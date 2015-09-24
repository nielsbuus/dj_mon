module DjMon
  module Backend
    module Mongoid
      class << self
        def all
          Delayed::Job.all
        end

        def failed
          Delayed::Job.where(:failed_at.ne => nil)
        end

        def active
          Delayed::Job.where(:failed_at => nil, :locked_by.ne => nil)
        end

        def queued
          Delayed::Job.where(:failed_at => nil, :locked_by => nil)
        end

        def destroy id
          dj = Delayed::Job.find(id)
          dj.destroy if dj
        end

        def retry id
          Delayed::Job.find(id).try do |job|
            job.update_attributes(attempts: 0, run_at: 5.seconds.ago, failed_at: nil)
          end
        end

        def reset_all
          Delayed::Job.update_all(attempts: 0, run_at: 5.seconds.ago, failed_at: nil)
        end

      end
    end
  end
end

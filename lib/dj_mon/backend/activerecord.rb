module DjMon
  module Backend
    module ActiveRecord
      PER_PAGE = 50

      class << self
        def all page = nil
          paginate Delayed::Job.all, page
        end

        def failed page = nil
          paginate Delayed::Job.where('failed_at IS NOT NULL'), page
        end

        def active page = nil
          paginate Delayed::Job.where('failed_at IS NULL AND locked_by IS NOT NULL'), page
        end

        def queued page = nil
          paginate Delayed::Job.where('failed_at IS NULL AND locked_by IS NULL'), page
        end

        def paginate scope, page
          return scope if page.nil?
          scope.offset(PER_PAGE * (page-1)).limit(PER_PAGE)
        end

        def destroy id
          Delayed::Job.find(id).try(:destroy)
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

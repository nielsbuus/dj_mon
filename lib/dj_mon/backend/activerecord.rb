module DjMon
  module Backend
    module ActiveRecord
      class << self
        def all page = nil, per_page = 50
          paginate Delayed::Job.all, page, per_page
        end

        def failed page = nil, per_page = 50
          paginate Delayed::Job.where('failed_at IS NOT NULL'), page, per_page
        end

        def active page = nil, per_page = 50
          paginate Delayed::Job.where('failed_at IS NULL AND locked_by IS NOT NULL'), page, per_page
        end

        def queued page = nil, per_page = 50
          paginate Delayed::Job.where('failed_at IS NULL AND locked_by IS NULL'), page, per_page
        end

        def paginate scope, page, per_page
          return scope if page.nil?
          scope.offset(per_page * (page-1)).limit(per_page)
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

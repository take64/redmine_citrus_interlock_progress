module RedmineCitrusInterlockProgress
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :done_ratio, :interlock_progress
        alias_method_chain :update_done_ratio_from_issue_status, :interlock_progress
        alias_method_chain :recalculate_attributes_for, :interlock_progress
      end

    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def done_ratio_with_interlock_progress
        unless Project.find(self.project_id).enabled_module_names.include?("citrus_interlock_progress")
          return done_ratio_without_interlock_progress
        end
        if Issue.use_status_for_done_ratio? && status && status.default_done_ratio && !self.children?
          status.default_done_ratio
        else
          read_attribute(:done_ratio)
        end
      end

      def update_done_ratio_from_issue_status_with_interlock_progress
        unless Project.find(self.project_id).enabled_module_names.include?("citrus_interlock_progress")
          return update_done_ratio_from_issue_status_without_interlock_progress
        end
        if Issue.use_status_for_done_ratio? && status && status.default_done_ratio && !self.children?
          self.done_ratio = status.default_done_ratio
        end
      end

      def recalculate_attributes_for_with_interlock_progress(issue_id)
        unless Project.find(self.project_id).enabled_module_names.include?("citrus_interlock_progress")
          return recalculate_attributes_for_without_interlock_progress(issue_id)
        end
        if issue_id && p = Issue.find_by_id(issue_id)
          if p.priority_derived?
            if priority_position = p.children.open.joins(:priority).maximum("#{IssuePriority.table_name}.position")
              p.priority = IssuePriority.find_by_position(priority_position)
            elsif default_priority = IssuePriority.default
              p.priority = default_priority
            end
          end

          if p.dates_derived?
            p.start_date = p.children.minimum(:start_date)
            p.due_date = p.children.maximum(:due_date)
            if p.start_date && p.due_date && p.due_date < p.start_date
              p.start_date, p.due_date = p.due_date, p.start_date
            end
          end

          if p.done_ratio_derived?
            # done ratio = weighted average ratio of leaves
            unless Issue.use_status_for_done_ratio? && p.status && p.status.default_done_ratio && !p.children?
              child_count = p.children.count
              if child_count > 0
                average = p.children.where("estimated_hours > 0").average(:estimated_hours).to_f
                if average == 0
                  average = 1
                end
                done = p.children.joins(:status).
                  sum("COALESCE(CASE WHEN estimated_hours > 0 THEN estimated_hours ELSE NULL END, #{average}) " +
                      "* (CASE WHEN is_closed = #{self.class.connection.quoted_true} THEN 100 ELSE COALESCE(done_ratio, 0) END)").to_f
                progress = done / (average * child_count)
                p.done_ratio = progress.round
              end
            end
          end

          p.save(:validate => false)
        end
      end
    end    
  end
end
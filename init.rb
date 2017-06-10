require 'redmine'

include RedmineCitrusInterlockProgress

#ActionDispatch::Callbacks.to_prepare do
#  require_dependency 'issue'
#  unless Issue.included_modules.include? RedmineCitrusInterlockProgress::IssuePatch
#    Issue.send(:include, RedmineCitrusInterlockProgress::IssuePatch)
#  end
#end

Redmine::Plugin.register :redmine_citrus_interlock_progress do
  name 'Redmine Citrus Interlock Progress plugin'
  author 'take64'
  description 'This is a plugin for Redmine'
  version '0.0.0.1'
  url 'http://github.com/take64'
  author_url 'http://besidesplus.net/'
  project_module :citrus_interlock_progress do
    permission :enable_interlock_progress, :interlock => :index
  end
  Rails.configuration.to_prepare do
    require_dependency 'issue'
    unless Issue.included_modules.include? RedmineCitrusInterlockProgress::IssuePatch
      Issue.send(:include, RedmineCitrusInterlockProgress::IssuePatch)
    end
  end
end
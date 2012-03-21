app = node.run_state[:fanfare_apps].detect{|app| app["name"] == "gitlab"}

deploy_revision app["deploy_to"] do
  repo app["deploy"]["repo"]
  revision app["deploy"]["revision"] || "HEAD" 
  user app["user"]
  enable_submodules true 
  
  before_restart do
    current_release_directory = release_path
    running_deploy_user = new_resource.user
    bundler_depot = new_resource.shared_path + '/bundle'
    excluded_groups = %w(development test)

    rbenv_script 'Bundling the gems' do
      #interpreter 'bash'
      cwd current_release_directory
      user running_deploy_user
      code <<-EOS
        bundle install --quiet --deployment --path #{bundler_depot} \
          --without #{excluded_groups.join(' ')}
      EOS
    end
  end
  #migrate true
  #migration_command "rake db:migrate"
  environment app["env"]
  shallow_clone true
  action (app["deploy"]["action"].nil?) ? :deploy : app["deploy"]["action"].to_sym
#  restart_command "touch tmp/restart.txt"
#  git_ssh_wrapper "wrap-ssh4git.sh"
end


# rvm_shell "run bundler" do
#   # ruby_string "1.9.2"
#   # user        "git"
#   # group       "git"
#   cwd         File.join(app["deploy_to"],current)
#   code        %{bundle}
# end
# 
# rvm_shell "set up database" do
#   cwd node[:gitlab][:path]
#   code %{RAILS_ENV=production rake db:setup; RAILS_ENV=production rake db:seed_fu}
#   creates "#{node[:gitlab][:path]}/db/production.sqlite3"
# end
#  

#should be linked from share
template "#{app["deploy_to"]}/current/config/gitlab.yml" do
  source "gitlab.yml.erb"
  variables(
    :host => node[:gitlab][:hostname]
  )
  action :create
  owner app["user"]
end
# 
# bash "update /etc/hosts" do
#   code "echo 127.0.0.1 #{node[:gitlab][:hostname]} >> /etc/hosts"
#   not_if "grep #{node[:gitlab][:hostname]} /etc/hosts"
# end   
# 
execute "generate ssh keys for #{app["user"]}." do
  user app["user"]
  creates "/home/#{app["user"]}/.ssh/id_rsa.pub"
  command "ssh-keygen -t rsa -q -f /home/#{app["user"]}/.ssh/id_rsa -P \"\""
end  

execute "fuck you" do
  command "rm /tmp/gitolite-admin.pub"
end

execute "copy gitlab admin ssh key #{app["user"]}" do
  user app["user"]
  creates "/tmp/gitolite-admin.pub"
  command "cp /home/#{app["user"]}/.ssh/id_rsa.pub /tmp/gitolite-admin.pub"
end  

template "/home/#{app["user"]}/.ssh/config" do
  source "ssh_config.erb"
  owner app["user"]
  group app["user"]
  mode "0600"
  variables(
    :hostname => node[:gitlab][:hostname]
  )
  action :create
end

# Installing gitolite in git
execute "install_gitolite_gitlab_admin_user" do
    user node[:gitolite][:username]
    command "/usr/local/bin/gl-setup /tmp/gitolite-admin.pub"
    environment ({'HOME' => "/home/#{node[:gitolite][:username]}"})   
    not_if %Q{admin_key=$(cat /tmp/gitolite-admin.pub); grep "$admin_key" /home/#{node[:gitolite][:username]}/.ssh/authorized_keys }
end                                 
                                      
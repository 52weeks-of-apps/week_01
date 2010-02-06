#
# Cookbook Name:: scribble_mail
# Recipe:: default
#
# Copyright 2009, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"
include_recipe "rails"
include_recipe "passenger_apache2::mod_rails"

web_app "week_01" do
  cookbook "passenger_apache2"
  docroot "/srv/week_01/current/public"
  server_name "week01.52weeksofapps.com"
  server_aliases ["week01"]
  rails_env "production"
end

node[:applications].each_pair do |app, data|
  next unless data[:run_deploy]

  user data[:user] do
    comment  "Deploy user for #{app}"
    gid      "users"
    password "4E322ddW"
    shell    "/bin/bash"
    home     "/home/deploy"
    supports :manage_home => true
    action   :create
  end

  directory "/home/#{data[:user]}/.ssh" do
    owner  data[:user]
    mode   "0700"
    action :create
  end

  template "/home/#{data[:user]}/.ssh/id_rsa" do
    source "#{data[:user]}.id_rsa.erb"
    owner  data[:user]
    mode   "0600"
    action :create
  end

  template "/home/#{data[:user]}/.ssh/known_hosts" do
    source "known_hosts.erb"
    owner  data[:user]
    mode   "0644"
    action :create
  end

  directory "/srv/scribble_mail" do
    owner "deploy"
    group "users"
    mode "0755"
    action :create
  end

  deploy "/srv/scribble_mail" do
    repo              data[:repository_name]
    revision          data[:revision]
    user              data[:user]
    migrate           data[:run_migrations]
    migration_command data[:migration_command]
    environment       "RAILS_ENV" => data[:framework_env]
    action            data[:deploy_action]
    restart_command   "touch tmp/restart.txt"
    shallow_clone     true

    before_migrate do
      directory "/srv/scribble_mail/shared/config" do
        owner "deploy"
        group "users"
        mode "0755"
        action :create
      end

      directory "/srv/scribble_mail/shared/log" do
        owner "deploy"
        group "users"
        mode "0755"
        action :create
      end

      template "/srv/scribble_mail/shared/config/database.yml" do
        source    "scribble_mail.database.yml.erb"
        variables :password => node[:mysql][:server_root_password]
        owner     data[:user]
        mode      "0644"
        action    :create
      end

      template "/srv/scribble_mail/shared/cached-copy/config/database.yml" do
        source    "scribble_mail.database.yml.erb"
        variables :password => node[:mysql][:server_root_password]
        owner     data[:user]
        mode      "0644"
        action    :create
      end

      execute "create-database" do
        command "cd /srv/scribble_mail/shared/cached-copy/config; rake db:create RAILS_ENV=#{data[:framework_env]}"
      end
    end
  end
end

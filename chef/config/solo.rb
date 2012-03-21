current_dir = File.dirname(__FILE__)

file_cache_path "#{current_dir}/../tmp"
cookbook_path ["#{current_dir}/../cookbooks"]
role_path "#{current_dir}/../roles"
log_level :info

data_bag_path "#{current_dir}/../data_bags"


http_proxy nil
http_proxy_user nil
http_proxy_pass nil
https_proxy nil
https_proxy_user nil
https_proxy_pass nil
no_proxy nil
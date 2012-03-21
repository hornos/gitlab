name "gitlab"
description "GitLab Web App"

run_list(
  "recipe[base_packages]",
#  "recipe[vagrant]",
  "recipe[pygments]",
  "recipe[gitolite::source]", 
#  "recipe[vagrant::gitolite]",
  "recipe[redis::install_from_release]",
  "recipe[redis::server]",
  "recipe[gitlab]"
#  "recipe[gitlab::nginx]"
)  

override_attributes(
  :redis => { 
    :version => "2.4.8"
  },
  :gitolite => {
    :umask => "0007"
  },
  :gitlab => {
    :hostname => "gitlab.local"
  }
  
)

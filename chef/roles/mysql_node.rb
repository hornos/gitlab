name "mysql_node"
description "A MySQL node in a cluster."

run_list(
  "recipe[mysql::server]",
  "recipe[fanfare::databases]"
)    

override_attributes(
  :mysql => { 
    :server_debian_password => "08team-server!15",
    :server_root_password => "08team-server!15",
    :server_repl_password => "08team-server!15" 
  }
)

name "app_node"
description "An application node in a cluster."

run_list(
  "recipe[nginx]",
  "recipe[ruby_build]",
  "recipe[rbenv::user]",
  "recipe[fanfare::applications]"   
)  

override_attributes(

  { :rbenv => 
    {
      :rubies => ['1.9.2-p318'], 
      :global  => '1.9.2-p318',
      :gems    => 
      {
        '1.9.2-p318'    => [
          { 'name'    => 'chef' }
        ]
      },
      :user_installs => 
      [
        { 
          :user    => 'gitlab',
          :rubies  => ['1.9.2-p318'],
          :global  => '1.9.2-p318',
          :gems    => 
          {
            '1.9.2-p318'    => [
              { 'name'    => 'bundler' }
            ]
          }
        }, 
        { 
          :user    => 'redmine',
          :rubies  => ['ree-1.8.7-2012.02'],
          :global   => 'ree-1.8.7-2012.02',
          :gems    => 
          {
            'ree-1.8.7-2012.02'    => [
              { 'name'    => 'mysql'},
              { 'name' => 'rake',
                'version' => '0.8.7'},
              { 'name' => "rack",
                'version' => '1.1.3'}
            ]
          }
        } 
      ]
    }
  }
)
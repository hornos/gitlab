group "git" do
  members [node[:gitolite][:groupname],node[:gitlab][:user]]
  append true
end
# Skype Install

execute "yum groupinstall Desktop" do
  command "yum groupinstall -y Desktop"
end

execute "yum update" do
  command "yum update -y"
end

%w(qtwebkit webkitgtk glibc alsa-lib libXv libXScrnSaver qt gtk2-engines PackageKit-gtk-module libcanberra libcanberra-gtk2).each do |pkg|
  yum_package pkg do
    action :install
    arch "i686"
  end
end

bash "installing skype" do
  flags "-ex"
  code <<-EOH
cd /tmp
wget http://download.skype.com/linux/skype-4.2.0.11.tar.bz2
cd /opt
tar xjvf /tmp/skype-4.2.0.11.tar.bz2
rm /tmp/skype-4.2.0.11.tar.bz2
ln -s skype-4.2.0.11 skype
ln -s /opt/skype /usr/share/skype
ln -s /opt/skype/skype /usr/bin/skype
EOH
  creates '/opt/skype-4.2.0.11'
end

# Skype Background Service
service "iptables" do
  action [:stop, :disable]
end

%w(xorg-x11-xauth xorg-x11-server-Xvfb).each do |pkg|
  package pkg do
    action :install
  end
end

user "skype" do
  password "$1$PpBY5Zo8$FEFVHnNS7AUWK64Bf2QZ7."
end

sudo "skype" do
  template "sudo_skype.erb"
end

%w(/var/db/skype /var/run/skype /var/log/skype).each do |dir|
  directory dir do
    action :create
    owner "skype"
    group "skype"
  end
end

template "/etc/init.d/skype" do
  source "etc/init.d/skype"
  mode 0755

  variables({
    :user     => node[:skype][:user],
    :password => node[:skype][:password] 
  })
end

%w(x11vnc ipa-gothic-fonts).each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/home/vagrant/init_x11vnc" do
  source "init_x11vnc"
  user "vagrant"
  group "vagrant"
  mode 0755
end

cookbook_file "/home/vagrant/run_x11vnc" do
  source "run_x11vnc"
  user "vagrant"
  group "vagrant"
  mode 0755
end

# Skype4Py
%w(python-setuptools dbus-python pygobject2 dbus-x11).each do |pkg|
  package pkg do
    action :install
  end
end

service "messagebus" do
  action :start
end

bash "easy_install Skype4Py" do
  flags "-ex"
  code <<-EOH
easy_install Skype4Py
EOH
end

# nodejs

%w(nodejs npm).each do |pkg|
  package pkg do
    action :install
  end
end

execute "install hubot" do
  command "npm install -g -y hubot coffee-script"
end

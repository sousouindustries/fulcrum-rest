# vim: noexpandtab:syntax=make
CWD	=$(shell pwd)


default:


install-development-deps:
	apt-get install ansible


install-vm-deps:
	apt-get install -y python3-pip debhelper devscripts reprepro nginx libpq-dev libyaml-dev
	pip3 install -r requirements.txt


links:
	cd src/python-stomp; $(MAKE) links
	cd src/python-s42; $(MAKE) links
	cd src/python-es; $(MAKE) links
	cd src/python-eda; $(MAKE) links
	cd src/python-libsousou; $(MAKE) links
	cd src/python-libsovereign; $(MAKE) links



devenv:
	make install-vm-deps
	rm -f $(CWD)/src/*.deb
	rm -f /etc/nginx/sites-enabled/default
	apt-get autoremove -y sovereign* || echo "No sovereign packages installed."
	apt-get autoremove -y fulcrum* || echo "No fulcrum packages installed."
	apt-get autoremove -y aorta* || echo "No aorta packages installed."
	cd $(CWD)/src/sovereign-infra-common; make devpackage
	cd $(CWD)/src/aorta-server; make devpackage
	cd $(CWD)/src/fulcrum-common; make devpackage
	cd $(CWD)/src/fulcrum-mds; make devpackage
	make links
	@echo "Installing Reprepro"
	rm -rf /etc/nginx/sites-enabled/default
	rm -rf /var/repositories;\
		mkdir -p /var/repositories/conf -p;\
		cd /var/repositories/conf; touch options;\
		cp /vagrant/conf/reprepro/distributions .;\
		cp /vagrant/conf/nginx/reprepro /etc/nginx/sites-enabled;\
		echo "deb [arch=amd64] file:///var/repositories trusty main" > /etc/apt/sources.list.d/apt_devenv.list;
	reprepro -b /var/repositories includedeb trusty /vagrant/src/*.deb
	cp $(CWD)/conf/vim/vim.conf /home/vagrant/.vimrc; chown vagrant:vagrant /home/vagrant/.vimrc
	@echo "Cleanup"
	rm -f $(CWD)/src/*.deb
	rm -f $(CWD)/src/*.dsc
	rm -f $(CWD)/src/*.changes
	service nginx start
	service nginx reload
	@apt-get clean
	@apt-get update > /dev/null
	apt-get install -y --allow-unauthenticated\
		sovereign-infra-common
	@apt-get update > /dev/null
	apt-get install -y --allow-unauthenticated\
		aorta-server fulcrum-mds
	sudo -u postgres createuser --superuser vagrant

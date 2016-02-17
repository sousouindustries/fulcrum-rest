# vim: noexpandtab:syntax=make
CWD	=$(shell pwd)
LSB=trusty
SI_KEY="FAC3ACCD"

default:


platform:
	rm -f /etc/apt/sources.list.d/apt_devenv.list
	rm -f /etc/apt/sources.list.d/apt_sousouindustries.list
	apt-add-repository -y ppa:qpid/released
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(LSB)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	sudo sh -c 'echo "deb [arch=amd64] http://apt.sousouindustries.com $(LSB) main" > /etc/apt/sources.list.d/apt_sousouindustries.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	gpg --keyserver keyserver.ubuntu.com --recv $(SI_KEY)
	gpg --export --armor $(SI_KEY) | sudo apt-key add -
	apt-get install -y python-pip python3-pip python-dev python3-dev
	apt-get update


reprepro:
	@echo "Installing Reprepro"
	@sudo apt-get install -y reprepro
	rm -rf /var/repositories &&\
		mkdir -p /var/repositories/conf -p &&\
		cd /var/repositories/conf; touch options &&\
		cp /vagrant/conf/reprepro/distributions . &&\
		echo "deb [arch=amd64] file:///var/repositories trusty main" > /etc/apt/sources.list.d/apt_devenv.list;


# Creates the build dependencies
build-deps:
	apt-get install -y debhelper devscripts dh-make git


packages:
	make build-deps
	make reprepro
	cd $(CWD)/src/aorta-server; make devpackage
	cd $(CWD)/src/fulcrum-common; make devpackage
	cd $(CWD)/src/fulcrum-mds; make devpackage
	cd $(CWD)/src/python-es; make devpackage
	reprepro -b /var/repositories includedeb trusty /vagrant/src/*.deb
	rm -f $(CWD)/src/*.deb
	rm -f $(CWD)/src/*.dsc
	rm -f $(CWD)/src/*.changes
	sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/apt_devenv.list" \
	    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"


links:
	apt-get install python3-pip
	pip3 install -r requirements.txt
	cd src/python-es; $(MAKE) links
	cd src/python-eda; $(MAKE) links


environment:
	sudo -u vagrant cp $(CWD)/conf/vim/vim.conf /home/vagrant/.vimrc
	make platform
	make packages
	make infrastructure


infrastructure:
	apt-get install -y --allow-unauthenticated\
		fulcrum-mds\
		aorta-server


docs-server:
	apt-get install -y nginx
	rm -rf /etc/nginx/sites-enabled/default
	cp $(CWD)/conf/nginx/reprepro /etc/nginx/sites-enabled/
	service nginx reload
	pip install alabaster sphinx_rtd_theme --upgrade


# Obs
install-development-deps:
	apt-get install ansible


install-vm-deps:
	apt-get install -y python3-pip debhelper devscripts reprepro nginx libpq-dev libyaml-dev
	pip3 install -r requirements.txt

install-platform-deps:
	#cd /tmp; rm *.deb; wget http://nl.archive.ubuntu.com/ubuntu/pool/main/a/alembic/python3-alembic_0.8.2-2ubuntu2_all.deb; dpkg -i *.deb


links1:
	#apt-get install python3-pip
	#pip3 install -r requirements.txt
	#cd src/python-stomp; $(MAKE) links
	#cd src/python-s42; $(MAKE) links
	#cd src/python-es; $(MAKE) links
	#cd src/python-eda; $(MAKE) links
	#cd src/python-libsousou; $(MAKE) links
	#cd src/python-libsovereign; $(MAKE) links


devenv:
	sudo -u vagrant cp $(CWD)/conf/vim/vim.conf /home/vagrant/.vimrc
	make links
	make platform
	make build-deps
	make reprepro
	make purge
	make devpackages
	apt-get install -y --allow-unauthenticated\
		aorta-server\
		fulcrum-mds


purge:
	@apt-get -qq remove -y fulcrum* --purge 2>/dev/null || echo "No Fulcrum packages installed."
	@apt-get -qq remove -y aorta* --purge 2>/dev/null || echo "No Fulcrum packages installed."


devpackages:

obs:
	make install-vm-deps
	rm -f $(CWD)/src/*.deb
	rm -f /etc/nginx/sites-enabled/default
	apt-get autoremove -y sovereign* || echo "No sovereign packages installed."
	apt-get autoremove -y fulcrum* || echo "No fulcrum packages installed."
	apt-get autoremove -y aorta* || echo "No aorta packages installed."
	make links
	reprepro -b /var/repositories includedeb trusty /vagrant/src/*.deb
	cp $(CWD)/conf/vim/vim.conf /home/vagrant/.vimrc; chown vagrant:vagrant /home/vagrant/.vimrc
	@echo "Cleanup"
	service nginx start
	service nginx reload
	@apt-get clean
	@apt-get update > /dev/null
	apt-get install -y --allow-unauthenticated\
		sovereign-infra-common
	@apt-get update > /dev/null
	apt-get install -y --allow-unauthenticated\
		aorta-server fulcrum-mds fulcrum-rest
	sudo -u postgres createuser --superuser vagrant

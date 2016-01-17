# vim: noexpandtab:syntax=make
CWD	=$(shell pwd)


default:


install-development-deps:
	apt-get install ansible


install-vm-deps:
	apt-get install -y python3-pip
	pip3 install -r requirements.txt


links:
	cd src/python-stomp; $(MAKE) links
	cd src/python-s42; $(MAKE) links
	cd src/python-es; $(MAKE) links
	cd src/python-eda; $(MAKE) links
	cd src/python-libsousou; $(MAKE) links
	cd src/python-libsovereign; $(MAKE) links

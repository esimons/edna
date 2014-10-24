app_dir = /home/ep/buzz/edna
deployment_hostname = ep@eae-buzzdev801.epnet.com
buildRev = ''

clean :
	ssh $(deployment_hostname) cd $(app_dir)\; sudo /etc/init.d/node-edna stop > /dev/null 2>&1
	ssh $(deployment_hostname) cd $(app_dir)\; rm -f $(app_dir)/app.pid
	# Get rid of old installs
	ssh $(deployment_hostname) sudo rm -rf $(app_dir)
	ssh $(deployment_hostname) mkdir -p $(app_dir)

build :
	# run the build locally
	npm install --unsafe-perm

deploy :
	make clean

	make build

	# Copy files over to remote machine
	scp -r ./ $(deployment_hostname):$(app_dir)

	# start the app
	ssh $(deployment_hostname) cd $(app_dir)\; make start_app

start_app :
	sudo /etc/init.d/node-edna start

# gravitee-docker-demo

Checkout the files from following github location. 

https://github.com/Logicoy/gravitee-docker-demo

git clone https://github.com/Logicoy/gravitee-docker-demo

File stucture  and detail

gravitee-docker-demo [Root folder]

--launch.sh [Launcher shell script, That will call the docker compose commands to start the mongodb, gravitee and web ui container]

--mongodb
	
	--docker-compose.yml [Docker compose script to start the mongodb container, Exposes port 27017]

--docker-compose.yml [Docker compose script to start the gravitee gateway and management API container, Expose port 8082 and 8083 respectively]
  
--gravitee-web-ui
	
	--docker-compose.yml [Docker compose script to start the UI application inside apache httpd server, Application port : 8080]


Running the Demo : 

$ cd gravitee-docker-demo

gravitee-docker-demo$ ./launch.sh

o/p will be something like below in your screen

gravitee-docker-demo$ ./launch.sh 
  _         ____   _____  _____  ______   ____ 	 
 | |      / ____ \/ ____ |_   _|/ _____ / ___  \ \ \    / / 
 | |      | |  | || |  __| | |  | |    | |    | | \ \  / / 
 | |      | |  | || | |_ | | |  | |    | |    | |  \_ / /	
 | |_____ | |__| || |__| |_| |_ | |____| |____| |    / / 	
 |_______|\ ___  /\_____||_____|\______ \ ____ /    / / 	
     | |                                              http://www.logicoy.com/gravitee.io
   __|_|_ _____       __      _______ _______ ______ ______   _____ ____   
  / ____|  __ \     /\ \    / /_   _|__   __|  ____|  ____| |_   _/ __ \  
 | |  __| |__) |   /  \ \  / /  | |    | |  | |__  | |__      | || |  | | 
 | | |_ |  _  /   / /\ \ \/ /   | |    | |  |  __| |  __|     | || |  | | 
 | |__| | | \ \  / ____ \  /   _| |_   | |  | |____| |____ _ _| || |__| | 
  \_____|_|  \_\/_/    \_\/   |_____|  |_|  |______|______(_)_____\____/  
     | |                                              http://gravitee.io
   __| | ___ _ __ ___   ___                                               
  / _` |/ _ \ '_ ` _ \ / _ \                                              
 | (_| |  __/ | | | | | (_) |                                             
  \__,_|\___|_| |_| |_|\___/                                              

Docker Gateway address found as :  172.17.0.1
Modifying the docker compose yml file to default IP as Docker gateway IP.. 
Init directories in /home/param/graviteeio-demo ...
Launch GraviteeIO demo ...
Waiting for mongodb container to start.. [wait time depends on mongodb container startup time!]
Pulling mongodb (logicoyinc/mongodb:v1)...



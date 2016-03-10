#!/bin/bash
#-------------------------------------------------------------------------------
# Copyright (C) 2015 The Gravitee team (http://gravitee.io)
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#            http://www.apache.org/licenses/LICENSE-2.0
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#-------------------------------------------------------------------------------

readonly WORKDIR="$HOME/graviteeio-demo"
readonly DIRNAME=`dirname $0`
readonly PROGNAME=`basename $0`
readonly color_title='\033[33m'
readonly color_text='\033[1;36m'

# OS specific support (must be 'true' or 'false').
declare cygwin=false
declare darwin=false
declare linux=false
declare dc_exec="docker-compose up"

welcome() {

    echo -e " ${color_title} _         ____   _____  _____  ______   ____ 	 \033[0m"
    echo -e " ${color_title}| |      / ____ \/ ____ |_   _|/ _____ / ___  \ \ \    / / \033[0m"  
    echo -e " ${color_title}| |      | |  | || |  __| | |  | |    | |    | | \ \  / / \033[0m"
    echo -e " ${color_title}| |      | |  | || | |_ | | |  | |    | |    | |  \_ / /	\033[0m"
    echo -e " ${color_title}| |_____ | |__| || |__| |_| |_ | |____| |____| |    / / 	\033[0m"
    echo -e " ${color_title}|_______|\ ___  /\_____||_____|\______ \ ____ /    / / 	\033[0m"
    echo -e " ${color_title}    | |                                              \033[0m${color_text}http://www.logicoy.com/gravitee.io\033[0m"
    echo -e " ${color_title}  __|_|_ _____       __      _______ _______ ______ ______   _____ ____   \033[0m"
    echo -e " ${color_title} / ____|  __ \     /\ \    / /_   _|__   __|  ____|  ____| |_   _/ __ \  \033[0m"
    echo -e " ${color_title}| |  __| |__) |   /  \ \  / /  | |    | |  | |__  | |__      | || |  | | \033[0m"
    echo -e " ${color_title}| | |_ |  _  /   / /\ \ \/ /   | |    | |  |  __| |  __|     | || |  | | \033[0m"
    echo -e " ${color_title}| |__| | | \ \  / ____ \  /   _| |_   | |  | |____| |____ _ _| || |__| | \033[0m"
    echo -e " ${color_title} \_____|_|  \_\/_/    \_\/   |_____|  |_|  |______|______(_)_____\____/  \033[0m"
    echo -e " ${color_title}    | |                                              \033[0m${color_text}http://gravitee.io\033[0m"
    echo -e " ${color_title}  __| | ___ _ __ ___   ___                                               \033[0m"
    echo -e " ${color_title} / _\` |/ _ \ '_ \` _ \ / _ \                                              \033[0m"
    echo -e " ${color_title}| (_| |  __/ | | | | | (_) |                                             \033[0m"
    echo -e " ${color_title} \__,_|\___|_| |_| |_|\___/                                              \033[0m"
    echo
}

init_env() {
    local dockergrp
    # define env
    case "`uname`" in
        CYGWIN*)
            cygwin=true
            ;;

        Darwin*)
            darwin=true
            ;;

        Linux)
            linux=true
            ;;
    esac

    # test if docker must be run with sudo
    dockergrp=$(groups | grep -c docker)
    if [[ $darwin == false && $dockergrp == 0 ]]; then
        dc_exec="sudo $dc_exec";
    fi
}

init_dirs() {
    echo "Init directories in $WORKDIR ..."
    mkdir -p $WORKDIR/logs/{mongodb,kibana3,elasticsearch,gateway,management-ui,management-api}
    echo 
}

init_darwin() {
    boot2docker up  | grep 'export' | while read line ; do eval "$line"  ; done 
}

main() {
    
    welcome
    init_env
    IPNAME=`ifconfig docker | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'` 
    echo "Docker Gateway address found as : " $IPNAME
    echo "Modifying the docker compose yml file to default IP as Docker gateway IP.. "
    sed -i -e "s/DOCKER_IP_ADDRESS/$IPNAME/g" docker-compose.yml
    sed -i -e "s/DOCKER_IP_ADDRESS/$IPNAME/g" mongodb/docker-compose.yml
    sed -i -e "s/DOCKER_IP_ADDRESS/$IPNAME/g" gravitee-web-ui/docker-compose.yml

    if [[ $? != 0 ]]; then
        exit 1
    fi
    set -e
    init_dirs
    if [[ $darwin == true ]]; then
        init_darwin
    fi
    
    echo "Launch GraviteeIO demo ..."
    cd mongodb
    $dc_exec &

    echo "Waiting for mongodb container to start.. [wait time depends on mongodb container startup time!]" 
    
    REMOTEHOST=$IPNAME
    REMOTEPORT=27017
    TIMEOUT=1

    con=0
    while [ $con -le 5 ]
    do
      if nc -w $TIMEOUT -z $REMOTEHOST $REMOTEPORT; then
         echo "Mongodb process is started and port is ready to get connections connect to ${REMOTEHOST}:${REMOTEPORT} .. success"
         con=6
      else
         
         con=0
      fi
     sleep 1
    done

    cd ..
    $dc_exec &

    REMOTEHOST_M=$IPNAME
    REMOTEPORT_M=8083
    TIMEOUT=1

    con=0
    while [ $con -le 5 ]
    do
      if nc -w $TIMEOUT -z $REMOTEHOST_M $REMOTEPORT_M; then
         echo "Management api Gravitee service is started and port is ready to serve request rest connect to ${REMOTEHOST_M}:${REMOTEPORT_M} .. success"
         con=6
      else         
         con=0
      fi
     sleep 1
    done

    REMOTEHOST_S=$IPNAME
    REMOTEPORT_S=8082
    TIMEOUT=1

    con=0
    while [ $con -le 5 ]
    do
      if nc -w $TIMEOUT -z $REMOTEHOST_S $REMOTEPORT_S; then
         echo "Management standalone Gravitee service is started and port is ready to serve request test connect to ${REMOTEHOST_S}:${REMOTEPORT_S} .. success"
         con=6
      else         
         con=0
      fi
     sleep 1
    done

    sudo docker run --name my_webui_6 -e MGMT_API_HOST=172.17.0.1 -p 172.17.0.1:8080:80 -i -t logicoyinc/gravitee-management-web-ui:v1  /bin/bash
    

    popd > /dev/null
}

main

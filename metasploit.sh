#!/usr/bin/env bash

green="\033[0;32m"
red="\033[0;31m"
cyan="\033[0;36m"
nc="\033[0m"
blue="\033[1;34m"
yellow="\033[1;33m"
lightPurple='\033[1;35m'

echo -e "${lightPurple}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~~~~~Metasploit Framework~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ${nc}"

runningDistro=${1}
isTest=${2}

which -a msfconsole
if [ $? -eq 1 ] #returns 0 if psql is installed.
then
    echo -e "${red}Metasploit Framework is not installed${nc}
    Do you want this script to install the Metasploit framework?
    ${red}Caution: ${nc} This scripts and any other script won't work without Metasploit framework. ${nc}"
    sleep 3s # wait before doing.

    ### Test case for Metasploit Installation (in Silent Mode too)
    if [ ${isTest} == 'true' ];then
        echo -e "${blue} Installing Metasploit framework from ${yellow}'https://github.com/rapid7/metasploit-framework/wiki/Nightly-Installers'
        ${blue}Script invocation will import the Rapid7 signing key and setup the package for all supported Linux and OS X systems
        ${nc}"
        sleep 5s #sleeping 5 seconds before installation begin.
        sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

        if [ $? -ne 0 ];then
            exit 255
        fi
    else
        read -n1 -p "Choose 1 if you want this script to install Metasploit or any key otherwise " user_choice
        echo ""
        if (($user_choice == 1));then
            echo -e "${blue} Installing Metasploit framework from ${yellow}'https://github.com/rapid7/metasploit-framework/wiki/Nightly-Installers'${nc}"
            echo "
            ${blue}The following script invocation will import the Rapid7 signing key and setup the package for all supported Linux and OS X systems
            ${nc}"
            sleep 5s #sleeping 5 seconds before installation begin.
            curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

            if [ $? -ne 0 ];then
                exit 255
            fi
        else
            echo "${blue} Good bye ${nc}"
            exit 255
        fi
    fi
fi

### This portion of code works if Metasploit is already installed or jst installed.
## if user choose to not install, then it will exit immediately using code 255.

echo -e "${green}Metasploit Framework is installed!${nc}"
sleep 2s # sleeping b4 doing bullshit.

echo -e "
    ${blue}1) Initialize the Database if it's not already initialized?
    ${yellow}2) Re-initialize the database it's already initialized?
    ${green}3) Database is configured correctly, Move on.
    ${red}4) Stop the script. I will deal with it. ${nc}
    "

### Test case for Metasploit Installation (in Silent Mode too)
if [ ${isTest} == 'true' ];then
    #reinit the db
    echo -e "${blue}Re-initializing the msf database${nc}"
    echo ""
    sleep 1s #wait 1 second

    if [ ${runningDistro} == 'Kali' ];then
        sudo msfdb reinit
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            exit 255
        fi
    else
#        sudo -u ${SUDO_USER} msfdb reinit
        sudo msfdb reinit
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            exit 255
        fi
    fi

    echo -e "${green}Metasploit framework database re-initialization complete ${nc}"
else
    read -n1 -p "Choose your option: " user_choice
    echo ""
    echo -e "${red}
        -------------------------------------------
        -------------------------------------------
        I want to clarify that whatever you choose
        might have irreversible affect on your machine.
        I hope you know what you are doing
        -------------------------------------------
        -------------------------------------------
        ${nc}"

    echo ""
    sleep 5s ## stooping script for 5 seconds.

    if (($user_choice == 1));then
        #init the db
        echo -e "${blue}Metasploit Framework db init${nc} needs to run as a ${blue}non-root user.${nc} You MAY need to provide your password... "
        echo ""
        sleep 1s #wait 1 second

        if [ ${runningDistro} == 'Kali' ];then
            echo ${runningDistro}
            msfdb init
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        else
            echo ${runningDistro}
            sudo -u ${SUDO_USER} msfdb init
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        fi

        echo -e "${green}Metasploit framework database initialization complete ${nc}"
    elif (($user_choice == 2));then
        #reinit the db
        echo -e "${blue}Re-initializing the msf database${nc}"
        echo ""
        sleep 1s #wait 1 second

        if [ ${runningDistro} == 'Kali' ];then
            msfdb reinit
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        else
            sudo -u ${SUDO_USER} msfdb reinit
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        fi

        echo -e "${green}Metasploit framework database re-initialization complete ${nc}"
    elif (($user_choice == 3));then
        #green
        echo -e "${green}Moving on${nc}"
    elif (($user_choice == 4));then
        echo -e "${red}Terminating the script!${nc}"
        sleep 2s
        ## Terminating command
        exit 255

    else
        # unknown command. stop script.
        echo -e "
        ${yellow}------------------------------------
        -${red}[Unknown option]${yellow}-------------------
        -${blue}This is important${yellow}------------------
        -${blue}Please choose carefully next time${yellow}--
        -${red}Terminating script......${yellow}-----------
        ------------------------------------${nc}
        "
        sleep 2s
        exit 255
    fi
fi

echo -e "${blue}Do you want to start the Metasploit Framework database? ${nc}"
echo ""

### Test case for Metasploit Installation (in Silent Mode too)
if [ ${isTest} == 'true' ];then
    echo -e "${blue}Starting msf database ${nc}"
    sleep 2s #sleep 2seconds before donning

    if [ ${runningDistro} == 'Kali' ];then
        sudo msfdb start
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            exit 255
        fi
    else
#        sudo -u ${SUDO_USER} msfdb start
        sudo msfdb start
        ## if the previous commit failed to run.
        if [ $? -ne 0 ];then
            exit 255
        fi
    fi
    echo -e "${green} -- Done"
else
    read -n1 -p "Choose your option y/n: " user_choice
    echo ""

    if [ "${user_choice}" == "y" ] || [ "${user_choice}" == "Y" ]; then
        echo -e "${blue}Starting msf database ${nc}"
        sleep 2s #sleep 2seconds before donning

        if [ ${runningDistro} == 'Kali' ];then
            msfdb start
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        else
            sudo -u ${SUDO_USER} msfdb start
            ## if the previous commit failed to run.
            if [ $? -ne 0 ];then
                exit 255
            fi
        fi
        echo -e "${green} -- Done"
    fi
fi

exit 0 ## total success
#!/bin/bash -eu

REPO=${REPO:-cimryan}
BRANCH=${BRANCH:-master}

export INSTALL_DIR=${INSTALL_DIR:-/root/bin}

function check_variable () {
    local var_name="$1"
    if [ -z "${!var_name+x}" ]
    then
        echo "STOP: Define the variable $var_name like this: export $var_name=value"
        exit 1
    fi
}

function get_script () {
    local local_path="$1"
    local name="$2"
    local remote_path="${3:-}"

    echo "Starting download for $local_path/$name"
    curl -o "$local_path/$name" https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/"$remote_path"/"$name"
    chmod +x "$local_path/$name"
    echo "Done"
}

function install_rc_local () {
    local install_home="$1"

    if grep -q archiveloop /etc/rc.local
    then
        echo "Skipping rc.local installation"
        return
    fi

    echo "Configuring /etc/rc.local to run the archive scripts at startup..."
    echo "#!/bin/bash -eu" > ~/rc.local
    echo "archiveserver=\"${archiveserver}\"" >> ~/rc.local
    echo "install_home=\"${install_home}\"" >> ~/rc.local
    cat << 'EOF' >> ~/rc.local
LOGFILE=/tmp/rc.local.log

function log () {
  echo "$( date )" >> "$LOGFILE"
  echo "$1" >> "$LOGFILE"
}

log "Launching archival script..."
"$install_home"/archiveloop "$archiveserver" &
log "All done"
exit 0
EOF

    cat ~/rc.local > /etc/rc.local
    rm ~/rc.local
    echo "Installed rc.local."
}

function check_archive_configs () {
    echo -n "Checking archive configs: "

    RSYNC_ENABLE="${RSYNC_ENABLE:-false}"
    RCLONE_ENABLE="${RCLONE_ENABLE:-false}"   
    if [ "$RSYNC_ENABLE" = true ] && [ "$RCLONE_ENABLE" = true ]
    then
        echo "STOP: Can't enable rsync and rclone at the same time"
        exit 1
    fi

    if [ "$RSYNC_ENABLE" = true ]
    then
        check_variable "RSYNC_USER"
        check_variable "RSYNC_SERVER"
        check_variable "RSYNC_PATH"
        export archiveserver="$RSYNC_SERVER"
        
    elif [ "$RCLONE_ENABLE" = true ]
    then
        check_variable "RCLONE_DRIVE"
        check_variable "RCLONE_PATH"
        export archiveserver="8.8.8.8" # since it's a cloud hosted drive we'll just set this to google dns
    else
        # default to cifs
        check_variable "sharename"
        check_variable "shareuser"
        check_variable "sharepassword"
        check_variable "archiveserver"
    fi

    echo "done"
}

function get_archive_module () {

    if [ "$RSYNC_ENABLE" = true ]
    then
        archive_module="run/rsync_archive"        
    elif [ "$RCLONE_ENABLE" = true ]
    then
        archive_module="run/rclone_archive"
    else
        archive_module="run/cifs_archive"
    fi

    echo $archive_module
}

function install_archive_scripts () {
    local install_path="$1"
    local archive_module="$2"

    echo "Installing base archive scripts into $install_path"
    get_script $install_path archiveloop run
    get_script $install_path remountfs_rw run
    get_script $install_path lookup-ip-address.sh run

    echo "Installing archive module scripts"
    get_script $install_path verify-archive-configuration.sh $archive_module
    get_script $install_path configure-archive.sh $archive_module
    get_script $install_path archive-clips.sh $archive_module
    get_script $install_path connect-archive.sh $archive_module
    get_script $install_path disconnect-archive.sh $archive_module
    get_script $install_path write-archive-configs-to.sh $archive_module
}


function check_pushover_configuration () {
    if [ ! -z "${pushover_enabled+x}" ]
    then
        if [ ! -n "${pushover_user_key+x}" ] || [ ! -n "${pushover_app_key+x}"  ]
        then
            echo "STOP: You're trying to setup Pushover but didn't provide your User and/or App key."
            echo "Define the variables like this:"
            echo "export pushover_user_key=put_your_userkey_here"
            echo "export pushover_app_key=put_your_appkey_here"
            exit 1
        elif [ "${pushover_user_key}" = "put_your_userkey_here" ] || [  "${pushover_app_key}" = "put_your_appkey_here" ]
        then
            echo "STOP: You're trying to setup Pushover, but didn't replace the default User and App key values."
            exit 1
        fi
    fi
}

function configure_pushover () {
    if [ ! -z "${pushover_enabled+x}" ]
    then
		echo "Enabling pushover"
		echo "export pushover_enabled=true" > /root/.teslaCamPushoverCredentials
		echo "export pushover_user_key=$pushover_user_key" >> /root/.teslaCamPushoverCredentials
		echo "export pushover_app_key=$pushover_app_key" >> /root/.teslaCamPushoverCredentials
    else
        echo "Pushover not configured."
    fi
}

function check_and_configure_pushover () {
    check_pushover_configuration
	
	configure_pushover
}

function install_pushover_scripts() {
    local install_path="$1"
    get_script $install_path send-pushover run
}

if ! [ $(id -u) = 0 ]
then
    echo "STOP: Run sudo -i."
    exit 1
fi

if [ ! -e "$INSTALL_DIR" ]
then
    mkdir "$INSTALL_DIR"
fi

echo "Getting files from $REPO:$BRANCH"

check_and_configure_pushover
install_pushover_scripts "$INSTALL_DIR"

check_archive_configs

archive_module="$( get_archive_module )"
echo "Using archive module: $archive_module"

install_archive_scripts $INSTALL_DIR $archive_module
"$INSTALL_DIR"/verify-archive-configuration.sh
"$INSTALL_DIR"/configure-archive.sh

install_rc_local "$INSTALL_DIR"




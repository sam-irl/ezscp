#!/usr/bin/env bash
#####################
# configuration     #
# loader            #
#####################
confFileLocation="/etc/ezscp/ezscp.conf"
sudo touch $confFileLocation
if [ $? -eq 0 ]
then
  source $confFileLocation
else
  echo "could not read configuration file, did you install from the script?"
  exit 1
fi
#####################
# update args check #
# will skip if not  #
# update.           #
#####################
if [[ $1 == "update" ]]
then
  if [[ $version == ${curl -sSL https://raw.githubusercontent.com/sam-irl/ezscp/master/version} ]]
  then
    echo "ezscp up-to-date"
    exit 0
  else
    read -p "Newer version available. Enter to update, CTRL-C to abort."
    curl -sSL https://raw.githubusercontent.com/sam-irl/ezscp/master/INSTALL.sh | sudo bash
    if [ $? -eq 0 ]
    then
      exit 0
    else
      echo "Update failed."
      exit 1
    fi
  fi
fi
# ezscp
echo "Hello, "$USER", and welcome to ez-scp."
echo "This provides a frontend to the scp command, more information can be found at its manual page."

echo "Please enter a hostname that your file to copy is on."
echo "Leave this blank if it is on your local machine."
echo "Hostname: "
read fileHostname

if [[ ! -z "${fileHostname// }" ]]
then
  echo "Please enter a user to copy the file from, on "$fileHostname": "
  read fileUser
  echo "Please enter a port to use for SSH. If blank, it defaults to 22: "
  read fileSshPort
  if [[ -z "${fileSshPort// }" ]]
  then
    fileSshPort="22"
  fi
  echo "Will connect to "$fileUser"@"$fileHostname", SSH via port "$fileSshPort""
  echo "Please CTRL-C and restart if this is incorrect."
fi

echo "Please enter a file to copy without hostnames: "
read fileToCopy

if [[ -z "$fileHostname" ]]
then
  touch $fileToCopy
  if [ $? -eq 0 ]
  then
    echo "Excellent, I found it."
    echo "We will copy file "$fileToCopy"."
  else
    echo "Sorry, I couldn't find the file to copy. Make sure you have permission to access it."
    exit 1
  fi
else
  echo "As the file is on a remote host, I can't verify it exists. If scp fails, this might be why."
  echo "We will attempt to copy file "$fileUser"@"$fileHostname":"$fileToCopy" using SSH port "$fileSshPort"."
fi

echo "Okay, now we need to copy the file somewhere."
echo "Please enter a hostname of the machine to copy TO."
echo "Leave blank for your local machine."
echo "Hostname: "
read destHostname

if [[ ! -z "${destHostname// }" ]]
then
  echo "Please enter a user to copy the file to, on "$destHostname": "
  read destUser
  echo "Please enter a port to use for SSH. Defaults to 22: "
  read destSshPort
  if [[ -z "${destSshPort// }" ]]
  then
    destSshPort="22"
  fi
  if [[ ! $fileSshPort == $destSshPort ]] && [[ ! $fileSshPort == "22" ]] && [[ ! $destSshPort == "22" ]]
  then
    echo "Only one port for SSH can be used, excluding 22. This is a problem with scp itself. Exiting."
    exit 1
  fi
  echo "Will copy to "$destUser"@"$destHostname", SSH via port "$destSshPort"."
  echo "Please CTRL-C and start again if this is incorrect."
fi

echo "Now, please enter the file to copy to. Please include a file name. For example, /usr/bin/my-script, not /usr/bin."
echo "File destination: "
read destFile

if [[ ! -z "${fileHostname// }" ]]
then
  if [[ ! -z "${destHostname// }" ]]
  then
    echo "Will attempt to copy from "$fileUser"@"$fileHostname":"$fileToCopy" SSH port "$fileSshPort" to "$destUser"@"$destHostname":"$destFile" SSH port "$destSshPort""
  else
    echo "Will attempt to copy from "$fileUser"@"$fileHostname":"$fileToCopy" SSH port "$fileSshPort" to "$destFile""
  fi
else
  if [[ ! -z "${destHostname// }" ]]
  then
    echo "Will attempt to copy from "$fileToCopy" to "$destUser"@"$destHostname":"$destFile" SSH port "$destSshPort""
  else
    echo "Will attempt to copy from "$fileToCopy" to "$destFile""
  fi
fi
read -p "Please verify this information is correct. Enter to continue, CTRL-C to abort."

if [[ ! -z "${fileHostname// }" ]]
then
  if [[ ! -z "${destHostname// }" ]]
  then
    if [[ ! $fileSshPort == "22" ]]
    then
      echo "scp -P "$fileSshPort" "$fileUser"@"$fileHostname":"$fileToCopy" "$destUser"@"$destHostname":"$destFile"" | bash
    else
      echo "scp -P "$destSshPort" "$fileUser"@"$fileHostname":"$fileToCopy" "$destUser"@"$destHostname":"$destFile"" | bash
    fi
    echo "scp "$fileUser"@"$fileHostname":"$fileToCopy" "$destUser"@"$destHostname":"$destFile"" | bash
  else
    echo "scp -P "$fileSshPort" "$fileUser"@"$fileHostname":"$fileToCopy" "$destFile"" | bash
  fi
else
  if [[ ! -z "${destHostname// }" ]]
  then
    echo "scp -P "$destSshPort" "$fileToCopy" "$destUser"@"$destHostname":"$destFile"" | bash
  else
    echo "Fine."
    echo "scp "$fileToCopy" "$destFile"" | bash
  fi
fi

if [ $? -eq 0 ]
then
  echo "Files copied successfully!"
  exit 0
else
  echo "There was an error with scp. Read man scp for help, or try again."
  exit 2
fi
exit 0

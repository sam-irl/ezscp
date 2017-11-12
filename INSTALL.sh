#!/usr/bin/env bash
echo "ezscp install script"
echo "checking for root"
dir=$PWD
cd /root
if [ $? -eq 0 ]
then
  echo "has root perms!"
  cd $dir
else
  echo "error: script must be run with root permissions, try sudo"
  cd $dir
  exit 1
fi

echo "checking for dependencies"
if [[ ! $(command -v gzip) == "" ]]
then
  echo "gzip found"
else
  echo "gzip not located, installing via apt-get"
  apt-get install gzip
  if [ $? -eq 0 ]
  then
    echo "successfully installed gzip"
  else
    echo "problem installing gzip"
    exit 1
  fi
fi

if [[ ! $(command -v scp) == "" ]]
then
  echo "scp found"
else
  echo "scp not found, installing via apt-get"
  apt-get install scp
  if [ $? -eq 0 ]
  then
    echo "successfully installed scp"
  else
    echo "problem installing scp"
    exit 1
  fi
fi

echo "installing ezscp"
cp ezscp ezscp.tmp
mv ezscp /usr/bin
if [ $? -eq 0 ]
then
  echo "ezscp installed to /usr/bin"
  mv ezscp.tmp ezscp
else
  echo "could not move to /usr/bin, do you have write permissions?"
  exit 1
fi

chmod +x /usr/bin/ezscp
if [ $? -eq 0 ]
then
  echo "chmod on ezscp successful"
else
  echo "could not chmod +x ezscp, do you have permission?"
  exit 1
fi

echo "installing manpage"
cp ezscp.1 ezscp.1.tmp
gzip ezscp.1
if [ $? -eq 0 ]
then
  echo "gzipped manpage"
  mv ezscp.1.tmp ezscp.1
else
  echo "problem gzipping manpage"
  exit 1
fi
mv ezscp.1.gz /usr/share/man/man1
if [ $? -eq 0 ]
then
  echo "installed manpage"
else
  echo "problem moving manpage to /usr/share/man/man1, do you have write permissions?"
  exit 1
fi
echo "installing configuration file"
# function to do config
config() {
  echo "version=1.0" >> /etc/ezscp/ezscp.conf
  echo "defaultSshPort=22" >> /etc/ezscp/ezscp.conf
}
# end function
touch /etc/ezscp/ezscp.conf
if [ $? -eq 0 ]
then
  echo "found an existing configuration file!"
  read -r -p "would you like to reset the configuration? [y/N] " response
  case "$response" in
      [yY][eE][sS]|[yY])
          config
          ;;
      *)
          ;;
  esac
else
  config
fi
echo "script execution successful"
exit 0

#!/bin/sh
echo "USERDATA APPLIED ON $(date)" >> /tmp/userdata
########################################################################################
apt update 
apt install unzip curl -y
curl -O https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip
unzip consul_1.5.1_linux_amd64.zip
rm -f consul_1.5.1_linux_amd64.zip
mv consul /usr/local/bin
cat <<EOF > /etc/init/consul.conf
script

    /usr/local/bin/consul agent \
        -server \
        -data-dir=/tmp/consul \
        -client=0.0.0.0 \
        -datacenter=eu-west-1 \
        -bootstrap-expect=3 \
        -ui \
        -retry-join "cousulvm0" \
        -retry-join "cousulvm1" \
        -retry-join "cousulvm2" ;
        
end script
EOF
initctl reload-configuration
initctl start consul


image: 
  description: Alpine Linux
  distribution: minimalalpine 
  release: {{ ALPINE_RELEASE }}


source: 
  downloader: alpinelinux-http 
  url: http://dl-cdn.alpinelinux.org/alpine/ 
  keys: 
    - 0482D84022F52DF1C4E7CD43293ACD0907D9495A 
  keyserver: keyserver.ubuntu.com 

packages: 
  manager: apk
  update: true
  sets:
    - packages:
        - openrc
        - openssh-server
        - python3
        - dhclient
      action: install

files:
- path: /etc/dhcp/dhclient.conf
  generator: dump
  content: |-
    send host-name = gethostname();
    prepend domain-name-servers 127.0.0.1;
    request subnet-mask, broadcast-address, time-offset, routers,
            domain-name, domain-name-servers, host-name;
    require subnet-mask, domain-name-servers;
    timeout 60;
    retry 60;
    reboot 10;
    select-timeout 5;
    initial-interval 2;
    script "/etc/dhclient-script";

    lease {
      interface "eth0";
    }

actions:
  - trigger: post-packages
    action: |-
      #!/bin/sh
      rc-update add sshd

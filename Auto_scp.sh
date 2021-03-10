#! /bin/sh
password=raspberry
username=pi
Ip=192.168.1.1.
sshpass -p "$password" scp <FileName>  $username@$Ip:<AbsoluteFIlename>

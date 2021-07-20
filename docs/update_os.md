# OS Update security

It is critically important to keep your system up-to-date with the latest patches to prevent intruders from accessing your system.

```
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get autoremove
sudo apt-get autoclean
```

*Enable automatic updates so you don't have to manually install them.*

```
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```
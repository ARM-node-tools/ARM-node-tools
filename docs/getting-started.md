# Getting started

## Requirements

- A computer that you can use to compile the image (Linux/Mac/Windows)
- Internet connect
- Git client
- Vagrant + Virtualbox

## Setting up Vagrant

First, you need to download and install Vagrant.
We use this to reduce cross platform complexity by always compiling from an identical environment.

Download instructions: https://www.vagrantup.com/downloads

Install instructions: https://www.vagrantup.com/docs/installation

## Set up the project environment

1. [Optional] Fork the repo, so that you can customize the image, commit, and preserve your changes.
2. Clone the repo, and cd into the repo root
3. Run ```vagrant up``` to initialize the virtual machine you're going to use for compiling the image. You can inspect the .vagrant file to see what software is being included in this VM.
4. Run ```vagrant ssh``` to remote into the VM

While vagrant isn't technically required in order to compile the image, it is highly encouraged in order to make the compilation environment consistent across platforms and make bugs easy to identify and reproduce. 

## Customize the image

### 1. Configure your SSH public key
There is exactly one customization that the image make script *requires* you to do, that it refuses to just do automatically on your behalf.

That step is providing a path to your SSH **public** key (*not* your private key).

If you don't already have an SSH key that you want to use for SSH access, you can generate one like this. You can do this on your host machine, or the vagrant VM. It doesn't really matter where you do this, it just matters that you do it somewhere and you safely manage that key (don't expose it, don't lose it)

```bash
# Create the public/private key pair and store it in ~/.ssh
ssh-keygen -t ed25519 -f $HOME/.ssh/my-ssh-key 
# You could also use RSA, if you prefer
```
Next, you need to copy your public key into a place where the make script can find it

```bash
cp $HOME/.ssh/my-ssh-key.pub image-builder/sources/etc/skel/
```

Next, update the ```pubKeyPath``` variable in the make.sh script so that it points to your public key

```bash
pubKeyPath="sources/etc/skel/my-ssh-key.pub"
```

This is necessary because the set up script will copy this public key into ```$HOME/.ssh/authorized_keys``` on your device, so that SSH knows to accept your private key, when you later use it to authenticate yourself.

### 2. Configure Google MFA (suggested, but optional)

If you want to configure Google MFA, follow [this guide](google-mfa.md).

Generally, these are the steps you will need to take
1. Install libpam-google-authenticator
2. Generate your .google-authenticator file, which contains your Googla MFA secret key
3. Add your secret key to your phone's Google Authenticator app by scanning the QR
3. Copy your .google-authenticator file to ```sources/etc/skel/```

### 3. Setup distributed packages

The image compilation script is configured to copy all of the contents of image-builder/packages/ into the image.
The image rc.local script later installs all of the packages it finds in that directory on first run. This makes the image-builds/packages/ dir an ideal place to put any packages that you want to get automatically installed in your image on first run.

### Make your own customizations

You are encouraged to make whatever other changes you want.

If you have an idea that you believe makes sense for everyone, make a PR! If it only makes sense for your scenario, or is a matter of personal preference, just fork the repo :)

Some ideas:
- Change the directory where the SSD is mounted (maybe you prefer ```$HOME```)
- Set the FORMAT_DRIVE variable in rc.local to 0 if your SSD is already formatted and partitioned
- Change the default SSH port
- Change the hostname
- Set a static ip
- Configure a firewall
- Rename the default linux user

## Compile the image

When you are ready prepare the image, run the following command from the ```image-builder/``` dir

```bash
./make.sh
```

## Flash the image onto your MicroSD card

1. Download and install the [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
2. Launch it, select your compiled image, and your MicroSD card, and hit continue. This will take a few minutes to write to disk and verify.
3. Eject and insert into your device, and boot it up!

## Go through post-install setup

Some ideas to consider
- [Update your OS](update_os.md)
- [Configure ZRAM swap](configure-zram-swap.md)
- [Configure ZRAM log rotation on /var/log](configure-zramlog.md)
- [Configure a UFW firewall](configure-firewall.md)
- [Test the performance of your SSD](test-ssd.md)

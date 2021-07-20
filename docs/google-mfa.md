# How to set up Google mulfi factor auth 
Source: https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-18-04

It's generally a good idea to harden your server especially when you enable SSH.
Google's libpam-google-authenticator library is an easy and effective way of hardening SSH access by requiring a second factor of authentication in addition to havin your private key.

This way, if a malicious actor were to gain access to your private key (and even the decryption password for the private key - if you encrypted it), they would still not be able to gain access to your machine over SSH, unless they ALSO have access to your MFA TOTP codes (the Google Authenticator app).

The image builder automatically installs and configures this for you IF you provide it with a .google-authenticator file before you compile the image.

# Step 1: Generate a .google-authenticator file (before your compile the image)
First, you need to install the google authenticator library on your config machine so that you create the .google-authenticator file that will include your MFA keys.

If you have multiple devices, you can re-use this MFA key if you want.

```
sudo apt-get install libpam-google-authenticator
```

Generate a .google-authenticator file

```
google-authenticator -t -d -f -r 3 -R 30 -w 3
```

Manage your keys (important)

1. Scan the QR code with your TOTP app. This is how you will read your keys 99% of the time.
2. Print out your secret key and emergency scratch codes **and store them somewhere safe**. Don't lose them.
3. [Optional] Backup your ~/.google-authenticator file somewhere safe, so you can re-use this 2FA key on another device (or the same device if you ever re-image it and don't want to do this again). Note, file permissions are important and need to stay as -r--------, so you can't just copy the contents over to a new file to restore.

# Step 2: Deploy your .google_authenticator file

Copy your .google_authenticator file to ubuntu_arm_image/sources/etc/skel/

The make.sh script will copy this file into your custom image. The /etc/skel dir is special in Linux, because all of the files in it get copied to every user's home directory. This means that this file will end up at ~/.google_authenticator, which is where the google-authenticator CLI expects to find it.

Now, you can compile your image. The deployed rc.local file will check if the .google_authenticator file is present, and if it is, it will automatically install and configure google-authenticator on your behalf.

# Step 3: Connect to your device over SSH

Connect to your device over SSH normally.
You will notice that you get prompted for a verification code in addition to your private key. Use the Google authenticator app to read your code.

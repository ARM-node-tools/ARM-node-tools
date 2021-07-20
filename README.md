# ARM Node Tools
ARM node tools is a set of blockchain agnostic, general purpose tools that facilitate the use of consensus nodes. This project specifically tests against the Raspberry Pi 4 Model B (8GB) hardware, but is meant to be theoretically usable on other ARM devices.

Really, this project is just a Ubuntu based ARM image that you can customize and compile yourself. It won't install or configure any blockchain specific software for you, but it will help you bootstrap your ARM node so you can use it for whatever you want (Bitcoin, Ethereum, Cardano, Avalanche, whatever!). It's up to you to research and understand the requirements from the blockchain you are targeting. But even for energy intensive PoW blockchains like Bitcoin, it's possible to run a node with a low power ARM device as long as you aren't trying to mine with it.

## Goals
1. Promote and facilitate the usage of low power/low cost ARM devices for blockchain nodes.
2. Provide general purpose tools to help you run your own consensus node on whatever blockchain you want using a low power ARM device
3. Optimize for the intermediate to experienced developers (customization > convenience)

## Non goals
1. Become a convenient one-click installer for staking on any particular blockchain
2. Have any blockchain specific functionality or responsibilities

## Values
- Trustlessness
- Decentralization
- Transparent (obfuscation != security)
- Security by default
- Blockchain agnostic

## How is this different from Ethereum on ARM?

This project is a fork of the [Ethereum on ARM project](https://github.com/diglos/ethereumonarm). That is a great project with a well defined mission and a strategy that makes sense. This project has different goals, and therefore takes a different strategy. Primary differences below:

1. This project does not include any ethereum specific software, while the Ethereum on ARM project does.
2. While this project is unopinionated about blockchain specific software, it *is* opinionated about hardening security by default and includes additional security features that make sense across blockchains.


# How it works

## At a glance

1. Fork the repo (if you want)
2. Clone the repo
3. Customize the build flags and the build scripts to your preference. Commit your changes.
4. Compile the image
5. Flash your MicroSD card, power on your device, and go on your merry way installing whatever blockchain specific applications you want. You are on your own at this point.


## Read the source

We encourage you to read image-builder/make.sh **and** image-builder/sources/etc/rc.local line by line for several reasons:

1) You should understand what it is doing, and how it works.
2) Then you can customize it and shape it to your liking. Push your opinionated changes back up to your fork, so you can reproduce this image whenever you want.
3) Build trust in the project, and encourage you to contribute back to it with whatever improvements you come up with that you think add value.
4) It's actually not that much code. If you don't understand a line, or what the flags mean, look it up and take advantage of the learning opportunity. Or just ask.

## What is included in the image

- Ubuntu 20.04.2 for ARM
- Security features
  - We take the SHA256 hash of the Ubuntu image after downloading it to ensure it is authentic and untampered
  - Implement many of the [CoinCashew ETH2 staking security best practices](https://www.coincashew.com/coins/overview-eth/guide-or-security-best-practices-for-a-eth2-validator-beaconchain-node). The title of that article implies these best practices are for ETH2, but there is really nothing specific about ETH2 there and are just good general practices that make sense for any kind of node.
  - SSH hardening
    - Private key authentication
    - Passwords turned off
    - Optional MFA support (recommended)
    - Customizable SSH port #
- Bundled rc.local setup script (runs on every boot, but checks against a one-time boot flag so it really only runs once unless you delete that flag)
  - Format and partition SSD before configuring mounting
  - Configure secure shared memory
  - Install and configure fail2ban
  - Configure Google MFA
  - Shred bash history from previous shell sessions
  - Misc
    - Disable Ubuntu cloud-init, which is enabled by default on Ubuntu Server but is redundant for our purposes
    - Set a MAC based machine hostname
    - Create non-default SSH user, with appropriate ownership, and default password (expires on first login)
    - Install ufw
    - Delete default ubuntu user


# Getting started

For a more in-depth tutorial on how to use this project, check out our [getting started guide](docs/getting-started.md).

# Acknowledgement and credits

This image was inspired by various sources
- [Ethereum on ARM project](https://ethereum-on-arm-documentation.readthedocs.io/en/latest/index.html)
- [Coin Cashew Security tips for eth stakers](https://www.coincashew.com/coins/overview-eth/guide-or-security-best-practices-for-a-eth2-validator-beaconchain-node#disable-root-account)
- [Guide to staking on Ethereum 2.0 by Somer Esat](https://someresat.medium.com/guide-to-staking-on-ethereum-2-0-ubuntu-pyrmont-lighthouse-a634d3b87393)
- [Digital Ocean MFA guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-18-04)
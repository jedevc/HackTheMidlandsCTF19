# HackTheMidlands CTF 2019

This is the repo for all the challenges built for and run at the
HackTheMidlands 2019 CTF. It's quite a small CTF, built for newcomers to
programming and security.

Please feel free to play around with all the challenges, use them yourself or
let them be inspiration for your own challenges.

## Try it yourself

Running and building the challenges assumes a Linux machine along with a
number of dependencies.

### Generate challenges

Compile and build all the different challenge files, such as images,
binaries, etc.

    $ ./ctftool run generate

### Build challenges

Build the docker images to run the challenges.

    $ ./ctftool run build

### Run challenges

Run the docker containers.

    $ ./ctftool run start

## Deployment

This repo contains a `main.tf` file used to deploy the CTF using Terraform
onto Google Cloud. It will deploy the CTF instance to a VM behind a static IP
and the challenge instance to a normal VM.

Yes, the scripts are a little messy, all the deployment stuff was put
together quite quickly.

    $ terraform init
    $ terraform apply

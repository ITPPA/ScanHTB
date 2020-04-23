# ScanHTB

Bash script for initial scans on HTB Machine

![Example](https://github.com/ITPPA/ScanHTB/raw/master/assets/scanhtb-full1.png)



| Chapters                                     | Description                                             |
|----------------------------------------------|---------------------------------------------------------|
| [Requirements](#requirements)                | Requirements             								 |
| [Features](#Features)              	       | What inside											 |
| [Usage](#Usage)                              | How to Use 						                     |
| [Install](#Install)                          | How to Install						                     |
| [Acknowledgments](#acknowledgments)          | Kudos to these people                                   |

## Requirement

* Bash !!!
* Nmap
* [Gobuster](https://github.com/OJ/gobuster)
* [Dirb](https://tools.kali.org/web-applications/dirb)

## Features

* Full TCP / UDP scan
* Service scan on full TCP scan result
* Gobuster / dirb if Webserver Found (only on p 80 from now)
* Can replay without full rescan (check if files exist)

## Install

> Download script
```sh
$ git clone https://github.com/ITPPA/ScanHTB.git
```
> create box folder
```sh
$ mkdir box && cd box/
```
> run script 
```sh
$ /path/to/script/scanhtb.sh <LAST DIGIT HTB BOX IP>
$ /path/to/script/scanhtb.sh 10
```

## Usage

```
Usage: ./scanhtb.sh [OPTION] ip

Perform initial scans on a new Hack the Box machine.

Options:
	-h               display this help message
	-t               perform TCP scans (default)
	-u               perform UDP scans
Parameters:
	ip               Last digit of IP address (10.10.10.X)
```

## Changelog

```
v0.1
------
First Release
* Full TCP / UDP scan
* Service scan on full TCP scan result
* Gobuster / dirbuster if Webserver Found (only on p 80 from now)
* Can replay without full rescan (check if files exist)
```

## TODO:

* add port 443 for web scanning
* clean code
* a lot of stuff

### Acknowledgments

This script was made based on calebstewart init-machine script 
* [calebstewart init-machine](https://github.com/calebstewart/init-machine) - Thank's


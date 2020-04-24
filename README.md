# ScanHTB

Bash script for initial scans on HTB Machine

 - All HackTheBox Player know, the 1st part of enumeration is always the same.

 - I'm a IT guy, so I'm lazy.

 - This script with do all the 1st stuff for you. Juste run and wait...

 - Feel free to use, share, improve. Just let me know ^^

## Exemple

![Example](https://github.com/ITPPA/ScanHTB/raw/master/assets/scanhtb-full1.png)


| Chapters                                     | Description                                             |
|----------------------------------------------|---------------------------------------------------------|
| [Requirements](#Requirements)                | Requirements             								 |
| [Features](#Features)              	       | What's inside											 |
| [Install](#Install)                          | How to Install						                     |
| [Usage](#Usage)                              | How to Use 						                     |
| [Changelog](#Changelog)                      | Does it change sometimes ?			                     |
| [TODO](#TODO)                                | What's next						                     |
| [Acknowledgments](#acknowledgments)          | Kudos to these people                                   |

## Requirements

* Bash in {a,c,Z,tc,k}sh / fish or what you want !!!
* Nmap
* [Gobuster](https://github.com/OJ/gobuster)
* [Dirb](https://tools.kali.org/web-applications/dirb)

## Features

* Full TCP / UDP scan
* Service scan on full TCP scan result
* Gobuster / dirb if Webserver Found (only on p 80 from now)
* Can replay without full rescan (check if files exist) 

![Replay](https://github.com/ITPPA/ScanHTB/raw/master/assets/scanhtb-exist.png)

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
# Exemple pour Arctic box (10.10.10.11)
$ /path/to/script/scanhtb.sh 11
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
v0.1 (April 2020) 
------
First Release
* Full TCP / UDP scan [1-65535]
* Service scan on full TCP scan result
* Gobuster / dirbuster if Webserver Found (only on p 80 from now)
* Can replay without full rescan (check if files exist)
```

## TODO:

* add port 443 for web scanning
* clean code
* put all results in one file
* a lots of stuff

### Acknowledgments

This script was made based on calebstewart init-machine script 

* [calebstewart init-machine](https://github.com/calebstewart/init-machine) - Thank's

* [HTBFRTeam](https://www.hackthebox.eu/home/teams/profile/2054) - My Team

![HTBFRTeam](https://www.hackthebox.eu/badge/team/image/2054)
![ITPPA](http://www.hackthebox.eu/badge/image/6798)


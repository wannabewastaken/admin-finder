<h3 align=center>
    admin-finder
</h3>

<h6 align=center>
    <a href="https://github.com/wannabewastaken/admin-finder#usage">Usage</a>
    ·
    <a href="https://github.com/wannabewastaken/admin-finder#features">Features</a>
    ·
    <a href="https://github.com/wannabewastaken/admin-finder#how-to-install">Install</a>
</h6>

<p align=center>
	A script used to find the admin login page of a website
</p>

<p align=center>
    <a href="https://github.com/wannabewastaken/admin-finder/">
		<img alt="Version" src="https://img.shields.io/github/v/tag/wannabewastaken/admin-finder?style=for-the-badge&label=release&logo=verdaccio&color=526D82&logoColor=DDE6ED&labelColor=27374D&sort=semver">
    </a>
    <a href="https://github.com/wannabewastaken/admin-finder/stargazers">
		<img alt="Stargazers" src="https://img.shields.io/github/stars/wannabewastaken/admin-finder?style=for-the-badge&logo=starship&color=526D82&logoColor=DDE6ED&labelColor=27374D">
    </a>
</p>

&nbsp;

### Usage
> <code>./admin-finder.sh [option] [value]</code>
<table>
    <tr>
        <th>Option</th>
        <th>Value</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>-h, --help</td>
        <td>None</td>
        <td>Show this help message and exit</td>
    </tr>
    <tr>
        <td>-u, --url</td>
        <td>url</td>
        <td>Target url (e.g. 'www.example.com' or 'example.com')</td>
    </tr>
    <tr>
        <td>-t, --thread</td>
        <td>thread</td>
        <td>Set thread number (default: 100)</td>
    </tr>
    <tr>
        <td>-w, --wordlist</td>
        <td>wordlist</td>
        <td>Use custom wordlist</td>
    </tr>
</table>

### Features
- [x] Web crawling
- [x] Auto scanning robots.txt
- [x] Checking potential EAR vulnerability
- [x] Launch multiple process java on demand (bash multiprocess)

### How to install
> This script required dependencies of `curl >= 7.88.1` and `cut >= 9.1` or higher.
<details>
<summary>Termux</summary>
	
<span>Make sure you have already installed `git` if you don't, run the code above.</span>
```bash
> pkg update -y
> pkg install git -y
```

<span>Let's cloning it into your computer.</span>
```bash
> git clone https://github.com/wannabewastaken/admin-finder
```
</details>

<details>
<summary>Kali-Linux</summary>
	
<span>Make sure you have already installed `git` if you don't, run the code above.</span>
```bash
> sudo apt update -y
> sudo apt install git -y
```

<span>Let's cloning it into your computer.</span>
```bash
> git clone https://github.com/wannabewastaken/admin-finder
```
</details>

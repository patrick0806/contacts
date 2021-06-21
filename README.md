# Contact Book

Contact book developed in flutter.
With a calendar you can register, change and delete contacts and add a photo of the content straight from the gallery.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Configuring a web server in DigitalOcean and installing wordpress

### Step 1 - Create a new droplet in DigitalOcean

## Initial Config

### Step 2 - Logging in as root user

    Open the command panel and type:

    ```
    ssh root@your_server_ip
    ```

### Step 3 (optional) - Creating a New User and grating admin privileges

    Create user:

    ```
    adduser _username_
    ```
    Grating  privileges:
    
    ```
    usermod -aG sudo _username_
    ```

### Step 4 - Setting Up a Basic Firewall
    run this commands:
    
    ```
    ufw allow OpenSSH
    ufw enable
    ufw status
    ```

    expected output
    ```
    Status: active

    |To          |              |Action|      |From         | 
    |--          |              |------|      |----         |
    |OpenSSH     |              |ALLOW |      |Anywhere     |
    |OpenSSH (v6)|              |ALLOW |      |Anywhere (v6)|
    ```

### Step 5 - Enabling External Access for your user
    run this command:
    
    ```
    rsync --archive --chown=_username_:_username_ ~/.ssh /home/_username_
    ```

## Config LAMP stack (Apache,Mysql,PHP)

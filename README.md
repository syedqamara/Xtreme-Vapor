# Xtreme-Vapor
Xtreme-Vapor is WebBased Application to create &amp; distributes iOS Apps


# Requirements?
You'll need to meet following requirements to host/run this application.
* Server/Machine must be running on macOS atleast.
* Server/Machine must have installed the Xcode Command line interface on that machine.
* Server/Machine must have enough space to store 5 Xcode Archive File Size for Demo.
* Server/Machine must have provided all necessory permissions asked for fresh launch of each application. (Like Directories, Appplications permission asked by macOS)


Now clone this rapo on any Server/Machine, install all dependencies embeded in this project, start <a href="https://docs.vapor.codes/4.0/fluent/migration/">Fluent Migrations<a/>, then open it once with Xcode & Set your Project Directory in your `Edit Scheme` near `Xcode-Play-Button`. Run this application from Xcode and you will be asked to provide permissions on `Fresh Launch` of this application. 
When Server starts you should be seeing `Running Server 127.0.0.1:8080`
Now go to your browser and type `127.0.0.1:8080`.

## Features

**User Registration/Authentication.**
**Application.**
  - Name
  - Git URL
  - Bundle ID
  - Image
  - Xcode Project Name 
  - Path to Project (if Project is at root level in git repository then leave this field empty)
  - Xcode Target Name
  - Platform (currently iOS)


**Build**
  - Nodes `UAT, RC, PROD, DEV, QA, etc`
  - Modes `ad-hoc, development, enterprise, app-store` Always use the latest resources for selected **Mode**
  - Branch (`git branch` you want to generate build)
  - Build Status `Success, Failed, Processing`
  - Build Downloadable Link
  - Release Notes

For Builds please Login using <a href="">Amazon CLI<a/>

**Resources**
  - Modes
  - Certificate `.p12` File
  - Zipfile of Provisioning & Export Option File created by Xcode by using those provisioning profiles.
  - Application

**Database**
Database for this project is not Yet public. 
You can create PostgreSQL database & change your database credentials in `configure.swift`.

First add your credential in bellow credential config
```
enum ENTBuildsDB: String {
    typealias RawValue = String
    case db_name = "d29gg198bn81tt"
    case hostname = "ec2-52-71-161-140.compute-1.amazonaws.com"
    case username = "uopczrtspxvnfp"
    case password = "0338f4911a02d17aaef20c4abe84e3cb026119a1b2b8b94de2a37266fa411ad8"
    case db_url = "postgres://toqcfrtepxqnfm:fghjhgfdfghjgfgfyuhgfdjhdfjhgfjhghjg@ec2-52-71-161-140.compute-1.amazonaws.com:5432/56787657"
 }
```
Then use above credentials either Local/Remote DB.
```
if AppConfig.isLocalDB {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? ENTBuildsDB.hostname.rawValue,
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? ENTBuildsDB.username.rawValue,
            password: Environment.get("DATABASE_PASSWORD") ?? ENTBuildsDB.password.rawValue,
            database: Environment.get("DATABASE_NAME") ?? ENTBuildsDB.db_name.rawValue
        ), as: .psql)
    }else {
        if var postgresConfig = PostgresConfiguration(url: ENTBuildsDB.db_url.rawValue) {
            postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
            app.databases.use(.postgres(
                configuration: postgresConfig
            ), as: .psql)
        }
    }
```

**ipa Storage**
This app is using `AWS Bucket` to store ipa. How to connect any AWS with our App?
1. First Login to AWS using AWS CLI.
2. Goto `Project/Public/scripts/aws_build.sh` And Change Your `Bucket` & `Region`

# Issues
Please create issues on issues section if you stuck somewhere. We will try our best to give response on your issues.

# Request
This application is not completely stable yet. We have made it public as we request Open Source Community to help us make this project more stable so we could help all developers to run & distribute any applications from your Mobile & Web apps. As this process requires extensive use to `Bash Scripting` so we request Bash Developers to help us in making our scripts more stable.

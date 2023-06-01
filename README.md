# Tools4everBV-HelloID-Conn-Prov-Source-BambooHR

| :information_source: Information |
|:---------------------------|
| This repository contains the connector and configuration code only. The implementer is responsible to acquire the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements.       |

<br />

<p align="center">
  <img src="https://github.com/Tools4everBV/Tools4everBV-HelloID-Conn-Prov-Source-BambooHR/blob/main/assets/bamboohrLogo.png">
</p
Source data from BambooHR via API

## Table of contents

* [Introduction](#introduction)
* [Prerequisites](#prerequisites)
* [Mappings](#mappings)
* [Setup the PowerShell source connector](#setup-the-powershell-source-connector)

## Introduction

This source connector leverages the BambooHR API to import employees into HelloID Provisioning

## Prerequisites

- API Key from BambooHR https://documentation.bamboohr.com/docs/getting-started

## Mappings

A basic person and contract mapping is provided. Make sure to further customize these accordingly.

## Setup the PowerShell source connector

1. Add a new 'Source System' to HelloID and make sure to import all the necessary files.

    - [ ] configuration.json
    - [ ] personMapping.json
    - [ ] contractMapping.json
    - [ ] persons.ps1
    - [ ] departments.ps1

2. Fill in the required fields on the connectors 'Configuration' tab.

![image](assets/BambooHRConfiguration.jpg)

# HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/

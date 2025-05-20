# Always Trust User Certs

This module makes all installed user certificates part of the system certificate store, so that they will automatically be used when building the trust chain. This module makes it unnecessary to add the network_security_config property to an application's manifest.

Features:

* Support for multiple users
* Support for Magisk/KernelSU/KernelSU Next
* Support for devices with and without mainline/conscrypt updates

Depending on your Android version and Google Play Security Update version, your certificates will be either stored in `/system/etc/security/cacerts` or in `/apex/com.android.conscrypt/cacerts/`. This module handles all scenarios and works on any device from Android 7 until Android 16.

## Usage

### Installing certificates

Install the certificate as a user certificate and restart the device.

### Removing certificates

Remove the certificate from the user store through the settings and restart the device.

## Changelog

### v1.3

* Fixed bug on A14+

### v1.2

* Added automatic update support

### v1.1

* Fixed permission issue for non-conscrypt
* Fixed removal of certs for non-conscrypt
* Renamed repo

### v1.0

* Add support for mainline/conscrypt certificates
* Add support for multiple users
* Add support for KernelSU

### v0.4.1

* Supports Android 10
* Updated Module to be compatible with latest Magisk module template (v20.4+)

### v0.3

* The module now removes all user-installed certificates from the system store before copying them over, so that user certificates that were removed will no longer be kept in the system store.

### v0.2

* Fixed directory creation bug
* Updated Module to be compatible with latest Magisk module template (v15+)

### v0.1

* Initial release

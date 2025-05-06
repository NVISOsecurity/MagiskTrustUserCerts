# Magisk Trust User Certs

This module makes all installed user certificates part of the system certificate store, so that they will automatically be used when building the trust chain. This module makes it unnecessary to add the network_security_config property to an application's manifest.

Features:

* Support for multiple users
* Support for Magisk and KernelSU
* Support for devices with and without mainline/conscrypt updates

## Accompanying blogpost

[Intercepting HTTPS Traffic from Apps on Android 7+ using Magisk & Burp](https://blog.nviso.be/2017/12/22/intercepting-https-traffic-from-apps-on-android-7-using-magisk-burp/)

## Installation

1. Install [Magisk](https://github.com/topjohnwu/Magisk)
2. Zip files `zip -r AlwaysTrustUserCerts.zip ./*` or download zip from releases
3. Install in Magisk / KernelSU
4. Install client certificates through [normal flow](https://support.portswigger.net/customer/portal/articles/1841102-installing-burp-s-ca-certificate-in-an-android-device)
5. Restart your device. Certificate are copied during boot.
6. The installed user certificates can now be found in the system store.

### Adding certificates

Install the certificate as a user certificate and restart the device.

### Removing certificates

Remove the certificate from the user store through the settings and restart the device.

## Changelog

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

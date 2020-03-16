# Magisk Trust User Certs
This module makes all installed user certificates part of the system certificate store, so that they will automatically be used when building the trust chain. This module makes it unnecessary to add the network_security_config property to an application's manifest.

## Accompanying blogpost
[Intercepting HTTPS Traffic from Apps on Android 7+ using Magisk & Burp](https://blog.nviso.be/2017/12/22/intercepting-https-traffic-from-apps-on-android-7-using-magisk-burp/)

### Installation
1. Install [Magisk](https://forum.xda-developers.com/apps/magisk/official-magisk-v7-universal-systemless-t3473445)
2. Zip files `zip -r AlwaysTrustUserCerts.zip ./*` or download zip from releases
3. Install in Magisk
4. Install client certificates through [normal flow](https://support.portswigger.net/customer/portal/articles/1841102-installing-burp-s-ca-certificate-in-an-android-device)
5. Reboot
6. The installed user certificates can now be found in the system store.

### Changelog
#### v0.4
* Supports Android 10
* Updated Module to be compatible with latest Magisk module template (v20.3+)

#### v0.3
* The module now removes all user-installed certificates from the system store before copying them over, so that user certificates that were removed will no longer be kept in the system store.

#### v0.2
* Fixed directory creation bug
* Updated Module to be compatible with latest Magisk module template (v15+)

#### v0.1
* Initial release



Template used from [Magisk's module template](https://github.com/topjohnwu/magisk-module-template)

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/7] crypto: aes - add new Kconfig symbol for soft dependency on AES
Date: Sun, 26 Mar 2017 19:49:03 +0100
Message-ID: <1490554148-10953-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35852 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdCZS4w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:56:52 -0400
Received: by mail-wr0-f169.google.com with SMTP id w11so15654476wrc.3
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:56:51 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Many drivers have a soft dependency on the availability of any crypto
driver that implements the "aes" cipher. To separate this notion from
the link time dependency on the tables or routines in the generic AES
driver, introduce a new Kconfig symbol CRYPTO_NEED_AES and use it to
replace any occurrences of CRYPTO_AES pertaining to such soft
dependencies.

For now, CRYPTO_NEED_AES simply implies CONFIG_AES, so the net result
is still the same.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig                               |  8 ++++++--
 drivers/block/Kconfig                        |  2 +-
 drivers/crypto/Kconfig                       | 10 +++++-----
 drivers/net/Kconfig                          |  2 +-
 drivers/net/wireless/cisco/Kconfig           |  2 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig   |  2 +-
 drivers/net/wireless/intersil/hostap/Kconfig |  2 +-
 drivers/staging/rtl8192e/Kconfig             |  2 +-
 drivers/usb/wusbcore/Kconfig                 |  2 +-
 fs/ceph/Kconfig                              |  2 +-
 fs/cifs/Kconfig                              |  2 +-
 fs/crypto/Kconfig                            |  2 +-
 net/Kconfig                                  |  2 +-
 net/bluetooth/Kconfig                        |  2 +-
 net/ceph/Kconfig                             |  2 +-
 net/mac80211/Kconfig                         |  2 +-
 net/mac802154/Kconfig                        |  2 +-
 net/sunrpc/Kconfig                           |  3 ++-
 security/keys/Kconfig                        |  4 ++--
 19 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6854c1fe54b7..5f89edc6cd13 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -894,6 +894,10 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 
 comment "Ciphers"
 
+config CRYPTO_NEED_AES
+	tristate
+	select CRYPTO_AES
+
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
@@ -1666,7 +1670,7 @@ comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_RNG
 	help
 	  This option enables the generic pseudo random number generator
@@ -1696,7 +1700,7 @@ config CRYPTO_DRBG_HASH
 
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	depends on CRYPTO_CTR
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f744de7a0f9b..f6fd9f237245 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -531,7 +531,7 @@ config BLK_DEV_RBD
 	depends on INET && BLOCK
 	select CEPH_LIB
 	select LIBCRC32C
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO
 	default n
 	help
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0cbc5b33d92d..0ea163122df2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -329,7 +329,7 @@ config CRYPTO_DEV_OMAP_SHAM
 config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_CBC
@@ -355,7 +355,7 @@ config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
 	depends on (ARCH_PICOXCELL || COMPILE_TEST) && HAVE_CLK
 	select CRYPTO_AEAD
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
@@ -373,7 +373,7 @@ config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
 	depends on ARCH_MXC && OF
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_ECB
 	help
 	  This option enables support for the SAHARA HW crypto accelerator
@@ -500,7 +500,7 @@ config CRYPTO_DEV_MXS_DCP
 	select STMP_DEVICE
 	select CRYPTO_CBC
 	select CRYPTO_ECB
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	help
@@ -523,7 +523,7 @@ config CRYPTO_DEV_CAVIUM_ZIP
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
 	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
 	select CRYPTO_CBC
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 100fbdc9b95c..6a05d978ecd9 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -230,7 +230,7 @@ config GTP
 config MACSEC
 	tristate "IEEE 802.1AE MAC-level encryption (MACsec)"
 	select CRYPTO
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_GCM
 	select GRO_CELLS
 	---help---
diff --git a/drivers/net/wireless/cisco/Kconfig b/drivers/net/wireless/cisco/Kconfig
index b22567dff893..e2ed36f95e04 100644
--- a/drivers/net/wireless/cisco/Kconfig
+++ b/drivers/net/wireless/cisco/Kconfig
@@ -38,7 +38,7 @@ config AIRO_CS
 	select WEXT_SPY
 	select WEXT_PRIV
 	select CRYPTO
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	---help---
 	  This is the standard Linux driver to support Cisco/Aironet PCMCIA
 	  802.11 wireless cards.  This driver is the same as the Aironet
diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index d6ec44d7a391..decc039d79d4 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -161,7 +161,7 @@ config LIBIPW
 	select CRYPTO
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_MICHAEL_MIC
 	select CRYPTO_ECB
 	select CRC32
diff --git a/drivers/net/wireless/intersil/hostap/Kconfig b/drivers/net/wireless/intersil/hostap/Kconfig
index 287d82728bc3..6491fd06d5a8 100644
--- a/drivers/net/wireless/intersil/hostap/Kconfig
+++ b/drivers/net/wireless/intersil/hostap/Kconfig
@@ -6,7 +6,7 @@ config HOSTAP
 	select CRYPTO
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_MICHAEL_MIC
 	select CRYPTO_ECB
 	select CRC32
diff --git a/drivers/staging/rtl8192e/Kconfig b/drivers/staging/rtl8192e/Kconfig
index 4602a47cdb4a..e32c0e9976b0 100644
--- a/drivers/staging/rtl8192e/Kconfig
+++ b/drivers/staging/rtl8192e/Kconfig
@@ -14,7 +14,7 @@ if RTLLIB
 config RTLLIB_CRYPTO_CCMP
 	tristate "Support for rtllib CCMP crypto"
 	depends on RTLLIB
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	default y
 	---help---
 	  CCMP crypto driver for rtllib.
diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
index 348de1d6726e..5f1fc924e425 100644
--- a/drivers/usb/wusbcore/Kconfig
+++ b/drivers/usb/wusbcore/Kconfig
@@ -8,7 +8,7 @@ config USB_WUSB
         select CRYPTO_BLKCIPHER
         select CRYPTO_CBC
         select CRYPTO_MANAGER
-        select CRYPTO_AES
+        select CRYPTO_NEED_AES
 	help
 	  Enable the host-side support for Wireless USB.
 
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 264e9bf83ff3..0b5f80109f83 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -3,7 +3,7 @@ config CEPH_FS
 	depends on INET
 	select CEPH_LIB
 	select LIBCRC32C
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO
 	default n
 	help
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 034f00f21390..4c4e25f72682 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -171,7 +171,7 @@ config CIFS_SMB2
 	select KEYS
 	select FSCACHE
 	select DNS_RESOLVER
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 08b46e6e3995..48c1b8fee64b 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,7 +1,7 @@
 config FS_ENCRYPTION
 	tristate "FS Encryption (Per-file encryption)"
 	select CRYPTO
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_XTS
diff --git a/net/Kconfig b/net/Kconfig
index 102f781a0131..7020680737f4 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -62,7 +62,7 @@ source "net/smc/Kconfig"
 config INET
 	bool "TCP/IP networking"
 	select CRYPTO
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	---help---
 	  These are the protocols used on the Internet and on most local
 	  Ethernets. It is highly recommended to say Y here (this will enlarge
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 06c31b9a68b0..3dcde8b1c3aa 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -9,7 +9,7 @@ menuconfig BT
 	select CRC16
 	select CRYPTO
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_CMAC
 	select CRYPTO_ECB
 	select CRYPTO_SHA256
diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index f8cceb99e732..9061ea82bdaa 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -2,7 +2,7 @@ config CEPH_LIB
 	tristate "Ceph core library"
 	depends on INET
 	select LIBCRC32C
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_CBC
 	select CRYPTO
 	select KEYS
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 76e30f4797fb..4f241ef31005 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -3,7 +3,7 @@ config MAC80211
 	depends on CFG80211
 	select CRYPTO
 	select CRYPTO_ARC4
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_CMAC
diff --git a/net/mac802154/Kconfig b/net/mac802154/Kconfig
index fb45287ebac3..1c5f68303e5d 100644
--- a/net/mac802154/Kconfig
+++ b/net/mac802154/Kconfig
@@ -6,7 +6,7 @@ config MAC802154
 	select CRYPTO_AUTHENC
 	select CRYPTO_CCM
 	select CRYPTO_CTR
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	---help---
 	  This option enables the hardware independent IEEE 802.15.4
 	  networking stack for SoftMAC devices (the ones implementing
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 04ce2c0b660e..6e79d6f35a80 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -19,7 +19,8 @@ config RPCSEC_GSS_KRB5
 	tristate "Secure RPC: Kerberos V mechanism"
 	depends on SUNRPC && CRYPTO
 	depends on CRYPTO_MD5 && CRYPTO_DES && CRYPTO_CBC && CRYPTO_CTS
-	depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1 && CRYPTO_AES
+	depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1
+	select CRYPTO_NEED_AES
 	depends on CRYPTO_ARC4
 	default y
 	select SUNRPC_GSS
diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index d942c7c2bc0a..c14f059310fe 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -42,7 +42,7 @@ config BIG_KEYS
 	depends on KEYS
 	depends on TMPFS
 	depends on (CRYPTO_ANSI_CPRNG = y || CRYPTO_DRBG = y)
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_ECB
 	select CRYPTO_RNG
 	help
@@ -73,7 +73,7 @@ config ENCRYPTED_KEYS
 	depends on KEYS
 	select CRYPTO
 	select CRYPTO_HMAC
-	select CRYPTO_AES
+	select CRYPTO_NEED_AES
 	select CRYPTO_CBC
 	select CRYPTO_SHA256
 	select CRYPTO_RNG
-- 
2.7.4

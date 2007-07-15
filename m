From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/crypto/Kconfig: hardware drivers shouldn't
	"default m"
Date: Sun, 15 Jul 2007 12:00:13 +0200
Message-ID: <20070715100013.GI3565@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33734 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756812AbXGOKAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jul 2007 06:00:50 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hardware drivers shouldn't default to m.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/crypto/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/crypto/Kconfig.old	2007-07-14 06:25:27.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/crypto/Kconfig	2007-07-14 06:25:35.000000000 +0200
@@ -8,7 +8,6 @@
 	tristate "Support for VIA PadLock ACE"
 	depends on X86_32
 	select CRYPTO_ALGAPI
-	default m
 	help
 	  Some VIA processors come with an integrated crypto engine
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
@@ -22,7 +21,6 @@
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
-	default m
 	help
 	  Use VIA PadLock for AES algorithm.
 
@@ -36,7 +34,6 @@
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
-	default m
 	help
 	  Use VIA PadLock for SHA1/SHA256 algorithms.
 
@@ -52,7 +49,6 @@
 	depends on X86_32 && PCI
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
-	default m
 	help
 	  Say 'Y' here to use the AMD Geode LX processor on-board AES
 	  engine for the CryptoAPI AES algorithm.
@@ -64,7 +60,6 @@
 	tristate "Support for PCI-attached cryptographic adapters"
 	depends on S390
 	select ZCRYPT_MONOLITHIC if ZCRYPT="y"
-	default "m"
 	help
 	  Select this option if you want to use a PCI-attached cryptographic
 	  adapter like:

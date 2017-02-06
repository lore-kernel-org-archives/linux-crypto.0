From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] crypto: atmel - refine Kconfig dependencies
Date: Mon,  6 Feb 2017 13:32:15 +0100
Message-ID: <20170206123240.1698839-1-arnd@arndb.de>
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:63115 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdBFMdG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 07:33:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With the new authenc support, we get a harmless Kconfig warning:

warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)

The problem is that each of the options has slightly different dependencies,
although they all seem to want the same thing: allow building for real AT91
targets that actually have the hardware, and possibly for compile testing.

This makes all four options consistent: instead of depending on a particular
dmaengine implementation, we depend on the ARM platform, CONFIG_COMPILE_TEST
as an alternative when that is turned off. This makes the 'select' statements
work correctly.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 74824612d3e9..f60de152a90d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -417,7 +417,8 @@ config CRYPTO_DEV_BFIN_CRC
 
 config CRYPTO_DEV_ATMEL_AUTHENC
 	tristate "Support for Atmel IPSEC/SSL hw accelerator"
-	depends on (ARCH_AT91 && HAS_DMA) || COMPILE_TEST
+	depends on HAS_DMA
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_ATMEL_AES
 	select CRYPTO_DEV_ATMEL_SHA
@@ -430,7 +431,7 @@ config CRYPTO_DEV_ATMEL_AUTHENC
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on HAS_DMA
-	depends on AT_XDMAC || AT_HDMAC || COMPILE_TEST
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
@@ -444,7 +445,7 @@ config CRYPTO_DEV_ATMEL_AES
 
 config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
-	depends on ARCH_AT91
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
@@ -457,7 +458,7 @@ config CRYPTO_DEV_ATMEL_TDES
 
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
-	depends on ARCH_AT91
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_HASH
 	help
 	  Some Atmel processors have SHA1/SHA224/SHA256/SHA384/SHA512
-- 
2.9.0

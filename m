From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] crypto: Allow drivers to build if COMPILE_TEST is enabled
Date: Tue, 13 Oct 2015 15:42:40 +0200
Message-ID: <1444743760-15155-1-git-send-email-javier@osg.samsung.com>
Cc: Luis de Bethencourt <luisbg@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51540 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbbJMNnE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:43:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These drivers only have runtime but no build time dependencies so can be
built for testing purposes if the Kconfig COMPILE_TEST option is enabled.

This is useful to have more build coverage and make sure that drivers are
not affected by changes that could cause build regressions.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/crypto/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab7e3b668890..dba87ab8878f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -51,7 +51,7 @@ config CRYPTO_DEV_PADLOCK_SHA
 
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
-	depends on X86_32 && PCI
+	depends on (X86_32 || COMPILE_TEST) && PCI
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
@@ -175,7 +175,7 @@ config CRYPTO_DEV_MV_CESA
 
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "New Marvell's Cryptographic Engine driver"
-	depends on PLAT_ORION || ARCH_MVEBU
+	depends on PLAT_ORION || ARCH_MVEBU || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
@@ -310,7 +310,7 @@ config CRYPTO_DEV_OMAP_DES
 
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
-	depends on ARCH_PICOXCELL && HAVE_CLK
+	depends on (ARCH_PICOXCELL || COMPILE_TEST) && HAVE_CLK
 	select CRYPTO_AEAD
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
@@ -338,7 +338,7 @@ config CRYPTO_DEV_SAHARA
 
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
-	depends on ARCH_S5PV210 || ARCH_EXYNOS
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	help
@@ -429,7 +429,7 @@ endif
 
 config CRYPTO_DEV_MXS_DCP
 	tristate "Support for Freescale MXS DCP"
-	depends on (ARCH_MXS || ARCH_MXC)
+	depends on (ARCH_MXS || ARCH_MXC || COMPILE_TEST)
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_AES
-- 
2.4.3

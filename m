From: Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] crypto: Improve wording for CRYPTO_DEV_OMAP_DES in Kconfig
Date: Sun, 13 Mar 2016 16:15:37 +0100
Message-ID: <1457882137-16265-1-git-send-email-pmeerw@pmeerw.net>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Peter Meerwald <pmeerw@pmeerw.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([84.19.176.92]:58714 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbcCMPPk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Mar 2016 11:15:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/crypto/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 07d4942..b4da268 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -301,15 +301,15 @@ config CRYPTO_DEV_OMAP_AES
 	  want to use the OMAP module for AES algorithms.
 
 config CRYPTO_DEV_OMAP_DES
-	tristate "Support for OMAP DES3DES hw engine"
+	tristate "Support for OMAP DES/3DES hw engine"
 	depends on ARCH_OMAP2PLUS
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
 	  OMAP processors have DES/3DES module accelerator. Select this if you
 	  want to use the OMAP module for DES and 3DES algorithms. Currently
-	  the ECB and CBC modes of operation supported by the driver. Also
-	  accesses made on unaligned boundaries are also supported.
+	  the ECB and CBC modes of operation are supported by the driver. Also
+	  accesses made on unaligned boundaries are supported.
 
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
-- 
1.7.10.4

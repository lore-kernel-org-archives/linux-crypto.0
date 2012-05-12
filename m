From: Alexander Clouter <alex@digriz.org.uk>
Subject: [PATCH] crypto: mv_cesa requires on CRYPTO_HASH to build
Date: Sat, 12 May 2012 09:45:08 +0100
Message-ID: <1336812308-32501-1-git-send-email-alex@digriz.org.uk>
Cc: Alexander Clouter <alex@digriz.org.uk>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from marmot.wormnet.eu ([188.246.204.87]:42574 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2ELJac (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 May 2012 05:30:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without CRYPTO_HASH being selected, mv_cesa has a lot of hooks
into undefined exports.
----
  MODPOST 81 modules
  Kernel: arch/arm/boot/Image is ready
  AS      arch/arm/boot/compressed/head.o
  GZIP    arch/arm/boot/compressed/piggy.gzip
  CC      arch/arm/boot/compressed/misc.o
  CC      arch/arm/boot/compressed/decompress.o
ERROR: "crypto_ahash_type" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_final" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_register_ahash" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_unregister_ahash" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_update" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_digest" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_shash_setkey" [drivers/crypto/mv_cesa.ko] undefined!
ERROR: "crypto_alloc_shash" [drivers/crypto/mv_cesa.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
----

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e707979..07dbc77 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -173,6 +173,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
-- 
1.7.10

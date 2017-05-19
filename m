From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] staging: ccree: add CRYPTO dependency
Date: Fri, 19 May 2017 10:04:01 +0200
Message-ID: <20170519080409.1042426-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:55844 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdESIES (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 04:04:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A rare randconfig build error shows up when we have CONFIG_CRYPTO=m
in combination with a built-in CCREE driver:

crypto/hmac.o: In function `hmac_update':
hmac.c:(.text.hmac_update+0x28): undefined reference to `crypto_shash_update'
crypto/hmac.o: In function `hmac_setkey':
hmac.c:(.text.hmac_setkey+0x90): undefined reference to `crypto_shash_digest'
hmac.c:(.text.hmac_setkey+0x154): undefined reference to `crypto_shash_update'
drivers/staging/ccree/ssi_cipher.o: In function `ssi_blkcipher_setkey':
ssi_cipher.c:(.text.ssi_blkcipher_setkey+0x350): undefined reference to `crypto_shash_digest'
drivers/staging/ccree/ssi_cipher.o: In function `ssi_blkcipher_exit':
ssi_cipher.c:(.text.ssi_blkcipher_exit+0xd4): undefined reference to `crypto_destroy_tfm'
drivers/staging/ccree/ssi_cipher.o: In function `ssi_blkcipher_init':
ssi_cipher.c:(.text.ssi_blkcipher_init+0x1b0): undefined reference to `crypto_alloc_shash'
drivers/staging/ccree/ssi_cipher.o: In function `ssi_ablkcipher_free':
ssi_cipher.c:(.text.ssi_ablkcipher_free+0x48): undefined reference to `crypto_unregister_alg'
drivers/staging/ccree/ssi_cipher.o: In function `ssi_ablkcipher_alloc':
ssi_cipher.c:(.text.ssi_ablkcipher_alloc+0x138): undefined reference to `crypto_register_alg'
ssi_cipher.c:(.text.ssi_ablkcipher_alloc+0x274): undefined reference to `crypto_blkcipher_type'

We actually need to depend on both CRYPTO and CRYPTO_HW here to avoid the
problem, since CRYPTO_HW is a bool symbol and by itself that does not
force CCREE to be a loadable module when the core cryto support is modular.

Fixes: 50cfbbb7e627 ("staging: ccree: add ahash support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/ccree/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index ae627049c499..4be87f503e3b 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell C7XX family of Crypto accelerators"
-	depends on CRYPTO_HW && OF && HAS_DMA
+	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
 	default n
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
-- 
2.9.0

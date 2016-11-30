From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: arm/aesbs - Select SIMD in Kconfig
Date: Thu,  1 Dec 2016 00:47:59 +0100
Message-ID: <20161130234826.854879-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:64508 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbcK3Xtf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 18:49:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 585b5fa63da9 ("crypto: arm/aes - Select SIMD in Kconfig") added
the dependency for CRYPTO_AES_ARM_CE, but missed the same change
for CRYPTO_AES_ARM_BS:

arch/arm/crypto/aes-arm-bs.o: In function `aesbs_mod_init':
aesbs-glue.c:(.init.text+0x38): undefined reference to `simd_skcipher_create_compat'

Fixes: 211f41af534a ("crypto: aesbs - Convert to skcipher")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 81348883450d..3251d385fddb 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -91,6 +91,7 @@ config CRYPTO_AES_ARM_BS
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_ARM
 	select CRYPTO_ABLK_HELPER
+	select CRYPTO_SIMD
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
-- 
2.9.0

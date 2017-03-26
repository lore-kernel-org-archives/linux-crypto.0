From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/7] crypto: aes - move crypto_aes_expand_key() to fixed-time AES driver
Date: Sun, 26 Mar 2017 19:49:06 +0100
Message-ID: <1490554148-10953-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:33830 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbdCZS5J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 14:57:09 -0400
Received: by mail-wr0-f179.google.com with SMTP id l43so27331057wre.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 11:57:07 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Both the original generic AES code and the new fixed-time AES driver
contain C implementations of crypto_aes_expand_key() which are
functionally equivalent to each other. However, the former version
pulls in crypto/aes_generic.o in its entirety, consisting of 16 KB
of lookup tables and fully unrolled encrypt and decrypt routines,
none of which are of any interest to most users of crypto_aes_expand_key.

So unexport the version in crypto/aes_generic.o, and export the version
in crypto/aes_ti.o, and fix up all Kconfig dependencies of users of
crypto_aes_expand_key.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   | 2 +-
 arch/arm64/crypto/Kconfig | 2 +-
 crypto/aes_generic.c      | 7 +++----
 crypto/aes_ti.c           | 7 ++++---
 drivers/crypto/Kconfig    | 6 +++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b9adedcc5b2e..d3fab7792eda 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -73,7 +73,7 @@ config CRYPTO_AES_ARM_BS
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
-	select CRYPTO_AES
+	select CRYPTO_AES_TI
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index d92293747d63..e36b671363a3 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -68,7 +68,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_AES_TI
 	select CRYPTO_SIMD
 
 config CRYPTO_CHACHA20_NEON
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index ca554d57d01e..56693e6f4f09 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1201,7 +1201,7 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 } while (0)
 
 /**
- * crypto_aes_expand_key - Expands the AES key as described in FIPS-197
+ * aes_expand_key - Expands the AES key as described in FIPS-197
  * @ctx:	The location where the computed key will be stored.
  * @in_key:	The supplied key.
  * @key_len:	The length of the supplied key.
@@ -1214,7 +1214,7 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
  * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
  * for the initial combination, the second slot for the first round and so on.
  */
-int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+static int aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		unsigned int key_len)
 {
 	u32 i, t, u, v, w, j;
@@ -1271,7 +1271,6 @@ int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
 
 /**
  * crypto_aes_set_key - Set the AES key.
@@ -1291,7 +1290,7 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	u32 *flags = &tfm->crt_flags;
 	int ret;
 
-	ret = crypto_aes_expand_key(ctx, in_key, key_len);
+	ret = aes_expand_key(ctx, in_key, key_len);
 	if (!ret)
 		return 0;
 
diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 92644fd1ac19..a3aae39e3a07 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -167,8 +167,8 @@ static u32 subw(u32 in)
 	       (__aesti_sbox[(in >> 24) & 0xff] << 24);
 }
 
-static int aesti_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-			    unsigned int key_len)
+int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+			  unsigned int key_len)
 {
 	u32 kwords = key_len / sizeof(u32);
 	u32 rc, i, j;
@@ -232,6 +232,7 @@ static int aesti_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
 
 static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			 unsigned int key_len)
@@ -239,7 +240,7 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = aesti_expand_key(ctx, in_key, key_len);
+	err = crypto_aes_expand_key(ctx, in_key, key_len);
 	if (err)
 		return err;
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0ea163122df2..a2e3739ba3bd 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_AES_TI
 	help
 	  Use VIA PadLock for AES algorithm.
 
@@ -189,7 +189,7 @@ config CRYPTO_CRC32_S390
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION
-	select CRYPTO_AES
+	select CRYPTO_AES_TI
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select SRAM
@@ -203,7 +203,7 @@ config CRYPTO_DEV_MV_CESA
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "New Marvell's Cryptographic Engine driver"
 	depends on PLAT_ORION || ARCH_MVEBU
-	select CRYPTO_AES
+	select CRYPTO_AES_TI
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
-- 
2.7.4

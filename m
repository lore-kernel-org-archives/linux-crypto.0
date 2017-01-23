From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 10/10] crypto: arm64/aes - replace scalar fallback with plain NEON fallback
Date: Mon, 23 Jan 2017 14:05:26 +0000
Message-ID: <1485180326-25612-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36083 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdAWOFv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:05:51 -0500
Received: by mail-wm0-f46.google.com with SMTP id c85so134187148wmi.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2017 06:05:50 -0800 (PST)
In-Reply-To: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The new bitsliced NEON implementation of AES uses a fallback in two
places: CBC encryption (which is strictly sequential, whereas this
driver can only operate efficiently on 8 blocks at a time), and the
XTS tweak generation, which involves encrypting a single AES block
with a different key schedule.

The plain (i.e., non-bitsliced) NEON code is more suitable as a fallback,
given that it is faster than scalar on low end cores (which is what
the NEON implementations target, since high end cores have dedicated
instructions for AES), and shows similar behavior in terms of D-cache
footprint and sensitivity to cache timing attacks. So switch the fallback
handling to the plain NEON driver.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           |  2 +-
 arch/arm64/crypto/aes-neonbs-glue.c | 38 ++++++++++++++------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 5de75c3dcbd4..bed7feddfeed 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -86,7 +86,7 @@ config CRYPTO_AES_ARM64_BS
 	tristate "AES in ECB/CBC/CTR/XTS modes using bit-sliced NEON algorithm"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES_ARM64
+	select CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_SIMD
 
 endif
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 323dd76ae5f0..863e436ecf89 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -10,7 +10,6 @@
 
 #include <asm/neon.h>
 #include <crypto/aes.h>
-#include <crypto/cbc.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
@@ -42,7 +41,12 @@ asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
 asmlinkage void aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
 
-asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
+/* borrowed from aes-neon-blk.ko */
+asmlinkage void neon_aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				     int rounds, int blocks, int first);
+asmlinkage void neon_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				     int rounds, int blocks, u8 iv[],
+				     int first);
 
 struct aesbs_ctx {
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32];
@@ -140,16 +144,28 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void cbc_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+static int cbc_encrypt(struct skcipher_request *req)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int err, first = 1;
 
-	__aes_arm64_encrypt(ctx->enc, dst, src, ctx->key.rounds);
-}
+	err = skcipher_walk_virt(&walk, req, true);
 
-static int cbc_encrypt(struct skcipher_request *req)
-{
-	return crypto_cbc_encrypt_walk(req, cbc_encrypt_one);
+	kernel_neon_begin();
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
+
+		/* fall back to the non-bitsliced NEON implementation */
+		neon_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				     ctx->enc, ctx->key.rounds, blocks, walk.iv,
+				     first);
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		first = 0;
+	}
+	kernel_neon_end();
+	return err;
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -254,9 +270,11 @@ static int __xts_crypt(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	__aes_arm64_encrypt(ctx->twkey, walk.iv, walk.iv, ctx->key.rounds);
-
 	kernel_neon_begin();
+
+	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey,
+			     ctx->key.rounds, 1, 1);
+
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
-- 
2.7.4

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/aes-neonbs - resolve fallback cipher at runtime
Date: Tue, 14 Feb 2017 10:03:59 +0000
Message-ID: <1487066640-17886-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35415 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbdBNKEP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 05:04:15 -0500
Received: by mail-wm0-f53.google.com with SMTP id v186so13524817wmd.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 02:04:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, the bit sliced NEON AES code for ARM has a link time
dependency on the scalar ARM asm implementation, which it uses as a
fallback to perform CBC encryption and the encryption of the initial
XTS tweak.

The bit sliced NEON code is both fast and time invariant, which makes
it a reasonable default on hardware that supports it. However, the
ARM asm code it pulls in is not time invariant, and due to the way it
is linked in, cannot be overridden by the new generic time invariant
driver. In fact, it will not be used at all, given that the ARM asm
code registers itself as a cipher with a priority that exceeds the
priority of the fixed time cipher.

So remove the link time dependency, and allocate the fallback cipher
via the crypto API. Note that this requires this driver's module_init
call to be replaced with late_initcall, so that the (possibly generic)
fallback cipher is guaranteed to be available when the builtin test
is performed at registration time.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig           |  2 +-
 arch/arm/crypto/aes-neonbs-glue.c | 65 ++++++++++++++++++++++++++++++---------
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index a8fce93137fb..b9adedcc5b2e 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -73,7 +73,7 @@ config CRYPTO_AES_ARM_BS
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
-	select CRYPTO_AES_ARM
+	select CRYPTO_AES
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 2920b96dbd36..6a2a30b9e4f5 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -42,9 +42,6 @@ asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
 asmlinkage void aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
 
-asmlinkage void __aes_arm_encrypt(const u32 rk[], int rounds, const u8 in[],
-				  u8 out[]);
-
 struct aesbs_ctx {
 	int	rounds;
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32] __aligned(AES_BLOCK_SIZE);
@@ -52,12 +49,12 @@ struct aesbs_ctx {
 
 struct aesbs_cbc_ctx {
 	struct aesbs_ctx	key;
-	u32			enc[AES_MAX_KEYLENGTH_U32];
+	struct crypto_cipher	*enc_tfm;
 };
 
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
-	u32			twkey[AES_MAX_KEYLENGTH_U32];
+	struct crypto_cipher	*tweak_tfm;
 };
 
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -132,20 +129,18 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 
 	ctx->key.rounds = 6 + key_len / 4;
 
-	memcpy(ctx->enc, rk.key_enc, sizeof(ctx->enc));
-
 	kernel_neon_begin();
 	aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
 	kernel_neon_end();
 
-	return 0;
+	return crypto_cipher_setkey(ctx->enc_tfm, in_key, key_len);
 }
 
 static void cbc_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
 {
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	__aes_arm_encrypt(ctx->enc, ctx->key.rounds, src, dst);
+	crypto_cipher_encrypt_one(ctx->enc_tfm, dst, src);
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
@@ -181,6 +176,23 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int cbc_init(struct crypto_tfm *tfm)
+{
+	struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->enc_tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(ctx->enc_tfm))
+		return PTR_ERR(ctx->enc_tfm);
+	return 0;
+}
+
+static void cbc_exit(struct crypto_tfm *tfm)
+{
+	struct aesbs_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_cipher(ctx->enc_tfm);
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -228,7 +240,6 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_aes_ctx rk;
 	int err;
 
 	err = xts_verify_key(tfm, in_key, key_len);
@@ -236,13 +247,33 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	key_len /= 2;
-	err = crypto_aes_expand_key(&rk, in_key + key_len, key_len);
+	err = crypto_cipher_setkey(ctx->tweak_tfm, in_key + key_len, key_len);
 	if (err)
 		return err;
 
-	memcpy(ctx->twkey, rk.key_enc, sizeof(ctx->twkey));
+	err = aesbs_setkey(tfm, in_key, key_len);
+	if (err)
+		return err;
+
+	return 0;
+
+}
+
+static int xts_init(struct crypto_tfm *tfm)
+{
+	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->tweak_tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(ctx->tweak_tfm))
+		return PTR_ERR(ctx->tweak_tfm);
+	return 0;
+}
+
+static void xts_exit(struct crypto_tfm *tfm)
+{
+	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return aesbs_setkey(tfm, in_key, key_len);
+	crypto_free_cipher(ctx->tweak_tfm);
 }
 
 static int __xts_crypt(struct skcipher_request *req,
@@ -256,7 +287,7 @@ static int __xts_crypt(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	__aes_arm_encrypt(ctx->twkey, ctx->key.rounds, walk.iv, walk.iv);
+	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
 
 	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
@@ -309,6 +340,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_init		= cbc_init,
+	.base.cra_exit		= cbc_exit,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
@@ -342,6 +375,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_ctxsize	= sizeof(struct aesbs_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_init		= xts_init,
+	.base.cra_exit		= xts_exit,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
@@ -402,5 +437,5 @@ static int __init aes_init(void)
 	return err;
 }
 
-module_init(aes_init);
+late_initcall(aes_init);
 module_exit(aes_exit);
-- 
2.7.4

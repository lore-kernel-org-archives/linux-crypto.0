From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/4] crypto: arm64/aes - add NEON and Crypto Extension CBC-MAC driver
Date: Thu, 26 Jan 2017 17:17:42 +0000
Message-ID: <1485451063-11822-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1485451063-11822-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38343 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdAZRSF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 12:18:05 -0500
Received: by mail-wm0-f45.google.com with SMTP id r144so95449964wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2017 09:18:05 -0800 (PST)
In-Reply-To: <1485451063-11822-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On ARMv8 implementations that do not support the Crypto Extensions,
such as the Raspberry Pi 3, the CCM driver falls back to the generic
table based AES implementation to perform the MAC part of the
algorithm, which is slow and not time invariant. So add a CBCMAC
implementation to the shared glue code between NEON AES and Crypto
Extensions AES, so that it can be used instead now that the CCM
driver has been updated to look for CBCMAC implementations other
than the one it supplies itself.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 102 ++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S |  19 ++++
 2 files changed, 121 insertions(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 055bc3f61138..1f29570b83e9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -11,6 +11,7 @@
 #include <asm/neon.h>
 #include <asm/hwcap.h>
 #include <crypto/aes.h>
+#include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
@@ -31,6 +32,7 @@
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
+#define aes_cbcmac_update	ce_aes_cbcmac_update
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
@@ -44,11 +46,13 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
+#define aes_cbcmac_update	neon_aes_cbcmac_update
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
+MODULE_ALIAS_CRYPTO("cbcmac(aes)");
 #endif
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
@@ -75,11 +79,19 @@ asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[],
 				int rounds, int blocks, u8 const rk2[], u8 iv[],
 				int first);
 
+asmlinkage void aes_cbcmac_update(u8 const in[], u32 const rk[], int rounds,
+				  int blocks, u8 dg[]);
+
 struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx key1;
 	struct crypto_aes_ctx __aligned(8) key2;
 };
 
+struct cbcmac_desc_ctx {
+	unsigned int len;
+	u8 dg[];
+};
+
 static int skcipher_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			       unsigned int key_len)
 {
@@ -357,6 +369,89 @@ static struct skcipher_alg aes_algs[] = { {
 	.decrypt	= xts_decrypt,
 } };
 
+static int cbcmac_setkey(struct crypto_shash *tfm,
+			 const u8 *in_key, unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_shash_ctx(tfm);
+	int err;
+
+	err = aes_expandkey(ctx, in_key, key_len);
+	if (err)
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return err;
+}
+
+static int cbcmac_init(struct shash_desc *desc)
+{
+	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	memset(ctx->dg, 0, AES_BLOCK_SIZE);
+	ctx->len = 0;
+
+	return 0;
+}
+
+static int cbcmac_update(struct shash_desc *desc, const u8 *p,
+			 unsigned int len)
+{
+	struct crypto_aes_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
+	int rounds = 6 + tctx->key_length / 4;
+
+	while (len--) {
+		ctx->dg[ctx->len++] ^= *p++;
+
+		if (ctx->len == AES_BLOCK_SIZE) {
+			int blocks = len / AES_BLOCK_SIZE;
+
+			kernel_neon_begin();
+			aes_cbcmac_update(p, tctx->key_enc, rounds, blocks,
+					  ctx->dg);
+			kernel_neon_end();
+
+			ctx->len = 0;
+			len %= AES_BLOCK_SIZE;
+			p += blocks * AES_BLOCK_SIZE;
+		}
+	}
+
+	return 0;
+}
+
+static int cbcmac_final(struct shash_desc *desc, u8 *out)
+{
+	struct crypto_aes_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
+	int rounds = 6 + tctx->key_length / 4;
+
+	if (ctx->len) {
+		kernel_neon_begin();
+		aes_cbcmac_update(NULL, tctx->key_enc, rounds, 0, ctx->dg);
+		kernel_neon_end();
+	}
+	memcpy(out, ctx->dg, AES_BLOCK_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg cbcmac_alg = {
+	.base.cra_name		= "cbcmac(aes)",
+	.base.cra_driver_name	= "cbcmac-aes-" MODE,
+	.base.cra_priority	= PRIO,
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= AES_BLOCK_SIZE,
+	.init			= cbcmac_init,
+	.update			= cbcmac_update,
+	.final			= cbcmac_final,
+	.setkey			= cbcmac_setkey,
+	.descsize		= sizeof(struct cbcmac_desc_ctx),
+};
+
 static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
 
 static void aes_exit(void)
@@ -367,6 +462,7 @@ static void aes_exit(void)
 		if (aes_simd_algs[i])
 			simd_skcipher_free(aes_simd_algs[i]);
 
+	crypto_unregister_shash(&cbcmac_alg);
 	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
@@ -383,6 +479,10 @@ static int __init aes_init(void)
 	if (err)
 		return err;
 
+	err = crypto_register_shash(&cbcmac_alg);
+	if (err)
+		goto unregister_ciphers;
+
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
 		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
 			continue;
@@ -402,6 +502,8 @@ static int __init aes_init(void)
 
 unregister_simds:
 	aes_exit();
+unregister_ciphers:
+	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 	return err;
 }
 
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 92b982a8b112..aa96c9691af9 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -525,3 +525,22 @@ AES_ENTRY(aes_xts_decrypt)
 	FRAME_POP
 	ret
 AES_ENDPROC(aes_xts_decrypt)
+
+	/*
+	 * aes_cbcmac_update(u8 const in[], u32 const rk[], int rounds,
+	 *		    int blocks, u8 dg[])
+	 */
+AES_ENTRY(aes_cbcmac_update)
+	ld1		{v0.16b}, [x4]			/* get iv */
+	enc_prepare	w2, x1, x5
+
+.Lcbcmacloop:
+	ld1		{v1.16b}, [x0], #16		/* get next pt block */
+	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
+	encrypt_block	v0, w2, x1, x5, w6
+	subs		w3, w3, #1
+	bne		.Lcbcmacloop
+
+	st1		{v0.16b}, [x4]			/* return iv */
+	ret
+AES_ENDPROC(aes_cbcmac_update)
-- 
2.7.4

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: generic/aes - drop alignment requirement
Date: Thu,  2 Feb 2017 15:58:57 +0000
Message-ID: <1486051137-20511-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers3@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37567 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752034AbdBBP7F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 10:59:05 -0500
Received: by mail-wm0-f41.google.com with SMTP id v77so93882471wmv.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 07:59:04 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The generic AES code exposes a 32-bit align mask, which forces all
users of the code to use temporary buffers or take other measures to
ensure the alignment requirement is adhered to, even on architectures
that don't care about alignment for software algorithms such as this
one.

So drop the align mask, and fix the code to use get_unaligned_le32()
where appropriate, which will resolve to whatever is optimal for the
architecture.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aes_generic.c | 64 ++++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 3dd101144a58..ca554d57d01e 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -54,6 +54,7 @@
 #include <linux/errno.h>
 #include <linux/crypto.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 static inline u8 byte(const u32 x, const unsigned n)
 {
@@ -1216,7 +1217,6 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		unsigned int key_len)
 {
-	const __le32 *key = (const __le32 *)in_key;
 	u32 i, t, u, v, w, j;
 
 	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
@@ -1225,10 +1225,15 @@ int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 
 	ctx->key_length = key_len;
 
-	ctx->key_dec[key_len + 24] = ctx->key_enc[0] = le32_to_cpu(key[0]);
-	ctx->key_dec[key_len + 25] = ctx->key_enc[1] = le32_to_cpu(key[1]);
-	ctx->key_dec[key_len + 26] = ctx->key_enc[2] = le32_to_cpu(key[2]);
-	ctx->key_dec[key_len + 27] = ctx->key_enc[3] = le32_to_cpu(key[3]);
+	ctx->key_enc[0] = get_unaligned_le32(in_key);
+	ctx->key_enc[1] = get_unaligned_le32(in_key + 4);
+	ctx->key_enc[2] = get_unaligned_le32(in_key + 8);
+	ctx->key_enc[3] = get_unaligned_le32(in_key + 12);
+
+	ctx->key_dec[key_len + 24] = ctx->key_enc[0];
+	ctx->key_dec[key_len + 25] = ctx->key_enc[1];
+	ctx->key_dec[key_len + 26] = ctx->key_enc[2];
+	ctx->key_dec[key_len + 27] = ctx->key_enc[3];
 
 	switch (key_len) {
 	case AES_KEYSIZE_128:
@@ -1238,17 +1243,17 @@ int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		break;
 
 	case AES_KEYSIZE_192:
-		ctx->key_enc[4] = le32_to_cpu(key[4]);
-		t = ctx->key_enc[5] = le32_to_cpu(key[5]);
+		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
+		t = ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
 		for (i = 0; i < 8; ++i)
 			loop6(i);
 		break;
 
 	case AES_KEYSIZE_256:
-		ctx->key_enc[4] = le32_to_cpu(key[4]);
-		ctx->key_enc[5] = le32_to_cpu(key[5]);
-		ctx->key_enc[6] = le32_to_cpu(key[6]);
-		t = ctx->key_enc[7] = le32_to_cpu(key[7]);
+		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
+		ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
+		ctx->key_enc[6] = get_unaligned_le32(in_key + 24);
+		t = ctx->key_enc[7] = get_unaligned_le32(in_key + 28);
 		for (i = 0; i < 6; ++i)
 			loop8(i);
 		loop8tophalf(i);
@@ -1329,16 +1334,14 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *src = (const __le32 *)in;
-	__le32 *dst = (__le32 *)out;
 	u32 b0[4], b1[4];
 	const u32 *kp = ctx->key_enc + 4;
 	const int key_len = ctx->key_length;
 
-	b0[0] = le32_to_cpu(src[0]) ^ ctx->key_enc[0];
-	b0[1] = le32_to_cpu(src[1]) ^ ctx->key_enc[1];
-	b0[2] = le32_to_cpu(src[2]) ^ ctx->key_enc[2];
-	b0[3] = le32_to_cpu(src[3]) ^ ctx->key_enc[3];
+	b0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
+	b0[1] = ctx->key_enc[1] ^ get_unaligned_le32(in + 4);
+	b0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
+	b0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
 
 	if (key_len > 24) {
 		f_nround(b1, b0, kp);
@@ -1361,10 +1364,10 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	f_nround(b1, b0, kp);
 	f_lround(b0, b1, kp);
 
-	dst[0] = cpu_to_le32(b0[0]);
-	dst[1] = cpu_to_le32(b0[1]);
-	dst[2] = cpu_to_le32(b0[2]);
-	dst[3] = cpu_to_le32(b0[3]);
+	put_unaligned_le32(b0[0], out);
+	put_unaligned_le32(b0[1], out + 4);
+	put_unaligned_le32(b0[2], out + 8);
+	put_unaligned_le32(b0[3], out + 12);
 }
 
 /* decrypt a block of text */
@@ -1401,16 +1404,14 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *src = (const __le32 *)in;
-	__le32 *dst = (__le32 *)out;
 	u32 b0[4], b1[4];
 	const int key_len = ctx->key_length;
 	const u32 *kp = ctx->key_dec + 4;
 
-	b0[0] = le32_to_cpu(src[0]) ^  ctx->key_dec[0];
-	b0[1] = le32_to_cpu(src[1]) ^  ctx->key_dec[1];
-	b0[2] = le32_to_cpu(src[2]) ^  ctx->key_dec[2];
-	b0[3] = le32_to_cpu(src[3]) ^  ctx->key_dec[3];
+	b0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
+	b0[1] = ctx->key_dec[1] ^ get_unaligned_le32(in + 4);
+	b0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
+	b0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
 
 	if (key_len > 24) {
 		i_nround(b1, b0, kp);
@@ -1433,10 +1434,10 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	i_nround(b1, b0, kp);
 	i_lround(b0, b1, kp);
 
-	dst[0] = cpu_to_le32(b0[0]);
-	dst[1] = cpu_to_le32(b0[1]);
-	dst[2] = cpu_to_le32(b0[2]);
-	dst[3] = cpu_to_le32(b0[3]);
+	put_unaligned_le32(b0[0], out);
+	put_unaligned_le32(b0[1], out + 4);
+	put_unaligned_le32(b0[2], out + 8);
+	put_unaligned_le32(b0[3], out + 12);
 }
 
 static struct crypto_alg aes_alg = {
@@ -1446,7 +1447,6 @@ static struct crypto_alg aes_alg = {
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
-- 
2.7.4

From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 2/3] [crypto] aes_generic: make key generation export able
Date: Sun, 28 Oct 2007 13:25:18 +0100
Message-ID: <E1ImAGE-0006qx-BX@Chamillionaire.breakpoint.cc>
References: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.3.4"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38549 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbXJ1PlM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Oct 2007 11:41:12 -0400
In-Reply-To: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


This patch exports four tables and the set_key() routine. This ressources
can be shared by other AES implementations (aes-x86_64 for instance).
The decryption key has been turned around (deckey[0] is the first piece
of the key instead of deckey[keylen+20]). The encrypt/decrypt functions
are looking now identical (except they are using different tables and
key).

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/aes_generic.c |  249 ++++++++++++++++++++++++--------------------------
 include/crypto/aes.h |   16 +++
 2 files changed, 136 insertions(+), 129 deletions(-)
--------------1.5.3.4
Content-Type: text/x-patch; name="1b03590d6d2583d1b512070b3832986c3467d70d.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="1b03590d6d2583d1b512070b3832986c3467d70d.diff"

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index df8df4d..cf30af7 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -47,11 +47,6 @@
  * ---------------------------------------------------------------------------
  */
 
-/* Some changes from the Gladman version:
-    s/RIJNDAEL(e_key)/E_KEY/g
-    s/RIJNDAEL(d_key)/D_KEY/g
-*/
-
 #include <crypto/aes.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -60,32 +55,26 @@
 #include <linux/crypto.h>
 #include <asm/byteorder.h>
 
-/*
- * #define byte(x, nr) ((unsigned char)((x) >> (nr*8))) 
- */
 static inline u8 byte(const u32 x, const unsigned n)
 {
 	return x >> (n << 3);
 }
 
-struct aes_ctx {
-	int key_length;
-	u32 buf[120];
-};
-
-#define E_KEY (&ctx->buf[0])
-#define D_KEY (&ctx->buf[60])
-
 static u8 pow_tab[256] __initdata;
 static u8 log_tab[256] __initdata;
 static u8 sbx_tab[256] __initdata;
 static u8 isb_tab[256] __initdata;
 static u32 rco_tab[10];
-static u32 ft_tab[4][256];
-static u32 it_tab[4][256];
 
-static u32 fl_tab[4][256];
-static u32 il_tab[4][256];
+u32 crypto_ft_tab[4][256];
+u32 crypto_fl_tab[4][256];
+u32 crypto_it_tab[4][256];
+u32 crypto_il_tab[4][256];
+
+EXPORT_SYMBOL_GPL(crypto_ft_tab);
+EXPORT_SYMBOL_GPL(crypto_fl_tab);
+EXPORT_SYMBOL_GPL(crypto_it_tab);
+EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 static inline u8 __init f_mult(u8 a, u8 b)
 {
@@ -134,37 +123,37 @@ static void __init gen_tabs(void)
 		p = sbx_tab[i];
 
 		t = p;
-		fl_tab[0][i] = t;
-		fl_tab[1][i] = rol32(t, 8);
-		fl_tab[2][i] = rol32(t, 16);
-		fl_tab[3][i] = rol32(t, 24);
+		crypto_fl_tab[0][i] = t;
+		crypto_fl_tab[1][i] = rol32(t, 8);
+		crypto_fl_tab[2][i] = rol32(t, 16);
+		crypto_fl_tab[3][i] = rol32(t, 24);
 
 		t = ((u32) ff_mult(2, p)) |
 		    ((u32) p << 8) |
 		    ((u32) p << 16) | ((u32) ff_mult(3, p) << 24);
 
-		ft_tab[0][i] = t;
-		ft_tab[1][i] = rol32(t, 8);
-		ft_tab[2][i] = rol32(t, 16);
-		ft_tab[3][i] = rol32(t, 24);
+		crypto_ft_tab[0][i] = t;
+		crypto_ft_tab[1][i] = rol32(t, 8);
+		crypto_ft_tab[2][i] = rol32(t, 16);
+		crypto_ft_tab[3][i] = rol32(t, 24);
 
 		p = isb_tab[i];
 
 		t = p;
-		il_tab[0][i] = t;
-		il_tab[1][i] = rol32(t, 8);
-		il_tab[2][i] = rol32(t, 16);
-		il_tab[3][i] = rol32(t, 24);
+		crypto_il_tab[0][i] = t;
+		crypto_il_tab[1][i] = rol32(t, 8);
+		crypto_il_tab[2][i] = rol32(t, 16);
+		crypto_il_tab[3][i] = rol32(t, 24);
 
 		t = ((u32) ff_mult(14, p)) |
 		    ((u32) ff_mult(9, p) << 8) |
 		    ((u32) ff_mult(13, p) << 16) |
 		    ((u32) ff_mult(11, p) << 24);
 
-		it_tab[0][i] = t;
-		it_tab[1][i] = rol32(t, 8);
-		it_tab[2][i] = rol32(t, 16);
-		it_tab[3][i] = rol32(t, 24);
+		crypto_it_tab[0][i] = t;
+		crypto_it_tab[1][i] = rol32(t, 8);
+		crypto_it_tab[2][i] = rol32(t, 16);
+		crypto_it_tab[3][i] = rol32(t, 24);
 	}
 }
 
@@ -184,69 +173,69 @@ static void __init gen_tabs(void)
 } while (0)
 
 #define ls_box(x)		\
-	fl_tab[0][byte(x, 0)] ^	\
-	fl_tab[1][byte(x, 1)] ^	\
-	fl_tab[2][byte(x, 2)] ^	\
-	fl_tab[3][byte(x, 3)]
+	crypto_fl_tab[0][byte(x, 0)] ^	\
+	crypto_fl_tab[1][byte(x, 1)] ^	\
+	crypto_fl_tab[2][byte(x, 2)] ^	\
+	crypto_fl_tab[3][byte(x, 3)]
 
 #define loop4(i)	do {		\
 	t = ror32(t, 8);		\
 	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= E_KEY[4 * i];		\
-	E_KEY[4 * i + 4] = t;		\
-	t ^= E_KEY[4 * i + 1];		\
-	E_KEY[4 * i + 5] = t;		\
-	t ^= E_KEY[4 * i + 2];		\
-	E_KEY[4 * i + 6] = t;		\
-	t ^= E_KEY[4 * i + 3];		\
-	E_KEY[4 * i + 7] = t;		\
+	t ^= ctx->key_enc[4 * i];		\
+	ctx->key_enc[4 * i + 4] = t;		\
+	t ^= ctx->key_enc[4 * i + 1];		\
+	ctx->key_enc[4 * i + 5] = t;		\
+	t ^= ctx->key_enc[4 * i + 2];		\
+	ctx->key_enc[4 * i + 6] = t;		\
+	t ^= ctx->key_enc[4 * i + 3];		\
+	ctx->key_enc[4 * i + 7] = t;		\
 } while (0)
 
 #define loop6(i)	do {		\
 	t = ror32(t, 8);		\
 	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= E_KEY[6 * i];		\
-	E_KEY[6 * i + 6] = t;		\
-	t ^= E_KEY[6 * i + 1];		\
-	E_KEY[6 * i + 7] = t;		\
-	t ^= E_KEY[6 * i + 2];		\
-	E_KEY[6 * i + 8] = t;		\
-	t ^= E_KEY[6 * i + 3];		\
-	E_KEY[6 * i + 9] = t;		\
-	t ^= E_KEY[6 * i + 4];		\
-	E_KEY[6 * i + 10] = t;		\
-	t ^= E_KEY[6 * i + 5];		\
-	E_KEY[6 * i + 11] = t;		\
+	t ^= ctx->key_enc[6 * i];		\
+	ctx->key_enc[6 * i + 6] = t;		\
+	t ^= ctx->key_enc[6 * i + 1];		\
+	ctx->key_enc[6 * i + 7] = t;		\
+	t ^= ctx->key_enc[6 * i + 2];		\
+	ctx->key_enc[6 * i + 8] = t;		\
+	t ^= ctx->key_enc[6 * i + 3];		\
+	ctx->key_enc[6 * i + 9] = t;		\
+	t ^= ctx->key_enc[6 * i + 4];		\
+	ctx->key_enc[6 * i + 10] = t;		\
+	t ^= ctx->key_enc[6 * i + 5];		\
+	ctx->key_enc[6 * i + 11] = t;		\
 } while (0)
 
 #define loop8(i)	do {			\
 	t = ror32(t, 8);			\
 	t = ls_box(t) ^ rco_tab[i];		\
-	t ^= E_KEY[8 * i];			\
-	E_KEY[8 * i + 8] = t;			\
-	t ^= E_KEY[8 * i + 1];			\
-	E_KEY[8 * i + 9] = t;			\
-	t ^= E_KEY[8 * i + 2];			\
-	E_KEY[8 * i + 10] = t;			\
-	t ^= E_KEY[8 * i + 3];			\
-	E_KEY[8 * i + 11] = t;			\
-	t  = E_KEY[8 * i + 4] ^ ls_box(t);	\
-	E_KEY[8 * i + 12] = t;			\
-	t ^= E_KEY[8 * i + 5];			\
-	E_KEY[8 * i + 13] = t;			\
-	t ^= E_KEY[8 * i + 6];			\
-	E_KEY[8 * i + 14] = t;			\
-	t ^= E_KEY[8 * i + 7];			\
-	E_KEY[8 * i + 15] = t;			\
+	t ^= ctx->key_enc[8 * i];			\
+	ctx->key_enc[8 * i + 8] = t;			\
+	t ^= ctx->key_enc[8 * i + 1];			\
+	ctx->key_enc[8 * i + 9] = t;			\
+	t ^= ctx->key_enc[8 * i + 2];			\
+	ctx->key_enc[8 * i + 10] = t;			\
+	t ^= ctx->key_enc[8 * i + 3];			\
+	ctx->key_enc[8 * i + 11] = t;			\
+	t  = ctx->key_enc[8 * i + 4] ^ ls_box(t);	\
+	ctx->key_enc[8 * i + 12] = t;			\
+	t ^= ctx->key_enc[8 * i + 5];			\
+	ctx->key_enc[8 * i + 13] = t;			\
+	t ^= ctx->key_enc[8 * i + 6];			\
+	ctx->key_enc[8 * i + 14] = t;			\
+	t ^= ctx->key_enc[8 * i + 7];			\
+	ctx->key_enc[8 * i + 15] = t;			\
 } while (0)
 
-static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len)
 {
-	struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
 	u32 *flags = &tfm->crt_flags;
-	u32 i, t, u, v, w;
+	u32 i, t, u, v, w, j;
 
 	if (key_len % 8) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -255,54 +244,55 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 	ctx->key_length = key_len;
 
-	E_KEY[0] = le32_to_cpu(key[0]);
-	E_KEY[1] = le32_to_cpu(key[1]);
-	E_KEY[2] = le32_to_cpu(key[2]);
-	E_KEY[3] = le32_to_cpu(key[3]);
+	ctx->key_dec[key_len + 24] = ctx->key_enc[0] = le32_to_cpu(key[0]);
+	ctx->key_dec[key_len + 25] = ctx->key_enc[1] = le32_to_cpu(key[1]);
+	ctx->key_dec[key_len + 26] = ctx->key_enc[2] = le32_to_cpu(key[2]);
+	ctx->key_dec[key_len + 27] = ctx->key_enc[3] = le32_to_cpu(key[3]);
 
 	switch (key_len) {
 	case 16:
-		t = E_KEY[3];
+		t = ctx->key_enc[3];
 		for (i = 0; i < 10; ++i)
 			loop4(i);
 		break;
 
 	case 24:
-		E_KEY[4] = le32_to_cpu(key[4]);
-		t = E_KEY[5] = le32_to_cpu(key[5]);
+		ctx->key_enc[4] = le32_to_cpu(key[4]);
+		t = ctx->key_enc[5] = le32_to_cpu(key[5]);
 		for (i = 0; i < 8; ++i)
 			loop6(i);
 		break;
 
 	case 32:
-		E_KEY[4] = le32_to_cpu(key[4]);
-		E_KEY[5] = le32_to_cpu(key[5]);
-		E_KEY[6] = le32_to_cpu(key[6]);
-		t = E_KEY[7] = le32_to_cpu(key[7]);
+		ctx->key_enc[4] = le32_to_cpu(key[4]);
+		ctx->key_enc[5] = le32_to_cpu(key[5]);
+		ctx->key_enc[6] = le32_to_cpu(key[6]);
+		t = ctx->key_enc[7] = le32_to_cpu(key[7]);
 		for (i = 0; i < 7; ++i)
 			loop8(i);
 		break;
 	}
 
-	D_KEY[0] = E_KEY[0];
-	D_KEY[1] = E_KEY[1];
-	D_KEY[2] = E_KEY[2];
-	D_KEY[3] = E_KEY[3];
+	ctx->key_dec[0] = ctx->key_enc[key_len + 24];
+	ctx->key_dec[1] = ctx->key_enc[key_len + 25];
+	ctx->key_dec[2] = ctx->key_enc[key_len + 26];
+	ctx->key_dec[3] = ctx->key_enc[key_len + 27];
 
 	for (i = 4; i < key_len + 24; ++i) {
-		imix_col(D_KEY[i], E_KEY[i]);
+		j = key_len + 24 - (i & ~3) + (i & 3);
+		imix_col(ctx->key_dec[j], ctx->key_enc[i]);
 	}
-
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 
 /* encrypt a block of text */
 
 #define f_rn(bo, bi, n, k)	do {				\
-	bo[n] = ft_tab[0][byte(bi[n], 0)] ^			\
-		ft_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
-		ft_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		ft_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+	bo[n] = crypto_ft_tab[0][byte(bi[n], 0)] ^			\
+		crypto_ft_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
+		crypto_ft_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		crypto_ft_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
 } while (0)
 
 #define f_nround(bo, bi, k)	do {\
@@ -314,10 +304,10 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 } while (0)
 
 #define f_rl(bo, bi, n, k)	do {				\
-	bo[n] = fl_tab[0][byte(bi[n], 0)] ^			\
-		fl_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
-		fl_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		fl_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+	bo[n] = crypto_fl_tab[0][byte(bi[n], 0)] ^			\
+		crypto_fl_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
+		crypto_fl_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		crypto_fl_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
 } while (0)
 
 #define f_lround(bo, bi, k)	do {\
@@ -329,23 +319,24 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
 	__le32 *dst = (__le32 *)out;
 	u32 b0[4], b1[4];
-	const u32 *kp = E_KEY + 4;
+	const u32 *kp = ctx->key_enc + 4;
+	const int key_len = ctx->key_length;
 
-	b0[0] = le32_to_cpu(src[0]) ^ E_KEY[0];
-	b0[1] = le32_to_cpu(src[1]) ^ E_KEY[1];
-	b0[2] = le32_to_cpu(src[2]) ^ E_KEY[2];
-	b0[3] = le32_to_cpu(src[3]) ^ E_KEY[3];
+	b0[0] = le32_to_cpu(src[0]) ^ ctx->key_enc[0];
+	b0[1] = le32_to_cpu(src[1]) ^ ctx->key_enc[1];
+	b0[2] = le32_to_cpu(src[2]) ^ ctx->key_enc[2];
+	b0[3] = le32_to_cpu(src[3]) ^ ctx->key_enc[3];
 
-	if (ctx->key_length > 24) {
+	if (key_len > 24) {
 		f_nround(b1, b0, kp);
 		f_nround(b0, b1, kp);
 	}
 
-	if (ctx->key_length > 16) {
+	if (key_len > 16) {
 		f_nround(b1, b0, kp);
 		f_nround(b0, b1, kp);
 	}
@@ -370,10 +361,10 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 /* decrypt a block of text */
 
 #define i_rn(bo, bi, n, k)	do {				\
-	bo[n] = it_tab[0][byte(bi[n], 0)] ^			\
-		it_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
-		it_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		it_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+	bo[n] = crypto_it_tab[0][byte(bi[n], 0)] ^			\
+		crypto_it_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
+		crypto_it_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		crypto_it_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
 } while (0)
 
 #define i_nround(bo, bi, k)	do {\
@@ -381,14 +372,14 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	i_rn(bo, bi, 1, k);	\
 	i_rn(bo, bi, 2, k);	\
 	i_rn(bo, bi, 3, k);	\
-	k -= 4;			\
+	k += 4;			\
 } while (0)
 
 #define i_rl(bo, bi, n, k)	do {			\
-	bo[n] = il_tab[0][byte(bi[n], 0)] ^		\
-	il_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
-	il_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-	il_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+	bo[n] = crypto_il_tab[0][byte(bi[n], 0)] ^		\
+	crypto_il_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
+	crypto_il_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+	crypto_il_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
 } while (0)
 
 #define i_lround(bo, bi, k)	do {\
@@ -400,17 +391,17 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
 	__le32 *dst = (__le32 *)out;
 	u32 b0[4], b1[4];
 	const int key_len = ctx->key_length;
-	const u32 *kp = D_KEY + key_len + 20;
+	const u32 *kp = ctx->key_dec + 4;
 
-	b0[0] = le32_to_cpu(src[0]) ^ E_KEY[key_len + 24];
-	b0[1] = le32_to_cpu(src[1]) ^ E_KEY[key_len + 25];
-	b0[2] = le32_to_cpu(src[2]) ^ E_KEY[key_len + 26];
-	b0[3] = le32_to_cpu(src[3]) ^ E_KEY[key_len + 27];
+	b0[0] = le32_to_cpu(src[0]) ^  ctx->key_dec[0];
+	b0[1] = le32_to_cpu(src[1]) ^  ctx->key_dec[1];
+	b0[2] = le32_to_cpu(src[2]) ^  ctx->key_dec[2];
+	b0[3] = le32_to_cpu(src[3]) ^  ctx->key_dec[3];
 
 	if (key_len > 24) {
 		i_nround(b1, b0, kp);
@@ -445,7 +436,7 @@ static struct crypto_alg aes_alg = {
 	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
+	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
@@ -453,7 +444,7 @@ static struct crypto_alg aes_alg = {
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		=	aes_set_key,
+			.cia_setkey		=	crypto_aes_set_key,
 			.cia_encrypt		=	aes_encrypt,
 			.cia_decrypt		=	aes_decrypt
 		}
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 9ff842f..d480b76 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -5,6 +5,9 @@
 #ifndef _CRYPTO_AES_H
 #define _CRYPTO_AES_H
 
+#include <linux/types.h>
+#include <linux/crypto.h>
+
 #define AES_MIN_KEY_SIZE	16
 #define AES_MAX_KEY_SIZE	32
 #define AES_KEYSIZE_128		16
@@ -12,4 +15,17 @@
 #define AES_KEYSIZE_256		32
 #define AES_BLOCK_SIZE		16
 
+struct crypto_aes_ctx {
+	u32 key_length;
+	u32 key_enc[60];
+	u32 key_dec[60];
+};
+
+extern u32 crypto_ft_tab[4][256];
+extern u32 crypto_fl_tab[4][256];
+extern u32 crypto_it_tab[4][256];
+extern u32 crypto_il_tab[4][256];
+
+int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		unsigned int key_len);
 #endif

--------------1.5.3.4--

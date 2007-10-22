From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 2/3] [crypto] generic AES use new common module
Date: Mon, 22 Oct 2007 19:22:13 +0200
Message-ID: <1193073734-15789-3-git-send-email-linux-crypto@ml.breakpoint.cc>
References: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53746 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbXJVRWR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 13:22:17 -0400
In-Reply-To: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

Share the tables and set_key function.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig       |    1 +
 crypto/aes_generic.c |  281 ++++++--------------------------------------------
 2 files changed, 35 insertions(+), 247 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 26130d0..17b11b8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -308,6 +308,7 @@ config CRYPTO_SERPENT
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES_COMMON
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 6683260..fc827cd 100644
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
@@ -69,236 +64,29 @@ byte(const u32 x, const unsigned n)
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
-static u8 pow_tab[256] __initdata;
-static u8 log_tab[256] __initdata;
-static u8 sbx_tab[256] __initdata;
-static u8 isb_tab[256] __initdata;
-static u32 rco_tab[10];
-static u32 ft_tab[4][256];
-static u32 it_tab[4][256];
-
-static u32 fl_tab[4][256];
-static u32 il_tab[4][256];
-
-static inline u8 __init
-f_mult (u8 a, u8 b)
-{
-	u8 aa = log_tab[a], cc = aa + log_tab[b];
-
-	return pow_tab[cc + (cc < aa ? 1 : 0)];
-}
-
-#define ff_mult(a,b)    (a && b ? f_mult(a, b) : 0)
-
 #define f_rn(bo, bi, n, k)					\
-    bo[n] =  ft_tab[0][byte(bi[n],0)] ^				\
-             ft_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
-             ft_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             ft_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
+    bo[n] =  crypto_ft_tab[0][byte(bi[n],0)] ^				\
+             crypto_ft_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
+             crypto_ft_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
+             crypto_ft_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
 
 #define i_rn(bo, bi, n, k)					\
-    bo[n] =  it_tab[0][byte(bi[n],0)] ^				\
-             it_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
-             it_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             it_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
-
-#define ls_box(x)				\
-    ( fl_tab[0][byte(x, 0)] ^			\
-      fl_tab[1][byte(x, 1)] ^			\
-      fl_tab[2][byte(x, 2)] ^			\
-      fl_tab[3][byte(x, 3)] )
+    bo[n] =  crypto_it_tab[0][byte(bi[n],0)] ^				\
+             crypto_it_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
+             crypto_it_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
+             crypto_it_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
 
 #define f_rl(bo, bi, n, k)					\
-    bo[n] =  fl_tab[0][byte(bi[n],0)] ^				\
-             fl_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
-             fl_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             fl_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
+    bo[n] =  crypto_fl_tab[0][byte(bi[n],0)] ^				\
+             crypto_fl_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
+             crypto_fl_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
+             crypto_fl_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
 
 #define i_rl(bo, bi, n, k)					\
-    bo[n] =  il_tab[0][byte(bi[n],0)] ^				\
-             il_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
-             il_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             il_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
-
-static void __init
-gen_tabs (void)
-{
-	u32 i, t;
-	u8 p, q;
-
-	/* log and power tables for GF(2**8) finite field with
-	   0x011b as modular polynomial - the simplest primitive
-	   root is 0x03, used here to generate the tables */
-
-	for (i = 0, p = 1; i < 256; ++i) {
-		pow_tab[i] = (u8) p;
-		log_tab[p] = (u8) i;
-
-		p ^= (p << 1) ^ (p & 0x80 ? 0x01b : 0);
-	}
-
-	log_tab[1] = 0;
-
-	for (i = 0, p = 1; i < 10; ++i) {
-		rco_tab[i] = p;
-
-		p = (p << 1) ^ (p & 0x80 ? 0x01b : 0);
-	}
-
-	for (i = 0; i < 256; ++i) {
-		p = (i ? pow_tab[255 - log_tab[i]] : 0);
-		q = ((p >> 7) | (p << 1)) ^ ((p >> 6) | (p << 2));
-		p ^= 0x63 ^ q ^ ((q >> 6) | (q << 2));
-		sbx_tab[i] = p;
-		isb_tab[p] = (u8) i;
-	}
-
-	for (i = 0; i < 256; ++i) {
-		p = sbx_tab[i];
-
-		t = p;
-		fl_tab[0][i] = t;
-		fl_tab[1][i] = rol32(t, 8);
-		fl_tab[2][i] = rol32(t, 16);
-		fl_tab[3][i] = rol32(t, 24);
-
-		t = ((u32) ff_mult (2, p)) |
-		    ((u32) p << 8) |
-		    ((u32) p << 16) | ((u32) ff_mult (3, p) << 24);
-
-		ft_tab[0][i] = t;
-		ft_tab[1][i] = rol32(t, 8);
-		ft_tab[2][i] = rol32(t, 16);
-		ft_tab[3][i] = rol32(t, 24);
-
-		p = isb_tab[i];
-
-		t = p;
-		il_tab[0][i] = t;
-		il_tab[1][i] = rol32(t, 8);
-		il_tab[2][i] = rol32(t, 16);
-		il_tab[3][i] = rol32(t, 24);
-
-		t = ((u32) ff_mult (14, p)) |
-		    ((u32) ff_mult (9, p) << 8) |
-		    ((u32) ff_mult (13, p) << 16) |
-		    ((u32) ff_mult (11, p) << 24);
-
-		it_tab[0][i] = t;
-		it_tab[1][i] = rol32(t, 8);
-		it_tab[2][i] = rol32(t, 16);
-		it_tab[3][i] = rol32(t, 24);
-	}
-}
-
-#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
-
-#define imix_col(y,x)       \
-    u   = star_x(x);        \
-    v   = star_x(u);        \
-    w   = star_x(v);        \
-    t   = w ^ (x);          \
-   (y)  = u ^ v ^ w;        \
-   (y) ^= ror32(u ^ t,  8) ^ \
-          ror32(v ^ t, 16) ^ \
-          ror32(t,24)
-
-/* initialise the key schedule from the user supplied key */
-
-#define loop4(i)                                    \
-{   t = ror32(t,  8); t = ls_box(t) ^ rco_tab[i];    \
-    t ^= E_KEY[4 * i];     E_KEY[4 * i + 4] = t;    \
-    t ^= E_KEY[4 * i + 1]; E_KEY[4 * i + 5] = t;    \
-    t ^= E_KEY[4 * i + 2]; E_KEY[4 * i + 6] = t;    \
-    t ^= E_KEY[4 * i + 3]; E_KEY[4 * i + 7] = t;    \
-}
-
-#define loop6(i)                                    \
-{   t = ror32(t,  8); t = ls_box(t) ^ rco_tab[i];    \
-    t ^= E_KEY[6 * i];     E_KEY[6 * i + 6] = t;    \
-    t ^= E_KEY[6 * i + 1]; E_KEY[6 * i + 7] = t;    \
-    t ^= E_KEY[6 * i + 2]; E_KEY[6 * i + 8] = t;    \
-    t ^= E_KEY[6 * i + 3]; E_KEY[6 * i + 9] = t;    \
-    t ^= E_KEY[6 * i + 4]; E_KEY[6 * i + 10] = t;   \
-    t ^= E_KEY[6 * i + 5]; E_KEY[6 * i + 11] = t;   \
-}
-
-#define loop8(i)                                    \
-{   t = ror32(t,  8); ; t = ls_box(t) ^ rco_tab[i];  \
-    t ^= E_KEY[8 * i];     E_KEY[8 * i + 8] = t;    \
-    t ^= E_KEY[8 * i + 1]; E_KEY[8 * i + 9] = t;    \
-    t ^= E_KEY[8 * i + 2]; E_KEY[8 * i + 10] = t;   \
-    t ^= E_KEY[8 * i + 3]; E_KEY[8 * i + 11] = t;   \
-    t  = E_KEY[8 * i + 4] ^ ls_box(t);    \
-    E_KEY[8 * i + 12] = t;                \
-    t ^= E_KEY[8 * i + 5]; E_KEY[8 * i + 13] = t;   \
-    t ^= E_KEY[8 * i + 6]; E_KEY[8 * i + 14] = t;   \
-    t ^= E_KEY[8 * i + 7]; E_KEY[8 * i + 15] = t;   \
-}
-
-static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len)
-{
-	struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *key = (const __le32 *)in_key;
-	u32 *flags = &tfm->crt_flags;
-	u32 i, t, u, v, w;
-
-	if (key_len % 8) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
-	ctx->key_length = key_len;
-
-	E_KEY[0] = le32_to_cpu(key[0]);
-	E_KEY[1] = le32_to_cpu(key[1]);
-	E_KEY[2] = le32_to_cpu(key[2]);
-	E_KEY[3] = le32_to_cpu(key[3]);
-
-	switch (key_len) {
-	case 16:
-		t = E_KEY[3];
-		for (i = 0; i < 10; ++i)
-			loop4 (i);
-		break;
-
-	case 24:
-		E_KEY[4] = le32_to_cpu(key[4]);
-		t = E_KEY[5] = le32_to_cpu(key[5]);
-		for (i = 0; i < 8; ++i)
-			loop6 (i);
-		break;
-
-	case 32:
-		E_KEY[4] = le32_to_cpu(key[4]);
-		E_KEY[5] = le32_to_cpu(key[5]);
-		E_KEY[6] = le32_to_cpu(key[6]);
-		t = E_KEY[7] = le32_to_cpu(key[7]);
-		for (i = 0; i < 7; ++i)
-			loop8 (i);
-		break;
-	}
-
-	D_KEY[0] = E_KEY[0];
-	D_KEY[1] = E_KEY[1];
-	D_KEY[2] = E_KEY[2];
-	D_KEY[3] = E_KEY[3];
-
-	for (i = 4; i < key_len + 24; ++i) {
-		imix_col (D_KEY[i], E_KEY[i]);
-	}
-
-	return 0;
-}
+    bo[n] =  crypto_il_tab[0][byte(bi[n],0)] ^				\
+             crypto_il_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
+             crypto_il_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
+             crypto_il_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
 
 /* encrypt a block of text */
 
@@ -317,23 +105,24 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *src = (const __le32 *)in;
 	__le32 *dst = (__le32 *)out;
 	u32 b0[4], b1[4];
-	const u32 *kp = E_KEY + 4;
+	const int key_len = ctx->key_length;
+	const u32 *kp = ctx->key_enc + 4;
 
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
 		f_nround (b1, b0, kp);
 		f_nround (b0, b1, kp);
 	}
 
-	if (ctx->key_length > 16) {
+	if (key_len > 16) {
 		f_nround (b1, b0, kp);
 		f_nround (b0, b1, kp);
 	}
@@ -362,7 +151,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
     i_rn(bo, bi, 1, k);     \
     i_rn(bo, bi, 2, k);     \
     i_rn(bo, bi, 3, k);     \
-    k -= 4
+    k += 4
 
 #define i_lround(bo, bi, k) \
     i_rl(bo, bi, 0, k);     \
@@ -372,17 +161,17 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
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
+	b0[0] = le32_to_cpu(src[0]) ^ ctx->key_dec[0];
+	b0[1] = le32_to_cpu(src[1]) ^ ctx->key_dec[1];
+	b0[2] = le32_to_cpu(src[2]) ^ ctx->key_dec[2];
+	b0[3] = le32_to_cpu(src[3]) ^ ctx->key_dec[3];
 
 	if (key_len > 24) {
 		i_nround (b1, b0, kp);
@@ -411,14 +200,13 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[3] = cpu_to_le32(b0[3]);
 }
 
-
 static struct crypto_alg aes_alg = {
 	.cra_name		=	"aes",
 	.cra_driver_name	=	"aes-generic",
 	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
+	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
@@ -426,7 +214,7 @@ static struct crypto_alg aes_alg = {
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey	   	= 	aes_set_key,
+			.cia_setkey		=	crypto_aes_set_key,
 			.cia_encrypt	 	=	aes_encrypt,
 			.cia_decrypt	  	=	aes_decrypt
 		}
@@ -435,7 +223,6 @@ static struct crypto_alg aes_alg = {
 
 static int __init aes_init(void)
 {
-	gen_tabs();
 	return crypto_register_alg(&aes_alg);
 }
 
-- 
1.5.3.4

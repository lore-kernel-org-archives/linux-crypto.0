From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/3] [crypto] aes_generic coding style cleanup
Date: Sun, 28 Oct 2007 12:50:17 +0100
Message-ID: <E1ImAG8-0006qq-73@Chamillionaire.breakpoint.cc>
References: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.3.4"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38547 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbXJ1PlF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Oct 2007 11:41:05 -0400
In-Reply-To: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/aes_generic.c |  325 +++++++++++++++++++++++++++-----------------------
 1 files changed, 176 insertions(+), 149 deletions(-)
--------------1.5.3.4
Content-Type: text/x-patch; name="d8a5da7eb76091108f7ab821be966ba6185393c3.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="d8a5da7eb76091108f7ab821be966ba6185393c3.diff"

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 6683260..df8df4d 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -63,8 +63,7 @@
 /*
  * #define byte(x, nr) ((unsigned char)((x) >> (nr*8))) 
  */
-static inline u8
-byte(const u32 x, const unsigned n)
+static inline u8 byte(const u32 x, const unsigned n)
 {
 	return x >> (n << 3);
 }
@@ -88,55 +87,25 @@ static u32 it_tab[4][256];
 static u32 fl_tab[4][256];
 static u32 il_tab[4][256];
 
-static inline u8 __init
-f_mult (u8 a, u8 b)
+static inline u8 __init f_mult(u8 a, u8 b)
 {
 	u8 aa = log_tab[a], cc = aa + log_tab[b];
 
 	return pow_tab[cc + (cc < aa ? 1 : 0)];
 }
 
-#define ff_mult(a,b)    (a && b ? f_mult(a, b) : 0)
-
-#define f_rn(bo, bi, n, k)					\
-    bo[n] =  ft_tab[0][byte(bi[n],0)] ^				\
-             ft_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
-             ft_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             ft_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
-
-#define i_rn(bo, bi, n, k)					\
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
-
-#define f_rl(bo, bi, n, k)					\
-    bo[n] =  fl_tab[0][byte(bi[n],0)] ^				\
-             fl_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
-             fl_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             fl_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
-
-#define i_rl(bo, bi, n, k)					\
-    bo[n] =  il_tab[0][byte(bi[n],0)] ^				\
-             il_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
-             il_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
-             il_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
-
-static void __init
-gen_tabs (void)
+#define ff_mult(a, b)	(a && b ? f_mult(a, b) : 0)
+
+static void __init gen_tabs(void)
 {
 	u32 i, t;
 	u8 p, q;
 
-	/* log and power tables for GF(2**8) finite field with
-	   0x011b as modular polynomial - the simplest primitive
-	   root is 0x03, used here to generate the tables */
+	/*
+	 * log and power tables for GF(2**8) finite field with
+	 * 0x011b as modular polynomial - the simplest primitive
+	 * root is 0x03, used here to generate the tables
+	 */
 
 	for (i = 0, p = 1; i < 256; ++i) {
 		pow_tab[i] = (u8) p;
@@ -170,9 +139,9 @@ gen_tabs (void)
 		fl_tab[2][i] = rol32(t, 16);
 		fl_tab[3][i] = rol32(t, 24);
 
-		t = ((u32) ff_mult (2, p)) |
+		t = ((u32) ff_mult(2, p)) |
 		    ((u32) p << 8) |
-		    ((u32) p << 16) | ((u32) ff_mult (3, p) << 24);
+		    ((u32) p << 16) | ((u32) ff_mult(3, p) << 24);
 
 		ft_tab[0][i] = t;
 		ft_tab[1][i] = rol32(t, 8);
@@ -187,10 +156,10 @@ gen_tabs (void)
 		il_tab[2][i] = rol32(t, 16);
 		il_tab[3][i] = rol32(t, 24);
 
-		t = ((u32) ff_mult (14, p)) |
-		    ((u32) ff_mult (9, p) << 8) |
-		    ((u32) ff_mult (13, p) << 16) |
-		    ((u32) ff_mult (11, p) << 24);
+		t = ((u32) ff_mult(14, p)) |
+		    ((u32) ff_mult(9, p) << 8) |
+		    ((u32) ff_mult(13, p) << 16) |
+		    ((u32) ff_mult(11, p) << 24);
 
 		it_tab[0][i] = t;
 		it_tab[1][i] = rol32(t, 8);
@@ -199,53 +168,80 @@ gen_tabs (void)
 	}
 }
 
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
 /* initialise the key schedule from the user supplied key */
 
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
+#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
 
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
+#define imix_col(y,x)	do {		\
+	u	= star_x(x);		\
+	v	= star_x(u);		\
+	w	= star_x(v);		\
+	t	= w ^ (x);		\
+	(y)	= u ^ v ^ w;		\
+	(y)	^= ror32(u ^ t, 8) ^	\
+		ror32(v ^ t, 16) ^	\
+		ror32(t, 24);		\
+} while (0)
+
+#define ls_box(x)		\
+	fl_tab[0][byte(x, 0)] ^	\
+	fl_tab[1][byte(x, 1)] ^	\
+	fl_tab[2][byte(x, 2)] ^	\
+	fl_tab[3][byte(x, 3)]
+
+#define loop4(i)	do {		\
+	t = ror32(t, 8);		\
+	t = ls_box(t) ^ rco_tab[i];	\
+	t ^= E_KEY[4 * i];		\
+	E_KEY[4 * i + 4] = t;		\
+	t ^= E_KEY[4 * i + 1];		\
+	E_KEY[4 * i + 5] = t;		\
+	t ^= E_KEY[4 * i + 2];		\
+	E_KEY[4 * i + 6] = t;		\
+	t ^= E_KEY[4 * i + 3];		\
+	E_KEY[4 * i + 7] = t;		\
+} while (0)
+
+#define loop6(i)	do {		\
+	t = ror32(t, 8);		\
+	t = ls_box(t) ^ rco_tab[i];	\
+	t ^= E_KEY[6 * i];		\
+	E_KEY[6 * i + 6] = t;		\
+	t ^= E_KEY[6 * i + 1];		\
+	E_KEY[6 * i + 7] = t;		\
+	t ^= E_KEY[6 * i + 2];		\
+	E_KEY[6 * i + 8] = t;		\
+	t ^= E_KEY[6 * i + 3];		\
+	E_KEY[6 * i + 9] = t;		\
+	t ^= E_KEY[6 * i + 4];		\
+	E_KEY[6 * i + 10] = t;		\
+	t ^= E_KEY[6 * i + 5];		\
+	E_KEY[6 * i + 11] = t;		\
+} while (0)
+
+#define loop8(i)	do {			\
+	t = ror32(t, 8);			\
+	t = ls_box(t) ^ rco_tab[i];		\
+	t ^= E_KEY[8 * i];			\
+	E_KEY[8 * i + 8] = t;			\
+	t ^= E_KEY[8 * i + 1];			\
+	E_KEY[8 * i + 9] = t;			\
+	t ^= E_KEY[8 * i + 2];			\
+	E_KEY[8 * i + 10] = t;			\
+	t ^= E_KEY[8 * i + 3];			\
+	E_KEY[8 * i + 11] = t;			\
+	t  = E_KEY[8 * i + 4] ^ ls_box(t);	\
+	E_KEY[8 * i + 12] = t;			\
+	t ^= E_KEY[8 * i + 5];			\
+	E_KEY[8 * i + 13] = t;			\
+	t ^= E_KEY[8 * i + 6];			\
+	E_KEY[8 * i + 14] = t;			\
+	t ^= E_KEY[8 * i + 7];			\
+	E_KEY[8 * i + 15] = t;			\
+} while (0)
 
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len)
+		unsigned int key_len)
 {
 	struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	const __le32 *key = (const __le32 *)in_key;
@@ -268,14 +264,14 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	case 16:
 		t = E_KEY[3];
 		for (i = 0; i < 10; ++i)
-			loop4 (i);
+			loop4(i);
 		break;
 
 	case 24:
 		E_KEY[4] = le32_to_cpu(key[4]);
 		t = E_KEY[5] = le32_to_cpu(key[5]);
 		for (i = 0; i < 8; ++i)
-			loop6 (i);
+			loop6(i);
 		break;
 
 	case 32:
@@ -284,7 +280,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		E_KEY[6] = le32_to_cpu(key[6]);
 		t = E_KEY[7] = le32_to_cpu(key[7]);
 		for (i = 0; i < 7; ++i)
-			loop8 (i);
+			loop8(i);
 		break;
 	}
 
@@ -294,7 +290,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	D_KEY[3] = E_KEY[3];
 
 	for (i = 4; i < key_len + 24; ++i) {
-		imix_col (D_KEY[i], E_KEY[i]);
+		imix_col(D_KEY[i], E_KEY[i]);
 	}
 
 	return 0;
@@ -302,18 +298,34 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 
 /* encrypt a block of text */
 
-#define f_nround(bo, bi, k) \
-    f_rn(bo, bi, 0, k);     \
-    f_rn(bo, bi, 1, k);     \
-    f_rn(bo, bi, 2, k);     \
-    f_rn(bo, bi, 3, k);     \
-    k += 4
-
-#define f_lround(bo, bi, k) \
-    f_rl(bo, bi, 0, k);     \
-    f_rl(bo, bi, 1, k);     \
-    f_rl(bo, bi, 2, k);     \
-    f_rl(bo, bi, 3, k)
+#define f_rn(bo, bi, n, k)	do {				\
+	bo[n] = ft_tab[0][byte(bi[n], 0)] ^			\
+		ft_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
+		ft_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		ft_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+} while (0)
+
+#define f_nround(bo, bi, k)	do {\
+	f_rn(bo, bi, 0, k);	\
+	f_rn(bo, bi, 1, k);	\
+	f_rn(bo, bi, 2, k);	\
+	f_rn(bo, bi, 3, k);	\
+	k += 4;			\
+} while (0)
+
+#define f_rl(bo, bi, n, k)	do {				\
+	bo[n] = fl_tab[0][byte(bi[n], 0)] ^			\
+		fl_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
+		fl_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		fl_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+} while (0)
+
+#define f_lround(bo, bi, k)	do {\
+	f_rl(bo, bi, 0, k);	\
+	f_rl(bo, bi, 1, k);	\
+	f_rl(bo, bi, 2, k);	\
+	f_rl(bo, bi, 3, k);	\
+} while (0)
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
@@ -329,25 +341,25 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	b0[3] = le32_to_cpu(src[3]) ^ E_KEY[3];
 
 	if (ctx->key_length > 24) {
-		f_nround (b1, b0, kp);
-		f_nround (b0, b1, kp);
+		f_nround(b1, b0, kp);
+		f_nround(b0, b1, kp);
 	}
 
 	if (ctx->key_length > 16) {
-		f_nround (b1, b0, kp);
-		f_nround (b0, b1, kp);
+		f_nround(b1, b0, kp);
+		f_nround(b0, b1, kp);
 	}
 
-	f_nround (b1, b0, kp);
-	f_nround (b0, b1, kp);
-	f_nround (b1, b0, kp);
-	f_nround (b0, b1, kp);
-	f_nround (b1, b0, kp);
-	f_nround (b0, b1, kp);
-	f_nround (b1, b0, kp);
-	f_nround (b0, b1, kp);
-	f_nround (b1, b0, kp);
-	f_lround (b0, b1, kp);
+	f_nround(b1, b0, kp);
+	f_nround(b0, b1, kp);
+	f_nround(b1, b0, kp);
+	f_nround(b0, b1, kp);
+	f_nround(b1, b0, kp);
+	f_nround(b0, b1, kp);
+	f_nround(b1, b0, kp);
+	f_nround(b0, b1, kp);
+	f_nround(b1, b0, kp);
+	f_lround(b0, b1, kp);
 
 	dst[0] = cpu_to_le32(b0[0]);
 	dst[1] = cpu_to_le32(b0[1]);
@@ -357,18 +369,34 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 /* decrypt a block of text */
 
-#define i_nround(bo, bi, k) \
-    i_rn(bo, bi, 0, k);     \
-    i_rn(bo, bi, 1, k);     \
-    i_rn(bo, bi, 2, k);     \
-    i_rn(bo, bi, 3, k);     \
-    k -= 4
-
-#define i_lround(bo, bi, k) \
-    i_rl(bo, bi, 0, k);     \
-    i_rl(bo, bi, 1, k);     \
-    i_rl(bo, bi, 2, k);     \
-    i_rl(bo, bi, 3, k)
+#define i_rn(bo, bi, n, k)	do {				\
+	bo[n] = it_tab[0][byte(bi[n], 0)] ^			\
+		it_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
+		it_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+		it_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+} while (0)
+
+#define i_nround(bo, bi, k)	do {\
+	i_rn(bo, bi, 0, k);	\
+	i_rn(bo, bi, 1, k);	\
+	i_rn(bo, bi, 2, k);	\
+	i_rn(bo, bi, 3, k);	\
+	k -= 4;			\
+} while (0)
+
+#define i_rl(bo, bi, n, k)	do {			\
+	bo[n] = il_tab[0][byte(bi[n], 0)] ^		\
+	il_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
+	il_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
+	il_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+} while (0)
+
+#define i_lround(bo, bi, k)	do {\
+	i_rl(bo, bi, 0, k);	\
+	i_rl(bo, bi, 1, k);	\
+	i_rl(bo, bi, 2, k);	\
+	i_rl(bo, bi, 3, k);	\
+} while (0)
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
@@ -385,25 +413,25 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	b0[3] = le32_to_cpu(src[3]) ^ E_KEY[key_len + 27];
 
 	if (key_len > 24) {
-		i_nround (b1, b0, kp);
-		i_nround (b0, b1, kp);
+		i_nround(b1, b0, kp);
+		i_nround(b0, b1, kp);
 	}
 
 	if (key_len > 16) {
-		i_nround (b1, b0, kp);
-		i_nround (b0, b1, kp);
+		i_nround(b1, b0, kp);
+		i_nround(b0, b1, kp);
 	}
 
-	i_nround (b1, b0, kp);
-	i_nround (b0, b1, kp);
-	i_nround (b1, b0, kp);
-	i_nround (b0, b1, kp);
-	i_nround (b1, b0, kp);
-	i_nround (b0, b1, kp);
-	i_nround (b1, b0, kp);
-	i_nround (b0, b1, kp);
-	i_nround (b1, b0, kp);
-	i_lround (b0, b1, kp);
+	i_nround(b1, b0, kp);
+	i_nround(b0, b1, kp);
+	i_nround(b1, b0, kp);
+	i_nround(b0, b1, kp);
+	i_nround(b1, b0, kp);
+	i_nround(b0, b1, kp);
+	i_nround(b1, b0, kp);
+	i_nround(b0, b1, kp);
+	i_nround(b1, b0, kp);
+	i_lround(b0, b1, kp);
 
 	dst[0] = cpu_to_le32(b0[0]);
 	dst[1] = cpu_to_le32(b0[1]);
@@ -411,7 +439,6 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	dst[3] = cpu_to_le32(b0[3]);
 }
 
-
 static struct crypto_alg aes_alg = {
 	.cra_name		=	"aes",
 	.cra_driver_name	=	"aes-generic",
@@ -426,9 +453,9 @@ static struct crypto_alg aes_alg = {
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey	   	= 	aes_set_key,
-			.cia_encrypt	 	=	aes_encrypt,
-			.cia_decrypt	  	=	aes_decrypt
+			.cia_setkey		=	aes_set_key,
+			.cia_encrypt		=	aes_encrypt,
+			.cia_decrypt		=	aes_decrypt
 		}
 	}
 };

--------------1.5.3.4--

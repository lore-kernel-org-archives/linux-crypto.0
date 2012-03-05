From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/6] crypto: camellia - fix checkpatch warnings
Date: Mon, 05 Mar 2012 20:26:37 +0200
Message-ID: <20120305182637.25411.96429.stgit@localhost6.localdomain6>
References: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33243 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab2CES1I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Mar 2012 13:27:08 -0500
In-Reply-To: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix checkpatch warnings before renaming file.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/camellia.c |   79 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/crypto/camellia.c b/crypto/camellia.c
index f07a19b..f7aaaaf 100644
--- a/crypto/camellia.c
+++ b/crypto/camellia.c
@@ -337,43 +337,40 @@ static const u32 camellia_sp4404[256] = {
 /*
  *  macros
  */
-#define ROLDQ(ll, lr, rl, rr, w0, w1, bits)		\
-    do {						\
+#define ROLDQ(ll, lr, rl, rr, w0, w1, bits) ({		\
 	w0 = ll;					\
 	ll = (ll << bits) + (lr >> (32 - bits));	\
 	lr = (lr << bits) + (rl >> (32 - bits));	\
 	rl = (rl << bits) + (rr >> (32 - bits));	\
 	rr = (rr << bits) + (w0 >> (32 - bits));	\
-    } while (0)
+})
 
-#define ROLDQo32(ll, lr, rl, rr, w0, w1, bits)		\
-    do {						\
+#define ROLDQo32(ll, lr, rl, rr, w0, w1, bits) ({	\
 	w0 = ll;					\
 	w1 = lr;					\
 	ll = (lr << (bits - 32)) + (rl >> (64 - bits));	\
 	lr = (rl << (bits - 32)) + (rr >> (64 - bits));	\
 	rl = (rr << (bits - 32)) + (w0 >> (64 - bits));	\
 	rr = (w0 << (bits - 32)) + (w1 >> (64 - bits));	\
-    } while (0)
+})
 
-#define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1)	\
-    do {							\
+#define CAMELLIA_F(xl, xr, kl, kr, yl, yr, il, ir, t0, t1) ({	\
 	il = xl ^ kl;						\
 	ir = xr ^ kr;						\
 	t0 = il >> 16;						\
 	t1 = ir >> 16;						\
-	yl = camellia_sp1110[(u8)(ir     )]			\
-	   ^ camellia_sp0222[    (t1 >> 8)]			\
-	   ^ camellia_sp3033[(u8)(t1     )]			\
+	yl = camellia_sp1110[(u8)(ir)]				\
+	   ^ camellia_sp0222[(u8)(t1 >> 8)]			\
+	   ^ camellia_sp3033[(u8)(t1)]				\
 	   ^ camellia_sp4404[(u8)(ir >> 8)];			\
-	yr = camellia_sp1110[    (t0 >> 8)]			\
-	   ^ camellia_sp0222[(u8)(t0     )]			\
+	yr = camellia_sp1110[(u8)(t0 >> 8)]			\
+	   ^ camellia_sp0222[(u8)(t0)]				\
 	   ^ camellia_sp3033[(u8)(il >> 8)]			\
-	   ^ camellia_sp4404[(u8)(il     )];			\
+	   ^ camellia_sp4404[(u8)(il)];				\
 	yl ^= yr;						\
 	yr = ror32(yr, 8);					\
 	yr ^= yl;						\
-    } while (0)
+})
 
 #define SUBKEY_L(INDEX) (subkey[(INDEX)*2])
 #define SUBKEY_R(INDEX) (subkey[(INDEX)*2 + 1])
@@ -832,8 +829,7 @@ static void camellia_setup192(const unsigned char *key, u32 *subkey)
 /*
  * Encrypt/decrypt
  */
-#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) \
-    do {								\
+#define CAMELLIA_FLS(ll, lr, rl, rr, kll, klr, krl, krr, t0, t1, t2, t3) ({ \
 	t0 = kll;							\
 	t2 = krr;							\
 	t0 &= ll;							\
@@ -846,15 +842,14 @@ static void camellia_setup192(const unsigned char *key, u32 *subkey)
 	t1 |= lr;							\
 	ll ^= t1;							\
 	rr ^= rol32(t3, 1);						\
-    } while (0)
+})
 
-#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir)		\
-    do {								\
+#define CAMELLIA_ROUNDSM(xl, xr, kl, kr, yl, yr, il, ir) ({		\
 	yl ^= kl;							\
 	yr ^= kr;							\
 	ir =  camellia_sp1110[(u8)xr];					\
-	il =  camellia_sp1110[    (xl >> 24)];				\
-	ir ^= camellia_sp0222[    (xr >> 24)];				\
+	il =  camellia_sp1110[(u8)(xl >> 24)];				\
+	ir ^= camellia_sp0222[(u8)(xr >> 24)];				\
 	il ^= camellia_sp0222[(u8)(xl >> 16)];				\
 	ir ^= camellia_sp3033[(u8)(xr >> 16)];				\
 	il ^= camellia_sp3033[(u8)(xl >> 8)];				\
@@ -862,8 +857,8 @@ static void camellia_setup192(const unsigned char *key, u32 *subkey)
 	il ^= camellia_sp4404[(u8)xl];					\
 	ir ^= il;							\
 	yl ^= ir;							\
-	yr ^= ror32(il, 8) ^ ir;						\
-    } while (0)
+	yr ^= ror32(il, 8) ^ ir;					\
+})
 
 /* max = 24: 128bit encrypt, max = 32: 256bit encrypt */
 static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
@@ -875,7 +870,7 @@ static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
 	io[1] ^= SUBKEY_R(0);
 
 	/* main iteration */
-#define ROUNDS(i) do { \
+#define ROUNDS(i) ({ \
 	CAMELLIA_ROUNDSM(io[0], io[1], \
 			 SUBKEY_L(i + 2), SUBKEY_R(i + 2), \
 			 io[2], io[3], il, ir); \
@@ -894,13 +889,13 @@ static void camellia_do_encrypt(const u32 *subkey, u32 *io, unsigned max)
 	CAMELLIA_ROUNDSM(io[2], io[3], \
 			 SUBKEY_L(i + 7), SUBKEY_R(i + 7), \
 			 io[0], io[1], il, ir); \
-} while (0)
-#define FLS(i) do { \
+})
+#define FLS(i) ({ \
 	CAMELLIA_FLS(io[0], io[1], io[2], io[3], \
 		     SUBKEY_L(i + 0), SUBKEY_R(i + 0), \
 		     SUBKEY_L(i + 1), SUBKEY_R(i + 1), \
 		     t0, t1, il, ir); \
-} while (0)
+})
 
 	ROUNDS(0);
 	FLS(8);
@@ -930,7 +925,7 @@ static void camellia_do_decrypt(const u32 *subkey, u32 *io, unsigned i)
 	io[1] ^= SUBKEY_R(i);
 
 	/* main iteration */
-#define ROUNDS(i) do { \
+#define ROUNDS(i) ({ \
 	CAMELLIA_ROUNDSM(io[0], io[1], \
 			 SUBKEY_L(i + 7), SUBKEY_R(i + 7), \
 			 io[2], io[3], il, ir); \
@@ -949,13 +944,13 @@ static void camellia_do_decrypt(const u32 *subkey, u32 *io, unsigned i)
 	CAMELLIA_ROUNDSM(io[2], io[3], \
 			 SUBKEY_L(i + 2), SUBKEY_R(i + 2), \
 			 io[0], io[1], il, ir); \
-} while (0)
-#define FLS(i) do { \
+})
+#define FLS(i) ({ \
 	CAMELLIA_FLS(io[0], io[1], io[2], io[3], \
 		     SUBKEY_L(i + 1), SUBKEY_R(i + 1), \
 		     SUBKEY_L(i + 0), SUBKEY_R(i + 0), \
 		     t0, t1, il, ir); \
-} while (0)
+})
 
 	if (i == 32) {
 		ROUNDS(24);
@@ -1017,6 +1012,7 @@ static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
+	unsigned int max;
 
 	u32 tmp[4];
 
@@ -1025,9 +1021,12 @@ static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	camellia_do_encrypt(cctx->key_table, tmp,
-		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
-	);
+	if (cctx->key_length == 16)
+		max = 24;
+	else
+		max = 32; /* for key lengths of 24 and 32 */
+
+	camellia_do_encrypt(cctx->key_table, tmp, max);
 
 	/* do_encrypt returns 0,1 swapped with 2,3 */
 	dst[0] = cpu_to_be32(tmp[2]);
@@ -1041,6 +1040,7 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
 	const __be32 *src = (const __be32 *)in;
 	__be32 *dst = (__be32 *)out;
+	unsigned int max;
 
 	u32 tmp[4];
 
@@ -1049,9 +1049,12 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	tmp[2] = be32_to_cpu(src[2]);
 	tmp[3] = be32_to_cpu(src[3]);
 
-	camellia_do_decrypt(cctx->key_table, tmp,
-		cctx->key_length == 16 ? 24 : 32 /* for key lengths of 24 and 32 */
-	);
+	if (cctx->key_length == 16)
+		max = 24;
+	else
+		max = 32; /* for key lengths of 24 and 32 */
+
+	camellia_do_decrypt(cctx->key_table, tmp, max);
 
 	/* do_decrypt returns 0,1 swapped with 2,3 */
 	dst[0] = cpu_to_be32(tmp[2]);

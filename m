From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/5] crypto: x86/glue_helper - use le128 instead of u128 for
 CTR mode
Date: Sat, 20 Oct 2012 15:06:36 +0300
Message-ID: <20121020120636.19422.89149.stgit@localhost6.localdomain6>
References: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43694 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JTMGk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:06:40 -0400
In-Reply-To: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

'u128' currently used for CTR mode is on little-endian 'long long' swapped
and would require extra swap operations by SSE/AVX code. Use of le128
instead of u128 allows IV calculations to be done with vector registers
easier.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/camellia_glue.c           |   16 ++++++++--------
 arch/x86/crypto/cast6_avx_glue.c          |   12 ++++++------
 arch/x86/crypto/glue_helper.c             |   12 ++++++------
 arch/x86/crypto/serpent_avx_glue.c        |   12 ++++++------
 arch/x86/crypto/serpent_sse2_glue.c       |   12 ++++++------
 arch/x86/crypto/twofish_avx_glue.c        |    6 +++---
 arch/x86/crypto/twofish_glue_3way.c       |   20 ++++++++++----------
 arch/x86/include/asm/crypto/glue_helper.h |   28 +++++++++++++++++-----------
 arch/x86/include/asm/crypto/twofish.h     |    4 ++--
 9 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 42ffd2b..021a008 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1317,21 +1317,21 @@ static void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 	u128_xor(&dst[1], &dst[1], &iv);
 }
 
-static void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+static void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
 	if (dst != src)
 		*dst = *src;
 
-	u128_to_be128(&ctrblk, iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblk, iv);
+	le128_inc(iv);
 
 	camellia_enc_blk_xor(ctx, (u8 *)dst, (u8 *)&ctrblk);
 }
 
 static void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
-				    u128 *iv)
+				    le128 *iv)
 {
 	be128 ctrblks[2];
 
@@ -1340,10 +1340,10 @@ static void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
 		dst[1] = src[1];
 	}
 
-	u128_to_be128(&ctrblks[0], iv);
-	u128_inc(iv);
-	u128_to_be128(&ctrblks[1], iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblks[0], iv);
+	le128_inc(iv);
+	le128_to_be128(&ctrblks[1], iv);
+	le128_inc(iv);
 
 	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 15e5f85..1dfd33b 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -78,19 +78,19 @@ static void cast6_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
-	u128_to_be128(&ctrblk, iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblk, iv);
+	le128_inc(iv);
 
 	__cast6_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
 static void cast6_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				   u128 *iv)
+				 le128 *iv)
 {
 	be128 ctrblks[CAST6_PARALLEL_BLOCKS];
 	unsigned int i;
@@ -99,8 +99,8 @@ static void cast6_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
 		if (dst != src)
 			dst[i] = src[i];
 
-		u128_to_be128(&ctrblks[i], iv);
-		u128_inc(iv);
+		le128_to_be128(&ctrblks[i], iv);
+		le128_inc(iv);
 	}
 
 	cast6_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 30b3927..22ce4f6 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -221,16 +221,16 @@ static void glue_ctr_crypt_final_128bit(const common_glue_ctr_func_t fn_ctr,
 	u8 *src = (u8 *)walk->src.virt.addr;
 	u8 *dst = (u8 *)walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
-	u128 ctrblk;
+	le128 ctrblk;
 	u128 tmp;
 
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+	be128_to_le128(&ctrblk, (be128 *)walk->iv);
 
 	memcpy(&tmp, src, nbytes);
 	fn_ctr(ctx, &tmp, &tmp, &ctrblk);
 	memcpy(dst, &tmp, nbytes);
 
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	le128_to_be128((be128 *)walk->iv, &ctrblk);
 }
 EXPORT_SYMBOL_GPL(glue_ctr_crypt_final_128bit);
 
@@ -243,11 +243,11 @@ static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
 	unsigned int nbytes = walk->nbytes;
 	u128 *src = (u128 *)walk->src.virt.addr;
 	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
+	le128 ctrblk;
 	unsigned int num_blocks, func_bytes;
 	unsigned int i;
 
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+	be128_to_le128(&ctrblk, (be128 *)walk->iv);
 
 	/* Process multi-block batch */
 	for (i = 0; i < gctx->num_funcs; i++) {
@@ -269,7 +269,7 @@ static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
 	}
 
 done:
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	le128_to_be128((be128 *)walk->iv, &ctrblk);
 	return nbytes;
 }
 
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 3f543a0..2aa31ad 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -56,19 +56,19 @@ static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
-	u128_to_be128(&ctrblk, iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblk, iv);
+	le128_inc(iv);
 
 	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
 static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				   u128 *iv)
+				   le128 *iv)
 {
 	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
 	unsigned int i;
@@ -77,8 +77,8 @@ static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
 		if (dst != src)
 			dst[i] = src[i];
 
-		u128_to_be128(&ctrblks[i], iv);
-		u128_inc(iv);
+		le128_to_be128(&ctrblks[i], iv);
+		le128_inc(iv);
 	}
 
 	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 9107a99..97a356e 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -59,19 +59,19 @@ static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
-	u128_to_be128(&ctrblk, iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblk, iv);
+	le128_inc(iv);
 
 	__serpent_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
 static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				   u128 *iv)
+				   le128 *iv)
 {
 	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
 	unsigned int i;
@@ -80,8 +80,8 @@ static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
 		if (dst != src)
 			dst[i] = src[i];
 
-		u128_to_be128(&ctrblks[i], iv);
-		u128_inc(iv);
+		le128_to_be128(&ctrblks[i], iv);
+		le128_inc(iv);
 	}
 
 	serpent_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index e7708b5..810e45d 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -90,7 +90,7 @@ static void twofish_dec_blk_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 }
 
 static void twofish_enc_blk_ctr_xway(void *ctx, u128 *dst, const u128 *src,
-				     u128 *iv)
+				     le128 *iv)
 {
 	be128 ctrblks[TWOFISH_PARALLEL_BLOCKS];
 	unsigned int i;
@@ -99,8 +99,8 @@ static void twofish_enc_blk_ctr_xway(void *ctx, u128 *dst, const u128 *src,
 		if (dst != src)
 			dst[i] = src[i];
 
-		u128_to_be128(&ctrblks[i], iv);
-		u128_inc(iv);
+		le128_to_be128(&ctrblks[i], iv);
+		le128_inc(iv);
 	}
 
 	twofish_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index aa3eb35..13e63b3 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -62,15 +62,15 @@ void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
 	if (dst != src)
 		*dst = *src;
 
-	u128_to_be128(&ctrblk, iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblk, iv);
+	le128_inc(iv);
 
 	twofish_enc_blk(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
 	u128_xor(dst, dst, (u128 *)&ctrblk);
@@ -78,7 +78,7 @@ void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
 EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
 
 void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
-				     u128 *iv)
+			      le128 *iv)
 {
 	be128 ctrblks[3];
 
@@ -88,12 +88,12 @@ void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
 		dst[2] = src[2];
 	}
 
-	u128_to_be128(&ctrblks[0], iv);
-	u128_inc(iv);
-	u128_to_be128(&ctrblks[1], iv);
-	u128_inc(iv);
-	u128_to_be128(&ctrblks[2], iv);
-	u128_inc(iv);
+	le128_to_be128(&ctrblks[0], iv);
+	le128_inc(iv);
+	le128_to_be128(&ctrblks[1], iv);
+	le128_inc(iv);
+	le128_to_be128(&ctrblks[2], iv);
+	le128_inc(iv);
 
 	twofish_enc_blk_xor_3way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 3e408bd..e2d65b0 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -13,7 +13,7 @@
 typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
 typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
-				       u128 *iv);
+				       le128 *iv);
 
 #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
 #define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
@@ -71,23 +71,29 @@ static inline void glue_fpu_end(bool fpu_enabled)
 		kernel_fpu_end();
 }
 
-static inline void u128_to_be128(be128 *dst, const u128 *src)
+static inline void le128_to_be128(be128 *dst, const le128 *src)
 {
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
+	dst->a = cpu_to_be64(le64_to_cpu(src->a));
+	dst->b = cpu_to_be64(le64_to_cpu(src->b));
 }
 
-static inline void be128_to_u128(u128 *dst, const be128 *src)
+static inline void be128_to_le128(le128 *dst, const be128 *src)
 {
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
+	dst->a = cpu_to_le64(be64_to_cpu(src->a));
+	dst->b = cpu_to_le64(be64_to_cpu(src->b));
 }
 
-static inline void u128_inc(u128 *i)
+static inline void le128_inc(le128 *i)
 {
-	i->b++;
-	if (!i->b)
-		i->a++;
+	u64 a = le64_to_cpu(i->a);
+	u64 b = le64_to_cpu(i->b);
+
+	b++;
+	if (!b)
+		a++;
+
+	i->a = cpu_to_le64(a);
+	i->b = cpu_to_le64(b);
 }
 
 extern int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 9d2c514..878c51c 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -31,9 +31,9 @@ asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
 extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
-				u128 *iv);
+				le128 *iv);
 extern void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
-				     u128 *iv);
+				     le128 *iv);
 
 extern int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
 			      unsigned int keylen);

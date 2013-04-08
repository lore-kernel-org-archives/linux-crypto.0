From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/5] crypto: x86 - add more optimized XTS-mode for
 serpent-avx
Date: Mon, 08 Apr 2013 21:50:55 +0300
Message-ID: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34535 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760400Ab3DHSvC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds AVX optimized XTS-mode helper functions/macros and conv=
erts
serpent-avx to use the new facilities. Benefits are slightly improved s=
peed
and reduced stack usage as use of temporary IV-array is avoided.

tcrypt results, with Intel i5-2450M:
        enc     dec
16B     1.00x   1.00x
64B     1.00x   1.00x
256B    1.04x   1.06x
1024B   1.09x   1.09x
8192B   1.10x   1.09x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/glue_helper-asm-avx.S       |   61 +++++++++++++++++
 arch/x86/crypto/glue_helper.c               |   97 +++++++++++++++++++=
++++++++
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |   45 ++++++++++++-
 arch/x86/crypto/serpent_avx_glue.c          |   87 +++++++++++++------=
-----
 arch/x86/include/asm/crypto/glue_helper.h   |   24 +++++++
 arch/x86/include/asm/crypto/serpent-avx.h   |    5 +
 6 files changed, 273 insertions(+), 46 deletions(-)

diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/gl=
ue_helper-asm-avx.S
index f7b6ea2..02ee230 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -1,7 +1,7 @@
 /*
  * Shared glue code for 128bit block ciphers, AVX assembler macros
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -89,3 +89,62 @@
 	vpxor (6*16)(src), x6, x6; \
 	vpxor (7*16)(src), x7, x7; \
 	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
+
+#define gf128mul_x_ble(iv, mask, tmp) \
+	vpsrad $31, iv, tmp; \
+	vpaddq iv, iv, iv; \
+	vpshufd $0x13, tmp, tmp; \
+	vpand mask, tmp, tmp; \
+	vpxor tmp, iv, iv;
+
+#define load_xts_8way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, ti=
v, t0, \
+		      t1, xts_gf128mul_and_shl1_mask) \
+	vmovdqa xts_gf128mul_and_shl1_mask, t0; \
+	\
+	/* load IV */ \
+	vmovdqu (iv), tiv; \
+	vpxor (0*16)(src), tiv, x0; \
+	vmovdqu tiv, (0*16)(dst); \
+	\
+	/* construct and store IVs, also xor with source */ \
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (1*16)(src), tiv, x1; \
+	vmovdqu tiv, (1*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (2*16)(src), tiv, x2; \
+	vmovdqu tiv, (2*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (3*16)(src), tiv, x3; \
+	vmovdqu tiv, (3*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (4*16)(src), tiv, x4; \
+	vmovdqu tiv, (4*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (5*16)(src), tiv, x5; \
+	vmovdqu tiv, (5*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (6*16)(src), tiv, x6; \
+	vmovdqu tiv, (6*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vpxor (7*16)(src), tiv, x7; \
+	vmovdqu tiv, (7*16)(dst); \
+	\
+	gf128mul_x_ble(tiv, t0, t1); \
+	vmovdqu tiv, (iv);
+
+#define store_xts_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
+	vpxor (0*16)(dst), x0, x0; \
+	vpxor (1*16)(dst), x1, x1; \
+	vpxor (2*16)(dst), x2, x2; \
+	vpxor (3*16)(dst), x3, x3; \
+	vpxor (4*16)(dst), x4, x4; \
+	vpxor (5*16)(dst), x5, x5; \
+	vpxor (6*16)(dst), x6, x6; \
+	vpxor (7*16)(dst), x7, x7; \
+	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helpe=
r.c
index 22ce4f6..432f1d76 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -1,7 +1,7 @@
 /*
  * Shared glue code for 128bit block ciphers
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
@@ -304,4 +304,99 @@ int glue_ctr_crypt_128bit(const struct common_glue=
_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_ctr_crypt_128bit);
=20
+static unsigned int __glue_xts_crypt_128bit(const struct common_glue_c=
tx *gctx,
+					    void *ctx,
+					    struct blkcipher_desc *desc,
+					    struct blkcipher_walk *walk)
+{
+	const unsigned int bsize =3D 128 / 8;
+	unsigned int nbytes =3D walk->nbytes;
+	u128 *src =3D (u128 *)walk->src.virt.addr;
+	u128 *dst =3D (u128 *)walk->dst.virt.addr;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
+
+	/* Process multi-block batch */
+	for (i =3D 0; i < gctx->num_funcs; i++) {
+		num_blocks =3D gctx->funcs[i].num_blocks;
+		func_bytes =3D bsize * num_blocks;
+
+		if (nbytes >=3D func_bytes) {
+			do {
+				gctx->funcs[i].fn_u.xts(ctx, dst, src,
+							(le128 *)walk->iv);
+
+				src +=3D num_blocks;
+				dst +=3D num_blocks;
+				nbytes -=3D func_bytes;
+			} while (nbytes >=3D func_bytes);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+	}
+
+done:
+	return nbytes;
+}
+
+/* for implementations implementing faster XTS IV generator */
+int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes,
+			  void (*tweak_fn)(void *ctx, u8 *dst, const u8 *src),
+			  void *tweak_ctx, void *crypt_ctx)
+{
+	const unsigned int bsize =3D 128 / 8;
+	bool fpu_enabled =3D false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+
+	err =3D blkcipher_walk_virt(desc, &walk);
+	nbytes =3D walk.nbytes;
+	if (!nbytes)
+		return err;
+
+	/* set minimum length to bsize, for tweak_fn */
+	fpu_enabled =3D glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+				     desc, fpu_enabled,
+				     nbytes < bsize ? bsize : nbytes);
+
+	/* calculate first value of T */
+	tweak_fn(tweak_ctx, walk.iv, walk.iv);
+
+	while (nbytes) {
+		nbytes =3D __glue_xts_crypt_128bit(gctx, crypt_ctx, desc, &walk);
+
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+		nbytes =3D walk.nbytes;
+	}
+
+	glue_fpu_end(fpu_enabled);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit);
+
+void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, =
le128 *iv,
+			       common_glue_func_t fn)
+{
+	le128 ivblk =3D *iv;
+
+	/* generate next IV */
+	le128_gf128mul_x_ble(iv, &ivblk);
+
+	/* CC <- T xor C */
+	u128_xor(dst, src, (u128 *)&ivblk);
+
+	/* PP <- D(Key2,CC) */
+	fn(ctx, (u8 *)dst, (u8 *)dst);
+
+	/* P <- T xor PP */
+	u128_xor(dst, dst, (u128 *)&ivblk);
+}
+EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit_one);
+
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/cry=
pto/serpent-avx-x86_64-asm_64.S
index 43c9386..2f202f4 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -4,8 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Based on arch/x86/crypto/serpent-sse2-x86_64-asm_64.S by
- *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2011-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -34,6 +33,8 @@
=20
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.Lxts_gf128mul_and_shl1_mask:
+	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
=20
 .text
=20
@@ -739,3 +740,43 @@ ENTRY(serpent_ctr_8way_avx)
=20
 	ret;
 ENDPROC(serpent_ctr_8way_avx)
+
+ENTRY(serpent_xts_enc_8way_avx)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+
+	/* regs <=3D src, dst <=3D IVs, regs <=3D regs xor IVs */
+	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD=
2,
+		      RK0, RK1, RK2, .Lxts_gf128mul_and_shl1_mask);
+
+	call __serpent_enc_blk8_avx;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+ENDPROC(serpent_xts_enc_8way_avx)
+
+ENTRY(serpent_xts_dec_8way_avx)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+
+	/* regs <=3D src, dst <=3D IVs, regs <=3D regs xor IVs */
+	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD=
2,
+		      RK0, RK1, RK2, .Lxts_gf128mul_and_shl1_mask);
+
+	call __serpent_dec_blk8_avx;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
+
+	ret;
+ENDPROC(serpent_xts_dec_8way_avx)
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpe=
nt_avx_glue.c
index 52abaaf..0f8519c 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -4,8 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Glue code based on serpent_sse2_glue.c by:
- *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2011-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -53,6 +52,18 @@ static void serpent_crypt_ctr(void *ctx, u128 *dst, =
const u128 *src, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
=20
+static void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(__serpent_encrypt));
+}
+
+static void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(__serpent_decrypt));
+}
+
 static const struct common_glue_ctx serpent_enc =3D {
 	.num_funcs =3D 2,
 	.fpu_blocks_limit =3D SERPENT_PARALLEL_BLOCKS,
@@ -79,6 +90,19 @@ static const struct common_glue_ctx serpent_ctr =3D =
{
 	} }
 };
=20
+static const struct common_glue_ctx serpent_enc_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D SERPENT_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D SERPENT_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+	} }
+};
+
 static const struct common_glue_ctx serpent_dec =3D {
 	.num_funcs =3D 2,
 	.fpu_blocks_limit =3D SERPENT_PARALLEL_BLOCKS,
@@ -105,6 +129,19 @@ static const struct common_glue_ctx serpent_dec_cb=
c =3D {
 	} }
 };
=20
+static const struct common_glue_ctx serpent_dec_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D SERPENT_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D SERPENT_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+	} }
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -299,54 +336,20 @@ static int xts_encrypt(struct blkcipher_desc *des=
c, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct serpent_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[SERPENT_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(__serpent_encrypt),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D encrypt_callback,
-	};
-	int ret;
=20
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	serpent_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&serpent_enc_xts, desc, dst, src, nbytes=
,
+				     XTS_TWEAK_CAST(__serpent_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct serpent_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[SERPENT_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(__serpent_encrypt),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D decrypt_callback,
-	};
-	int ret;
=20
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	serpent_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&serpent_dec_xts, desc, dst, src, nbytes=
,
+				     XTS_TWEAK_CAST(__serpent_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static struct crypto_alg serpent_algs[10] =3D { {
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/inclu=
de/asm/crypto/glue_helper.h
index e2d65b0..1eef555 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -14,10 +14,13 @@ typedef void (*common_glue_func_t)(void *ctx, u8 *d=
st, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u12=
8 *src);
 typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u12=
8 *src,
 				       le128 *iv);
+typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u12=
8 *src,
+				       le128 *iv);
=20
 #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
 #define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
 #define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
+#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
=20
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
@@ -25,6 +28,7 @@ struct common_glue_func_entry {
 		common_glue_func_t ecb;
 		common_glue_cbc_func_t cbc;
 		common_glue_ctr_func_t ctr;
+		common_glue_xts_func_t xts;
 	} fn_u;
 };
=20
@@ -96,6 +100,16 @@ static inline void le128_inc(le128 *i)
 	i->b =3D cpu_to_le64(b);
 }
=20
+static inline void le128_gf128mul_x_ble(le128 *dst, const le128 *src)
+{
+	u64 a =3D le64_to_cpu(src->a);
+	u64 b =3D le64_to_cpu(src->b);
+	u64 _tt =3D ((s64)a >> 63) & 0x87;
+
+	dst->a =3D cpu_to_le64((a << 1) ^ (b >> 63));
+	dst->b =3D cpu_to_le64((b << 1) ^ _tt);
+}
+
 extern int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 				 struct blkcipher_desc *desc,
 				 struct scatterlist *dst,
@@ -118,4 +132,14 @@ extern int glue_ctr_crypt_128bit(const struct comm=
on_glue_ctx *gctx,
 				 struct scatterlist *dst,
 				 struct scatterlist *src, unsigned int nbytes);
=20
+extern int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
+				 struct blkcipher_desc *desc,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes,
+				 common_glue_func_t tweak_fn, void *tweak_ctx,
+				 void *crypt_ctx);
+
+extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128=
 *src,
+				      le128 *iv, common_glue_func_t fn);
+
 #endif /* _CRYPTO_GLUE_HELPER_H */
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/inclu=
de/asm/crypto/serpent-avx.h
index 0da1d3e..56e79cc 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -16,4 +16,9 @@ asmlinkage void serpent_cbc_dec_8way_avx(struct serpe=
nt_ctx *ctx, u8 *dst,
 asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
=20
+asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *=
dst,
+					 const u8 *src, le128 *iv);
+asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *=
dst,
+					 const u8 *src, le128 *iv);
+
 #endif

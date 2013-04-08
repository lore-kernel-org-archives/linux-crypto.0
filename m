From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 3/5] crypto: cast6-avx: use new optimized XTS code
Date: Mon, 08 Apr 2013 21:51:05 +0300
Message-ID: <20130408185105.4107.9040.stgit@localhost6.localdomain6>
References: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34800 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760400Ab3DHSvM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:12 -0400
In-Reply-To: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change cast6-avx to use the new XTS code, for smaller stack usage and s=
mall
boost to performance.

tcrypt results, with Intel i5-2450M:
        enc     dec
16B     1.01x   1.01x
64B     1.01x   1.00x
256B    1.09x   1.02x
1024B   1.08x   1.06x
8192B   1.08x   1.07x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |   48 +++++++++++++++
 arch/x86/crypto/cast6_avx_glue.c          |   91 ++++++++++++++++-----=
--------
 2 files changed, 98 insertions(+), 41 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypt=
o/cast6-avx-x86_64-asm_64.S
index f93b610..e3531f8 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -4,7 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -227,6 +227,8 @@
 .data
=20
 .align 16
+.Lxts_gf128mul_and_shl1_mask:
+	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
 .Lbswap_mask:
 	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
 .Lbswap128_mask:
@@ -424,3 +426,47 @@ ENTRY(cast6_ctr_8way)
=20
 	ret;
 ENDPROC(cast6_ctr_8way)
+
+ENTRY(cast6_xts_enc_8way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+
+	movq %rsi, %r11;
+
+	/* regs <=3D src, dst <=3D IVs, regs <=3D regs xor IVs */
+	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD=
2,
+		      RX, RKR, RKM, .Lxts_gf128mul_and_shl1_mask);
+
+	call __cast6_enc_blk8;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+ENDPROC(cast6_xts_enc_8way)
+
+ENTRY(cast6_xts_dec_8way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+
+	movq %rsi, %r11;
+
+	/* regs <=3D src, dst <=3D IVs, regs <=3D regs xor IVs */
+	load_xts_8way(%rcx, %rdx, %rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD=
2,
+		      RX, RKR, RKM, .Lxts_gf128mul_and_shl1_mask);
+
+	call __cast6_dec_blk8;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+ENDPROC(cast6_xts_dec_8way)
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_a=
vx_glue.c
index 92f7ca2..8d0dfb8 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
+ * Copyright =C2=A9 2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
+ *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
  * the Free Software Foundation; either version 2 of the License, or
@@ -50,6 +52,23 @@ asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx =
*ctx, u8 *dst,
 asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u=
8 *src,
 			       le128 *iv);
=20
+asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
+				   const u8 *src, le128 *iv);
+asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
+				   const u8 *src, le128 *iv);
+
+static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128=
 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(__cast6_encrypt));
+}
+
+static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128=
 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(__cast6_decrypt));
+}
+
 static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
 {
 	be128 ctrblk;
@@ -87,6 +106,19 @@ static const struct common_glue_ctx cast6_ctr =3D {
 	} }
 };
=20
+static const struct common_glue_ctx cast6_enc_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D CAST6_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D CAST6_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(cast6_xts_enc_8way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(cast6_xts_enc) }
+	} }
+};
+
 static const struct common_glue_ctx cast6_dec =3D {
 	.num_funcs =3D 2,
 	.fpu_blocks_limit =3D CAST6_PARALLEL_BLOCKS,
@@ -113,6 +145,19 @@ static const struct common_glue_ctx cast6_dec_cbc =
=3D {
 	} }
 };
=20
+static const struct common_glue_ctx cast6_dec_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D CAST6_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D CAST6_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(cast6_xts_dec_8way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(cast6_xts_dec) }
+	} }
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -307,54 +352,20 @@ static int xts_encrypt(struct blkcipher_desc *des=
c, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct cast6_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[CAST6_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
=20
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(__cast6_encrypt),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D encrypt_callback,
-	};
-	int ret;
-
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	cast6_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&cast6_enc_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(__cast6_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct cast6_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[CAST6_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(__cast6_encrypt),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D decrypt_callback,
-	};
-	int ret;
=20
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	cast6_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&cast6_dec_xts, desc, dst, src, nbytes,
+				     XTS_TWEAK_CAST(__cast6_encrypt),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static struct crypto_alg cast6_algs[10] =3D { {

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/5] crypto: x86/twofish-avx - use optimized XTS code
Date: Mon, 08 Apr 2013 21:51:00 +0300
Message-ID: <20130408185100.4107.91153.stgit@localhost6.localdomain6>
References: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45918 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab3DHSvN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:13 -0400
In-Reply-To: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change twofish-avx to use the new XTS code, for smaller stack usage and=
 small
boost to performance.

tcrypt results, with Intel i5-2450M:
        enc     dec
16B     1.03x   1.02x
64B     0.91x   0.91x
256B    1.10x   1.09x
1024B   1.12x   1.11x
8192B   1.12x   1.11x

Since XTS is practically always used with data blocks of size 512 bytes=
 or
more, I chose to not make use of twofish-3way for block sized smaller t=
han
128 bytes. This causes slower result in tcrypt for 64 bytes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |   48 ++++++++++++++
 arch/x86/crypto/twofish_avx_glue.c          |   91 +++++++++++++++----=
--------
 2 files changed, 98 insertions(+), 41 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/cry=
pto/twofish-avx-x86_64-asm_64.S
index 8d3e113..0505813 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
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
@@ -33,6 +33,8 @@
=20
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
+.Lxts_gf128mul_and_shl1_mask:
+	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
=20
 .text
=20
@@ -408,3 +410,47 @@ ENTRY(twofish_ctr_8way)
=20
 	ret;
 ENDPROC(twofish_ctr_8way)
+
+ENTRY(twofish_xts_enc_8way)
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
+		      RX0, RX1, RY0, .Lxts_gf128mul_and_shl1_mask);
+
+	call __twofish_enc_blk8;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
+
+	ret;
+ENDPROC(twofish_xts_enc_8way)
+
+ENTRY(twofish_xts_dec_8way)
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
+	load_xts_8way(%rcx, %rdx, %rsi, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB=
2,
+		      RX0, RX1, RY0, .Lxts_gf128mul_and_shl1_mask);
+
+	call __twofish_dec_blk8;
+
+	/* dst <=3D regs xor IVs(in dst) */
+	store_xts_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
+
+	ret;
+ENDPROC(twofish_xts_dec_8way)
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofi=
sh_avx_glue.c
index 94ac91d..a62ba54 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
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
@@ -56,12 +58,29 @@ asmlinkage void twofish_cbc_dec_8way(struct twofish=
_ctx *ctx, u8 *dst,
 asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
 				 const u8 *src, le128 *iv);
=20
+asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src, le128 *iv);
+
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *d=
st,
 					const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
=20
+static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(twofish_enc_blk));
+}
+
+static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le1=
28 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(twofish_dec_blk));
+}
+
=20
 static const struct common_glue_ctx twofish_enc =3D {
 	.num_funcs =3D 3,
@@ -95,6 +114,19 @@ static const struct common_glue_ctx twofish_ctr =3D=
 {
 	} }
 };
=20
+static const struct common_glue_ctx twofish_enc_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D TWOFISH_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
+	} }
+};
+
 static const struct common_glue_ctx twofish_dec =3D {
 	.num_funcs =3D 3,
 	.fpu_blocks_limit =3D TWOFISH_PARALLEL_BLOCKS,
@@ -127,6 +159,19 @@ static const struct common_glue_ctx twofish_dec_cb=
c =3D {
 	} }
 };
=20
+static const struct common_glue_ctx twofish_dec_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D TWOFISH_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D TWOFISH_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
+	} }
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -275,54 +320,20 @@ static int xts_encrypt(struct blkcipher_desc *des=
c, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct twofish_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[TWOFISH_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(twofish_enc_blk),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D encrypt_callback,
-	};
-	int ret;
=20
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	twofish_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&twofish_enc_xts, desc, dst, src, nbytes=
,
+				     XTS_TWEAK_CAST(twofish_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct twofish_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[TWOFISH_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(twofish_enc_blk),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D decrypt_callback,
-	};
-	int ret;
=20
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	twofish_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&twofish_dec_xts, desc, dst, src, nbytes=
,
+				     XTS_TWEAK_CAST(twofish_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static struct crypto_alg twofish_algs[10] =3D { {

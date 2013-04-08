From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 4/5] crypto: x86/camellia-aesni-avx - add more optimized XTS
 code
Date: Mon, 08 Apr 2013 21:51:11 +0300
Message-ID: <20130408185110.4107.6463.stgit@localhost6.localdomain6>
References: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45946 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935589Ab3DHSvR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 14:51:17 -0400
In-Reply-To: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add more optimized XTS code for camellia-aesni-avx, for smaller stack u=
sage
and small boost for speed.

tcrypt results, with Intel i5-2450M:
        enc     dec
16B     1.10x   1.01x
64B     0.82x   0.77x
256B    1.14x   1.10x
1024B   1.17x   1.16x
8192B   1.10x   1.11x

Since XTS is practically always used with data blocks of size 512 bytes=
 or
more, I chose to not make use of camellia-2way for block sized smaller =
than
256 bytes. This causes slower result in tcrypt for 64 bytes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/camellia-aesni-avx-asm_64.S |  180 +++++++++++++++++++=
++++++++
 arch/x86/crypto/camellia_aesni_avx_glue.c   |   91 ++++++++------
 2 files changed, 229 insertions(+), 42 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/cry=
pto/camellia-aesni-avx-asm_64.S
index cfc1634..ce71f92 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -1,7 +1,7 @@
 /*
  * x86_64/AVX/AES-NI assembler implementation of Camellia
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -589,6 +589,10 @@ ENDPROC(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6=
_y7_y0_y1_y2_y3_ab)
 .Lbswap128_mask:
 	.byte 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
=20
+/* For XTS mode IV generation */
+.Lxts_gf128mul_and_shl1_mask:
+	.byte 0x87, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
+
 /*
  * pre-SubByte transform
  *
@@ -1090,3 +1094,177 @@ ENTRY(camellia_ctr_16way)
=20
 	ret;
 ENDPROC(camellia_ctr_16way)
+
+#define gf128mul_x_ble(iv, mask, tmp) \
+	vpsrad $31, iv, tmp; \
+	vpaddq iv, iv, iv; \
+	vpshufd $0x13, tmp, tmp; \
+	vpand mask, tmp, tmp; \
+	vpxor tmp, iv, iv;
+
+.align 8
+camellia_xts_crypt_16way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 *	%r8: index for input whitening key
+	 *	%r9: pointer to  __camellia_enc_blk16 or __camellia_dec_blk16
+	 */
+
+	subq $(16 * 16), %rsp;
+	movq %rsp, %rax;
+
+	vmovdqa .Lxts_gf128mul_and_shl1_mask, %xmm14;
+
+	/* load IV */
+	vmovdqu (%rcx), %xmm0;
+	vpxor 0 * 16(%rdx), %xmm0, %xmm15;
+	vmovdqu %xmm15, 15 * 16(%rax);
+	vmovdqu %xmm0, 0 * 16(%rsi);
+
+	/* construct IVs */
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 1 * 16(%rdx), %xmm0, %xmm15;
+	vmovdqu %xmm15, 14 * 16(%rax);
+	vmovdqu %xmm0, 1 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 2 * 16(%rdx), %xmm0, %xmm13;
+	vmovdqu %xmm0, 2 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 3 * 16(%rdx), %xmm0, %xmm12;
+	vmovdqu %xmm0, 3 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 4 * 16(%rdx), %xmm0, %xmm11;
+	vmovdqu %xmm0, 4 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 5 * 16(%rdx), %xmm0, %xmm10;
+	vmovdqu %xmm0, 5 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 6 * 16(%rdx), %xmm0, %xmm9;
+	vmovdqu %xmm0, 6 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 7 * 16(%rdx), %xmm0, %xmm8;
+	vmovdqu %xmm0, 7 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 8 * 16(%rdx), %xmm0, %xmm7;
+	vmovdqu %xmm0, 8 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 9 * 16(%rdx), %xmm0, %xmm6;
+	vmovdqu %xmm0, 9 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 10 * 16(%rdx), %xmm0, %xmm5;
+	vmovdqu %xmm0, 10 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 11 * 16(%rdx), %xmm0, %xmm4;
+	vmovdqu %xmm0, 11 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 12 * 16(%rdx), %xmm0, %xmm3;
+	vmovdqu %xmm0, 12 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 13 * 16(%rdx), %xmm0, %xmm2;
+	vmovdqu %xmm0, 13 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 14 * 16(%rdx), %xmm0, %xmm1;
+	vmovdqu %xmm0, 14 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vpxor 15 * 16(%rdx), %xmm0, %xmm15;
+	vmovdqu %xmm15, 0 * 16(%rax);
+	vmovdqu %xmm0, 15 * 16(%rsi);
+
+	gf128mul_x_ble(%xmm0, %xmm14, %xmm15);
+	vmovdqu %xmm0, (%rcx);
+
+	/* inpack16_pre: */
+	vmovq (key_table)(CTX, %r8, 8), %xmm15;
+	vpshufb .Lpack_bswap, %xmm15, %xmm15;
+	vpxor 0 * 16(%rax), %xmm15, %xmm0;
+	vpxor %xmm1, %xmm15, %xmm1;
+	vpxor %xmm2, %xmm15, %xmm2;
+	vpxor %xmm3, %xmm15, %xmm3;
+	vpxor %xmm4, %xmm15, %xmm4;
+	vpxor %xmm5, %xmm15, %xmm5;
+	vpxor %xmm6, %xmm15, %xmm6;
+	vpxor %xmm7, %xmm15, %xmm7;
+	vpxor %xmm8, %xmm15, %xmm8;
+	vpxor %xmm9, %xmm15, %xmm9;
+	vpxor %xmm10, %xmm15, %xmm10;
+	vpxor %xmm11, %xmm15, %xmm11;
+	vpxor %xmm12, %xmm15, %xmm12;
+	vpxor %xmm13, %xmm15, %xmm13;
+	vpxor 14 * 16(%rax), %xmm15, %xmm14;
+	vpxor 15 * 16(%rax), %xmm15, %xmm15;
+
+	call *%r9;
+
+	addq $(16 * 16), %rsp;
+
+	vpxor 0 * 16(%rsi), %xmm7, %xmm7;
+	vpxor 1 * 16(%rsi), %xmm6, %xmm6;
+	vpxor 2 * 16(%rsi), %xmm5, %xmm5;
+	vpxor 3 * 16(%rsi), %xmm4, %xmm4;
+	vpxor 4 * 16(%rsi), %xmm3, %xmm3;
+	vpxor 5 * 16(%rsi), %xmm2, %xmm2;
+	vpxor 6 * 16(%rsi), %xmm1, %xmm1;
+	vpxor 7 * 16(%rsi), %xmm0, %xmm0;
+	vpxor 8 * 16(%rsi), %xmm15, %xmm15;
+	vpxor 9 * 16(%rsi), %xmm14, %xmm14;
+	vpxor 10 * 16(%rsi), %xmm13, %xmm13;
+	vpxor 11 * 16(%rsi), %xmm12, %xmm12;
+	vpxor 12 * 16(%rsi), %xmm11, %xmm11;
+	vpxor 13 * 16(%rsi), %xmm10, %xmm10;
+	vpxor 14 * 16(%rsi), %xmm9, %xmm9;
+	vpxor 15 * 16(%rsi), %xmm8, %xmm8;
+	write_output(%xmm7, %xmm6, %xmm5, %xmm4, %xmm3, %xmm2, %xmm1, %xmm0,
+		     %xmm15, %xmm14, %xmm13, %xmm12, %xmm11, %xmm10, %xmm9,
+		     %xmm8, %rsi);
+
+	ret;
+ENDPROC(camellia_xts_crypt_16way)
+
+ENTRY(camellia_xts_enc_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+	xorl %r8d, %r8d; /* input whitening key, 0 for enc */
+
+	leaq __camellia_enc_blk16, %r9;
+
+	jmp camellia_xts_crypt_16way;
+ENDPROC(camellia_xts_enc_16way)
+
+ENTRY(camellia_xts_dec_16way)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: iv (t =E2=8A=95 =CE=B1=E2=81=BF =E2=88=88 GF(2=C2=B9=C2=B2=E2=
=81=B8))
+	 */
+
+	cmpl $16, key_length(CTX);
+	movl $32, %r8d;
+	movl $24, %eax;
+	cmovel %eax, %r8d;  /* input whitening key, last for dec */
+
+	leaq __camellia_dec_blk16, %r9;
+
+	jmp camellia_xts_crypt_16way;
+ENDPROC(camellia_xts_dec_16way)
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypt=
o/camellia_aesni_avx_glue.c
index 96cbb60..4ff7ed4 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for x86_64/AVX/AES-NI assembler optimized version of Came=
llia
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
@@ -37,6 +37,23 @@ asmlinkage void camellia_cbc_dec_16way(struct camell=
ia_ctx *ctx, u8 *dst,
 asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
=20
+asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *d=
st,
+				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *d=
st,
+				       const u8 *src, le128 *iv);
+
+static void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le=
128 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(camellia_enc_blk));
+}
+
+static void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le=
128 *iv)
+{
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
+				  GLUE_FUNC_CAST(camellia_dec_blk));
+}
+
 static const struct common_glue_ctx camellia_enc =3D {
 	.num_funcs =3D 3,
 	.fpu_blocks_limit =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -69,6 +86,19 @@ static const struct common_glue_ctx camellia_ctr =3D=
 {
 	} }
 };
=20
+static const struct common_glue_ctx camellia_enc_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+	} }
+};
+
 static const struct common_glue_ctx camellia_dec =3D {
 	.num_funcs =3D 3,
 	.fpu_blocks_limit =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
@@ -101,6 +131,19 @@ static const struct common_glue_ctx camellia_dec_c=
bc =3D {
 	} }
 };
=20
+static const struct common_glue_ctx camellia_dec_xts =3D {
+	.num_funcs =3D 2,
+	.fpu_blocks_limit =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
+
+	.funcs =3D { {
+		.num_blocks =3D CAMELLIA_AESNI_PARALLEL_BLOCKS,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+	}, {
+		.num_blocks =3D 1,
+		.fn_u =3D { .xts =3D GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+	} }
+};
+
 static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
@@ -261,54 +304,20 @@ static int xts_encrypt(struct blkcipher_desc *des=
c, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct camellia_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[CAMELLIA_AESNI_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
-
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(camellia_enc_blk),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D encrypt_callback,
-	};
-	int ret;
-
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	camellia_fpu_end(crypt_ctx.fpu_enabled);
=20
-	return ret;
+	return glue_xts_crypt_128bit(&camellia_enc_xts, desc, dst, src, nbyte=
s,
+				     XTS_TWEAK_CAST(camellia_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
 		       struct scatterlist *src, unsigned int nbytes)
 {
 	struct camellia_xts_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
-	be128 buf[CAMELLIA_AESNI_PARALLEL_BLOCKS];
-	struct crypt_priv crypt_ctx =3D {
-		.ctx =3D &ctx->crypt_ctx,
-		.fpu_enabled =3D false,
-	};
-	struct xts_crypt_req req =3D {
-		.tbuf =3D buf,
-		.tbuflen =3D sizeof(buf),
=20
-		.tweak_ctx =3D &ctx->tweak_ctx,
-		.tweak_fn =3D XTS_TWEAK_CAST(camellia_enc_blk),
-		.crypt_ctx =3D &crypt_ctx,
-		.crypt_fn =3D decrypt_callback,
-	};
-	int ret;
-
-	desc->flags &=3D ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	ret =3D xts_crypt(desc, dst, src, nbytes, &req);
-	camellia_fpu_end(crypt_ctx.fpu_enabled);
-
-	return ret;
+	return glue_xts_crypt_128bit(&camellia_dec_xts, desc, dst, src, nbyte=
s,
+				     XTS_TWEAK_CAST(camellia_enc_blk),
+				     &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
=20
 static struct crypto_alg cmll_algs[10] =3D { {

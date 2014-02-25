From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 3/3] arm64: add support for AES in CCM mode using Crypto Extensions
Date: Tue, 25 Feb 2014 13:57:52 +0100
Message-ID: <1393333072-15310-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1393333072-15310-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40729 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBYM6C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:58:02 -0500
Received: by mail-wi0-f176.google.com with SMTP id hi5so4431353wib.3
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2014 04:58:01 -0800 (PST)
In-Reply-To: <1393333072-15310-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for a synchronous implementation of AES in CCM mode
using ARMv8 Crypto Extensions, using NEON registers q0 - q5.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile                |   1 +
 arch/arm64/crypto/Makefile         |  12 ++
 arch/arm64/crypto/aesce-ccm-core.S | 222 +++++++++++++++++++++++++++
 arch/arm64/crypto/aesce-ccm-glue.c | 301 +++++++++++++++++++++++++++++++++++++
 4 files changed, 536 insertions(+)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aesce-ccm-core.S
 create mode 100644 arch/arm64/crypto/aesce-ccm-glue.c

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index e0b75464b7f1..a4b3e253557d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -46,6 +46,7 @@ core-y		+= arch/arm64/emu/
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
 core-$(CONFIG_KVM) += arch/arm64/kvm/
 core-$(CONFIG_XEN) += arch/arm64/xen/
+core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
new file mode 100644
index 000000000000..ba10ebb53e9e
--- /dev/null
+++ b/arch/arm64/crypto/Makefile
@@ -0,0 +1,12 @@
+#
+# linux/arch/arm64/crypto/Makefile
+#
+# Copyright (C) 2013 - 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+aesce-ccm-y	:= aesce-ccm-glue.o aesce-ccm-core.o
+obj-m		+= aesce-ccm.o
diff --git a/arch/arm64/crypto/aesce-ccm-core.S b/arch/arm64/crypto/aesce-ccm-core.S
new file mode 100644
index 000000000000..f808c17eac45
--- /dev/null
+++ b/arch/arm64/crypto/aesce-ccm-core.S
@@ -0,0 +1,222 @@
+/*
+ * linux/arch/arm64/crypto/aesce-ccm-core.S - AES-CCM transform for
+ *                                            ARMv8 with Crypto Extensions
+ *
+ * Copyright (C) 2013 - 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+	.text
+	.arch	armv8-a+crypto
+
+	/*
+	 * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
+	 *			     u32 *macp, u8 const rk[], u32 rounds);
+	 */
+ENTRY(ce_aes_ccm_auth_data)
+	ldr	w8, [x3]			/* leftover from prev round? */
+	ld1	{v0.2d}, [x0]			/* load mac */
+	cbz	w8, 1f
+	sub	w8, w8, #16
+	eor	v1.16b, v1.16b, v1.16b
+0:	ldrb	w7, [x1], #1			/* get 1 byte of input */
+	subs	w2, w2, #1
+	add	w8, w8, #1
+	ins	v1.b[0], w7
+	ext	v1.16b, v1.16b, v1.16b, #1	/* rotate in the input bytes */
+	beq	8f				/* out of input? */
+	cbnz	w8, 0b
+	eor	v0.16b, v0.16b, v1.16b
+1:	ld1	{v3.2d}, [x4]			/* load first round key */
+	prfm	pldl1strm, [x1]
+	cmp	w5, #12				/* which key size? */
+	add	x6, x4, #16
+	sub	w7, w5, #2			/* modified # of rounds */
+	bmi	2f
+	bne	5f
+	mov	v5.16b, v3.16b
+	b	4f
+2:	mov	v4.16b, v3.16b
+	ld1	{v5.2d}, [x6], #16		/* load 2nd round key */
+3:	aese	v0.16b, v4.16b
+	aesmc	v0.16b, v0.16b
+4:	ld1	{v3.2d}, [x6], #16		/* load next round key */
+	aese	v0.16b, v5.16b
+	aesmc	v0.16b, v0.16b
+5:	ld1	{v4.2d}, [x6], #16		/* load next round key */
+	subs	w7, w7, #3
+	aese	v0.16b, v3.16b
+	aesmc	v0.16b, v0.16b
+	ld1	{v5.2d}, [x6], #16		/* load next round key */
+	bpl	3b
+	aese	v0.16b, v4.16b
+	subs	w2, w2, #16			/* last data? */
+	eor	v0.16b, v0.16b, v5.16b		/* final round */
+	bmi	6f
+	ld1	{v1.16b}, [x1], #16		/* load next input block */
+	eor	v0.16b, v0.16b, v1.16b		/* xor with mac */
+	bne	1b
+6:	st1	{v0.2d}, [x0]			/* store mac */
+	beq	10f
+	adds	w2, w2, #16
+	beq	10f
+	mov	w8, w2
+7:	ldrb	w7, [x1], #1
+	umov	w6, v0.b[0]
+	eor	w6, w6, w7
+	strb	w6, [x0], #1
+	subs	w2, w2, #1
+	beq	10f
+	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
+	b	7b
+8:	mov	w7, w8
+	add	w8, w8, #16
+9:	ext	v1.16b, v1.16b, v1.16b, #1
+	adds	w7, w7, #1
+	bne	9b
+	eor	v0.16b, v0.16b, v1.16b
+	st1	{v0.2d}, [x0]
+10:	str	w8, [x3]
+	ret
+ENDPROC(ce_aes_ccm_auth_data)
+
+	/*
+	 * void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u8 const rk[],
+	 * 			 u32 rounds);
+	 */
+ENTRY(ce_aes_ccm_final)
+	ld1	{v3.2d}, [x2], #16		/* load first round key */
+	ld1	{v0.2d}, [x0]			/* load mac */
+	cmp	w3, #12				/* which key size? */
+	sub	w3, w3, #2			/* modified # of rounds */
+	ld1	{v1.2d}, [x1]			/* load 1st ctriv */
+	bmi	0f
+	bne	3f
+	mov	v5.16b, v3.16b
+	b	2f
+0:	mov	v4.16b, v3.16b
+1:	ld1	{v5.2d}, [x2], #16		/* load next round key */
+	aese	v0.16b, v4.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v4.16b
+	aesmc	v1.16b, v1.16b
+2:	ld1	{v3.2d}, [x2], #16		/* load next round key */
+	aese	v0.16b, v5.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v5.16b
+	aesmc	v1.16b, v1.16b
+3:	ld1	{v4.2d}, [x2], #16		/* load next round key */
+	subs	w3, w3, #3
+	aese	v0.16b, v3.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v3.16b
+	aesmc	v1.16b, v1.16b
+	bpl	1b
+	aese	v0.16b, v4.16b
+	aese	v1.16b, v4.16b
+	/* final round key cancels out */
+	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
+	st1	{v0.2d}, [x0]			/* store result */
+	ret
+ENDPROC(ce_aes_ccm_final)
+
+	.macro	aes_ccm_do_crypt,enc
+	ldr	x8, [x6, #8]			/* load lower ctr */
+	ld1	{v0.2d}, [x5]			/* load mac */
+	rev	x8, x8				/* keep swabbed ctr in reg */
+0:	/* outer loop */
+	ld1	{v1.1d}, [x6]			/* load upper ctr */
+	prfm	pldl1strm, [x1]
+	add	x8, x8, #1
+	rev	x9, x8
+	cmp	w4, #12				/* which key size? */
+	sub	w7, w4, #2			/* get modified # of rounds */
+	ins	v1.d[1], x9			/* no carry in lower ctr */
+	ld1	{v3.2d}, [x3]			/* load first round key */
+	add	x10, x3, #16
+	bmi	1f
+	bne	4f
+	mov	v5.16b, v3.16b
+	b	3f
+1:	mov	v4.16b, v3.16b
+	ld1	{v5.2d}, [x10], #16		/* load 2nd round key */
+2:	/* inner loop: 3 rounds, 2x interleaved */
+	aese	v0.16b, v4.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v4.16b
+	aesmc	v1.16b, v1.16b
+3:	ld1	{v3.2d}, [x10], #16		/* load next round key */
+	aese	v0.16b, v5.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v5.16b
+	aesmc	v1.16b, v1.16b
+4:	ld1	{v4.2d}, [x10], #16		/* load next round key */
+	subs	w7, w7, #3
+	aese	v0.16b, v3.16b
+	aesmc	v0.16b, v0.16b
+	aese	v1.16b, v3.16b
+	aesmc	v1.16b, v1.16b
+	ld1	{v5.2d}, [x10], #16		/* load next round key */
+	bpl	2b
+	aese	v0.16b, v4.16b
+	aese	v1.16b, v4.16b
+	subs	w2, w2, #16
+	bmi	5f
+	ld1	{v2.16b}, [x1], #16		/* load next input block */
+	.if	\enc == 1
+	eor	v2.16b, v2.16b, v5.16b		/* final round enc+mac */
+	eor	v1.16b, v1.16b, v2.16b		/* xor with crypted ctr */
+	.else
+	eor	v2.16b, v2.16b, v1.16b		/* xor with crypted ctr */
+	eor	v1.16b, v2.16b, v5.16b		/* final round enc */
+	.endif
+	eor	v0.16b, v0.16b, v2.16b		/* xor mac with pt ^ rk[last] */
+	st1	{v1.16b}, [x0], #16		/* write output block */
+	bne	0b
+5:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
+	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
+	st1	{v0.2d}, [x5]			/* store mac */
+	beq	7f
+	add	w2, w2, #16			/* process partial tail block */
+6:	ldrb	w9, [x1], #1			/* get 1 byte of input */
+	umov	w6, v1.b[0]			/* get top crypted ctr byte */
+	umov	w7, v0.b[0]			/* get top mac byte */
+	.if	\enc == 1
+	eor	w7, w7, w9
+	eor	w9, w9, w6
+	.else
+	eor	w9, w9, w6
+	eor	w7, w7, w9
+	.endif
+	strb	w9, [x0], #1			/* store out byte */
+	strb	w7, [x5], #1			/* store mac byte */
+	subs	w2, w2, #1
+	beq	8f
+	ext	v0.16b, v0.16b, v0.16b, #1	/* shift out mac byte */
+	ext	v1.16b, v1.16b, v1.16b, #1	/* shift out ctr byte */
+	b	6b
+7:	rev	x8, x8
+	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
+8:	ret
+	.endm
+
+	/*
+	 * void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
+	 * 			   u8 const rk[], u32 rounds, u8 mac[],
+	 * 			   u8 ctr[]);
+	 * void ce_aes_ccm_decrypt(u8 out[], u8 const in[], u32 cbytes,
+	 * 			   u8 const rk[], u32 rounds, u8 mac[],
+	 * 			   u8 ctr[]);
+	 */
+ENTRY(ce_aes_ccm_encrypt)
+	aes_ccm_do_crypt	1
+ENDPROC(ce_aes_ccm_encrypt)
+
+ENTRY(ce_aes_ccm_decrypt)
+	aes_ccm_do_crypt	0
+ENDPROC(ce_aes_ccm_decrypt)
diff --git a/arch/arm64/crypto/aesce-ccm-glue.c b/arch/arm64/crypto/aesce-ccm-glue.c
new file mode 100644
index 000000000000..344025deca3c
--- /dev/null
+++ b/arch/arm64/crypto/aesce-ccm-glue.c
@@ -0,0 +1,301 @@
+/*
+ * linux/arch/arm64/crypto/aes-ccm-glue.c
+ *
+ * Copyright (C) 2013 - 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <crypto/scatterwalk.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+static int num_rounds(struct crypto_aes_ctx *ctx)
+{
+	/*
+	 * # of rounds specified by AES:
+	 * 128 bit key		10 rounds
+	 * 192 bit key		12 rounds
+	 * 256 bit key		14 rounds
+	 * => n byte key	=> 6 + (n/4) rounds
+	 */
+	return 6 + ctx->key_length / 4;
+}
+
+asmlinkage void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
+				     u32 *macp, u32 const rk[], u32 rounds);
+
+asmlinkage void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
+				   u32 const rk[], u32 rounds, u8 mac[],
+				   u8 ctr[]);
+
+asmlinkage void ce_aes_ccm_decrypt(u8 out[], u8 const in[], u32 cbytes,
+				   u32 const rk[], u32 rounds, u8 mac[],
+				   u8 ctr[]);
+
+asmlinkage void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u32 const rk[],
+				 u32 rounds);
+
+static int ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
+		      unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(tfm);
+	int ret;
+
+	ret = crypto_aes_expand_key(ctx, in_key, key_len);
+	if (!ret)
+		return 0;
+
+	tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+	return -EINVAL;
+}
+
+static int ccm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	if ((authsize & 1) || authsize < 4)
+		return -EINVAL;
+	return 0;
+}
+
+static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	__be32 *n = (__be32 *)&maciv[AES_BLOCK_SIZE - 8];
+	u32 l = req->iv[0] + 1;
+
+	/* verify that CCM dimension 'L' is set correctly in the IV */
+	if (l < 2 || l > 8)
+		return -EINVAL;
+
+	/* verify that msglen can in fact be represented in L bytes */
+	if (msglen >> (8 * l))
+		return -EOVERFLOW;
+
+	/*
+	 * Even if the CCM spec allows L values of up to 8, the Linux cryptoapi
+	 * uses a u32 type to represent msglen so the top 4 bytes are always 0.
+	 */
+	n[0] = 0;
+	n[1] = cpu_to_be32(msglen);
+
+	memcpy(maciv, req->iv, AES_BLOCK_SIZE - l);
+
+	/*
+	 * Meaning of byte 0 according to CCM spec (RFC 3610/NIST 800-38C)
+	 * - bits 0..2	: max # of bytes required to represent msglen, minus 1
+	 *                (already set by caller)
+	 * - bits 3..5	: size of auth tag (1 => 4 bytes, 2 => 6 bytes, etc)
+	 * - bit 6	: indicates presence of authenticate-only data
+	 */
+	maciv[0] |= (crypto_aead_authsize(aead) - 2) << 2;
+	if (req->assoclen)
+		maciv[0] |= 0x40;
+
+	memset(&req->iv[AES_BLOCK_SIZE - l], 0, l);
+	return 0;
+}
+
+static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct __packed { __be16 l; __be32 h; u16 len; } ltag;
+	struct scatter_walk walk;
+	u32 len = req->assoclen;
+	u32 macp = 0;
+
+	/* prepend the AAD with a length tag */
+	if (len < 0xff00) {
+		ltag.l = cpu_to_be16(len);
+		ltag.len = 2;
+	} else  {
+		ltag.l = cpu_to_be16(0xfffe);
+		put_unaligned_be32(len, &ltag.h);
+		ltag.len = 6;
+	}
+
+	ce_aes_ccm_auth_data(mac, (u8 *)&ltag, ltag.len, &macp, ctx->key_enc,
+	                     num_rounds(ctx));
+	scatterwalk_start(&walk, req->assoc);
+
+	do {
+		u32 n = scatterwalk_clamp(&walk, len);
+		u8 *p;
+
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		p = scatterwalk_map(&walk);
+		ce_aes_ccm_auth_data(mac, p, n, &macp, ctx->key_enc,
+				     num_rounds(ctx));
+		len -= n;
+
+		scatterwalk_unmap(p);
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+	} while (len);
+}
+
+static int ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	struct blkcipher_desc desc = { .info = req->iv };
+	struct blkcipher_walk walk;
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u8 buf[AES_BLOCK_SIZE];
+	u32 len = req->cryptlen;
+	int err;
+
+	err = ccm_init_mac(req, mac, len);
+	if (err)
+		return err;
+
+	kernel_neon_begin_partial(6);
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
+
+	/* preserve the original iv for the final round */
+	memcpy(buf, req->iv, AES_BLOCK_SIZE);
+
+	blkcipher_walk_init_raw(&walk, req->dst, req->src, len,
+				crypto_aead_blocksize(aead),
+				crypto_aead_ivsize(aead),
+				crypto_aead_alignmask(aead));
+	err = blkcipher_walk_virt_raw(&desc, &walk, AES_BLOCK_SIZE);
+
+	while (walk.nbytes) {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+
+		if (walk.nbytes == len)
+			tail = 0;
+
+		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+
+		len -= walk.nbytes - tail;
+		err = blkcipher_walk_done(&desc, &walk, tail);
+	}
+	if (!err)
+		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+
+	kernel_neon_end();
+
+	if (err)
+		return err;
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(mac, req->dst, req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+
+	return 0;
+}
+
+static int ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	struct blkcipher_desc desc = { .info = req->iv };
+	struct blkcipher_walk walk;
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u8 buf[AES_BLOCK_SIZE];
+	u32 len = req->cryptlen - authsize;
+	int err;
+
+	err = ccm_init_mac(req, mac, len);
+	if (err)
+		return err;
+
+	kernel_neon_begin_partial(6);
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
+
+	/* preserve the original iv for the final round */
+	memcpy(buf, req->iv, AES_BLOCK_SIZE);
+
+	blkcipher_walk_init_raw(&walk, req->dst, req->src, len,
+				crypto_aead_blocksize(aead),
+				crypto_aead_ivsize(aead),
+				crypto_aead_alignmask(aead));
+	err = blkcipher_walk_virt_raw(&desc, &walk, AES_BLOCK_SIZE);
+
+	while (walk.nbytes) {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+
+		if (walk.nbytes == len)
+			tail = 0;
+
+		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+
+		len -= walk.nbytes - tail;
+		err = blkcipher_walk_done(&desc, &walk, tail);
+	}
+	if (!err)
+		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+
+	kernel_neon_end();
+
+	if (err)
+		return err;
+
+	/* compare calculated auth tag with the stored one */
+	scatterwalk_map_and_copy(buf, req->src, req->cryptlen - authsize,
+				 authsize, 0);
+
+	if (memcmp(mac, buf, authsize))
+		return -EBADMSG;
+	return 0;
+}
+
+static struct crypto_alg ccm_aes_alg = {
+	.cra_name		= "ccm(aes)",
+	.cra_driver_name	= "ccm-aes-ce",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_aead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_aead = {
+		.ivsize		= AES_BLOCK_SIZE,
+		.maxauthsize	= AES_BLOCK_SIZE,
+		.setkey		= ccm_setkey,
+		.setauthsize	= ccm_setauthsize,
+		.encrypt	= ccm_encrypt,
+		.decrypt	= ccm_decrypt,
+	}
+};
+
+static int __init aes_mod_init(void)
+{
+	if (!(elf_hwcap & HWCAP_AES))
+		return -ENODEV;
+	return crypto_register_alg(&ccm_aes_alg);
+}
+
+static void __exit aes_mod_exit(void)
+{
+	crypto_unregister_alg(&ccm_aes_alg);
+}
+
+module_init(aes_mod_init);
+module_exit(aes_mod_exit);
+
+MODULE_DESCRIPTION("Synchronous AES in CCM mode using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ccm(aes)");
-- 
1.8.3.2

From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 3/3] [crypto] x86_64 asm AES use new common module
Date: Mon, 22 Oct 2007 19:22:14 +0200
Message-ID: <1193073734-15789-4-git-send-email-linux-crypto@ml.breakpoint.cc>
References: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53748 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbXJVRWR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 13:22:17 -0400
In-Reply-To: <1193073734-15789-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

Share the tables and set_key function.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/x86/crypto/aes-x86_64-asm_64.S |   68 ++++----
 arch/x86/crypto/aes_64.c            |  282 +----------------------------------
 crypto/Kconfig                      |    1 +
 3 files changed, 38 insertions(+), 313 deletions(-)

diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
index 26b40de..a120f52 100644
--- a/arch/x86/crypto/aes-x86_64-asm_64.S
+++ b/arch/x86/crypto/aes-x86_64-asm_64.S
@@ -8,10 +8,10 @@
  * including this sentence is retained in full.
  */
 
-.extern aes_ft_tab
-.extern aes_it_tab
-.extern aes_fl_tab
-.extern aes_il_tab
+.extern crypto_ft_tab
+.extern crypto_it_tab
+.extern crypto_fl_tab
+.extern crypto_il_tab
 
 .text
 
@@ -56,13 +56,13 @@
 	.align	8;			\
 FUNC:	movq	r1,r2;			\
 	movq	r3,r4;			\
-	leaq	BASE+KEY+52(r8),r9;	\
+	leaq	BASE+KEY+48+4(r8),r9;	\
 	movq	r10,r11;		\
 	movl	(r7),r5 ## E;		\
 	movl	4(r7),r1 ## E;		\
 	movl	8(r7),r6 ## E;		\
 	movl	12(r7),r7 ## E;		\
-	movl	BASE(r8),r10 ## E;	\
+	movl	BASE+0(r8),r10 ## E;	\
 	xorl	-48(r9),r5 ## E;	\
 	xorl	-44(r9),r1 ## E;	\
 	xorl	-40(r9),r6 ## E;	\
@@ -154,37 +154,37 @@ FUNC:	movq	r1,r2;			\
 /* void aes_enc_blk(stuct crypto_tfm *tfm, u8 *out, const u8 *in) */
 
 	entry(aes_enc_blk,0,enc128,enc192)
-	encrypt_round(aes_ft_tab,-96)
-	encrypt_round(aes_ft_tab,-80)
-enc192:	encrypt_round(aes_ft_tab,-64)
-	encrypt_round(aes_ft_tab,-48)
-enc128:	encrypt_round(aes_ft_tab,-32)
-	encrypt_round(aes_ft_tab,-16)
-	encrypt_round(aes_ft_tab,  0)
-	encrypt_round(aes_ft_tab, 16)
-	encrypt_round(aes_ft_tab, 32)
-	encrypt_round(aes_ft_tab, 48)
-	encrypt_round(aes_ft_tab, 64)
-	encrypt_round(aes_ft_tab, 80)
-	encrypt_round(aes_ft_tab, 96)
-	encrypt_final(aes_fl_tab,112)
+	encrypt_round(crypto_ft_tab,-96)
+	encrypt_round(crypto_ft_tab,-80)
+enc192:	encrypt_round(crypto_ft_tab,-64)
+	encrypt_round(crypto_ft_tab,-48)
+enc128:	encrypt_round(crypto_ft_tab,-32)
+	encrypt_round(crypto_ft_tab,-16)
+	encrypt_round(crypto_ft_tab,  0)
+	encrypt_round(crypto_ft_tab, 16)
+	encrypt_round(crypto_ft_tab, 32)
+	encrypt_round(crypto_ft_tab, 48)
+	encrypt_round(crypto_ft_tab, 64)
+	encrypt_round(crypto_ft_tab, 80)
+	encrypt_round(crypto_ft_tab, 96)
+	encrypt_final(crypto_fl_tab,112)
 	return
 
 /* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in) */
 
 	entry(aes_dec_blk,240,dec128,dec192)
-	decrypt_round(aes_it_tab,-96)
-	decrypt_round(aes_it_tab,-80)
-dec192:	decrypt_round(aes_it_tab,-64)
-	decrypt_round(aes_it_tab,-48)
-dec128:	decrypt_round(aes_it_tab,-32)
-	decrypt_round(aes_it_tab,-16)
-	decrypt_round(aes_it_tab,  0)
-	decrypt_round(aes_it_tab, 16)
-	decrypt_round(aes_it_tab, 32)
-	decrypt_round(aes_it_tab, 48)
-	decrypt_round(aes_it_tab, 64)
-	decrypt_round(aes_it_tab, 80)
-	decrypt_round(aes_it_tab, 96)
-	decrypt_final(aes_il_tab,112)
+	decrypt_round(crypto_it_tab,-96)
+	decrypt_round(crypto_it_tab,-80)
+dec192:	decrypt_round(crypto_it_tab,-64)
+	decrypt_round(crypto_it_tab,-48)
+dec128:	decrypt_round(crypto_it_tab,-32)
+	decrypt_round(crypto_it_tab,-16)
+	decrypt_round(crypto_it_tab,  0)
+	decrypt_round(crypto_it_tab, 16)
+	decrypt_round(crypto_it_tab, 32)
+	decrypt_round(crypto_it_tab, 48)
+	decrypt_round(crypto_it_tab, 64)
+	decrypt_round(crypto_it_tab, 80)
+	decrypt_round(crypto_it_tab, 96)
+	decrypt_final(crypto_il_tab,112)
 	return
diff --git a/arch/x86/crypto/aes_64.c b/arch/x86/crypto/aes_64.c
index 0b38a4c..d7a41a9 100644
--- a/arch/x86/crypto/aes_64.c
+++ b/arch/x86/crypto/aes_64.c
@@ -1,284 +1,9 @@
 /*
- * Cryptographic API.
+ * Glue Code for AES Cipher Algorithm
  *
- * AES Cipher Algorithm.
- *
- * Based on Brian Gladman's code.
- *
- * Linux developers:
- *  Alexander Kjeldaas <astor@fast.no>
- *  Herbert Valerio Riedel <hvr@hvrlab.org>
- *  Kyle McMartin <kyle@debian.org>
- *  Adam J. Richter <adam@yggdrasil.com> (conversion to 2.5 API).
- *  Andreas Steinmetz <ast@domdv.de> (adapted to x86_64 assembler)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * ---------------------------------------------------------------------------
- * Copyright (c) 2002, Dr Brian Gladman <brg@gladman.me.uk>, Worcester, UK.
- * All rights reserved.
- *
- * LICENSE TERMS
- *
- * The free distribution and use of this software in both source and binary
- * form is allowed (with or without changes) provided that:
- *
- *   1. distributions of this source code include the above copyright
- *      notice, this list of conditions and the following disclaimer;
- *
- *   2. distributions in binary form include the above copyright
- *      notice, this list of conditions and the following disclaimer
- *      in the documentation and/or other associated materials;
- *
- *   3. the copyright holder's name is not used to endorse products
- *      built using this software without specific written permission.
- *
- * ALTERNATIVELY, provided that this notice is retained in full, this product
- * may be distributed under the terms of the GNU General Public License (GPL),
- * in which case the provisions of the GPL apply INSTEAD OF those given above.
- *
- * DISCLAIMER
- *
- * This software is provided 'as is' with no explicit or implied warranties
- * in respect of its properties, including, but not limited to, correctness
- * and/or fitness for purpose.
- * ---------------------------------------------------------------------------
  */
 
-/* Some changes from the Gladman version:
-    s/RIJNDAEL(e_key)/E_KEY/g
-    s/RIJNDAEL(d_key)/D_KEY/g
-*/
-
-#include <asm/byteorder.h>
 #include <crypto/aes.h>
-#include <linux/bitops.h>
-#include <linux/crypto.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/types.h>
-
-/*
- * #define byte(x, nr) ((unsigned char)((x) >> (nr*8)))
- */
-static inline u8 byte(const u32 x, const unsigned n)
-{
-	return x >> (n << 3);
-}
-
-struct aes_ctx
-{
-	u32 key_length;
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
-u32 aes_ft_tab[4][256];
-u32 aes_it_tab[4][256];
-
-u32 aes_fl_tab[4][256];
-u32 aes_il_tab[4][256];
-
-static inline u8 f_mult(u8 a, u8 b)
-{
-	u8 aa = log_tab[a], cc = aa + log_tab[b];
-
-	return pow_tab[cc + (cc < aa ? 1 : 0)];
-}
-
-#define ff_mult(a, b) (a && b ? f_mult(a, b) : 0)
-
-#define ls_box(x)				\
-	(aes_fl_tab[0][byte(x, 0)] ^		\
-	 aes_fl_tab[1][byte(x, 1)] ^		\
-	 aes_fl_tab[2][byte(x, 2)] ^		\
-	 aes_fl_tab[3][byte(x, 3)])
-
-static void __init gen_tabs(void)
-{
-	u32 i, t;
-	u8 p, q;
-
-	/* log and power tables for GF(2**8) finite field with
-	   0x011b as modular polynomial - the simplest primitive
-	   root is 0x03, used here to generate the tables */
-
-	for (i = 0, p = 1; i < 256; ++i) {
-		pow_tab[i] = (u8)p;
-		log_tab[p] = (u8)i;
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
-		isb_tab[p] = (u8)i;
-	}
-
-	for (i = 0; i < 256; ++i) {
-		p = sbx_tab[i];
-
-		t = p;
-		aes_fl_tab[0][i] = t;
-		aes_fl_tab[1][i] = rol32(t, 8);
-		aes_fl_tab[2][i] = rol32(t, 16);
-		aes_fl_tab[3][i] = rol32(t, 24);
-
-		t = ((u32)ff_mult(2, p)) |
-		    ((u32)p << 8) |
-		    ((u32)p << 16) | ((u32)ff_mult(3, p) << 24);
-
-		aes_ft_tab[0][i] = t;
-		aes_ft_tab[1][i] = rol32(t, 8);
-		aes_ft_tab[2][i] = rol32(t, 16);
-		aes_ft_tab[3][i] = rol32(t, 24);
-
-		p = isb_tab[i];
-
-		t = p;
-		aes_il_tab[0][i] = t;
-		aes_il_tab[1][i] = rol32(t, 8);
-		aes_il_tab[2][i] = rol32(t, 16);
-		aes_il_tab[3][i] = rol32(t, 24);
-
-		t = ((u32)ff_mult(14, p)) |
-		    ((u32)ff_mult(9, p) << 8) |
-		    ((u32)ff_mult(13, p) << 16) |
-		    ((u32)ff_mult(11, p) << 24);
-
-		aes_it_tab[0][i] = t;
-		aes_it_tab[1][i] = rol32(t, 8);
-		aes_it_tab[2][i] = rol32(t, 16);
-		aes_it_tab[3][i] = rol32(t, 24);
-	}
-}
-
-#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
-
-#define imix_col(y, x)			\
-	u    = star_x(x);		\
-	v    = star_x(u);		\
-	w    = star_x(v);		\
-	t    = w ^ (x);			\
-	(y)  = u ^ v ^ w;		\
-	(y) ^= ror32(u ^ t,  8) ^	\
-	       ror32(v ^ t, 16) ^	\
-	       ror32(t, 24)
-
-/* initialise the key schedule from the user supplied key */
-
-#define loop4(i)					\
-{							\
-	t = ror32(t,  8); t = ls_box(t) ^ rco_tab[i];	\
-	t ^= E_KEY[4 * i];     E_KEY[4 * i + 4] = t;	\
-	t ^= E_KEY[4 * i + 1]; E_KEY[4 * i + 5] = t;	\
-	t ^= E_KEY[4 * i + 2]; E_KEY[4 * i + 6] = t;	\
-	t ^= E_KEY[4 * i + 3]; E_KEY[4 * i + 7] = t;	\
-}
-
-#define loop6(i)					\
-{							\
-	t = ror32(t,  8); t = ls_box(t) ^ rco_tab[i];	\
-	t ^= E_KEY[6 * i];     E_KEY[6 * i + 6] = t;	\
-	t ^= E_KEY[6 * i + 1]; E_KEY[6 * i + 7] = t;	\
-	t ^= E_KEY[6 * i + 2]; E_KEY[6 * i + 8] = t;	\
-	t ^= E_KEY[6 * i + 3]; E_KEY[6 * i + 9] = t;	\
-	t ^= E_KEY[6 * i + 4]; E_KEY[6 * i + 10] = t;	\
-	t ^= E_KEY[6 * i + 5]; E_KEY[6 * i + 11] = t;	\
-}
-
-#define loop8(i)					\
-{							\
-	t = ror32(t,  8); ; t = ls_box(t) ^ rco_tab[i];	\
-	t ^= E_KEY[8 * i];     E_KEY[8 * i + 8] = t;	\
-	t ^= E_KEY[8 * i + 1]; E_KEY[8 * i + 9] = t;	\
-	t ^= E_KEY[8 * i + 2]; E_KEY[8 * i + 10] = t;	\
-	t ^= E_KEY[8 * i + 3]; E_KEY[8 * i + 11] = t;	\
-	t  = E_KEY[8 * i + 4] ^ ls_box(t);		\
-	E_KEY[8 * i + 12] = t;				\
-	t ^= E_KEY[8 * i + 5]; E_KEY[8 * i + 13] = t;	\
-	t ^= E_KEY[8 * i + 6]; E_KEY[8 * i + 14] = t;	\
-	t ^= E_KEY[8 * i + 7]; E_KEY[8 * i + 15] = t;	\
-}
-
-static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len)
-{
-	struct aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *key = (const __le32 *)in_key;
-	u32 *flags = &tfm->crt_flags;
-	u32 i, j, t, u, v, w;
-
-	if (key_len % 8) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
-	ctx->key_length = key_len;
-
-	D_KEY[key_len + 24] = E_KEY[0] = le32_to_cpu(key[0]);
-	D_KEY[key_len + 25] = E_KEY[1] = le32_to_cpu(key[1]);
-	D_KEY[key_len + 26] = E_KEY[2] = le32_to_cpu(key[2]);
-	D_KEY[key_len + 27] = E_KEY[3] = le32_to_cpu(key[3]);
-
-	switch (key_len) {
-	case 16:
-		t = E_KEY[3];
-		for (i = 0; i < 10; ++i)
-			loop4(i);
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
-			loop8(i);
-		break;
-	}
-
-	D_KEY[0] = E_KEY[key_len + 24];
-	D_KEY[1] = E_KEY[key_len + 25];
-	D_KEY[2] = E_KEY[key_len + 26];
-	D_KEY[3] = E_KEY[key_len + 27];
-
-	for (i = 4; i < key_len + 24; ++i) {
-		j = key_len + 24 - (i & ~3) + (i & 3);
-		imix_col(D_KEY[j], E_KEY[i]);
-	}
-
-	return 0;
-}
 
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
@@ -299,14 +24,14 @@ static struct crypto_alg aes_alg = {
 	.cra_priority		=	200,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct aes_ctx),
+	.cra_ctxsize		=	sizeof(struct crypto_aes_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey	   	= 	aes_set_key,
+			.cia_setkey		=	crypto_aes_set_key,
 			.cia_encrypt	 	=	aes_encrypt,
 			.cia_decrypt	  	=	aes_decrypt
 		}
@@ -315,7 +40,6 @@ static struct crypto_alg aes_alg = {
 
 static int __init aes_init(void)
 {
-	gen_tabs();
 	return crypto_register_alg(&aes_alg);
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 17b11b8..0e17ddb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -354,6 +354,7 @@ config CRYPTO_AES_X86_64
 	tristate "AES cipher algorithms (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES_COMMON
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael 
 	  algorithm.
-- 
1.5.3.4

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809B1C54E94
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Jan 2023 03:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjAZD40 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Jan 2023 22:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZD4Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2023 22:56:25 -0500
Received: from aib29gb126.yyz1.oracleemaildelivery.com (aib29gb126.yyz1.oracleemaildelivery.com [192.29.72.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4601458A4
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jan 2023 19:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ocHr5a4hTcwk1Rfx5LBk1VWPJ/rgHyOJzrXgjLBswSg=;
 b=Kxaurn9d2gUNeuFvjlR+zDH8wv+ShXvJ/lsdtBPWgRZUKRZ8k0J4JqfJY5nANntjSo9rFbrrc4zU
   A527QxmJMQABOYhXwoO0ezpMdD/gQYRWKGt9WdqkH5xXpXIxUBWoO7mYyuxoxG9nxEtcFQxXME3M
   mg68K+lgARKYwvi5O76VaK5Yka085iAxcwJvVk6tEtgsqkPQkl9yxsMr6oO7lsIjBKGJ5Ptm3eQG
   3W/RlSXMe80TtMWzjeSm22ABHxG5Iy49z7I/9AgSVON9UcRVtN0JNvjnymJifq2Zvg6m5b+qIPaK
   8T/d8UgU4xEKTQzIZJnJdvtByQXByaoHKW6IUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ocHr5a4hTcwk1Rfx5LBk1VWPJ/rgHyOJzrXgjLBswSg=;
 b=DDJXTuYMUfteHXXhz4cqKiFrdQz/h+Zzket8AQT2Y3zH7vThFKfko4hFDRx82uvS2241mJythXom
   vQvlSQriapH2Mw+kk6UW78KqDJSDhaACpBq0eJxeDi29yJBYT4yqYIde7y6rG2658136dTpp/YkQ
   k0mdpxSTCRNucwqubuNeM96i8iFeNE8UteSksYthYi9CrOKPYzPPpz8xehuk12zKO8dj0yIf6ZGH
   JeGiMiypRSau8calq3b0e5LOn08TolORm+gUeve1oAAZL8bKN5xOwuhXaWSi/crtAya59yy+AKFA
   q2kSbJXQQJ5zTiVfz2k0XQG1kVUwCSUdCyODnw==
Received: by omta-ad1-fd3-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP200B5DQXZ8N00@omta-ad1-fd3-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Thu, 26 Jan 2023 03:56:23 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 2/3] crypto: x86/blowfish - Convert to use ECB/CBC helpers
Date:   Wed, 25 Jan 2023 22:56:14 -0500
Message-id: <20230126035614.5399-2-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAGEnqUkZOnKR2AixouMNiboXePPLolPQLxNyhUJniIKAHLQKsNepv49w2Y2VH/x
 za1QMdH+fijd1lwz+iq0dln+elq3OfOceBukYHBDClZbzCCh6qQrl3wMbhJQe1Q1
 4jR2NuFoy3ZOZ+kNl+Pcpg6qLENemoqI7S13+/macrGCYah3LkIT9yW1QujDarQC
 1aCHN1xCsJ5/SRD3ezp38aCEy4AwORG9f/QPpoyfz9+jKsmOQ2Zy6sf9mTeSsb+4
 ji6faGk336aSHaVvpq6aQJ9yGSAGZ7icC7Ly0ko1stvVxRnEfmL2cjBYbdOdIHlv
 BrR4n8RZe4u3dlBvvVX42rVLcEquW2N/n4DqTmAesi8MXgSBjvNyMY4PkhV0WPY3
 BZZX7ShVV51us8QGG1z5byTeT7eDWxTC4+i4tyR0H44AAB1LlFQNqbRWVCtXW2k=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We can simplify the blowfish-x86_64 glue code by using the preexisting
ECB/CBC helper macros. Additionally, this allows for easier reuse of asm
functions in later x86 implementations of blowfish.

This involves:
 1 - Modifying blowfish_dec_blk_4way() to xor outputs when a flag is
     passed.
 2 - Renaming blowfish_dec_blk_4way() to __blowfish_dec_blk_4way().
 3 - Creating two wrapper functions around __blowfish_dec_blk_4way() for
     use in the ECB/CBC macros.
 4 - Removing the custom ecb_encrypt() and cbc_encrypt() routines in
     favor of macro-based routines.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/blowfish-x86_64-asm_64.S |  30 +++-
 arch/x86/crypto/blowfish_glue.c          | 196 ++++-------------------
 2 files changed, 58 insertions(+), 168 deletions(-)

diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 4c5d4bc28ac4..767a209ca989 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -260,6 +260,19 @@ SYM_FUNC_END(blowfish_dec_blk)
 	bswapq 			RX3; \
 	movq RX3,		24(RIO);
 
+#define xor_block4() \
+	movq (RIO),		RT0; \
+	bsqapq			RT0; \
+	xorq RT0,		RX1; \
+	\
+	movq 8(RIO),		RT2; \
+	bswapq			RT2; \
+	xorq RT2,		RX2; \
+	\
+	movq 16(RIO),		RT3; \
+	bswapq			RT3; \
+	xorq RT3,		RX3;
+
 SYM_TYPED_FUNC_START(blowfish_enc_blk_4way)
 	/* input:
 	 *	%rdi: ctx
@@ -295,17 +308,20 @@ SYM_TYPED_FUNC_START(blowfish_enc_blk_4way)
 	RET;
 SYM_FUNC_END(blowfish_enc_blk_4way)
 
-SYM_TYPED_FUNC_START(blowfish_dec_blk_4way)
+SYM_TYPED_FUNC_START(__blowfish_dec_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
 	 *	%rdx: src
+	 *	%rcx: cbc (bool)
 	 */
 	pushq %r12;
 	pushq %rbx;
+	pushq %rcx;
+	pushq %rdx;
 
 	movq %rdi, CTX;
-	movq %rsi, %r11
+	movq %rsi, %r11;
 	movq %rdx, RIO;
 
 	preload_roundkey_dec(17);
@@ -321,6 +337,14 @@ SYM_TYPED_FUNC_START(blowfish_dec_blk_4way)
 	round_dec4(3);
 	add_preloaded_roundkey4();
 
+	popq RIO;
+	popq %r12;
+	testq %r12, %r12;
+	jz .L_no_cbc_xor;
+
+	xor_block4();
+
+.L_no_cbc_xor:
 	movq %r11, RIO;
 	write_block4();
 
@@ -328,4 +352,4 @@ SYM_TYPED_FUNC_START(blowfish_dec_blk_4way)
 	popq %r12;
 
 	RET;
-SYM_FUNC_END(blowfish_dec_blk_4way)
+SYM_FUNC_END(__blowfish_dec_blk_4way)
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 13a6664a89f3..552f2df0643f 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -16,6 +16,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "ecb_cbc_helpers.h"
+
 /* regular block cipher functions */
 asmlinkage void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
 asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
@@ -23,8 +25,20 @@ asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
 /* 4-way parallel cipher functions */
 asmlinkage void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
 				      const u8 *src);
-asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void __blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
+					const u8 *src, bool cbc);
+
+static inline void blowfish_dec_ecb_4way(struct bf_ctx *ctx, u8 *dst,
+					     const u8 *src)
+{
+	return __blowfish_dec_blk_4way(ctx, dst, src, false);
+}
+
+static inline void blowfish_dec_cbc_4way(struct bf_ctx *ctx, u8 *dst,
+					     const u8 *src)
+{
+	return __blowfish_dec_blk_4way(ctx, dst, src, true);
+}
 
 static void blowfish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
@@ -42,183 +56,35 @@ static int blowfish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return blowfish_setkey(&tfm->base, key, keylen);
 }
 
-static int ecb_crypt(struct skcipher_request *req,
-		     void (*fn)(struct bf_ctx *, u8 *, const u8 *),
-		     void (*fn_4way)(struct bf_ctx *, u8 *, const u8 *))
-{
-	unsigned int bsize = BF_BLOCK_SIZE;
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct bf_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		u8 *wsrc = walk.src.virt.addr;
-		u8 *wdst = walk.dst.virt.addr;
-
-		/* Process four block batch */
-		if (nbytes >= bsize * 4) {
-			do {
-				fn_4way(ctx, wdst, wsrc);
-
-				wsrc += bsize * 4;
-				wdst += bsize * 4;
-				nbytes -= bsize * 4;
-			} while (nbytes >= bsize * 4);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-
-		/* Handle leftovers */
-		do {
-			fn(ctx, wdst, wsrc);
-
-			wsrc += bsize;
-			wdst += bsize;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
-
-done:
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return ecb_crypt(req, blowfish_enc_blk, blowfish_enc_blk_4way);
+	ECB_WALK_START(req, BF_BLOCK_SIZE, -1);
+	ECB_BLOCK(4, blowfish_enc_blk_4way);
+	ECB_BLOCK(1, blowfish_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return ecb_crypt(req, blowfish_dec_blk, blowfish_dec_blk_4way);
-}
-
-static unsigned int __cbc_encrypt(struct bf_ctx *ctx,
-				  struct skcipher_walk *walk)
-{
-	unsigned int bsize = BF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u64 *src = (u64 *)walk->src.virt.addr;
-	u64 *dst = (u64 *)walk->dst.virt.addr;
-	u64 *iv = (u64 *)walk->iv;
-
-	do {
-		*dst = *src ^ *iv;
-		blowfish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
-		iv = dst;
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-	*(u64 *)walk->iv = *iv;
-	return nbytes;
+	ECB_WALK_START(req, BF_BLOCK_SIZE, -1);
+	ECB_BLOCK(4, blowfish_dec_ecb_4way);
+	ECB_BLOCK(1, blowfish_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct bf_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		nbytes = __cbc_encrypt(ctx, &walk);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static unsigned int __cbc_decrypt(struct bf_ctx *ctx,
-				  struct skcipher_walk *walk)
-{
-	unsigned int bsize = BF_BLOCK_SIZE;
-	unsigned int nbytes = walk->nbytes;
-	u64 *src = (u64 *)walk->src.virt.addr;
-	u64 *dst = (u64 *)walk->dst.virt.addr;
-	u64 ivs[4 - 1];
-	u64 last_iv;
-
-	/* Start of the last block. */
-	src += nbytes / bsize - 1;
-	dst += nbytes / bsize - 1;
-
-	last_iv = *src;
-
-	/* Process four block batch */
-	if (nbytes >= bsize * 4) {
-		do {
-			nbytes -= bsize * 4 - bsize;
-			src -= 4 - 1;
-			dst -= 4 - 1;
-
-			ivs[0] = src[0];
-			ivs[1] = src[1];
-			ivs[2] = src[2];
-
-			blowfish_dec_blk_4way(ctx, (u8 *)dst, (u8 *)src);
-
-			dst[1] ^= ivs[0];
-			dst[2] ^= ivs[1];
-			dst[3] ^= ivs[2];
-
-			nbytes -= bsize;
-			if (nbytes < bsize)
-				goto done;
-
-			*dst ^= *(src - 1);
-			src -= 1;
-			dst -= 1;
-		} while (nbytes >= bsize * 4);
-	}
-
-	/* Handle leftovers */
-	for (;;) {
-		blowfish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
-
-		nbytes -= bsize;
-		if (nbytes < bsize)
-			break;
-
-		*dst ^= *(src - 1);
-		src -= 1;
-		dst -= 1;
-	}
-
-done:
-	*dst ^= *(u64 *)walk->iv;
-	*(u64 *)walk->iv = last_iv;
-
-	return nbytes;
+	CBC_WALK_START(req, BF_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(blowfish_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct bf_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		nbytes = __cbc_decrypt(ctx, &walk);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
+	CBC_WALK_START(req, BF_BLOCK_SIZE, -1);
+	CBC_DEC_BLOCK(4, blowfish_dec_cbc_4way);
+	CBC_DEC_BLOCK(1, blowfish_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct crypto_alg bf_cipher_alg = {
-- 
2.39.1


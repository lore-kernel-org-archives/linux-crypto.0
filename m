Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEE3C05027
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Jan 2023 03:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjAZDzN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Jan 2023 22:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZDzM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2023 22:55:12 -0500
Received: from aib29gb127.yyz1.oracleemaildelivery.com (aib29gb127.yyz1.oracleemaildelivery.com [192.29.72.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981B946145
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jan 2023 19:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cPxNIIwgJ5odAtXr+OjYy14aXyYybwI9Ww2yc5huXoM=;
 b=fqOthopHu1Qeqs3w0Q44XhwAqsjXkmb+9cWyJopmgXY/TFLn2nZEaxoYviUZQ/wbsiGgpAXS/1rg
   8kaWJQYX+5BPYiXY4VvgD8eA2mox5thvVLhumEv3iVdavjoAP/xHDuhroC6pDUmFo7sAujaUDQC4
   3tVmw9evbKKEA0r7Tse/tScdcUjYUaS+r38asuY81ja9BF261IpyKrhMp6IsHhHTT0dB5wSmQnCB
   LnT+Wo71xr8Ax0Cz8UEbTVbxsN8RVRCfUWQPvaw0Y2dS0oSxKe5tob/JvGF13VGsDeWb9kL0go2q
   9WOQ9i0RLX2C8f69xZVZ1mbHjOyfQgbx+8issA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cPxNIIwgJ5odAtXr+OjYy14aXyYybwI9Ww2yc5huXoM=;
 b=VOsnbXSJpStH6A5psM6skC1RoDPhUWTbOx1JjJr4DMztVajJ7OGMiGUMli/2M6MLkv6jp0dATkPx
   mKM6gEUlyu16ZtEbHj3vJew+MVikQZeNu3gYDaQuvzu1eBoxbA01xnTrCfNd5vy8WysEhOpUfqeg
   9hV/ElcMDRotGV5v3mxy6nYPN6Z+35nTAcq8Z+Hv5yIAA9Ja+/2FBk/tBN5/ZhK13Mo2Avagc3Dl
   juyHribKd0VOAnWxoLxLSUECJB3PelHYKI4HXlWRX6mOyditeMJb81q1Yba5s7Y+9JA/vzdzgaAw
   9hgPKz+Ssds8K6iVgwYOvz5xDNV2OiRrHZugrw==
Received: by omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP2002BKQVYFR50@omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Thu, 26 Jan 2023 03:55:10 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 1/3] crypto: x86/blowfish - Remove unused encode parameter
Date:   Wed, 25 Jan 2023 22:54:33 -0500
Message-id: <20230126035433.5291-2-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
In-reply-to: <20230126035433.5291-1-peter@n8pjl.ca>
References: <20230126035433.5291-1-peter@n8pjl.ca>
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAGLmsdiyB4PGyn7+In7rV6QBZ5OTvOSWiLYpD1TZNZj2h0lcACgDMDi0nori/iH
 k6j6g7zEP4tzudYydKlQWKN4ZKPPoQCrl3M9fZzwFeJKSaFsznEqsEuItKGmDvPK
 RdcZgH2cP0qZRlhcuZRkv7UWkNdp14EBZZa0nYgwISnxlNE2hve5iphrFxuwypkj
 6BKOXkktQ24jC1/eKFShH8Y2PfeduP6W2dZ4PA+a1/Dq+LIkiItEARmdtft8KGMu
 ARhbOFDIFoCPSl7PE4etDoeCRefmMKc4RmfpEAEC2+L/ahaVA2L63y0ROF/3vAJS
 wdSobCPqWI1WWujGMlfoOGNNSTnwSYrx4S0Xn3b9DxtY/Z2rwuisrdaYJ2TyP90e
 dMEkcJ+oh3zQdjQiPp8yg/fES+gTk0c/gKawN1S7SRR0pZbkw2LAneBLwt+0ESAu
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The blowfish-x86_64 encryption functions have an unused argument. Remove
it.

This involves:
 1 - Removing xor_block() macros.
 2 - Removing handling of fourth argument from __blowfish_enc_blk{,_4way}()
     functions.
 3 - Renaming __blowfish_enc_blk{,_4way}() to blowfish_enc_blk{,_4way}().
 4 - Removing the blowfish_enc_blk{,_4way}() wrappers from
     blowfish_glue.c
 5 - Temporarily using SYM_TYPED_FUNC_START for now indirectly-callable
     encode functions.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/blowfish-x86_64-asm_64.S | 46 +++---------------------
 arch/x86/crypto/blowfish_glue.c          | 18 ++--------
 2 files changed, 7 insertions(+), 57 deletions(-)

diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 4a43e072d2d1..4c5d4bc28ac4 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -100,16 +100,11 @@
 	bswapq 			RX0; \
 	movq RX0, 		(RIO);
 
-#define xor_block() \
-	bswapq 			RX0; \
-	xorq RX0, 		(RIO);
-
-SYM_FUNC_START(__blowfish_enc_blk)
+SYM_TYPED_FUNC_START(blowfish_enc_blk)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
 	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
 	 */
 	movq %r12, %r11;
 
@@ -130,17 +125,11 @@ SYM_FUNC_START(__blowfish_enc_blk)
 	add_roundkey_enc(16);
 
 	movq %r11, %r12;
-
 	movq %r10, RIO;
-	test %cl, %cl;
-	jnz .L__enc_xor;
 
 	write_block();
 	RET;
-.L__enc_xor:
-	xor_block();
-	RET;
-SYM_FUNC_END(__blowfish_enc_blk)
+SYM_FUNC_END(blowfish_enc_blk)
 
 SYM_TYPED_FUNC_START(blowfish_dec_blk)
 	/* input:
@@ -271,29 +260,14 @@ SYM_FUNC_END(blowfish_dec_blk)
 	bswapq 			RX3; \
 	movq RX3,		24(RIO);
 
-#define xor_block4() \
-	bswapq 			RX0; \
-	xorq RX0,		(RIO); \
-	\
-	bswapq 			RX1; \
-	xorq RX1,		8(RIO); \
-	\
-	bswapq 			RX2; \
-	xorq RX2,		16(RIO); \
-	\
-	bswapq 			RX3; \
-	xorq RX3,		24(RIO);
-
-SYM_FUNC_START(__blowfish_enc_blk_4way)
+SYM_TYPED_FUNC_START(blowfish_enc_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
 	 *	%rdx: src
-	 *	%rcx: bool, if true: xor output
 	 */
 	pushq %r12;
 	pushq %rbx;
-	pushq %rcx;
 
 	movq %rdi, CTX
 	movq %rsi, %r11;
@@ -313,25 +287,13 @@ SYM_FUNC_START(__blowfish_enc_blk_4way)
 	round_enc4(14);
 	add_preloaded_roundkey4();
 
-	popq %r12;
 	movq %r11, RIO;
-
-	test %r12b, %r12b;
-	jnz .L__enc_xor4;
-
 	write_block4();
 
 	popq %rbx;
 	popq %r12;
 	RET;
-
-.L__enc_xor4:
-	xor_block4();
-
-	popq %rbx;
-	popq %r12;
-	RET;
-SYM_FUNC_END(__blowfish_enc_blk_4way)
+SYM_FUNC_END(blowfish_enc_blk_4way)
 
 SYM_TYPED_FUNC_START(blowfish_dec_blk_4way)
 	/* input:
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 019c64c1340a..13a6664a89f3 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -17,27 +17,15 @@
 #include <linux/types.h>
 
 /* regular block cipher functions */
-asmlinkage void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src,
-				   bool xor);
+asmlinkage void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
 asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
 
 /* 4-way parallel cipher functions */
-asmlinkage void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
+asmlinkage void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+				      const u8 *src);
 asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
 				      const u8 *src);
 
-static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src)
-{
-	__blowfish_enc_blk(ctx, dst, src, false);
-}
-
-static inline void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
-					 const u8 *src)
-{
-	__blowfish_enc_blk_4way(ctx, dst, src, false);
-}
-
 static void blowfish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	blowfish_enc_blk(crypto_tfm_ctx(tfm), dst, src);
-- 
2.39.1


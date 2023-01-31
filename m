Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC27C61DA4
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 01:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjAaB1Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAaB1Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 20:27:24 -0500
Received: from aib29gb124.yyz1.oracleemaildelivery.com (aib29gb124.yyz1.oracleemaildelivery.com [192.29.72.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D10222F8
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 17:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oSWhjkFhtF/m0qxTIAuEQh5KNpmykItCC6HGUy6fKU0=;
 b=VRddeNNBAsa7/0Mlr/J0qgtoN66LyOKt8L5NK8jfjZiV/cK68G62j9XLnn6KShU7CvoK9Xde+iGm
   R8uRqRbPLpsJEZbdxmv5TDABlrVbbHBa3EqyYX5gnQ98gj8DBLx9Rbfws3KXLObYIS9ijCsFaCTX
   4ZPMuR3FB9O3w026HlEMns7SlUIRsCW6tJSEYYhdxQnYpx5zHZ1GHQ5ZyZFrTRwsq+pFNvPqjaX9
   cn81wSc1EbWYFA5RddpG77QIsg//A3MaeEWsmfpj6E6H5bIVbso43HNmy6vibAzVOpvBMLhWbx/P
   4Kx3Cmdez8v3rzPLtWGbFMNsa3HjjC4BfQFelA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oSWhjkFhtF/m0qxTIAuEQh5KNpmykItCC6HGUy6fKU0=;
 b=UTzfkC2TGAV/ojHLiHAWcwKHPkZ5s+alWbiJOkHBZXYxsldMZ1Rd0anXeXN06eh5wzQVDBQ3NP3q
   bkpWrOJtvVQe2S7etjB5JBmAVBsg9XJjvK34a10esUcXpQXd2w1N7N93XYG73/FVwp1z+RI5YAnd
   /lluWgteh/fY5daxsxU8Ng+GykwFe8cFRCkdSiNQgs50JS6LgU0m7iZGZ7capacKm0OhZYKPGnSy
   exSvBp2t+eFiSLsMq4ZacXqDcOfJ9UnajjjBU+5eFMgmFM9SZVnP+hNjGg9uFcxzSEnbUpWmvaX/
   IQwRVTnTtylzmRm5q+24LJCn8WcDabZ/U8WCWQ==
Received: by omta-ad1-fd2-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPB002N3TDMVQ00@omta-ad1-fd2-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Tue, 31 Jan 2023 01:27:22 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH v2 1/3] crypto: x86/blowfish - Remove unused encode parameter
Date:   Mon, 30 Jan 2023 20:27:14 -0500
Message-id: <20230131012714.6267-2-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAEteT6nhtSJC5yvk27zuBZexFe292wfs99ey1Dc5Q4RVBSj5Oet4txWpCt9HriU
 2JFcH9jpE1cuXPl86Va6nxBv9QdjGpYDFtoZ23skje5/CsAvCHnaOhJs9wwrcrbV
 z4+NtLBiWk5EZnUEw3P4p7RHYRcnAneJ2pwdW9gk6EzDPEltFkaQquuD02Lykbxy
 OMXBkASQEkCWo8coC79g6ijdgqfF6b1ZWKMuKSEZ1p+Il0iPwprocknOGbUEw1eX
 OI05Y4gDFn8BCe1S4TmWcLAYkZZ4hPtp4mh/OMepx+a3v3kr+KKgx0p9oOhP1ViS
 Wlmqy0QmRuQ4xH9CnAKm6oz9NrccuYTYd6RNJdu6HZl3KWB0y6C6uFZE4dwioLnk
 /WAUy4nt0tYrehYcb5h4DW0S7ch/8+xrkfUQ2zwEWCqlVu1LQbiIdUTXcyVmQ+c=
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
v1 -> v2:
 - Fixed typo that caused an assembler failure
 - Added note about performance to cover letter

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


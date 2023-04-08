Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEF9C77B6C
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjDHP1x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjDHP1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A64CEFA5
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AFB0601D6
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94B0C4339C;
        Sat,  8 Apr 2023 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967666;
        bh=qVPD0XqrxTEr/O5PQB21V00qndpVEhzjGwVPYtYsRa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKd5LQ0Ujb/4dnKS8v4qzAmdcC/tnWNZ8MRGevi208P48S5hXmcaqk0GTQ/Cds8ee
         8N4nRmnT4oAdLMsrho/ZQ0PYeVfiRfnMmYIPXnME1XSzXjCXFCR0HJNx3t11bp2L6X
         umHcPET+dYYAvnr6Yy/3WgoZF/GBwmFTnyl/+IETR7sXNgQr25Ydj5PjWpvoOf9/MR
         gBmIjeR5WWIBI9B+vUqs/KCKyHlityGkrLbBfLUOUZXoQJBfFBFW2b143EofxAmNAZ
         zVBdjdiFECmikTtHkfC4KZBR/TTQNNc54+xzJaEmcvxscjFG8e7wesFodjuuoAW7Ft
         s8f/Vw/N7LQnQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 05/10] crypto: x86/cast5 - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:17 +0200
Message-Id: <20230408152722.3975985-6-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3783; i=ardb@kernel.org; h=from:subject; bh=qVPD0XqrxTEr/O5PQB21V00qndpVEhzjGwVPYtYsRa0=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/fLaVdtjlrvxzVr1/u2y+94tv/1rrDc0rzBfrn260 4LBeNLGjlIWBjEOBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRjlRGhnWlE1/LzVt74lhH 49P9vE53zj43WXOb5Zj+/ayHK1Nydpxk+F/e7Wi5MbQhyLz9+pzsZJYl22Ldp826qXDumK7ZjwK fXB4A
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S | 50 +++++++++++---------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 0326a01503c3a554..438c404a03bcd33e 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -83,16 +83,20 @@
 
 
 #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	shrq $16,	src;                     \
-	movl		s1(, RID1, 4), dst ## d; \
-	op1		s2(, RID2, 4), dst ## d; \
-	movzbl		src ## bh,     RID1d;    \
-	movzbl		src ## bl,     RID2d;    \
-	interleave_op(il_reg);			 \
-	op2		s3(, RID1, 4), dst ## d; \
-	op3		s4(, RID2, 4), dst ## d;
+	movzbl		src ## bh,       RID1d;    \
+	leaq		s1(%rip),        RID2;     \
+	movl		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,       RID2d;    \
+	leaq		s2(%rip),        RID1;     \
+	op1		(RID1, RID2, 4), dst ## d; \
+	shrq $16,	src;                       \
+	movzbl		src ## bh,     RID1d;      \
+	leaq		s3(%rip),        RID2;     \
+	op2		(RID2, RID1, 4), dst ## d; \
+	movzbl		src ## bl,     RID2d;      \
+	leaq		s4(%rip),        RID1;     \
+	op3		(RID1, RID2, 4), dst ## d; \
+	interleave_op(il_reg);
 
 #define dummy(d) /* do nothing */
 
@@ -151,15 +155,15 @@
 	subround(l ## 3, r ## 3, l ## 4, r ## 4, f);
 
 #define enc_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR;
 
 #define dec_preload_rkr() \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		kr(CTX),                  RKR, RKR; \
-	vpshufb		.Lbswap128_mask,          RKR, RKR;
+	vpshufb		.Lbswap128_mask(%rip),    RKR, RKR;
 
 #define transpose_2x4(x0, x1, t0, t1) \
 	vpunpckldq		x1, x0, t0; \
@@ -235,9 +239,9 @@ SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	enc_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -271,7 +275,7 @@ SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 	popq %rbx;
 	popq %r15;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 
 	outunpack_blocks(RR1, RL1, RTMP, RX, RKM);
 	outunpack_blocks(RR2, RL2, RTMP, RX, RKM);
@@ -308,9 +312,9 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 	dec_preload_rkr();
 
 	inpack_blocks(RL1, RR1, RTMP, RX, RKM);
@@ -341,7 +345,7 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 	round(RL, RR, 1, 2);
 	round(RR, RL, 0, 1);
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 	popq %rbx;
 	popq %r15;
 
@@ -504,8 +508,8 @@ SYM_FUNC_START(cast5_ctr_16way)
 
 	vpcmpeqd RKR, RKR, RKR;
 	vpaddq RKR, RKR, RKR; /* low: -2, high: -2 */
-	vmovdqa .Lbswap_iv_mask, R1ST;
-	vmovdqa .Lbswap128_mask, RKM;
+	vmovdqa .Lbswap_iv_mask(%rip), R1ST;
+	vmovdqa .Lbswap128_mask(%rip), RKM;
 
 	/* load IV and byteswap */
 	vmovq (%rcx), RX;
-- 
2.39.2


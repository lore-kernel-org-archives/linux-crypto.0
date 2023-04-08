Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B3EC77B6F
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjDHP1y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjDHP1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47622728
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4095D60B42
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B24CC4339E;
        Sat,  8 Apr 2023 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967667;
        bh=z2V/qqJcqdgDfG+2yyztCwnAhUw23li+Y5aLW0QEB5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGqHGCtyvZgcP/Zq9+h1wz62utCB8HpiO/9Lfm5OyGUNxkoblD1pSDJ3xgY3A3uyj
         /XtJSU+f4lO93vJpEyMJGV2yCKj7HPMzVZcl5J9FfiAJv/DUzlCh9mK7Fxfet3SVUo
         sfvbihmBbYL3IbLj4zdDQHe/jtDR8Qb0vVJaAlPKeC2miAWnBLd/9Tb3uDjC7IgSki
         LBYciMw1z1JxlqlKnMt2IkQoIx4I9Z46MVrxUTCAlv/3B2MXMqeKGhqYIXSKpVPMv+
         V5CT6o+ppxNDBVcd0RDCn7Dm//j179CSmXSj+81burHakMlcibfT1YSDLTrb1PXl/v
         +yFaHbEN5cm2g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 06/10] crypto: x86/cast6 - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:18 +0200
Message-Id: <20230408152722.3975985-7-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3361; i=ardb@kernel.org; h=from:subject; bh=z2V/qqJcqdgDfG+2yyztCwnAhUw23li+Y5aLW0QEB5E=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/Wqd4dMC7Zo31erbithf+LL/WHhnH4eX25VkpjcVz y66iu/qKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZZ8nwV+ydxoKlX11lX/BH Ckyf+jbl5/ZV937caba/qMY8Qd/J+Cgjw8bNv7PWTo+89O7vgjvPVjBoTzQW3LxnY7Gtsd3pADH tvawA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S | 44 +++++++++++---------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 82b716fd5dbac65a..180fb9c78de2d315 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
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
 
@@ -175,10 +179,10 @@
 	qop(RD, RC, 1);
 
 #define shuffle(mask) \
-	vpshufb		mask,            RKR, RKR;
+	vpshufb		mask(%rip),            RKR, RKR;
 
 #define preload_rkr(n, do_mask, mask) \
-	vbroadcastss	.L16_mask,                RKR;      \
+	vbroadcastss	.L16_mask(%rip),          RKR;      \
 	/* add 16-bit rotation to key rotations (mod 32) */ \
 	vpxor		(kr+n*16)(CTX),           RKR, RKR; \
 	do_mask(mask);
@@ -258,9 +262,9 @@ SYM_FUNC_START_LOCAL(__cast6_enc_blk8)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 
 	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -284,7 +288,7 @@ SYM_FUNC_START_LOCAL(__cast6_enc_blk8)
 	popq %rbx;
 	popq %r15;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -306,9 +310,9 @@ SYM_FUNC_START_LOCAL(__cast6_dec_blk8)
 
 	movq %rdi, CTX;
 
-	vmovdqa .Lbswap_mask, RKM;
-	vmovd .Lfirst_mask, R1ST;
-	vmovd .L32_mask, R32;
+	vmovdqa .Lbswap_mask(%rip), RKM;
+	vmovd .Lfirst_mask(%rip), R1ST;
+	vmovd .L32_mask(%rip), R32;
 
 	inpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	inpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
@@ -332,7 +336,7 @@ SYM_FUNC_START_LOCAL(__cast6_dec_blk8)
 	popq %rbx;
 	popq %r15;
 
-	vmovdqa .Lbswap_mask, RKM;
+	vmovdqa .Lbswap_mask(%rip), RKM;
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
-- 
2.39.2


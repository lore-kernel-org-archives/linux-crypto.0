Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86853C77B76
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDLLBA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDLLA6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AD965B0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3415163256
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779E3C433D2;
        Wed, 12 Apr 2023 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297256;
        bh=qEHykw/e7t8o+96tpVB/xNNOYi4X5fvmoTrv8XRvmCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyVYsqkDehjfnkV3ZwaaBytDALEmhWSq23F9wtMj/RhVBGk4YhIDtZYNET+XXmUsW
         Ho5c+fp3OypMTnuSxL+9OPANkeX+uFpnN3RfyJMm33GOepWu07oAyKj3hpcroqAShA
         QOilVAlF5EqyfiH6TMP15GRNlEYs+DoofXymLPpPgu3nroZkVVDO2JX+ZB3nyf7rkI
         hnDcrm9eb6X+8TDp5u8pzUmg3XFEv3tBDkddVDPG2GF9BL1uINzdkpYIMosoI/Rc4y
         K4LLpU37Iz982rYpHqLJrqrUh6zpvduwYzg7iuunnNd2XTqS0w3q3ZqbhI9y4WTlL3
         CXDMbdlKs/JpQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 06/13] crypto: x86/cast6 - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:28 +0200
Message-Id: <20230412110035.361447-7-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3224; i=ardb@kernel.org; h=from:subject; bh=qEHykw/e7t8o+96tpVB/xNNOYi4X5fvmoTrv8XRvmCs=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs37MnQOXLh36nBbe63uUsZL7+LOfru9C/dWLz6lbri bP0/qvsKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZvZOR4Q9/UfWKXY46Qj2W KZV1rr/NeKZKBeZoJp29HqPXZmGTzvDfTUOC8/mytesMH989w3Le2zCjPcHQ1Erh2XLuIp/NWhP ZAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Co-developed-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S | 32 +++++++++++---------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index 82b716fd5dbac65a..9e86d460b4092826 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -84,15 +84,19 @@
 
 #define lookup_32bit(src, dst, op1, op2, op3, interleave_op, il_reg) \
 	movzbl		src ## bh,     RID1d;    \
+	leaq		s1(%rip),      RID2;     \
+	movl		(RID2,RID1,4), dst ## d; \
 	movzbl		src ## bl,     RID2d;    \
+	leaq		s2(%rip),      RID1;     \
+	op1		(RID1,RID2,4), dst ## d; \
 	shrq $16,	src;                     \
-	movl		s1(, RID1, 4), dst ## d; \
-	op1		s2(, RID2, 4), dst ## d; \
 	movzbl		src ## bh,     RID1d;    \
+	leaq		s3(%rip),      RID2;     \
+	op2		(RID2,RID1,4), dst ## d; \
 	movzbl		src ## bl,     RID2d;    \
 	interleave_op(il_reg);			 \
-	op2		s3(, RID1, 4), dst ## d; \
-	op3		s4(, RID2, 4), dst ## d;
+	leaq		s4(%rip),      RID1;     \
+	op3		(RID1,RID2,4), dst ## d;
 
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


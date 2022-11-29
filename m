Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEFEC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiK2Qyr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 11:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiK2QyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 11:54:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29656D485
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 08:49:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BBE617F5
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 16:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0019C433C1;
        Tue, 29 Nov 2022 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740546;
        bh=9SaQlin5wIPSWq6g8wiEQHueYYCgsDKbOKZ0VuZfqu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URq6AxQgbJUKmVR/yOoJCXfth/DGQD4tsIfBNcXClyFWyfmyhQWZvXcgl3PnzxG9/
         gENXtdi1Dn4Q3ktgr8tSZIZz5MS7SJKqe61nbqNJLC3vc9ZuASY7jUfwec1JgPDRU4
         NfOJGq2XZnMexQl2ilyM+u4awnvnh1CGTONgShohGucCOPWV05uPZB/wTG707HDmb/
         u6wNgO7Oj1fq/FrHp123ZQ7Ayasq1NO0bDGSaTYQgEbyvUi1OMBLA9D3AZ09fBHgvs
         J1kKkTYee0Oht2SaXtaIiDM37VdaJ7/+ku7rffd5wqKLi6LlReIQK3K1RKmHdpSLNH
         E2+cjo3AJFyxw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/4] crypto: arm64/aes-modes - use frame_push/pop macros consistently
Date:   Tue, 29 Nov 2022 17:48:50 +0100
Message-Id: <20221129164852.2051561-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129164852.2051561-1-ardb@kernel.org>
References: <20221129164852.2051561-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3335; i=ardb@kernel.org; h=from:subject; bh=9SaQlin5wIPSWq6g8wiEQHueYYCgsDKbOKZ0VuZfqu0=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjhjfwPWjIKBspc8Vza4qzgFrGMSyTXBB7j1I4rhmM Tu1O2zOJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY4Y38AAKCRDDTyI5ktmPJCCADA Cp1nu/8+KaItcoizpuHj9k3Mvh6o4lGpSwkBKWXJeQjo32v6/1kI9TPrV27XEj12Ze0AJD03EYAFj7 QAh2662d/qMZsLk4jaRKt4aVZGvOMSiCiu27lCvXhHPmS4WY3OG3PzdKh6YezosVLNsS0DoIzjjnzS cxandBA9r+pLhAXm55Fv6rrBhwcNZQl1AasepJjPdTQzUdJFZiayX3m8zNkbLUVdNWd0X5ODSYl+kG o5iWgHORGS0uttwwqSGxQ5qBbkXuRwBy7qZrzCOYdA+mnin3tQy6WoP2SveeGEZYzYnXqVjCu2mVqT 1oPpIZwaWub+nYtgxuQ3035Xi484MH+oM2h5mqJXSnltWWn3sp4wLZHPl+El8Ov629crZSBhc7I5rp y70+cjtLLgnhgFLjk6gKDcpxRpgidBsV46r+NKtGedFOrATpn36wa8OEqv8NcfyGilaVve2BJOG09L yR6jtkQFViQ2ExaE7/Al/zfK5+xm5An9SyL5ZM+48bhsQ=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the frame_push and frame_pop macros to create the stack frames in
the AES chaining mode wrappers so that they will get PAC and/or shadow
call stack protection when configured.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-modes.S | 34 +++++++-------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 5abc834271f4a610..0e834a2c062cf265 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -52,8 +52,7 @@ SYM_FUNC_END(aes_decrypt_block5x)
 	 */
 
 AES_FUNC_START(aes_ecb_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	0
 
 	enc_prepare	w3, x2, x5
 
@@ -77,14 +76,13 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	subs		w4, w4, #1
 	bne		.Lecbencloop
 .Lecbencout:
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 AES_FUNC_END(aes_ecb_encrypt)
 
 
 AES_FUNC_START(aes_ecb_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	0
 
 	dec_prepare	w3, x2, x5
 
@@ -108,7 +106,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	subs		w4, w4, #1
 	bne		.Lecbdecloop
 .Lecbdecout:
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 AES_FUNC_END(aes_ecb_decrypt)
 
@@ -171,9 +169,6 @@ AES_FUNC_END(aes_cbc_encrypt)
 AES_FUNC_END(aes_essiv_cbc_encrypt)
 
 AES_FUNC_START(aes_essiv_cbc_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
-
 	ld1		{cbciv.16b}, [x5]		/* get iv */
 
 	mov		w8, #14				/* AES-256: 14 rounds */
@@ -182,11 +177,9 @@ AES_FUNC_START(aes_essiv_cbc_decrypt)
 	b		.Lessivcbcdecstart
 
 AES_FUNC_START(aes_cbc_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
-
 	ld1		{cbciv.16b}, [x5]		/* get iv */
 .Lessivcbcdecstart:
+	frame_push	0
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
@@ -236,7 +229,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	bne		.Lcbcdecloop
 .Lcbcdecout:
 	st1		{cbciv.16b}, [x5]		/* return iv */
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 AES_FUNC_END(aes_cbc_decrypt)
 AES_FUNC_END(aes_essiv_cbc_decrypt)
@@ -337,8 +330,7 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 	BLOCKS		.req x13
 	BLOCKS_W	.req w13
 
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	0
 
 	enc_prepare	ROUNDS_W, KEY, IV_PART
 	ld1		{vctr.16b}, [IV]
@@ -481,7 +473,7 @@ ST5(	st1		{v4.16b}, [OUT], #16		)
 	.if !\xctr
 		st1		{vctr.16b}, [IV] /* return next CTR value */
 	.endif
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 
 .Lctrtail\xctr:
@@ -645,8 +637,7 @@ AES_FUNC_END(aes_xctr_encrypt)
 	.endm
 
 AES_FUNC_START(aes_xts_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	0
 
 	ld1		{v4.16b}, [x6]
 	xts_load_mask	v8
@@ -704,7 +695,7 @@ AES_FUNC_START(aes_xts_encrypt)
 	st1		{v0.16b}, [x0]
 .Lxtsencret:
 	st1		{v4.16b}, [x6]
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 
 .LxtsencctsNx:
@@ -732,8 +723,7 @@ AES_FUNC_START(aes_xts_encrypt)
 AES_FUNC_END(aes_xts_encrypt)
 
 AES_FUNC_START(aes_xts_decrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	0
 
 	/* subtract 16 bytes if we are doing CTS */
 	sub		w8, w4, #0x10
@@ -794,7 +784,7 @@ AES_FUNC_START(aes_xts_decrypt)
 	b		.Lxtsdecloop
 .Lxtsdecout:
 	st1		{v4.16b}, [x6]
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 
 .Lxtsdeccts:
-- 
2.35.1


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98E9C4167B
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 16:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiK2QzK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 11:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiK2Qyp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 11:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BB06D97F
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 08:49:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D254B816E6
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 16:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE550C433D6;
        Tue, 29 Nov 2022 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740544;
        bh=oQMUkxvrTm4OuRm3HK0ePgwoHaMfWUymrN1oCIlb2jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOaN4rh6k1CDY798/SmgJ3l2/m7HPaFp/qv8aBLDD6vr0oQWND7XoyXHiiQc69gf/
         s84kJUofyLit14gtkj/xwbOKD8yPEVmiizdzN6FvGNZ9bRrW1ONBqutLsMMhpGZEHE
         dWnks2Bef8fCUisMmTrp9OTsLEgsQVRthPe0WaIdpWCBMuQAbbw2+OBo3X/7GW/9em
         /gyuCVc4/EbZPnwOrdhKw/gEJFIx9I1ZjxA+rOJampNW8kWSTQs4eGOqRJXds5V35j
         TCFmp/GENg1lj6ZZ7AQ7aLFUMkjFMM0kBRRCAJhru8lllyqahCbHNJd8++z3+/M+hP
         8BCc8ePvuNZ0Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/4] crypto: arm64/aes-neonbs - use frame_push/pop consistently
Date:   Tue, 29 Nov 2022 17:48:49 +0100
Message-Id: <20221129164852.2051561-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129164852.2051561-1-ardb@kernel.org>
References: <20221129164852.2051561-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1902; i=ardb@kernel.org; h=from:subject; bh=oQMUkxvrTm4OuRm3HK0ePgwoHaMfWUymrN1oCIlb2jY=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjhjfuqjkvuSq8aMyx5h/TfQRJuuGKk2UmquyRiuAo IQMNdYOJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY4Y37gAKCRDDTyI5ktmPJCvUC/ 0cb3km+z0Qvj0HffLq7ioFO7uB1DlYHHBcKY0MSdqexVFyd/wnPKH3lP5Xm/6TPob7nz3YhGVM3oGd f1YRC65DV10O6BqjDtU+9X70RCJlA5aDglTMNgsoyGOL2EWUYgzBwap4i/+glRcC2xIHGAa/SGPvjF cDpLlm1QA0fNT7Sn6DcdtIS0shkTqBOjOQ+hIeyFrFZ3XXDP0EYFcAtj+TM6hbt4JXDay+m3MstQ0Q H72d51ysDC6A42vZWQD/ewsslJKXUCSJK60sd0eZesp97adxC9tt2y3rsE62FF4iOzeGU+WZo5tJWx LUabmAs/MWahWrIcLzytk1y+TlaE1NJdszRpM0J8MeHKYXkR+O0RDadHz+vVVG1tpRyRb5ZWJCkVNY h+lwfZssKwuK9Z1x8Mo7dmnqwYtbm3WvXmrCgRSY4ACC+deBa0k03V4llx+CNfBsp7EzYCBGOPV/+s RCUp3jUwvUQxbBfnGPIVoBrxujYF+DD2qo+DcskkBp1DM=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the frame_push and frame_pop macros consistently to create the stack
frame, so that we will get PAC and/or shadow call stack handling as well
when enabled.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-neonbs-core.S | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index 66eb3f076fa7a6cf..e4da53b3f189e2bd 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -772,7 +772,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
 	eor		v6.16b, v6.16b, v31.16b
 	eor		v7.16b, v7.16b, v16.16b
 
-	stp		q16, q17, [sp, #16]
+	stp		q16, q17, [x6]
 
 	mov		bskey, x2
 	mov		rounds, x3
@@ -780,8 +780,8 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
 SYM_FUNC_END(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
-	stp		x29, x30, [sp, #-48]!
-	mov		x29, sp
+	frame_push	0, 32
+	add		x6, sp, #.Lframe_local_offset
 
 	ld1		{v25.16b}, [x5]
 
@@ -793,7 +793,7 @@ SYM_FUNC_END(__xts_crypt8)
 	eor		v18.16b, \o2\().16b, v27.16b
 	eor		v19.16b, \o3\().16b, v28.16b
 
-	ldp		q24, q25, [sp, #16]
+	ldp		q24, q25, [x6]
 
 	eor		v20.16b, \o4\().16b, v29.16b
 	eor		v21.16b, \o5\().16b, v30.16b
@@ -807,7 +807,7 @@ SYM_FUNC_END(__xts_crypt8)
 	b.gt		0b
 
 	st1		{v25.16b}, [x5]
-	ldp		x29, x30, [sp], #48
+	frame_pop
 	ret
 	.endm
 
@@ -832,9 +832,7 @@ SYM_FUNC_END(aesbs_xts_decrypt)
 	 *		     int rounds, int blocks, u8 iv[])
 	 */
 SYM_FUNC_START(aesbs_ctr_encrypt)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
-
+	frame_push	0
 	ldp		x7, x8, [x5]
 	ld1		{v0.16b}, [x5]
 CPU_LE(	rev		x7, x7		)
@@ -874,6 +872,6 @@ CPU_LE(	rev		x8, x8		)
 	b.gt		0b
 
 	st1		{v0.16b}, [x5]
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	ret
 SYM_FUNC_END(aesbs_ctr_encrypt)
-- 
2.35.1


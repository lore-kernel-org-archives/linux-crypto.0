Return-Path: <SRS0=gJ+M=IF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0356AC433DB
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24B9650F7
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhCGQyw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Mar 2021 11:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhCGQyk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Mar 2021 11:54:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA17650F7;
        Sun,  7 Mar 2021 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615136080;
        bh=sRnuXXD7TlfFv4eImJMtLg/XRHVEyLz/rJplHnrqJ5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmD5feJRT/m5WjVhVrMiryy2N3E/TYW1urTAJpWyrct8FRurRkNyvJq8z4M4bW4YS
         aa6fuFApzqY7pyxd8QUcCsbezkcusnzvNsUOY6mn0yY0BhZC+lXuvSCne/t2rLWcrM
         nBvLGICrOr2iPVcrs0m1ZQ59lvWBPoNoXelQahlS0EiyvWCjkNHmaJ8uYoi+954ubj
         X2Ivgd4nxjycAQng+BcqQo6ecRZS/dOHlqGfTkwnQ50+hM5W5VJeOWDI1PPIxQL7TI
         MWieH9kNXhi7gxj16RHjyQrkC1TU0Bw2S/PupMXdwoOTw/R+mwvi3usGZdHeaRDzbg
         uHbO5IaCl8qqA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Eric Biggers <ebiggers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 2/2] crypto: arm/chacha-scalar - switch to common rev_32 macro
Date:   Sun,  7 Mar 2021 17:54:24 +0100
Message-Id: <20210307165424.165188-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307165424.165188-1-ardb@kernel.org>
References: <20210307165424.165188-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the local definition of a byte swapping macro and use the common
one instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/crypto/chacha-scalar-core.S | 43 ++++++--------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/arch/arm/crypto/chacha-scalar-core.S b/arch/arm/crypto/chacha-scalar-core.S
index 2985b80a45b5..083fe1ab96d0 100644
--- a/arch/arm/crypto/chacha-scalar-core.S
+++ b/arch/arm/crypto/chacha-scalar-core.S
@@ -41,32 +41,15 @@
 	X14	.req	r12
 	X15	.req	r14
 
-.macro __rev		out, in,  t0, t1, t2
-.if __LINUX_ARM_ARCH__ >= 6
-	rev		\out, \in
-.else
-	lsl		\t0, \in, #24
-	and		\t1, \in, #0xff00
-	and		\t2, \in, #0xff0000
-	orr		\out, \t0, \in, lsr #24
-	orr		\out, \out, \t1, lsl #8
-	orr		\out, \out, \t2, lsr #8
-.endif
-.endm
-
-.macro _le32_bswap	x,  t0, t1, t2
+.macro _le32_bswap_4x	a, b, c, d,  tmp
 #ifdef __ARMEB__
-	__rev		\x, \x,  \t0, \t1, \t2
+	rev_l		\a,  \tmp
+	rev_l		\b,  \tmp
+	rev_l		\c,  \tmp
+	rev_l		\d,  \tmp
 #endif
 .endm
 
-.macro _le32_bswap_4x	a, b, c, d,  t0, t1, t2
-	_le32_bswap	\a,  \t0, \t1, \t2
-	_le32_bswap	\b,  \t0, \t1, \t2
-	_le32_bswap	\c,  \t0, \t1, \t2
-	_le32_bswap	\d,  \t0, \t1, \t2
-.endm
-
 .macro __ldrd		a, b, src, offset
 #if __LINUX_ARM_ARCH__ >= 6
 	ldrd		\a, \b, [\src, #\offset]
@@ -200,7 +183,7 @@
 	add		X1, X1, r9
 	add		X2, X2, r10
 	add		X3, X3, r11
-	_le32_bswap_4x	X0, X1, X2, X3,  r8, r9, r10
+	_le32_bswap_4x	X0, X1, X2, X3,  r8
 	ldmia		r12!, {r8-r11}
 	eor		X0, X0, r8
 	eor		X1, X1, r9
@@ -216,7 +199,7 @@
 	ldmia		r12!, {X0-X3}
 	add		X6, r10, X6, ror #brot
 	add		X7, r11, X7, ror #brot
-	_le32_bswap_4x	X4, X5, X6, X7,  r8, r9, r10
+	_le32_bswap_4x	X4, X5, X6, X7,  r8
 	eor		X4, X4, X0
 	eor		X5, X5, X1
 	eor		X6, X6, X2
@@ -231,7 +214,7 @@
 	add		r1, r1, r9		// x9
 	add		r6, r6, r10		// x10
 	add		r7, r7, r11		// x11
-	_le32_bswap_4x	r0, r1, r6, r7,  r8, r9, r10
+	_le32_bswap_4x	r0, r1, r6, r7,  r8
 	ldmia		r12!, {r8-r11}
 	eor		r0, r0, r8		// x8
 	eor		r1, r1, r9		// x9
@@ -245,7 +228,7 @@
 	add		r3, r9, r3, ror #drot	// x13
 	add		r4, r10, r4, ror #drot	// x14
 	add		r5, r11, r5, ror #drot	// x15
-	_le32_bswap_4x	r2, r3, r4, r5,  r9, r10, r11
+	_le32_bswap_4x	r2, r3, r4, r5,  r9
 	  ldr		r9, [sp, #72]		// load LEN
 	eor		r2, r2, r0		// x12
 	eor		r3, r3, r1		// x13
@@ -301,7 +284,7 @@
 	add		X1, X1, r9
 	add		X2, X2, r10
 	add		X3, X3, r11
-	_le32_bswap_4x	X0, X1, X2, X3,  r8, r9, r10
+	_le32_bswap_4x	X0, X1, X2, X3,  r8
 	stmia		r14!, {X0-X3}
 
 	// Save keystream for x4-x7
@@ -311,7 +294,7 @@
 	add		X5, r9, X5, ror #brot
 	add		X6, r10, X6, ror #brot
 	add		X7, r11, X7, ror #brot
-	_le32_bswap_4x	X4, X5, X6, X7,  r8, r9, r10
+	_le32_bswap_4x	X4, X5, X6, X7,  r8
 	  add		r8, sp, #64
 	stmia		r14!, {X4-X7}
 
@@ -323,7 +306,7 @@
 	add		r1, r1, r9		// x9
 	add		r6, r6, r10		// x10
 	add		r7, r7, r11		// x11
-	_le32_bswap_4x	r0, r1, r6, r7,  r8, r9, r10
+	_le32_bswap_4x	r0, r1, r6, r7,  r8
 	stmia		r14!, {r0,r1,r6,r7}
 	__ldrd		r8, r9, sp, 144
 	__ldrd		r10, r11, sp, 152
@@ -331,7 +314,7 @@
 	add		r3, r9, r3, ror #drot	// x13
 	add		r4, r10, r4, ror #drot	// x14
 	add		r5, r11, r5, ror #drot	// x15
-	_le32_bswap_4x	r2, r3, r4, r5,  r9, r10, r11
+	_le32_bswap_4x	r2, r3, r4, r5,  r9
 	stmia		r14, {r2-r5}
 
 	// Stack: ks0-ks15 unused0-unused7 x0-x15 OUT IN LEN
-- 
2.30.1


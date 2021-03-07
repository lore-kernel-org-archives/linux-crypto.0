Return-Path: <SRS0=gJ+M=IF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9B9C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8C6650FA
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Mar 2021 16:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhCGQyv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Mar 2021 11:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhCGQyi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Mar 2021 11:54:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AC664F24;
        Sun,  7 Mar 2021 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615136077;
        bh=QQ6iRUBjvne4w+erRM0/caOkhugUfV9fXLFyPXMweqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atXOjUzIydD6CzfTM0pslSjscitT5CZP/+NMcfW9dRY5QeEqhY4bpYWq0sDDnp7WI
         EiTiwZdrMOZoCtZQMtSxcJcBPrPgRHFD11jRU0s9cSGpgR79QJHwjwcGd8wDREBeVp
         wNYqoTjpiqbVKZRtODxdnLnjawF5kaq6fGiglF5u0XxSZGo12oX29lCNybs0ikDr+e
         cS14G5hlFroLrQKidnHl5IGmlGbuOBnA+da1S2XuDAptkQFpnw5J9358qfVI0F1fIu
         ny+fHER0Hjw56A/JW0uBqlsMJqPcCoqkRQkUfpYEgdJNJ7iTxTXE4PNK+POBBd+k7R
         lNHbrtA3TJbPg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Nicolas Pitre <nico@fluxnic.net>,
        Eric Biggers <ebiggers@google.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 1/2] crypto: arm/aes-scalar - switch to common rev_32/mov_l macros
Date:   Sun,  7 Mar 2021 17:54:23 +0100
Message-Id: <20210307165424.165188-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307165424.165188-1-ardb@kernel.org>
References: <20210307165424.165188-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The scalar AES implementation has some locally defined macros which
reimplement things that are now available in macros defined in
assembler.h. So let's switch to those.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/crypto/aes-cipher-core.S | 42 +++++---------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index 472e56d09eea..1da3f41359aa 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -99,28 +99,6 @@
 	__hround	\out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op, \oldcpsr
 	.endm
 
-	.macro		__rev, out, in
-	.if		__LINUX_ARM_ARCH__ < 6
-	lsl		t0, \in, #24
-	and		t1, \in, #0xff00
-	and		t2, \in, #0xff0000
-	orr		\out, t0, \in, lsr #24
-	orr		\out, \out, t1, lsl #8
-	orr		\out, \out, t2, lsr #8
-	.else
-	rev		\out, \in
-	.endif
-	.endm
-
-	.macro		__adrl, out, sym, c
-	.if		__LINUX_ARM_ARCH__ < 7
-	ldr\c		\out, =\sym
-	.else
-	movw\c		\out, #:lower16:\sym
-	movt\c		\out, #:upper16:\sym
-	.endif
-	.endm
-
 	.macro		do_crypt, round, ttab, ltab, bsz
 	push		{r3-r11, lr}
 
@@ -133,10 +111,10 @@
 	ldr		r7, [in, #12]
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
-	__rev		r4, r4
-	__rev		r5, r5
-	__rev		r6, r6
-	__rev		r7, r7
+	rev_l		r4, t0
+	rev_l		r5, t0
+	rev_l		r6, t0
+	rev_l		r7, t0
 #endif
 
 	eor		r4, r4, r8
@@ -144,7 +122,7 @@
 	eor		r6, r6, r10
 	eor		r7, r7, r11
 
-	__adrl		ttab, \ttab
+	mov_l		ttab, \ttab
 	/*
 	 * Disable interrupts and prefetch the 1024-byte 'ft' or 'it' table into
 	 * L1 cache, assuming cacheline size >= 32.  This is a hardening measure
@@ -180,7 +158,7 @@
 2:	.ifb		\ltab
 	add		ttab, ttab, #1
 	.else
-	__adrl		ttab, \ltab
+	mov_l		ttab, \ltab
 	// Prefetch inverse S-box for final round; see explanation above
 	.set		i, 0
 	.rept		256 / 64
@@ -194,10 +172,10 @@
 	\round		r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b, rounds
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
-	__rev		r4, r4
-	__rev		r5, r5
-	__rev		r6, r6
-	__rev		r7, r7
+	rev_l		r4, t0
+	rev_l		r5, t0
+	rev_l		r6, t0
+	rev_l		r7, t0
 #endif
 
 	ldr		out, [sp]
-- 
2.30.1


Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04426ECE596
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD22120700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kBI4CL5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfJGQrB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:47:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbfJGQrB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:47:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so454167wme.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DseypCii1mb2+41Q6zcO+oiJG2CWF//1CSOaDe2o/do=;
        b=kBI4CL5gID7MoE8jUA3yGyasxw5Uixh3r1N6IR8uBXYy5au918de3lS2lJIbTglbYH
         UFBszvZe3FEQvISzjKscrD3OQQ2tgJkGAYz2YglZdP1CBErKuILUTTGtJkzHLgseN+Y8
         CUKHJs3c3WiLz2XdkeR1QUOYeRIS/mYB0xzJqus71tD2ARHntmgsoHGvme+Nqg9+t2XZ
         +eAk3Y+U7B5vnmsk/rn6/aNFLvHlAP9nFyucyR04mO9tXa8SFP9OUwDG98gqRjrpHnUW
         EVQpX0LcBhMRJhSaXNRS7czm8gOACuGmNATY41HIIBvcYjCV2Qz2S8+1KqFYBNjgwYrH
         7CIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DseypCii1mb2+41Q6zcO+oiJG2CWF//1CSOaDe2o/do=;
        b=QVVVWSVELui++1lmw2XE3+jO/Oi8hQ/bZi7kRuK6RC+bT4C2DR29HxZzlzk3bs313L
         9Q/tSadclWWsusr+IP0oud8Yti3Q+V2PsYvQOep9tXlOMXDx4eRG/BAjisoOx0jfih2a
         rY/it/GvtdrTbSnuAxd8XaaJwZFlQliWk3eIf8AkPd6bWSK24LD0efnW9RDM1qfypJ27
         obtEDYTIRCtL061j3jL7E8mqTdzxLa7hTcS8DX8ipY59V5EvSj4O1knuVpkTWuXTjzyc
         Urn30voR0mPJJ9LKXFmK+FUCHw+jMN0TT4sVgpdkjMvhHThnwCmOYFk5kViPv6lW1Es2
         vwyg==
X-Gm-Message-State: APjAAAXp8pMgPddlswEGkCxhCSwnvJBQamVBCUxUfebn3or98yCANJq6
        tPkfWixYWfY7yP5ssRYU5xd2VXXjHn5Yeg==
X-Google-Smtp-Source: APXvYqzg1SyTIUdH3fGOD5mZxkzbYasDcSWbJc773HmPohC4NVOE3QdhdagOIwZ3fn+BHwobZGvEDA==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr192221wma.16.1570466817418;
        Mon, 07 Oct 2019 09:46:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 27/29] crypto: arm/Curve25519 - wire up NEON implementation
Date:   Mon,  7 Oct 2019 18:46:08 +0200
Message-Id: <20191007164610.6881-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

This ports the SUPERCOP implementation for usage in kernel space. In
addition to the usual header, macro, and style changes required for
kernel space, it makes a few small changes to the code:

  - The stack alignment is relaxed to 16 bytes.
  - Superfluous mov statements have been removed.
  - ldr for constants has been replaced with movw.
  - ldreq has been replaced with moveq.
  - The str epilogue has been made more idiomatic.
  - SIMD registers are not pushed and popped at the beginning and end.
  - The prologue and epilogue have been made idiomatic.
  - A hole has been removed from the stack, saving 32 bytes.
  - We write-back the base register whenever possible for vld1.8.
  - Some multiplications have been reordered for better A7 performance.

There are more opportunities for cleanup, since this code is from qhasm,
which doesn't always do the most opportune thing. But even prior to
extensive hand optimizations, this code delivers significant performance
improvements (given in get_cycles() per call):

		      ----------- -------------
	             | generic C | this commit |
	 ------------ ----------- -------------
	| Cortex-A7  |     49136 |       22395 |
	 ------------ ----------- -------------
	| Cortex-A17 |     17326 |        4983 |
	 ------------ ----------- -------------

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig           |   6 +
 arch/arm/crypto/Makefile          |   2 +
 arch/arm/crypto/curve25519-core.S | 347 +++++++++-----------
 arch/arm/crypto/curve25519-glue.c |  52 +++
 4 files changed, 212 insertions(+), 195 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 19411f82468e..a618f3e65822 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -140,4 +140,10 @@ config CRYPTO_NHPOLY1305_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_NHPOLY1305
 
+config CRYPTO_LIB_CURVE25519_NEON
+	tristate "NEON accelerated Curve25519 scalar multiplication library"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_LIB_CURVE25519
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+
 endif
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 521bca069457..181691340df8 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 obj-$(CONFIG_CRYPTO_POLY1305_ARM) += poly1305-arm.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_NEON) += libcurve25519-neon.o
 
 ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
@@ -58,6 +59,7 @@ chacha-neon-y := chacha-scalar-core.o chacha-glue.o
 chacha-neon-$(CONFIG_KERNEL_MODE_NEON) += chacha-neon-core.o
 poly1305-arm-y := poly1305-core.o poly1305-glue.o
 nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
+libcurve25519-neon-y := curve25519-core.o curve25519-glue.o
 
 ifdef REGENERATE_ARM_CRYPTO
 quiet_cmd_perl = PERL    $@
diff --git a/arch/arm/crypto/curve25519-core.S b/arch/arm/crypto/curve25519-core.S
index f33b85fef382..be18af52e7dc 100644
--- a/arch/arm/crypto/curve25519-core.S
+++ b/arch/arm/crypto/curve25519-core.S
@@ -1,43 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
 /*
- * Public domain code from Daniel J. Bernstein and Peter Schwabe, from
- * SUPERCOP's curve25519/neon2/scalarmult.s.
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * Based on public domain code from Daniel J. Bernstein and Peter Schwabe. This
+ * began from SUPERCOP's curve25519/neon2/scalarmult.s, but has subsequently been
+ * manually reworked for use in kernel space.
  */
 
-.fpu neon
+#include <linux/linkage.h>
+
 .text
+.fpu neon
+.arch armv7-a
 .align 4
-.global _crypto_scalarmult_curve25519_neon2
-.global crypto_scalarmult_curve25519_neon2
-.type _crypto_scalarmult_curve25519_neon2 STT_FUNC
-.type crypto_scalarmult_curve25519_neon2 STT_FUNC
-	_crypto_scalarmult_curve25519_neon2:
-	crypto_scalarmult_curve25519_neon2:
-	vpush		{q4, q5, q6, q7}
-	mov		r12, sp
-	sub		sp, sp, #736
-	and		sp, sp, #0xffffffe0
-	strd		r4, [sp, #0]
-	strd		r6, [sp, #8]
-	strd		r8, [sp, #16]
-	strd		r10, [sp, #24]
-	str		r12, [sp, #480]
-	str		r14, [sp, #484]
-	mov		r0, r0
-	mov		r1, r1
-	mov		r2, r2
-	add		r3, sp, #32
-	ldr		r4, =0
-	ldr		r5, =254
+
+ENTRY(curve25519_neon)
+	push		{r4-r11, lr}
+	mov		ip, sp
+	sub		r3, sp, #704
+	and		r3, r3, #0xfffffff0
+	mov		sp, r3
+	movw		r4, #0
+	movw		r5, #254
 	vmov.i32	q0, #1
 	vshr.u64	q1, q0, #7
 	vshr.u64	q0, q0, #8
 	vmov.i32	d4, #19
 	vmov.i32	d5, #38
-	add		r6, sp, #512
-	vst1.8		{d2-d3}, [r6, : 128]
-	add		r6, sp, #528
-	vst1.8		{d0-d1}, [r6, : 128]
-	add		r6, sp, #544
+	add		r6, sp, #480
+	vst1.8		{d2-d3}, [r6, : 128]!
+	vst1.8		{d0-d1}, [r6, : 128]!
 	vst1.8		{d4-d5}, [r6, : 128]
 	add		r6, r3, #0
 	vmov.i32	q2, #0
@@ -45,12 +37,12 @@
 	vst1.8		{d4-d5}, [r6, : 128]!
 	vst1.8		d4, [r6, : 64]
 	add		r6, r3, #0
-	ldr		r7, =960
+	movw		r7, #960
 	sub		r7, r7, #2
 	neg		r7, r7
 	sub		r7, r7, r7, LSL #7
 	str		r7, [r6]
-	add		r6, sp, #704
+	add		r6, sp, #672
 	vld1.8		{d4-d5}, [r1]!
 	vld1.8		{d6-d7}, [r1]
 	vst1.8		{d4-d5}, [r6, : 128]!
@@ -212,15 +204,15 @@
 	vst1.8		{d0-d1}, [r6, : 128]!
 	vst1.8		{d2-d3}, [r6, : 128]!
 	vst1.8		d4, [r6, : 64]
-._mainloop:
+.Lmainloop:
 	mov		r2, r5, LSR #3
 	and		r6, r5, #7
 	ldrb		r2, [r1, r2]
 	mov		r2, r2, LSR r6
 	and		r2, r2, #1
-	str		r5, [sp, #488]
+	str		r5, [sp, #456]
 	eor		r4, r4, r2
-	str		r2, [sp, #492]
+	str		r2, [sp, #460]
 	neg		r2, r4
 	add		r4, r3, #96
 	add		r5, r3, #192
@@ -291,7 +283,7 @@
 	vsub.i32	q0, q1, q3
 	vst1.8		d4, [r4, : 64]
 	vst1.8		d0, [r6, : 64]
-	add		r2, sp, #544
+	add		r2, sp, #512
 	add		r4, r3, #96
 	add		r5, r3, #144
 	vld1.8		{d0-d1}, [r2, : 128]
@@ -361,14 +353,13 @@
 	vmlal.s32	q0, d12, d8
 	vmlal.s32	q0, d13, d17
 	vmlal.s32	q0, d6, d6
-	add		r2, sp, #512
-	vld1.8		{d18-d19}, [r2, : 128]
+	add		r2, sp, #480
+	vld1.8		{d18-d19}, [r2, : 128]!
 	vmull.s32	q3, d16, d7
 	vmlal.s32	q3, d10, d15
 	vmlal.s32	q3, d11, d14
 	vmlal.s32	q3, d12, d9
 	vmlal.s32	q3, d13, d8
-	add		r2, sp, #528
 	vld1.8		{d8-d9}, [r2, : 128]
 	vadd.i64	q5, q12, q9
 	vadd.i64	q6, q15, q9
@@ -502,22 +493,19 @@
 	vadd.i32	q5, q5, q0
 	vtrn.32		q11, q14
 	vadd.i32	q6, q6, q3
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vadd.i32	q10, q10, q2
 	vtrn.32		d24, d25
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q6, q13, #1
-	add		r2, sp, #576
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vshl.i32	q10, q14, #1
-	add		r2, sp, #592
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q15, q12, #1
 	vadd.i32	q8, q8, q4
 	vext.32		d10, d31, d30, #0
 	vadd.i32	q7, q7, q1
-	add		r2, sp, #608
-	vst1.8		{d16-d17}, [r2, : 128]
+	vst1.8		{d16-d17}, [r2, : 128]!
 	vmull.s32	q8, d18, d5
 	vmlal.s32	q8, d26, d4
 	vmlal.s32	q8, d19, d9
@@ -528,8 +516,7 @@
 	vmlal.s32	q8, d29, d1
 	vmlal.s32	q8, d24, d6
 	vmlal.s32	q8, d25, d0
-	add		r2, sp, #624
-	vst1.8		{d14-d15}, [r2, : 128]
+	vst1.8		{d14-d15}, [r2, : 128]!
 	vmull.s32	q2, d18, d4
 	vmlal.s32	q2, d12, d9
 	vmlal.s32	q2, d13, d8
@@ -537,8 +524,7 @@
 	vmlal.s32	q2, d22, d2
 	vmlal.s32	q2, d23, d1
 	vmlal.s32	q2, d24, d0
-	add		r2, sp, #640
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vmull.s32	q7, d18, d9
 	vmlal.s32	q7, d26, d3
 	vmlal.s32	q7, d19, d8
@@ -547,14 +533,12 @@
 	vmlal.s32	q7, d28, d1
 	vmlal.s32	q7, d23, d6
 	vmlal.s32	q7, d29, d0
-	add		r2, sp, #656
-	vst1.8		{d10-d11}, [r2, : 128]
+	vst1.8		{d10-d11}, [r2, : 128]!
 	vmull.s32	q5, d18, d3
 	vmlal.s32	q5, d19, d2
 	vmlal.s32	q5, d22, d1
 	vmlal.s32	q5, d23, d0
 	vmlal.s32	q5, d12, d8
-	add		r2, sp, #672
 	vst1.8		{d16-d17}, [r2, : 128]
 	vmull.s32	q4, d18, d8
 	vmlal.s32	q4, d26, d2
@@ -566,7 +550,7 @@
 	vmlal.s32	q8, d26, d1
 	vmlal.s32	q8, d19, d6
 	vmlal.s32	q8, d27, d0
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q7, d24, d21
 	vmlal.s32	q7, d25, d20
@@ -575,32 +559,30 @@
 	vmlal.s32	q8, d22, d21
 	vmlal.s32	q8, d28, d20
 	vmlal.s32	q5, d24, d20
-	add		r2, sp, #576
 	vst1.8		{d14-d15}, [r2, : 128]
 	vmull.s32	q7, d18, d6
 	vmlal.s32	q7, d26, d0
-	add		r2, sp, #656
+	add		r2, sp, #624
 	vld1.8		{d30-d31}, [r2, : 128]
 	vmlal.s32	q2, d30, d21
 	vmlal.s32	q7, d19, d21
 	vmlal.s32	q7, d27, d20
-	add		r2, sp, #624
+	add		r2, sp, #592
 	vld1.8		{d26-d27}, [r2, : 128]
 	vmlal.s32	q4, d25, d27
 	vmlal.s32	q8, d29, d27
 	vmlal.s32	q8, d25, d26
 	vmlal.s32	q7, d28, d27
 	vmlal.s32	q7, d29, d26
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d28-d29}, [r2, : 128]
 	vmlal.s32	q4, d24, d29
 	vmlal.s32	q8, d23, d29
 	vmlal.s32	q8, d24, d28
 	vmlal.s32	q7, d22, d29
 	vmlal.s32	q7, d23, d28
-	add		r2, sp, #608
 	vst1.8		{d8-d9}, [r2, : 128]
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vld1.8		{d8-d9}, [r2, : 128]
 	vmlal.s32	q7, d24, d9
 	vmlal.s32	q7, d25, d31
@@ -621,36 +603,36 @@
 	vmlal.s32	q0, d23, d26
 	vmlal.s32	q0, d24, d31
 	vmlal.s32	q0, d19, d20
-	add		r2, sp, #640
+	add		r2, sp, #608
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q2, d18, d7
-	vmlal.s32	q2, d19, d6
 	vmlal.s32	q5, d18, d6
-	vmlal.s32	q5, d19, d21
 	vmlal.s32	q1, d18, d21
-	vmlal.s32	q1, d19, d29
 	vmlal.s32	q0, d18, d28
-	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d18, d29
+	vmlal.s32	q2, d19, d6
+	vmlal.s32	q5, d19, d21
+	vmlal.s32	q1, d19, d29
+	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d19, d28
-	add		r2, sp, #592
+	add		r2, sp, #560
 	vld1.8		{d18-d19}, [r2, : 128]
-	add		r2, sp, #512
+	add		r2, sp, #480
 	vld1.8		{d22-d23}, [r2, : 128]
 	vmlal.s32	q5, d19, d7
 	vmlal.s32	q0, d18, d21
 	vmlal.s32	q0, d19, d29
 	vmlal.s32	q6, d18, d6
-	add		r2, sp, #528
+	add		r2, sp, #496
 	vld1.8		{d6-d7}, [r2, : 128]
 	vmlal.s32	q6, d19, d21
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q0, d30, d8
-	add		r2, sp, #672
+	add		r2, sp, #640
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q5, d30, d29
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d24-d25}, [r2, : 128]
 	vmlal.s32	q1, d30, d28
 	vadd.i64	q13, q0, q11
@@ -823,22 +805,19 @@
 	vadd.i32	q5, q5, q0
 	vtrn.32		q11, q14
 	vadd.i32	q6, q6, q3
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vadd.i32	q10, q10, q2
 	vtrn.32		d24, d25
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q6, q13, #1
-	add		r2, sp, #576
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vshl.i32	q10, q14, #1
-	add		r2, sp, #592
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q15, q12, #1
 	vadd.i32	q8, q8, q4
 	vext.32		d10, d31, d30, #0
 	vadd.i32	q7, q7, q1
-	add		r2, sp, #608
-	vst1.8		{d16-d17}, [r2, : 128]
+	vst1.8		{d16-d17}, [r2, : 128]!
 	vmull.s32	q8, d18, d5
 	vmlal.s32	q8, d26, d4
 	vmlal.s32	q8, d19, d9
@@ -849,8 +828,7 @@
 	vmlal.s32	q8, d29, d1
 	vmlal.s32	q8, d24, d6
 	vmlal.s32	q8, d25, d0
-	add		r2, sp, #624
-	vst1.8		{d14-d15}, [r2, : 128]
+	vst1.8		{d14-d15}, [r2, : 128]!
 	vmull.s32	q2, d18, d4
 	vmlal.s32	q2, d12, d9
 	vmlal.s32	q2, d13, d8
@@ -858,8 +836,7 @@
 	vmlal.s32	q2, d22, d2
 	vmlal.s32	q2, d23, d1
 	vmlal.s32	q2, d24, d0
-	add		r2, sp, #640
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vmull.s32	q7, d18, d9
 	vmlal.s32	q7, d26, d3
 	vmlal.s32	q7, d19, d8
@@ -868,15 +845,13 @@
 	vmlal.s32	q7, d28, d1
 	vmlal.s32	q7, d23, d6
 	vmlal.s32	q7, d29, d0
-	add		r2, sp, #656
-	vst1.8		{d10-d11}, [r2, : 128]
+	vst1.8		{d10-d11}, [r2, : 128]!
 	vmull.s32	q5, d18, d3
 	vmlal.s32	q5, d19, d2
 	vmlal.s32	q5, d22, d1
 	vmlal.s32	q5, d23, d0
 	vmlal.s32	q5, d12, d8
-	add		r2, sp, #672
-	vst1.8		{d16-d17}, [r2, : 128]
+	vst1.8		{d16-d17}, [r2, : 128]!
 	vmull.s32	q4, d18, d8
 	vmlal.s32	q4, d26, d2
 	vmlal.s32	q4, d19, d7
@@ -887,7 +862,7 @@
 	vmlal.s32	q8, d26, d1
 	vmlal.s32	q8, d19, d6
 	vmlal.s32	q8, d27, d0
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q7, d24, d21
 	vmlal.s32	q7, d25, d20
@@ -896,32 +871,30 @@
 	vmlal.s32	q8, d22, d21
 	vmlal.s32	q8, d28, d20
 	vmlal.s32	q5, d24, d20
-	add		r2, sp, #576
 	vst1.8		{d14-d15}, [r2, : 128]
 	vmull.s32	q7, d18, d6
 	vmlal.s32	q7, d26, d0
-	add		r2, sp, #656
+	add		r2, sp, #624
 	vld1.8		{d30-d31}, [r2, : 128]
 	vmlal.s32	q2, d30, d21
 	vmlal.s32	q7, d19, d21
 	vmlal.s32	q7, d27, d20
-	add		r2, sp, #624
+	add		r2, sp, #592
 	vld1.8		{d26-d27}, [r2, : 128]
 	vmlal.s32	q4, d25, d27
 	vmlal.s32	q8, d29, d27
 	vmlal.s32	q8, d25, d26
 	vmlal.s32	q7, d28, d27
 	vmlal.s32	q7, d29, d26
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d28-d29}, [r2, : 128]
 	vmlal.s32	q4, d24, d29
 	vmlal.s32	q8, d23, d29
 	vmlal.s32	q8, d24, d28
 	vmlal.s32	q7, d22, d29
 	vmlal.s32	q7, d23, d28
-	add		r2, sp, #608
 	vst1.8		{d8-d9}, [r2, : 128]
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vld1.8		{d8-d9}, [r2, : 128]
 	vmlal.s32	q7, d24, d9
 	vmlal.s32	q7, d25, d31
@@ -942,36 +915,36 @@
 	vmlal.s32	q0, d23, d26
 	vmlal.s32	q0, d24, d31
 	vmlal.s32	q0, d19, d20
-	add		r2, sp, #640
+	add		r2, sp, #608
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q2, d18, d7
-	vmlal.s32	q2, d19, d6
 	vmlal.s32	q5, d18, d6
-	vmlal.s32	q5, d19, d21
 	vmlal.s32	q1, d18, d21
-	vmlal.s32	q1, d19, d29
 	vmlal.s32	q0, d18, d28
-	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d18, d29
+	vmlal.s32	q2, d19, d6
+	vmlal.s32	q5, d19, d21
+	vmlal.s32	q1, d19, d29
+	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d19, d28
-	add		r2, sp, #592
+	add		r2, sp, #560
 	vld1.8		{d18-d19}, [r2, : 128]
-	add		r2, sp, #512
+	add		r2, sp, #480
 	vld1.8		{d22-d23}, [r2, : 128]
 	vmlal.s32	q5, d19, d7
 	vmlal.s32	q0, d18, d21
 	vmlal.s32	q0, d19, d29
 	vmlal.s32	q6, d18, d6
-	add		r2, sp, #528
+	add		r2, sp, #496
 	vld1.8		{d6-d7}, [r2, : 128]
 	vmlal.s32	q6, d19, d21
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q0, d30, d8
-	add		r2, sp, #672
+	add		r2, sp, #640
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q5, d30, d29
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d24-d25}, [r2, : 128]
 	vmlal.s32	q1, d30, d28
 	vadd.i64	q13, q0, q11
@@ -1069,7 +1042,7 @@
 	sub		r4, r4, #24
 	vst1.8		d0, [r2, : 64]
 	vst1.8		d1, [r4, : 64]
-	add		r2, sp, #544
+	add		r2, sp, #512
 	add		r4, r3, #144
 	add		r5, r3, #192
 	vld1.8		{d0-d1}, [r2, : 128]
@@ -1139,14 +1112,13 @@
 	vmlal.s32	q0, d12, d8
 	vmlal.s32	q0, d13, d17
 	vmlal.s32	q0, d6, d6
-	add		r2, sp, #512
-	vld1.8		{d18-d19}, [r2, : 128]
+	add		r2, sp, #480
+	vld1.8		{d18-d19}, [r2, : 128]!
 	vmull.s32	q3, d16, d7
 	vmlal.s32	q3, d10, d15
 	vmlal.s32	q3, d11, d14
 	vmlal.s32	q3, d12, d9
 	vmlal.s32	q3, d13, d8
-	add		r2, sp, #528
 	vld1.8		{d8-d9}, [r2, : 128]
 	vadd.i64	q5, q12, q9
 	vadd.i64	q6, q15, q9
@@ -1295,22 +1267,19 @@
 	vadd.i32	q5, q5, q0
 	vtrn.32		q11, q14
 	vadd.i32	q6, q6, q3
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vadd.i32	q10, q10, q2
 	vtrn.32		d24, d25
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q6, q13, #1
-	add		r2, sp, #576
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vshl.i32	q10, q14, #1
-	add		r2, sp, #592
-	vst1.8		{d12-d13}, [r2, : 128]
+	vst1.8		{d12-d13}, [r2, : 128]!
 	vshl.i32	q15, q12, #1
 	vadd.i32	q8, q8, q4
 	vext.32		d10, d31, d30, #0
 	vadd.i32	q7, q7, q1
-	add		r2, sp, #608
-	vst1.8		{d16-d17}, [r2, : 128]
+	vst1.8		{d16-d17}, [r2, : 128]!
 	vmull.s32	q8, d18, d5
 	vmlal.s32	q8, d26, d4
 	vmlal.s32	q8, d19, d9
@@ -1321,8 +1290,7 @@
 	vmlal.s32	q8, d29, d1
 	vmlal.s32	q8, d24, d6
 	vmlal.s32	q8, d25, d0
-	add		r2, sp, #624
-	vst1.8		{d14-d15}, [r2, : 128]
+	vst1.8		{d14-d15}, [r2, : 128]!
 	vmull.s32	q2, d18, d4
 	vmlal.s32	q2, d12, d9
 	vmlal.s32	q2, d13, d8
@@ -1330,8 +1298,7 @@
 	vmlal.s32	q2, d22, d2
 	vmlal.s32	q2, d23, d1
 	vmlal.s32	q2, d24, d0
-	add		r2, sp, #640
-	vst1.8		{d20-d21}, [r2, : 128]
+	vst1.8		{d20-d21}, [r2, : 128]!
 	vmull.s32	q7, d18, d9
 	vmlal.s32	q7, d26, d3
 	vmlal.s32	q7, d19, d8
@@ -1340,15 +1307,13 @@
 	vmlal.s32	q7, d28, d1
 	vmlal.s32	q7, d23, d6
 	vmlal.s32	q7, d29, d0
-	add		r2, sp, #656
-	vst1.8		{d10-d11}, [r2, : 128]
+	vst1.8		{d10-d11}, [r2, : 128]!
 	vmull.s32	q5, d18, d3
 	vmlal.s32	q5, d19, d2
 	vmlal.s32	q5, d22, d1
 	vmlal.s32	q5, d23, d0
 	vmlal.s32	q5, d12, d8
-	add		r2, sp, #672
-	vst1.8		{d16-d17}, [r2, : 128]
+	vst1.8		{d16-d17}, [r2, : 128]!
 	vmull.s32	q4, d18, d8
 	vmlal.s32	q4, d26, d2
 	vmlal.s32	q4, d19, d7
@@ -1359,7 +1324,7 @@
 	vmlal.s32	q8, d26, d1
 	vmlal.s32	q8, d19, d6
 	vmlal.s32	q8, d27, d0
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q7, d24, d21
 	vmlal.s32	q7, d25, d20
@@ -1368,32 +1333,30 @@
 	vmlal.s32	q8, d22, d21
 	vmlal.s32	q8, d28, d20
 	vmlal.s32	q5, d24, d20
-	add		r2, sp, #576
 	vst1.8		{d14-d15}, [r2, : 128]
 	vmull.s32	q7, d18, d6
 	vmlal.s32	q7, d26, d0
-	add		r2, sp, #656
+	add		r2, sp, #624
 	vld1.8		{d30-d31}, [r2, : 128]
 	vmlal.s32	q2, d30, d21
 	vmlal.s32	q7, d19, d21
 	vmlal.s32	q7, d27, d20
-	add		r2, sp, #624
+	add		r2, sp, #592
 	vld1.8		{d26-d27}, [r2, : 128]
 	vmlal.s32	q4, d25, d27
 	vmlal.s32	q8, d29, d27
 	vmlal.s32	q8, d25, d26
 	vmlal.s32	q7, d28, d27
 	vmlal.s32	q7, d29, d26
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d28-d29}, [r2, : 128]
 	vmlal.s32	q4, d24, d29
 	vmlal.s32	q8, d23, d29
 	vmlal.s32	q8, d24, d28
 	vmlal.s32	q7, d22, d29
 	vmlal.s32	q7, d23, d28
-	add		r2, sp, #608
 	vst1.8		{d8-d9}, [r2, : 128]
-	add		r2, sp, #560
+	add		r2, sp, #528
 	vld1.8		{d8-d9}, [r2, : 128]
 	vmlal.s32	q7, d24, d9
 	vmlal.s32	q7, d25, d31
@@ -1414,36 +1377,36 @@
 	vmlal.s32	q0, d23, d26
 	vmlal.s32	q0, d24, d31
 	vmlal.s32	q0, d19, d20
-	add		r2, sp, #640
+	add		r2, sp, #608
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q2, d18, d7
-	vmlal.s32	q2, d19, d6
 	vmlal.s32	q5, d18, d6
-	vmlal.s32	q5, d19, d21
 	vmlal.s32	q1, d18, d21
-	vmlal.s32	q1, d19, d29
 	vmlal.s32	q0, d18, d28
-	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d18, d29
+	vmlal.s32	q2, d19, d6
+	vmlal.s32	q5, d19, d21
+	vmlal.s32	q1, d19, d29
+	vmlal.s32	q0, d19, d9
 	vmlal.s32	q6, d19, d28
-	add		r2, sp, #592
+	add		r2, sp, #560
 	vld1.8		{d18-d19}, [r2, : 128]
-	add		r2, sp, #512
+	add		r2, sp, #480
 	vld1.8		{d22-d23}, [r2, : 128]
 	vmlal.s32	q5, d19, d7
 	vmlal.s32	q0, d18, d21
 	vmlal.s32	q0, d19, d29
 	vmlal.s32	q6, d18, d6
-	add		r2, sp, #528
+	add		r2, sp, #496
 	vld1.8		{d6-d7}, [r2, : 128]
 	vmlal.s32	q6, d19, d21
-	add		r2, sp, #576
+	add		r2, sp, #544
 	vld1.8		{d18-d19}, [r2, : 128]
 	vmlal.s32	q0, d30, d8
-	add		r2, sp, #672
+	add		r2, sp, #640
 	vld1.8		{d20-d21}, [r2, : 128]
 	vmlal.s32	q5, d30, d29
-	add		r2, sp, #608
+	add		r2, sp, #576
 	vld1.8		{d24-d25}, [r2, : 128]
 	vmlal.s32	q1, d30, d28
 	vadd.i64	q13, q0, q11
@@ -1541,10 +1504,10 @@
 	sub		r4, r4, #24
 	vst1.8		d0, [r2, : 64]
 	vst1.8		d1, [r4, : 64]
-	ldr		r2, [sp, #488]
-	ldr		r4, [sp, #492]
+	ldr		r2, [sp, #456]
+	ldr		r4, [sp, #460]
 	subs		r5, r2, #1
-	bge		._mainloop
+	bge		.Lmainloop
 	add		r1, r3, #144
 	add		r2, r3, #336
 	vld1.8		{d0-d1}, [r1, : 128]!
@@ -1553,41 +1516,41 @@
 	vst1.8		{d0-d1}, [r2, : 128]!
 	vst1.8		{d2-d3}, [r2, : 128]!
 	vst1.8		d4, [r2, : 64]
-	ldr		r1, =0
-._invertloop:
+	movw		r1, #0
+.Linvertloop:
 	add		r2, r3, #144
-	ldr		r4, =0
-	ldr		r5, =2
+	movw		r4, #0
+	movw		r5, #2
 	cmp		r1, #1
-	ldreq		r5, =1
+	moveq		r5, #1
 	addeq		r2, r3, #336
 	addeq		r4, r3, #48
 	cmp		r1, #2
-	ldreq		r5, =1
+	moveq		r5, #1
 	addeq		r2, r3, #48
 	cmp		r1, #3
-	ldreq		r5, =5
+	moveq		r5, #5
 	addeq		r4, r3, #336
 	cmp		r1, #4
-	ldreq		r5, =10
+	moveq		r5, #10
 	cmp		r1, #5
-	ldreq		r5, =20
+	moveq		r5, #20
 	cmp		r1, #6
-	ldreq		r5, =10
+	moveq		r5, #10
 	addeq		r2, r3, #336
 	addeq		r4, r3, #336
 	cmp		r1, #7
-	ldreq		r5, =50
+	moveq		r5, #50
 	cmp		r1, #8
-	ldreq		r5, =100
+	moveq		r5, #100
 	cmp		r1, #9
-	ldreq		r5, =50
+	moveq		r5, #50
 	addeq		r2, r3, #336
 	cmp		r1, #10
-	ldreq		r5, =5
+	moveq		r5, #5
 	addeq		r2, r3, #48
 	cmp		r1, #11
-	ldreq		r5, =0
+	moveq		r5, #0
 	addeq		r2, r3, #96
 	add		r6, r3, #144
 	add		r7, r3, #288
@@ -1598,8 +1561,8 @@
 	vst1.8		{d2-d3}, [r7, : 128]!
 	vst1.8		d4, [r7, : 64]
 	cmp		r5, #0
-	beq		._skipsquaringloop
-._squaringloop:
+	beq		.Lskipsquaringloop
+.Lsquaringloop:
 	add		r6, r3, #288
 	add		r7, r3, #288
 	add		r8, r3, #288
@@ -1611,7 +1574,7 @@
 	vld1.8		{d6-d7}, [r7, : 128]!
 	vld1.8		{d9}, [r7, : 64]
 	vld1.8		{d10-d11}, [r6, : 128]!
-	add		r7, sp, #416
+	add		r7, sp, #384
 	vld1.8		{d12-d13}, [r6, : 128]!
 	vmul.i32	q7, q2, q0
 	vld1.8		{d8}, [r6, : 64]
@@ -1726,7 +1689,7 @@
 	vext.32		d10, d6, d6, #0
 	vmov.i32	q1, #0xffffffff
 	vshl.i64	q4, q1, #25
-	add		r7, sp, #512
+	add		r7, sp, #480
 	vld1.8		{d14-d15}, [r7, : 128]
 	vadd.i64	q9, q2, q7
 	vshl.i64	q1, q1, #26
@@ -1735,7 +1698,7 @@
 	vadd.i64	q5, q5, q10
 	vand		q9, q9, q1
 	vld1.8		{d16}, [r6, : 64]!
-	add		r6, sp, #528
+	add		r6, sp, #496
 	vld1.8		{d20-d21}, [r6, : 128]
 	vadd.i64	q11, q5, q10
 	vsub.i64	q2, q2, q9
@@ -1789,8 +1752,8 @@
 	sub		r6, r6, #32
 	vst1.8		d4, [r6, : 64]
 	subs		r5, r5, #1
-	bhi		._squaringloop
-._skipsquaringloop:
+	bhi		.Lsquaringloop
+.Lskipsquaringloop:
 	mov		r2, r2
 	add		r5, r3, #288
 	add		r6, r3, #144
@@ -1802,7 +1765,7 @@
 	vld1.8		{d6-d7}, [r5, : 128]!
 	vld1.8		{d9}, [r5, : 64]
 	vld1.8		{d10-d11}, [r2, : 128]!
-	add		r5, sp, #416
+	add		r5, sp, #384
 	vld1.8		{d12-d13}, [r2, : 128]!
 	vmul.i32	q7, q2, q0
 	vld1.8		{d8}, [r2, : 64]
@@ -1917,7 +1880,7 @@
 	vext.32		d10, d6, d6, #0
 	vmov.i32	q1, #0xffffffff
 	vshl.i64	q4, q1, #25
-	add		r5, sp, #512
+	add		r5, sp, #480
 	vld1.8		{d14-d15}, [r5, : 128]
 	vadd.i64	q9, q2, q7
 	vshl.i64	q1, q1, #26
@@ -1926,7 +1889,7 @@
 	vadd.i64	q5, q5, q10
 	vand		q9, q9, q1
 	vld1.8		{d16}, [r2, : 64]!
-	add		r2, sp, #528
+	add		r2, sp, #496
 	vld1.8		{d20-d21}, [r2, : 128]
 	vadd.i64	q11, q5, q10
 	vsub.i64	q2, q2, q9
@@ -1980,7 +1943,7 @@
 	sub		r2, r2, #32
 	vst1.8		d4, [r2, : 64]
 	cmp		r4, #0
-	beq		._skippostcopy
+	beq		.Lskippostcopy
 	add		r2, r3, #144
 	mov		r4, r4
 	vld1.8		{d0-d1}, [r2, : 128]!
@@ -1989,9 +1952,9 @@
 	vst1.8		{d0-d1}, [r4, : 128]!
 	vst1.8		{d2-d3}, [r4, : 128]!
 	vst1.8		d4, [r4, : 64]
-._skippostcopy:
+.Lskippostcopy:
 	cmp		r1, #1
-	bne		._skipfinalcopy
+	bne		.Lskipfinalcopy
 	add		r2, r3, #288
 	add		r4, r3, #144
 	vld1.8		{d0-d1}, [r2, : 128]!
@@ -2000,10 +1963,10 @@
 	vst1.8		{d0-d1}, [r4, : 128]!
 	vst1.8		{d2-d3}, [r4, : 128]!
 	vst1.8		d4, [r4, : 64]
-._skipfinalcopy:
+.Lskipfinalcopy:
 	add		r1, r1, #1
 	cmp		r1, #12
-	blo		._invertloop
+	blo		.Linvertloop
 	add		r1, r3, #144
 	ldr		r2, [r1], #4
 	ldr		r3, [r1], #4
@@ -2085,21 +2048,15 @@
 	add		r8, r8, r10, LSL #12
 	mov		r9, r10, LSR #20
 	add		r1, r9, r1, LSL #6
-	str		r2, [r0], #4
-	str		r3, [r0], #4
-	str		r4, [r0], #4
-	str		r5, [r0], #4
-	str		r6, [r0], #4
-	str		r7, [r0], #4
-	str		r8, [r0], #4
-	str		r1, [r0]
-	ldrd		r4, [sp, #0]
-	ldrd		r6, [sp, #8]
-	ldrd		r8, [sp, #16]
-	ldrd		r10, [sp, #24]
-	ldr		r12, [sp, #480]
-	ldr		r14, [sp, #484]
-	ldr		r0, =0
-	mov		sp, r12
-	vpop		{q4, q5, q6, q7}
-	bx		lr
+	str		r2, [r0]
+	str		r3, [r0, #4]
+	str		r4, [r0, #8]
+	str		r5, [r0, #12]
+	str		r6, [r0, #16]
+	str		r7, [r0, #20]
+	str		r8, [r0, #24]
+	str		r1, [r0, #28]
+	movw		r0, #0
+	mov		sp, ip
+	pop		{r4-r11, pc}
+ENDPROC(curve25519_neon)
diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
new file mode 100644
index 000000000000..18f337b1103e
--- /dev/null
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * Based on public domain code from Daniel J. Bernstein and Peter Schwabe. This
+ * began from SUPERCOP's curve25519/neon2/scalarmult.s, but has subsequently been
+ * manually reworked for use in kernel space.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <crypto/internal/simd.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/jump_label.h>
+#include <crypto/curve25519.h>
+
+asmlinkage void curve25519_neon(u8 mypublic[CURVE25519_KEY_SIZE],
+				const u8 secret[CURVE25519_KEY_SIZE],
+				const u8 basepoint[CURVE25519_KEY_SIZE]);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
+bool curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
+		     const u8 scalar[CURVE25519_KEY_SIZE],
+		     const u8 point[CURVE25519_KEY_SIZE])
+{
+	if (!static_branch_likely(&have_neon) || !crypto_simd_usable())
+		return false;
+	kernel_neon_begin();
+	curve25519_neon(out, scalar, point);
+	kernel_neon_end();
+	return true;
+}
+EXPORT_SYMBOL(curve25519_arch);
+
+static int __init mod_init(void)
+{
+	if (elf_hwcap & HWCAP_NEON)
+		static_branch_enable(&have_neon);
+	return 0;
+}
+
+static void __exit mod_exit(void)
+{
+}
+
+module_init(mod_init);
+module_exit(mod_exit);
+MODULE_LICENSE("GPL v2");
-- 
2.20.1


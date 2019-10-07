Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D396ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD43720659
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0EgI7Eh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfJGQq4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:56 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:51444 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfJGQq4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:56 -0400
Received: by mail-wm1-f54.google.com with SMTP id 7so228107wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CaKwWOuYLJmvAYKqMyo8Qj3k+P94cL9//xIzElK7pzM=;
        b=u0EgI7EhX8wg9zZdJ5VsbSf+3+e1eXgPZoEADb4pVvU3KGWznMf3XcJ5iOyJ3K6K0F
         EJLN2g0YPK60OHmUEZ6mzgH1F25DKPB5Yn5nW+uIlEmtG44B84mYdnJ30QLeqSEMWh14
         t+Gfm/9SlE5nMh/Mcz/8EI+H3U+a5aK84zRgMA85SKhGl7B+mvBArvYFbpd91n5U3/Ln
         2IQzC8QlJfkKV8wnuEngSczU24rXn2IEAozDuZe/HnmLAqk43mURO6SsR4H2UXO5mVCN
         WR0bsd/GJ4o0Hevrx7gYkgtw/YH0zVthpJ4I6R/72KBq3Ny3l0xDcw/qBI/nZsf/7+i6
         i6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CaKwWOuYLJmvAYKqMyo8Qj3k+P94cL9//xIzElK7pzM=;
        b=q4eUWhEnA/N7zNbk9/1jLt4rCq/32HpCOOemPogOqB1b7+HkHBap0v+zmgh5HXCI8C
         4yGTqJVXN1Prt8UlSMxJ5uy/rKHn2D0Plbk5guG4EVJ8RgsoNyqS0YUP5LFv2m1RRHAY
         xpdUi2xyYzREmWfYWlIHOCmU3Abp0l+JAyNVRbbYUcbQ1+ZHsQrXLSlVaOyaVgGTQ0G3
         3y39a0cStLYkG3kSiHFAUwkEbsK24qFUpEwbLlCbM9YVDZT5/0P4U2X6c/ES/IdK6CZf
         Y/2yQb/yOX/xsjN5mQZPz5lKORpTatIjofUYk4OzOLKmLp1+XCKJ0tMOxDyCqGp5IWaB
         RbYA==
X-Gm-Message-State: APjAAAU0nlnxeemJwHXeMAvePh9j9+nG2NJeMBSbnH6YsT+6UooOKfHN
        k+fYt0Y1ZF/rJUylft9i56PBaCZveCoXRA==
X-Google-Smtp-Source: APXvYqzyH/PAXS6Yn+N20K0rGMrI9MO3AEHH6Ddtme87GoD5l2IDcslgB+4nIwP1mXbEOWXijYLhfA==
X-Received: by 2002:a1c:4383:: with SMTP id q125mr169125wma.122.1570466809484;
        Mon, 07 Oct 2019 09:46:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:48 -0700 (PDT)
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
Subject: [PATCH v3 22/29] crypto: BLAKE2s - x86_64 library implementation
Date:   Mon,  7 Oct 2019 18:46:03 +0200
Message-Id: <20191007164610.6881-23-ard.biesheuvel@linaro.org>
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

These implementations from Samuel Neves support AVX and AVX-512VL.
Originally this used AVX-512F, but Skylake thermal throttling made
AVX-512VL more attractive and possible to do with negligable difference.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
[ardb: move to arch/x86/crypto, wire into lib/crypto framework]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/Makefile       |   2 +
 arch/x86/crypto/blake2s-core.S | 685 ++++++++++++++++++++
 arch/x86/crypto/blake2s-glue.c |  85 +++
 crypto/Kconfig                 |   6 +
 4 files changed, 778 insertions(+)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 759b1a927826..db87c182ce0f 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -48,6 +48,7 @@ ifeq ($(avx_supported),yes)
 	obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
 	obj-$(CONFIG_CRYPTO_TWOFISH_AVX_X86_64) += twofish-avx-x86_64.o
 	obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) += serpent-avx-x86_64.o
+	obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_X86) += blake2s-x86_64.o
 endif
 
 # These modules require assembler to support AVX2.
@@ -70,6 +71,7 @@ serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 nhpoly1305-sse2-y := nh-sse2-x86_64.o nhpoly1305-sse2-glue.o
+blake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 
 ifeq ($(avx_supported),yes)
 	camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o \
diff --git a/arch/x86/crypto/blake2s-core.S b/arch/x86/crypto/blake2s-core.S
new file mode 100644
index 000000000000..675288fa4cca
--- /dev/null
+++ b/arch/x86/crypto/blake2s-core.S
@@ -0,0 +1,685 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ * Copyright (C) 2017 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
+ */
+
+#include <linux/linkage.h>
+
+.section .rodata.cst32.BLAKE2S_IV, "aM", @progbits, 32
+.align 32
+IV:	.octa 0xA54FF53A3C6EF372BB67AE856A09E667
+	.octa 0x5BE0CD191F83D9AB9B05688C510E527F
+.section .rodata.cst16.ROT16, "aM", @progbits, 16
+.align 16
+ROT16:	.octa 0x0D0C0F0E09080B0A0504070601000302
+.section .rodata.cst16.ROR328, "aM", @progbits, 16
+.align 16
+ROR328:	.octa 0x0C0F0E0D080B0A090407060500030201
+#ifdef CONFIG_AS_AVX512
+.section .rodata.cst64.BLAKE2S_SIGMA, "aM", @progbits, 640
+.align 64
+SIGMA:
+.long 0, 2, 4, 6, 1, 3, 5, 7, 8, 10, 12, 14, 9, 11, 13, 15
+.long 11, 2, 12, 14, 9, 8, 15, 3, 4, 0, 13, 6, 10, 1, 7, 5
+.long 10, 12, 11, 6, 5, 9, 13, 3, 4, 15, 14, 2, 0, 7, 8, 1
+.long 10, 9, 7, 0, 11, 14, 1, 12, 6, 2, 15, 3, 13, 8, 5, 4
+.long 4, 9, 8, 13, 14, 0, 10, 11, 7, 3, 12, 1, 5, 6, 15, 2
+.long 2, 10, 4, 14, 13, 3, 9, 11, 6, 5, 7, 12, 15, 1, 8, 0
+.long 4, 11, 14, 8, 13, 10, 12, 5, 2, 1, 15, 3, 9, 7, 0, 6
+.long 6, 12, 0, 13, 15, 2, 1, 10, 4, 5, 11, 14, 8, 3, 9, 7
+.long 14, 5, 4, 12, 9, 7, 3, 10, 2, 0, 6, 15, 11, 1, 13, 8
+.long 11, 7, 13, 10, 12, 14, 0, 15, 4, 5, 6, 9, 2, 1, 8, 3
+#endif /* CONFIG_AS_AVX512 */
+
+.text
+#ifdef CONFIG_AS_AVX
+ENTRY(blake2s_compress_avx)
+	movl		%ecx, %ecx
+	testq		%rdx, %rdx
+	je		.Lendofloop
+	.align 32
+.Lbeginofloop:
+	addq		%rcx, 32(%rdi)
+	vmovdqu		IV+16(%rip), %xmm1
+	vmovdqu		(%rsi), %xmm4
+	vpxor		32(%rdi), %xmm1, %xmm1
+	vmovdqu		16(%rsi), %xmm3
+	vshufps		$136, %xmm3, %xmm4, %xmm6
+	vmovdqa		ROT16(%rip), %xmm7
+	vpaddd		(%rdi), %xmm6, %xmm6
+	vpaddd		16(%rdi), %xmm6, %xmm6
+	vpxor		%xmm6, %xmm1, %xmm1
+	vmovdqu		IV(%rip), %xmm8
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vmovdqu		48(%rsi), %xmm5
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		16(%rdi), %xmm8, %xmm9
+	vmovdqu		32(%rsi), %xmm2
+	vpblendw	$12, %xmm3, %xmm5, %xmm13
+	vshufps		$221, %xmm5, %xmm2, %xmm12
+	vpunpckhqdq	%xmm2, %xmm4, %xmm14
+	vpslld		$20, %xmm9, %xmm0
+	vpsrld		$12, %xmm9, %xmm9
+	vpxor		%xmm0, %xmm9, %xmm0
+	vshufps		$221, %xmm3, %xmm4, %xmm9
+	vpaddd		%xmm9, %xmm6, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vmovdqa		ROR328(%rip), %xmm6
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm0, %xmm0
+	vpshufd		$147, %xmm1, %xmm1
+	vpshufd		$78, %xmm8, %xmm8
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm10, %xmm0, %xmm0
+	vshufps		$136, %xmm5, %xmm2, %xmm10
+	vpshufd		$57, %xmm0, %xmm0
+	vpaddd		%xmm10, %xmm9, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpaddd		%xmm12, %xmm9, %xmm9
+	vpblendw	$12, %xmm2, %xmm3, %xmm12
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm0, %xmm10
+	vpslld		$20, %xmm10, %xmm0
+	vpsrld		$12, %xmm10, %xmm10
+	vpxor		%xmm0, %xmm10, %xmm0
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm0, %xmm0
+	vpshufd		$57, %xmm1, %xmm1
+	vpshufd		$78, %xmm8, %xmm8
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm10, %xmm0, %xmm0
+	vpslldq		$4, %xmm5, %xmm10
+	vpblendw	$240, %xmm10, %xmm12, %xmm12
+	vpshufd		$147, %xmm0, %xmm0
+	vpshufd		$147, %xmm12, %xmm12
+	vpaddd		%xmm9, %xmm12, %xmm12
+	vpaddd		%xmm0, %xmm12, %xmm12
+	vpxor		%xmm12, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm0, %xmm11
+	vpslld		$20, %xmm11, %xmm9
+	vpsrld		$12, %xmm11, %xmm11
+	vpxor		%xmm9, %xmm11, %xmm0
+	vpshufd		$8, %xmm2, %xmm9
+	vpblendw	$192, %xmm5, %xmm3, %xmm11
+	vpblendw	$240, %xmm11, %xmm9, %xmm9
+	vpshufd		$177, %xmm9, %xmm9
+	vpaddd		%xmm12, %xmm9, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm11
+	vpxor		%xmm11, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm0, %xmm9
+	vpshufd		$147, %xmm1, %xmm1
+	vpshufd		$78, %xmm8, %xmm8
+	vpslld		$25, %xmm9, %xmm0
+	vpsrld		$7, %xmm9, %xmm9
+	vpxor		%xmm0, %xmm9, %xmm0
+	vpslldq		$4, %xmm3, %xmm9
+	vpblendw	$48, %xmm9, %xmm2, %xmm9
+	vpblendw	$240, %xmm9, %xmm4, %xmm9
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$177, %xmm9, %xmm9
+	vpaddd		%xmm11, %xmm9, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm8, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpslld		$20, %xmm0, %xmm8
+	vpsrld		$12, %xmm0, %xmm0
+	vpxor		%xmm8, %xmm0, %xmm0
+	vpunpckhdq	%xmm3, %xmm4, %xmm8
+	vpblendw	$12, %xmm10, %xmm8, %xmm12
+	vpshufd		$177, %xmm12, %xmm12
+	vpaddd		%xmm9, %xmm12, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpshufd		$57, %xmm1, %xmm1
+	vpshufd		$78, %xmm11, %xmm11
+	vpslld		$25, %xmm0, %xmm12
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm12, %xmm0, %xmm0
+	vpunpckhdq	%xmm5, %xmm2, %xmm12
+	vpshufd		$147, %xmm0, %xmm0
+	vpblendw	$15, %xmm13, %xmm12, %xmm12
+	vpslldq		$8, %xmm5, %xmm13
+	vpshufd		$210, %xmm12, %xmm12
+	vpaddd		%xmm9, %xmm12, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpslld		$20, %xmm0, %xmm12
+	vpsrld		$12, %xmm0, %xmm0
+	vpxor		%xmm12, %xmm0, %xmm0
+	vpunpckldq	%xmm4, %xmm2, %xmm12
+	vpblendw	$240, %xmm4, %xmm12, %xmm12
+	vpblendw	$192, %xmm13, %xmm12, %xmm12
+	vpsrldq		$12, %xmm3, %xmm13
+	vpaddd		%xmm12, %xmm9, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpshufd		$147, %xmm1, %xmm1
+	vpshufd		$78, %xmm11, %xmm11
+	vpslld		$25, %xmm0, %xmm12
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm12, %xmm0, %xmm0
+	vpblendw	$60, %xmm2, %xmm4, %xmm12
+	vpblendw	$3, %xmm13, %xmm12, %xmm12
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$78, %xmm12, %xmm12
+	vpaddd		%xmm9, %xmm12, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm12
+	vpslld		$20, %xmm12, %xmm13
+	vpsrld		$12, %xmm12, %xmm0
+	vpblendw	$51, %xmm3, %xmm4, %xmm12
+	vpxor		%xmm13, %xmm0, %xmm0
+	vpblendw	$192, %xmm10, %xmm12, %xmm10
+	vpslldq		$8, %xmm2, %xmm12
+	vpshufd		$27, %xmm10, %xmm10
+	vpaddd		%xmm9, %xmm10, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpshufd		$57, %xmm1, %xmm1
+	vpshufd		$78, %xmm11, %xmm11
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm10, %xmm0, %xmm0
+	vpunpckhdq	%xmm2, %xmm8, %xmm10
+	vpshufd		$147, %xmm0, %xmm0
+	vpblendw	$12, %xmm5, %xmm10, %xmm10
+	vpshufd		$210, %xmm10, %xmm10
+	vpaddd		%xmm9, %xmm10, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm0, %xmm10
+	vpslld		$20, %xmm10, %xmm0
+	vpsrld		$12, %xmm10, %xmm10
+	vpxor		%xmm0, %xmm10, %xmm0
+	vpblendw	$12, %xmm4, %xmm5, %xmm10
+	vpblendw	$192, %xmm12, %xmm10, %xmm10
+	vpunpckldq	%xmm2, %xmm4, %xmm12
+	vpshufd		$135, %xmm10, %xmm10
+	vpaddd		%xmm9, %xmm10, %xmm9
+	vpaddd		%xmm0, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm11, %xmm13
+	vpxor		%xmm13, %xmm0, %xmm0
+	vpshufd		$147, %xmm1, %xmm1
+	vpshufd		$78, %xmm13, %xmm13
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm10, %xmm0, %xmm0
+	vpblendw	$15, %xmm3, %xmm4, %xmm10
+	vpblendw	$192, %xmm5, %xmm10, %xmm10
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$198, %xmm10, %xmm10
+	vpaddd		%xmm9, %xmm10, %xmm10
+	vpaddd		%xmm0, %xmm10, %xmm10
+	vpxor		%xmm10, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm0, %xmm9
+	vpslld		$20, %xmm9, %xmm0
+	vpsrld		$12, %xmm9, %xmm9
+	vpxor		%xmm0, %xmm9, %xmm0
+	vpunpckhdq	%xmm2, %xmm3, %xmm9
+	vpunpcklqdq	%xmm12, %xmm9, %xmm15
+	vpunpcklqdq	%xmm12, %xmm8, %xmm12
+	vpblendw	$15, %xmm5, %xmm8, %xmm8
+	vpaddd		%xmm15, %xmm10, %xmm15
+	vpaddd		%xmm0, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm1, %xmm1
+	vpshufd		$141, %xmm8, %xmm8
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm0, %xmm0
+	vpshufd		$57, %xmm1, %xmm1
+	vpshufd		$78, %xmm13, %xmm13
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm10, %xmm0, %xmm0
+	vpunpcklqdq	%xmm2, %xmm3, %xmm10
+	vpshufd		$147, %xmm0, %xmm0
+	vpblendw	$51, %xmm14, %xmm10, %xmm14
+	vpshufd		$135, %xmm14, %xmm14
+	vpaddd		%xmm15, %xmm14, %xmm14
+	vpaddd		%xmm0, %xmm14, %xmm14
+	vpxor		%xmm14, %xmm1, %xmm1
+	vpunpcklqdq	%xmm3, %xmm4, %xmm15
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm0, %xmm0
+	vpslld		$20, %xmm0, %xmm11
+	vpsrld		$12, %xmm0, %xmm0
+	vpxor		%xmm11, %xmm0, %xmm0
+	vpunpckhqdq	%xmm5, %xmm3, %xmm11
+	vpblendw	$51, %xmm15, %xmm11, %xmm11
+	vpunpckhqdq	%xmm3, %xmm5, %xmm15
+	vpaddd		%xmm11, %xmm14, %xmm11
+	vpaddd		%xmm0, %xmm11, %xmm11
+	vpxor		%xmm11, %xmm1, %xmm1
+	vpshufb		%xmm6, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm0, %xmm0
+	vpshufd		$147, %xmm1, %xmm1
+	vpshufd		$78, %xmm13, %xmm13
+	vpslld		$25, %xmm0, %xmm14
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm14, %xmm0, %xmm14
+	vpunpckhqdq	%xmm4, %xmm2, %xmm0
+	vpshufd		$57, %xmm14, %xmm14
+	vpblendw	$51, %xmm15, %xmm0, %xmm15
+	vpaddd		%xmm15, %xmm11, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm1, %xmm1
+	vpshufb		%xmm7, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm11
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm11, %xmm14, %xmm14
+	vpblendw	$3, %xmm2, %xmm4, %xmm11
+	vpslldq		$8, %xmm11, %xmm0
+	vpblendw	$15, %xmm5, %xmm0, %xmm0
+	vpshufd		$99, %xmm0, %xmm0
+	vpaddd		%xmm15, %xmm0, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm1, %xmm0
+	vpaddd		%xmm12, %xmm15, %xmm15
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$78, %xmm13, %xmm13
+	vpslld		$25, %xmm14, %xmm1
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpblendw	$3, %xmm5, %xmm4, %xmm1
+	vpshufd		$147, %xmm14, %xmm14
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm12
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm12, %xmm14, %xmm14
+	vpsrldq		$4, %xmm2, %xmm12
+	vpblendw	$60, %xmm12, %xmm1, %xmm1
+	vpaddd		%xmm1, %xmm15, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpblendw	$12, %xmm4, %xmm3, %xmm1
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm13, %xmm13
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpshufd		$147, %xmm0, %xmm0
+	vpshufd		$78, %xmm13, %xmm13
+	vpslld		$25, %xmm14, %xmm12
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm12, %xmm14, %xmm14
+	vpsrldq		$4, %xmm5, %xmm12
+	vpblendw	$48, %xmm12, %xmm1, %xmm1
+	vpshufd		$33, %xmm5, %xmm12
+	vpshufd		$57, %xmm14, %xmm14
+	vpshufd		$108, %xmm1, %xmm1
+	vpblendw	$51, %xmm12, %xmm10, %xmm12
+	vpaddd		%xmm15, %xmm1, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpaddd		%xmm12, %xmm15, %xmm15
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm13, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm13
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpslldq		$12, %xmm3, %xmm13
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm14, %xmm12
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm12, %xmm14, %xmm14
+	vpblendw	$51, %xmm5, %xmm4, %xmm12
+	vpshufd		$147, %xmm14, %xmm14
+	vpblendw	$192, %xmm13, %xmm12, %xmm12
+	vpaddd		%xmm12, %xmm15, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpsrldq		$4, %xmm3, %xmm12
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm13
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpblendw	$48, %xmm2, %xmm5, %xmm13
+	vpblendw	$3, %xmm12, %xmm13, %xmm13
+	vpshufd		$156, %xmm13, %xmm13
+	vpaddd		%xmm15, %xmm13, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpshufd		$147, %xmm0, %xmm0
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm14, %xmm13
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm13, %xmm14, %xmm14
+	vpunpcklqdq	%xmm2, %xmm4, %xmm13
+	vpshufd		$57, %xmm14, %xmm14
+	vpblendw	$12, %xmm12, %xmm13, %xmm12
+	vpshufd		$180, %xmm12, %xmm12
+	vpaddd		%xmm15, %xmm12, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm12
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm12, %xmm14, %xmm14
+	vpunpckhqdq	%xmm9, %xmm4, %xmm12
+	vpshufd		$198, %xmm12, %xmm12
+	vpaddd		%xmm15, %xmm12, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpaddd		%xmm15, %xmm8, %xmm15
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpshufd		$57, %xmm0, %xmm0
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm14, %xmm12
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm12, %xmm14, %xmm14
+	vpsrldq		$4, %xmm4, %xmm12
+	vpshufd		$147, %xmm14, %xmm14
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm15, %xmm0, %xmm0
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpslld		$20, %xmm14, %xmm8
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm14, %xmm8, %xmm14
+	vpblendw	$48, %xmm5, %xmm2, %xmm8
+	vpblendw	$3, %xmm12, %xmm8, %xmm8
+	vpunpckhqdq	%xmm5, %xmm4, %xmm12
+	vpshufd		$75, %xmm8, %xmm8
+	vpblendw	$60, %xmm10, %xmm12, %xmm10
+	vpaddd		%xmm15, %xmm8, %xmm15
+	vpaddd		%xmm14, %xmm15, %xmm15
+	vpxor		%xmm0, %xmm15, %xmm0
+	vpshufd		$45, %xmm10, %xmm10
+	vpshufb		%xmm6, %xmm0, %xmm0
+	vpaddd		%xmm15, %xmm10, %xmm15
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm14, %xmm14
+	vpshufd		$147, %xmm0, %xmm0
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm14, %xmm8
+	vpsrld		$7, %xmm14, %xmm14
+	vpxor		%xmm14, %xmm8, %xmm8
+	vpshufd		$57, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm15, %xmm15
+	vpxor		%xmm0, %xmm15, %xmm0
+	vpshufb		%xmm7, %xmm0, %xmm0
+	vpaddd		%xmm0, %xmm1, %xmm1
+	vpxor		%xmm8, %xmm1, %xmm8
+	vpslld		$20, %xmm8, %xmm10
+	vpsrld		$12, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm10, %xmm10
+	vpunpckldq	%xmm3, %xmm4, %xmm8
+	vpunpcklqdq	%xmm9, %xmm8, %xmm9
+	vpaddd		%xmm9, %xmm15, %xmm9
+	vpaddd		%xmm10, %xmm9, %xmm9
+	vpxor		%xmm0, %xmm9, %xmm8
+	vpshufb		%xmm6, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm10, %xmm10
+	vpshufd		$57, %xmm8, %xmm8
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm10, %xmm12
+	vpsrld		$7, %xmm10, %xmm10
+	vpxor		%xmm10, %xmm12, %xmm10
+	vpblendw	$48, %xmm4, %xmm3, %xmm12
+	vpshufd		$147, %xmm10, %xmm0
+	vpunpckhdq	%xmm5, %xmm3, %xmm10
+	vpshufd		$78, %xmm12, %xmm12
+	vpunpcklqdq	%xmm4, %xmm10, %xmm10
+	vpblendw	$192, %xmm2, %xmm10, %xmm10
+	vpshufhw	$78, %xmm10, %xmm10
+	vpaddd		%xmm10, %xmm9, %xmm10
+	vpaddd		%xmm0, %xmm10, %xmm10
+	vpxor		%xmm8, %xmm10, %xmm8
+	vpshufb		%xmm7, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm0, %xmm1, %xmm9
+	vpslld		$20, %xmm9, %xmm0
+	vpsrld		$12, %xmm9, %xmm9
+	vpxor		%xmm9, %xmm0, %xmm0
+	vpunpckhdq	%xmm5, %xmm4, %xmm9
+	vpblendw	$240, %xmm9, %xmm2, %xmm13
+	vpshufd		$39, %xmm13, %xmm13
+	vpaddd		%xmm10, %xmm13, %xmm10
+	vpaddd		%xmm0, %xmm10, %xmm10
+	vpxor		%xmm8, %xmm10, %xmm8
+	vpblendw	$12, %xmm4, %xmm2, %xmm13
+	vpshufb		%xmm6, %xmm8, %xmm8
+	vpslldq		$4, %xmm13, %xmm13
+	vpblendw	$15, %xmm5, %xmm13, %xmm13
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm0, %xmm0
+	vpaddd		%xmm13, %xmm10, %xmm13
+	vpshufd		$147, %xmm8, %xmm8
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm0, %xmm14
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm0, %xmm14, %xmm14
+	vpshufd		$57, %xmm14, %xmm14
+	vpaddd		%xmm14, %xmm13, %xmm13
+	vpxor		%xmm8, %xmm13, %xmm8
+	vpaddd		%xmm13, %xmm12, %xmm12
+	vpshufb		%xmm7, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm14, %xmm1, %xmm14
+	vpslld		$20, %xmm14, %xmm10
+	vpsrld		$12, %xmm14, %xmm14
+	vpxor		%xmm14, %xmm10, %xmm10
+	vpaddd		%xmm10, %xmm12, %xmm12
+	vpxor		%xmm8, %xmm12, %xmm8
+	vpshufb		%xmm6, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm10, %xmm0
+	vpshufd		$57, %xmm8, %xmm8
+	vpshufd		$78, %xmm1, %xmm1
+	vpslld		$25, %xmm0, %xmm10
+	vpsrld		$7, %xmm0, %xmm0
+	vpxor		%xmm0, %xmm10, %xmm10
+	vpblendw	$48, %xmm2, %xmm3, %xmm0
+	vpblendw	$15, %xmm11, %xmm0, %xmm0
+	vpshufd		$147, %xmm10, %xmm10
+	vpshufd		$114, %xmm0, %xmm0
+	vpaddd		%xmm12, %xmm0, %xmm0
+	vpaddd		%xmm10, %xmm0, %xmm0
+	vpxor		%xmm8, %xmm0, %xmm8
+	vpshufb		%xmm7, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm1, %xmm1
+	vpxor		%xmm10, %xmm1, %xmm10
+	vpslld		$20, %xmm10, %xmm11
+	vpsrld		$12, %xmm10, %xmm10
+	vpxor		%xmm10, %xmm11, %xmm10
+	vpslldq		$4, %xmm4, %xmm11
+	vpblendw	$192, %xmm11, %xmm3, %xmm3
+	vpunpckldq	%xmm5, %xmm4, %xmm4
+	vpshufd		$99, %xmm3, %xmm3
+	vpaddd		%xmm0, %xmm3, %xmm3
+	vpaddd		%xmm10, %xmm3, %xmm3
+	vpxor		%xmm8, %xmm3, %xmm11
+	vpunpckldq	%xmm5, %xmm2, %xmm0
+	vpblendw	$192, %xmm2, %xmm5, %xmm2
+	vpshufb		%xmm6, %xmm11, %xmm11
+	vpunpckhqdq	%xmm0, %xmm9, %xmm0
+	vpblendw	$15, %xmm4, %xmm2, %xmm4
+	vpaddd		%xmm11, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm10, %xmm10
+	vpshufd		$147, %xmm11, %xmm11
+	vpshufd		$201, %xmm0, %xmm0
+	vpslld		$25, %xmm10, %xmm8
+	vpsrld		$7, %xmm10, %xmm10
+	vpxor		%xmm10, %xmm8, %xmm10
+	vpshufd		$78, %xmm1, %xmm1
+	vpaddd		%xmm3, %xmm0, %xmm0
+	vpshufd		$27, %xmm4, %xmm4
+	vpshufd		$57, %xmm10, %xmm10
+	vpaddd		%xmm10, %xmm0, %xmm0
+	vpxor		%xmm11, %xmm0, %xmm11
+	vpaddd		%xmm0, %xmm4, %xmm0
+	vpshufb		%xmm7, %xmm11, %xmm7
+	vpaddd		%xmm7, %xmm1, %xmm1
+	vpxor		%xmm10, %xmm1, %xmm10
+	vpslld		$20, %xmm10, %xmm8
+	vpsrld		$12, %xmm10, %xmm10
+	vpxor		%xmm10, %xmm8, %xmm8
+	vpaddd		%xmm8, %xmm0, %xmm0
+	vpxor		%xmm7, %xmm0, %xmm7
+	vpshufb		%xmm6, %xmm7, %xmm6
+	vpaddd		%xmm6, %xmm1, %xmm1
+	vpxor		%xmm1, %xmm8, %xmm8
+	vpshufd		$78, %xmm1, %xmm1
+	vpshufd		$57, %xmm6, %xmm6
+	vpslld		$25, %xmm8, %xmm2
+	vpsrld		$7, %xmm8, %xmm8
+	vpxor		%xmm8, %xmm2, %xmm8
+	vpxor		(%rdi), %xmm1, %xmm1
+	vpshufd		$147, %xmm8, %xmm8
+	vpxor		%xmm0, %xmm1, %xmm0
+	vmovups		%xmm0, (%rdi)
+	vpxor		16(%rdi), %xmm8, %xmm0
+	vpxor		%xmm6, %xmm0, %xmm6
+	vmovups		%xmm6, 16(%rdi)
+	addq		$64, %rsi
+	decq		%rdx
+	jnz .Lbeginofloop
+.Lendofloop:
+	ret
+ENDPROC(blake2s_compress_avx)
+#endif /* CONFIG_AS_AVX */
+
+#ifdef CONFIG_AS_AVX512
+ENTRY(blake2s_compress_avx512)
+	vmovdqu		(%rdi),%xmm0
+	vmovdqu		0x10(%rdi),%xmm1
+	vmovdqu		0x20(%rdi),%xmm4
+	vmovq		%rcx,%xmm5
+	vmovdqa		IV(%rip),%xmm14
+	vmovdqa		IV+16(%rip),%xmm15
+	jmp		.Lblake2s_compress_avx512_mainloop
+.align 32
+.Lblake2s_compress_avx512_mainloop:
+	vmovdqa		%xmm0,%xmm10
+	vmovdqa		%xmm1,%xmm11
+	vpaddq		%xmm5,%xmm4,%xmm4
+	vmovdqa		%xmm14,%xmm2
+	vpxor		%xmm15,%xmm4,%xmm3
+	vmovdqu		(%rsi),%ymm6
+	vmovdqu		0x20(%rsi),%ymm7
+	addq		$0x40,%rsi
+	leaq		SIGMA(%rip),%rax
+	movb		$0xa,%cl
+.Lblake2s_compress_avx512_roundloop:
+	addq		$0x40,%rax
+	vmovdqa		-0x40(%rax),%ymm8
+	vmovdqa		-0x20(%rax),%ymm9
+	vpermi2d	%ymm7,%ymm6,%ymm8
+	vpermi2d	%ymm7,%ymm6,%ymm9
+	vmovdqa		%ymm8,%ymm6
+	vmovdqa		%ymm9,%ymm7
+	vpaddd		%xmm8,%xmm0,%xmm0
+	vpaddd		%xmm1,%xmm0,%xmm0
+	vpxor		%xmm0,%xmm3,%xmm3
+	vprord		$0x10,%xmm3,%xmm3
+	vpaddd		%xmm3,%xmm2,%xmm2
+	vpxor		%xmm2,%xmm1,%xmm1
+	vprord		$0xc,%xmm1,%xmm1
+	vextracti128	$0x1,%ymm8,%xmm8
+	vpaddd		%xmm8,%xmm0,%xmm0
+	vpaddd		%xmm1,%xmm0,%xmm0
+	vpxor		%xmm0,%xmm3,%xmm3
+	vprord		$0x8,%xmm3,%xmm3
+	vpaddd		%xmm3,%xmm2,%xmm2
+	vpxor		%xmm2,%xmm1,%xmm1
+	vprord		$0x7,%xmm1,%xmm1
+	vpshufd		$0x39,%xmm1,%xmm1
+	vpshufd		$0x4e,%xmm2,%xmm2
+	vpshufd		$0x93,%xmm3,%xmm3
+	vpaddd		%xmm9,%xmm0,%xmm0
+	vpaddd		%xmm1,%xmm0,%xmm0
+	vpxor		%xmm0,%xmm3,%xmm3
+	vprord		$0x10,%xmm3,%xmm3
+	vpaddd		%xmm3,%xmm2,%xmm2
+	vpxor		%xmm2,%xmm1,%xmm1
+	vprord		$0xc,%xmm1,%xmm1
+	vextracti128	$0x1,%ymm9,%xmm9
+	vpaddd		%xmm9,%xmm0,%xmm0
+	vpaddd		%xmm1,%xmm0,%xmm0
+	vpxor		%xmm0,%xmm3,%xmm3
+	vprord		$0x8,%xmm3,%xmm3
+	vpaddd		%xmm3,%xmm2,%xmm2
+	vpxor		%xmm2,%xmm1,%xmm1
+	vprord		$0x7,%xmm1,%xmm1
+	vpshufd		$0x93,%xmm1,%xmm1
+	vpshufd		$0x4e,%xmm2,%xmm2
+	vpshufd		$0x39,%xmm3,%xmm3
+	decb		%cl
+	jne		.Lblake2s_compress_avx512_roundloop
+	vpxor		%xmm10,%xmm0,%xmm0
+	vpxor		%xmm11,%xmm1,%xmm1
+	vpxor		%xmm2,%xmm0,%xmm0
+	vpxor		%xmm3,%xmm1,%xmm1
+	decq		%rdx
+	jne		.Lblake2s_compress_avx512_mainloop
+	vmovdqu		%xmm0,(%rdi)
+	vmovdqu		%xmm1,0x10(%rdi)
+	vmovdqu		%xmm4,0x20(%rdi)
+	vzeroupper
+	retq
+ENDPROC(blake2s_compress_avx512)
+#endif /* CONFIG_AS_AVX512 */
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
new file mode 100644
index 000000000000..c71a8e62666d
--- /dev/null
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <crypto/blake2s.h>
+#include <crypto/internal/simd.h>
+
+#include <linux/types.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <asm/cpufeature.h>
+#include <asm/fpu/api.h>
+#include <asm/processor.h>
+#include <asm/simd.h>
+
+asmlinkage void blake2s_compress_avx(struct blake2s_state *state,
+				     const u8 *block, const size_t nblocks,
+				     const u32 inc);
+asmlinkage void blake2s_compress_avx512(struct blake2s_state *state,
+					const u8 *block, const size_t nblocks,
+					const u32 inc);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_avx);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_avx512);
+
+bool blake2s_compress_arch(struct blake2s_state *state,
+			   const u8 *block, size_t nblocks,
+			   const u32 inc)
+{
+	/* SIMD disables preemption, so relax after processing each page. */
+	BUILD_BUG_ON(PAGE_SIZE / BLAKE2S_BLOCK_SIZE < 8);
+
+	if (!static_branch_likely(&blake2s_use_avx) || !crypto_simd_usable())
+		return false;
+
+	for (;;) {
+		const size_t blocks = min_t(size_t, nblocks,
+					    PAGE_SIZE / BLAKE2S_BLOCK_SIZE);
+
+		kernel_fpu_begin();
+		if (IS_ENABLED(CONFIG_AS_AVX512) &&
+		    static_branch_likely(&blake2s_use_avx512))
+			blake2s_compress_avx512(state, block, blocks, inc);
+		else
+			blake2s_compress_avx(state, block, blocks, inc);
+		kernel_fpu_end();
+
+		nblocks -= blocks;
+		if (!nblocks)
+			break;
+		block += blocks * BLAKE2S_BLOCK_SIZE;
+	}
+	return true;
+}
+EXPORT_SYMBOL(blake2s_compress_arch);
+
+static int __init blake2s_mod_init(void)
+{
+	if (boot_cpu_has(X86_FEATURE_AVX) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		static_branch_enable(&blake2s_use_avx);
+
+	if (IS_ENABLED(CONFIG_AS_AVX512) &&
+	    boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX512F) &&
+	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
+			      XFEATURE_MASK_AVX512, NULL))
+		static_branch_enable(&blake2s_use_avx512);
+
+	return 0;
+}
+
+static void __exit blake2s_mod_exit(void)
+{
+}
+
+module_init(blake2s_mod_init);
+module_exit(blake2s_mod_exit);
+
+MODULE_LICENSE("GPL v2");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1b6e3d7719d8..08d7e085a417 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1047,6 +1047,12 @@ config CRYPTO_LIB_BLAKE2S
 	tristate "BLAKE2s hash function library"
 	depends on CRYPTO_ARCH_HAVE_LIB_BLAKE2S || !CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 
+config CRYPTO_LIB_BLAKE2S_X86
+	tristate "BLAKE2s hash function library (x86 accelerated version)"
+	depends on X86 && 64BIT
+	select CRYPTO_LIB_BLAKE2S
+	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
+
 comment "Ciphers"
 
 config CRYPTO_LIB_AES
-- 
2.20.1


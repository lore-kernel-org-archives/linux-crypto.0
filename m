Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98AEC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 09:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C59422B48
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 09:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="X9axgz1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfLLJaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:30:39 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:41827 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfLLJai (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 04:30:38 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bc3827c3;
        Thu, 12 Dec 2019 08:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=yDxp6wdx7QbuDqbY7Tq7B3r+L
        0g=; b=X9axgz1vbCoiHzBoHZfgcSnUD400aNTuKnt0BMls9TC290fTtjGv0oNN0
        9CBtt5eKv2XWmqWO5ODZmOmI3aUodhJ71ZDqBp+7I9uJ3cuRLxxZuF0nJsNXr2vz
        5dBCrEcTQAyYoC+tXg6LdZIpSz9g01PH0Ja7eO2H5KX4ZtkEKGz9MkYP2cz1qXao
        b3H/Bei+Fr0/ObTGhTQj7/eKEozPpJrlTxIfO4FYlisq+0M+CH4+qmbeNvBAiT8s
        vokBSATngo4IJU+zDWauc5Z0S3e3rXLhrizEu8kABAs1C/sidXqTFxq40FzqZJtI
        LwR2kcqoX7M8a/XSTNsLvvt7wq+yw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8859bc48 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 12 Dec 2019 08:34:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Polyakov <appro@openssl.org>
Subject: [PATCH crypto-next v2 2/3] crypto: x86_64/poly1305 - add faster implementations
Date:   Thu, 12 Dec 2019 10:30:07 +0100
Message-Id: <20191212093008.217086-2-Jason@zx2c4.com>
In-Reply-To: <20191212093008.217086-1-Jason@zx2c4.com>
References: <20191211170936.385572-1-Jason@zx2c4.com>
 <20191212093008.217086-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These x86_64 vectorized implementations are based on Andy Polyakov's
implementation, and support AVX, AVX-2, and AVX512F. The AVX-512F
implementation is disabled on Skylake, due to throttling, but it is
quite fast on >= Cannonlake.

On the left is cycle counts on a Core i7 6700HQ using the AVX-2
codepath, comparing this implementation ("new") to the implementation in
the current crypto api ("old"). On the right are benchmarks on a Xeon
Gold 5120 using the AVX-512 codepath. The new implementation is faster
on all benchmarks.

    AVX-2                  AVX-512
  ---------              -----------

size    old     new      size   old     new
----    ----    ----     ----   ----    ----
0       70      68       0      74      70
16      92      90       16     96      92
32      134     104      32     136     106
48      172     120      48     184     124
64      218     136      64     218     138
80      254     158      80     260     160
96      298     174      96     300     176
112     342     192      112    342     194
128     388     212      128    384     212
144     428     228      144    420     226
160     466     246      160    464     248
176     510     264      176    504     264
192     550     282      192    544     282
208     594     302      208    582     300
224     628     316      224    624     318
240     676     334      240    662     338
256     716     354      256    708     358
272     764     374      272    748     372
288     802     352      288    788     358
304     420     366      304    422     370
320     428     360      320    432     364
336     484     378      336    486     380
352     426     384      352    434     390
368     478     400      368    480     408
384     488     394      384    490     398
400     542     408      400    542     412
416     486     416      416    492     426
432     534     430      432    538     436
448     544     422      448    546     432
464     600     438      464    600     448
480     540     448      480    548     456
496     594     464      496    594     476
512     602     456      512    606     470
528     656     476      528    656     480
544     600     480      544    606     498
560     650     494      560    652     512
576     664     490      576    662     508
592     714     508      592    716     522
608     656     514      608    664     538
624     708     532      624    710     552
640     716     524      640    720     516
656     770     536      656    772     526
672     716     548      672    722     544
688     770     562      688    768     556
704     774     552      704    778     556
720     826     568      720    832     568
736     768     574      736    780     584
752     822     592      752    826     600
768     830     584      768    836     560
784     884     602      784    888     572
800     828     610      800    838     588
816     884     628      816    884     604
832     888     618      832    894     598
848     942     632      848    946     612
864     884     644      864    896     628
880     936     660      880    942     644
896     948     652      896    952     608
912     1000    664      912    1004    616
928     942     676      928    954     634
944     994     690      944    1000    646
960     1002    680      960    1008    646
976     1054    694      976    1062    658
992     1002    706      992    1012    674
1008    1052    720      1008   1058    690

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
Co-developed-by: Andy Polyakov <appro@openssl.org>
---
 arch/x86/crypto/Makefile               |   12 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S |  390 ---
 arch/x86/crypto/poly1305-sse2-x86_64.S |  590 ----
 arch/x86/crypto/poly1305-x86_64.pl     | 4266 ++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  473 +--
 lib/crypto/Kconfig                     |    2 +-
 6 files changed, 4441 insertions(+), 1292 deletions(-)
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64.pl

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 958440eae27e..1cfd6f0ea679 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -101,11 +101,8 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
-poly1305-x86_64-y := poly1305-sse2-x86_64.o poly1305_glue.o
-ifeq ($(avx2_supported),yes)
-sha1-ssse3-y += sha1_avx2_x86_64_asm.o
-poly1305-x86_64-y += poly1305-avx2-x86_64.o
-endif
+poly1305-x86_64-y := poly1305-x86_64.o poly1305_glue.o
+targets += poly1305-x86_64.S
 ifeq ($(sha1_ni_supported),yes)
 sha1-ssse3-y += sha1_ni_asm.o
 endif
@@ -118,3 +115,8 @@ sha256-ssse3-y += sha256_ni_asm.o
 endif
 sha512-ssse3-y := sha512-ssse3-asm.o sha512-avx-asm.o sha512-avx2-asm.o sha512_ssse3_glue.o
 crct10dif-pclmul-y := crct10dif-pcl-asm_64.o crct10dif-pclmul_glue.o
+
+quiet_cmd_perlasm = PERLASM $@
+      cmd_perlasm = $(PERL) $< > $@
+$(obj)/%.S: $(src)/%.pl FORCE
+	$(call if_changed,perlasm)
diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
deleted file mode 100644
index 8f56989ea599..000000000000
--- a/arch/x86/crypto/poly1305-avx2-x86_64.S
+++ /dev/null
@@ -1,390 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Poly1305 authenticator algorithm, RFC7539, x64 AVX2 functions
- *
- * Copyright (C) 2015 Martin Willi
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst32.ANMASK, "aM", @progbits, 32
-.align 32
-ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
-	.octa 0x0000000003ffffff0000000003ffffff
-
-.section	.rodata.cst32.ORMASK, "aM", @progbits, 32
-.align 32
-ORMASK:	.octa 0x00000000010000000000000001000000
-	.octa 0x00000000010000000000000001000000
-
-.text
-
-#define h0 0x00(%rdi)
-#define h1 0x04(%rdi)
-#define h2 0x08(%rdi)
-#define h3 0x0c(%rdi)
-#define h4 0x10(%rdi)
-#define r0 0x00(%rdx)
-#define r1 0x04(%rdx)
-#define r2 0x08(%rdx)
-#define r3 0x0c(%rdx)
-#define r4 0x10(%rdx)
-#define u0 0x00(%r8)
-#define u1 0x04(%r8)
-#define u2 0x08(%r8)
-#define u3 0x0c(%r8)
-#define u4 0x10(%r8)
-#define w0 0x18(%r8)
-#define w1 0x1c(%r8)
-#define w2 0x20(%r8)
-#define w3 0x24(%r8)
-#define w4 0x28(%r8)
-#define y0 0x30(%r8)
-#define y1 0x34(%r8)
-#define y2 0x38(%r8)
-#define y3 0x3c(%r8)
-#define y4 0x40(%r8)
-#define m %rsi
-#define hc0 %ymm0
-#define hc1 %ymm1
-#define hc2 %ymm2
-#define hc3 %ymm3
-#define hc4 %ymm4
-#define hc0x %xmm0
-#define hc1x %xmm1
-#define hc2x %xmm2
-#define hc3x %xmm3
-#define hc4x %xmm4
-#define t1 %ymm5
-#define t2 %ymm6
-#define t1x %xmm5
-#define t2x %xmm6
-#define ruwy0 %ymm7
-#define ruwy1 %ymm8
-#define ruwy2 %ymm9
-#define ruwy3 %ymm10
-#define ruwy4 %ymm11
-#define ruwy0x %xmm7
-#define ruwy1x %xmm8
-#define ruwy2x %xmm9
-#define ruwy3x %xmm10
-#define ruwy4x %xmm11
-#define svxz1 %ymm12
-#define svxz2 %ymm13
-#define svxz3 %ymm14
-#define svxz4 %ymm15
-#define d0 %r9
-#define d1 %r10
-#define d2 %r11
-#define d3 %r12
-#define d4 %r13
-
-SYM_FUNC_START(poly1305_4block_avx2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 64 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Quadblock count
-	# %r8:  Poly1305 derived key r^2 u[5], r^3 w[5], r^4 y[5],
-
-	# This four-block variant uses loop unrolled block processing. It
-	# requires 4 Poly1305 keys: r, r^2, r^3 and r^4:
-	# h = (h + m) * r  =>  h = (h + m1) * r^4 + m2 * r^3 + m3 * r^2 + m4 * r
-
-	vzeroupper
-	push		%rbx
-	push		%r12
-	push		%r13
-
-	# combine r0,u0,w0,y0
-	vmovd		y0,ruwy0x
-	vmovd		w0,t1x
-	vpunpcklqdq	t1,ruwy0,ruwy0
-	vmovd		u0,t1x
-	vmovd		r0,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy0,ruwy0
-
-	# combine r1,u1,w1,y1 and s1=r1*5,v1=u1*5,x1=w1*5,z1=y1*5
-	vmovd		y1,ruwy1x
-	vmovd		w1,t1x
-	vpunpcklqdq	t1,ruwy1,ruwy1
-	vmovd		u1,t1x
-	vmovd		r1,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy1,ruwy1
-	vpslld		$2,ruwy1,svxz1
-	vpaddd		ruwy1,svxz1,svxz1
-
-	# combine r2,u2,w2,y2 and s2=r2*5,v2=u2*5,x2=w2*5,z2=y2*5
-	vmovd		y2,ruwy2x
-	vmovd		w2,t1x
-	vpunpcklqdq	t1,ruwy2,ruwy2
-	vmovd		u2,t1x
-	vmovd		r2,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy2,ruwy2
-	vpslld		$2,ruwy2,svxz2
-	vpaddd		ruwy2,svxz2,svxz2
-
-	# combine r3,u3,w3,y3 and s3=r3*5,v3=u3*5,x3=w3*5,z3=y3*5
-	vmovd		y3,ruwy3x
-	vmovd		w3,t1x
-	vpunpcklqdq	t1,ruwy3,ruwy3
-	vmovd		u3,t1x
-	vmovd		r3,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy3,ruwy3
-	vpslld		$2,ruwy3,svxz3
-	vpaddd		ruwy3,svxz3,svxz3
-
-	# combine r4,u4,w4,y4 and s4=r4*5,v4=u4*5,x4=w4*5,z4=y4*5
-	vmovd		y4,ruwy4x
-	vmovd		w4,t1x
-	vpunpcklqdq	t1,ruwy4,ruwy4
-	vmovd		u4,t1x
-	vmovd		r4,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy4,ruwy4
-	vpslld		$2,ruwy4,svxz4
-	vpaddd		ruwy4,svxz4,svxz4
-
-.Ldoblock4:
-	# hc0 = [m[48-51] & 0x3ffffff, m[32-35] & 0x3ffffff,
-	#	 m[16-19] & 0x3ffffff, m[ 0- 3] & 0x3ffffff + h0]
-	vmovd		0x00(m),hc0x
-	vmovd		0x10(m),t1x
-	vpunpcklqdq	t1,hc0,hc0
-	vmovd		0x20(m),t1x
-	vmovd		0x30(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc0,hc0
-	vpand		ANMASK(%rip),hc0,hc0
-	vmovd		h0,t1x
-	vpaddd		t1,hc0,hc0
-	# hc1 = [(m[51-54] >> 2) & 0x3ffffff, (m[35-38] >> 2) & 0x3ffffff,
-	#	 (m[19-22] >> 2) & 0x3ffffff, (m[ 3- 6] >> 2) & 0x3ffffff + h1]
-	vmovd		0x03(m),hc1x
-	vmovd		0x13(m),t1x
-	vpunpcklqdq	t1,hc1,hc1
-	vmovd		0x23(m),t1x
-	vmovd		0x33(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc1,hc1
-	vpsrld		$2,hc1,hc1
-	vpand		ANMASK(%rip),hc1,hc1
-	vmovd		h1,t1x
-	vpaddd		t1,hc1,hc1
-	# hc2 = [(m[54-57] >> 4) & 0x3ffffff, (m[38-41] >> 4) & 0x3ffffff,
-	#	 (m[22-25] >> 4) & 0x3ffffff, (m[ 6- 9] >> 4) & 0x3ffffff + h2]
-	vmovd		0x06(m),hc2x
-	vmovd		0x16(m),t1x
-	vpunpcklqdq	t1,hc2,hc2
-	vmovd		0x26(m),t1x
-	vmovd		0x36(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc2,hc2
-	vpsrld		$4,hc2,hc2
-	vpand		ANMASK(%rip),hc2,hc2
-	vmovd		h2,t1x
-	vpaddd		t1,hc2,hc2
-	# hc3 = [(m[57-60] >> 6) & 0x3ffffff, (m[41-44] >> 6) & 0x3ffffff,
-	#	 (m[25-28] >> 6) & 0x3ffffff, (m[ 9-12] >> 6) & 0x3ffffff + h3]
-	vmovd		0x09(m),hc3x
-	vmovd		0x19(m),t1x
-	vpunpcklqdq	t1,hc3,hc3
-	vmovd		0x29(m),t1x
-	vmovd		0x39(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc3,hc3
-	vpsrld		$6,hc3,hc3
-	vpand		ANMASK(%rip),hc3,hc3
-	vmovd		h3,t1x
-	vpaddd		t1,hc3,hc3
-	# hc4 = [(m[60-63] >> 8) | (1<<24), (m[44-47] >> 8) | (1<<24),
-	#	 (m[28-31] >> 8) | (1<<24), (m[12-15] >> 8) | (1<<24) + h4]
-	vmovd		0x0c(m),hc4x
-	vmovd		0x1c(m),t1x
-	vpunpcklqdq	t1,hc4,hc4
-	vmovd		0x2c(m),t1x
-	vmovd		0x3c(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc4,hc4
-	vpsrld		$8,hc4,hc4
-	vpor		ORMASK(%rip),hc4,hc4
-	vmovd		h4,t1x
-	vpaddd		t1,hc4,hc4
-
-	# t1 = [ hc0[3] * r0, hc0[2] * u0, hc0[1] * w0, hc0[0] * y0 ]
-	vpmuludq	hc0,ruwy0,t1
-	# t1 += [ hc1[3] * s4, hc1[2] * v4, hc1[1] * x4, hc1[0] * z4 ]
-	vpmuludq	hc1,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * s3, hc2[2] * v3, hc2[1] * x3, hc2[0] * z3 ]
-	vpmuludq	hc2,svxz3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s2, hc3[2] * v2, hc3[1] * x2, hc3[0] * z2 ]
-	vpmuludq	hc3,svxz2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s1, hc4[2] * v1, hc4[1] * x1, hc4[0] * z1 ]
-	vpmuludq	hc4,svxz1,t2
-	vpaddq		t2,t1,t1
-	# d0 = t1[0] + t1[1] + t[2] + t[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d0
-
-	# t1 = [ hc0[3] * r1, hc0[2] * u1,hc0[1] * w1, hc0[0] * y1 ]
-	vpmuludq	hc0,ruwy1,t1
-	# t1 += [ hc1[3] * r0, hc1[2] * u0, hc1[1] * w0, hc1[0] * y0 ]
-	vpmuludq	hc1,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * s4, hc2[2] * v4, hc2[1] * x4, hc2[0] * z4 ]
-	vpmuludq	hc2,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s3, hc3[2] * v3, hc3[1] * x3, hc3[0] * z3 ]
-	vpmuludq	hc3,svxz3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s2, hc4[2] * v2, hc4[1] * x2, hc4[0] * z2 ]
-	vpmuludq	hc4,svxz2,t2
-	vpaddq		t2,t1,t1
-	# d1 = t1[0] + t1[1] + t1[3] + t1[4]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d1
-
-	# t1 = [ hc0[3] * r2, hc0[2] * u2, hc0[1] * w2, hc0[0] * y2 ]
-	vpmuludq	hc0,ruwy2,t1
-	# t1 += [ hc1[3] * r1, hc1[2] * u1, hc1[1] * w1, hc1[0] * y1 ]
-	vpmuludq	hc1,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r0, hc2[2] * u0, hc2[1] * w0, hc2[0] * y0 ]
-	vpmuludq	hc2,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s4, hc3[2] * v4, hc3[1] * x4, hc3[0] * z4 ]
-	vpmuludq	hc3,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s3, hc4[2] * v3, hc4[1] * x3, hc4[0] * z3 ]
-	vpmuludq	hc4,svxz3,t2
-	vpaddq		t2,t1,t1
-	# d2 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d2
-
-	# t1 = [ hc0[3] * r3, hc0[2] * u3, hc0[1] * w3, hc0[0] * y3 ]
-	vpmuludq	hc0,ruwy3,t1
-	# t1 += [ hc1[3] * r2, hc1[2] * u2, hc1[1] * w2, hc1[0] * y2 ]
-	vpmuludq	hc1,ruwy2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r1, hc2[2] * u1, hc2[1] * w1, hc2[0] * y1 ]
-	vpmuludq	hc2,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * r0, hc3[2] * u0, hc3[1] * w0, hc3[0] * y0 ]
-	vpmuludq	hc3,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s4, hc4[2] * v4, hc4[1] * x4, hc4[0] * z4 ]
-	vpmuludq	hc4,svxz4,t2
-	vpaddq		t2,t1,t1
-	# d3 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d3
-
-	# t1 = [ hc0[3] * r4, hc0[2] * u4, hc0[1] * w4, hc0[0] * y4 ]
-	vpmuludq	hc0,ruwy4,t1
-	# t1 += [ hc1[3] * r3, hc1[2] * u3, hc1[1] * w3, hc1[0] * y3 ]
-	vpmuludq	hc1,ruwy3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r2, hc2[2] * u2, hc2[1] * w2, hc2[0] * y2 ]
-	vpmuludq	hc2,ruwy2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * r1, hc3[2] * u1, hc3[1] * w1, hc3[0] * y1 ]
-	vpmuludq	hc3,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * r0, hc4[2] * u0, hc4[1] * w0, hc4[0] * y0 ]
-	vpmuludq	hc4,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# d4 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d4
-
-	# Now do a partial reduction mod (2^130)-5, carrying h0 -> h1 -> h2 ->
-	# h3 -> h4 -> h0 -> h1 to get h0,h2,h3,h4 < 2^26 and h1 < 2^26 + a small
-	# amount.  Careful: we must not assume the carry bits 'd0 >> 26',
-	# 'd1 >> 26', 'd2 >> 26', 'd3 >> 26', and '(d4 >> 26) * 5' fit in 32-bit
-	# integers.  It's true in a single-block implementation, but not here.
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%rax,%rax,4),%rax
-	add		%rax,%rbx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%rbx,%rax
-	shr		$26,%rax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x40,m
-	dec		%rcx
-	jnz		.Ldoblock4
-
-	vzeroupper
-	pop		%r13
-	pop		%r12
-	pop		%rbx
-	ret
-SYM_FUNC_END(poly1305_4block_avx2)
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
deleted file mode 100644
index d8ea29b96640..000000000000
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ /dev/null
@@ -1,590 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Poly1305 authenticator algorithm, RFC7539, x64 SSE2 functions
- *
- * Copyright (C) 2015 Martin Willi
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst16.ANMASK, "aM", @progbits, 16
-.align 16
-ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
-
-.section	.rodata.cst16.ORMASK, "aM", @progbits, 16
-.align 16
-ORMASK:	.octa 0x00000000010000000000000001000000
-
-.text
-
-#define h0 0x00(%rdi)
-#define h1 0x04(%rdi)
-#define h2 0x08(%rdi)
-#define h3 0x0c(%rdi)
-#define h4 0x10(%rdi)
-#define r0 0x00(%rdx)
-#define r1 0x04(%rdx)
-#define r2 0x08(%rdx)
-#define r3 0x0c(%rdx)
-#define r4 0x10(%rdx)
-#define s1 0x00(%rsp)
-#define s2 0x04(%rsp)
-#define s3 0x08(%rsp)
-#define s4 0x0c(%rsp)
-#define m %rsi
-#define h01 %xmm0
-#define h23 %xmm1
-#define h44 %xmm2
-#define t1 %xmm3
-#define t2 %xmm4
-#define t3 %xmm5
-#define t4 %xmm6
-#define mask %xmm7
-#define d0 %r8
-#define d1 %r9
-#define d2 %r10
-#define d3 %r11
-#define d4 %r12
-
-SYM_FUNC_START(poly1305_block_sse2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 16 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Block count
-
-	# This single block variant tries to improve performance by doing two
-	# multiplications in parallel using SSE instructions. There is quite
-	# some quardword packing involved, hence the speedup is marginal.
-
-	push		%rbx
-	push		%r12
-	sub		$0x10,%rsp
-
-	# s1..s4 = r1..r4 * 5
-	mov		r1,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s1
-	mov		r2,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s2
-	mov		r3,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s3
-	mov		r4,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s4
-
-	movdqa		ANMASK(%rip),mask
-
-.Ldoblock:
-	# h01 = [0, h1, 0, h0]
-	# h23 = [0, h3, 0, h2]
-	# h44 = [0, h4, 0, h4]
-	movd		h0,h01
-	movd		h1,t1
-	movd		h2,h23
-	movd		h3,t2
-	movd		h4,h44
-	punpcklqdq	t1,h01
-	punpcklqdq	t2,h23
-	punpcklqdq	h44,h44
-
-	# h01 += [ (m[3-6] >> 2) & 0x3ffffff, m[0-3] & 0x3ffffff ]
-	movd		0x00(m),t1
-	movd		0x03(m),t2
-	psrld		$2,t2
-	punpcklqdq	t2,t1
-	pand		mask,t1
-	paddd		t1,h01
-	# h23 += [ (m[9-12] >> 6) & 0x3ffffff, (m[6-9] >> 4) & 0x3ffffff ]
-	movd		0x06(m),t1
-	movd		0x09(m),t2
-	psrld		$4,t1
-	psrld		$6,t2
-	punpcklqdq	t2,t1
-	pand		mask,t1
-	paddd		t1,h23
-	# h44 += [ (m[12-15] >> 8) | (1 << 24), (m[12-15] >> 8) | (1 << 24) ]
-	mov		0x0c(m),%eax
-	shr		$8,%eax
-	or		$0x01000000,%eax
-	movd		%eax,t1
-	pshufd		$0xc4,t1,t1
-	paddd		t1,h44
-
-	# t1[0] = h0 * r0 + h2 * s3
-	# t1[1] = h1 * s4 + h3 * s2
-	movd		r0,t1
-	movd		s4,t2
-	punpcklqdq	t2,t1
-	pmuludq		h01,t1
-	movd		s3,t2
-	movd		s2,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t2[0] = h0 * r1 + h2 * s4
-	# t2[1] = h1 * r0 + h3 * s3
-	movd		r1,t2
-	movd		r0,t3
-	punpcklqdq	t3,t2
-	pmuludq		h01,t2
-	movd		s4,t3
-	movd		s3,t4
-	punpcklqdq	t4,t3
-	pmuludq		h23,t3
-	paddq		t3,t2
-	# t3[0] = h4 * s1
-	# t3[1] = h4 * s2
-	movd		s1,t3
-	movd		s2,t4
-	punpcklqdq	t4,t3
-	pmuludq		h44,t3
-	# d0 = t1[0] + t1[1] + t3[0]
-	# d1 = t2[0] + t2[1] + t3[1]
-	movdqa		t1,t4
-	punpcklqdq	t2,t4
-	punpckhqdq	t2,t1
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d0
-	psrldq		$8,t1
-	movq		t1,d1
-
-	# t1[0] = h0 * r2 + h2 * r0
-	# t1[1] = h1 * r1 + h3 * s4
-	movd		r2,t1
-	movd		r1,t2
-	punpcklqdq 	t2,t1
-	pmuludq		h01,t1
-	movd		r0,t2
-	movd		s4,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t2[0] = h0 * r3 + h2 * r1
-	# t2[1] = h1 * r2 + h3 * r0
-	movd		r3,t2
-	movd		r2,t3
-	punpcklqdq	t3,t2
-	pmuludq		h01,t2
-	movd		r1,t3
-	movd		r0,t4
-	punpcklqdq	t4,t3
-	pmuludq		h23,t3
-	paddq		t3,t2
-	# t3[0] = h4 * s3
-	# t3[1] = h4 * s4
-	movd		s3,t3
-	movd		s4,t4
-	punpcklqdq	t4,t3
-	pmuludq		h44,t3
-	# d2 = t1[0] + t1[1] + t3[0]
-	# d3 = t2[0] + t2[1] + t3[1]
-	movdqa		t1,t4
-	punpcklqdq	t2,t4
-	punpckhqdq	t2,t1
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d2
-	psrldq		$8,t1
-	movq		t1,d3
-
-	# t1[0] = h0 * r4 + h2 * r2
-	# t1[1] = h1 * r3 + h3 * r1
-	movd		r4,t1
-	movd		r3,t2
-	punpcklqdq	t2,t1
-	pmuludq		h01,t1
-	movd		r2,t2
-	movd		r1,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t3[0] = h4 * r0
-	movd		r0,t3
-	pmuludq		h44,t3
-	# d4 = t1[0] + t1[1] + t3[0]
-	movdqa		t1,t4
-	psrldq		$8,t4
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d4
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%rax,%rax,4),%rax
-	add		%rax,%rbx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%rbx,%rax
-	shr		$26,%rax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x10,m
-	dec		%rcx
-	jnz		.Ldoblock
-
-	# Zeroing of key material
-	mov		%rcx,0x00(%rsp)
-	mov		%rcx,0x08(%rsp)
-
-	add		$0x10,%rsp
-	pop		%r12
-	pop		%rbx
-	ret
-SYM_FUNC_END(poly1305_block_sse2)
-
-
-#define u0 0x00(%r8)
-#define u1 0x04(%r8)
-#define u2 0x08(%r8)
-#define u3 0x0c(%r8)
-#define u4 0x10(%r8)
-#define hc0 %xmm0
-#define hc1 %xmm1
-#define hc2 %xmm2
-#define hc3 %xmm5
-#define hc4 %xmm6
-#define ru0 %xmm7
-#define ru1 %xmm8
-#define ru2 %xmm9
-#define ru3 %xmm10
-#define ru4 %xmm11
-#define sv1 %xmm12
-#define sv2 %xmm13
-#define sv3 %xmm14
-#define sv4 %xmm15
-#undef d0
-#define d0 %r13
-
-SYM_FUNC_START(poly1305_2block_sse2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 16 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Doubleblock count
-	# %r8:  Poly1305 derived key r^2 u[5]
-
-	# This two-block variant further improves performance by using loop
-	# unrolled block processing. This is more straight forward and does
-	# less byte shuffling, but requires a second Poly1305 key r^2:
-	# h = (h + m) * r    =>    h = (h + m1) * r^2 + m2 * r
-
-	push		%rbx
-	push		%r12
-	push		%r13
-
-	# combine r0,u0
-	movd		u0,ru0
-	movd		r0,t1
-	punpcklqdq	t1,ru0
-
-	# combine r1,u1 and s1=r1*5,v1=u1*5
-	movd		u1,ru1
-	movd		r1,t1
-	punpcklqdq	t1,ru1
-	movdqa		ru1,sv1
-	pslld		$2,sv1
-	paddd		ru1,sv1
-
-	# combine r2,u2 and s2=r2*5,v2=u2*5
-	movd		u2,ru2
-	movd		r2,t1
-	punpcklqdq	t1,ru2
-	movdqa		ru2,sv2
-	pslld		$2,sv2
-	paddd		ru2,sv2
-
-	# combine r3,u3 and s3=r3*5,v3=u3*5
-	movd		u3,ru3
-	movd		r3,t1
-	punpcklqdq	t1,ru3
-	movdqa		ru3,sv3
-	pslld		$2,sv3
-	paddd		ru3,sv3
-
-	# combine r4,u4 and s4=r4*5,v4=u4*5
-	movd		u4,ru4
-	movd		r4,t1
-	punpcklqdq	t1,ru4
-	movdqa		ru4,sv4
-	pslld		$2,sv4
-	paddd		ru4,sv4
-
-.Ldoblock2:
-	# hc0 = [ m[16-19] & 0x3ffffff, h0 + m[0-3] & 0x3ffffff ]
-	movd		0x00(m),hc0
-	movd		0x10(m),t1
-	punpcklqdq	t1,hc0
-	pand		ANMASK(%rip),hc0
-	movd		h0,t1
-	paddd		t1,hc0
-	# hc1 = [ (m[19-22] >> 2) & 0x3ffffff, h1 + (m[3-6] >> 2) & 0x3ffffff ]
-	movd		0x03(m),hc1
-	movd		0x13(m),t1
-	punpcklqdq	t1,hc1
-	psrld		$2,hc1
-	pand		ANMASK(%rip),hc1
-	movd		h1,t1
-	paddd		t1,hc1
-	# hc2 = [ (m[22-25] >> 4) & 0x3ffffff, h2 + (m[6-9] >> 4) & 0x3ffffff ]
-	movd		0x06(m),hc2
-	movd		0x16(m),t1
-	punpcklqdq	t1,hc2
-	psrld		$4,hc2
-	pand		ANMASK(%rip),hc2
-	movd		h2,t1
-	paddd		t1,hc2
-	# hc3 = [ (m[25-28] >> 6) & 0x3ffffff, h3 + (m[9-12] >> 6) & 0x3ffffff ]
-	movd		0x09(m),hc3
-	movd		0x19(m),t1
-	punpcklqdq	t1,hc3
-	psrld		$6,hc3
-	pand		ANMASK(%rip),hc3
-	movd		h3,t1
-	paddd		t1,hc3
-	# hc4 = [ (m[28-31] >> 8) | (1<<24), h4 + (m[12-15] >> 8) | (1<<24) ]
-	movd		0x0c(m),hc4
-	movd		0x1c(m),t1
-	punpcklqdq	t1,hc4
-	psrld		$8,hc4
-	por		ORMASK(%rip),hc4
-	movd		h4,t1
-	paddd		t1,hc4
-
-	# t1 = [ hc0[1] * r0, hc0[0] * u0 ]
-	movdqa		ru0,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * s4, hc1[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * s3, hc2[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s2, hc3[0] * v2 ]
-	movdqa		sv2,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s1, hc4[0] * v1 ]
-	movdqa		sv1,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d0 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d0
-
-	# t1 = [ hc0[1] * r1, hc0[0] * u1 ]
-	movdqa		ru1,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r0, hc1[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * s4, hc2[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s3, hc3[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s2, hc4[0] * v2 ]
-	movdqa		sv2,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d1 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d1
-
-	# t1 = [ hc0[1] * r2, hc0[0] * u2 ]
-	movdqa		ru2,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r1, hc1[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r0, hc2[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s4, hc3[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s3, hc4[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d2 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d2
-
-	# t1 = [ hc0[1] * r3, hc0[0] * u3 ]
-	movdqa		ru3,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r2, hc1[0] * u2 ]
-	movdqa		ru2,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r1, hc2[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * r0, hc3[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s4, hc4[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d3 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d3
-
-	# t1 = [ hc0[1] * r4, hc0[0] * u4 ]
-	movdqa		ru4,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r3, hc1[0] * u3 ]
-	movdqa		ru3,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r2, hc2[0] * u2 ]
-	movdqa		ru2,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * r1, hc3[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * r0, hc4[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d4 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d4
-
-	# Now do a partial reduction mod (2^130)-5, carrying h0 -> h1 -> h2 ->
-	# h3 -> h4 -> h0 -> h1 to get h0,h2,h3,h4 < 2^26 and h1 < 2^26 + a small
-	# amount.  Careful: we must not assume the carry bits 'd0 >> 26',
-	# 'd1 >> 26', 'd2 >> 26', 'd3 >> 26', and '(d4 >> 26) * 5' fit in 32-bit
-	# integers.  It's true in a single-block implementation, but not here.
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%rax,%rax,4),%rax
-	add		%rax,%rbx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%rbx,%rax
-	shr		$26,%rax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x20,m
-	dec		%rcx
-	jnz		.Ldoblock2
-
-	pop		%r13
-	pop		%r12
-	pop		%rbx
-	ret
-SYM_FUNC_END(poly1305_2block_sse2)
diff --git a/arch/x86/crypto/poly1305-x86_64.pl b/arch/x86/crypto/poly1305-x86_64.pl
new file mode 100644
index 000000000000..f994855cdbe2
--- /dev/null
+++ b/arch/x86/crypto/poly1305-x86_64.pl
@@ -0,0 +1,4266 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+#
+# Copyright (C) 2017-2018 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
+# Copyright (C) 2017-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+# Copyright (C) 2006-2017 CRYPTOGAMS by <appro@openssl.org>. All Rights Reserved.
+#
+# This code is taken from the OpenSSL project but the author, Andy Polyakov,
+# has relicensed it under the licenses specified in the SPDX header above.
+# The original headers, including the original license headers, are
+# included below for completeness.
+#
+# ====================================================================
+# Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
+# project. The module is, however, dual licensed under OpenSSL and
+# CRYPTOGAMS licenses depending on where you obtain it. For further
+# details see http://www.openssl.org/~appro/cryptogams/.
+# ====================================================================
+#
+# This module implements Poly1305 hash for x86_64.
+#
+# March 2015
+#
+# Initial release.
+#
+# December 2016
+#
+# Add AVX512F+VL+BW code path.
+#
+# November 2017
+#
+# Convert AVX512F+VL+BW code path to pure AVX512F, so that it can be
+# executed even on Knights Landing. Trigger for modification was
+# observation that AVX512 code paths can negatively affect overall
+# Skylake-X system performance. Since we are likely to suppress
+# AVX512F capability flag [at least on Skylake-X], conversion serves
+# as kind of "investment protection". Note that next *lake processor,
+# Cannonlake, has AVX512IFMA code path to execute...
+#
+# Numbers are cycles per processed byte with poly1305_blocks alone,
+# measured with rdtsc at fixed clock frequency.
+#
+#		IALU/gcc-4.8(*)	AVX(**)		AVX2	AVX-512
+# P4		4.46/+120%	-
+# Core 2	2.41/+90%	-
+# Westmere	1.88/+120%	-
+# Sandy Bridge	1.39/+140%	1.10
+# Haswell	1.14/+175%	1.11		0.65
+# Skylake[-X]	1.13/+120%	0.96		0.51	[0.35]
+# Silvermont	2.83/+95%	-
+# Knights L	3.60/?		1.65		1.10	0.41(***)
+# Goldmont	1.70/+180%	-
+# VIA Nano	1.82/+150%	-
+# Sledgehammer	1.38/+160%	-
+# Bulldozer	2.30/+130%	0.97
+# Ryzen		1.15/+200%	1.08		1.18
+#
+# (*)	improvement coefficients relative to clang are more modest and
+#	are ~50% on most processors, in both cases we are comparing to
+#	__int128 code;
+# (**)	SSE2 implementation was attempted, but among non-AVX processors
+#	it was faster than integer-only code only on older Intel P4 and
+#	Core processors, 50-30%, less newer processor is, but slower on
+#	contemporary ones, for example almost 2x slower on Atom, and as
+#	former are naturally disappearing, SSE2 is deemed unnecessary;
+# (***)	strangely enough performance seems to vary from core to core,
+#	listed result is best case;
+
+$flavour = shift;
+$output  = shift;
+if ($flavour =~ /\./) { $output = $flavour; undef $flavour; }
+
+$win64=0; $win64=1 if ($flavour =~ /[nm]asm|mingw64/ || $output =~ /\.asm$/);
+$kernel=0; $kernel=1 if (!$flavour && !$output);
+
+if (!$kernel) {
+	$0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
+	( $xlate="${dir}x86_64-xlate.pl" and -f $xlate ) or
+	( $xlate="${dir}../../perlasm/x86_64-xlate.pl" and -f $xlate) or
+	die "can't locate x86_64-xlate.pl";
+
+	open OUT,"| \"$^X\" \"$xlate\" $flavour \"$output\"";
+	*STDOUT=*OUT;
+
+	if (`$ENV{CC} -Wa,-v -c -o /dev/null -x assembler /dev/null 2>&1`
+	    =~ /GNU assembler version ([2-9]\.[0-9]+)/) {
+		$avx = ($1>=2.19) + ($1>=2.22) + ($1>=2.25);
+	}
+
+	if (!$avx && $win64 && ($flavour =~ /nasm/ || $ENV{ASM} =~ /nasm/) &&
+	    `nasm -v 2>&1` =~ /NASM version ([2-9]\.[0-9]+)(?:\.([0-9]+))?/) {
+		$avx = ($1>=2.09) + ($1>=2.10) + ($1>=2.12);
+		$avx += 1 if ($1==2.11 && $2>=8);
+	}
+
+	if (!$avx && $win64 && ($flavour =~ /masm/ || $ENV{ASM} =~ /ml64/) &&
+	    `ml64 2>&1` =~ /Version ([0-9]+)\./) {
+		$avx = ($1>=10) + ($1>=11);
+	}
+
+	if (!$avx && `$ENV{CC} -v 2>&1` =~ /((?:^clang|LLVM) version|.*based on LLVM) ([3-9]\.[0-9]+)/) {
+		$avx = ($2>=3.0) + ($2>3.0);
+	}
+} else {
+	$avx = 4; # The kernel uses ifdefs for this.
+}
+
+sub declare_function() {
+	my ($name, $align, $nargs) = @_;
+	if($kernel) {
+		$code .= ".align $align\n";
+		$code .= "SYM_FUNC_START($name)\n";
+		$code .= ".L$name:\n";
+	} else {
+		$code .= ".globl	$name\n";
+		$code .= ".type	$name,\@function,$nargs\n";
+		$code .= ".align	$align\n";
+		$code .= "$name:\n";
+	}
+}
+
+sub end_function() {
+	my ($name) = @_;
+	if($kernel) {
+		$code .= "SYM_FUNC_END($name)\n";
+	} else {
+		$code .= ".size   $name,.-$name\n";
+	}
+}
+
+$code.=<<___ if $kernel;
+#include <linux/linkage.h>
+___
+
+if ($avx) {
+$code.=<<___ if $kernel;
+.section .rodata
+___
+$code.=<<___;
+.align	64
+.Lconst:
+.Lmask24:
+.long	0x0ffffff,0,0x0ffffff,0,0x0ffffff,0,0x0ffffff,0
+.L129:
+.long	`1<<24`,0,`1<<24`,0,`1<<24`,0,`1<<24`,0
+.Lmask26:
+.long	0x3ffffff,0,0x3ffffff,0,0x3ffffff,0,0x3ffffff,0
+.Lpermd_avx2:
+.long	2,2,2,3,2,0,2,1
+.Lpermd_avx512:
+.long	0,0,0,1, 0,2,0,3, 0,4,0,5, 0,6,0,7
+
+.L2_44_inp_permd:
+.long	0,1,1,2,2,3,7,7
+.L2_44_inp_shift:
+.quad	0,12,24,64
+.L2_44_mask:
+.quad	0xfffffffffff,0xfffffffffff,0x3ffffffffff,0xffffffffffffffff
+.L2_44_shift_rgt:
+.quad	44,44,42,64
+.L2_44_shift_lft:
+.quad	8,8,10,64
+
+.align	64
+.Lx_mask44:
+.quad	0xfffffffffff,0xfffffffffff,0xfffffffffff,0xfffffffffff
+.quad	0xfffffffffff,0xfffffffffff,0xfffffffffff,0xfffffffffff
+.Lx_mask42:
+.quad	0x3ffffffffff,0x3ffffffffff,0x3ffffffffff,0x3ffffffffff
+.quad	0x3ffffffffff,0x3ffffffffff,0x3ffffffffff,0x3ffffffffff
+___
+}
+$code.=<<___ if (!$kernel);
+.asciz	"Poly1305 for x86_64, CRYPTOGAMS by <appro\@openssl.org>"
+.align	16
+___
+
+my ($ctx,$inp,$len,$padbit)=("%rdi","%rsi","%rdx","%rcx");
+my ($mac,$nonce)=($inp,$len);	# *_emit arguments
+my ($d1,$d2,$d3, $r0,$r1,$s1)=("%r8","%r9","%rdi","%r11","%r12","%r13");
+my ($h0,$h1,$h2)=("%r14","%rbx","%r10");
+
+sub poly1305_iteration {
+# input:	copy of $r1 in %rax, $h0-$h2, $r0-$r1
+# output:	$h0-$h2 *= $r0-$r1
+$code.=<<___;
+	mulq	$h0			# h0*r1
+	mov	%rax,$d2
+	 mov	$r0,%rax
+	mov	%rdx,$d3
+
+	mulq	$h0			# h0*r0
+	mov	%rax,$h0		# future $h0
+	 mov	$r0,%rax
+	mov	%rdx,$d1
+
+	mulq	$h1			# h1*r0
+	add	%rax,$d2
+	 mov	$s1,%rax
+	adc	%rdx,$d3
+
+	mulq	$h1			# h1*s1
+	 mov	$h2,$h1			# borrow $h1
+	add	%rax,$h0
+	adc	%rdx,$d1
+
+	imulq	$s1,$h1			# h2*s1
+	add	$h1,$d2
+	 mov	$d1,$h1
+	adc	\$0,$d3
+
+	imulq	$r0,$h2			# h2*r0
+	add	$d2,$h1
+	mov	\$-4,%rax		# mask value
+	adc	$h2,$d3
+
+	and	$d3,%rax		# last reduction step
+	mov	$d3,$h2
+	shr	\$2,$d3
+	and	\$3,$h2
+	add	$d3,%rax
+	add	%rax,$h0
+	adc	\$0,$h1
+	adc	\$0,$h2
+___
+}
+
+########################################################################
+# Layout of opaque area is following.
+#
+#	unsigned __int64 h[3];		# current hash value base 2^64
+#	unsigned __int64 r[2];		# key value base 2^64
+
+$code.=<<___;
+.text
+___
+$code.=<<___ if (!$kernel);
+.extern	OPENSSL_ia32cap_P
+
+.globl	poly1305_init_x86_64
+.hidden	poly1305_init_x86_64
+.globl	poly1305_blocks_x86_64
+.hidden	poly1305_blocks_x86_64
+.globl	poly1305_emit_x86_64
+.hidden	poly1305_emit_x86_64
+___
+&declare_function("poly1305_init_x86_64", 32, 3);
+$code.=<<___;
+	xor	%rax,%rax
+	mov	%rax,0($ctx)		# initialize hash value
+	mov	%rax,8($ctx)
+	mov	%rax,16($ctx)
+
+	cmp	\$0,$inp
+	je	.Lno_key
+___
+$code.=<<___ if (!$kernel);
+	lea	poly1305_blocks_x86_64(%rip),%r10
+	lea	poly1305_emit_x86_64(%rip),%r11
+___
+$code.=<<___	if (!$kernel && $avx);
+	mov	OPENSSL_ia32cap_P+4(%rip),%r9
+	lea	poly1305_blocks_avx(%rip),%rax
+	lea	poly1305_emit_avx(%rip),%rcx
+	bt	\$`60-32`,%r9		# AVX?
+	cmovc	%rax,%r10
+	cmovc	%rcx,%r11
+___
+$code.=<<___	if (!$kernel && $avx>1);
+	lea	poly1305_blocks_avx2(%rip),%rax
+	bt	\$`5+32`,%r9		# AVX2?
+	cmovc	%rax,%r10
+___
+$code.=<<___	if (!$kernel && $avx>3);
+	mov	\$`(1<<31|1<<21|1<<16)`,%rax
+	shr	\$32,%r9
+	and	%rax,%r9
+	cmp	%rax,%r9
+	je	.Linit_base2_44
+___
+$code.=<<___;
+	mov	\$0x0ffffffc0fffffff,%rax
+	mov	\$0x0ffffffc0ffffffc,%rcx
+	and	0($inp),%rax
+	and	8($inp),%rcx
+	mov	%rax,24($ctx)
+	mov	%rcx,32($ctx)
+___
+$code.=<<___	if (!$kernel && $flavour !~ /elf32/);
+	mov	%r10,0(%rdx)
+	mov	%r11,8(%rdx)
+___
+$code.=<<___	if (!$kernel && $flavour =~ /elf32/);
+	mov	%r10d,0(%rdx)
+	mov	%r11d,4(%rdx)
+___
+$code.=<<___;
+	mov	\$1,%eax
+.Lno_key:
+	ret
+___
+&end_function("poly1305_init_x86_64");
+
+&declare_function("poly1305_blocks_x86_64", 32, 4);
+$code.=<<___;
+.cfi_startproc
+.Lblocks:
+	shr	\$4,$len
+	jz	.Lno_data		# too short
+
+	push	%rbx
+.cfi_push	%rbx
+	push	%r12
+.cfi_push	%r12
+	push	%r13
+.cfi_push	%r13
+	push	%r14
+.cfi_push	%r14
+	push	%r15
+.cfi_push	%r15
+	push	$ctx
+.cfi_push	$ctx
+.Lblocks_body:
+
+	mov	$len,%r15		# reassign $len
+
+	mov	24($ctx),$r0		# load r
+	mov	32($ctx),$s1
+
+	mov	0($ctx),$h0		# load hash value
+	mov	8($ctx),$h1
+	mov	16($ctx),$h2
+
+	mov	$s1,$r1
+	shr	\$2,$s1
+	mov	$r1,%rax
+	add	$r1,$s1			# s1 = r1 + (r1 >> 2)
+	jmp	.Loop
+
+.align	32
+.Loop:
+	add	0($inp),$h0		# accumulate input
+	adc	8($inp),$h1
+	lea	16($inp),$inp
+	adc	$padbit,$h2
+___
+
+	&poly1305_iteration();
+
+$code.=<<___;
+	mov	$r1,%rax
+	dec	%r15			# len-=16
+	jnz	.Loop
+
+	mov	0(%rsp),$ctx
+.cfi_restore	$ctx
+
+	mov	$h0,0($ctx)		# store hash value
+	mov	$h1,8($ctx)
+	mov	$h2,16($ctx)
+
+	mov	8(%rsp),%r15
+.cfi_restore	%r15
+	mov	16(%rsp),%r14
+.cfi_restore	%r14
+	mov	24(%rsp),%r13
+.cfi_restore	%r13
+	mov	32(%rsp),%r12
+.cfi_restore	%r12
+	mov	40(%rsp),%rbx
+.cfi_restore	%rbx
+	lea	48(%rsp),%rsp
+.cfi_adjust_cfa_offset	-48
+.Lno_data:
+.Lblocks_epilogue:
+	ret
+.cfi_endproc
+___
+&end_function("poly1305_blocks_x86_64");
+
+&declare_function("poly1305_emit_x86_64", 32, 3);
+$code.=<<___;
+.Lemit:
+	mov	0($ctx),%r8	# load hash value
+	mov	8($ctx),%r9
+	mov	16($ctx),%r10
+
+	mov	%r8,%rax
+	add	\$5,%r8		# compare to modulus
+	mov	%r9,%rcx
+	adc	\$0,%r9
+	adc	\$0,%r10
+	shr	\$2,%r10	# did 130-bit value overflow?
+	cmovnz	%r8,%rax
+	cmovnz	%r9,%rcx
+
+	add	0($nonce),%rax	# accumulate nonce
+	adc	8($nonce),%rcx
+	mov	%rax,0($mac)	# write result
+	mov	%rcx,8($mac)
+
+	ret
+___
+&end_function("poly1305_emit_x86_64");
+if ($avx) {
+
+if($kernel) {
+	$code .= "#ifdef CONFIG_AS_AVX\n";
+}
+
+########################################################################
+# Layout of opaque area is following.
+#
+#	unsigned __int32 h[5];		# current hash value base 2^26
+#	unsigned __int32 is_base2_26;
+#	unsigned __int64 r[2];		# key value base 2^64
+#	unsigned __int64 pad;
+#	struct { unsigned __int32 r^2, r^1, r^4, r^3; } r[9];
+#
+# where r^n are base 2^26 digits of degrees of multiplier key. There are
+# 5 digits, but last four are interleaved with multiples of 5, totalling
+# in 9 elements: r0, r1, 5*r1, r2, 5*r2, r3, 5*r3, r4, 5*r4.
+
+my ($H0,$H1,$H2,$H3,$H4, $T0,$T1,$T2,$T3,$T4, $D0,$D1,$D2,$D3,$D4, $MASK) =
+    map("%xmm$_",(0..15));
+
+$code.=<<___;
+.type	__poly1305_block,\@abi-omnipotent
+.align	32
+__poly1305_block:
+	push $ctx
+___
+	&poly1305_iteration();
+$code.=<<___;
+	pop $ctx
+	ret
+.size	__poly1305_block,.-__poly1305_block
+
+.type	__poly1305_init_avx,\@abi-omnipotent
+.align	32
+__poly1305_init_avx:
+	push %rbp
+	mov %rsp,%rbp
+	mov	$r0,$h0
+	mov	$r1,$h1
+	xor	$h2,$h2
+
+	lea	48+64($ctx),$ctx	# size optimization
+
+	mov	$r1,%rax
+	call	__poly1305_block	# r^2
+
+	mov	\$0x3ffffff,%eax	# save interleaved r^2 and r base 2^26
+	mov	\$0x3ffffff,%edx
+	mov	$h0,$d1
+	and	$h0#d,%eax
+	mov	$r0,$d2
+	and	$r0#d,%edx
+	mov	%eax,`16*0+0-64`($ctx)
+	shr	\$26,$d1
+	mov	%edx,`16*0+4-64`($ctx)
+	shr	\$26,$d2
+
+	mov	\$0x3ffffff,%eax
+	mov	\$0x3ffffff,%edx
+	and	$d1#d,%eax
+	and	$d2#d,%edx
+	mov	%eax,`16*1+0-64`($ctx)
+	lea	(%rax,%rax,4),%eax	# *5
+	mov	%edx,`16*1+4-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	mov	%eax,`16*2+0-64`($ctx)
+	shr	\$26,$d1
+	mov	%edx,`16*2+4-64`($ctx)
+	shr	\$26,$d2
+
+	mov	$h1,%rax
+	mov	$r1,%rdx
+	shl	\$12,%rax
+	shl	\$12,%rdx
+	or	$d1,%rax
+	or	$d2,%rdx
+	and	\$0x3ffffff,%eax
+	and	\$0x3ffffff,%edx
+	mov	%eax,`16*3+0-64`($ctx)
+	lea	(%rax,%rax,4),%eax	# *5
+	mov	%edx,`16*3+4-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	mov	%eax,`16*4+0-64`($ctx)
+	mov	$h1,$d1
+	mov	%edx,`16*4+4-64`($ctx)
+	mov	$r1,$d2
+
+	mov	\$0x3ffffff,%eax
+	mov	\$0x3ffffff,%edx
+	shr	\$14,$d1
+	shr	\$14,$d2
+	and	$d1#d,%eax
+	and	$d2#d,%edx
+	mov	%eax,`16*5+0-64`($ctx)
+	lea	(%rax,%rax,4),%eax	# *5
+	mov	%edx,`16*5+4-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	mov	%eax,`16*6+0-64`($ctx)
+	shr	\$26,$d1
+	mov	%edx,`16*6+4-64`($ctx)
+	shr	\$26,$d2
+
+	mov	$h2,%rax
+	shl	\$24,%rax
+	or	%rax,$d1
+	mov	$d1#d,`16*7+0-64`($ctx)
+	lea	($d1,$d1,4),$d1		# *5
+	mov	$d2#d,`16*7+4-64`($ctx)
+	lea	($d2,$d2,4),$d2		# *5
+	mov	$d1#d,`16*8+0-64`($ctx)
+	mov	$d2#d,`16*8+4-64`($ctx)
+
+	mov	$r1,%rax
+	call	__poly1305_block	# r^3
+
+	mov	\$0x3ffffff,%eax	# save r^3 base 2^26
+	mov	$h0,$d1
+	and	$h0#d,%eax
+	shr	\$26,$d1
+	mov	%eax,`16*0+12-64`($ctx)
+
+	mov	\$0x3ffffff,%edx
+	and	$d1#d,%edx
+	mov	%edx,`16*1+12-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	shr	\$26,$d1
+	mov	%edx,`16*2+12-64`($ctx)
+
+	mov	$h1,%rax
+	shl	\$12,%rax
+	or	$d1,%rax
+	and	\$0x3ffffff,%eax
+	mov	%eax,`16*3+12-64`($ctx)
+	lea	(%rax,%rax,4),%eax	# *5
+	mov	$h1,$d1
+	mov	%eax,`16*4+12-64`($ctx)
+
+	mov	\$0x3ffffff,%edx
+	shr	\$14,$d1
+	and	$d1#d,%edx
+	mov	%edx,`16*5+12-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	shr	\$26,$d1
+	mov	%edx,`16*6+12-64`($ctx)
+
+	mov	$h2,%rax
+	shl	\$24,%rax
+	or	%rax,$d1
+	mov	$d1#d,`16*7+12-64`($ctx)
+	lea	($d1,$d1,4),$d1		# *5
+	mov	$d1#d,`16*8+12-64`($ctx)
+
+	mov	$r1,%rax
+	call	__poly1305_block	# r^4
+
+	mov	\$0x3ffffff,%eax	# save r^4 base 2^26
+	mov	$h0,$d1
+	and	$h0#d,%eax
+	shr	\$26,$d1
+	mov	%eax,`16*0+8-64`($ctx)
+
+	mov	\$0x3ffffff,%edx
+	and	$d1#d,%edx
+	mov	%edx,`16*1+8-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	shr	\$26,$d1
+	mov	%edx,`16*2+8-64`($ctx)
+
+	mov	$h1,%rax
+	shl	\$12,%rax
+	or	$d1,%rax
+	and	\$0x3ffffff,%eax
+	mov	%eax,`16*3+8-64`($ctx)
+	lea	(%rax,%rax,4),%eax	# *5
+	mov	$h1,$d1
+	mov	%eax,`16*4+8-64`($ctx)
+
+	mov	\$0x3ffffff,%edx
+	shr	\$14,$d1
+	and	$d1#d,%edx
+	mov	%edx,`16*5+8-64`($ctx)
+	lea	(%rdx,%rdx,4),%edx	# *5
+	shr	\$26,$d1
+	mov	%edx,`16*6+8-64`($ctx)
+
+	mov	$h2,%rax
+	shl	\$24,%rax
+	or	%rax,$d1
+	mov	$d1#d,`16*7+8-64`($ctx)
+	lea	($d1,$d1,4),$d1		# *5
+	mov	$d1#d,`16*8+8-64`($ctx)
+
+	lea	-48-64($ctx),$ctx	# size [de-]optimization
+	pop %rbp
+	ret
+.size	__poly1305_init_avx,.-__poly1305_init_avx
+___
+
+&declare_function("poly1305_blocks_avx", 32, 4);
+$code.=<<___;
+.cfi_startproc
+	mov	20($ctx),%r8d		# is_base2_26
+	cmp	\$128,$len
+	jae	.Lblocks_avx
+	test	%r8d,%r8d
+	jz	.Lblocks
+
+.Lblocks_avx:
+	and	\$-16,$len
+	jz	.Lno_data_avx
+
+	vzeroupper
+
+	test	%r8d,%r8d
+	jz	.Lbase2_64_avx
+
+	test	\$31,$len
+	jz	.Leven_avx
+
+	push	%rbp
+.cfi_push	%rbp
+	mov 	%rsp,%rbp
+	push	%rbx
+.cfi_push	%rbx
+	push	%r12
+.cfi_push	%r12
+	push	%r13
+.cfi_push	%r13
+	push	%r14
+.cfi_push	%r14
+	push	%r15
+.cfi_push	%r15
+.Lblocks_avx_body:
+
+	mov	$len,%r15		# reassign $len
+
+	mov	0($ctx),$d1		# load hash value
+	mov	8($ctx),$d2
+	mov	16($ctx),$h2#d
+
+	mov	24($ctx),$r0		# load r
+	mov	32($ctx),$s1
+
+	################################# base 2^26 -> base 2^64
+	mov	$d1#d,$h0#d
+	and	\$`-1*(1<<31)`,$d1
+	mov	$d2,$r1			# borrow $r1
+	mov	$d2#d,$h1#d
+	and	\$`-1*(1<<31)`,$d2
+
+	shr	\$6,$d1
+	shl	\$52,$r1
+	add	$d1,$h0
+	shr	\$12,$h1
+	shr	\$18,$d2
+	add	$r1,$h0
+	adc	$d2,$h1
+
+	mov	$h2,$d1
+	shl	\$40,$d1
+	shr	\$24,$h2
+	add	$d1,$h1
+	adc	\$0,$h2			# can be partially reduced...
+
+	mov	\$-4,$d2		# ... so reduce
+	mov	$h2,$d1
+	and	$h2,$d2
+	shr	\$2,$d1
+	and	\$3,$h2
+	add	$d2,$d1			# =*5
+	add	$d1,$h0
+	adc	\$0,$h1
+	adc	\$0,$h2
+
+	mov	$s1,$r1
+	mov	$s1,%rax
+	shr	\$2,$s1
+	add	$r1,$s1			# s1 = r1 + (r1 >> 2)
+
+	add	0($inp),$h0		# accumulate input
+	adc	8($inp),$h1
+	lea	16($inp),$inp
+	adc	$padbit,$h2
+
+	call	__poly1305_block
+
+	test	$padbit,$padbit		# if $padbit is zero,
+	jz	.Lstore_base2_64_avx	# store hash in base 2^64 format
+
+	################################# base 2^64 -> base 2^26
+	mov	$h0,%rax
+	mov	$h0,%rdx
+	shr	\$52,$h0
+	mov	$h1,$r0
+	mov	$h1,$r1
+	shr	\$26,%rdx
+	and	\$0x3ffffff,%rax	# h[0]
+	shl	\$12,$r0
+	and	\$0x3ffffff,%rdx	# h[1]
+	shr	\$14,$h1
+	or	$r0,$h0
+	shl	\$24,$h2
+	and	\$0x3ffffff,$h0		# h[2]
+	shr	\$40,$r1
+	and	\$0x3ffffff,$h1		# h[3]
+	or	$r1,$h2			# h[4]
+
+	sub	\$16,%r15
+	jz	.Lstore_base2_26_avx
+
+	vmovd	%rax#d,$H0
+	vmovd	%rdx#d,$H1
+	vmovd	$h0#d,$H2
+	vmovd	$h1#d,$H3
+	vmovd	$h2#d,$H4
+	jmp	.Lproceed_avx
+
+.align	32
+.Lstore_base2_64_avx:
+	mov	$h0,0($ctx)
+	mov	$h1,8($ctx)
+	mov	$h2,16($ctx)		# note that is_base2_26 is zeroed
+	jmp	.Ldone_avx
+
+.align	16
+.Lstore_base2_26_avx:
+	mov	%rax#d,0($ctx)		# store hash value base 2^26
+	mov	%rdx#d,4($ctx)
+	mov	$h0#d,8($ctx)
+	mov	$h1#d,12($ctx)
+	mov	$h2#d,16($ctx)
+.align	16
+.Ldone_avx:
+	pop 		%r15
+.cfi_restore	%r15
+	pop 		%r14
+.cfi_restore	%r14
+	pop 		%r13
+.cfi_restore	%r13
+	pop 		%r12
+.cfi_restore	%r12
+	pop 		%rbx
+.cfi_restore	%rbx
+	pop 		%rbp
+.cfi_restore	%rbp
+.Lno_data_avx:
+.Lblocks_avx_epilogue:
+	ret
+.cfi_endproc
+
+.align	32
+.Lbase2_64_avx:
+.cfi_startproc
+	push	%rbp
+.cfi_push	%rbp
+	mov 	%rsp,%rbp
+	push	%rbx
+.cfi_push	%rbx
+	push	%r12
+.cfi_push	%r12
+	push	%r13
+.cfi_push	%r13
+	push	%r14
+.cfi_push	%r14
+	push	%r15
+.cfi_push	%r15
+.Lbase2_64_avx_body:
+
+	mov	$len,%r15		# reassign $len
+
+	mov	24($ctx),$r0		# load r
+	mov	32($ctx),$s1
+
+	mov	0($ctx),$h0		# load hash value
+	mov	8($ctx),$h1
+	mov	16($ctx),$h2#d
+
+	mov	$s1,$r1
+	mov	$s1,%rax
+	shr	\$2,$s1
+	add	$r1,$s1			# s1 = r1 + (r1 >> 2)
+
+	test	\$31,$len
+	jz	.Linit_avx
+
+	add	0($inp),$h0		# accumulate input
+	adc	8($inp),$h1
+	lea	16($inp),$inp
+	adc	$padbit,$h2
+	sub	\$16,%r15
+
+	call	__poly1305_block
+
+.Linit_avx:
+	################################# base 2^64 -> base 2^26
+	mov	$h0,%rax
+	mov	$h0,%rdx
+	shr	\$52,$h0
+	mov	$h1,$d1
+	mov	$h1,$d2
+	shr	\$26,%rdx
+	and	\$0x3ffffff,%rax	# h[0]
+	shl	\$12,$d1
+	and	\$0x3ffffff,%rdx	# h[1]
+	shr	\$14,$h1
+	or	$d1,$h0
+	shl	\$24,$h2
+	and	\$0x3ffffff,$h0		# h[2]
+	shr	\$40,$d2
+	and	\$0x3ffffff,$h1		# h[3]
+	or	$d2,$h2			# h[4]
+
+	vmovd	%rax#d,$H0
+	vmovd	%rdx#d,$H1
+	vmovd	$h0#d,$H2
+	vmovd	$h1#d,$H3
+	vmovd	$h2#d,$H4
+	movl	\$1,20($ctx)		# set is_base2_26
+
+	call	__poly1305_init_avx
+
+.Lproceed_avx:
+	mov	%r15,$len
+	pop 		%r15
+.cfi_restore	%r15
+	pop 		%r14
+.cfi_restore	%r14
+	pop 		%r13
+.cfi_restore	%r13
+	pop 		%r12
+.cfi_restore	%r12
+	pop 		%rbx
+.cfi_restore	%rbx
+	pop 		%rbp
+.cfi_restore	%rbp
+.Lbase2_64_avx_epilogue:
+	jmp	.Ldo_avx
+.cfi_endproc
+
+.align	32
+.Leven_avx:
+.cfi_startproc
+	vmovd		4*0($ctx),$H0		# load hash value
+	vmovd		4*1($ctx),$H1
+	vmovd		4*2($ctx),$H2
+	vmovd		4*3($ctx),$H3
+	vmovd		4*4($ctx),$H4
+
+.Ldo_avx:
+___
+$code.=<<___	if (!$win64);
+	lea		8(%rsp),%r10
+.cfi_def_cfa_register	%r10
+	and		\$-32,%rsp
+	sub		\$-8,%rsp
+	lea		-0x58(%rsp),%r11
+	sub		\$0x178,%rsp
+	
+___
+$code.=<<___	if ($win64);
+	lea		-0xf8(%rsp),%r11
+	sub		\$0x218,%rsp
+	vmovdqa		%xmm6,0x50(%r11)
+	vmovdqa		%xmm7,0x60(%r11)
+	vmovdqa		%xmm8,0x70(%r11)
+	vmovdqa		%xmm9,0x80(%r11)
+	vmovdqa		%xmm10,0x90(%r11)
+	vmovdqa		%xmm11,0xa0(%r11)
+	vmovdqa		%xmm12,0xb0(%r11)
+	vmovdqa		%xmm13,0xc0(%r11)
+	vmovdqa		%xmm14,0xd0(%r11)
+	vmovdqa		%xmm15,0xe0(%r11)
+.Ldo_avx_body:
+___
+$code.=<<___;
+	sub		\$64,$len
+	lea		-32($inp),%rax
+	cmovc		%rax,$inp
+
+	vmovdqu		`16*3`($ctx),$D4	# preload r0^2
+	lea		`16*3+64`($ctx),$ctx	# size optimization
+	lea		.Lconst(%rip),%rcx
+
+	################################################################
+	# load input
+	vmovdqu		16*2($inp),$T0
+	vmovdqu		16*3($inp),$T1
+	vmovdqa		64(%rcx),$MASK		# .Lmask26
+
+	vpsrldq		\$6,$T0,$T2		# splat input
+	vpsrldq		\$6,$T1,$T3
+	vpunpckhqdq	$T1,$T0,$T4		# 4
+	vpunpcklqdq	$T1,$T0,$T0		# 0:1
+	vpunpcklqdq	$T3,$T2,$T3		# 2:3
+
+	vpsrlq		\$40,$T4,$T4		# 4
+	vpsrlq		\$26,$T0,$T1
+	vpand		$MASK,$T0,$T0		# 0
+	vpsrlq		\$4,$T3,$T2
+	vpand		$MASK,$T1,$T1		# 1
+	vpsrlq		\$30,$T3,$T3
+	vpand		$MASK,$T2,$T2		# 2
+	vpand		$MASK,$T3,$T3		# 3
+	vpor		32(%rcx),$T4,$T4	# padbit, yes, always
+
+	jbe		.Lskip_loop_avx
+
+	# expand and copy pre-calculated table to stack
+	vmovdqu		`16*1-64`($ctx),$D1
+	vmovdqu		`16*2-64`($ctx),$D2
+	vpshufd		\$0xEE,$D4,$D3		# 34xx -> 3434
+	vpshufd		\$0x44,$D4,$D0		# xx12 -> 1212
+	vmovdqa		$D3,-0x90(%r11)
+	vmovdqa		$D0,0x00(%rsp)
+	vpshufd		\$0xEE,$D1,$D4
+	vmovdqu		`16*3-64`($ctx),$D0
+	vpshufd		\$0x44,$D1,$D1
+	vmovdqa		$D4,-0x80(%r11)
+	vmovdqa		$D1,0x10(%rsp)
+	vpshufd		\$0xEE,$D2,$D3
+	vmovdqu		`16*4-64`($ctx),$D1
+	vpshufd		\$0x44,$D2,$D2
+	vmovdqa		$D3,-0x70(%r11)
+	vmovdqa		$D2,0x20(%rsp)
+	vpshufd		\$0xEE,$D0,$D4
+	vmovdqu		`16*5-64`($ctx),$D2
+	vpshufd		\$0x44,$D0,$D0
+	vmovdqa		$D4,-0x60(%r11)
+	vmovdqa		$D0,0x30(%rsp)
+	vpshufd		\$0xEE,$D1,$D3
+	vmovdqu		`16*6-64`($ctx),$D0
+	vpshufd		\$0x44,$D1,$D1
+	vmovdqa		$D3,-0x50(%r11)
+	vmovdqa		$D1,0x40(%rsp)
+	vpshufd		\$0xEE,$D2,$D4
+	vmovdqu		`16*7-64`($ctx),$D1
+	vpshufd		\$0x44,$D2,$D2
+	vmovdqa		$D4,-0x40(%r11)
+	vmovdqa		$D2,0x50(%rsp)
+	vpshufd		\$0xEE,$D0,$D3
+	vmovdqu		`16*8-64`($ctx),$D2
+	vpshufd		\$0x44,$D0,$D0
+	vmovdqa		$D3,-0x30(%r11)
+	vmovdqa		$D0,0x60(%rsp)
+	vpshufd		\$0xEE,$D1,$D4
+	vpshufd		\$0x44,$D1,$D1
+	vmovdqa		$D4,-0x20(%r11)
+	vmovdqa		$D1,0x70(%rsp)
+	vpshufd		\$0xEE,$D2,$D3
+	 vmovdqa	0x00(%rsp),$D4		# preload r0^2
+	vpshufd		\$0x44,$D2,$D2
+	vmovdqa		$D3,-0x10(%r11)
+	vmovdqa		$D2,0x80(%rsp)
+
+	jmp		.Loop_avx
+
+.align	32
+.Loop_avx:
+	################################################################
+	# ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2
+	# ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^3+inp[7]*r
+	#   \___________________/
+	# ((inp[0]*r^4+inp[2]*r^2+inp[4])*r^4+inp[6]*r^2+inp[8])*r^2
+	# ((inp[1]*r^4+inp[3]*r^2+inp[5])*r^4+inp[7]*r^2+inp[9])*r
+	#   \___________________/ \____________________/
+	#
+	# Note that we start with inp[2:3]*r^2. This is because it
+	# doesn't depend on reduction in previous iteration.
+	################################################################
+	# d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	# d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	# d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+	#
+	# though note that $Tx and $Hx are "reversed" in this section,
+	# and $D4 is preloaded with r0^2...
+
+	vpmuludq	$T0,$D4,$D0		# d0 = h0*r0
+	vpmuludq	$T1,$D4,$D1		# d1 = h1*r0
+	  vmovdqa	$H2,0x20(%r11)				# offload hash
+	vpmuludq	$T2,$D4,$D2		# d3 = h2*r0
+	 vmovdqa	0x10(%rsp),$H2		# r1^2
+	vpmuludq	$T3,$D4,$D3		# d3 = h3*r0
+	vpmuludq	$T4,$D4,$D4		# d4 = h4*r0
+
+	  vmovdqa	$H0,0x00(%r11)				#
+	vpmuludq	0x20(%rsp),$T4,$H0	# h4*s1
+	  vmovdqa	$H1,0x10(%r11)				#
+	vpmuludq	$T3,$H2,$H1		# h3*r1
+	vpaddq		$H0,$D0,$D0		# d0 += h4*s1
+	vpaddq		$H1,$D4,$D4		# d4 += h3*r1
+	  vmovdqa	$H3,0x30(%r11)				#
+	vpmuludq	$T2,$H2,$H0		# h2*r1
+	vpmuludq	$T1,$H2,$H1		# h1*r1
+	vpaddq		$H0,$D3,$D3		# d3 += h2*r1
+	 vmovdqa	0x30(%rsp),$H3		# r2^2
+	vpaddq		$H1,$D2,$D2		# d2 += h1*r1
+	  vmovdqa	$H4,0x40(%r11)				#
+	vpmuludq	$T0,$H2,$H2		# h0*r1
+	 vpmuludq	$T2,$H3,$H0		# h2*r2
+	vpaddq		$H2,$D1,$D1		# d1 += h0*r1
+
+	 vmovdqa	0x40(%rsp),$H4		# s2^2
+	vpaddq		$H0,$D4,$D4		# d4 += h2*r2
+	vpmuludq	$T1,$H3,$H1		# h1*r2
+	vpmuludq	$T0,$H3,$H3		# h0*r2
+	vpaddq		$H1,$D3,$D3		# d3 += h1*r2
+	 vmovdqa	0x50(%rsp),$H2		# r3^2
+	vpaddq		$H3,$D2,$D2		# d2 += h0*r2
+	vpmuludq	$T4,$H4,$H0		# h4*s2
+	vpmuludq	$T3,$H4,$H4		# h3*s2
+	vpaddq		$H0,$D1,$D1		# d1 += h4*s2
+	 vmovdqa	0x60(%rsp),$H3		# s3^2
+	vpaddq		$H4,$D0,$D0		# d0 += h3*s2
+
+	 vmovdqa	0x80(%rsp),$H4		# s4^2
+	vpmuludq	$T1,$H2,$H1		# h1*r3
+	vpmuludq	$T0,$H2,$H2		# h0*r3
+	vpaddq		$H1,$D4,$D4		# d4 += h1*r3
+	vpaddq		$H2,$D3,$D3		# d3 += h0*r3
+	vpmuludq	$T4,$H3,$H0		# h4*s3
+	vpmuludq	$T3,$H3,$H1		# h3*s3
+	vpaddq		$H0,$D2,$D2		# d2 += h4*s3
+	 vmovdqu	16*0($inp),$H0				# load input
+	vpaddq		$H1,$D1,$D1		# d1 += h3*s3
+	vpmuludq	$T2,$H3,$H3		# h2*s3
+	 vpmuludq	$T2,$H4,$T2		# h2*s4
+	vpaddq		$H3,$D0,$D0		# d0 += h2*s3
+
+	 vmovdqu	16*1($inp),$H1				#
+	vpaddq		$T2,$D1,$D1		# d1 += h2*s4
+	vpmuludq	$T3,$H4,$T3		# h3*s4
+	vpmuludq	$T4,$H4,$T4		# h4*s4
+	 vpsrldq	\$6,$H0,$H2				# splat input
+	vpaddq		$T3,$D2,$D2		# d2 += h3*s4
+	vpaddq		$T4,$D3,$D3		# d3 += h4*s4
+	 vpsrldq	\$6,$H1,$H3				#
+	vpmuludq	0x70(%rsp),$T0,$T4	# h0*r4
+	vpmuludq	$T1,$H4,$T0		# h1*s4
+	 vpunpckhqdq	$H1,$H0,$H4		# 4
+	vpaddq		$T4,$D4,$D4		# d4 += h0*r4
+	 vmovdqa	-0x90(%r11),$T4		# r0^4
+	vpaddq		$T0,$D0,$D0		# d0 += h1*s4
+
+	vpunpcklqdq	$H1,$H0,$H0		# 0:1
+	vpunpcklqdq	$H3,$H2,$H3		# 2:3
+
+	#vpsrlq		\$40,$H4,$H4		# 4
+	vpsrldq		\$`40/8`,$H4,$H4	# 4
+	vpsrlq		\$26,$H0,$H1
+	vpand		$MASK,$H0,$H0		# 0
+	vpsrlq		\$4,$H3,$H2
+	vpand		$MASK,$H1,$H1		# 1
+	vpand		0(%rcx),$H4,$H4		# .Lmask24
+	vpsrlq		\$30,$H3,$H3
+	vpand		$MASK,$H2,$H2		# 2
+	vpand		$MASK,$H3,$H3		# 3
+	vpor		32(%rcx),$H4,$H4	# padbit, yes, always
+
+	vpaddq		0x00(%r11),$H0,$H0	# add hash value
+	vpaddq		0x10(%r11),$H1,$H1
+	vpaddq		0x20(%r11),$H2,$H2
+	vpaddq		0x30(%r11),$H3,$H3
+	vpaddq		0x40(%r11),$H4,$H4
+
+	lea		16*2($inp),%rax
+	lea		16*4($inp),$inp
+	sub		\$64,$len
+	cmovc		%rax,$inp
+
+	################################################################
+	# Now we accumulate (inp[0:1]+hash)*r^4
+	################################################################
+	# d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	# d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	# d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+
+	vpmuludq	$H0,$T4,$T0		# h0*r0
+	vpmuludq	$H1,$T4,$T1		# h1*r0
+	vpaddq		$T0,$D0,$D0
+	vpaddq		$T1,$D1,$D1
+	 vmovdqa	-0x80(%r11),$T2		# r1^4
+	vpmuludq	$H2,$T4,$T0		# h2*r0
+	vpmuludq	$H3,$T4,$T1		# h3*r0
+	vpaddq		$T0,$D2,$D2
+	vpaddq		$T1,$D3,$D3
+	vpmuludq	$H4,$T4,$T4		# h4*r0
+	 vpmuludq	-0x70(%r11),$H4,$T0	# h4*s1
+	vpaddq		$T4,$D4,$D4
+
+	vpaddq		$T0,$D0,$D0		# d0 += h4*s1
+	vpmuludq	$H2,$T2,$T1		# h2*r1
+	vpmuludq	$H3,$T2,$T0		# h3*r1
+	vpaddq		$T1,$D3,$D3		# d3 += h2*r1
+	 vmovdqa	-0x60(%r11),$T3		# r2^4
+	vpaddq		$T0,$D4,$D4		# d4 += h3*r1
+	vpmuludq	$H1,$T2,$T1		# h1*r1
+	vpmuludq	$H0,$T2,$T2		# h0*r1
+	vpaddq		$T1,$D2,$D2		# d2 += h1*r1
+	vpaddq		$T2,$D1,$D1		# d1 += h0*r1
+
+	 vmovdqa	-0x50(%r11),$T4		# s2^4
+	vpmuludq	$H2,$T3,$T0		# h2*r2
+	vpmuludq	$H1,$T3,$T1		# h1*r2
+	vpaddq		$T0,$D4,$D4		# d4 += h2*r2
+	vpaddq		$T1,$D3,$D3		# d3 += h1*r2
+	 vmovdqa	-0x40(%r11),$T2		# r3^4
+	vpmuludq	$H0,$T3,$T3		# h0*r2
+	vpmuludq	$H4,$T4,$T0		# h4*s2
+	vpaddq		$T3,$D2,$D2		# d2 += h0*r2
+	vpaddq		$T0,$D1,$D1		# d1 += h4*s2
+	 vmovdqa	-0x30(%r11),$T3		# s3^4
+	vpmuludq	$H3,$T4,$T4		# h3*s2
+	 vpmuludq	$H1,$T2,$T1		# h1*r3
+	vpaddq		$T4,$D0,$D0		# d0 += h3*s2
+
+	 vmovdqa	-0x10(%r11),$T4		# s4^4
+	vpaddq		$T1,$D4,$D4		# d4 += h1*r3
+	vpmuludq	$H0,$T2,$T2		# h0*r3
+	vpmuludq	$H4,$T3,$T0		# h4*s3
+	vpaddq		$T2,$D3,$D3		# d3 += h0*r3
+	vpaddq		$T0,$D2,$D2		# d2 += h4*s3
+	 vmovdqu	16*2($inp),$T0				# load input
+	vpmuludq	$H3,$T3,$T2		# h3*s3
+	vpmuludq	$H2,$T3,$T3		# h2*s3
+	vpaddq		$T2,$D1,$D1		# d1 += h3*s3
+	 vmovdqu	16*3($inp),$T1				#
+	vpaddq		$T3,$D0,$D0		# d0 += h2*s3
+
+	vpmuludq	$H2,$T4,$H2		# h2*s4
+	vpmuludq	$H3,$T4,$H3		# h3*s4
+	 vpsrldq	\$6,$T0,$T2				# splat input
+	vpaddq		$H2,$D1,$D1		# d1 += h2*s4
+	vpmuludq	$H4,$T4,$H4		# h4*s4
+	 vpsrldq	\$6,$T1,$T3				#
+	vpaddq		$H3,$D2,$H2		# h2 = d2 + h3*s4
+	vpaddq		$H4,$D3,$H3		# h3 = d3 + h4*s4
+	vpmuludq	-0x20(%r11),$H0,$H4	# h0*r4
+	vpmuludq	$H1,$T4,$H0
+	 vpunpckhqdq	$T1,$T0,$T4		# 4
+	vpaddq		$H4,$D4,$H4		# h4 = d4 + h0*r4
+	vpaddq		$H0,$D0,$H0		# h0 = d0 + h1*s4
+
+	vpunpcklqdq	$T1,$T0,$T0		# 0:1
+	vpunpcklqdq	$T3,$T2,$T3		# 2:3
+
+	#vpsrlq		\$40,$T4,$T4		# 4
+	vpsrldq		\$`40/8`,$T4,$T4	# 4
+	vpsrlq		\$26,$T0,$T1
+	 vmovdqa	0x00(%rsp),$D4		# preload r0^2
+	vpand		$MASK,$T0,$T0		# 0
+	vpsrlq		\$4,$T3,$T2
+	vpand		$MASK,$T1,$T1		# 1
+	vpand		0(%rcx),$T4,$T4		# .Lmask24
+	vpsrlq		\$30,$T3,$T3
+	vpand		$MASK,$T2,$T2		# 2
+	vpand		$MASK,$T3,$T3		# 3
+	vpor		32(%rcx),$T4,$T4	# padbit, yes, always
+
+	################################################################
+	# lazy reduction as discussed in "NEON crypto" by D.J. Bernstein
+	# and P. Schwabe
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$D1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H4,$D0
+	vpand		$MASK,$H4,$H4
+
+	vpsrlq		\$26,$H1,$D1
+	vpand		$MASK,$H1,$H1
+	vpaddq		$D1,$H2,$H2		# h1 -> h2
+
+	vpaddq		$D0,$H0,$H0
+	vpsllq		\$2,$D0,$D0
+	vpaddq		$D0,$H0,$H0		# h4 -> h0
+
+	vpsrlq		\$26,$H2,$D2
+	vpand		$MASK,$H2,$H2
+	vpaddq		$D2,$H3,$H3		# h2 -> h3
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	ja		.Loop_avx
+
+.Lskip_loop_avx:
+	################################################################
+	# multiply (inp[0:1]+hash) or inp[2:3] by r^2:r^1
+
+	vpshufd		\$0x10,$D4,$D4		# r0^n, xx12 -> x1x2
+	add		\$32,$len
+	jnz		.Long_tail_avx
+
+	vpaddq		$H2,$T2,$T2
+	vpaddq		$H0,$T0,$T0
+	vpaddq		$H1,$T1,$T1
+	vpaddq		$H3,$T3,$T3
+	vpaddq		$H4,$T4,$T4
+
+.Long_tail_avx:
+	vmovdqa		$H2,0x20(%r11)
+	vmovdqa		$H0,0x00(%r11)
+	vmovdqa		$H1,0x10(%r11)
+	vmovdqa		$H3,0x30(%r11)
+	vmovdqa		$H4,0x40(%r11)
+
+	# d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	# d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	# d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+
+	vpmuludq	$T2,$D4,$D2		# d2 = h2*r0
+	vpmuludq	$T0,$D4,$D0		# d0 = h0*r0
+	 vpshufd	\$0x10,`16*1-64`($ctx),$H2		# r1^n
+	vpmuludq	$T1,$D4,$D1		# d1 = h1*r0
+	vpmuludq	$T3,$D4,$D3		# d3 = h3*r0
+	vpmuludq	$T4,$D4,$D4		# d4 = h4*r0
+
+	vpmuludq	$T3,$H2,$H0		# h3*r1
+	vpaddq		$H0,$D4,$D4		# d4 += h3*r1
+	 vpshufd	\$0x10,`16*2-64`($ctx),$H3		# s1^n
+	vpmuludq	$T2,$H2,$H1		# h2*r1
+	vpaddq		$H1,$D3,$D3		# d3 += h2*r1
+	 vpshufd	\$0x10,`16*3-64`($ctx),$H4		# r2^n
+	vpmuludq	$T1,$H2,$H0		# h1*r1
+	vpaddq		$H0,$D2,$D2		# d2 += h1*r1
+	vpmuludq	$T0,$H2,$H2		# h0*r1
+	vpaddq		$H2,$D1,$D1		# d1 += h0*r1
+	vpmuludq	$T4,$H3,$H3		# h4*s1
+	vpaddq		$H3,$D0,$D0		# d0 += h4*s1
+
+	 vpshufd	\$0x10,`16*4-64`($ctx),$H2		# s2^n
+	vpmuludq	$T2,$H4,$H1		# h2*r2
+	vpaddq		$H1,$D4,$D4		# d4 += h2*r2
+	vpmuludq	$T1,$H4,$H0		# h1*r2
+	vpaddq		$H0,$D3,$D3		# d3 += h1*r2
+	 vpshufd	\$0x10,`16*5-64`($ctx),$H3		# r3^n
+	vpmuludq	$T0,$H4,$H4		# h0*r2
+	vpaddq		$H4,$D2,$D2		# d2 += h0*r2
+	vpmuludq	$T4,$H2,$H1		# h4*s2
+	vpaddq		$H1,$D1,$D1		# d1 += h4*s2
+	 vpshufd	\$0x10,`16*6-64`($ctx),$H4		# s3^n
+	vpmuludq	$T3,$H2,$H2		# h3*s2
+	vpaddq		$H2,$D0,$D0		# d0 += h3*s2
+
+	vpmuludq	$T1,$H3,$H0		# h1*r3
+	vpaddq		$H0,$D4,$D4		# d4 += h1*r3
+	vpmuludq	$T0,$H3,$H3		# h0*r3
+	vpaddq		$H3,$D3,$D3		# d3 += h0*r3
+	 vpshufd	\$0x10,`16*7-64`($ctx),$H2		# r4^n
+	vpmuludq	$T4,$H4,$H1		# h4*s3
+	vpaddq		$H1,$D2,$D2		# d2 += h4*s3
+	 vpshufd	\$0x10,`16*8-64`($ctx),$H3		# s4^n
+	vpmuludq	$T3,$H4,$H0		# h3*s3
+	vpaddq		$H0,$D1,$D1		# d1 += h3*s3
+	vpmuludq	$T2,$H4,$H4		# h2*s3
+	vpaddq		$H4,$D0,$D0		# d0 += h2*s3
+
+	vpmuludq	$T0,$H2,$H2		# h0*r4
+	vpaddq		$H2,$D4,$D4		# h4 = d4 + h0*r4
+	vpmuludq	$T4,$H3,$H1		# h4*s4
+	vpaddq		$H1,$D3,$D3		# h3 = d3 + h4*s4
+	vpmuludq	$T3,$H3,$H0		# h3*s4
+	vpaddq		$H0,$D2,$D2		# h2 = d2 + h3*s4
+	vpmuludq	$T2,$H3,$H1		# h2*s4
+	vpaddq		$H1,$D1,$D1		# h1 = d1 + h2*s4
+	vpmuludq	$T1,$H3,$H3		# h1*s4
+	vpaddq		$H3,$D0,$D0		# h0 = d0 + h1*s4
+
+	jz		.Lshort_tail_avx
+
+	vmovdqu		16*0($inp),$H0		# load input
+	vmovdqu		16*1($inp),$H1
+
+	vpsrldq		\$6,$H0,$H2		# splat input
+	vpsrldq		\$6,$H1,$H3
+	vpunpckhqdq	$H1,$H0,$H4		# 4
+	vpunpcklqdq	$H1,$H0,$H0		# 0:1
+	vpunpcklqdq	$H3,$H2,$H3		# 2:3
+
+	vpsrlq		\$40,$H4,$H4		# 4
+	vpsrlq		\$26,$H0,$H1
+	vpand		$MASK,$H0,$H0		# 0
+	vpsrlq		\$4,$H3,$H2
+	vpand		$MASK,$H1,$H1		# 1
+	vpsrlq		\$30,$H3,$H3
+	vpand		$MASK,$H2,$H2		# 2
+	vpand		$MASK,$H3,$H3		# 3
+	vpor		32(%rcx),$H4,$H4	# padbit, yes, always
+
+	vpshufd		\$0x32,`16*0-64`($ctx),$T4	# r0^n, 34xx -> x3x4
+	vpaddq		0x00(%r11),$H0,$H0
+	vpaddq		0x10(%r11),$H1,$H1
+	vpaddq		0x20(%r11),$H2,$H2
+	vpaddq		0x30(%r11),$H3,$H3
+	vpaddq		0x40(%r11),$H4,$H4
+
+	################################################################
+	# multiply (inp[0:1]+hash) by r^4:r^3 and accumulate
+
+	vpmuludq	$H0,$T4,$T0		# h0*r0
+	vpaddq		$T0,$D0,$D0		# d0 += h0*r0
+	vpmuludq	$H1,$T4,$T1		# h1*r0
+	vpaddq		$T1,$D1,$D1		# d1 += h1*r0
+	vpmuludq	$H2,$T4,$T0		# h2*r0
+	vpaddq		$T0,$D2,$D2		# d2 += h2*r0
+	 vpshufd	\$0x32,`16*1-64`($ctx),$T2		# r1^n
+	vpmuludq	$H3,$T4,$T1		# h3*r0
+	vpaddq		$T1,$D3,$D3		# d3 += h3*r0
+	vpmuludq	$H4,$T4,$T4		# h4*r0
+	vpaddq		$T4,$D4,$D4		# d4 += h4*r0
+
+	vpmuludq	$H3,$T2,$T0		# h3*r1
+	vpaddq		$T0,$D4,$D4		# d4 += h3*r1
+	 vpshufd	\$0x32,`16*2-64`($ctx),$T3		# s1
+	vpmuludq	$H2,$T2,$T1		# h2*r1
+	vpaddq		$T1,$D3,$D3		# d3 += h2*r1
+	 vpshufd	\$0x32,`16*3-64`($ctx),$T4		# r2
+	vpmuludq	$H1,$T2,$T0		# h1*r1
+	vpaddq		$T0,$D2,$D2		# d2 += h1*r1
+	vpmuludq	$H0,$T2,$T2		# h0*r1
+	vpaddq		$T2,$D1,$D1		# d1 += h0*r1
+	vpmuludq	$H4,$T3,$T3		# h4*s1
+	vpaddq		$T3,$D0,$D0		# d0 += h4*s1
+
+	 vpshufd	\$0x32,`16*4-64`($ctx),$T2		# s2
+	vpmuludq	$H2,$T4,$T1		# h2*r2
+	vpaddq		$T1,$D4,$D4		# d4 += h2*r2
+	vpmuludq	$H1,$T4,$T0		# h1*r2
+	vpaddq		$T0,$D3,$D3		# d3 += h1*r2
+	 vpshufd	\$0x32,`16*5-64`($ctx),$T3		# r3
+	vpmuludq	$H0,$T4,$T4		# h0*r2
+	vpaddq		$T4,$D2,$D2		# d2 += h0*r2
+	vpmuludq	$H4,$T2,$T1		# h4*s2
+	vpaddq		$T1,$D1,$D1		# d1 += h4*s2
+	 vpshufd	\$0x32,`16*6-64`($ctx),$T4		# s3
+	vpmuludq	$H3,$T2,$T2		# h3*s2
+	vpaddq		$T2,$D0,$D0		# d0 += h3*s2
+
+	vpmuludq	$H1,$T3,$T0		# h1*r3
+	vpaddq		$T0,$D4,$D4		# d4 += h1*r3
+	vpmuludq	$H0,$T3,$T3		# h0*r3
+	vpaddq		$T3,$D3,$D3		# d3 += h0*r3
+	 vpshufd	\$0x32,`16*7-64`($ctx),$T2		# r4
+	vpmuludq	$H4,$T4,$T1		# h4*s3
+	vpaddq		$T1,$D2,$D2		# d2 += h4*s3
+	 vpshufd	\$0x32,`16*8-64`($ctx),$T3		# s4
+	vpmuludq	$H3,$T4,$T0		# h3*s3
+	vpaddq		$T0,$D1,$D1		# d1 += h3*s3
+	vpmuludq	$H2,$T4,$T4		# h2*s3
+	vpaddq		$T4,$D0,$D0		# d0 += h2*s3
+
+	vpmuludq	$H0,$T2,$T2		# h0*r4
+	vpaddq		$T2,$D4,$D4		# d4 += h0*r4
+	vpmuludq	$H4,$T3,$T1		# h4*s4
+	vpaddq		$T1,$D3,$D3		# d3 += h4*s4
+	vpmuludq	$H3,$T3,$T0		# h3*s4
+	vpaddq		$T0,$D2,$D2		# d2 += h3*s4
+	vpmuludq	$H2,$T3,$T1		# h2*s4
+	vpaddq		$T1,$D1,$D1		# d1 += h2*s4
+	vpmuludq	$H1,$T3,$T3		# h1*s4
+	vpaddq		$T3,$D0,$D0		# d0 += h1*s4
+
+.Lshort_tail_avx:
+	################################################################
+	# horizontal addition
+
+	vpsrldq		\$8,$D4,$T4
+	vpsrldq		\$8,$D3,$T3
+	vpsrldq		\$8,$D1,$T1
+	vpsrldq		\$8,$D0,$T0
+	vpsrldq		\$8,$D2,$T2
+	vpaddq		$T3,$D3,$D3
+	vpaddq		$T4,$D4,$D4
+	vpaddq		$T0,$D0,$D0
+	vpaddq		$T1,$D1,$D1
+	vpaddq		$T2,$D2,$D2
+
+	################################################################
+	# lazy reduction
+
+	vpsrlq		\$26,$D3,$H3
+	vpand		$MASK,$D3,$D3
+	vpaddq		$H3,$D4,$D4		# h3 -> h4
+
+	vpsrlq		\$26,$D0,$H0
+	vpand		$MASK,$D0,$D0
+	vpaddq		$H0,$D1,$D1		# h0 -> h1
+
+	vpsrlq		\$26,$D4,$H4
+	vpand		$MASK,$D4,$D4
+
+	vpsrlq		\$26,$D1,$H1
+	vpand		$MASK,$D1,$D1
+	vpaddq		$H1,$D2,$D2		# h1 -> h2
+
+	vpaddq		$H4,$D0,$D0
+	vpsllq		\$2,$H4,$H4
+	vpaddq		$H4,$D0,$D0		# h4 -> h0
+
+	vpsrlq		\$26,$D2,$H2
+	vpand		$MASK,$D2,$D2
+	vpaddq		$H2,$D3,$D3		# h2 -> h3
+
+	vpsrlq		\$26,$D0,$H0
+	vpand		$MASK,$D0,$D0
+	vpaddq		$H0,$D1,$D1		# h0 -> h1
+
+	vpsrlq		\$26,$D3,$H3
+	vpand		$MASK,$D3,$D3
+	vpaddq		$H3,$D4,$D4		# h3 -> h4
+
+	vmovd		$D0,`4*0-48-64`($ctx)	# save partially reduced
+	vmovd		$D1,`4*1-48-64`($ctx)
+	vmovd		$D2,`4*2-48-64`($ctx)
+	vmovd		$D3,`4*3-48-64`($ctx)
+	vmovd		$D4,`4*4-48-64`($ctx)
+___
+$code.=<<___	if ($win64);
+	vmovdqa		0x50(%r11),%xmm6
+	vmovdqa		0x60(%r11),%xmm7
+	vmovdqa		0x70(%r11),%xmm8
+	vmovdqa		0x80(%r11),%xmm9
+	vmovdqa		0x90(%r11),%xmm10
+	vmovdqa		0xa0(%r11),%xmm11
+	vmovdqa		0xb0(%r11),%xmm12
+	vmovdqa		0xc0(%r11),%xmm13
+	vmovdqa		0xd0(%r11),%xmm14
+	vmovdqa		0xe0(%r11),%xmm15
+	lea		0xf8(%r11),%rsp
+.Ldo_avx_epilogue:
+___
+$code.=<<___	if (!$win64);
+	lea		-8(%r10),%rsp
+.cfi_def_cfa_register	%rsp
+___
+$code.=<<___;
+	vzeroupper
+	ret
+.cfi_endproc
+___
+&end_function("poly1305_blocks_avx");
+
+&declare_function("poly1305_emit_avx", 32, 3);
+$code.=<<___;
+	cmpl	\$0,20($ctx)	# is_base2_26?
+	je	.Lemit
+
+	mov	0($ctx),%eax	# load hash value base 2^26
+	mov	4($ctx),%ecx
+	mov	8($ctx),%r8d
+	mov	12($ctx),%r11d
+	mov	16($ctx),%r10d
+
+	shl	\$26,%rcx	# base 2^26 -> base 2^64
+	mov	%r8,%r9
+	shl	\$52,%r8
+	add	%rcx,%rax
+	shr	\$12,%r9
+	add	%rax,%r8	# h0
+	adc	\$0,%r9
+
+	shl	\$14,%r11
+	mov	%r10,%rax
+	shr	\$24,%r10
+	add	%r11,%r9
+	shl	\$40,%rax
+	add	%rax,%r9	# h1
+	adc	\$0,%r10	# h2
+
+	mov	%r10,%rax	# could be partially reduced, so reduce
+	mov	%r10,%rcx
+	and	\$3,%r10
+	shr	\$2,%rax
+	and	\$-4,%rcx
+	add	%rcx,%rax
+	add	%rax,%r8
+	adc	\$0,%r9
+	adc	\$0,%r10
+
+	mov	%r8,%rax
+	add	\$5,%r8		# compare to modulus
+	mov	%r9,%rcx
+	adc	\$0,%r9
+	adc	\$0,%r10
+	shr	\$2,%r10	# did 130-bit value overflow?
+	cmovnz	%r8,%rax
+	cmovnz	%r9,%rcx
+
+	add	0($nonce),%rax	# accumulate nonce
+	adc	8($nonce),%rcx
+	mov	%rax,0($mac)	# write result
+	mov	%rcx,8($mac)
+
+	ret
+___
+&end_function("poly1305_emit_avx");
+
+if ($kernel) {
+	$code .= "#endif\n";
+}
+
+if ($avx>1) {
+
+if ($kernel) {
+	$code .= "#ifdef CONFIG_AS_AVX2\n";
+}
+
+my ($H0,$H1,$H2,$H3,$H4, $MASK, $T4,$T0,$T1,$T2,$T3, $D0,$D1,$D2,$D3,$D4) =
+    map("%ymm$_",(0..15));
+my $S4=$MASK;
+
+sub poly1305_blocks_avxN {
+	my ($avx512) = @_;
+	my $suffix = $avx512 ? "_avx512" : "";
+$code.=<<___;
+.cfi_startproc
+	mov	20($ctx),%r8d		# is_base2_26
+	cmp	\$128,$len
+	jae	.Lblocks_avx2$suffix
+	test	%r8d,%r8d
+	jz	.Lblocks
+
+.Lblocks_avx2$suffix:
+	and	\$-16,$len
+	jz	.Lno_data_avx2$suffix
+
+	vzeroupper
+
+	test	%r8d,%r8d
+	jz	.Lbase2_64_avx2$suffix
+
+	test	\$63,$len
+	jz	.Leven_avx2$suffix
+
+	push	%rbp
+.cfi_push	%rbp
+	mov 	%rsp,%rbp
+	push	%rbx
+.cfi_push	%rbx
+	push	%r12
+.cfi_push	%r12
+	push	%r13
+.cfi_push	%r13
+	push	%r14
+.cfi_push	%r14
+	push	%r15
+.cfi_push	%r15
+.Lblocks_avx2_body$suffix:
+
+	mov	$len,%r15		# reassign $len
+
+	mov	0($ctx),$d1		# load hash value
+	mov	8($ctx),$d2
+	mov	16($ctx),$h2#d
+
+	mov	24($ctx),$r0		# load r
+	mov	32($ctx),$s1
+
+	################################# base 2^26 -> base 2^64
+	mov	$d1#d,$h0#d
+	and	\$`-1*(1<<31)`,$d1
+	mov	$d2,$r1			# borrow $r1
+	mov	$d2#d,$h1#d
+	and	\$`-1*(1<<31)`,$d2
+
+	shr	\$6,$d1
+	shl	\$52,$r1
+	add	$d1,$h0
+	shr	\$12,$h1
+	shr	\$18,$d2
+	add	$r1,$h0
+	adc	$d2,$h1
+
+	mov	$h2,$d1
+	shl	\$40,$d1
+	shr	\$24,$h2
+	add	$d1,$h1
+	adc	\$0,$h2			# can be partially reduced...
+
+	mov	\$-4,$d2		# ... so reduce
+	mov	$h2,$d1
+	and	$h2,$d2
+	shr	\$2,$d1
+	and	\$3,$h2
+	add	$d2,$d1			# =*5
+	add	$d1,$h0
+	adc	\$0,$h1
+	adc	\$0,$h2
+
+	mov	$s1,$r1
+	mov	$s1,%rax
+	shr	\$2,$s1
+	add	$r1,$s1			# s1 = r1 + (r1 >> 2)
+
+.Lbase2_26_pre_avx2$suffix:
+	add	0($inp),$h0		# accumulate input
+	adc	8($inp),$h1
+	lea	16($inp),$inp
+	adc	$padbit,$h2
+	sub	\$16,%r15
+
+	call	__poly1305_block
+	mov	$r1,%rax
+
+	test	\$63,%r15
+	jnz	.Lbase2_26_pre_avx2$suffix
+
+	test	$padbit,$padbit		# if $padbit is zero,
+	jz	.Lstore_base2_64_avx2$suffix	# store hash in base 2^64 format
+
+	################################# base 2^64 -> base 2^26
+	mov	$h0,%rax
+	mov	$h0,%rdx
+	shr	\$52,$h0
+	mov	$h1,$r0
+	mov	$h1,$r1
+	shr	\$26,%rdx
+	and	\$0x3ffffff,%rax	# h[0]
+	shl	\$12,$r0
+	and	\$0x3ffffff,%rdx	# h[1]
+	shr	\$14,$h1
+	or	$r0,$h0
+	shl	\$24,$h2
+	and	\$0x3ffffff,$h0		# h[2]
+	shr	\$40,$r1
+	and	\$0x3ffffff,$h1		# h[3]
+	or	$r1,$h2			# h[4]
+
+	test	%r15,%r15
+	jz	.Lstore_base2_26_avx2$suffix
+
+	vmovd	%rax#d,%x#$H0
+	vmovd	%rdx#d,%x#$H1
+	vmovd	$h0#d,%x#$H2
+	vmovd	$h1#d,%x#$H3
+	vmovd	$h2#d,%x#$H4
+	jmp	.Lproceed_avx2$suffix
+
+.align	32
+.Lstore_base2_64_avx2$suffix:
+	mov	$h0,0($ctx)
+	mov	$h1,8($ctx)
+	mov	$h2,16($ctx)		# note that is_base2_26 is zeroed
+	jmp	.Ldone_avx2$suffix
+
+.align	16
+.Lstore_base2_26_avx2$suffix:
+	mov	%rax#d,0($ctx)		# store hash value base 2^26
+	mov	%rdx#d,4($ctx)
+	mov	$h0#d,8($ctx)
+	mov	$h1#d,12($ctx)
+	mov	$h2#d,16($ctx)
+.align	16
+.Ldone_avx2$suffix:
+	pop 		%r15
+.cfi_restore	%r15
+	pop 		%r14
+.cfi_restore	%r14
+	pop 		%r13
+.cfi_restore	%r13
+	pop 		%r12
+.cfi_restore	%r12
+	pop 		%rbx
+.cfi_restore	%rbx
+	pop 		%rbp
+.cfi_restore 	%rbp
+.Lno_data_avx2$suffix:
+.Lblocks_avx2_epilogue$suffix:
+	ret
+.cfi_endproc
+
+.align	32
+.Lbase2_64_avx2$suffix:
+.cfi_startproc
+	push	%rbp
+.cfi_push	%rbp
+	mov 	%rsp,%rbp
+	push	%rbx
+.cfi_push	%rbx
+	push	%r12
+.cfi_push	%r12
+	push	%r13
+.cfi_push	%r13
+	push	%r14
+.cfi_push	%r14
+	push	%r15
+.cfi_push	%r15
+.Lbase2_64_avx2_body$suffix:
+
+	mov	$len,%r15		# reassign $len
+
+	mov	24($ctx),$r0		# load r
+	mov	32($ctx),$s1
+
+	mov	0($ctx),$h0		# load hash value
+	mov	8($ctx),$h1
+	mov	16($ctx),$h2#d
+
+	mov	$s1,$r1
+	mov	$s1,%rax
+	shr	\$2,$s1
+	add	$r1,$s1			# s1 = r1 + (r1 >> 2)
+
+	test	\$63,$len
+	jz	.Linit_avx2$suffix
+
+.Lbase2_64_pre_avx2$suffix:
+	add	0($inp),$h0		# accumulate input
+	adc	8($inp),$h1
+	lea	16($inp),$inp
+	adc	$padbit,$h2
+	sub	\$16,%r15
+
+	call	__poly1305_block
+	mov	$r1,%rax
+
+	test	\$63,%r15
+	jnz	.Lbase2_64_pre_avx2$suffix
+
+.Linit_avx2$suffix:
+	################################# base 2^64 -> base 2^26
+	mov	$h0,%rax
+	mov	$h0,%rdx
+	shr	\$52,$h0
+	mov	$h1,$d1
+	mov	$h1,$d2
+	shr	\$26,%rdx
+	and	\$0x3ffffff,%rax	# h[0]
+	shl	\$12,$d1
+	and	\$0x3ffffff,%rdx	# h[1]
+	shr	\$14,$h1
+	or	$d1,$h0
+	shl	\$24,$h2
+	and	\$0x3ffffff,$h0		# h[2]
+	shr	\$40,$d2
+	and	\$0x3ffffff,$h1		# h[3]
+	or	$d2,$h2			# h[4]
+
+	vmovd	%rax#d,%x#$H0
+	vmovd	%rdx#d,%x#$H1
+	vmovd	$h0#d,%x#$H2
+	vmovd	$h1#d,%x#$H3
+	vmovd	$h2#d,%x#$H4
+	movl	\$1,20($ctx)		# set is_base2_26
+
+	call	__poly1305_init_avx
+
+.Lproceed_avx2$suffix:
+	mov	%r15,$len			# restore $len
+___
+$code.=<<___ if (!$kernel);
+	mov	OPENSSL_ia32cap_P+8(%rip),%r9d
+	mov	\$`(1<<31|1<<30|1<<16)`,%r11d
+___
+$code.=<<___;
+	pop 		%r15
+.cfi_restore	%r15
+	pop 		%r14
+.cfi_restore	%r14
+	pop 		%r13
+.cfi_restore	%r13
+	pop 		%r12
+.cfi_restore	%r12
+	pop 		%rbx
+.cfi_restore	%rbx
+	pop 		%rbp
+.cfi_restore 	%rbp
+.Lbase2_64_avx2_epilogue$suffix:
+	jmp	.Ldo_avx2$suffix
+.cfi_endproc
+
+.align	32
+.Leven_avx2$suffix:
+.cfi_startproc
+___
+$code.=<<___ if (!$kernel);
+	mov		OPENSSL_ia32cap_P+8(%rip),%r9d
+___
+$code.=<<___;
+	vmovd		4*0($ctx),%x#$H0	# load hash value base 2^26
+	vmovd		4*1($ctx),%x#$H1
+	vmovd		4*2($ctx),%x#$H2
+	vmovd		4*3($ctx),%x#$H3
+	vmovd		4*4($ctx),%x#$H4
+
+.Ldo_avx2$suffix:
+___
+$code.=<<___		if (!$kernel && $avx>2);
+	cmp		\$512,$len
+	jb		.Lskip_avx512
+	and		%r11d,%r9d
+	test		\$`1<<16`,%r9d		# check for AVX512F
+	jnz		.Lblocks_avx512
+.Lskip_avx512$suffix:
+___
+$code.=<<___ if ($avx > 2 && $avx512 && $kernel);
+	cmp		\$512,$len
+	jae		.Lblocks_avx512
+___
+$code.=<<___	if (!$win64);
+	lea		8(%rsp),%r10
+.cfi_def_cfa_register	%r10
+	sub		\$0x128,%rsp
+___
+$code.=<<___	if ($win64);
+	lea		8(%rsp),%r10
+	sub		\$0x1c8,%rsp
+	vmovdqa		%xmm6,-0xb0(%r10)
+	vmovdqa		%xmm7,-0xa0(%r10)
+	vmovdqa		%xmm8,-0x90(%r10)
+	vmovdqa		%xmm9,-0x80(%r10)
+	vmovdqa		%xmm10,-0x70(%r10)
+	vmovdqa		%xmm11,-0x60(%r10)
+	vmovdqa		%xmm12,-0x50(%r10)
+	vmovdqa		%xmm13,-0x40(%r10)
+	vmovdqa		%xmm14,-0x30(%r10)
+	vmovdqa		%xmm15,-0x20(%r10)
+.Ldo_avx2_body$suffix:
+___
+$code.=<<___;
+	lea		.Lconst(%rip),%rcx
+	lea		48+64($ctx),$ctx	# size optimization
+	vmovdqa		96(%rcx),$T0		# .Lpermd_avx2
+
+	# expand and copy pre-calculated table to stack
+	vmovdqu		`16*0-64`($ctx),%x#$T2
+	and		\$-512,%rsp
+	vmovdqu		`16*1-64`($ctx),%x#$T3
+	vmovdqu		`16*2-64`($ctx),%x#$T4
+	vmovdqu		`16*3-64`($ctx),%x#$D0
+	vmovdqu		`16*4-64`($ctx),%x#$D1
+	vmovdqu		`16*5-64`($ctx),%x#$D2
+	lea		0x90(%rsp),%rax		# size optimization
+	vmovdqu		`16*6-64`($ctx),%x#$D3
+	vpermd		$T2,$T0,$T2		# 00003412 -> 14243444
+	vmovdqu		`16*7-64`($ctx),%x#$D4
+	vpermd		$T3,$T0,$T3
+	vmovdqu		`16*8-64`($ctx),%x#$MASK
+	vpermd		$T4,$T0,$T4
+	vmovdqa		$T2,0x00(%rsp)
+	vpermd		$D0,$T0,$D0
+	vmovdqa		$T3,0x20-0x90(%rax)
+	vpermd		$D1,$T0,$D1
+	vmovdqa		$T4,0x40-0x90(%rax)
+	vpermd		$D2,$T0,$D2
+	vmovdqa		$D0,0x60-0x90(%rax)
+	vpermd		$D3,$T0,$D3
+	vmovdqa		$D1,0x80-0x90(%rax)
+	vpermd		$D4,$T0,$D4
+	vmovdqa		$D2,0xa0-0x90(%rax)
+	vpermd		$MASK,$T0,$MASK
+	vmovdqa		$D3,0xc0-0x90(%rax)
+	vmovdqa		$D4,0xe0-0x90(%rax)
+	vmovdqa		$MASK,0x100-0x90(%rax)
+	vmovdqa		64(%rcx),$MASK		# .Lmask26
+
+	################################################################
+	# load input
+	vmovdqu		16*0($inp),%x#$T0
+	vmovdqu		16*1($inp),%x#$T1
+	vinserti128	\$1,16*2($inp),$T0,$T0
+	vinserti128	\$1,16*3($inp),$T1,$T1
+	lea		16*4($inp),$inp
+
+	vpsrldq		\$6,$T0,$T2		# splat input
+	vpsrldq		\$6,$T1,$T3
+	vpunpckhqdq	$T1,$T0,$T4		# 4
+	vpunpcklqdq	$T3,$T2,$T2		# 2:3
+	vpunpcklqdq	$T1,$T0,$T0		# 0:1
+
+	vpsrlq		\$30,$T2,$T3
+	vpsrlq		\$4,$T2,$T2
+	vpsrlq		\$26,$T0,$T1
+	vpsrlq		\$40,$T4,$T4		# 4
+	vpand		$MASK,$T2,$T2		# 2
+	vpand		$MASK,$T0,$T0		# 0
+	vpand		$MASK,$T1,$T1		# 1
+	vpand		$MASK,$T3,$T3		# 3
+	vpor		32(%rcx),$T4,$T4	# padbit, yes, always
+
+	vpaddq		$H2,$T2,$H2		# accumulate input
+	sub		\$64,$len
+	jz		.Ltail_avx2$suffix
+	jmp		.Loop_avx2$suffix
+
+.align	32
+.Loop_avx2$suffix:
+	################################################################
+	# ((inp[0]*r^4+inp[4])*r^4+inp[ 8])*r^4
+	# ((inp[1]*r^4+inp[5])*r^4+inp[ 9])*r^3
+	# ((inp[2]*r^4+inp[6])*r^4+inp[10])*r^2
+	# ((inp[3]*r^4+inp[7])*r^4+inp[11])*r^1
+	#   \________/\__________/
+	################################################################
+	#vpaddq		$H2,$T2,$H2		# accumulate input
+	vpaddq		$H0,$T0,$H0
+	vmovdqa		`32*0`(%rsp),$T0	# r0^4
+	vpaddq		$H1,$T1,$H1
+	vmovdqa		`32*1`(%rsp),$T1	# r1^4
+	vpaddq		$H3,$T3,$H3
+	vmovdqa		`32*3`(%rsp),$T2	# r2^4
+	vpaddq		$H4,$T4,$H4
+	vmovdqa		`32*6-0x90`(%rax),$T3	# s3^4
+	vmovdqa		`32*8-0x90`(%rax),$S4	# s4^4
+
+	# d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	# d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	# d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+	#
+	# however, as h2 is "chronologically" first one available pull
+	# corresponding operations up, so it's
+	#
+	# d4 = h2*r2   + h4*r0 + h3*r1             + h1*r3   + h0*r4
+	# d3 = h2*r1   + h3*r0           + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0           + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h2*5*r4 + h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3
+	# d0 = h2*5*r3 + h0*r0 + h4*5*r1 + h3*5*r2           + h1*5*r4
+
+	vpmuludq	$H2,$T0,$D2		# d2 = h2*r0
+	vpmuludq	$H2,$T1,$D3		# d3 = h2*r1
+	vpmuludq	$H2,$T2,$D4		# d4 = h2*r2
+	vpmuludq	$H2,$T3,$D0		# d0 = h2*s3
+	vpmuludq	$H2,$S4,$D1		# d1 = h2*s4
+
+	vpmuludq	$H0,$T1,$T4		# h0*r1
+	vpmuludq	$H1,$T1,$H2		# h1*r1, borrow $H2 as temp
+	vpaddq		$T4,$D1,$D1		# d1 += h0*r1
+	vpaddq		$H2,$D2,$D2		# d2 += h1*r1
+	vpmuludq	$H3,$T1,$T4		# h3*r1
+	vpmuludq	`32*2`(%rsp),$H4,$H2	# h4*s1
+	vpaddq		$T4,$D4,$D4		# d4 += h3*r1
+	vpaddq		$H2,$D0,$D0		# d0 += h4*s1
+	 vmovdqa	`32*4-0x90`(%rax),$T1	# s2
+
+	vpmuludq	$H0,$T0,$T4		# h0*r0
+	vpmuludq	$H1,$T0,$H2		# h1*r0
+	vpaddq		$T4,$D0,$D0		# d0 += h0*r0
+	vpaddq		$H2,$D1,$D1		# d1 += h1*r0
+	vpmuludq	$H3,$T0,$T4		# h3*r0
+	vpmuludq	$H4,$T0,$H2		# h4*r0
+	 vmovdqu	16*0($inp),%x#$T0	# load input
+	vpaddq		$T4,$D3,$D3		# d3 += h3*r0
+	vpaddq		$H2,$D4,$D4		# d4 += h4*r0
+	 vinserti128	\$1,16*2($inp),$T0,$T0
+
+	vpmuludq	$H3,$T1,$T4		# h3*s2
+	vpmuludq	$H4,$T1,$H2		# h4*s2
+	 vmovdqu	16*1($inp),%x#$T1
+	vpaddq		$T4,$D0,$D0		# d0 += h3*s2
+	vpaddq		$H2,$D1,$D1		# d1 += h4*s2
+	 vmovdqa	`32*5-0x90`(%rax),$H2	# r3
+	vpmuludq	$H1,$T2,$T4		# h1*r2
+	vpmuludq	$H0,$T2,$T2		# h0*r2
+	vpaddq		$T4,$D3,$D3		# d3 += h1*r2
+	vpaddq		$T2,$D2,$D2		# d2 += h0*r2
+	 vinserti128	\$1,16*3($inp),$T1,$T1
+	 lea		16*4($inp),$inp
+
+	vpmuludq	$H1,$H2,$T4		# h1*r3
+	vpmuludq	$H0,$H2,$H2		# h0*r3
+	 vpsrldq	\$6,$T0,$T2		# splat input
+	vpaddq		$T4,$D4,$D4		# d4 += h1*r3
+	vpaddq		$H2,$D3,$D3		# d3 += h0*r3
+	vpmuludq	$H3,$T3,$T4		# h3*s3
+	vpmuludq	$H4,$T3,$H2		# h4*s3
+	 vpsrldq	\$6,$T1,$T3
+	vpaddq		$T4,$D1,$D1		# d1 += h3*s3
+	vpaddq		$H2,$D2,$D2		# d2 += h4*s3
+	 vpunpckhqdq	$T1,$T0,$T4		# 4
+
+	vpmuludq	$H3,$S4,$H3		# h3*s4
+	vpmuludq	$H4,$S4,$H4		# h4*s4
+	 vpunpcklqdq	$T1,$T0,$T0		# 0:1
+	vpaddq		$H3,$D2,$H2		# h2 = d2 + h3*r4
+	vpaddq		$H4,$D3,$H3		# h3 = d3 + h4*r4
+	 vpunpcklqdq	$T3,$T2,$T3		# 2:3
+	vpmuludq	`32*7-0x90`(%rax),$H0,$H4	# h0*r4
+	vpmuludq	$H1,$S4,$H0		# h1*s4
+	vmovdqa		64(%rcx),$MASK		# .Lmask26
+	vpaddq		$H4,$D4,$H4		# h4 = d4 + h0*r4
+	vpaddq		$H0,$D0,$H0		# h0 = d0 + h1*s4
+
+	################################################################
+	# lazy reduction (interleaved with tail of input splat)
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$D1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H4,$D4
+	vpand		$MASK,$H4,$H4
+
+	 vpsrlq		\$4,$T3,$T2
+
+	vpsrlq		\$26,$H1,$D1
+	vpand		$MASK,$H1,$H1
+	vpaddq		$D1,$H2,$H2		# h1 -> h2
+
+	vpaddq		$D4,$H0,$H0
+	vpsllq		\$2,$D4,$D4
+	vpaddq		$D4,$H0,$H0		# h4 -> h0
+
+	 vpand		$MASK,$T2,$T2		# 2
+	 vpsrlq		\$26,$T0,$T1
+
+	vpsrlq		\$26,$H2,$D2
+	vpand		$MASK,$H2,$H2
+	vpaddq		$D2,$H3,$H3		# h2 -> h3
+
+	 vpaddq		$T2,$H2,$H2		# modulo-scheduled
+	 vpsrlq		\$30,$T3,$T3
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	 vpsrlq		\$40,$T4,$T4		# 4
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	 vpand		$MASK,$T0,$T0		# 0
+	 vpand		$MASK,$T1,$T1		# 1
+	 vpand		$MASK,$T3,$T3		# 3
+	 vpor		32(%rcx),$T4,$T4	# padbit, yes, always
+
+	sub		\$64,$len
+	jnz		.Loop_avx2$suffix
+
+	.byte		0x66,0x90
+.Ltail_avx2$suffix:
+	################################################################
+	# while above multiplications were by r^4 in all lanes, in last
+	# iteration we multiply least significant lane by r^4 and most
+	# significant one by r, so copy of above except that references
+	# to the precomputed table are displaced by 4...
+
+	#vpaddq		$H2,$T2,$H2		# accumulate input
+	vpaddq		$H0,$T0,$H0
+	vmovdqu		`32*0+4`(%rsp),$T0	# r0^4
+	vpaddq		$H1,$T1,$H1
+	vmovdqu		`32*1+4`(%rsp),$T1	# r1^4
+	vpaddq		$H3,$T3,$H3
+	vmovdqu		`32*3+4`(%rsp),$T2	# r2^4
+	vpaddq		$H4,$T4,$H4
+	vmovdqu		`32*6+4-0x90`(%rax),$T3	# s3^4
+	vmovdqu		`32*8+4-0x90`(%rax),$S4	# s4^4
+
+	vpmuludq	$H2,$T0,$D2		# d2 = h2*r0
+	vpmuludq	$H2,$T1,$D3		# d3 = h2*r1
+	vpmuludq	$H2,$T2,$D4		# d4 = h2*r2
+	vpmuludq	$H2,$T3,$D0		# d0 = h2*s3
+	vpmuludq	$H2,$S4,$D1		# d1 = h2*s4
+
+	vpmuludq	$H0,$T1,$T4		# h0*r1
+	vpmuludq	$H1,$T1,$H2		# h1*r1
+	vpaddq		$T4,$D1,$D1		# d1 += h0*r1
+	vpaddq		$H2,$D2,$D2		# d2 += h1*r1
+	vpmuludq	$H3,$T1,$T4		# h3*r1
+	vpmuludq	`32*2+4`(%rsp),$H4,$H2	# h4*s1
+	vpaddq		$T4,$D4,$D4		# d4 += h3*r1
+	vpaddq		$H2,$D0,$D0		# d0 += h4*s1
+
+	vpmuludq	$H0,$T0,$T4		# h0*r0
+	vpmuludq	$H1,$T0,$H2		# h1*r0
+	vpaddq		$T4,$D0,$D0		# d0 += h0*r0
+	 vmovdqu	`32*4+4-0x90`(%rax),$T1	# s2
+	vpaddq		$H2,$D1,$D1		# d1 += h1*r0
+	vpmuludq	$H3,$T0,$T4		# h3*r0
+	vpmuludq	$H4,$T0,$H2		# h4*r0
+	vpaddq		$T4,$D3,$D3		# d3 += h3*r0
+	vpaddq		$H2,$D4,$D4		# d4 += h4*r0
+
+	vpmuludq	$H3,$T1,$T4		# h3*s2
+	vpmuludq	$H4,$T1,$H2		# h4*s2
+	vpaddq		$T4,$D0,$D0		# d0 += h3*s2
+	vpaddq		$H2,$D1,$D1		# d1 += h4*s2
+	 vmovdqu	`32*5+4-0x90`(%rax),$H2	# r3
+	vpmuludq	$H1,$T2,$T4		# h1*r2
+	vpmuludq	$H0,$T2,$T2		# h0*r2
+	vpaddq		$T4,$D3,$D3		# d3 += h1*r2
+	vpaddq		$T2,$D2,$D2		# d2 += h0*r2
+
+	vpmuludq	$H1,$H2,$T4		# h1*r3
+	vpmuludq	$H0,$H2,$H2		# h0*r3
+	vpaddq		$T4,$D4,$D4		# d4 += h1*r3
+	vpaddq		$H2,$D3,$D3		# d3 += h0*r3
+	vpmuludq	$H3,$T3,$T4		# h3*s3
+	vpmuludq	$H4,$T3,$H2		# h4*s3
+	vpaddq		$T4,$D1,$D1		# d1 += h3*s3
+	vpaddq		$H2,$D2,$D2		# d2 += h4*s3
+
+	vpmuludq	$H3,$S4,$H3		# h3*s4
+	vpmuludq	$H4,$S4,$H4		# h4*s4
+	vpaddq		$H3,$D2,$H2		# h2 = d2 + h3*r4
+	vpaddq		$H4,$D3,$H3		# h3 = d3 + h4*r4
+	vpmuludq	`32*7+4-0x90`(%rax),$H0,$H4		# h0*r4
+	vpmuludq	$H1,$S4,$H0		# h1*s4
+	vmovdqa		64(%rcx),$MASK		# .Lmask26
+	vpaddq		$H4,$D4,$H4		# h4 = d4 + h0*r4
+	vpaddq		$H0,$D0,$H0		# h0 = d0 + h1*s4
+
+	################################################################
+	# horizontal addition
+
+	vpsrldq		\$8,$D1,$T1
+	vpsrldq		\$8,$H2,$T2
+	vpsrldq		\$8,$H3,$T3
+	vpsrldq		\$8,$H4,$T4
+	vpsrldq		\$8,$H0,$T0
+	vpaddq		$T1,$D1,$D1
+	vpaddq		$T2,$H2,$H2
+	vpaddq		$T3,$H3,$H3
+	vpaddq		$T4,$H4,$H4
+	vpaddq		$T0,$H0,$H0
+
+	vpermq		\$0x2,$H3,$T3
+	vpermq		\$0x2,$H4,$T4
+	vpermq		\$0x2,$H0,$T0
+	vpermq		\$0x2,$D1,$T1
+	vpermq		\$0x2,$H2,$T2
+	vpaddq		$T3,$H3,$H3
+	vpaddq		$T4,$H4,$H4
+	vpaddq		$T0,$H0,$H0
+	vpaddq		$T1,$D1,$D1
+	vpaddq		$T2,$H2,$H2
+
+	################################################################
+	# lazy reduction
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$D1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H4,$D4
+	vpand		$MASK,$H4,$H4
+
+	vpsrlq		\$26,$H1,$D1
+	vpand		$MASK,$H1,$H1
+	vpaddq		$D1,$H2,$H2		# h1 -> h2
+
+	vpaddq		$D4,$H0,$H0
+	vpsllq		\$2,$D4,$D4
+	vpaddq		$D4,$H0,$H0		# h4 -> h0
+
+	vpsrlq		\$26,$H2,$D2
+	vpand		$MASK,$H2,$H2
+	vpaddq		$D2,$H3,$H3		# h2 -> h3
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	vmovd		%x#$H0,`4*0-48-64`($ctx)# save partially reduced
+	vmovd		%x#$H1,`4*1-48-64`($ctx)
+	vmovd		%x#$H2,`4*2-48-64`($ctx)
+	vmovd		%x#$H3,`4*3-48-64`($ctx)
+	vmovd		%x#$H4,`4*4-48-64`($ctx)
+___
+$code.=<<___	if ($win64);
+	vmovdqa		-0xb0(%r10),%xmm6
+	vmovdqa		-0xa0(%r10),%xmm7
+	vmovdqa		-0x90(%r10),%xmm8
+	vmovdqa		-0x80(%r10),%xmm9
+	vmovdqa		-0x70(%r10),%xmm10
+	vmovdqa		-0x60(%r10),%xmm11
+	vmovdqa		-0x50(%r10),%xmm12
+	vmovdqa		-0x40(%r10),%xmm13
+	vmovdqa		-0x30(%r10),%xmm14
+	vmovdqa		-0x20(%r10),%xmm15
+	lea		-8(%r10),%rsp
+.Ldo_avx2_epilogue$suffix:
+___
+$code.=<<___	if (!$win64);
+	lea		-8(%r10),%rsp
+.cfi_def_cfa_register	%rsp
+___
+$code.=<<___;
+	vzeroupper
+	ret
+.cfi_endproc
+___
+if($avx > 2 && $avx512) {
+my ($R0,$R1,$R2,$R3,$R4, $S1,$S2,$S3,$S4) = map("%zmm$_",(16..24));
+my ($M0,$M1,$M2,$M3,$M4) = map("%zmm$_",(25..29));
+my $PADBIT="%zmm30";
+
+map(s/%y/%z/,($T4,$T0,$T1,$T2,$T3));		# switch to %zmm domain
+map(s/%y/%z/,($D0,$D1,$D2,$D3,$D4));
+map(s/%y/%z/,($H0,$H1,$H2,$H3,$H4));
+map(s/%y/%z/,($MASK));
+
+$code.=<<___;
+.cfi_startproc
+.Lblocks_avx512:
+	mov		\$15,%eax
+	kmovw		%eax,%k2
+___
+$code.=<<___	if (!$win64);
+	lea		8(%rsp),%r10
+.cfi_def_cfa_register	%r10
+	sub		\$0x128,%rsp
+___
+$code.=<<___	if ($win64);
+	lea		8(%rsp),%r10
+	sub		\$0x1c8,%rsp
+	vmovdqa		%xmm6,-0xb0(%r10)
+	vmovdqa		%xmm7,-0xa0(%r10)
+	vmovdqa		%xmm8,-0x90(%r10)
+	vmovdqa		%xmm9,-0x80(%r10)
+	vmovdqa		%xmm10,-0x70(%r10)
+	vmovdqa		%xmm11,-0x60(%r10)
+	vmovdqa		%xmm12,-0x50(%r10)
+	vmovdqa		%xmm13,-0x40(%r10)
+	vmovdqa		%xmm14,-0x30(%r10)
+	vmovdqa		%xmm15,-0x20(%r10)
+.Ldo_avx512_body:
+___
+$code.=<<___;
+	lea		.Lconst(%rip),%rcx
+	lea		48+64($ctx),$ctx	# size optimization
+	vmovdqa		96(%rcx),%y#$T2		# .Lpermd_avx2
+
+	# expand pre-calculated table
+	vmovdqu		`16*0-64`($ctx),%x#$D0	# will become expanded ${R0}
+	and		\$-512,%rsp
+	vmovdqu		`16*1-64`($ctx),%x#$D1	# will become ... ${R1}
+	mov		\$0x20,%rax
+	vmovdqu		`16*2-64`($ctx),%x#$T0	# ... ${S1}
+	vmovdqu		`16*3-64`($ctx),%x#$D2	# ... ${R2}
+	vmovdqu		`16*4-64`($ctx),%x#$T1	# ... ${S2}
+	vmovdqu		`16*5-64`($ctx),%x#$D3	# ... ${R3}
+	vmovdqu		`16*6-64`($ctx),%x#$T3	# ... ${S3}
+	vmovdqu		`16*7-64`($ctx),%x#$D4	# ... ${R4}
+	vmovdqu		`16*8-64`($ctx),%x#$T4	# ... ${S4}
+	vpermd		$D0,$T2,$R0		# 00003412 -> 14243444
+	vpbroadcastq	64(%rcx),$MASK		# .Lmask26
+	vpermd		$D1,$T2,$R1
+	vpermd		$T0,$T2,$S1
+	vpermd		$D2,$T2,$R2
+	vmovdqa64	$R0,0x00(%rsp){%k2}	# save in case $len%128 != 0
+	 vpsrlq		\$32,$R0,$T0		# 14243444 -> 01020304
+	vpermd		$T1,$T2,$S2
+	vmovdqu64	$R1,0x00(%rsp,%rax){%k2}
+	 vpsrlq		\$32,$R1,$T1
+	vpermd		$D3,$T2,$R3
+	vmovdqa64	$S1,0x40(%rsp){%k2}
+	vpermd		$T3,$T2,$S3
+	vpermd		$D4,$T2,$R4
+	vmovdqu64	$R2,0x40(%rsp,%rax){%k2}
+	vpermd		$T4,$T2,$S4
+	vmovdqa64	$S2,0x80(%rsp){%k2}
+	vmovdqu64	$R3,0x80(%rsp,%rax){%k2}
+	vmovdqa64	$S3,0xc0(%rsp){%k2}
+	vmovdqu64	$R4,0xc0(%rsp,%rax){%k2}
+	vmovdqa64	$S4,0x100(%rsp){%k2}
+
+	################################################################
+	# calculate 5th through 8th powers of the key
+	#
+	# d0 = r0'*r0 + r1'*5*r4 + r2'*5*r3 + r3'*5*r2 + r4'*5*r1
+	# d1 = r0'*r1 + r1'*r0   + r2'*5*r4 + r3'*5*r3 + r4'*5*r2
+	# d2 = r0'*r2 + r1'*r1   + r2'*r0   + r3'*5*r4 + r4'*5*r3
+	# d3 = r0'*r3 + r1'*r2   + r2'*r1   + r3'*r0   + r4'*5*r4
+	# d4 = r0'*r4 + r1'*r3   + r2'*r2   + r3'*r1   + r4'*r0
+
+	vpmuludq	$T0,$R0,$D0		# d0 = r0'*r0
+	vpmuludq	$T0,$R1,$D1		# d1 = r0'*r1
+	vpmuludq	$T0,$R2,$D2		# d2 = r0'*r2
+	vpmuludq	$T0,$R3,$D3		# d3 = r0'*r3
+	vpmuludq	$T0,$R4,$D4		# d4 = r0'*r4
+	 vpsrlq		\$32,$R2,$T2
+
+	vpmuludq	$T1,$S4,$M0
+	vpmuludq	$T1,$R0,$M1
+	vpmuludq	$T1,$R1,$M2
+	vpmuludq	$T1,$R2,$M3
+	vpmuludq	$T1,$R3,$M4
+	 vpsrlq		\$32,$R3,$T3
+	vpaddq		$M0,$D0,$D0		# d0 += r1'*5*r4
+	vpaddq		$M1,$D1,$D1		# d1 += r1'*r0
+	vpaddq		$M2,$D2,$D2		# d2 += r1'*r1
+	vpaddq		$M3,$D3,$D3		# d3 += r1'*r2
+	vpaddq		$M4,$D4,$D4		# d4 += r1'*r3
+
+	vpmuludq	$T2,$S3,$M0
+	vpmuludq	$T2,$S4,$M1
+	vpmuludq	$T2,$R1,$M3
+	vpmuludq	$T2,$R2,$M4
+	vpmuludq	$T2,$R0,$M2
+	 vpsrlq		\$32,$R4,$T4
+	vpaddq		$M0,$D0,$D0		# d0 += r2'*5*r3
+	vpaddq		$M1,$D1,$D1		# d1 += r2'*5*r4
+	vpaddq		$M3,$D3,$D3		# d3 += r2'*r1
+	vpaddq		$M4,$D4,$D4		# d4 += r2'*r2
+	vpaddq		$M2,$D2,$D2		# d2 += r2'*r0
+
+	vpmuludq	$T3,$S2,$M0
+	vpmuludq	$T3,$R0,$M3
+	vpmuludq	$T3,$R1,$M4
+	vpmuludq	$T3,$S3,$M1
+	vpmuludq	$T3,$S4,$M2
+	vpaddq		$M0,$D0,$D0		# d0 += r3'*5*r2
+	vpaddq		$M3,$D3,$D3		# d3 += r3'*r0
+	vpaddq		$M4,$D4,$D4		# d4 += r3'*r1
+	vpaddq		$M1,$D1,$D1		# d1 += r3'*5*r3
+	vpaddq		$M2,$D2,$D2		# d2 += r3'*5*r4
+
+	vpmuludq	$T4,$S4,$M3
+	vpmuludq	$T4,$R0,$M4
+	vpmuludq	$T4,$S1,$M0
+	vpmuludq	$T4,$S2,$M1
+	vpmuludq	$T4,$S3,$M2
+	vpaddq		$M3,$D3,$D3		# d3 += r2'*5*r4
+	vpaddq		$M4,$D4,$D4		# d4 += r2'*r0
+	vpaddq		$M0,$D0,$D0		# d0 += r2'*5*r1
+	vpaddq		$M1,$D1,$D1		# d1 += r2'*5*r2
+	vpaddq		$M2,$D2,$D2		# d2 += r2'*5*r3
+
+	################################################################
+	# load input
+	vmovdqu64	16*0($inp),%z#$T3
+	vmovdqu64	16*4($inp),%z#$T4
+	lea		16*8($inp),$inp
+
+	################################################################
+	# lazy reduction
+
+	vpsrlq		\$26,$D3,$M3
+	vpandq		$MASK,$D3,$D3
+	vpaddq		$M3,$D4,$D4		# d3 -> d4
+
+	vpsrlq		\$26,$D0,$M0
+	vpandq		$MASK,$D0,$D0
+	vpaddq		$M0,$D1,$D1		# d0 -> d1
+
+	vpsrlq		\$26,$D4,$M4
+	vpandq		$MASK,$D4,$D4
+
+	vpsrlq		\$26,$D1,$M1
+	vpandq		$MASK,$D1,$D1
+	vpaddq		$M1,$D2,$D2		# d1 -> d2
+
+	vpaddq		$M4,$D0,$D0
+	vpsllq		\$2,$M4,$M4
+	vpaddq		$M4,$D0,$D0		# d4 -> d0
+
+	vpsrlq		\$26,$D2,$M2
+	vpandq		$MASK,$D2,$D2
+	vpaddq		$M2,$D3,$D3		# d2 -> d3
+
+	vpsrlq		\$26,$D0,$M0
+	vpandq		$MASK,$D0,$D0
+	vpaddq		$M0,$D1,$D1		# d0 -> d1
+
+	vpsrlq		\$26,$D3,$M3
+	vpandq		$MASK,$D3,$D3
+	vpaddq		$M3,$D4,$D4		# d3 -> d4
+
+	################################################################
+	# at this point we have 14243444 in $R0-$S4 and 05060708 in
+	# $D0-$D4, ...
+
+	vpunpcklqdq	$T4,$T3,$T0	# transpose input
+	vpunpckhqdq	$T4,$T3,$T4
+
+	# ... since input 64-bit lanes are ordered as 73625140, we could
+	# "vperm" it to 76543210 (here and in each loop iteration), *or*
+	# we could just flow along, hence the goal for $R0-$S4 is
+	# 1858286838784888 ...
+
+	vmovdqa32	128(%rcx),$M0		# .Lpermd_avx512:
+	mov		\$0x7777,%eax
+	kmovw		%eax,%k1
+
+	vpermd		$R0,$M0,$R0		# 14243444 -> 1---2---3---4---
+	vpermd		$R1,$M0,$R1
+	vpermd		$R2,$M0,$R2
+	vpermd		$R3,$M0,$R3
+	vpermd		$R4,$M0,$R4
+
+	vpermd		$D0,$M0,${R0}{%k1}	# 05060708 -> 1858286838784888
+	vpermd		$D1,$M0,${R1}{%k1}
+	vpermd		$D2,$M0,${R2}{%k1}
+	vpermd		$D3,$M0,${R3}{%k1}
+	vpermd		$D4,$M0,${R4}{%k1}
+
+	vpslld		\$2,$R1,$S1		# *5
+	vpslld		\$2,$R2,$S2
+	vpslld		\$2,$R3,$S3
+	vpslld		\$2,$R4,$S4
+	vpaddd		$R1,$S1,$S1
+	vpaddd		$R2,$S2,$S2
+	vpaddd		$R3,$S3,$S3
+	vpaddd		$R4,$S4,$S4
+
+	vpbroadcastq	32(%rcx),$PADBIT	# .L129
+
+	vpsrlq		\$52,$T0,$T2		# splat input
+	vpsllq		\$12,$T4,$T3
+	vporq		$T3,$T2,$T2
+	vpsrlq		\$26,$T0,$T1
+	vpsrlq		\$14,$T4,$T3
+	vpsrlq		\$40,$T4,$T4		# 4
+	vpandq		$MASK,$T2,$T2		# 2
+	vpandq		$MASK,$T0,$T0		# 0
+	#vpandq		$MASK,$T1,$T1		# 1
+	#vpandq		$MASK,$T3,$T3		# 3
+	#vporq		$PADBIT,$T4,$T4		# padbit, yes, always
+
+	vpaddq		$H2,$T2,$H2		# accumulate input
+	sub		\$192,$len
+	jbe		.Ltail_avx512
+	jmp		.Loop_avx512
+
+.align	32
+.Loop_avx512:
+	################################################################
+	# ((inp[0]*r^8+inp[ 8])*r^8+inp[16])*r^8
+	# ((inp[1]*r^8+inp[ 9])*r^8+inp[17])*r^7
+	# ((inp[2]*r^8+inp[10])*r^8+inp[18])*r^6
+	# ((inp[3]*r^8+inp[11])*r^8+inp[19])*r^5
+	# ((inp[4]*r^8+inp[12])*r^8+inp[20])*r^4
+	# ((inp[5]*r^8+inp[13])*r^8+inp[21])*r^3
+	# ((inp[6]*r^8+inp[14])*r^8+inp[22])*r^2
+	# ((inp[7]*r^8+inp[15])*r^8+inp[23])*r^1
+	#   \________/\___________/
+	################################################################
+	#vpaddq		$H2,$T2,$H2		# accumulate input
+
+	# d4 = h4*r0 + h3*r1   + h2*r2   + h1*r3   + h0*r4
+	# d3 = h3*r0 + h2*r1   + h1*r2   + h0*r3   + h4*5*r4
+	# d2 = h2*r0 + h1*r1   + h0*r2   + h4*5*r3 + h3*5*r4
+	# d1 = h1*r0 + h0*r1   + h4*5*r2 + h3*5*r3 + h2*5*r4
+	# d0 = h0*r0 + h4*5*r1 + h3*5*r2 + h2*5*r3 + h1*5*r4
+	#
+	# however, as h2 is "chronologically" first one available pull
+	# corresponding operations up, so it's
+	#
+	# d3 = h2*r1   + h0*r3 + h1*r2   + h3*r0 + h4*5*r4
+	# d4 = h2*r2   + h0*r4 + h1*r3   + h3*r1 + h4*r0
+	# d0 = h2*5*r3 + h0*r0 + h1*5*r4         + h3*5*r2 + h4*5*r1
+	# d1 = h2*5*r4 + h0*r1           + h1*r0 + h3*5*r3 + h4*5*r2
+	# d2 = h2*r0           + h0*r2   + h1*r1 + h3*5*r4 + h4*5*r3
+
+	vpmuludq	$H2,$R1,$D3		# d3 = h2*r1
+	 vpaddq		$H0,$T0,$H0
+	vpmuludq	$H2,$R2,$D4		# d4 = h2*r2
+	 vpandq		$MASK,$T1,$T1		# 1
+	vpmuludq	$H2,$S3,$D0		# d0 = h2*s3
+	 vpandq		$MASK,$T3,$T3		# 3
+	vpmuludq	$H2,$S4,$D1		# d1 = h2*s4
+	 vporq		$PADBIT,$T4,$T4		# padbit, yes, always
+	vpmuludq	$H2,$R0,$D2		# d2 = h2*r0
+	 vpaddq		$H1,$T1,$H1		# accumulate input
+	 vpaddq		$H3,$T3,$H3
+	 vpaddq		$H4,$T4,$H4
+
+	  vmovdqu64	16*0($inp),$T3		# load input
+	  vmovdqu64	16*4($inp),$T4
+	  lea		16*8($inp),$inp
+	vpmuludq	$H0,$R3,$M3
+	vpmuludq	$H0,$R4,$M4
+	vpmuludq	$H0,$R0,$M0
+	vpmuludq	$H0,$R1,$M1
+	vpaddq		$M3,$D3,$D3		# d3 += h0*r3
+	vpaddq		$M4,$D4,$D4		# d4 += h0*r4
+	vpaddq		$M0,$D0,$D0		# d0 += h0*r0
+	vpaddq		$M1,$D1,$D1		# d1 += h0*r1
+
+	vpmuludq	$H1,$R2,$M3
+	vpmuludq	$H1,$R3,$M4
+	vpmuludq	$H1,$S4,$M0
+	vpmuludq	$H0,$R2,$M2
+	vpaddq		$M3,$D3,$D3		# d3 += h1*r2
+	vpaddq		$M4,$D4,$D4		# d4 += h1*r3
+	vpaddq		$M0,$D0,$D0		# d0 += h1*s4
+	vpaddq		$M2,$D2,$D2		# d2 += h0*r2
+
+	  vpunpcklqdq	$T4,$T3,$T0		# transpose input
+	  vpunpckhqdq	$T4,$T3,$T4
+
+	vpmuludq	$H3,$R0,$M3
+	vpmuludq	$H3,$R1,$M4
+	vpmuludq	$H1,$R0,$M1
+	vpmuludq	$H1,$R1,$M2
+	vpaddq		$M3,$D3,$D3		# d3 += h3*r0
+	vpaddq		$M4,$D4,$D4		# d4 += h3*r1
+	vpaddq		$M1,$D1,$D1		# d1 += h1*r0
+	vpaddq		$M2,$D2,$D2		# d2 += h1*r1
+
+	vpmuludq	$H4,$S4,$M3
+	vpmuludq	$H4,$R0,$M4
+	vpmuludq	$H3,$S2,$M0
+	vpmuludq	$H3,$S3,$M1
+	vpaddq		$M3,$D3,$D3		# d3 += h4*s4
+	vpmuludq	$H3,$S4,$M2
+	vpaddq		$M4,$D4,$D4		# d4 += h4*r0
+	vpaddq		$M0,$D0,$D0		# d0 += h3*s2
+	vpaddq		$M1,$D1,$D1		# d1 += h3*s3
+	vpaddq		$M2,$D2,$D2		# d2 += h3*s4
+
+	vpmuludq	$H4,$S1,$M0
+	vpmuludq	$H4,$S2,$M1
+	vpmuludq	$H4,$S3,$M2
+	vpaddq		$M0,$D0,$H0		# h0 = d0 + h4*s1
+	vpaddq		$M1,$D1,$H1		# h1 = d2 + h4*s2
+	vpaddq		$M2,$D2,$H2		# h2 = d3 + h4*s3
+
+	################################################################
+	# lazy reduction (interleaved with input splat)
+
+	 vpsrlq		\$52,$T0,$T2		# splat input
+	 vpsllq		\$12,$T4,$T3
+
+	vpsrlq		\$26,$D3,$H3
+	vpandq		$MASK,$D3,$D3
+	vpaddq		$H3,$D4,$H4		# h3 -> h4
+
+	 vporq		$T3,$T2,$T2
+
+	vpsrlq		\$26,$H0,$D0
+	vpandq		$MASK,$H0,$H0
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	 vpandq		$MASK,$T2,$T2		# 2
+
+	vpsrlq		\$26,$H4,$D4
+	vpandq		$MASK,$H4,$H4
+
+	vpsrlq		\$26,$H1,$D1
+	vpandq		$MASK,$H1,$H1
+	vpaddq		$D1,$H2,$H2		# h1 -> h2
+
+	vpaddq		$D4,$H0,$H0
+	vpsllq		\$2,$D4,$D4
+	vpaddq		$D4,$H0,$H0		# h4 -> h0
+
+	 vpaddq		$T2,$H2,$H2		# modulo-scheduled
+	 vpsrlq		\$26,$T0,$T1
+
+	vpsrlq		\$26,$H2,$D2
+	vpandq		$MASK,$H2,$H2
+	vpaddq		$D2,$D3,$H3		# h2 -> h3
+
+	 vpsrlq		\$14,$T4,$T3
+
+	vpsrlq		\$26,$H0,$D0
+	vpandq		$MASK,$H0,$H0
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	 vpsrlq		\$40,$T4,$T4		# 4
+
+	vpsrlq		\$26,$H3,$D3
+	vpandq		$MASK,$H3,$H3
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	 vpandq		$MASK,$T0,$T0		# 0
+	 #vpandq	$MASK,$T1,$T1		# 1
+	 #vpandq	$MASK,$T3,$T3		# 3
+	 #vporq		$PADBIT,$T4,$T4		# padbit, yes, always
+
+	sub		\$128,$len
+	ja		.Loop_avx512
+
+.Ltail_avx512:
+	################################################################
+	# while above multiplications were by r^8 in all lanes, in last
+	# iteration we multiply least significant lane by r^8 and most
+	# significant one by r, that's why table gets shifted...
+
+	vpsrlq		\$32,$R0,$R0		# 0105020603070408
+	vpsrlq		\$32,$R1,$R1
+	vpsrlq		\$32,$R2,$R2
+	vpsrlq		\$32,$S3,$S3
+	vpsrlq		\$32,$S4,$S4
+	vpsrlq		\$32,$R3,$R3
+	vpsrlq		\$32,$R4,$R4
+	vpsrlq		\$32,$S1,$S1
+	vpsrlq		\$32,$S2,$S2
+
+	################################################################
+	# load either next or last 64 byte of input
+	lea		($inp,$len),$inp
+
+	#vpaddq		$H2,$T2,$H2		# accumulate input
+	vpaddq		$H0,$T0,$H0
+
+	vpmuludq	$H2,$R1,$D3		# d3 = h2*r1
+	vpmuludq	$H2,$R2,$D4		# d4 = h2*r2
+	vpmuludq	$H2,$S3,$D0		# d0 = h2*s3
+	 vpandq		$MASK,$T1,$T1		# 1
+	vpmuludq	$H2,$S4,$D1		# d1 = h2*s4
+	 vpandq		$MASK,$T3,$T3		# 3
+	vpmuludq	$H2,$R0,$D2		# d2 = h2*r0
+	 vporq		$PADBIT,$T4,$T4		# padbit, yes, always
+	 vpaddq		$H1,$T1,$H1		# accumulate input
+	 vpaddq		$H3,$T3,$H3
+	 vpaddq		$H4,$T4,$H4
+
+	  vmovdqu	16*0($inp),%x#$T0
+	vpmuludq	$H0,$R3,$M3
+	vpmuludq	$H0,$R4,$M4
+	vpmuludq	$H0,$R0,$M0
+	vpmuludq	$H0,$R1,$M1
+	vpaddq		$M3,$D3,$D3		# d3 += h0*r3
+	vpaddq		$M4,$D4,$D4		# d4 += h0*r4
+	vpaddq		$M0,$D0,$D0		# d0 += h0*r0
+	vpaddq		$M1,$D1,$D1		# d1 += h0*r1
+
+	  vmovdqu	16*1($inp),%x#$T1
+	vpmuludq	$H1,$R2,$M3
+	vpmuludq	$H1,$R3,$M4
+	vpmuludq	$H1,$S4,$M0
+	vpmuludq	$H0,$R2,$M2
+	vpaddq		$M3,$D3,$D3		# d3 += h1*r2
+	vpaddq		$M4,$D4,$D4		# d4 += h1*r3
+	vpaddq		$M0,$D0,$D0		# d0 += h1*s4
+	vpaddq		$M2,$D2,$D2		# d2 += h0*r2
+
+	  vinserti128	\$1,16*2($inp),%y#$T0,%y#$T0
+	vpmuludq	$H3,$R0,$M3
+	vpmuludq	$H3,$R1,$M4
+	vpmuludq	$H1,$R0,$M1
+	vpmuludq	$H1,$R1,$M2
+	vpaddq		$M3,$D3,$D3		# d3 += h3*r0
+	vpaddq		$M4,$D4,$D4		# d4 += h3*r1
+	vpaddq		$M1,$D1,$D1		# d1 += h1*r0
+	vpaddq		$M2,$D2,$D2		# d2 += h1*r1
+
+	  vinserti128	\$1,16*3($inp),%y#$T1,%y#$T1
+	vpmuludq	$H4,$S4,$M3
+	vpmuludq	$H4,$R0,$M4
+	vpmuludq	$H3,$S2,$M0
+	vpmuludq	$H3,$S3,$M1
+	vpmuludq	$H3,$S4,$M2
+	vpaddq		$M3,$D3,$H3		# h3 = d3 + h4*s4
+	vpaddq		$M4,$D4,$D4		# d4 += h4*r0
+	vpaddq		$M0,$D0,$D0		# d0 += h3*s2
+	vpaddq		$M1,$D1,$D1		# d1 += h3*s3
+	vpaddq		$M2,$D2,$D2		# d2 += h3*s4
+
+	vpmuludq	$H4,$S1,$M0
+	vpmuludq	$H4,$S2,$M1
+	vpmuludq	$H4,$S3,$M2
+	vpaddq		$M0,$D0,$H0		# h0 = d0 + h4*s1
+	vpaddq		$M1,$D1,$H1		# h1 = d2 + h4*s2
+	vpaddq		$M2,$D2,$H2		# h2 = d3 + h4*s3
+
+	################################################################
+	# horizontal addition
+
+	mov		\$1,%eax
+	vpermq		\$0xb1,$H3,$D3
+	vpermq		\$0xb1,$D4,$H4
+	vpermq		\$0xb1,$H0,$D0
+	vpermq		\$0xb1,$H1,$D1
+	vpermq		\$0xb1,$H2,$D2
+	vpaddq		$D3,$H3,$H3
+	vpaddq		$D4,$H4,$H4
+	vpaddq		$D0,$H0,$H0
+	vpaddq		$D1,$H1,$H1
+	vpaddq		$D2,$H2,$H2
+
+	kmovw		%eax,%k3
+	vpermq		\$0x2,$H3,$D3
+	vpermq		\$0x2,$H4,$D4
+	vpermq		\$0x2,$H0,$D0
+	vpermq		\$0x2,$H1,$D1
+	vpermq		\$0x2,$H2,$D2
+	vpaddq		$D3,$H3,$H3
+	vpaddq		$D4,$H4,$H4
+	vpaddq		$D0,$H0,$H0
+	vpaddq		$D1,$H1,$H1
+	vpaddq		$D2,$H2,$H2
+
+	vextracti64x4	\$0x1,$H3,%y#$D3
+	vextracti64x4	\$0x1,$H4,%y#$D4
+	vextracti64x4	\$0x1,$H0,%y#$D0
+	vextracti64x4	\$0x1,$H1,%y#$D1
+	vextracti64x4	\$0x1,$H2,%y#$D2
+	vpaddq		$D3,$H3,${H3}{%k3}{z}	# keep single qword in case
+	vpaddq		$D4,$H4,${H4}{%k3}{z}	# it's passed to .Ltail_avx2
+	vpaddq		$D0,$H0,${H0}{%k3}{z}
+	vpaddq		$D1,$H1,${H1}{%k3}{z}
+	vpaddq		$D2,$H2,${H2}{%k3}{z}
+___
+map(s/%z/%y/,($T0,$T1,$T2,$T3,$T4, $PADBIT));
+map(s/%z/%y/,($H0,$H1,$H2,$H3,$H4, $D0,$D1,$D2,$D3,$D4, $MASK));
+$code.=<<___;
+	################################################################
+	# lazy reduction (interleaved with input splat)
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	 vpsrldq	\$6,$T0,$T2		# splat input
+	 vpsrldq	\$6,$T1,$T3
+	 vpunpckhqdq	$T1,$T0,$T4		# 4
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	 vpunpcklqdq	$T3,$T2,$T2		# 2:3
+	 vpunpcklqdq	$T1,$T0,$T0		# 0:1
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H4,$D4
+	vpand		$MASK,$H4,$H4
+
+	vpsrlq		\$26,$H1,$D1
+	vpand		$MASK,$H1,$H1
+	 vpsrlq		\$30,$T2,$T3
+	 vpsrlq		\$4,$T2,$T2
+	vpaddq		$D1,$H2,$H2		# h1 -> h2
+
+	vpaddq		$D4,$H0,$H0
+	vpsllq		\$2,$D4,$D4
+	 vpsrlq		\$26,$T0,$T1
+	 vpsrlq		\$40,$T4,$T4		# 4
+	vpaddq		$D4,$H0,$H0		# h4 -> h0
+
+	vpsrlq		\$26,$H2,$D2
+	vpand		$MASK,$H2,$H2
+	 vpand		$MASK,$T2,$T2		# 2
+	 vpand		$MASK,$T0,$T0		# 0
+	vpaddq		$D2,$H3,$H3		# h2 -> h3
+
+	vpsrlq		\$26,$H0,$D0
+	vpand		$MASK,$H0,$H0
+	 vpaddq		$H2,$T2,$H2		# accumulate input for .Ltail_avx2
+	 vpand		$MASK,$T1,$T1		# 1
+	vpaddq		$D0,$H1,$H1		# h0 -> h1
+
+	vpsrlq		\$26,$H3,$D3
+	vpand		$MASK,$H3,$H3
+	 vpand		$MASK,$T3,$T3		# 3
+	 vpor		32(%rcx),$T4,$T4	# padbit, yes, always
+	vpaddq		$D3,$H4,$H4		# h3 -> h4
+
+	lea		0x90(%rsp),%rax		# size optimization for .Ltail_avx2
+	add		\$64,$len
+	jnz		.Ltail_avx2$suffix
+
+	vpsubq		$T2,$H2,$H2		# undo input accumulation
+	vmovd		%x#$H0,`4*0-48-64`($ctx)# save partially reduced
+	vmovd		%x#$H1,`4*1-48-64`($ctx)
+	vmovd		%x#$H2,`4*2-48-64`($ctx)
+	vmovd		%x#$H3,`4*3-48-64`($ctx)
+	vmovd		%x#$H4,`4*4-48-64`($ctx)
+	vzeroall
+___
+$code.=<<___	if ($win64);
+	movdqa		-0xb0(%r10),%xmm6
+	movdqa		-0xa0(%r10),%xmm7
+	movdqa		-0x90(%r10),%xmm8
+	movdqa		-0x80(%r10),%xmm9
+	movdqa		-0x70(%r10),%xmm10
+	movdqa		-0x60(%r10),%xmm11
+	movdqa		-0x50(%r10),%xmm12
+	movdqa		-0x40(%r10),%xmm13
+	movdqa		-0x30(%r10),%xmm14
+	movdqa		-0x20(%r10),%xmm15
+	lea		-8(%r10),%rsp
+.Ldo_avx512_epilogue:
+___
+$code.=<<___	if (!$win64);
+	lea		-8(%r10),%rsp
+.cfi_def_cfa_register	%rsp
+___
+$code.=<<___;
+	ret
+.cfi_endproc
+___
+
+}
+
+}
+
+&declare_function("poly1305_blocks_avx2", 32, 4);
+poly1305_blocks_avxN(0);
+&end_function("poly1305_blocks_avx2");
+
+if($kernel) {
+	$code .= "#endif\n";
+}
+
+#######################################################################
+if ($avx>2) {
+# On entry we have input length divisible by 64. But since inner loop
+# processes 128 bytes per iteration, cases when length is not divisible
+# by 128 are handled by passing tail 64 bytes to .Ltail_avx2. For this
+# reason stack layout is kept identical to poly1305_blocks_avx2. If not
+# for this tail, we wouldn't have to even allocate stack frame...
+
+if($kernel) {
+	$code .= "#ifdef CONFIG_AS_AVX512\n";
+}
+
+&declare_function("poly1305_blocks_avx512", 32, 4);
+poly1305_blocks_avxN(1);
+&end_function("poly1305_blocks_avx512");
+
+if ($kernel) {
+	$code .= "#endif\n";
+}
+
+if (!$kernel && $avx>3) {
+########################################################################
+# VPMADD52 version using 2^44 radix.
+#
+# One can argue that base 2^52 would be more natural. Well, even though
+# some operations would be more natural, one has to recognize couple of
+# things. Base 2^52 doesn't provide advantage over base 2^44 if you look
+# at amount of multiply-n-accumulate operations. Secondly, it makes it
+# impossible to pre-compute multiples of 5 [referred to as s[]/sN in
+# reference implementations], which means that more such operations
+# would have to be performed in inner loop, which in turn makes critical
+# path longer. In other words, even though base 2^44 reduction might
+# look less elegant, overall critical path is actually shorter...
+
+########################################################################
+# Layout of opaque area is following.
+#
+#	unsigned __int64 h[3];		# current hash value base 2^44
+#	unsigned __int64 s[2];		# key value*20 base 2^44
+#	unsigned __int64 r[3];		# key value base 2^44
+#	struct { unsigned __int64 r^1, r^3, r^2, r^4; } R[4];
+#					# r^n positions reflect
+#					# placement in register, not
+#					# memory, R[3] is R[1]*20
+
+$code.=<<___;
+.type	poly1305_init_base2_44,\@function,3
+.align	32
+poly1305_init_base2_44:
+	xor	%rax,%rax
+	mov	%rax,0($ctx)		# initialize hash value
+	mov	%rax,8($ctx)
+	mov	%rax,16($ctx)
+
+.Linit_base2_44:
+	lea	poly1305_blocks_vpmadd52(%rip),%r10
+	lea	poly1305_emit_base2_44(%rip),%r11
+
+	mov	\$0x0ffffffc0fffffff,%rax
+	mov	\$0x0ffffffc0ffffffc,%rcx
+	and	0($inp),%rax
+	mov	\$0x00000fffffffffff,%r8
+	and	8($inp),%rcx
+	mov	\$0x00000fffffffffff,%r9
+	and	%rax,%r8
+	shrd	\$44,%rcx,%rax
+	mov	%r8,40($ctx)		# r0
+	and	%r9,%rax
+	shr	\$24,%rcx
+	mov	%rax,48($ctx)		# r1
+	lea	(%rax,%rax,4),%rax	# *5
+	mov	%rcx,56($ctx)		# r2
+	shl	\$2,%rax		# magic <<2
+	lea	(%rcx,%rcx,4),%rcx	# *5
+	shl	\$2,%rcx		# magic <<2
+	mov	%rax,24($ctx)		# s1
+	mov	%rcx,32($ctx)		# s2
+	movq	\$-1,64($ctx)		# write impossible value
+___
+$code.=<<___	if ($flavour !~ /elf32/);
+	mov	%r10,0(%rdx)
+	mov	%r11,8(%rdx)
+___
+$code.=<<___	if ($flavour =~ /elf32/);
+	mov	%r10d,0(%rdx)
+	mov	%r11d,4(%rdx)
+___
+$code.=<<___;
+	mov	\$1,%eax
+	ret
+.size	poly1305_init_base2_44,.-poly1305_init_base2_44
+___
+{
+my ($H0,$H1,$H2,$r2r1r0,$r1r0s2,$r0s2s1,$Dlo,$Dhi) = map("%ymm$_",(0..5,16,17));
+my ($T0,$inp_permd,$inp_shift,$PAD) = map("%ymm$_",(18..21));
+my ($reduc_mask,$reduc_rght,$reduc_left) = map("%ymm$_",(22..25));
+
+$code.=<<___;
+.type	poly1305_blocks_vpmadd52,\@function,4
+.align	32
+poly1305_blocks_vpmadd52:
+	shr	\$4,$len
+	jz	.Lno_data_vpmadd52		# too short
+
+	shl	\$40,$padbit
+	mov	64($ctx),%r8			# peek on power of the key
+
+	# if powers of the key are not calculated yet, process up to 3
+	# blocks with this single-block subroutine, otherwise ensure that
+	# length is divisible by 2 blocks and pass the rest down to next
+	# subroutine...
+
+	mov	\$3,%rax
+	mov	\$1,%r10
+	cmp	\$4,$len			# is input long
+	cmovae	%r10,%rax
+	test	%r8,%r8				# is power value impossible?
+	cmovns	%r10,%rax
+
+	and	$len,%rax			# is input of favourable length?
+	jz	.Lblocks_vpmadd52_4x
+
+	sub		%rax,$len
+	mov		\$7,%r10d
+	mov		\$1,%r11d
+	kmovw		%r10d,%k7
+	lea		.L2_44_inp_permd(%rip),%r10
+	kmovw		%r11d,%k1
+
+	vmovq		$padbit,%x#$PAD
+	vmovdqa64	0(%r10),$inp_permd	# .L2_44_inp_permd
+	vmovdqa64	32(%r10),$inp_shift	# .L2_44_inp_shift
+	vpermq		\$0xcf,$PAD,$PAD
+	vmovdqa64	64(%r10),$reduc_mask	# .L2_44_mask
+
+	vmovdqu64	0($ctx),${Dlo}{%k7}{z}		# load hash value
+	vmovdqu64	40($ctx),${r2r1r0}{%k7}{z}	# load keys
+	vmovdqu64	32($ctx),${r1r0s2}{%k7}{z}
+	vmovdqu64	24($ctx),${r0s2s1}{%k7}{z}
+
+	vmovdqa64	96(%r10),$reduc_rght	# .L2_44_shift_rgt
+	vmovdqa64	128(%r10),$reduc_left	# .L2_44_shift_lft
+
+	jmp		.Loop_vpmadd52
+
+.align	32
+.Loop_vpmadd52:
+	vmovdqu32	0($inp),%x#$T0		# load input as ----3210
+	lea		16($inp),$inp
+
+	vpermd		$T0,$inp_permd,$T0	# ----3210 -> --322110
+	vpsrlvq		$inp_shift,$T0,$T0
+	vpandq		$reduc_mask,$T0,$T0
+	vporq		$PAD,$T0,$T0
+
+	vpaddq		$T0,$Dlo,$Dlo		# accumulate input
+
+	vpermq		\$0,$Dlo,${H0}{%k7}{z}	# smash hash value
+	vpermq		\$0b01010101,$Dlo,${H1}{%k7}{z}
+	vpermq		\$0b10101010,$Dlo,${H2}{%k7}{z}
+
+	vpxord		$Dlo,$Dlo,$Dlo
+	vpxord		$Dhi,$Dhi,$Dhi
+
+	vpmadd52luq	$r2r1r0,$H0,$Dlo
+	vpmadd52huq	$r2r1r0,$H0,$Dhi
+
+	vpmadd52luq	$r1r0s2,$H1,$Dlo
+	vpmadd52huq	$r1r0s2,$H1,$Dhi
+
+	vpmadd52luq	$r0s2s1,$H2,$Dlo
+	vpmadd52huq	$r0s2s1,$H2,$Dhi
+
+	vpsrlvq		$reduc_rght,$Dlo,$T0	# 0 in topmost qword
+	vpsllvq		$reduc_left,$Dhi,$Dhi	# 0 in topmost qword
+	vpandq		$reduc_mask,$Dlo,$Dlo
+
+	vpaddq		$T0,$Dhi,$Dhi
+
+	vpermq		\$0b10010011,$Dhi,$Dhi	# 0 in lowest qword
+
+	vpaddq		$Dhi,$Dlo,$Dlo		# note topmost qword :-)
+
+	vpsrlvq		$reduc_rght,$Dlo,$T0	# 0 in topmost word
+	vpandq		$reduc_mask,$Dlo,$Dlo
+
+	vpermq		\$0b10010011,$T0,$T0
+
+	vpaddq		$T0,$Dlo,$Dlo
+
+	vpermq		\$0b10010011,$Dlo,${T0}{%k1}{z}
+
+	vpaddq		$T0,$Dlo,$Dlo
+	vpsllq		\$2,$T0,$T0
+
+	vpaddq		$T0,$Dlo,$Dlo
+
+	dec		%rax			# len-=16
+	jnz		.Loop_vpmadd52
+
+	vmovdqu64	$Dlo,0($ctx){%k7}	# store hash value
+
+	test		$len,$len
+	jnz		.Lblocks_vpmadd52_4x
+
+.Lno_data_vpmadd52:
+	ret
+.size	poly1305_blocks_vpmadd52,.-poly1305_blocks_vpmadd52
+___
+}
+{
+########################################################################
+# As implied by its name 4x subroutine processes 4 blocks in parallel
+# (but handles even 4*n+2 blocks lengths). It takes up to 4th key power
+# and is handled in 256-bit %ymm registers.
+
+my ($H0,$H1,$H2,$R0,$R1,$R2,$S1,$S2) = map("%ymm$_",(0..5,16,17));
+my ($D0lo,$D0hi,$D1lo,$D1hi,$D2lo,$D2hi) = map("%ymm$_",(18..23));
+my ($T0,$T1,$T2,$T3,$mask44,$mask42,$tmp,$PAD) = map("%ymm$_",(24..31));
+
+$code.=<<___;
+.type	poly1305_blocks_vpmadd52_4x,\@function,4
+.align	32
+poly1305_blocks_vpmadd52_4x:
+	shr	\$4,$len
+	jz	.Lno_data_vpmadd52_4x		# too short
+
+	shl	\$40,$padbit
+	mov	64($ctx),%r8			# peek on power of the key
+
+.Lblocks_vpmadd52_4x:
+	vpbroadcastq	$padbit,$PAD
+
+	vmovdqa64	.Lx_mask44(%rip),$mask44
+	mov		\$5,%eax
+	vmovdqa64	.Lx_mask42(%rip),$mask42
+	kmovw		%eax,%k1		# used in 2x path
+
+	test		%r8,%r8			# is power value impossible?
+	js		.Linit_vpmadd52		# if it is, then init R[4]
+
+	vmovq		0($ctx),%x#$H0		# load current hash value
+	vmovq		8($ctx),%x#$H1
+	vmovq		16($ctx),%x#$H2
+
+	test		\$3,$len		# is length 4*n+2?
+	jnz		.Lblocks_vpmadd52_2x_do
+
+.Lblocks_vpmadd52_4x_do:
+	vpbroadcastq	64($ctx),$R0		# load 4th power of the key
+	vpbroadcastq	96($ctx),$R1
+	vpbroadcastq	128($ctx),$R2
+	vpbroadcastq	160($ctx),$S1
+
+.Lblocks_vpmadd52_4x_key_loaded:
+	vpsllq		\$2,$R2,$S2		# S2 = R2*5*4
+	vpaddq		$R2,$S2,$S2
+	vpsllq		\$2,$S2,$S2
+
+	test		\$7,$len		# is len 8*n?
+	jz		.Lblocks_vpmadd52_8x
+
+	vmovdqu64	16*0($inp),$T2		# load data
+	vmovdqu64	16*2($inp),$T3
+	lea		16*4($inp),$inp
+
+	vpunpcklqdq	$T3,$T2,$T1		# transpose data
+	vpunpckhqdq	$T3,$T2,$T3
+
+	# at this point 64-bit lanes are ordered as 3-1-2-0
+
+	vpsrlq		\$24,$T3,$T2		# splat the data
+	vporq		$PAD,$T2,$T2
+	 vpaddq		$T2,$H2,$H2		# accumulate input
+	vpandq		$mask44,$T1,$T0
+	vpsrlq		\$44,$T1,$T1
+	vpsllq		\$20,$T3,$T3
+	vporq		$T3,$T1,$T1
+	vpandq		$mask44,$T1,$T1
+
+	sub		\$4,$len
+	jz		.Ltail_vpmadd52_4x
+	jmp		.Loop_vpmadd52_4x
+	ud2
+
+.align	32
+.Linit_vpmadd52:
+	vmovq		24($ctx),%x#$S1		# load key
+	vmovq		56($ctx),%x#$H2
+	vmovq		32($ctx),%x#$S2
+	vmovq		40($ctx),%x#$R0
+	vmovq		48($ctx),%x#$R1
+
+	vmovdqa		$R0,$H0
+	vmovdqa		$R1,$H1
+	vmovdqa		$H2,$R2
+
+	mov		\$2,%eax
+
+.Lmul_init_vpmadd52:
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$H2,$S1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$H2,$S1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$H2,$S2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$H2,$S2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$H2,$R0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$H2,$R0,$D2hi
+
+	vpmadd52luq	$H0,$R0,$D0lo
+	vpmadd52huq	$H0,$R0,$D0hi
+	vpmadd52luq	$H0,$R1,$D1lo
+	vpmadd52huq	$H0,$R1,$D1hi
+	vpmadd52luq	$H0,$R2,$D2lo
+	vpmadd52huq	$H0,$R2,$D2hi
+
+	vpmadd52luq	$H1,$S2,$D0lo
+	vpmadd52huq	$H1,$S2,$D0hi
+	vpmadd52luq	$H1,$R0,$D1lo
+	vpmadd52huq	$H1,$R0,$D1hi
+	vpmadd52luq	$H1,$R1,$D2lo
+	vpmadd52huq	$H1,$R1,$D2hi
+
+	################################################################
+	# partial reduction
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$H0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$H1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$H2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+
+	vpsrlq		\$44,$H0,$tmp		# additional step
+	vpandq		$mask44,$H0,$H0
+
+	vpaddq		$tmp,$H1,$H1
+
+	dec		%eax
+	jz		.Ldone_init_vpmadd52
+
+	vpunpcklqdq	$R1,$H1,$R1		# 1,2
+	vpbroadcastq	%x#$H1,%x#$H1		# 2,2
+	vpunpcklqdq	$R2,$H2,$R2
+	vpbroadcastq	%x#$H2,%x#$H2
+	vpunpcklqdq	$R0,$H0,$R0
+	vpbroadcastq	%x#$H0,%x#$H0
+
+	vpsllq		\$2,$R1,$S1		# S1 = R1*5*4
+	vpsllq		\$2,$R2,$S2		# S2 = R2*5*4
+	vpaddq		$R1,$S1,$S1
+	vpaddq		$R2,$S2,$S2
+	vpsllq		\$2,$S1,$S1
+	vpsllq		\$2,$S2,$S2
+
+	jmp		.Lmul_init_vpmadd52
+	ud2
+
+.align	32
+.Ldone_init_vpmadd52:
+	vinserti128	\$1,%x#$R1,$H1,$R1	# 1,2,3,4
+	vinserti128	\$1,%x#$R2,$H2,$R2
+	vinserti128	\$1,%x#$R0,$H0,$R0
+
+	vpermq		\$0b11011000,$R1,$R1	# 1,3,2,4
+	vpermq		\$0b11011000,$R2,$R2
+	vpermq		\$0b11011000,$R0,$R0
+
+	vpsllq		\$2,$R1,$S1		# S1 = R1*5*4
+	vpaddq		$R1,$S1,$S1
+	vpsllq		\$2,$S1,$S1
+
+	vmovq		0($ctx),%x#$H0		# load current hash value
+	vmovq		8($ctx),%x#$H1
+	vmovq		16($ctx),%x#$H2
+
+	test		\$3,$len		# is length 4*n+2?
+	jnz		.Ldone_init_vpmadd52_2x
+
+	vmovdqu64	$R0,64($ctx)		# save key powers
+	vpbroadcastq	%x#$R0,$R0		# broadcast 4th power
+	vmovdqu64	$R1,96($ctx)
+	vpbroadcastq	%x#$R1,$R1
+	vmovdqu64	$R2,128($ctx)
+	vpbroadcastq	%x#$R2,$R2
+	vmovdqu64	$S1,160($ctx)
+	vpbroadcastq	%x#$S1,$S1
+
+	jmp		.Lblocks_vpmadd52_4x_key_loaded
+	ud2
+
+.align	32
+.Ldone_init_vpmadd52_2x:
+	vmovdqu64	$R0,64($ctx)		# save key powers
+	vpsrldq		\$8,$R0,$R0		# 0-1-0-2
+	vmovdqu64	$R1,96($ctx)
+	vpsrldq		\$8,$R1,$R1
+	vmovdqu64	$R2,128($ctx)
+	vpsrldq		\$8,$R2,$R2
+	vmovdqu64	$S1,160($ctx)
+	vpsrldq		\$8,$S1,$S1
+	jmp		.Lblocks_vpmadd52_2x_key_loaded
+	ud2
+
+.align	32
+.Lblocks_vpmadd52_2x_do:
+	vmovdqu64	128+8($ctx),${R2}{%k1}{z}# load 2nd and 1st key powers
+	vmovdqu64	160+8($ctx),${S1}{%k1}{z}
+	vmovdqu64	64+8($ctx),${R0}{%k1}{z}
+	vmovdqu64	96+8($ctx),${R1}{%k1}{z}
+
+.Lblocks_vpmadd52_2x_key_loaded:
+	vmovdqu64	16*0($inp),$T2		# load data
+	vpxorq		$T3,$T3,$T3
+	lea		16*2($inp),$inp
+
+	vpunpcklqdq	$T3,$T2,$T1		# transpose data
+	vpunpckhqdq	$T3,$T2,$T3
+
+	# at this point 64-bit lanes are ordered as x-1-x-0
+
+	vpsrlq		\$24,$T3,$T2		# splat the data
+	vporq		$PAD,$T2,$T2
+	 vpaddq		$T2,$H2,$H2		# accumulate input
+	vpandq		$mask44,$T1,$T0
+	vpsrlq		\$44,$T1,$T1
+	vpsllq		\$20,$T3,$T3
+	vporq		$T3,$T1,$T1
+	vpandq		$mask44,$T1,$T1
+
+	jmp		.Ltail_vpmadd52_2x
+	ud2
+
+.align	32
+.Loop_vpmadd52_4x:
+	#vpaddq		$T2,$H2,$H2		# accumulate input
+	vpaddq		$T0,$H0,$H0
+	vpaddq		$T1,$H1,$H1
+
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$H2,$S1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$H2,$S1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$H2,$S2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$H2,$S2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$H2,$R0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$H2,$R0,$D2hi
+
+	 vmovdqu64	16*0($inp),$T2		# load data
+	 vmovdqu64	16*2($inp),$T3
+	 lea		16*4($inp),$inp
+	vpmadd52luq	$H0,$R0,$D0lo
+	vpmadd52huq	$H0,$R0,$D0hi
+	vpmadd52luq	$H0,$R1,$D1lo
+	vpmadd52huq	$H0,$R1,$D1hi
+	vpmadd52luq	$H0,$R2,$D2lo
+	vpmadd52huq	$H0,$R2,$D2hi
+
+	 vpunpcklqdq	$T3,$T2,$T1		# transpose data
+	 vpunpckhqdq	$T3,$T2,$T3
+	vpmadd52luq	$H1,$S2,$D0lo
+	vpmadd52huq	$H1,$S2,$D0hi
+	vpmadd52luq	$H1,$R0,$D1lo
+	vpmadd52huq	$H1,$R0,$D1hi
+	vpmadd52luq	$H1,$R1,$D2lo
+	vpmadd52huq	$H1,$R1,$D2hi
+
+	################################################################
+	# partial reduction (interleaved with data splat)
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$H0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	 vpsrlq		\$24,$T3,$T2
+	 vporq		$PAD,$T2,$T2
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$H1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	 vpandq		$mask44,$T1,$T0
+	 vpsrlq		\$44,$T1,$T1
+	 vpsllq		\$20,$T3,$T3
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$H2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	  vpaddq	$T2,$H2,$H2		# accumulate input
+	vpaddq		$D2hi,$H0,$H0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+	 vporq		$T3,$T1,$T1
+	 vpandq		$mask44,$T1,$T1
+
+	vpsrlq		\$44,$H0,$tmp		# additional step
+	vpandq		$mask44,$H0,$H0
+
+	vpaddq		$tmp,$H1,$H1
+
+	sub		\$4,$len		# len-=64
+	jnz		.Loop_vpmadd52_4x
+
+.Ltail_vpmadd52_4x:
+	vmovdqu64	128($ctx),$R2		# load all key powers
+	vmovdqu64	160($ctx),$S1
+	vmovdqu64	64($ctx),$R0
+	vmovdqu64	96($ctx),$R1
+
+.Ltail_vpmadd52_2x:
+	vpsllq		\$2,$R2,$S2		# S2 = R2*5*4
+	vpaddq		$R2,$S2,$S2
+	vpsllq		\$2,$S2,$S2
+
+	#vpaddq		$T2,$H2,$H2		# accumulate input
+	vpaddq		$T0,$H0,$H0
+	vpaddq		$T1,$H1,$H1
+
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$H2,$S1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$H2,$S1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$H2,$S2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$H2,$S2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$H2,$R0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$H2,$R0,$D2hi
+
+	vpmadd52luq	$H0,$R0,$D0lo
+	vpmadd52huq	$H0,$R0,$D0hi
+	vpmadd52luq	$H0,$R1,$D1lo
+	vpmadd52huq	$H0,$R1,$D1hi
+	vpmadd52luq	$H0,$R2,$D2lo
+	vpmadd52huq	$H0,$R2,$D2hi
+
+	vpmadd52luq	$H1,$S2,$D0lo
+	vpmadd52huq	$H1,$S2,$D0hi
+	vpmadd52luq	$H1,$R0,$D1lo
+	vpmadd52huq	$H1,$R0,$D1hi
+	vpmadd52luq	$H1,$R1,$D2lo
+	vpmadd52huq	$H1,$R1,$D2hi
+
+	################################################################
+	# horizontal addition
+
+	mov		\$1,%eax
+	kmovw		%eax,%k1
+	vpsrldq		\$8,$D0lo,$T0
+	vpsrldq		\$8,$D0hi,$H0
+	vpsrldq		\$8,$D1lo,$T1
+	vpsrldq		\$8,$D1hi,$H1
+	vpaddq		$T0,$D0lo,$D0lo
+	vpaddq		$H0,$D0hi,$D0hi
+	vpsrldq		\$8,$D2lo,$T2
+	vpsrldq		\$8,$D2hi,$H2
+	vpaddq		$T1,$D1lo,$D1lo
+	vpaddq		$H1,$D1hi,$D1hi
+	 vpermq		\$0x2,$D0lo,$T0
+	 vpermq		\$0x2,$D0hi,$H0
+	vpaddq		$T2,$D2lo,$D2lo
+	vpaddq		$H2,$D2hi,$D2hi
+
+	vpermq		\$0x2,$D1lo,$T1
+	vpermq		\$0x2,$D1hi,$H1
+	vpaddq		$T0,$D0lo,${D0lo}{%k1}{z}
+	vpaddq		$H0,$D0hi,${D0hi}{%k1}{z}
+	vpermq		\$0x2,$D2lo,$T2
+	vpermq		\$0x2,$D2hi,$H2
+	vpaddq		$T1,$D1lo,${D1lo}{%k1}{z}
+	vpaddq		$H1,$D1hi,${D1hi}{%k1}{z}
+	vpaddq		$T2,$D2lo,${D2lo}{%k1}{z}
+	vpaddq		$H2,$D2hi,${D2hi}{%k1}{z}
+
+	################################################################
+	# partial reduction
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$H0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$H1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$H2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+
+	vpsrlq		\$44,$H0,$tmp		# additional step
+	vpandq		$mask44,$H0,$H0
+
+	vpaddq		$tmp,$H1,$H1
+						# at this point $len is
+						# either 4*n+2 or 0...
+	sub		\$2,$len		# len-=32
+	ja		.Lblocks_vpmadd52_4x_do
+
+	vmovq		%x#$H0,0($ctx)
+	vmovq		%x#$H1,8($ctx)
+	vmovq		%x#$H2,16($ctx)
+	vzeroall
+
+.Lno_data_vpmadd52_4x:
+	ret
+.size	poly1305_blocks_vpmadd52_4x,.-poly1305_blocks_vpmadd52_4x
+___
+}
+{
+########################################################################
+# As implied by its name 8x subroutine processes 8 blocks in parallel...
+# This is intermediate version, as it's used only in cases when input
+# length is either 8*n, 8*n+1 or 8*n+2...
+
+my ($H0,$H1,$H2,$R0,$R1,$R2,$S1,$S2) = map("%ymm$_",(0..5,16,17));
+my ($D0lo,$D0hi,$D1lo,$D1hi,$D2lo,$D2hi) = map("%ymm$_",(18..23));
+my ($T0,$T1,$T2,$T3,$mask44,$mask42,$tmp,$PAD) = map("%ymm$_",(24..31));
+my ($RR0,$RR1,$RR2,$SS1,$SS2) = map("%ymm$_",(6..10));
+
+$code.=<<___;
+.type	poly1305_blocks_vpmadd52_8x,\@function,4
+.align	32
+poly1305_blocks_vpmadd52_8x:
+	shr	\$4,$len
+	jz	.Lno_data_vpmadd52_8x		# too short
+
+	shl	\$40,$padbit
+	mov	64($ctx),%r8			# peek on power of the key
+
+	vmovdqa64	.Lx_mask44(%rip),$mask44
+	vmovdqa64	.Lx_mask42(%rip),$mask42
+
+	test	%r8,%r8				# is power value impossible?
+	js	.Linit_vpmadd52			# if it is, then init R[4]
+
+	vmovq	0($ctx),%x#$H0			# load current hash value
+	vmovq	8($ctx),%x#$H1
+	vmovq	16($ctx),%x#$H2
+
+.Lblocks_vpmadd52_8x:
+	################################################################
+	# fist we calculate more key powers
+
+	vmovdqu64	128($ctx),$R2		# load 1-3-2-4 powers
+	vmovdqu64	160($ctx),$S1
+	vmovdqu64	64($ctx),$R0
+	vmovdqu64	96($ctx),$R1
+
+	vpsllq		\$2,$R2,$S2		# S2 = R2*5*4
+	vpaddq		$R2,$S2,$S2
+	vpsllq		\$2,$S2,$S2
+
+	vpbroadcastq	%x#$R2,$RR2		# broadcast 4th power
+	vpbroadcastq	%x#$R0,$RR0
+	vpbroadcastq	%x#$R1,$RR1
+
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$RR2,$S1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$RR2,$S1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$RR2,$S2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$RR2,$S2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$RR2,$R0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$RR2,$R0,$D2hi
+
+	vpmadd52luq	$RR0,$R0,$D0lo
+	vpmadd52huq	$RR0,$R0,$D0hi
+	vpmadd52luq	$RR0,$R1,$D1lo
+	vpmadd52huq	$RR0,$R1,$D1hi
+	vpmadd52luq	$RR0,$R2,$D2lo
+	vpmadd52huq	$RR0,$R2,$D2hi
+
+	vpmadd52luq	$RR1,$S2,$D0lo
+	vpmadd52huq	$RR1,$S2,$D0hi
+	vpmadd52luq	$RR1,$R0,$D1lo
+	vpmadd52huq	$RR1,$R0,$D1hi
+	vpmadd52luq	$RR1,$R1,$D2lo
+	vpmadd52huq	$RR1,$R1,$D2hi
+
+	################################################################
+	# partial reduction
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$RR0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$RR1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$RR2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$RR0,$RR0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$RR0,$RR0
+
+	vpsrlq		\$44,$RR0,$tmp		# additional step
+	vpandq		$mask44,$RR0,$RR0
+
+	vpaddq		$tmp,$RR1,$RR1
+
+	################################################################
+	# At this point Rx holds 1324 powers, RRx - 5768, and the goal
+	# is 15263748, which reflects how data is loaded...
+
+	vpunpcklqdq	$R2,$RR2,$T2		# 3748
+	vpunpckhqdq	$R2,$RR2,$R2		# 1526
+	vpunpcklqdq	$R0,$RR0,$T0
+	vpunpckhqdq	$R0,$RR0,$R0
+	vpunpcklqdq	$R1,$RR1,$T1
+	vpunpckhqdq	$R1,$RR1,$R1
+___
+######## switch to %zmm
+map(s/%y/%z/, $H0,$H1,$H2,$R0,$R1,$R2,$S1,$S2);
+map(s/%y/%z/, $D0lo,$D0hi,$D1lo,$D1hi,$D2lo,$D2hi);
+map(s/%y/%z/, $T0,$T1,$T2,$T3,$mask44,$mask42,$tmp,$PAD);
+map(s/%y/%z/, $RR0,$RR1,$RR2,$SS1,$SS2);
+
+$code.=<<___;
+	vshufi64x2	\$0x44,$R2,$T2,$RR2	# 15263748
+	vshufi64x2	\$0x44,$R0,$T0,$RR0
+	vshufi64x2	\$0x44,$R1,$T1,$RR1
+
+	vmovdqu64	16*0($inp),$T2		# load data
+	vmovdqu64	16*4($inp),$T3
+	lea		16*8($inp),$inp
+
+	vpsllq		\$2,$RR2,$SS2		# S2 = R2*5*4
+	vpsllq		\$2,$RR1,$SS1		# S1 = R1*5*4
+	vpaddq		$RR2,$SS2,$SS2
+	vpaddq		$RR1,$SS1,$SS1
+	vpsllq		\$2,$SS2,$SS2
+	vpsllq		\$2,$SS1,$SS1
+
+	vpbroadcastq	$padbit,$PAD
+	vpbroadcastq	%x#$mask44,$mask44
+	vpbroadcastq	%x#$mask42,$mask42
+
+	vpbroadcastq	%x#$SS1,$S1		# broadcast 8th power
+	vpbroadcastq	%x#$SS2,$S2
+	vpbroadcastq	%x#$RR0,$R0
+	vpbroadcastq	%x#$RR1,$R1
+	vpbroadcastq	%x#$RR2,$R2
+
+	vpunpcklqdq	$T3,$T2,$T1		# transpose data
+	vpunpckhqdq	$T3,$T2,$T3
+
+	# at this point 64-bit lanes are ordered as 73625140
+
+	vpsrlq		\$24,$T3,$T2		# splat the data
+	vporq		$PAD,$T2,$T2
+	 vpaddq		$T2,$H2,$H2		# accumulate input
+	vpandq		$mask44,$T1,$T0
+	vpsrlq		\$44,$T1,$T1
+	vpsllq		\$20,$T3,$T3
+	vporq		$T3,$T1,$T1
+	vpandq		$mask44,$T1,$T1
+
+	sub		\$8,$len
+	jz		.Ltail_vpmadd52_8x
+	jmp		.Loop_vpmadd52_8x
+
+.align	32
+.Loop_vpmadd52_8x:
+	#vpaddq		$T2,$H2,$H2		# accumulate input
+	vpaddq		$T0,$H0,$H0
+	vpaddq		$T1,$H1,$H1
+
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$H2,$S1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$H2,$S1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$H2,$S2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$H2,$S2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$H2,$R0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$H2,$R0,$D2hi
+
+	 vmovdqu64	16*0($inp),$T2		# load data
+	 vmovdqu64	16*4($inp),$T3
+	 lea		16*8($inp),$inp
+	vpmadd52luq	$H0,$R0,$D0lo
+	vpmadd52huq	$H0,$R0,$D0hi
+	vpmadd52luq	$H0,$R1,$D1lo
+	vpmadd52huq	$H0,$R1,$D1hi
+	vpmadd52luq	$H0,$R2,$D2lo
+	vpmadd52huq	$H0,$R2,$D2hi
+
+	 vpunpcklqdq	$T3,$T2,$T1		# transpose data
+	 vpunpckhqdq	$T3,$T2,$T3
+	vpmadd52luq	$H1,$S2,$D0lo
+	vpmadd52huq	$H1,$S2,$D0hi
+	vpmadd52luq	$H1,$R0,$D1lo
+	vpmadd52huq	$H1,$R0,$D1hi
+	vpmadd52luq	$H1,$R1,$D2lo
+	vpmadd52huq	$H1,$R1,$D2hi
+
+	################################################################
+	# partial reduction (interleaved with data splat)
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$H0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	 vpsrlq		\$24,$T3,$T2
+	 vporq		$PAD,$T2,$T2
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$H1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	 vpandq		$mask44,$T1,$T0
+	 vpsrlq		\$44,$T1,$T1
+	 vpsllq		\$20,$T3,$T3
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$H2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	  vpaddq	$T2,$H2,$H2		# accumulate input
+	vpaddq		$D2hi,$H0,$H0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+	 vporq		$T3,$T1,$T1
+	 vpandq		$mask44,$T1,$T1
+
+	vpsrlq		\$44,$H0,$tmp		# additional step
+	vpandq		$mask44,$H0,$H0
+
+	vpaddq		$tmp,$H1,$H1
+
+	sub		\$8,$len		# len-=128
+	jnz		.Loop_vpmadd52_8x
+
+.Ltail_vpmadd52_8x:
+	#vpaddq		$T2,$H2,$H2		# accumulate input
+	vpaddq		$T0,$H0,$H0
+	vpaddq		$T1,$H1,$H1
+
+	vpxorq		$D0lo,$D0lo,$D0lo
+	vpmadd52luq	$H2,$SS1,$D0lo
+	vpxorq		$D0hi,$D0hi,$D0hi
+	vpmadd52huq	$H2,$SS1,$D0hi
+	vpxorq		$D1lo,$D1lo,$D1lo
+	vpmadd52luq	$H2,$SS2,$D1lo
+	vpxorq		$D1hi,$D1hi,$D1hi
+	vpmadd52huq	$H2,$SS2,$D1hi
+	vpxorq		$D2lo,$D2lo,$D2lo
+	vpmadd52luq	$H2,$RR0,$D2lo
+	vpxorq		$D2hi,$D2hi,$D2hi
+	vpmadd52huq	$H2,$RR0,$D2hi
+
+	vpmadd52luq	$H0,$RR0,$D0lo
+	vpmadd52huq	$H0,$RR0,$D0hi
+	vpmadd52luq	$H0,$RR1,$D1lo
+	vpmadd52huq	$H0,$RR1,$D1hi
+	vpmadd52luq	$H0,$RR2,$D2lo
+	vpmadd52huq	$H0,$RR2,$D2hi
+
+	vpmadd52luq	$H1,$SS2,$D0lo
+	vpmadd52huq	$H1,$SS2,$D0hi
+	vpmadd52luq	$H1,$RR0,$D1lo
+	vpmadd52huq	$H1,$RR0,$D1hi
+	vpmadd52luq	$H1,$RR1,$D2lo
+	vpmadd52huq	$H1,$RR1,$D2hi
+
+	################################################################
+	# horizontal addition
+
+	mov		\$1,%eax
+	kmovw		%eax,%k1
+	vpsrldq		\$8,$D0lo,$T0
+	vpsrldq		\$8,$D0hi,$H0
+	vpsrldq		\$8,$D1lo,$T1
+	vpsrldq		\$8,$D1hi,$H1
+	vpaddq		$T0,$D0lo,$D0lo
+	vpaddq		$H0,$D0hi,$D0hi
+	vpsrldq		\$8,$D2lo,$T2
+	vpsrldq		\$8,$D2hi,$H2
+	vpaddq		$T1,$D1lo,$D1lo
+	vpaddq		$H1,$D1hi,$D1hi
+	 vpermq		\$0x2,$D0lo,$T0
+	 vpermq		\$0x2,$D0hi,$H0
+	vpaddq		$T2,$D2lo,$D2lo
+	vpaddq		$H2,$D2hi,$D2hi
+
+	vpermq		\$0x2,$D1lo,$T1
+	vpermq		\$0x2,$D1hi,$H1
+	vpaddq		$T0,$D0lo,$D0lo
+	vpaddq		$H0,$D0hi,$D0hi
+	vpermq		\$0x2,$D2lo,$T2
+	vpermq		\$0x2,$D2hi,$H2
+	vpaddq		$T1,$D1lo,$D1lo
+	vpaddq		$H1,$D1hi,$D1hi
+	 vextracti64x4	\$1,$D0lo,%y#$T0
+	 vextracti64x4	\$1,$D0hi,%y#$H0
+	vpaddq		$T2,$D2lo,$D2lo
+	vpaddq		$H2,$D2hi,$D2hi
+
+	vextracti64x4	\$1,$D1lo,%y#$T1
+	vextracti64x4	\$1,$D1hi,%y#$H1
+	vextracti64x4	\$1,$D2lo,%y#$T2
+	vextracti64x4	\$1,$D2hi,%y#$H2
+___
+######## switch back to %ymm
+map(s/%z/%y/, $H0,$H1,$H2,$R0,$R1,$R2,$S1,$S2);
+map(s/%z/%y/, $D0lo,$D0hi,$D1lo,$D1hi,$D2lo,$D2hi);
+map(s/%z/%y/, $T0,$T1,$T2,$T3,$mask44,$mask42,$tmp,$PAD);
+
+$code.=<<___;
+	vpaddq		$T0,$D0lo,${D0lo}{%k1}{z}
+	vpaddq		$H0,$D0hi,${D0hi}{%k1}{z}
+	vpaddq		$T1,$D1lo,${D1lo}{%k1}{z}
+	vpaddq		$H1,$D1hi,${D1hi}{%k1}{z}
+	vpaddq		$T2,$D2lo,${D2lo}{%k1}{z}
+	vpaddq		$H2,$D2hi,${D2hi}{%k1}{z}
+
+	################################################################
+	# partial reduction
+	vpsrlq		\$44,$D0lo,$tmp
+	vpsllq		\$8,$D0hi,$D0hi
+	vpandq		$mask44,$D0lo,$H0
+	vpaddq		$tmp,$D0hi,$D0hi
+
+	vpaddq		$D0hi,$D1lo,$D1lo
+
+	vpsrlq		\$44,$D1lo,$tmp
+	vpsllq		\$8,$D1hi,$D1hi
+	vpandq		$mask44,$D1lo,$H1
+	vpaddq		$tmp,$D1hi,$D1hi
+
+	vpaddq		$D1hi,$D2lo,$D2lo
+
+	vpsrlq		\$42,$D2lo,$tmp
+	vpsllq		\$10,$D2hi,$D2hi
+	vpandq		$mask42,$D2lo,$H2
+	vpaddq		$tmp,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+	vpsllq		\$2,$D2hi,$D2hi
+
+	vpaddq		$D2hi,$H0,$H0
+
+	vpsrlq		\$44,$H0,$tmp		# additional step
+	vpandq		$mask44,$H0,$H0
+
+	vpaddq		$tmp,$H1,$H1
+
+	################################################################
+
+	vmovq		%x#$H0,0($ctx)
+	vmovq		%x#$H1,8($ctx)
+	vmovq		%x#$H2,16($ctx)
+	vzeroall
+
+.Lno_data_vpmadd52_8x:
+	ret
+.size	poly1305_blocks_vpmadd52_8x,.-poly1305_blocks_vpmadd52_8x
+___
+}
+$code.=<<___;
+.type	poly1305_emit_base2_44,\@function,3
+.align	32
+poly1305_emit_base2_44:
+	mov	0($ctx),%r8	# load hash value
+	mov	8($ctx),%r9
+	mov	16($ctx),%r10
+
+	mov	%r9,%rax
+	shr	\$20,%r9
+	shl	\$44,%rax
+	mov	%r10,%rcx
+	shr	\$40,%r10
+	shl	\$24,%rcx
+
+	add	%rax,%r8
+	adc	%rcx,%r9
+	adc	\$0,%r10
+
+	mov	%r8,%rax
+	add	\$5,%r8		# compare to modulus
+	mov	%r9,%rcx
+	adc	\$0,%r9
+	adc	\$0,%r10
+	shr	\$2,%r10	# did 130-bit value overflow?
+	cmovnz	%r8,%rax
+	cmovnz	%r9,%rcx
+
+	add	0($nonce),%rax	# accumulate nonce
+	adc	8($nonce),%rcx
+	mov	%rax,0($mac)	# write result
+	mov	%rcx,8($mac)
+
+	ret
+.size	poly1305_emit_base2_44,.-poly1305_emit_base2_44
+___
+}	}	}
+}
+
+if (!$kernel)
+{	# chacha20-poly1305 helpers
+my ($out,$inp,$otp,$len)=$win64 ? ("%rcx","%rdx","%r8", "%r9") :  # Win64 order
+                                  ("%rdi","%rsi","%rdx","%rcx");  # Unix order
+$code.=<<___;
+.globl	xor128_encrypt_n_pad
+.type	xor128_encrypt_n_pad,\@abi-omnipotent
+.align	16
+xor128_encrypt_n_pad:
+	sub	$otp,$inp
+	sub	$otp,$out
+	mov	$len,%r10		# put len aside
+	shr	\$4,$len		# len / 16
+	jz	.Ltail_enc
+	nop
+.Loop_enc_xmm:
+	movdqu	($inp,$otp),%xmm0
+	pxor	($otp),%xmm0
+	movdqu	%xmm0,($out,$otp)
+	movdqa	%xmm0,($otp)
+	lea	16($otp),$otp
+	dec	$len
+	jnz	.Loop_enc_xmm
+
+	and	\$15,%r10		# len % 16
+	jz	.Ldone_enc
+
+.Ltail_enc:
+	mov	\$16,$len
+	sub	%r10,$len
+	xor	%eax,%eax
+.Loop_enc_byte:
+	mov	($inp,$otp),%al
+	xor	($otp),%al
+	mov	%al,($out,$otp)
+	mov	%al,($otp)
+	lea	1($otp),$otp
+	dec	%r10
+	jnz	.Loop_enc_byte
+
+	xor	%eax,%eax
+.Loop_enc_pad:
+	mov	%al,($otp)
+	lea	1($otp),$otp
+	dec	$len
+	jnz	.Loop_enc_pad
+
+.Ldone_enc:
+	mov	$otp,%rax
+	ret
+.size	xor128_encrypt_n_pad,.-xor128_encrypt_n_pad
+
+.globl	xor128_decrypt_n_pad
+.type	xor128_decrypt_n_pad,\@abi-omnipotent
+.align	16
+xor128_decrypt_n_pad:
+	sub	$otp,$inp
+	sub	$otp,$out
+	mov	$len,%r10		# put len aside
+	shr	\$4,$len		# len / 16
+	jz	.Ltail_dec
+	nop
+.Loop_dec_xmm:
+	movdqu	($inp,$otp),%xmm0
+	movdqa	($otp),%xmm1
+	pxor	%xmm0,%xmm1
+	movdqu	%xmm1,($out,$otp)
+	movdqa	%xmm0,($otp)
+	lea	16($otp),$otp
+	dec	$len
+	jnz	.Loop_dec_xmm
+
+	pxor	%xmm1,%xmm1
+	and	\$15,%r10		# len % 16
+	jz	.Ldone_dec
+
+.Ltail_dec:
+	mov	\$16,$len
+	sub	%r10,$len
+	xor	%eax,%eax
+	xor	%r11,%r11
+.Loop_dec_byte:
+	mov	($inp,$otp),%r11b
+	mov	($otp),%al
+	xor	%r11b,%al
+	mov	%al,($out,$otp)
+	mov	%r11b,($otp)
+	lea	1($otp),$otp
+	dec	%r10
+	jnz	.Loop_dec_byte
+
+	xor	%eax,%eax
+.Loop_dec_pad:
+	mov	%al,($otp)
+	lea	1($otp),$otp
+	dec	$len
+	jnz	.Loop_dec_pad
+
+.Ldone_dec:
+	mov	$otp,%rax
+	ret
+.size	xor128_decrypt_n_pad,.-xor128_decrypt_n_pad
+___
+}
+
+# EXCEPTION_DISPOSITION handler (EXCEPTION_RECORD *rec,ULONG64 frame,
+#		CONTEXT *context,DISPATCHER_CONTEXT *disp)
+if ($win64) {
+$rec="%rcx";
+$frame="%rdx";
+$context="%r8";
+$disp="%r9";
+
+$code.=<<___;
+.extern	__imp_RtlVirtualUnwind
+.type	se_handler,\@abi-omnipotent
+.align	16
+se_handler:
+	push	%rsi
+	push	%rdi
+	push	%rbx
+	push	%rbp
+	push	%r12
+	push	%r13
+	push	%r14
+	push	%r15
+	pushfq
+	sub	\$64,%rsp
+
+	mov	120($context),%rax	# pull context->Rax
+	mov	248($context),%rbx	# pull context->Rip
+
+	mov	8($disp),%rsi		# disp->ImageBase
+	mov	56($disp),%r11		# disp->HandlerData
+
+	mov	0(%r11),%r10d		# HandlerData[0]
+	lea	(%rsi,%r10),%r10	# prologue label
+	cmp	%r10,%rbx		# context->Rip<.Lprologue
+	jb	.Lcommon_seh_tail
+
+	mov	152($context),%rax	# pull context->Rsp
+
+	mov	4(%r11),%r10d		# HandlerData[1]
+	lea	(%rsi,%r10),%r10	# epilogue label
+	cmp	%r10,%rbx		# context->Rip>=.Lepilogue
+	jae	.Lcommon_seh_tail
+
+	lea	48(%rax),%rax
+
+	mov	-8(%rax),%rbx
+	mov	-16(%rax),%rbp
+	mov	-24(%rax),%r12
+	mov	-32(%rax),%r13
+	mov	-40(%rax),%r14
+	mov	-48(%rax),%r15
+	mov	%rbx,144($context)	# restore context->Rbx
+	mov	%rbp,160($context)	# restore context->Rbp
+	mov	%r12,216($context)	# restore context->R12
+	mov	%r13,224($context)	# restore context->R13
+	mov	%r14,232($context)	# restore context->R14
+	mov	%r15,240($context)	# restore context->R14
+
+	jmp	.Lcommon_seh_tail
+.size	se_handler,.-se_handler
+
+.type	avx_handler,\@abi-omnipotent
+.align	16
+avx_handler:
+	push	%rsi
+	push	%rdi
+	push	%rbx
+	push	%rbp
+	push	%r12
+	push	%r13
+	push	%r14
+	push	%r15
+	pushfq
+	sub	\$64,%rsp
+
+	mov	120($context),%rax	# pull context->Rax
+	mov	248($context),%rbx	# pull context->Rip
+
+	mov	8($disp),%rsi		# disp->ImageBase
+	mov	56($disp),%r11		# disp->HandlerData
+
+	mov	0(%r11),%r10d		# HandlerData[0]
+	lea	(%rsi,%r10),%r10	# prologue label
+	cmp	%r10,%rbx		# context->Rip<prologue label
+	jb	.Lcommon_seh_tail
+
+	mov	152($context),%rax	# pull context->Rsp
+
+	mov	4(%r11),%r10d		# HandlerData[1]
+	lea	(%rsi,%r10),%r10	# epilogue label
+	cmp	%r10,%rbx		# context->Rip>=epilogue label
+	jae	.Lcommon_seh_tail
+
+	mov	208($context),%rax	# pull context->R11
+
+	lea	0x50(%rax),%rsi
+	lea	0xf8(%rax),%rax
+	lea	512($context),%rdi	# &context.Xmm6
+	mov	\$20,%ecx
+	.long	0xa548f3fc		# cld; rep movsq
+
+.Lcommon_seh_tail:
+	mov	8(%rax),%rdi
+	mov	16(%rax),%rsi
+	mov	%rax,152($context)	# restore context->Rsp
+	mov	%rsi,168($context)	# restore context->Rsi
+	mov	%rdi,176($context)	# restore context->Rdi
+
+	mov	40($disp),%rdi		# disp->ContextRecord
+	mov	$context,%rsi		# context
+	mov	\$154,%ecx		# sizeof(CONTEXT)
+	.long	0xa548f3fc		# cld; rep movsq
+
+	mov	$disp,%rsi
+	xor	%rcx,%rcx		# arg1, UNW_FLAG_NHANDLER
+	mov	8(%rsi),%rdx		# arg2, disp->ImageBase
+	mov	0(%rsi),%r8		# arg3, disp->ControlPc
+	mov	16(%rsi),%r9		# arg4, disp->FunctionEntry
+	mov	40(%rsi),%r10		# disp->ContextRecord
+	lea	56(%rsi),%r11		# &disp->HandlerData
+	lea	24(%rsi),%r12		# &disp->EstablisherFrame
+	mov	%r10,32(%rsp)		# arg5
+	mov	%r11,40(%rsp)		# arg6
+	mov	%r12,48(%rsp)		# arg7
+	mov	%rcx,56(%rsp)		# arg8, (NULL)
+	call	*__imp_RtlVirtualUnwind(%rip)
+
+	mov	\$1,%eax		# ExceptionContinueSearch
+	add	\$64,%rsp
+	popfq
+	pop	%r15
+	pop	%r14
+	pop	%r13
+	pop	%r12
+	pop	%rbp
+	pop	%rbx
+	pop	%rdi
+	pop	%rsi
+	ret
+.size	avx_handler,.-avx_handler
+
+.section	.pdata
+.align	4
+	.rva	.LSEH_begin_poly1305_init_x86_64
+	.rva	.LSEH_end_poly1305_init_x86_64
+	.rva	.LSEH_info_poly1305_init_x86_64
+
+	.rva	.LSEH_begin_poly1305_blocks_x86_64
+	.rva	.LSEH_end_poly1305_blocks_x86_64
+	.rva	.LSEH_info_poly1305_blocks_x86_64
+
+	.rva	.LSEH_begin_poly1305_emit_x86_64
+	.rva	.LSEH_end_poly1305_emit_x86_64
+	.rva	.LSEH_info_poly1305_emit_x86_64
+___
+$code.=<<___ if ($avx);
+	.rva	.LSEH_begin_poly1305_blocks_avx
+	.rva	.Lbase2_64_avx
+	.rva	.LSEH_info_poly1305_blocks_avx_1
+
+	.rva	.Lbase2_64_avx
+	.rva	.Leven_avx
+	.rva	.LSEH_info_poly1305_blocks_avx_2
+
+	.rva	.Leven_avx
+	.rva	.LSEH_end_poly1305_blocks_avx
+	.rva	.LSEH_info_poly1305_blocks_avx_3
+
+	.rva	.LSEH_begin_poly1305_emit_avx
+	.rva	.LSEH_end_poly1305_emit_avx
+	.rva	.LSEH_info_poly1305_emit_avx
+___
+$code.=<<___ if ($avx>1);
+	.rva	.LSEH_begin_poly1305_blocks_avx2
+	.rva	.Lbase2_64_avx2
+	.rva	.LSEH_info_poly1305_blocks_avx2_1
+
+	.rva	.Lbase2_64_avx2
+	.rva	.Leven_avx2
+	.rva	.LSEH_info_poly1305_blocks_avx2_2
+
+	.rva	.Leven_avx2
+	.rva	.LSEH_end_poly1305_blocks_avx2
+	.rva	.LSEH_info_poly1305_blocks_avx2_3
+___
+$code.=<<___ if ($avx>2);
+	.rva	.LSEH_begin_poly1305_blocks_avx512
+	.rva	.LSEH_end_poly1305_blocks_avx512
+	.rva	.LSEH_info_poly1305_blocks_avx512
+___
+$code.=<<___;
+.section	.xdata
+.align	8
+.LSEH_info_poly1305_init_x86_64:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.LSEH_begin_poly1305_init_x86_64,.LSEH_begin_poly1305_init_x86_64
+
+.LSEH_info_poly1305_blocks_x86_64:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.Lblocks_body,.Lblocks_epilogue
+
+.LSEH_info_poly1305_emit_x86_64:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.LSEH_begin_poly1305_emit_x86_64,.LSEH_begin_poly1305_emit_x86_64
+___
+$code.=<<___ if ($avx);
+.LSEH_info_poly1305_blocks_avx_1:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.Lblocks_avx_body,.Lblocks_avx_epilogue		# HandlerData[]
+
+.LSEH_info_poly1305_blocks_avx_2:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.Lbase2_64_avx_body,.Lbase2_64_avx_epilogue	# HandlerData[]
+
+.LSEH_info_poly1305_blocks_avx_3:
+	.byte	9,0,0,0
+	.rva	avx_handler
+	.rva	.Ldo_avx_body,.Ldo_avx_epilogue			# HandlerData[]
+
+.LSEH_info_poly1305_emit_avx:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.LSEH_begin_poly1305_emit_avx,.LSEH_begin_poly1305_emit_avx
+___
+$code.=<<___ if ($avx>1);
+.LSEH_info_poly1305_blocks_avx2_1:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.Lblocks_avx2_body,.Lblocks_avx2_epilogue	# HandlerData[]
+
+.LSEH_info_poly1305_blocks_avx2_2:
+	.byte	9,0,0,0
+	.rva	se_handler
+	.rva	.Lbase2_64_avx2_body,.Lbase2_64_avx2_epilogue	# HandlerData[]
+
+.LSEH_info_poly1305_blocks_avx2_3:
+	.byte	9,0,0,0
+	.rva	avx_handler
+	.rva	.Ldo_avx2_body,.Ldo_avx2_epilogue		# HandlerData[]
+___
+$code.=<<___ if ($avx>2);
+.LSEH_info_poly1305_blocks_avx512:
+	.byte	9,0,0,0
+	.rva	avx_handler
+	.rva	.Ldo_avx512_body,.Ldo_avx512_epilogue		# HandlerData[]
+___
+}
+
+open SELF,$0;
+while(<SELF>) {
+	next if (/^#!/);
+	last if (!s/^#/\/\// and !/^$/);
+	print;
+}
+close SELF;
+
+foreach (split('\n',$code)) {
+	s/\`([^\`]*)\`/eval($1)/ge;
+	s/%r([a-z]+)#d/%e$1/g;
+	s/%r([0-9]+)#d/%r$1d/g;
+	s/%x#%[yz]/%x/g or s/%y#%z/%y/g or s/%z#%[yz]/%z/g;
+
+	if ($kernel) {
+		s/(^\.type.*),[0-9]+$/\1/;
+		s/(^\.type.*),\@abi-omnipotent+$/\1,\@function/;
+		next if /^\.cfi.*/;
+	}
+
+	print $_,"\n";
+}
+close STDOUT;
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 633e6d5093fa..657363588e0c 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -1,8 +1,6 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: GPL-2.0 OR MIT
 /*
- * Poly1305 authenticator algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #include <crypto/algapi.h>
@@ -13,279 +11,170 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <asm/intel-family.h>
 #include <asm/simd.h>
 
-asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
-				    const u32 *r, unsigned int blocks);
-asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
-				     unsigned int blocks, const u32 *u);
-asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
-				     unsigned int blocks, const u32 *u);
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_simd);
+asmlinkage void poly1305_init_x86_64(void *ctx,
+				     const u8 key[POLY1305_KEY_SIZE]);
+asmlinkage void poly1305_blocks_x86_64(void *ctx, const u8 *inp,
+				       const size_t len, const u32 padbit);
+asmlinkage void poly1305_emit_x86_64(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
+				     const u32 nonce[4]);
+asmlinkage void poly1305_emit_avx(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
+				  const u32 nonce[4]);
+asmlinkage void poly1305_blocks_avx(void *ctx, const u8 *inp, const size_t len,
+				    const u32 padbit);
+asmlinkage void poly1305_blocks_avx2(void *ctx, const u8 *inp, const size_t len,
+				     const u32 padbit);
+asmlinkage void poly1305_blocks_avx512(void *ctx, const u8 *inp,
+				       const size_t len, const u32 padbit);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
+
+struct poly1305_arch_internal {
+	union {
+		struct {
+			u32 h[5];
+			u32 is_base2_26;
+		};
+		u64 hs[3];
+	};
+	u64 r[2];
+	u64 pad;
+	struct { u32 r2, r1, r4, r3; } rn[9];
+};
 
-static inline u64 mlt(u64 a, u64 b)
+/* The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
+ * the unfortunate situation of using AVX and then having to go back to scalar
+ * -- because the user is silly and has called the update function from two
+ * separate contexts -- then we need to convert back to the original base before
+ * proceeding. It is possible to reason that the initial reduction below is
+ * sufficient given the implementation invariants. However, for an avoidance of
+ * doubt and because this is not performance critical, we do the full reduction
+ * anyway. Z3 proof of below function: https://xn--4db.cc/ltPtHCKN/py
+ */
+static void convert_to_base2_64(void *ctx)
 {
-	return a * b;
-}
+	struct poly1305_arch_internal *state = ctx;
+	u32 cy;
 
-static inline u32 sr(u64 v, u_char n)
-{
-	return v >> n;
-}
+	if (!state->is_base2_26)
+		return;
 
-static inline u32 and(u32 v, u32 mask)
-{
-	return v & mask;
+	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
+	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
+	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
+	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
+	state->hs[0] = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
+	state->hs[1] = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
+	state->hs[2] = state->h[4] >> 24;
+#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
+	cy = (state->hs[2] >> 2) + (state->hs[2] & ~3ULL);
+	state->hs[2] &= 3;
+	state->hs[0] += cy;
+	state->hs[1] += (cy = ULT(state->hs[0], cy));
+	state->hs[2] += ULT(state->hs[1], cy);
+#undef ULT
+	state->is_base2_26 = 0;
 }
 
-static void poly1305_simd_mult(u32 *a, const u32 *b)
+static void poly1305_simd_init(void *ctx, const u8 key[POLY1305_KEY_SIZE])
 {
-	u8 m[POLY1305_BLOCK_SIZE];
-
-	memset(m, 0, sizeof(m));
-	/* The poly1305 block function adds a hi-bit to the accumulator which
-	 * we don't need for key multiplication; compensate for it. */
-	a[4] -= 1 << 24;
-	poly1305_block_sse2(a, m, b, 1);
+	poly1305_init_x86_64(ctx, key);
 }
 
-static void poly1305_integer_setkey(struct poly1305_key *key, const u8 *raw_key)
+static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
+				 const u32 padbit)
 {
-	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
-	key->r[0] = (get_unaligned_le32(raw_key +  0) >> 0) & 0x3ffffff;
-	key->r[1] = (get_unaligned_le32(raw_key +  3) >> 2) & 0x3ffff03;
-	key->r[2] = (get_unaligned_le32(raw_key +  6) >> 4) & 0x3ffc0ff;
-	key->r[3] = (get_unaligned_le32(raw_key +  9) >> 6) & 0x3f03fff;
-	key->r[4] = (get_unaligned_le32(raw_key + 12) >> 8) & 0x00fffff;
-}
+	struct poly1305_arch_internal *state = ctx;
 
-static void poly1305_integer_blocks(struct poly1305_state *state,
-				    const struct poly1305_key *key,
-				    const void *src,
-				    unsigned int nblocks, u32 hibit)
-{
-	u32 r0, r1, r2, r3, r4;
-	u32 s1, s2, s3, s4;
-	u32 h0, h1, h2, h3, h4;
-	u64 d0, d1, d2, d3, d4;
+	/* SIMD disables preemption, so relax after processing each page. */
+	BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
+		     PAGE_SIZE % POLY1305_BLOCK_SIZE);
 
-	if (!nblocks)
+	if (!IS_ENABLED(CONFIG_AS_AVX) || !static_branch_likely(&poly1305_use_avx) ||
+	    (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
+	    !crypto_simd_usable()) {
+		convert_to_base2_64(ctx);
+		poly1305_blocks_x86_64(ctx, inp, len, padbit);
 		return;
+	}
 
-	r0 = key->r[0];
-	r1 = key->r[1];
-	r2 = key->r[2];
-	r3 = key->r[3];
-	r4 = key->r[4];
-
-	s1 = r1 * 5;
-	s2 = r2 * 5;
-	s3 = r3 * 5;
-	s4 = r4 * 5;
-
-	h0 = state->h[0];
-	h1 = state->h[1];
-	h2 = state->h[2];
-	h3 = state->h[3];
-	h4 = state->h[4];
-
-	do {
-		/* h += m[i] */
-		h0 += (get_unaligned_le32(src +  0) >> 0) & 0x3ffffff;
-		h1 += (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
-		h2 += (get_unaligned_le32(src +  6) >> 4) & 0x3ffffff;
-		h3 += (get_unaligned_le32(src +  9) >> 6) & 0x3ffffff;
-		h4 += (get_unaligned_le32(src + 12) >> 8) | (hibit << 24);
-
-		/* h *= r */
-		d0 = mlt(h0, r0) + mlt(h1, s4) + mlt(h2, s3) +
-		     mlt(h3, s2) + mlt(h4, s1);
-		d1 = mlt(h0, r1) + mlt(h1, r0) + mlt(h2, s4) +
-		     mlt(h3, s3) + mlt(h4, s2);
-		d2 = mlt(h0, r2) + mlt(h1, r1) + mlt(h2, r0) +
-		     mlt(h3, s4) + mlt(h4, s3);
-		d3 = mlt(h0, r3) + mlt(h1, r2) + mlt(h2, r1) +
-		     mlt(h3, r0) + mlt(h4, s4);
-		d4 = mlt(h0, r4) + mlt(h1, r3) + mlt(h2, r2) +
-		     mlt(h3, r1) + mlt(h4, r0);
-
-		/* (partial) h %= p */
-		d1 += sr(d0, 26);     h0 = and(d0, 0x3ffffff);
-		d2 += sr(d1, 26);     h1 = and(d1, 0x3ffffff);
-		d3 += sr(d2, 26);     h2 = and(d2, 0x3ffffff);
-		d4 += sr(d3, 26);     h3 = and(d3, 0x3ffffff);
-		h0 += sr(d4, 26) * 5; h4 = and(d4, 0x3ffffff);
-		h1 += h0 >> 26;       h0 = h0 & 0x3ffffff;
-
-		src += POLY1305_BLOCK_SIZE;
-	} while (--nblocks);
-
-	state->h[0] = h0;
-	state->h[1] = h1;
-	state->h[2] = h2;
-	state->h[3] = h3;
-	state->h[4] = h4;
+	for (;;) {
+		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+		kernel_fpu_begin();
+		if (IS_ENABLED(CONFIG_AS_AVX512) && static_branch_likely(&poly1305_use_avx512))
+			poly1305_blocks_avx512(ctx, inp, bytes, padbit);
+		else if (IS_ENABLED(CONFIG_AS_AVX2) && static_branch_likely(&poly1305_use_avx2))
+			poly1305_blocks_avx2(ctx, inp, bytes, padbit);
+		else
+			poly1305_blocks_avx(ctx, inp, bytes, padbit);
+		kernel_fpu_end();
+		len -= bytes;
+		if (!len)
+			break;
+		inp += bytes;
+	}
 }
 
-static void poly1305_integer_emit(const struct poly1305_state *state, void *dst)
+static void poly1305_simd_emit(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
+			       const u32 nonce[4])
 {
-	u32 h0, h1, h2, h3, h4;
-	u32 g0, g1, g2, g3, g4;
-	u32 mask;
-
-	/* fully carry h */
-	h0 = state->h[0];
-	h1 = state->h[1];
-	h2 = state->h[2];
-	h3 = state->h[3];
-	h4 = state->h[4];
-
-	h2 += (h1 >> 26);     h1 = h1 & 0x3ffffff;
-	h3 += (h2 >> 26);     h2 = h2 & 0x3ffffff;
-	h4 += (h3 >> 26);     h3 = h3 & 0x3ffffff;
-	h0 += (h4 >> 26) * 5; h4 = h4 & 0x3ffffff;
-	h1 += (h0 >> 26);     h0 = h0 & 0x3ffffff;
-
-	/* compute h + -p */
-	g0 = h0 + 5;
-	g1 = h1 + (g0 >> 26);             g0 &= 0x3ffffff;
-	g2 = h2 + (g1 >> 26);             g1 &= 0x3ffffff;
-	g3 = h3 + (g2 >> 26);             g2 &= 0x3ffffff;
-	g4 = h4 + (g3 >> 26) - (1 << 26); g3 &= 0x3ffffff;
-
-	/* select h if h < p, or h + -p if h >= p */
-	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
-	g0 &= mask;
-	g1 &= mask;
-	g2 &= mask;
-	g3 &= mask;
-	g4 &= mask;
-	mask = ~mask;
-	h0 = (h0 & mask) | g0;
-	h1 = (h1 & mask) | g1;
-	h2 = (h2 & mask) | g2;
-	h3 = (h3 & mask) | g3;
-	h4 = (h4 & mask) | g4;
-
-	/* h = h % (2^128) */
-	put_unaligned_le32((h0 >>  0) | (h1 << 26), dst +  0);
-	put_unaligned_le32((h1 >>  6) | (h2 << 20), dst +  4);
-	put_unaligned_le32((h2 >> 12) | (h3 << 14), dst +  8);
-	put_unaligned_le32((h3 >> 18) | (h4 <<  8), dst + 12);
+	struct poly1305_arch_internal *state = ctx;
+
+	if (!IS_ENABLED(CONFIG_AS_AVX) || !static_branch_likely(&poly1305_use_avx) ||
+	    !state->is_base2_26 || !crypto_simd_usable()) {
+		convert_to_base2_64(ctx);
+		poly1305_emit_x86_64(ctx, mac, nonce);
+	} else
+		poly1305_emit_avx(ctx, mac, nonce);
 }
 
-void poly1305_init_arch(struct poly1305_desc_ctx *desc, const u8 *key)
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
-	poly1305_integer_setkey(desc->r, key);
-	desc->s[0] = get_unaligned_le32(key + 16);
-	desc->s[1] = get_unaligned_le32(key + 20);
-	desc->s[2] = get_unaligned_le32(key + 24);
-	desc->s[3] = get_unaligned_le32(key + 28);
-	poly1305_core_init(&desc->h);
-	desc->buflen = 0;
-	desc->sset = true;
-	desc->rset = 1;
+	poly1305_simd_init(&dctx->h, key);
+	dctx->s[0] = get_unaligned_le32(&key[16]);
+	dctx->s[1] = get_unaligned_le32(&key[20]);
+	dctx->s[2] = get_unaligned_le32(&key[24]);
+	dctx->s[3] = get_unaligned_le32(&key[28]);
+	dctx->buflen = 0;
+	dctx->sset = true;
 }
-EXPORT_SYMBOL_GPL(poly1305_init_arch);
+EXPORT_SYMBOL(poly1305_init_arch);
 
-static unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
-					       const u8 *src, unsigned int srclen)
+static unsigned int crypto_poly1305_setdctxkey(struct poly1305_desc_ctx *dctx,
+					       const u8 *inp, unsigned int len)
 {
-	if (!dctx->sset) {
-		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
-			poly1305_integer_setkey(dctx->r, src);
-			src += POLY1305_BLOCK_SIZE;
-			srclen -= POLY1305_BLOCK_SIZE;
+	unsigned int acc = 0;
+	if (unlikely(!dctx->sset)) {
+		if (!dctx->rset && len >= POLY1305_BLOCK_SIZE) {
+			poly1305_simd_init(&dctx->h, inp);
+			inp += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			acc += POLY1305_BLOCK_SIZE;
 			dctx->rset = 1;
 		}
-		if (srclen >= POLY1305_BLOCK_SIZE) {
-			dctx->s[0] = get_unaligned_le32(src +  0);
-			dctx->s[1] = get_unaligned_le32(src +  4);
-			dctx->s[2] = get_unaligned_le32(src +  8);
-			dctx->s[3] = get_unaligned_le32(src + 12);
-			src += POLY1305_BLOCK_SIZE;
-			srclen -= POLY1305_BLOCK_SIZE;
+		if (len >= POLY1305_BLOCK_SIZE) {
+			dctx->s[0] = get_unaligned_le32(&inp[0]);
+			dctx->s[1] = get_unaligned_le32(&inp[4]);
+			dctx->s[2] = get_unaligned_le32(&inp[8]);
+			dctx->s[3] = get_unaligned_le32(&inp[12]);
+			inp += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			acc += POLY1305_BLOCK_SIZE;
 			dctx->sset = true;
 		}
 	}
-	return srclen;
-}
-
-static unsigned int poly1305_scalar_blocks(struct poly1305_desc_ctx *dctx,
-					   const u8 *src, unsigned int srclen)
-{
-	unsigned int datalen;
-
-	if (unlikely(!dctx->sset)) {
-		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
-		src += srclen - datalen;
-		srclen = datalen;
-	}
-	if (srclen >= POLY1305_BLOCK_SIZE) {
-		poly1305_integer_blocks(&dctx->h, dctx->r, src,
-					srclen / POLY1305_BLOCK_SIZE, 1);
-		srclen %= POLY1305_BLOCK_SIZE;
-	}
-	return srclen;
-}
-
-static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
-					 const u8 *src, unsigned int srclen)
-{
-	unsigned int blocks, datalen;
-
-	if (unlikely(!dctx->sset)) {
-		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
-		src += srclen - datalen;
-		srclen = datalen;
-	}
-
-	if (IS_ENABLED(CONFIG_AS_AVX2) &&
-	    static_branch_likely(&poly1305_use_avx2) &&
-	    srclen >= POLY1305_BLOCK_SIZE * 4) {
-		if (unlikely(dctx->rset < 4)) {
-			if (dctx->rset < 2) {
-				dctx->r[1] = dctx->r[0];
-				poly1305_simd_mult(dctx->r[1].r, dctx->r[0].r);
-			}
-			dctx->r[2] = dctx->r[1];
-			poly1305_simd_mult(dctx->r[2].r, dctx->r[0].r);
-			dctx->r[3] = dctx->r[2];
-			poly1305_simd_mult(dctx->r[3].r, dctx->r[0].r);
-			dctx->rset = 4;
-		}
-		blocks = srclen / (POLY1305_BLOCK_SIZE * 4);
-		poly1305_4block_avx2(dctx->h.h, src, dctx->r[0].r, blocks,
-				     dctx->r[1].r);
-		src += POLY1305_BLOCK_SIZE * 4 * blocks;
-		srclen -= POLY1305_BLOCK_SIZE * 4 * blocks;
-	}
-
-	if (likely(srclen >= POLY1305_BLOCK_SIZE * 2)) {
-		if (unlikely(dctx->rset < 2)) {
-			dctx->r[1] = dctx->r[0];
-			poly1305_simd_mult(dctx->r[1].r, dctx->r[0].r);
-			dctx->rset = 2;
-		}
-		blocks = srclen / (POLY1305_BLOCK_SIZE * 2);
-		poly1305_2block_sse2(dctx->h.h, src, dctx->r[0].r,
-				     blocks, dctx->r[1].r);
-		src += POLY1305_BLOCK_SIZE * 2 * blocks;
-		srclen -= POLY1305_BLOCK_SIZE * 2 * blocks;
-	}
-	if (srclen >= POLY1305_BLOCK_SIZE) {
-		poly1305_block_sse2(dctx->h.h, src, dctx->r[0].r, 1);
-		srclen -= POLY1305_BLOCK_SIZE;
-	}
-	return srclen;
+	return acc;
 }
 
 void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 			  unsigned int srclen)
 {
-	unsigned int bytes;
+	unsigned int bytes, used;
 
 	if (unlikely(dctx->buflen)) {
 		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
@@ -295,31 +184,19 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			if (static_branch_likely(&poly1305_use_simd) &&
-			    likely(crypto_simd_usable())) {
-				kernel_fpu_begin();
-				poly1305_simd_blocks(dctx, dctx->buf,
-						     POLY1305_BLOCK_SIZE);
-				kernel_fpu_end();
-			} else {
-				poly1305_scalar_blocks(dctx, dctx->buf,
-						       POLY1305_BLOCK_SIZE);
-			}
+			if (likely(!crypto_poly1305_setdctxkey(dctx, dctx->buf, POLY1305_BLOCK_SIZE)))
+				poly1305_simd_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 1);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		if (static_branch_likely(&poly1305_use_simd) &&
-		    likely(crypto_simd_usable())) {
-			kernel_fpu_begin();
-			bytes = poly1305_simd_blocks(dctx, src, srclen);
-			kernel_fpu_end();
-		} else {
-			bytes = poly1305_scalar_blocks(dctx, src, srclen);
-		}
-		src += srclen - bytes;
-		srclen = bytes;
+		bytes = round_down(srclen, POLY1305_BLOCK_SIZE);
+		srclen -= bytes;
+		used = crypto_poly1305_setdctxkey(dctx, src, bytes);
+		if (likely(bytes - used))
+			poly1305_simd_blocks(&dctx->h, src + used, bytes - used, 1);
+		src += bytes;
 	}
 
 	if (unlikely(srclen)) {
@@ -329,31 +206,17 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 }
 EXPORT_SYMBOL(poly1305_update_arch);
 
-void poly1305_final_arch(struct poly1305_desc_ctx *desc, u8 *dst)
+void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 {
-	__le32 digest[4];
-	u64 f = 0;
-
-	if (unlikely(desc->buflen)) {
-		desc->buf[desc->buflen++] = 1;
-		memset(desc->buf + desc->buflen, 0,
-		       POLY1305_BLOCK_SIZE - desc->buflen);
-		poly1305_integer_blocks(&desc->h, desc->r, desc->buf, 1, 0);
+	if (unlikely(dctx->buflen)) {
+		dctx->buf[dctx->buflen++] = 1;
+		memset(dctx->buf + dctx->buflen, 0,
+		       POLY1305_BLOCK_SIZE - dctx->buflen);
+		poly1305_simd_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
-	poly1305_integer_emit(&desc->h, digest);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]) + desc->s[0];
-	put_unaligned_le32(f, dst + 0);
-	f = (f >> 32) + le32_to_cpu(digest[1]) + desc->s[1];
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]) + desc->s[2];
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]) + desc->s[3];
-	put_unaligned_le32(f, dst + 12);
-
-	*desc = (struct poly1305_desc_ctx){};
+	poly1305_simd_emit(&dctx->h, dst, dctx->s);
+	*dctx = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final_arch);
 
@@ -361,38 +224,34 @@ static int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	poly1305_core_init(&dctx->h);
-	dctx->buflen = 0;
-	dctx->rset = 0;
-	dctx->sset = false;
-
+	*dctx = (struct poly1305_desc_ctx){};
 	return 0;
 }
 
-static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
+static int crypto_poly1305_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (unlikely(!dctx->sset))
-		return -ENOKEY;
-
-	poly1305_final_arch(dctx, dst);
+	poly1305_update_arch(dctx, src, srclen);
 	return 0;
 }
 
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
+static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	poly1305_update_arch(dctx, src, srclen);
+	if (unlikely(!dctx->sset))
+		return -ENOKEY;
+
+	poly1305_final_arch(dctx, dst);
 	return 0;
 }
 
 static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
 	.init		= crypto_poly1305_init,
-	.update		= poly1305_simd_update,
+	.update		= crypto_poly1305_update,
 	.final		= crypto_poly1305_final,
 	.descsize	= sizeof(struct poly1305_desc_ctx),
 	.base		= {
@@ -406,17 +265,19 @@ static struct shash_alg alg = {
 
 static int __init poly1305_simd_mod_init(void)
 {
-	if (!boot_cpu_has(X86_FEATURE_XMM2))
-		return 0;
-
-	static_branch_enable(&poly1305_use_simd);
-
-	if (IS_ENABLED(CONFIG_AS_AVX2) &&
-	    boot_cpu_has(X86_FEATURE_AVX) &&
+	if (IS_ENABLED(CONFIG_AS_AVX) && boot_cpu_has(X86_FEATURE_AVX) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		static_branch_enable(&poly1305_use_avx);
+	if (IS_ENABLED(CONFIG_AS_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		static_branch_enable(&poly1305_use_avx2);
-
+	if (IS_ENABLED(CONFIG_AS_AVX512) && boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX512F) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL) &&
+	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
+	    boot_cpu_data.x86_model != INTEL_FAM6_SKYLAKE_X)
+		static_branch_enable(&poly1305_use_avx512);
 	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ? crypto_register_shash(&alg) : 0;
 }
 
@@ -430,7 +291,7 @@ module_init(poly1305_simd_mod_init);
 module_exit(poly1305_simd_mod_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
 MODULE_DESCRIPTION("Poly1305 authenticator");
 MODULE_ALIAS_CRYPTO("poly1305");
 MODULE_ALIAS_CRYPTO("poly1305-simd");
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 2d4a8f385e62..c2f4a2ea41d7 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -90,7 +90,7 @@ config CRYPTO_LIB_DES
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
 	default 2 if MIPS
-	default 4 if X86_64
+	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 2
 
-- 
2.24.0


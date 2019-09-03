Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8234CC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5375821881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LruIlOMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbfICQns (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44404 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQns (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so9438249pgl.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u8c7yjt2nGuO09VOjn5Nf28VuKqSVZEi1e4/jRpqUrQ=;
        b=LruIlOMVykumLE+Kn6REj/Kf6l4eAtnBxB2V4x2mog96vRfdjUQBvf7OHYCdaHyENd
         kX9IQKJ+BO11dvgIhjAfniDZPoip7cZWQ+fHmPH2U3zXA6FZhv91+VXKDNORi5da2cCQ
         VtwYMkv1peXXk1AgLqkhEjfR2eYFCVOqIG+L9K1H7m8U4YvsWXUWf6knPZig3SYpHRUc
         gNxRZQlFH7h6ThgktlnF+0hbBJhItD3dpa58XjB5X0Z77senmUP66bUw+SJFhiqSKv9B
         0H+yiNuNBi0W5bYK5lSOPIHCTi1rhUxHgJRKXhVwhtA2Ofh4taOHACKM2nv3ox0518dz
         2GnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u8c7yjt2nGuO09VOjn5Nf28VuKqSVZEi1e4/jRpqUrQ=;
        b=XUDqgV9R+8Y/Nh9jbokGXeXXC7C/79RW05GXgyRPeRJdYL8AOa1+wk+HOG8osCsdqN
         Fi10aAfOZiteOgqYwMW/04TdNzj2ilV3Ala8PG5IDPkeiEsVr0jYqGW5FW6VpHf6vvxN
         ZI8k1nAEGftiZCs1xjUB6UVXA8kW5TxnWeFnB1KoxTiJjtSVi9STCuUCs15WdZ9E8+rH
         /xO6cn0yxHDMt6myk1OmVcqMmMDzNAu3gC8V/IqYaxdUxgbSs5L3V5UehFfFW2u41JKD
         mQE34Se8F2yIROO18nf7temUcbmIjt7Y61a0QFUpCA8uk2IBVWnHBIpVA8Dxt/7nIxo2
         ASxA==
X-Gm-Message-State: APjAAAWk9AEdX9psrQ7Ujmjnb/FiNE0YQE8riniglqx1hDl2Recm0jRo
        OE5kvB6eWUZYceXJX+9N1jyJZUH3hRIpCeeQ
X-Google-Smtp-Source: APXvYqysJFRuAdws0qiUqgeqgn7SCWoWwHP3sXrqYYbgv3Hoj0krpMbegYUR4zn6gBFNanysHyKIFA==
X-Received: by 2002:a63:1d0e:: with SMTP id d14mr31231670pgd.324.1567529027447;
        Tue, 03 Sep 2019 09:43:47 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 03/17] crypto: arm/aes-ce - switch to 4x interleave
Date:   Tue,  3 Sep 2019 09:43:25 -0700
Message-Id: <20190903164339.27984-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the ARM AES instruction based crypto driver was introduced, there
were no known implementations that could benefit from a 4-way interleave,
and so a 3-way interleave was used instead. Since we have sufficient
space in the SIMD register file, let's switch to a 4-way interleave to
align with the 64-bit driver, and to ensure that we can reach optimum
performance when running under emulation on high end 64-bit cores.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 263 +++++++++++---------
 1 file changed, 144 insertions(+), 119 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 1e0d45183590..a3ca4ac2d7bb 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -44,46 +44,56 @@
 	veor		q0, q0, \key3
 	.endm
 
-	.macro		enc_dround_3x, key1, key2
+	.macro		enc_dround_4x, key1, key2
 	enc_round	q0, \key1
 	enc_round	q1, \key1
 	enc_round	q2, \key1
+	enc_round	q3, \key1
 	enc_round	q0, \key2
 	enc_round	q1, \key2
 	enc_round	q2, \key2
+	enc_round	q3, \key2
 	.endm
 
-	.macro		dec_dround_3x, key1, key2
+	.macro		dec_dround_4x, key1, key2
 	dec_round	q0, \key1
 	dec_round	q1, \key1
 	dec_round	q2, \key1
+	dec_round	q3, \key1
 	dec_round	q0, \key2
 	dec_round	q1, \key2
 	dec_round	q2, \key2
+	dec_round	q3, \key2
 	.endm
 
-	.macro		enc_fround_3x, key1, key2, key3
+	.macro		enc_fround_4x, key1, key2, key3
 	enc_round	q0, \key1
 	enc_round	q1, \key1
 	enc_round	q2, \key1
+	enc_round	q3, \key1
 	aese.8		q0, \key2
 	aese.8		q1, \key2
 	aese.8		q2, \key2
+	aese.8		q3, \key2
 	veor		q0, q0, \key3
 	veor		q1, q1, \key3
 	veor		q2, q2, \key3
+	veor		q3, q3, \key3
 	.endm
 
-	.macro		dec_fround_3x, key1, key2, key3
+	.macro		dec_fround_4x, key1, key2, key3
 	dec_round	q0, \key1
 	dec_round	q1, \key1
 	dec_round	q2, \key1
+	dec_round	q3, \key1
 	aesd.8		q0, \key2
 	aesd.8		q1, \key2
 	aesd.8		q2, \key2
+	aesd.8		q3, \key2
 	veor		q0, q0, \key3
 	veor		q1, q1, \key3
 	veor		q2, q2, \key3
+	veor		q3, q3, \key3
 	.endm
 
 	.macro		do_block, dround, fround
@@ -114,8 +124,9 @@
 	 * transforms. These should preserve all registers except q0 - q2 and ip
 	 * Arguments:
 	 *   q0        : first in/output block
-	 *   q1        : second in/output block (_3x version only)
-	 *   q2        : third in/output block (_3x version only)
+	 *   q1        : second in/output block (_4x version only)
+	 *   q2        : third in/output block (_4x version only)
+	 *   q3        : fourth in/output block (_4x version only)
 	 *   q8        : first round key
 	 *   q9        : secound round key
 	 *   q14       : final round key
@@ -136,16 +147,16 @@ aes_decrypt:
 ENDPROC(aes_decrypt)
 
 	.align		6
-aes_encrypt_3x:
+aes_encrypt_4x:
 	add		ip, r2, #32		@ 3rd round key
-	do_block	enc_dround_3x, enc_fround_3x
-ENDPROC(aes_encrypt_3x)
+	do_block	enc_dround_4x, enc_fround_4x
+ENDPROC(aes_encrypt_4x)
 
 	.align		6
-aes_decrypt_3x:
+aes_decrypt_4x:
 	add		ip, r2, #32		@ 3rd round key
-	do_block	dec_dround_3x, dec_fround_3x
-ENDPROC(aes_decrypt_3x)
+	do_block	dec_dround_4x, dec_fround_4x
+ENDPROC(aes_decrypt_4x)
 
 	.macro		prepare_key, rk, rounds
 	add		ip, \rk, \rounds, lsl #4
@@ -163,17 +174,17 @@ ENTRY(ce_aes_ecb_encrypt)
 	push		{r4, lr}
 	ldr		r4, [sp, #8]
 	prepare_key	r2, r3
-.Lecbencloop3x:
-	subs		r4, r4, #3
+.Lecbencloop4x:
+	subs		r4, r4, #4
 	bmi		.Lecbenc1x
 	vld1.8		{q0-q1}, [r1]!
-	vld1.8		{q2}, [r1]!
-	bl		aes_encrypt_3x
+	vld1.8		{q2-q3}, [r1]!
+	bl		aes_encrypt_4x
 	vst1.8		{q0-q1}, [r0]!
-	vst1.8		{q2}, [r0]!
-	b		.Lecbencloop3x
+	vst1.8		{q2-q3}, [r0]!
+	b		.Lecbencloop4x
 .Lecbenc1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lecbencout
 .Lecbencloop:
 	vld1.8		{q0}, [r1]!
@@ -189,17 +200,17 @@ ENTRY(ce_aes_ecb_decrypt)
 	push		{r4, lr}
 	ldr		r4, [sp, #8]
 	prepare_key	r2, r3
-.Lecbdecloop3x:
-	subs		r4, r4, #3
+.Lecbdecloop4x:
+	subs		r4, r4, #4
 	bmi		.Lecbdec1x
 	vld1.8		{q0-q1}, [r1]!
-	vld1.8		{q2}, [r1]!
-	bl		aes_decrypt_3x
+	vld1.8		{q2-q3}, [r1]!
+	bl		aes_decrypt_4x
 	vst1.8		{q0-q1}, [r0]!
-	vst1.8		{q2}, [r0]!
-	b		.Lecbdecloop3x
+	vst1.8		{q2-q3}, [r0]!
+	b		.Lecbdecloop4x
 .Lecbdec1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lecbdecout
 .Lecbdecloop:
 	vld1.8		{q0}, [r1]!
@@ -236,38 +247,40 @@ ENDPROC(ce_aes_cbc_encrypt)
 ENTRY(ce_aes_cbc_decrypt)
 	push		{r4-r6, lr}
 	ldrd		r4, r5, [sp, #16]
-	vld1.8		{q6}, [r5]		@ keep iv in q6
+	vld1.8		{q15}, [r5]		@ keep iv in q15
 	prepare_key	r2, r3
-.Lcbcdecloop3x:
-	subs		r4, r4, #3
+.Lcbcdecloop4x:
+	subs		r4, r4, #4
 	bmi		.Lcbcdec1x
 	vld1.8		{q0-q1}, [r1]!
-	vld1.8		{q2}, [r1]!
-	vmov		q3, q0
-	vmov		q4, q1
-	vmov		q5, q2
-	bl		aes_decrypt_3x
-	veor		q0, q0, q6
-	veor		q1, q1, q3
-	veor		q2, q2, q4
-	vmov		q6, q5
+	vld1.8		{q2-q3}, [r1]!
+	vmov		q4, q0
+	vmov		q5, q1
+	vmov		q6, q2
+	vmov		q7, q3
+	bl		aes_decrypt_4x
+	veor		q0, q0, q15
+	veor		q1, q1, q4
+	veor		q2, q2, q5
+	veor		q3, q3, q6
+	vmov		q15, q7
 	vst1.8		{q0-q1}, [r0]!
-	vst1.8		{q2}, [r0]!
-	b		.Lcbcdecloop3x
+	vst1.8		{q2-q3}, [r0]!
+	b		.Lcbcdecloop4x
 .Lcbcdec1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lcbcdecout
-	vmov		q15, q14		@ preserve last round key
+	vmov		q6, q14			@ preserve last round key
 .Lcbcdecloop:
 	vld1.8		{q0}, [r1]!		@ get next ct block
 	veor		q14, q15, q6		@ combine prev ct with last key
-	vmov		q6, q0
+	vmov		q15, q0
 	bl		aes_decrypt
 	vst1.8		{q0}, [r0]!
 	subs		r4, r4, #1
 	bne		.Lcbcdecloop
 .Lcbcdecout:
-	vst1.8		{q6}, [r5]		@ keep iv in q6
+	vst1.8		{q15}, [r5]		@ keep iv in q15
 	pop		{r4-r6, pc}
 ENDPROC(ce_aes_cbc_decrypt)
 
@@ -278,46 +291,52 @@ ENDPROC(ce_aes_cbc_decrypt)
 ENTRY(ce_aes_ctr_encrypt)
 	push		{r4-r6, lr}
 	ldrd		r4, r5, [sp, #16]
-	vld1.8		{q6}, [r5]		@ load ctr
+	vld1.8		{q7}, [r5]		@ load ctr
 	prepare_key	r2, r3
-	vmov		r6, s27			@ keep swabbed ctr in r6
+	vmov		r6, s31			@ keep swabbed ctr in r6
 	rev		r6, r6
 	cmn		r6, r4			@ 32 bit overflow?
 	bcs		.Lctrloop
-.Lctrloop3x:
-	subs		r4, r4, #3
+.Lctrloop4x:
+	subs		r4, r4, #4
 	bmi		.Lctr1x
 	add		r6, r6, #1
-	vmov		q0, q6
-	vmov		q1, q6
+	vmov		q0, q7
+	vmov		q1, q7
 	rev		ip, r6
 	add		r6, r6, #1
-	vmov		q2, q6
+	vmov		q2, q7
 	vmov		s7, ip
 	rev		ip, r6
 	add		r6, r6, #1
+	vmov		q3, q7
 	vmov		s11, ip
-	vld1.8		{q3-q4}, [r1]!
-	vld1.8		{q5}, [r1]!
-	bl		aes_encrypt_3x
-	veor		q0, q0, q3
-	veor		q1, q1, q4
-	veor		q2, q2, q5
+	rev		ip, r6
+	add		r6, r6, #1
+	vmov		s15, ip
+	vld1.8		{q4-q5}, [r1]!
+	vld1.8		{q6}, [r1]!
+	vld1.8		{q15}, [r1]!
+	bl		aes_encrypt_4x
+	veor		q0, q0, q4
+	veor		q1, q1, q5
+	veor		q2, q2, q6
+	veor		q3, q3, q15
 	rev		ip, r6
 	vst1.8		{q0-q1}, [r0]!
-	vst1.8		{q2}, [r0]!
-	vmov		s27, ip
-	b		.Lctrloop3x
+	vst1.8		{q2-q3}, [r0]!
+	vmov		s31, ip
+	b		.Lctrloop4x
 .Lctr1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lctrout
 .Lctrloop:
-	vmov		q0, q6
+	vmov		q0, q7
 	bl		aes_encrypt
 
 	adds		r6, r6, #1		@ increment BE ctr
 	rev		ip, r6
-	vmov		s27, ip
+	vmov		s31, ip
 	bcs		.Lctrcarry
 
 .Lctrcarrydone:
@@ -329,7 +348,7 @@ ENTRY(ce_aes_ctr_encrypt)
 	bne		.Lctrloop
 
 .Lctrout:
-	vst1.8		{q6}, [r5]		@ return next CTR value
+	vst1.8		{q7}, [r5]		@ return next CTR value
 	pop		{r4-r6, pc}
 
 .Lctrtailblock:
@@ -337,7 +356,7 @@ ENTRY(ce_aes_ctr_encrypt)
 	b		.Lctrout
 
 .Lctrcarry:
-	.irp		sreg, s26, s25, s24
+	.irp		sreg, s30, s29, s28
 	vmov		ip, \sreg		@ load next word of ctr
 	rev		ip, ip			@ ... to handle the carry
 	adds		ip, ip, #1
@@ -368,8 +387,8 @@ ENDPROC(ce_aes_ctr_encrypt)
 	.quad		1, 0x87
 
 ce_aes_xts_init:
-	vldr		d14, .Lxts_mul_x
-	vldr		d15, .Lxts_mul_x + 8
+	vldr		d30, .Lxts_mul_x
+	vldr		d31, .Lxts_mul_x + 8
 
 	ldrd		r4, r5, [sp, #16]	@ load args
 	ldr		r6, [sp, #28]
@@ -390,48 +409,51 @@ ENTRY(ce_aes_xts_encrypt)
 
 	bl		ce_aes_xts_init		@ run shared prologue
 	prepare_key	r2, r3
-	vmov		q3, q0
+	vmov		q4, q0
 
 	teq		r6, #0			@ start of a block?
-	bne		.Lxtsenc3x
+	bne		.Lxtsenc4x
 
-.Lxtsencloop3x:
-	next_tweak	q3, q3, q7, q6
-.Lxtsenc3x:
-	subs		r4, r4, #3
+.Lxtsencloop4x:
+	next_tweak	q4, q4, q15, q10
+.Lxtsenc4x:
+	subs		r4, r4, #4
 	bmi		.Lxtsenc1x
-	vld1.8		{q0-q1}, [r1]!		@ get 3 pt blocks
-	vld1.8		{q2}, [r1]!
-	next_tweak	q4, q3, q7, q6
-	veor		q0, q0, q3
-	next_tweak	q5, q4, q7, q6
-	veor		q1, q1, q4
-	veor		q2, q2, q5
-	bl		aes_encrypt_3x
-	veor		q0, q0, q3
-	veor		q1, q1, q4
-	veor		q2, q2, q5
-	vst1.8		{q0-q1}, [r0]!		@ write 3 ct blocks
-	vst1.8		{q2}, [r0]!
-	vmov		q3, q5
+	vld1.8		{q0-q1}, [r1]!		@ get 4 pt blocks
+	vld1.8		{q2-q3}, [r1]!
+	next_tweak	q5, q4, q15, q10
+	veor		q0, q0, q4
+	next_tweak	q6, q5, q15, q10
+	veor		q1, q1, q5
+	next_tweak	q7, q6, q15, q10
+	veor		q2, q2, q6
+	veor		q3, q3, q7
+	bl		aes_encrypt_4x
+	veor		q0, q0, q4
+	veor		q1, q1, q5
+	veor		q2, q2, q6
+	veor		q3, q3, q7
+	vst1.8		{q0-q1}, [r0]!		@ write 4 ct blocks
+	vst1.8		{q2-q3}, [r0]!
+	vmov		q4, q7
 	teq		r4, #0
 	beq		.Lxtsencout
-	b		.Lxtsencloop3x
+	b		.Lxtsencloop4x
 .Lxtsenc1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lxtsencout
 .Lxtsencloop:
 	vld1.8		{q0}, [r1]!
-	veor		q0, q0, q3
+	veor		q0, q0, q4
 	bl		aes_encrypt
-	veor		q0, q0, q3
+	veor		q0, q0, q4
 	vst1.8		{q0}, [r0]!
 	subs		r4, r4, #1
 	beq		.Lxtsencout
-	next_tweak	q3, q3, q7, q6
+	next_tweak	q4, q4, q15, q6
 	b		.Lxtsencloop
 .Lxtsencout:
-	vst1.8		{q3}, [r5]
+	vst1.8		{q4}, [r5]
 	pop		{r4-r6, pc}
 ENDPROC(ce_aes_xts_encrypt)
 
@@ -441,49 +463,52 @@ ENTRY(ce_aes_xts_decrypt)
 
 	bl		ce_aes_xts_init		@ run shared prologue
 	prepare_key	r2, r3
-	vmov		q3, q0
+	vmov		q4, q0
 
 	teq		r6, #0			@ start of a block?
-	bne		.Lxtsdec3x
+	bne		.Lxtsdec4x
 
-.Lxtsdecloop3x:
-	next_tweak	q3, q3, q7, q6
-.Lxtsdec3x:
-	subs		r4, r4, #3
+.Lxtsdecloop4x:
+	next_tweak	q4, q4, q15, q10
+.Lxtsdec4x:
+	subs		r4, r4, #4
 	bmi		.Lxtsdec1x
-	vld1.8		{q0-q1}, [r1]!		@ get 3 ct blocks
-	vld1.8		{q2}, [r1]!
-	next_tweak	q4, q3, q7, q6
-	veor		q0, q0, q3
-	next_tweak	q5, q4, q7, q6
-	veor		q1, q1, q4
-	veor		q2, q2, q5
-	bl		aes_decrypt_3x
-	veor		q0, q0, q3
-	veor		q1, q1, q4
-	veor		q2, q2, q5
-	vst1.8		{q0-q1}, [r0]!		@ write 3 pt blocks
-	vst1.8		{q2}, [r0]!
-	vmov		q3, q5
+	vld1.8		{q0-q1}, [r1]!		@ get 4 ct blocks
+	vld1.8		{q2-q3}, [r1]!
+	next_tweak	q5, q4, q15, q10
+	veor		q0, q0, q4
+	next_tweak	q6, q5, q15, q10
+	veor		q1, q1, q5
+	next_tweak	q7, q6, q15, q10
+	veor		q2, q2, q6
+	veor		q3, q3, q7
+	bl		aes_decrypt_4x
+	veor		q0, q0, q4
+	veor		q1, q1, q5
+	veor		q2, q2, q6
+	veor		q3, q3, q7
+	vst1.8		{q0-q1}, [r0]!		@ write 4 pt blocks
+	vst1.8		{q2-q3}, [r0]!
+	vmov		q4, q7
 	teq		r4, #0
 	beq		.Lxtsdecout
-	b		.Lxtsdecloop3x
+	b		.Lxtsdecloop4x
 .Lxtsdec1x:
-	adds		r4, r4, #3
+	adds		r4, r4, #4
 	beq		.Lxtsdecout
 .Lxtsdecloop:
 	vld1.8		{q0}, [r1]!
-	veor		q0, q0, q3
+	veor		q0, q0, q4
 	add		ip, r2, #32		@ 3rd round key
 	bl		aes_decrypt
-	veor		q0, q0, q3
+	veor		q0, q0, q4
 	vst1.8		{q0}, [r0]!
 	subs		r4, r4, #1
 	beq		.Lxtsdecout
-	next_tweak	q3, q3, q7, q6
+	next_tweak	q4, q4, q15, q6
 	b		.Lxtsdecloop
 .Lxtsdecout:
-	vst1.8		{q3}, [r5]
+	vst1.8		{q4}, [r5]
 	pop		{r4-r6, pc}
 ENDPROC(ce_aes_xts_decrypt)
 
-- 
2.17.1


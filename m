Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71585C48BE8
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6FA20645
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bN+JTKg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbfFXRjX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:39:23 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51231 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfFXRjX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 13:39:23 -0400
Received: by mail-wm1-f48.google.com with SMTP id 207so199659wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 10:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNlQrDhTvmKworOs7YcRIZ4pDf2weoiPlXkzqH25+mU=;
        b=bN+JTKg+zSPN8uDKOndRtVWL54JBT3X8WQGqzvv/memssEIXhtymc+2ZWDvY3I1WiS
         uaXlD4dufvPc57Xs7b68RreyUj8HYSkbbI7mJn9FR6xFaK2UmsnirnGrWFrt1WcA0m8Z
         a+KKkwmRa3qkv7AdeUWOfUC1+R/VXQaLVMSXF6biGetfvonCjPRbZvlbI4B4Xsey1hYt
         ABuQZj9WVPEP+Sd6SpHCXpMjLYhNlyN4ZSdT9AYiekTzM69BtnPH0BGiSO//hZ+rn9BR
         nf3XRMg6E9rtLh6Ok6IiXOn/YMq+8aaxqf/RGfgD1DotM6cmAwM9wP4dTgkosDH0dxpi
         u5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNlQrDhTvmKworOs7YcRIZ4pDf2weoiPlXkzqH25+mU=;
        b=E+GyYEmSZq8Iospo5e71vF1ngxnTllKlBiIGUc8PBD6KYx/fciWxkY7DFROFf1A0C1
         NEtP1goyLiy1kBZVu8orqVplzc/dabRjsf+0k/2r9mz3y3lObdTUQ5EpyiH46suGWj/k
         ifcXhZuoJ4YawnAT1wIDJpTe2dz/vjOtBjjjb7JeBgyAFznEFnEP/TDOulrxlRnTBamE
         CPVwiprSU7F06h5Q6LGLbAlsqTYCqtXO3Yr/8wCd6j8THyW97UNo0A7DePBH/eLCMo4K
         62EHH/646+XLadzdHTgw7l8qRM1tBDTokRafJCjzhdgrNHE7yTRcnpWCYTQisrhicGvZ
         ASYQ==
X-Gm-Message-State: APjAAAVxEQoNYGZHHtGwDX/TPqnqZYEG5+28RszRzw26T2yw1UJcKjAU
        BYIoF2HJ9sr2GKqMYNUhmJ6sRLh04/I=
X-Google-Smtp-Source: APXvYqx7FPRTliQm/RRNyNE5TSp8T3pDn20l639cSOq0j5pFZ1nuC/Vnl0/2wZDUSn0o6Ex2qBRU8g==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr16500820wmg.155.1561397959982;
        Mon, 24 Jun 2019 10:39:19 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-10-211.w90-88.abo.wanadoo.fr. [90.88.131.211])
        by smtp.gmail.com with ESMTPSA id s10sm260787wmf.8.2019.06.24.10.39.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 10:39:19 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linux-arm-kernel@lists.infradead.org, steve.capper@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64/aes-ce - implement 5 way interleave for ECB, CBC and CTR
Date:   Mon, 24 Jun 2019 19:38:31 +0200
Message-Id: <20190624173831.8375-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624173831.8375-1-ard.biesheuvel@linaro.org>
References: <20190624173831.8375-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This implements 5-way interleaving for ECB, CBC decryption and CTR,
resulting in a speedup of ~11% on Marvell ThunderX2, which has a
very deep pipeline and therefore a high issue latency for NEON
instructions operating on the same registers.

Note that XTS is left alone: implementing 5-way interleave there
would either involve spilling of the calculated tweaks to the
stack, or recalculating them after the encryption operation, and
doing either of those would most likely penalize low end cores.

For ECB, this is not a concern at all, given that we have plenty
of spare registers. For CTR and CBC decryption, we take advantage
of the fact that v16 is not used by the CE version of the code
(which is the only one targeted by the optimization), and so we
can reshuffle the code a bit and avoid having to spill to memory
(with the exception of one extra reload in the CBC routine)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S    |   2 +
 arch/arm64/crypto/aes-modes.S | 102 ++++++++++++++------
 arch/arm64/crypto/aes-neon.S  |   2 +
 3 files changed, 75 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 0fca5f463406..dbfc04ea20c7 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -18,6 +18,8 @@
 	.arch		armv8-a+crypto
 
 	xtsmask		.req	v16
+	cbciv		.req	v16
+	vctr		.req	v16
 
 	.macro		xts_reload_mask, tmp
 	.endm
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 0dbeaf2ce9b1..42edc34e8f01 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -17,6 +17,14 @@
 #define MAX_STRIDE	4
 #endif
 
+#if MAX_STRIDE == 4
+#define ST4(x...) x
+#define ST5(x...)
+#else
+#define ST4(x...)
+#define ST5(x...) x
+#endif
+
 aes_encrypt_block4x:
 	encrypt_block4x	v0, v1, v2, v3, w3, x2, x8, w7
 	ret
@@ -53,14 +61,17 @@ AES_ENTRY(aes_ecb_encrypt)
 	enc_prepare	w3, x2, x5
 
 .LecbencloopNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #MAX_STRIDE
 	bmi		.Lecbenc1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
-	bl		aes_encrypt_block4x
+ST4(	bl		aes_encrypt_block4x		)
+ST5(	ld1		{v4.16b}, [x1], #16		)
+ST5(	bl		aes_encrypt_block5x		)
 	st1		{v0.16b-v3.16b}, [x0], #64
+ST5(	st1		{v4.16b}, [x0], #16		)
 	b		.LecbencloopNx
 .Lecbenc1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #MAX_STRIDE
 	beq		.Lecbencout
 .Lecbencloop:
 	ld1		{v0.16b}, [x1], #16		/* get next pt block */
@@ -81,14 +92,17 @@ AES_ENTRY(aes_ecb_decrypt)
 	dec_prepare	w3, x2, x5
 
 .LecbdecloopNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #MAX_STRIDE
 	bmi		.Lecbdec1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
-	bl		aes_decrypt_block4x
+ST4(	bl		aes_decrypt_block4x		)
+ST5(	ld1		{v4.16b}, [x1], #16		)
+ST5(	bl		aes_decrypt_block5x		)
 	st1		{v0.16b-v3.16b}, [x0], #64
+ST5(	st1		{v4.16b}, [x0], #16		)
 	b		.LecbdecloopNx
 .Lecbdec1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #MAX_STRIDE
 	beq		.Lecbdecout
 .Lecbdecloop:
 	ld1		{v0.16b}, [x1], #16		/* get next ct block */
@@ -148,39 +162,56 @@ AES_ENTRY(aes_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
-	ld1		{v7.16b}, [x5]			/* get iv */
+	ld1		{cbciv.16b}, [x5]		/* get iv */
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #MAX_STRIDE
 	bmi		.Lcbcdec1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
+#if MAX_STRIDE == 5
+	ld1		{v4.16b}, [x1], #16		/* get 1 ct block */
+	mov		v5.16b, v0.16b
+	mov		v6.16b, v1.16b
+	mov		v7.16b, v2.16b
+	bl		aes_decrypt_block5x
+	sub		x1, x1, #32
+	eor		v0.16b, v0.16b, cbciv.16b
+	eor		v1.16b, v1.16b, v5.16b
+	ld1		{v5.16b}, [x1], #16		/* reload 1 ct block */
+	ld1		{cbciv.16b}, [x1], #16		/* reload 1 ct block */
+	eor		v2.16b, v2.16b, v6.16b
+	eor		v3.16b, v3.16b, v7.16b
+	eor		v4.16b, v4.16b, v5.16b
+#else
 	mov		v4.16b, v0.16b
 	mov		v5.16b, v1.16b
 	mov		v6.16b, v2.16b
 	bl		aes_decrypt_block4x
 	sub		x1, x1, #16
-	eor		v0.16b, v0.16b, v7.16b
+	eor		v0.16b, v0.16b, cbciv.16b
 	eor		v1.16b, v1.16b, v4.16b
-	ld1		{v7.16b}, [x1], #16		/* reload 1 ct block */
+	ld1		{cbciv.16b}, [x1], #16		/* reload 1 ct block */
 	eor		v2.16b, v2.16b, v5.16b
 	eor		v3.16b, v3.16b, v6.16b
+#endif
 	st1		{v0.16b-v3.16b}, [x0], #64
+ST5(	st1		{v4.16b}, [x0], #16		)
 	b		.LcbcdecloopNx
 .Lcbcdec1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #MAX_STRIDE
 	beq		.Lcbcdecout
 .Lcbcdecloop:
 	ld1		{v1.16b}, [x1], #16		/* get next ct block */
 	mov		v0.16b, v1.16b			/* ...and copy to v0 */
 	decrypt_block	v0, w3, x2, x6, w7
-	eor		v0.16b, v0.16b, v7.16b		/* xor with iv => pt */
-	mov		v7.16b, v1.16b			/* ct is next iv */
+	eor		v0.16b, v0.16b, cbciv.16b	/* xor with iv => pt */
+	mov		cbciv.16b, v1.16b		/* ct is next iv */
 	st1		{v0.16b}, [x0], #16
 	subs		w4, w4, #1
 	bne		.Lcbcdecloop
 .Lcbcdecout:
-	st1		{v7.16b}, [x5]			/* return iv */
+	st1		{cbciv.16b}, [x5]		/* return iv */
 	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
@@ -373,51 +404,60 @@ AES_ENTRY(aes_ctr_encrypt)
 	mov		x29, sp
 
 	enc_prepare	w3, x2, x6
-	ld1		{v4.16b}, [x5]
+	ld1		{vctr.16b}, [x5]
 
-	umov		x6, v4.d[1]		/* keep swabbed ctr in reg */
+	umov		x6, vctr.d[1]		/* keep swabbed ctr in reg */
 	rev		x6, x6
 	cmn		w6, w4			/* 32 bit overflow? */
 	bcs		.Lctrloop
 .LctrloopNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #MAX_STRIDE
 	bmi		.Lctr1x
 	add		w7, w6, #1
-	mov		v0.16b, v4.16b
+	mov		v0.16b, vctr.16b
 	add		w8, w6, #2
-	mov		v1.16b, v4.16b
+	mov		v1.16b, vctr.16b
+	add		w9, w6, #3
+	mov		v2.16b, vctr.16b
 	add		w9, w6, #3
-	mov		v2.16b, v4.16b
 	rev		w7, w7
-	mov		v3.16b, v4.16b
+	mov		v3.16b, vctr.16b
 	rev		w8, w8
+ST5(	mov		v4.16b, vctr.16b		)
 	mov		v1.s[3], w7
 	rev		w9, w9
+ST5(	add		w10, w6, #4			)
 	mov		v2.s[3], w8
+ST5(	rev		w10, w10			)
 	mov		v3.s[3], w9
+ST5(	mov		v4.s[3], w10			)
 	ld1		{v5.16b-v7.16b}, [x1], #48	/* get 3 input blocks */
-	bl		aes_encrypt_block4x
+ST4(	bl		aes_encrypt_block4x		)
+ST5(	bl		aes_encrypt_block5x		)
 	eor		v0.16b, v5.16b, v0.16b
-	ld1		{v5.16b}, [x1], #16		/* get 1 input block  */
+ST4(	ld1		{v5.16b}, [x1], #16		)
 	eor		v1.16b, v6.16b, v1.16b
+ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
+ST5(	eor		v4.16b, v6.16b, v4.16b		)
 	st1		{v0.16b-v3.16b}, [x0], #64
-	add		x6, x6, #4
+ST5(	st1		{v4.16b}, [x0], #16		)
+	add		x6, x6, #MAX_STRIDE
 	rev		x7, x6
-	ins		v4.d[1], x7
+	ins		vctr.d[1], x7
 	cbz		w4, .Lctrout
 	b		.LctrloopNx
 .Lctr1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #MAX_STRIDE
 	beq		.Lctrout
 .Lctrloop:
-	mov		v0.16b, v4.16b
+	mov		v0.16b, vctr.16b
 	encrypt_block	v0, w3, x2, x8, w7
 
 	adds		x6, x6, #1		/* increment BE ctr */
 	rev		x7, x6
-	ins		v4.d[1], x7
+	ins		vctr.d[1], x7
 	bcs		.Lctrcarry		/* overflow? */
 
 .Lctrcarrydone:
@@ -429,7 +469,7 @@ AES_ENTRY(aes_ctr_encrypt)
 	bne		.Lctrloop
 
 .Lctrout:
-	st1		{v4.16b}, [x5]		/* return next CTR value */
+	st1		{vctr.16b}, [x5]	/* return next CTR value */
 	ldp		x29, x30, [sp], #16
 	ret
 
@@ -438,11 +478,11 @@ AES_ENTRY(aes_ctr_encrypt)
 	b		.Lctrout
 
 .Lctrcarry:
-	umov		x7, v4.d[0]		/* load upper word of ctr  */
+	umov		x7, vctr.d[0]		/* load upper word of ctr  */
 	rev		x7, x7			/* ... to handle the carry */
 	add		x7, x7, #1
 	rev		x7, x7
-	ins		v4.d[0], x7
+	ins		vctr.d[0], x7
 	b		.Lctrcarrydone
 AES_ENDPROC(aes_ctr_encrypt)
 
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 33bb6af309a3..8bd66a6c4749 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -15,6 +15,8 @@
 #define AES_ENDPROC(func)	ENDPROC(neon_ ## func)
 
 	xtsmask		.req	v7
+	cbciv		.req	v7
+	vctr		.req	v4
 
 	.macro		xts_reload_mask, tmp
 	xts_load_mask	\tmp
-- 
2.20.1


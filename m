Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA6DC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 17:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352983AbiDLRa5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358136AbiDLRaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 13:30:55 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F099F54BDA
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:35 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id w24-20020ab06518000000b0035d1e9751easo5135742uam.13
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 10:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6iz/7Ye5kn72lPb0F+3c20rQ2PMxA7Ok6mrZRLWGz9U=;
        b=pZojZgENJf1XOSpVFHadhKKFlCr3S59SZS1Sg6XMfSZZsQdNjqRUUz8VYjqr9VpZzz
         ccXlEfAWAgz2phgXImUGJTFIHJgAd/g7ibieLEBhKosh22FrG4yR5A05Alo6D5F7EP49
         Y/65ohD9G0d7llOTsVQd8uG6X+Q4J9xv15Q3N8q1NAoPX1ZUpaYZHSyAcF1zGxMSw81B
         uhBGhpU+idHX3ro8R4vOrN2CIIGu12JK+7tRVQj0X4tee8IuGk3AKKxMhdHjTbnIIz5l
         3XNalOsABNgH9nTDZrR7bbVn57UOBce4F3B7e8PH4UhdqVei+SBxRfXI1GWwX9Xx3ecW
         T/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6iz/7Ye5kn72lPb0F+3c20rQ2PMxA7Ok6mrZRLWGz9U=;
        b=7+7Suef7C0Bd9NmbrnCKBKb1AOQAirqKr9SlWyWlXL4uG7hdmJQYJpIzXkPBcLv0KD
         joDzhCeRdxumIkSdccXr3U3QbWOLULrYJ5wrBVzPKa4k6aKlD0DDnRE9zEtzIejisczw
         Jg2aF1fNA05TBe53HwYg9RHOnA3lovaArIqfs8PzXeX0LNr+TnXRIwhJvJUdRiVoyEnZ
         mOElXcYMvic2bEYUMnJOio1Q9RWAP1FtgmKO5/ErPcUghxXbI3B+4SZo+HB+7nFWZNfk
         KZ92yRir1DCmipryAWOa7LWLBV7KegyvV+pT3d/wTJq4T5syGWtFyh57+bRQwXFQcNsQ
         gQ+A==
X-Gm-Message-State: AOAM533UCQgPN5RE6lNe0NfKOJjyt46+Kj+BcDVzNghEeGOKm+AW9Emw
        VDiT0mqC8aUaA7ygVGXDhoFLyGZUL9WvWF+tjZJuQ1F8LDBJRo7W5Ls38CJLTx9hJqLIEurhfTa
        oOjIabinvt1+O55JXdvgB7S3wNhoWp9OLcaC6hXm18FBB4IcMmBIUsG/NAiikhQG4vng=
X-Google-Smtp-Source: ABdhPJw7Y/Nko35rjsVbDNcZT3pXQOI4AhpuO1bTFA+7KTOj9LkJWk8JnCRDz6sH6KI5z+ByYIwvmoBHVQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6102:3ed0:b0:319:dfd2:89d5 with SMTP id
 n16-20020a0561023ed000b00319dfd289d5mr11900426vsv.45.1649784515025; Tue, 12
 Apr 2022 10:28:35 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:28:12 +0000
In-Reply-To: <20220412172816.917723-1-nhuck@google.com>
Message-Id: <20220412172816.917723-5-nhuck@google.com>
Mime-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 4/8] crypto: x86/aesni-xctr: Add accelerated implementation
 of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
support.  These implementations are modified versions of the CTR
implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.

More information on XCTR can be found in the HCTR2 paper:
Length-preserving encryption with HCTR2:
https://enterprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 233 ++++++++++++++++--------
 arch/x86/crypto/aesni-intel_asm.S       |  70 +++++++
 arch/x86/crypto/aesni-intel_glue.c      |  89 +++++++++
 crypto/Kconfig                          |   2 +-
 4 files changed, 317 insertions(+), 77 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index 43852ba6e19c..9e20d7d3d6da 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -53,6 +53,10 @@
 #define KEY_192		2
 #define KEY_256		3
 
+// XCTR mode only
+#define counter		%r9
+#define xiv		%xmm8
+
 .section .rodata
 .align 16
 
@@ -102,38 +106,67 @@ ddq_add_8:
  * do_aes num_in_par load_keys key_len
  * This increments p_in, but not p_out
  */
-.macro do_aes b, k, key_len
+.macro do_aes b, k, key_len, xctr
 	.set by, \b
 	.set load_keys, \k
 	.set klen, \key_len
 
+	.if (\xctr == 1)
+		.set i, 0
+		.rept (by)
+			club XDATA, i
+			movq counter, var_xdata
+			.set i, (i +1)
+		.endr
+	.endif
+
 	.if (load_keys)
 		vmovdqa	0*16(p_keys), xkey0
 	.endif
 
-	vpshufb	xbyteswap, xcounter, xdata0
-
-	.set i, 1
-	.rept (by - 1)
-		club XDATA, i
-		vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
-		vptest	ddq_low_msk(%rip), var_xdata
-		jnz 1f
-		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
-		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-		1:
-		vpshufb	xbyteswap, var_xdata, var_xdata
-		.set i, (i +1)
-	.endr
+	.if (\xctr == 0)
+		vpshufb	xbyteswap, xcounter, xdata0
+		.set i, 1
+		.rept (by - 1)
+			club XDATA, i
+			vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
+			vptest	ddq_low_msk(%rip), var_xdata
+			jnz 1f
+			vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
+			vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+			1:
+			vpshufb	xbyteswap, var_xdata, var_xdata
+			.set i, (i +1)
+		.endr
+	.endif
+	.if (\xctr == 1)
+		.set i, 0
+		.rept (by)
+			club XDATA, i
+			vpaddq	(ddq_add_1 + 16 * i)(%rip), var_xdata, var_xdata
+			.set i, (i +1)
+		.endr
+		.set i, 0
+		.rept (by)
+			club	XDATA, i
+			vpxor	xiv, var_xdata, var_xdata
+			.set i, (i +1)
+		.endr
+	.endif
 
 	vmovdqa	1*16(p_keys), xkeyA
 
 	vpxor	xkey0, xdata0, xdata0
-	vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
-	vptest	ddq_low_msk(%rip), xcounter
-	jnz	1f
-	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-	1:
+	.if (\xctr == 0)
+		vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
+		vptest	ddq_low_msk(%rip), xcounter
+		jnz	1f
+		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+		1:
+	.endif
+	.if (\xctr == 1)
+		add $by, counter
+	.endif
 
 	.set i, 1
 	.rept (by - 1)
@@ -371,94 +404,101 @@ ddq_add_8:
 	.endr
 .endm
 
-.macro do_aes_load val, key_len
-	do_aes \val, 1, \key_len
+.macro do_aes_load val, key_len, xctr
+	do_aes \val, 1, \key_len, \xctr
 .endm
 
-.macro do_aes_noload val, key_len
-	do_aes \val, 0, \key_len
+.macro do_aes_noload val, key_len, xctr
+	do_aes \val, 0, \key_len, \xctr
 .endm
 
 /* main body of aes ctr load */
 
-.macro do_aes_ctrmain key_len
+.macro do_aes_ctrmain key_len, xctr
 	cmp	$16, num_bytes
-	jb	.Ldo_return2\key_len
+	jb	.Ldo_return2\xctr\key_len
 
 	vmovdqa	byteswap_const(%rip), xbyteswap
-	vmovdqu	(p_iv), xcounter
-	vpshufb	xbyteswap, xcounter, xcounter
+	.if (\xctr == 0)
+		vmovdqu	(p_iv), xcounter
+		vpshufb	xbyteswap, xcounter, xcounter
+	.endif
+	.if (\xctr == 1)
+		andq	$(~0xf), num_bytes
+		shr	$4, counter
+		vmovdqu	(p_iv), xiv
+	.endif
 
 	mov	num_bytes, tmp
 	and	$(7*16), tmp
-	jz	.Lmult_of_8_blks\key_len
+	jz	.Lmult_of_8_blks\xctr\key_len
 
 	/* 1 <= tmp <= 7 */
 	cmp	$(4*16), tmp
-	jg	.Lgt4\key_len
-	je	.Leq4\key_len
+	jg	.Lgt4\xctr\key_len
+	je	.Leq4\xctr\key_len
 
-.Llt4\key_len:
+.Llt4\xctr\key_len:
 	cmp	$(2*16), tmp
-	jg	.Leq3\key_len
-	je	.Leq2\key_len
+	jg	.Leq3\xctr\key_len
+	je	.Leq2\xctr\key_len
 
-.Leq1\key_len:
-	do_aes_load	1, \key_len
+.Leq1\xctr\key_len:
+	do_aes_load	1, \key_len, \xctr
 	add	$(1*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq2\key_len:
-	do_aes_load	2, \key_len
+.Leq2\xctr\key_len:
+	do_aes_load	2, \key_len, \xctr
 	add	$(2*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
 
-.Leq3\key_len:
-	do_aes_load	3, \key_len
+.Leq3\xctr\key_len:
+	do_aes_load	3, \key_len, \xctr
 	add	$(3*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq4\key_len:
-	do_aes_load	4, \key_len
+.Leq4\xctr\key_len:
+	do_aes_load	4, \key_len, \xctr
 	add	$(4*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Lgt4\key_len:
+.Lgt4\xctr\key_len:
 	cmp	$(6*16), tmp
-	jg	.Leq7\key_len
-	je	.Leq6\key_len
+	jg	.Leq7\xctr\key_len
+	je	.Leq6\xctr\key_len
 
-.Leq5\key_len:
-	do_aes_load	5, \key_len
+.Leq5\xctr\key_len:
+	do_aes_load	5, \key_len, \xctr
 	add	$(5*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq6\key_len:
-	do_aes_load	6, \key_len
+.Leq6\xctr\key_len:
+	do_aes_load	6, \key_len, \xctr
 	add	$(6*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq7\key_len:
-	do_aes_load	7, \key_len
+.Leq7\xctr\key_len:
+	do_aes_load	7, \key_len, \xctr
 	add	$(7*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Lmult_of_8_blks\key_len:
+.Lmult_of_8_blks\xctr\key_len:
 	.if (\key_len != KEY_128)
 		vmovdqa	0*16(p_keys), xkey0
 		vmovdqa	4*16(p_keys), xkey4
@@ -471,17 +511,19 @@ ddq_add_8:
 		vmovdqa	9*16(p_keys), xkey12
 	.endif
 .align 16
-.Lmain_loop2\key_len:
+.Lmain_loop2\xctr\key_len:
 	/* num_bytes is a multiple of 8 and >0 */
-	do_aes_noload	8, \key_len
+	do_aes_noload	8, \key_len, \xctr
 	add	$(8*16), p_out
 	sub	$(8*16), num_bytes
-	jne	.Lmain_loop2\key_len
+	jne	.Lmain_loop2\xctr\key_len
 
-.Ldo_return2\key_len:
-	/* return updated IV */
-	vpshufb	xbyteswap, xcounter, xcounter
-	vmovdqu	xcounter, (p_iv)
+.Ldo_return2\xctr\key_len:
+	.if (\xctr == 0)
+		/* return updated IV */
+		vpshufb	xbyteswap, xcounter, xcounter
+		vmovdqu	xcounter, (p_iv)
+	.endif
 	RET
 .endm
 
@@ -494,7 +536,7 @@ ddq_add_8:
  */
 SYM_FUNC_START(aes_ctr_enc_128_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_128
+	do_aes_ctrmain KEY_128 0
 
 SYM_FUNC_END(aes_ctr_enc_128_avx_by8)
 
@@ -507,7 +549,7 @@ SYM_FUNC_END(aes_ctr_enc_128_avx_by8)
  */
 SYM_FUNC_START(aes_ctr_enc_192_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_192
+	do_aes_ctrmain KEY_192 0
 
 SYM_FUNC_END(aes_ctr_enc_192_avx_by8)
 
@@ -520,6 +562,45 @@ SYM_FUNC_END(aes_ctr_enc_192_avx_by8)
  */
 SYM_FUNC_START(aes_ctr_enc_256_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_256
+	do_aes_ctrmain KEY_256 0
 
 SYM_FUNC_END(aes_ctr_enc_256_avx_by8)
+
+/*
+ * routine to do AES128 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_128_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_128_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_128 1
+
+SYM_FUNC_END(aes_xctr_enc_128_avx_by8)
+
+/*
+ * routine to do AES192 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_192_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_192_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_192 1
+
+SYM_FUNC_END(aes_xctr_enc_192_avx_by8)
+
+/*
+ * routine to do AES256 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_256_avx_by8(const u8 *in, const u8 *iv, const aes_ctx *keys, u8
+ * 			    *out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_256_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_256 1
+
+SYM_FUNC_END(aes_xctr_enc_256_avx_by8)
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 363699dd7220..ce17fe630150 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2821,6 +2821,76 @@ SYM_FUNC_END(aesni_ctr_enc)
 
 #endif
 
+#ifdef __x86_64__
+/*
+ * void aesni_xctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv, int byte_ctr)
+ */
+SYM_FUNC_START(aesni_xctr_enc)
+	FRAME_BEGIN
+	cmp $16, LEN
+	jb .Lxctr_ret
+	shr	$4, %arg6
+	movq %arg6, CTR
+	mov 480(KEYP), KLEN
+	movups (IVP), IV
+	cmp $64, LEN
+	jb .Lxctr_enc_loop1
+.align 4
+.Lxctr_enc_loop4:
+	movaps IV, STATE1
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE1, STATE1
+	movups (INP), IN1
+	movaps IV, STATE2
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE2, STATE2
+	movups 0x10(INP), IN2
+	movaps IV, STATE3
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE3, STATE3
+	movups 0x20(INP), IN3
+	movaps IV, STATE4
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE4, STATE4
+	movups 0x30(INP), IN4
+	call _aesni_enc4
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+	pxor IN2, STATE2
+	movups STATE2, 0x10(OUTP)
+	pxor IN3, STATE3
+	movups STATE3, 0x20(OUTP)
+	pxor IN4, STATE4
+	movups STATE4, 0x30(OUTP)
+	sub $64, LEN
+	add $64, INP
+	add $64, OUTP
+	cmp $64, LEN
+	jge .Lxctr_enc_loop4
+	cmp $16, LEN
+	jb .Lxctr_ret
+.align 4
+.Lxctr_enc_loop1:
+	movaps IV, STATE
+	vpaddq ONE(%rip), CTR, CTR
+	vpxor CTR, STATE1, STATE1
+	movups (INP), IN
+	call _aesni_enc1
+	pxor IN, STATE
+	movups STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lxctr_enc_loop1
+.Lxctr_ret:
+	FRAME_END
+	RET
+SYM_FUNC_END(aesni_xctr_enc)
+
+#endif
+
 .section	.rodata.cst16.gf128mul_x_ble_mask, "aM", @progbits, 16
 .align 16
 .Lgf128mul_x_ble_mask:
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 41901ba9d3a2..74021bd524b6 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -112,6 +112,11 @@ asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 DEFINE_STATIC_CALL(aesni_ctr_enc_tfm, aesni_ctr_enc);
 
+asmlinkage void aesni_xctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			       const u8 *in, unsigned int len, u8 *iv,
+			       unsigned int byte_ctr);
+DEFINE_STATIC_CALL(aesni_xctr_enc_tfm, aesni_xctr_enc);
+
 /* Scatter / Gather routines, with args similar to above */
 asmlinkage void aesni_gcm_init(void *ctx,
 			       struct gcm_context_data *gdata,
@@ -135,6 +140,16 @@ asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
 asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
+
+asmlinkage void aes_xctr_enc_128_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_192_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_256_avx_by8(const u8 *in, u8 *iv, void *keys, u8
+	*out, unsigned int num_bytes, unsigned int byte_ctr);
+
 /*
  * asmlinkage void aesni_gcm_init_avx_gen2()
  * gcm_data *my_ctx_data, context data
@@ -527,6 +542,61 @@ static int ctr_crypt(struct skcipher_request *req)
 	return err;
 }
 
+static void aesni_xctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out, const u8
+				   *in, unsigned int len, u8 *iv, unsigned int
+				   byte_ctr)
+{
+	if (ctx->key_length == AES_KEYSIZE_128)
+		aes_xctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else if (ctx->key_length == AES_KEYSIZE_192)
+		aes_xctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else
+		aes_xctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+}
+
+static int xctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	u8 keystream[AES_BLOCK_SIZE];
+	u8 ctr[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	unsigned int byte_ctr = 0;
+	int err;
+	__le32 ctr32;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while ((nbytes = walk.nbytes) > 0) {
+		kernel_fpu_begin();
+		if (nbytes & AES_BLOCK_MASK)
+			static_call(aesni_xctr_enc_tfm)(ctx, walk.dst.virt.addr,
+				walk.src.virt.addr, nbytes & AES_BLOCK_MASK,
+				walk.iv, byte_ctr);
+		nbytes &= ~AES_BLOCK_MASK;
+		byte_ctr += walk.nbytes - nbytes;
+
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			ctr32 = cpu_to_le32(byte_ctr / AES_BLOCK_SIZE + 1);
+			memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
+			crypto_xor(ctr, (u8 *)&ctr32, sizeof(ctr32));
+			aesni_enc(ctx, keystream, ctr);
+			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes -
+				       nbytes, walk.src.virt.addr + walk.nbytes
+				       - nbytes, keystream, nbytes);
+			byte_ctr += nbytes;
+			nbytes = 0;
+		}
+		kernel_fpu_end();
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+	return err;
+}
+
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
@@ -1026,6 +1096,23 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
+	}, {
+		.base = {
+			.cra_name		= "__xctr(aes)",
+			.cra_driver_name	= "__xctr-aes-aesni",
+			.cra_priority		= 400,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.setkey		= aesni_skcipher_setkey,
+		.encrypt	= xctr_crypt,
+		.decrypt	= xctr_crypt,
 #endif
 	}, {
 		.base = {
@@ -1162,6 +1249,8 @@ static int __init aesni_init(void)
 		/* optimize performance of ctr mode encryption transform */
 		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
+		static_call_update(aesni_xctr_enc_tfm, aesni_xctr_enc_avx_tfm);
+		pr_info("AES XCTR mode by8 optimization enabled\n");
 	}
 #endif
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0dedba74db4a..aa06af0e0ebe 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1161,7 +1161,7 @@ config CRYPTO_AES_NI_INTEL
 	  In addition to AES cipher algorithm support, the acceleration
 	  for some popular block cipher mode is supported too, including
 	  ECB, CBC, LRW, XTS. The 64 bit version has additional
-	  acceleration for CTR.
+	  acceleration for CTR and XCTR.
 
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
-- 
2.35.1.1178.g4f1659d476-goog


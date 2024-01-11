Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DB015AC2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lQD92y6f"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e530b7596so18866135e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976417; x=1705581217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tshT8cVe3rLNAhTq0AmYLGXGv7+SRdWkw2tW13vqpSo=;
        b=lQD92y6f5cMhRruv4Bob2pS5nu72o0mjXzJ2E7RVD7sEO5yytbjYPJs52ZIbZc0lXg
         IMwnxS/yEaPWrat0A8hBXIo/mYo5gCGg/FU+bzONiJopeJlsIDbcY3a/mDHVCzFaPnfq
         plhyYXP07kBj7nvxCDLbDs+Dx6l3Yl2dDGQOpMPl18cxwqhIC+KYettUutFmEVhVzc7m
         7COjzB4JjSpXRC7Gg/kPAIpNDGHly2CQWcG+qvdfwj5ulbXrrawU7iKdrkYs0dYRc/Ak
         CFTthfWnbA+fR+2v7QeWvczY5oiEorAYGlu0T7+JqRPfoWxAlme6gmAlAOtQU6qkTG60
         4UwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976417; x=1705581217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tshT8cVe3rLNAhTq0AmYLGXGv7+SRdWkw2tW13vqpSo=;
        b=ChPBGxad8c4VQ8tzmVSxPeQ5tL+JOjZOvx80qGVKnowSxP/TTCPvfJluCxKTSRB+7O
         F3Jdv9LF7dVyUzGKl5cU3oyYhqwSDL5SIBSGKJBM4fvwtqCR0M+DYB9Qy+mngKD/VFPg
         m7BKPjnKUisgabGHEYfUcH69AoFXHD4FOWNgFy+ZhABbEJ0hOmhAL+9DUU9WoYuFNbpw
         N6C4qX2rYuyYbGRs2pLN36MLx+AN0KxQJDkZWDMtplMePcS4eD/pwsq5FZrZErqAQ4bI
         HdkXhbuhVhzq5qyREuCuvYBcyCx1Ku42AzXdLnqppksckcGA5E62TbFv7bwa+NTE4jil
         gxdg==
X-Gm-Message-State: AOJu0YyUA/d9dctVb7/YEcYSWPqP3DBjk5zEKggM9Aq6JSfrMWrEuFlw
	ikTnufgK02sjDt5sLCwERE2kcSDnv6NP+ZIfT7YPhq4xl+3UYceNIddK8Uf6SNFCWam+cvOWQUF
	oskRZUEWE7JfGfJk9vQMezVTZ8/ugnxPhD/VTRq3yisvREsLYKPsH95iR/5Cu9uW9wefjrIg=
X-Google-Smtp-Source: AGHT+IHggGQ8Q7oqdoxLFnr4dEDiGu6WfeqncJaKlv3cSRqySJ7Lj8nZ8t63ceb0nTMxXPddJivP1mpG
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:4f12:b0:40e:4cae:a416 with SMTP id
 l18-20020a05600c4f1200b0040e4caea416mr8012wmq.1.1704976416765; Thu, 11 Jan
 2024 04:33:36 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:09 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4505; i=ardb@kernel.org;
 h=from:subject; bh=Gmp1Fk2CXqJjN2EJN3MlWDoy+XN+d7Zbe69qrq+tdjU=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A5aem5OjL+asvf/rJcePP7k5TGuCwhrLfsxeUTup9
 IGIRZNYRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIprWMDPNmdej/m+3Yy2Yz
 94GO1tr+wi1/T7H8bu6fktqyetnUTxcYGRpmNqccy1lw2HvRlM/X11acKvyf1d9oNPmLIPuK8wb 1TYwA
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-16-ardb+git@google.com>
Subject: [PATCH 6/8] crypto: arm64/aes-ccm - Cache round keys and unroll AES loops
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The CCM code as originally written attempted to use as few NEON
registers as possible, to avoid having to eagerly preserve/restore the
entire NEON register file at every call to kernel_neon_begin/end. At
that time, this API took a number of NEON registers as a parameter, and
only preserved that many registers.

Today, the NEON register file is restored lazily, and the old API is
long gone. This means we can use as many NEON registers as we can make
meaningful use of, which means in the AES case that we can keep all
round keys in registers rather than reloading each of them for each AES
block processed.

On Cortex-A53, this results in a speedup of more than 50%. (From 4
cycles per byte to 2.6 cycles per byte)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 95 ++++++++------------
 1 file changed, 38 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 0132872bd780..0ec59fc4ef3e 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -14,40 +14,46 @@
 	.text
 	.arch	armv8-a+crypto
 
+	.macro	load_round_keys, rk, nr, tmp
+	sub	w\tmp, \nr, #10
+	add	\tmp, \rk, w\tmp, sxtw #4
+	ld1	{v10.4s-v13.4s}, [\rk]
+	ld1	{v14.4s-v17.4s}, [\tmp], #64
+	ld1	{v18.4s-v21.4s}, [\tmp], #64
+	ld1	{v3.4s-v5.4s}, [\tmp]
+	.endm
+
+	.macro	dround, va, vb, vk
+	aese	\va\().16b, \vk\().16b
+	aesmc	\va\().16b, \va\().16b
+	aese	\vb\().16b, \vk\().16b
+	aesmc	\vb\().16b, \vb\().16b
+	.endm
+
+	.macro	aes_encrypt, va, vb, nr
+	tbz	\nr, #2, .L\@
+	dround	\va, \vb, v10
+	dround	\va, \vb, v11
+	tbz	\nr, #1, .L\@
+	dround	\va, \vb, v12
+	dround	\va, \vb, v13
+.L\@:	.irp	v, v14, v15, v16, v17, v18, v19, v20, v21, v3
+	dround	\va, \vb, \v
+	.endr
+	aese	\va\().16b, v4.16b
+	aese	\vb\().16b, v4.16b
+	.endm
+
 	/*
 	 * void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u8 const rk[],
 	 * 			 u32 rounds);
 	 */
 SYM_FUNC_START(ce_aes_ccm_final)
-	ld1	{v3.4s}, [x2], #16		/* load first round key */
 	ld1	{v0.16b}, [x0]			/* load mac */
-	cmp	w3, #12				/* which key size? */
-	sub	w3, w3, #2			/* modified # of rounds */
 	ld1	{v1.16b}, [x1]			/* load 1st ctriv */
-	bmi	0f
-	bne	3f
-	mov	v5.16b, v3.16b
-	b	2f
-0:	mov	v4.16b, v3.16b
-1:	ld1	{v5.4s}, [x2], #16		/* load next round key */
-	aese	v0.16b, v4.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v4.16b
-	aesmc	v1.16b, v1.16b
-2:	ld1	{v3.4s}, [x2], #16		/* load next round key */
-	aese	v0.16b, v5.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v5.16b
-	aesmc	v1.16b, v1.16b
-3:	ld1	{v4.4s}, [x2], #16		/* load next round key */
-	subs	w3, w3, #3
-	aese	v0.16b, v3.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v3.16b
-	aesmc	v1.16b, v1.16b
-	bpl	1b
-	aese	v0.16b, v4.16b
-	aese	v1.16b, v4.16b
+
+	aes_encrypt	v0, v1, w3
+
 	/* final round key cancels out */
 	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
 	st1	{v0.16b}, [x0]			/* store result */
@@ -55,6 +61,8 @@ SYM_FUNC_START(ce_aes_ccm_final)
 SYM_FUNC_END(ce_aes_ccm_final)
 
 	.macro	aes_ccm_do_crypt,enc
+	load_round_keys	x3, w4, x10
+
 	cbz	x2, 5f
 	ldr	x8, [x6, #8]			/* load lower ctr */
 	ld1	{v0.16b}, [x5]			/* load mac */
@@ -64,37 +72,10 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	prfm	pldl1strm, [x1]
 	add	x8, x8, #1
 	rev	x9, x8
-	cmp	w4, #12				/* which key size? */
-	sub	w7, w4, #2			/* get modified # of rounds */
 	ins	v1.d[1], x9			/* no carry in lower ctr */
-	ld1	{v3.4s}, [x3]			/* load first round key */
-	add	x10, x3, #16
-	bmi	1f
-	bne	4f
-	mov	v5.16b, v3.16b
-	b	3f
-1:	mov	v4.16b, v3.16b
-	ld1	{v5.4s}, [x10], #16		/* load 2nd round key */
-2:	/* inner loop: 3 rounds, 2x interleaved */
-	aese	v0.16b, v4.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v4.16b
-	aesmc	v1.16b, v1.16b
-3:	ld1	{v3.4s}, [x10], #16		/* load next round key */
-	aese	v0.16b, v5.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v5.16b
-	aesmc	v1.16b, v1.16b
-4:	ld1	{v4.4s}, [x10], #16		/* load next round key */
-	subs	w7, w7, #3
-	aese	v0.16b, v3.16b
-	aesmc	v0.16b, v0.16b
-	aese	v1.16b, v3.16b
-	aesmc	v1.16b, v1.16b
-	ld1	{v5.4s}, [x10], #16		/* load next round key */
-	bpl	2b
-	aese	v0.16b, v4.16b
-	aese	v1.16b, v4.16b
+
+	aes_encrypt	v0, v1, w4
+
 	subs	w2, w2, #16
 	bmi	6f				/* partial block? */
 	ld1	{v2.16b}, [x1], #16		/* load next input block */
-- 
2.43.0.275.g3460e3d667-goog


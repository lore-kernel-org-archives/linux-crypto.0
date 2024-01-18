Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495F22C84D
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597674; cv=none; b=TAZ0y4/VU6Svp6vUY5dxU0crhb2pC47jif2PYpnr6OvwFYNQgQEUw/EQzosajMplcpzUlrrgTnWy+PANStRocwL0rT/7+EJOpuwvsXdrcmorGWrMop82xvSHD8AKF8QaXEXqGSYu+qojGVq0d1944gvdB4MB8en6B2M22XRe/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597674; c=relaxed/simple;
	bh=E8xa5pPwKdPObbfeUy3dAiPldcHAbAySa96B8+aC2vc=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XkHtFssn7chMHO9hUC9iaztUpWzYfiymSm6oxZJ6w2QwlK2kzOIgYN4kERvIN+sHG0V0wnCsy8m7eTasT9rkNkam2ZO0YI4aoVE9wqTf3dbjdGcsiVnTAIjvXmJDHGhJJImtGCSQuRC8cR+AYLHvI2lH75oWA2nPfZLsiQHx+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zhpl7XNJ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zhpl7XNJ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-337d2ccaab0so302662f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597671; x=1706202471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIgUgl/Kj0Nyil4FuwM1hWjLVD7oyZgze427wzrk/WE=;
        b=Zhpl7XNJQ6cwpMPY0NGnHUgt1Oi0IOY/XROjT1N6j/Jj5/2hJ0ve9dgRfMOAIYQkAN
         RvQNsqg4Sd/V3udAGoICPfWVwB21tGMYOThhlxdeepU1HermT0pz0N/B229nVbkipRcI
         h//qyA9+x9gS3w9ZTNzyrA/8SH6zdPNOnF0HlctYLZOAR0suwU0+FkdiTUwi90biEVxS
         idOgOoLVH/2R23caGKGv4nU6dHl3558v1pkgmTpZcd2pjqYA9EzJZA4cQOJgM1mH4Zv9
         pV0oXwft3kKBQnCMiUBl19O1ClTpKDC7uS5q30cCjo+zvYdRDGCf+HS62pSEMwJwcp7x
         eIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597671; x=1706202471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIgUgl/Kj0Nyil4FuwM1hWjLVD7oyZgze427wzrk/WE=;
        b=K4mUomH1QoH/wQO0uqqPEEOE3HL1DQhZZNJ06KqrEgG6B6CHe+JOHyAvkhurQlAoyO
         C8VXBD3WRgNe+RE8DZHzbQQL2wd5kDGydDbRyXEE4IUdEgp9frxwVHBxtM0MxulyE05L
         qhcp1PfVGb1pGaRLB0E2rl7eipXRMKN/Qynz/kkA4HMgQmvKMtx54UtC6iW5SIL0veoS
         jn+rfn0WssGLiEi1iuFVuA1q/IGuKOJp9Cet5aaLqzpF9PMsW4A3kFS8F4bq/cY0Bwo/
         aty0T/dxl6IfKGIM696KKR3QYONaC9WRflzNtq4LxJv1n0TI26TZv9LADQnSMGKK0h3t
         aGnA==
X-Gm-Message-State: AOJu0YzW/i9+E7aoyreJfv0BgwfPafOuMe48/gvLC6wxFZ7+wagfECUt
	imzDjVcCtARo02st+PwbblhnlPzH9Wdpyf2zfzKgXXD8z5GL+PpZBY9UHR5qVsMr5uEYXU+1ySk
	mcNsrZb0w69Xne1kw2Hj+THnMzMZyIkyLn5bgRdP8Mbvl1nsYeerHGbxpi0VLGugOTebC8CRz9k
	n4KnZ6dRrtvjYWeAib5MgDKdIS4FWWug==
X-Google-Smtp-Source: AGHT+IHmpkiTwDCMmoshq9XEruxIDO9/ssDzOUltwIkrpJ0qqgbXFwDHXffJA8kpNmNypyEyoN1Yj7d9
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:adf:db4d:0:b0:337:61b6:e4af with SMTP id
 f13-20020adfdb4d000000b0033761b6e4afmr3219wrj.9.1705597671397; Thu, 18 Jan
 2024 09:07:51 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:35 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4505; i=ardb@kernel.org;
 h=from:subject; bh=BZ/DOHhRiS0C26Q9Ksj11LPomr42R+ccgChBBs+l+0U=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1GzbqgdMnT8+hDwodXzQ+Jyn5PaTqwWqe+d7PZWzP
 crCL7mxo5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExEwJLhn+qGG4L3FtmvaZh6
 zNbametjVeoe2wfTlN07fzYbMgn+uMLIMKtoW5y8zqnEe5OEv8w8lzN50lG92xVBfKs2piTPfJO qzgkA
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-16-ardb+git@google.com>
Subject: [PATCH v2 6/8] crypto: arm64/aes-ccm - Cache round keys and unroll
 AES loops
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
2.43.0.381.gb435a96ce8-goog


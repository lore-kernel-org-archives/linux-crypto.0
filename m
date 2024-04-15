Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF3129E8D
	for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2024 13:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186281; cv=none; b=hPwjDmzi5++BxdyyK36dFG6f/nsaxfXSKI2M5WNz6t/fvO2R0fdNprDnyXZFzxBw/rD81yWWK9RaS+GfarxuYT3hRWoDnUUJUO5L2Wk0gCTNf1F0ZhpXejXw3Wjj+VPkYvc8uUbWNoT6wWPTYgw9xbeyIS+ydDiTh+Dus9UcZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186281; c=relaxed/simple;
	bh=gv6RCyRiLzF5sYTSCR6UVKd1nRYO7POKsvCFzmBm6GQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VDXzNMO3iJr2/H1G1mkUO3v19Phx9gKsiF32Pz+QTaMrvvv1dh8kS5Hc4pa82qmEfNW9UPH6pYn0K1MQP9lqWIrwAT6uQcKZddX7mhTWFMauAsSGDf7ugPT46ZjorCk4Ah+eox3ecggj7BZn1cALnsw8NPMstq9wW9mSd6MQr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0pW1jrtH; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0pW1jrtH"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so4981882276.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2024 06:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713186275; x=1713791075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vTHIfbeWCqDn/6Ak6Nz73ChYB9sKU9j2WCGb9z4UFhA=;
        b=0pW1jrtHuomGo9WxZCOqdFcps5t5cNCdA9wuR4/N/wrJnqbBJ2JWDalUviOd7PH28w
         yXSaSXmJec2VBMf/4EzyEGzwbOU9a6o2bFN7frbuB7c/LxQD9bOM+aCP7IG/npoYpIq6
         TxM4ftQXrbtwrEZdtMd4WoNkHnqCRiNbMn8HYlku9WKc+QUqNokK7YNqlSXDbREiZuiL
         JacWuxqz9PvaN9jJqMjpShty/KlyH4X9R9lphDw8TEd2sk+BpoUS7IcHFI35f/VsVr9k
         UuxpwN8gTLpmVM+qadq1zt6NiHKAF6RWSy8WZerocFnT45iBnxuvJql5DFwWIQOT+UUa
         5LfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713186275; x=1713791075;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vTHIfbeWCqDn/6Ak6Nz73ChYB9sKU9j2WCGb9z4UFhA=;
        b=XPb/XRvpKwXkg2nP/zURaFPkxXMz0ql+WfZeX4/LsOk5nMA9mk9F8qpAvSt7G2EIG9
         d/XTpA7lsz+deT1rj/AkyIlFkqg9Zcmo4XVwvc5M0rgG2fXyetaByuaqfa3qrksoEONU
         l8VVMR3hBDoTbF4g3UNkAsXl4Dou/AuBopyqutg0r7XTkDFGNLmiMIzERILBcq1On8hu
         DRXah2jjKVWGRSQYZ3Hcchs6cPnhHHRmBIdxGpjNog3f+UYtKRbmkhLfUs2h16nEKmy/
         JtFi8RFKqKLqIqjXrn6nqSBpHxOl+GtLdJDgz5yn+NEVLNKFw9stFQcFPTmLnw7RTq2F
         u4oQ==
X-Gm-Message-State: AOJu0Ywnax3M+H0ccZ45Fzwv+qNKo+701K/5AS8Qugugbm/mLb8nZhse
	Uagb/ivJg/Q3yjjJDGZXFB3kBPJICknxwmhEw3w6+K4pwvTHdu7DKWWConoBv1ek77WNwOpf+0n
	3t4PhlKxgLBPMA5Av7gl8eIXHIUxIueeOLH6wiBnsKZ5vkrk1r99+DnEkFYR/JNYO+f8RJ0dsBh
	jW/iMU9Dzoa122rBmOcV2CLWMCxQ5S7Q==
X-Google-Smtp-Source: AGHT+IFEdrqSXbUhZqSFHBk+4NqWPvmeUHUoY/Nxmh2Y1T9lVTxCO3Puwe2+YIH2+BX87pkwvjg+fjAN
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6902:114c:b0:dcc:8be2:7cb0 with SMTP id
 p12-20020a056902114c00b00dcc8be27cb0mr1166461ybu.0.1713186275497; Mon, 15 Apr
 2024 06:04:35 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:04:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5404; i=ardb@kernel.org;
 h=from:subject; bh=W2X44H1A80cEEvDrTguBqJCXGG730nuz2bjOWwRC0QA=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIU1W9eYuAcfy7KI19RJWFmZTWQUmzv59NM/2Cc9JD54nT
 revKpzuKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABM5U8fIsD+kab7B1embi5b8
 9ZFMcY0MY9ZnX8TobrGiYNkbrjIXUUaGmVmFpm+vBrIXhWeLZ3PsLTHIY/r18tv3b+1lsRaPGZd wAAA=
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240415130425.2414653-2-ardb+git@google.com>
Subject: [PATCH] crypto: arm64/aes-ce - Simplify round key load sequence
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Tweak the round key logic so that they can be loaded using a single
branchless sequence using overlapping loads. This is shorter and
simpler, and puts the conditional branches based on the key size further
apart, which might benefit microarchitectures that cannot record taken
branches at every instruction. For these branches, use test-bit-branch
instructions that don't clobber the condition flags.

Note that none of this has any impact on performance, positive or
otherwise (and the branch prediction benefit would only benefit AES-192
which nobody uses). It does make for nicer code, though.

While at it, use \@ to generate the labels inside the macros, which is
more robust than using fixed numbers, which could clash inadvertently.
Also, bring aes-neon.S in line with these changes, including the switch
to test-and-branch instructions, to avoid surprises in the future when
we might start relying on the condition flags being preserved in the
chaining mode wrappers in aes-modes.S

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce.S   | 34 ++++++++++++++--------------------
 arch/arm64/crypto/aes-neon.S | 20 ++++++++++----------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 1dc5bbbfeed2..b262eaa9170c 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -25,33 +25,28 @@
 	.endm
 
 	/* preload all round keys */
-	.macro		load_round_keys, rounds, rk
-	cmp		\rounds, #12
-	blo		2222f		/* 128 bits */
-	beq		1111f		/* 192 bits */
-	ld1		{v17.4s-v18.4s}, [\rk], #32
-1111:	ld1		{v19.4s-v20.4s}, [\rk], #32
-2222:	ld1		{v21.4s-v24.4s}, [\rk], #64
-	ld1		{v25.4s-v28.4s}, [\rk], #64
-	ld1		{v29.4s-v31.4s}, [\rk]
+	.macro		load_round_keys, rk, nr, tmp
+	add		\tmp, \rk, \nr, sxtw #4
+	sub		\tmp, \tmp, #160
+	ld1		{v17.4s-v20.4s}, [\rk]
+	ld1		{v21.4s-v24.4s}, [\tmp], #64
+	ld1		{v25.4s-v28.4s}, [\tmp], #64
+	ld1		{v29.4s-v31.4s}, [\tmp]
 	.endm
 
 	/* prepare for encryption with key in rk[] */
 	.macro		enc_prepare, rounds, rk, temp
-	mov		\temp, \rk
-	load_round_keys	\rounds, \temp
+	load_round_keys	\rk, \rounds, \temp
 	.endm
 
 	/* prepare for encryption (again) but with new key in rk[] */
 	.macro		enc_switch_key, rounds, rk, temp
-	mov		\temp, \rk
-	load_round_keys	\rounds, \temp
+	load_round_keys	\rk, \rounds, \temp
 	.endm
 
 	/* prepare for decryption with key in rk[] */
 	.macro		dec_prepare, rounds, rk, temp
-	mov		\temp, \rk
-	load_round_keys	\rounds, \temp
+	load_round_keys	\rk, \rounds, \temp
 	.endm
 
 	.macro		do_enc_Nx, de, mc, k, i0, i1, i2, i3, i4
@@ -110,14 +105,13 @@
 
 	/* up to 5 interleaved blocks */
 	.macro		do_block_Nx, enc, rounds, i0, i1, i2, i3, i4
-	cmp		\rounds, #12
-	blo		2222f		/* 128 bits */
-	beq		1111f		/* 192 bits */
+	tbz		\rounds, #2, .L\@	/* 128 bits */
 	round_Nx	\enc, v17, \i0, \i1, \i2, \i3, \i4
 	round_Nx	\enc, v18, \i0, \i1, \i2, \i3, \i4
-1111:	round_Nx	\enc, v19, \i0, \i1, \i2, \i3, \i4
+	tbz		\rounds, #1, .L\@	/* 192 bits */
+	round_Nx	\enc, v19, \i0, \i1, \i2, \i3, \i4
 	round_Nx	\enc, v20, \i0, \i1, \i2, \i3, \i4
-2222:	.irp		key, v21, v22, v23, v24, v25, v26, v27, v28, v29
+.L\@:	.irp		key, v21, v22, v23, v24, v25, v26, v27, v28, v29
 	round_Nx	\enc, \key, \i0, \i1, \i2, \i3, \i4
 	.endr
 	fin_round_Nx	\enc, v30, v31, \i0, \i1, \i2, \i3, \i4
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 9de7fbc797af..3a8961b6ea51 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -99,16 +99,16 @@
 	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
 	mov		\i, \rounds
-1111:	eor		\in\().16b, \in\().16b, v15.16b		/* ^round key */
+.La\@:	eor		\in\().16b, \in\().16b, v15.16b		/* ^round key */
 	movi		v15.16b, #0x40
 	tbl		\in\().16b, {\in\().16b}, v13.16b	/* ShiftRows */
 	sub_bytes	\in
-	subs		\i, \i, #1
+	sub		\i, \i, #1
 	ld1		{v15.4s}, [\rkp], #16
-	beq		2222f
+	cbz		\i, .Lb\@
 	mix_columns	\in, \enc
-	b		1111b
-2222:	eor		\in\().16b, \in\().16b, v15.16b		/* ^round key */
+	b		.La\@
+.Lb\@:	eor		\in\().16b, \in\().16b, v15.16b		/* ^round key */
 	.endm
 
 	.macro		encrypt_block, in, rounds, rk, rkp, i
@@ -206,7 +206,7 @@
 	ld1		{v15.4s}, [\rk]
 	add		\rkp, \rk, #16
 	mov		\i, \rounds
-1111:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
+.La\@:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
 	eor		\in1\().16b, \in1\().16b, v15.16b	/* ^round key */
 	eor		\in2\().16b, \in2\().16b, v15.16b	/* ^round key */
 	eor		\in3\().16b, \in3\().16b, v15.16b	/* ^round key */
@@ -216,13 +216,13 @@
 	tbl		\in2\().16b, {\in2\().16b}, v13.16b	/* ShiftRows */
 	tbl		\in3\().16b, {\in3\().16b}, v13.16b	/* ShiftRows */
 	sub_bytes_4x	\in0, \in1, \in2, \in3
-	subs		\i, \i, #1
+	sub		\i, \i, #1
 	ld1		{v15.4s}, [\rkp], #16
-	beq		2222f
+	cbz		\i, .Lb\@
 	mix_columns_2x	\in0, \in1, \enc
 	mix_columns_2x	\in2, \in3, \enc
-	b		1111b
-2222:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
+	b		.La\@
+.Lb\@:	eor		\in0\().16b, \in0\().16b, v15.16b	/* ^round key */
 	eor		\in1\().16b, \in1\().16b, v15.16b	/* ^round key */
 	eor		\in2\().16b, \in2\().16b, v15.16b	/* ^round key */
 	eor		\in3\().16b, \in3\().16b, v15.16b	/* ^round key */
-- 
2.44.0.683.g7961c838ac-goog


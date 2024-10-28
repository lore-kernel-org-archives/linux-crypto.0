Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2801E18B03
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142158; cv=none; b=fuUjNIABWTm/3DMabKtKP+UDdBcpwAjuCWPjHP0zYd0MutZu7LfufBuLqLvkRifLQxQPoz8ARL0yjSPDH4MZMQyYMLavBWsxxx/3Jk2r7PaWKTG6xdZeWGKgRAJhrfFSOrvNQ+l/wpUzs2HEAWS8WTEYJS/1EgrJmU95cJkTms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142158; c=relaxed/simple;
	bh=ryK96+oDave7YZNXIpCKT7SxGDjqJppxbNJtiIAeJew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQc9+udJF35PCKoBgKDj4xu6D7yJ/JbHfP+x4d7TeKiMLrSXq/E439JOktVooXz8mDk/8CUvaMMJ41tKoMXAouyxGZGOT4nftM77mPBvg+m4Yotni0TVodBqbQT+AI4nZjk6zLGDn0Yj570sdAXH42jCBfq9mQ7A+3Yhz0H4bU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JtK6srLq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JtK6srLq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4316ac69e6dso35718205e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142154; x=1730746954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zpm0CqO0jkLCQ2hNqhD5Z+6vomBgNs7dr74ifVRZnt4=;
        b=JtK6srLqjG77Ki0faGB8Gguoh6Rz73aYCtR7Gm+itODaKFvCscFu5480xGx7/qgtHK
         CqM74Ag7zwsrdP6i2AUxy6S9+y8dqERnDzpQ2E6KaecNytUyUeupAxec34BI9Tpb78TP
         N+4q/nsi8LeXiwgnpMk+KqStNCNhrPVyzi42Xek03TulfhcQnY50Jg5yRfNiJcePfbBY
         1YkqYD4mNIJFQWhDCq1sxfLntC8HH+wGZspLIh9nUd/wRA/AAWZDQ5S4SkXF5GLC09Zf
         piB/qkFH1BeMfBMcdkdc6jwGuwJemw59XFPxVTd0szZQT9h0GQ5QrRXySaXamoHLKEB8
         WYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142154; x=1730746954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zpm0CqO0jkLCQ2hNqhD5Z+6vomBgNs7dr74ifVRZnt4=;
        b=FYjIqruNQawlbqYuO5xz04iwmXrov3Zu4EKuldLcx1bZsVQuMY0n45j+C4Wbi8rD+v
         0ICB5ag+0ddt0zwJiMiAz6eNyPHsRBOc7KeiSEWCQT5U1dlg8YGwGFPUbKEBCW2xkYCU
         q2XYSk/wqnIcDRPGnN9zEL/b0/jvhg4+kZDcYdO6V9wzzaAht4q8l8RuR9UZn4DxNCrb
         LaBz0E+isGpJ/+mQukIB8r8C8HqXms3trW1boAs70/Kwt1GpvgOXzSGCICHUxtpv4s3X
         RWpUfUG2abKL3FXSxxgZkyEOS0W51vIEuy6ui+XcXj4Z8pIduKYolmR57vzImt+n9p/v
         xO9A==
X-Gm-Message-State: AOJu0YzIRZ7hQ9Mz8sa39Mf5U28hw+XCQxDlFt5TSAfrJCP42+nYj9eh
	GR2rszaS3YuZwVRw/5YwbFgQyW+feSuvITQQ+1KTmgrjQoYFIJh7TtTfFAMEPNx8OBBU520nYAS
	I0Ryjfj9b5gvJpR6KtmPTMuFZiuLJqIjIr8k+xAsrhRG1civIg9jWSWt03f/Scv8MyPuzN8DhDL
	SzG5ior00nI0ZoJpcYtDbuKtPOtvkX3A==
X-Google-Smtp-Source: AGHT+IHGLMQXbNwdTcbne8ZPAgPqC6Qf7gZJjvWldbCy0+SyVOa2wRc/e+wvEEV0+cVX9xWO8q2z0UUr
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a5d:45c5:0:b0:37d:4f54:78b0 with SMTP id
 ffacd0b85a97d-38060ffebe5mr9194f8f.0.1730142154146; Mon, 28 Oct 2024 12:02:34
 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:10 +0100
In-Reply-To: <20241028190207.1394367-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028190207.1394367-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6680; i=ardb@kernel.org;
 h=from:subject; bh=QvAfJRoNWdwrMVr1L2fVoyNArQiBoPeeMAMmJjZbWLQ=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/uY/HbF7q6KVWOVU1bu/fbKpKD62X/nPC91lWTYfl
 /v+/13fUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyvYnhn3FY/teFh351Z11z
 z5Ire3IttYff/WT20RXHpq0tFt9VfZXhn9mU3cctGCtY76fV7q6fEph4TLvo3uVo5t7bc74uy/5 6ixMA
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-10-ardb+git@google.com>
Subject: [PATCH 2/6] crypto: arm64/crct10dif - Use faster 16x64 bit polynomial multiply
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The CRC-T10DIF implementation for arm64 has a version that uses 8x8
polynomial multiplication, for cores that lack the crypto extensions,
which cover the 64x64 polynomial multiplication instruction that the
algorithm was built around.

This fallback version rather naively adopted the 64x64 polynomial
multiplication algorithm that I ported from ARM for the GHASH driver,
which needs 8 PMULL8 instructions to implement one PMULL64. This is
reasonable, given that each 8-bit vector element needs to be multiplied
with each element in the other vector, producing 8 vectors with partial
results that need to be combined to yield the correct result.

However, most PMULL64 invocations in the CRC-T10DIF code involve
multiplication by a pair of 16-bit folding coefficients, and so all the
partial results from higher order bytes will be zero, and there is no
need to calculate them to begin with.

Then, the CRC-T10DIF algorithm always XORs the output values of the
PMULL64 instructions being issued in pairs, and so there is no need to
faithfully implement each individual PMULL64 instruction, as long as
XORing the results pairwise produces the expected result.

Implementing these improvements results in a speedup of 3.3x on low-end
platforms such as Raspberry Pi 4 (Cortex-A72)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 71 +++++++++++++++-----
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 5604de61d06d..8d99ccf61f16 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -1,8 +1,11 @@
 //
 // Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
 //
-// Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
-// Copyright (C) 2019 Google LLC <ebiggers@google.com>
+// Copyright (C) 2016 Linaro Ltd
+// Copyright (C) 2019-2024 Google LLC
+//
+// Authors: Ard Biesheuvel <ardb@google.com>
+//          Eric Biggers <ebiggers@google.com>
 //
 // This program is free software; you can redistribute it and/or modify
 // it under the terms of the GNU General Public License version 2 as
@@ -122,6 +125,10 @@
 	sli		perm2.2d, perm1.2d, #56
 	sli		perm3.2d, perm1.2d, #48
 	sli		perm4.2d, perm1.2d, #40
+
+	mov_q		x5, 0x909010108080000
+	mov		bd1.d[0], x5
+	zip1		bd1.16b, bd1.16b, bd1.16b
 	.endm
 
 	.macro		__pmull_pre_p8, bd
@@ -196,6 +203,45 @@ SYM_FUNC_START_LOCAL(__pmull_p8_core)
 	ret
 SYM_FUNC_END(__pmull_p8_core)
 
+SYM_FUNC_START_LOCAL(__pmull_p8_16x64)
+	ext		t6.16b, t5.16b, t5.16b, #8
+
+	pmull		t3.8h, t7.8b, t5.8b
+	pmull		t4.8h, t7.8b, t6.8b
+	pmull2		t5.8h, t7.16b, t5.16b
+	pmull2		t6.8h, t7.16b, t6.16b
+
+	ext		t8.16b, t3.16b, t3.16b, #8
+	eor		t4.16b, t4.16b, t6.16b
+	ext		t7.16b, t5.16b, t5.16b, #8
+	ext		t6.16b, t4.16b, t4.16b, #8
+	eor		t8.8b, t8.8b, t3.8b
+	eor		t5.8b, t5.8b, t7.8b
+	eor		t4.8b, t4.8b, t6.8b
+	ext		t5.16b, t5.16b, t5.16b, #14
+	ret
+SYM_FUNC_END(__pmull_p8_16x64)
+
+	.macro		pmull16x64_p64, a16, b64, c64
+	pmull2		\c64\().1q, \a16\().2d, \b64\().2d
+	pmull		\b64\().1q, \a16\().1d, \b64\().1d
+	.endm
+
+	/*
+	 * NOTE: the 16x64 bit polynomial multiply below is not equivalent to
+	 * the one above, but XOR'ing the outputs together will produce the
+	 * expected result, and this is sufficient in the context of this
+	 * algorithm.
+	 */
+	.macro		pmull16x64_p8, a16, b64, c64
+	ext		t7.16b, \b64\().16b, \b64\().16b, #1
+	tbl		t5.16b, {\a16\().16b}, bd1.16b
+	uzp1		t7.16b, \b64\().16b, t7.16b
+	bl		__pmull_p8_16x64
+	ext		\b64\().16b, t4.16b, t4.16b, #15
+	eor		\c64\().16b, t8.16b, t5.16b
+	.endm
+
 	.macro		__pmull_p8, rq, ad, bd, i
 	.ifnc		\bd, fold_consts
 	.err
@@ -218,14 +264,12 @@ SYM_FUNC_END(__pmull_p8_core)
 	.macro		fold_32_bytes, p, reg1, reg2
 	ldp		q11, q12, [buf], #0x20
 
-	__pmull_\p	v8, \reg1, fold_consts, 2
-	__pmull_\p	\reg1, \reg1, fold_consts
+	pmull16x64_\p	fold_consts, \reg1, v8
 
 CPU_LE(	rev64		v11.16b, v11.16b		)
 CPU_LE(	rev64		v12.16b, v12.16b		)
 
-	__pmull_\p	v9, \reg2, fold_consts, 2
-	__pmull_\p	\reg2, \reg2, fold_consts
+	pmull16x64_\p	fold_consts, \reg2, v9
 
 CPU_LE(	ext		v11.16b, v11.16b, v11.16b, #8	)
 CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
@@ -238,11 +282,9 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 
 	// Fold src_reg into dst_reg, optionally loading the next fold constants
 	.macro		fold_16_bytes, p, src_reg, dst_reg, load_next_consts
-	__pmull_\p	v8, \src_reg, fold_consts
-	__pmull_\p	\src_reg, \src_reg, fold_consts, 2
+	pmull16x64_\p	fold_consts, \src_reg, v8
 	.ifnb		\load_next_consts
 	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
 	.endif
 	eor		\dst_reg\().16b, \dst_reg\().16b, v8.16b
 	eor		\dst_reg\().16b, \dst_reg\().16b, \src_reg\().16b
@@ -296,7 +338,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	// Load the constants for folding across 128 bytes.
 	ld1		{fold_consts.2d}, [fold_consts_ptr]
-	__pmull_pre_\p	fold_consts
 
 	// Subtract 128 for the 128 data bytes just consumed.  Subtract another
 	// 128 to simplify the termination condition of the following loop.
@@ -318,7 +359,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// Fold across 64 bytes.
 	add		fold_consts_ptr, fold_consts_ptr, #16
 	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
 	fold_16_bytes	\p, v0, v4
 	fold_16_bytes	\p, v1, v5
 	fold_16_bytes	\p, v2, v6
@@ -339,8 +379,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// into them, storing the result back into v7.
 	b.lt		.Lfold_16_bytes_loop_done_\@
 .Lfold_16_bytes_loop_\@:
-	__pmull_\p	v8, v7, fold_consts
-	__pmull_\p	v7, v7, fold_consts, 2
+	pmull16x64_\p	fold_consts, v7, v8
 	eor		v7.16b, v7.16b, v8.16b
 	ldr		q0, [buf], #16
 CPU_LE(	rev64		v0.16b, v0.16b			)
@@ -387,9 +426,8 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	bsl		v2.16b, v1.16b, v0.16b
 
 	// Fold the first chunk into the second chunk, storing the result in v7.
-	__pmull_\p	v0, v3, fold_consts
-	__pmull_\p	v7, v3, fold_consts, 2
-	eor		v7.16b, v7.16b, v0.16b
+	pmull16x64_\p	fold_consts, v3, v0
+	eor		v7.16b, v3.16b, v0.16b
 	eor		v7.16b, v7.16b, v2.16b
 
 .Lreduce_final_16_bytes_\@:
@@ -450,7 +488,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	// Load the fold-across-16-bytes constants.
 	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
 
 	cmp		len, #16
 	b.eq		.Lreduce_final_16_bytes_\@	// len == 16
-- 
2.47.0.163.g1226f6d8fa-goog


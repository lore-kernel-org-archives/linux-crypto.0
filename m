Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AE6225D7
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823255; cv=none; b=Ni8Y6CeYbgTzSPy84wpL8Ar7RaqxvyUqLWNL4BEV6/DWX6/gH/DYYCgVubJvYotge4HnmhJyj2PKz1Fk4qEHiX+K+SgZlpxmszez56zr8fMDOI9NCOmRTZ6SdBDXNwoQQi8y5d2FbWzK+4l+IKifA7ruL3/5EYzsF/tYx60Usp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823255; c=relaxed/simple;
	bh=VqKVzyeKDONa3wQHx07LdfRIXqOq+PEwchSE6Q9wT0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=POYnvZx0YzsVBLIvBdhDHRDYbfjGPpq/V0VHSwXIfc/9I0RvUTOyI2phXQgLaHw7FyD5nmBRoyA8HDMYqCKlNrkh1GziNkQo7LzuxoIPObzwFMAwpttp/peX8+Y+9Xqn5BfCh+HVxA+/31BuamamUAYi+FaMW6a1WBk3GVGL6CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fwwepjpm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fwwepjpm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4315af466d9so38045435e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823252; x=1731428052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUTZKhO+m9CbRYTtzqazvIhlpnuTgx8VjiuBDf6t1Bk=;
        b=FwwepjpmIeJHuLFJYODc5KQcf7lW9H6ApgfpjPhYox4qS2RFKY/cIenI6wR+xBkqNJ
         XzwFY4rL/+Y0eWPfo7mSKJWwQzejlEXxkVP837UiizZ0YngLM0XrdykikxYPWSjbryyL
         0QS11gPm/M8c4boY3TRmdcfXw9lOHO0ovPBhqpQfmwR0FMRFb3cG4N3hM5EYH5xOLa+r
         lU8zfQXUX1+pz9EeXi+jcA2PnQB33gyW1r5kf6DJsM20iDYQcLhtpSVH6jq5xTs61X/X
         bjFIzS2Nk5sqXDCqi98NsTt++ktSaINVkNHEwNzqSmt5QgTrSzxf0rf2f9zr4Cra4mYK
         /8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823252; x=1731428052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cUTZKhO+m9CbRYTtzqazvIhlpnuTgx8VjiuBDf6t1Bk=;
        b=GBX/M0shxEl84JWchV+0xcgMRADSbh5V1F4Kf30DsNjwPpCgoEl0U97F5n6XjsvefK
         E3IoBRo7ZCpr/LAH/GjD81svJoummye8zoYBEkPpbj7Rn7MIJ7RDIuWTNkYgJDeNgf0U
         upl1/+GuOEGYtTMCZbX5kZn9rVztIO9gCPrYpTxDEZFrBT+vpbUgbciU14OpY58Bv3KB
         GccBWnDsiZc4tfAnoeED0oyWDJgoELe4gP89+WrAPmR4r5U52JagHEUpCX7vsqezu2dH
         6lrK/Ti7mlF8eBC92Vxkg7h3Ddlfte/ZzqWebXmzSBrYOubGKjeS9Gf5SQrzc9oO7FlW
         l8Fg==
X-Gm-Message-State: AOJu0YxJGtytxW+LEpeirpM4K6lLsjgE5Lp9La9oAcMosn0u/p08aIqQ
	pX5x7VMk1517pMvuudoi6qBlYytA9ZCNFLj1u9kDLAANvPiH8xX7fmmv0yQzPukMjV8zB+rAT0A
	erCgA4FDC6qWfhcvlfUl8UyOLUyFkX8LCwuaCr9RrBRWc4CZ897CtkPRth4D5NeCpfNKDZ7Bi7y
	dLlaRTNrhpzMzvmnnb81ak0MsId4P9/A==
X-Google-Smtp-Source: AGHT+IE1Nlhc8GIHkn95vE7fV4U4p21WsOlBR9O4RgNPNsEk4URCQoymAAI4dVUFa6csu+wXO7g9Q+4A
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:2210:b0:431:47cf:4f59 with SMTP id
 5b1f17b1804b1-432831cb821mr486115e9.0.1730823251479; Tue, 05 Nov 2024
 08:14:11 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:02 +0100
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160859.1459261-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9105; i=ardb@kernel.org;
 h=from:subject; bh=sF5Epk2ae4EBs5KvMvDtueP5LeUDeZZXIOLxDNupMtk=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWf6rZTzfNf2uGcFSITdPTj271yi9/aDmlRmxC0S+n
 NI+q76wo5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkQywjwyt/D/dvO14ZMiyS
 6zu6+vAx31jBSE23ZqfUaQHnQuSWFTAy7Fxj82lfc+mxM1uX2ItPfzf1zJ549/P+3DkXg/RSjbp aOAE=
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-10-ardb+git@google.com>
Subject: [PATCH v2 2/6] crypto: arm64/crct10dif - Use faster 16x64 bit
 polynomial multiply
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
 arch/arm64/crypto/crct10dif-ce-core.S | 121 +++++++++++++++++---
 1 file changed, 104 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 5604de61d06d..d2acaa2b5a01 100644
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
@@ -122,6 +125,13 @@
 	sli		perm2.2d, perm1.2d, #56
 	sli		perm3.2d, perm1.2d, #48
 	sli		perm4.2d, perm1.2d, #40
+
+	// Compose { 0,0,0,0, 8,8,8,8, 1,1,1,1, 9,9,9,9 }
+	movi		bd1.4h, #8, lsl #8
+	orr		bd1.2s, #1, lsl #16
+	orr		bd1.2s, #1, lsl #24
+	zip1		bd1.16b, bd1.16b, bd1.16b
+	zip1		bd1.16b, bd1.16b, bd1.16b
 	.endm
 
 	.macro		__pmull_pre_p8, bd
@@ -196,6 +206,92 @@ SYM_FUNC_START_LOCAL(__pmull_p8_core)
 	ret
 SYM_FUNC_END(__pmull_p8_core)
 
+	.macro		pmull16x64_p64, a16, b64, c64
+	pmull2		\c64\().1q, \a16\().2d, \b64\().2d
+	pmull		\b64\().1q, \a16\().1d, \b64\().1d
+	.endm
+
+	/*
+	 * Pairwise long polynomial multiplication of two 16-bit values
+	 *
+	 *   { w0, w1 }, { y0, y1 }
+	 *
+	 * by two 64-bit values
+	 *
+	 *   { x0, x1, x2, x3, x4, x5, x6, x7 }, { z0, z1, z2, z3, z4, z5, z6, z7 }
+	 *
+	 * where each vector element is a byte, ordered from least to most
+	 * significant.
+	 *
+	 * This can be implemented using 8x8 long polynomial multiplication, by
+	 * reorganizing the input so that each pairwise 8x8 multiplication
+	 * produces one of the terms from the decomposition below, and
+	 * combining the results of each rank and shifting them into place.
+	 *
+	 * Rank
+	 *  0            w0*x0 ^              |        y0*z0 ^
+	 *  1       (w0*x1 ^ w1*x0) <<  8 ^   |   (y0*z1 ^ y1*z0) <<  8 ^
+	 *  2       (w0*x2 ^ w1*x1) << 16 ^   |   (y0*z2 ^ y1*z1) << 16 ^
+	 *  3       (w0*x3 ^ w1*x2) << 24 ^   |   (y0*z3 ^ y1*z2) << 24 ^
+	 *  4       (w0*x4 ^ w1*x3) << 32 ^   |   (y0*z4 ^ y1*z3) << 32 ^
+	 *  5       (w0*x5 ^ w1*x4) << 40 ^   |   (y0*z5 ^ y1*z4) << 40 ^
+	 *  6       (w0*x6 ^ w1*x5) << 48 ^   |   (y0*z6 ^ y1*z5) << 48 ^
+	 *  7       (w0*x7 ^ w1*x6) << 56 ^   |   (y0*z7 ^ y1*z6) << 56 ^
+	 *  8            w1*x7      << 64     |        y1*z7      << 64
+	 *
+	 * The inputs can be reorganized into
+	 *
+	 *   { w0, w0, w0, w0, y0, y0, y0, y0 }, { w1, w1, w1, w1, y1, y1, y1, y1 }
+	 *   { x0, x2, x4, x6, z0, z2, z4, z6 }, { x1, x3, x5, x7, z1, z3, z5, z7 }
+	 *
+	 * and after performing 8x8->16 bit long polynomial multiplication of
+	 * each of the halves of the first vector with those of the second one,
+	 * we obtain the following four vectors of 16-bit elements:
+	 *
+	 *   a := { w0*x0, w0*x2, w0*x4, w0*x6 }, { y0*z0, y0*z2, y0*z4, y0*z6 }
+	 *   b := { w0*x1, w0*x3, w0*x5, w0*x7 }, { y0*z1, y0*z3, y0*z5, y0*z7 }
+	 *   c := { w1*x0, w1*x2, w1*x4, w1*x6 }, { y1*z0, y1*z2, y1*z4, y1*z6 }
+	 *   d := { w1*x1, w1*x3, w1*x5, w1*x7 }, { y1*z1, y1*z3, y1*z5, y1*z7 }
+	 *
+	 * Results b and c can be XORed together, as the vector elements have
+	 * matching ranks. Then, the final XOR (*) can be pulled forward, and
+	 * applied between the halves of each of the remaining three vectors,
+	 * which are then shifted into place, and combined to produce two
+	 * 80-bit results.
+	 *
+	 * (*) NOTE: the 16x64 bit polynomial multiply below is not equivalent
+	 * to the 64x64 bit one above, but XOR'ing the outputs together will
+	 * produce the expected result, and this is sufficient in the context of
+	 * this algorithm.
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
 	.macro		__pmull_p8, rq, ad, bd, i
 	.ifnc		\bd, fold_consts
 	.err
@@ -218,14 +314,12 @@ SYM_FUNC_END(__pmull_p8_core)
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
@@ -238,11 +332,9 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 
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
@@ -296,7 +388,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	// Load the constants for folding across 128 bytes.
 	ld1		{fold_consts.2d}, [fold_consts_ptr]
-	__pmull_pre_\p	fold_consts
 
 	// Subtract 128 for the 128 data bytes just consumed.  Subtract another
 	// 128 to simplify the termination condition of the following loop.
@@ -318,7 +409,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// Fold across 64 bytes.
 	add		fold_consts_ptr, fold_consts_ptr, #16
 	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
 	fold_16_bytes	\p, v0, v4
 	fold_16_bytes	\p, v1, v5
 	fold_16_bytes	\p, v2, v6
@@ -339,8 +429,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// into them, storing the result back into v7.
 	b.lt		.Lfold_16_bytes_loop_done_\@
 .Lfold_16_bytes_loop_\@:
-	__pmull_\p	v8, v7, fold_consts
-	__pmull_\p	v7, v7, fold_consts, 2
+	pmull16x64_\p	fold_consts, v7, v8
 	eor		v7.16b, v7.16b, v8.16b
 	ldr		q0, [buf], #16
 CPU_LE(	rev64		v0.16b, v0.16b			)
@@ -387,9 +476,8 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	bsl		v2.16b, v1.16b, v0.16b
 
 	// Fold the first chunk into the second chunk, storing the result in v7.
-	__pmull_\p	v0, v3, fold_consts
-	__pmull_\p	v7, v3, fold_consts, 2
-	eor		v7.16b, v7.16b, v0.16b
+	pmull16x64_\p	fold_consts, v3, v0
+	eor		v7.16b, v3.16b, v0.16b
 	eor		v7.16b, v7.16b, v2.16b
 
 .Lreduce_final_16_bytes_\@:
@@ -450,7 +538,6 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 
 	// Load the fold-across-16-bytes constants.
 	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
 
 	cmp		len, #16
 	b.eq		.Lreduce_final_16_bytes_\@	// len == 16
-- 
2.47.0.199.ga7371fff76-goog


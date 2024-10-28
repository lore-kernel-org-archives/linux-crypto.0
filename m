Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9841DF96A
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142161; cv=none; b=kBzwBcXbIA2Tl0k7qCO1lamw/RJB9tr2kmkAzFadezZGZxjQrTXao0kRaQNZMZZlUQ9w4fy5DKS1JAQYS+ZuIRsGEd3+VQ2ceJvlocJ/fKFyP1junyVLnLR91nC47gGfvW5nEhDUQYg/MFprRgY6h/C3nAoEsoWCpun/abaP7Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142161; c=relaxed/simple;
	bh=J7aFTZ/f+621TjfCMvLqBV9mSzYeHA0Rh7jsQetDVQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RA8/cwjIFIyN6oWGYOKzDBSAVeM8Hff6ol3Li3iL6uUZgnVMj2qXLWtRXcV57mlBqt0/R9cl5icJ4jqzPZh+a2TKWPnrHu/bs26E/F7ZCwL05T/q2HFVwR3/BcdAyaE5g5XHPmJ2wn8OTYaTTPCvzq4FA37Ct1c/oqV9fm5MiBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CsWAY1DK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CsWAY1DK"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43157cff1d1so34173305e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142156; x=1730746956; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Echa0+oKKJH44B+9S6rJI95UvNtKR1Bf1nPVGCz2Lh4=;
        b=CsWAY1DKvG8E7CpMRuXku/reix6I8bWwKlGvSe9FN9f7iwq0E9j3iLcQvSoGrnYmV+
         Jzf9A/4F+mThA9MDHtV4lBdUHJyq5F6BoCmzPWndetccYnw/LDPBPfiPvvjuVPO7ilGw
         veDu+wl81AJ0sUa+osoSU4cGtuN2K4Qcg96TtwgdJFlqNUCVSoi1a9SKPKt5/0MjZJOr
         Ip1VoPeSZ/WzLDoXhfo9LGnzNsYcuuvsFbLyI6QzjxgBvIo0g6x70qlbQM9roMXbv+fm
         xZ6NXjWxt2kBzwMB5jDT4i6tlwZ5vknXSYuluq9jk6s1nhCuvGSX3p8c2VWiHZrp0kXU
         ktFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142156; x=1730746956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Echa0+oKKJH44B+9S6rJI95UvNtKR1Bf1nPVGCz2Lh4=;
        b=KZ5tQneYHZLMeNoYGH61vBHsLOwcZ4mLV18GvEi2hrY+hTQF29tb4zTijY8ngvAoQT
         Zm3pTP4uT2DLpeexyaulmVRk/uZE1RdODJ9CO59vFLcnGf6AjBGw79z9DoLUzXp0tdWG
         EdtQkp7JlY1hFOP7rfEptKiO7WNnxjmYN9z8XuCHKDamFZcTku4Ge/PE9nBGBfyfGRck
         EQrfuQJ+TF2fa+JRLmfAjP1xECGD8JQA8Jre9zWhO/rmXA9RCbpKz7glXrtqmP0DAkmF
         DxqxIn6XodXTFzq1EgZLUstkpeZlMGvNFan5HwKBgC5Uardm9GehTBUEmyuDN+y6JavX
         LZ2Q==
X-Gm-Message-State: AOJu0YxeexZy6mwYc3cDbdIRU7BSB4zlSv3lKmXfGG3cBe2GHobOU0/g
	yq/u6aW5aWgtXr8IG2R9LmaqQMQPBwVR8QDzO8X+X1vnxhAScZOdCbQZeECdQ02boj3vUwXy2cr
	by1GXV6jlrv8PR6c5HO94QoO7dhiE75JiwpdCzpmjW7eQvdpsVYSPOGU8fmPwrtzJPJbpNjR+O2
	qG+urS6P40IWtAXUqkrIByRmYohUc29A==
X-Google-Smtp-Source: AGHT+IEy2t8IV03SYSWSP1iIc6zNu5vJGMwwfry7I6Nnl0H6Rg2JBL1p2BwJnhY8iG6jvNn6l5QvQwZ2
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:683:b0:431:4509:696a with SMTP id
 5b1f17b1804b1-4319ac8a64amr142545e9.2.1730142156375; Mon, 28 Oct 2024
 12:02:36 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:11 +0100
In-Reply-To: <20241028190207.1394367-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028190207.1394367-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=11267; i=ardb@kernel.org;
 h=from:subject; bh=+XBmdyxmNZmCfvA5pryYtkZFwd//f6d6ET/JrqhadgY=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/hY1AeeNfmLRkqqNyozz5T4n/HrFafBWSyn6zCnp0
 sCFz391lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIlM62Nk+HEz98fJrS4cMhbS
 SfVdm9llFxxKsNinZsySLBX92fK2GMN/5xr7Ys/5L5exbZm4NfGA40ypdrGSLsbdHrxM55ezCaz hAQA=
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-11-ardb+git@google.com>
Subject: [PATCH 3/6] crypto: arm64/crct10dif - Remove remaining 64x64 PMULL
 fallback code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The only remaining user of the fallback implementation of 64x64
polynomial multiplication using 8x8 PMULL instructions is the final
reduction from a 16 byte vector to a 16-bit CRC.

The fallback code is complicated and messy, and this reduction has very
little impact on the overall performance, so instead, let's calculate
the final CRC by passing the 16 byte vector to the generic CRC-T10DIF
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 237 +++++---------------
 arch/arm64/crypto/crct10dif-ce-glue.c |  15 +-
 2 files changed, 64 insertions(+), 188 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 8d99ccf61f16..1db5d1d1e2b7 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -74,14 +74,12 @@
 	init_crc	.req	w0
 	buf		.req	x1
 	len		.req	x2
-	fold_consts_ptr	.req	x3
+	fold_consts_ptr	.req	x5
 
 	fold_consts	.req	v10
 
 	ad		.req	v14
-
-	k00_16		.req	v15
-	k32_48		.req	v16
+	bd		.req	v15
 
 	t3		.req	v17
 	t4		.req	v18
@@ -91,117 +89,7 @@
 	t8		.req	v22
 	t9		.req	v23
 
-	perm1		.req	v24
-	perm2		.req	v25
-	perm3		.req	v26
-	perm4		.req	v27
-
-	bd1		.req	v28
-	bd2		.req	v29
-	bd3		.req	v30
-	bd4		.req	v31
-
-	.macro		__pmull_init_p64
-	.endm
-
-	.macro		__pmull_pre_p64, bd
-	.endm
-
-	.macro		__pmull_init_p8
-	// k00_16 := 0x0000000000000000_000000000000ffff
-	// k32_48 := 0x00000000ffffffff_0000ffffffffffff
-	movi		k32_48.2d, #0xffffffff
-	mov		k32_48.h[2], k32_48.h[0]
-	ushr		k00_16.2d, k32_48.2d, #32
-
-	// prepare the permutation vectors
-	mov_q		x5, 0x080f0e0d0c0b0a09
-	movi		perm4.8b, #8
-	dup		perm1.2d, x5
-	eor		perm1.16b, perm1.16b, perm4.16b
-	ushr		perm2.2d, perm1.2d, #8
-	ushr		perm3.2d, perm1.2d, #16
-	ushr		perm4.2d, perm1.2d, #24
-	sli		perm2.2d, perm1.2d, #56
-	sli		perm3.2d, perm1.2d, #48
-	sli		perm4.2d, perm1.2d, #40
-
-	mov_q		x5, 0x909010108080000
-	mov		bd1.d[0], x5
-	zip1		bd1.16b, bd1.16b, bd1.16b
-	.endm
-
-	.macro		__pmull_pre_p8, bd
-	tbl		bd1.16b, {\bd\().16b}, perm1.16b
-	tbl		bd2.16b, {\bd\().16b}, perm2.16b
-	tbl		bd3.16b, {\bd\().16b}, perm3.16b
-	tbl		bd4.16b, {\bd\().16b}, perm4.16b
-	.endm
-
-SYM_FUNC_START_LOCAL(__pmull_p8_core)
-.L__pmull_p8_core:
-	ext		t4.8b, ad.8b, ad.8b, #1			// A1
-	ext		t5.8b, ad.8b, ad.8b, #2			// A2
-	ext		t6.8b, ad.8b, ad.8b, #3			// A3
-
-	pmull		t4.8h, t4.8b, fold_consts.8b		// F = A1*B
-	pmull		t8.8h, ad.8b, bd1.8b			// E = A*B1
-	pmull		t5.8h, t5.8b, fold_consts.8b		// H = A2*B
-	pmull		t7.8h, ad.8b, bd2.8b			// G = A*B2
-	pmull		t6.8h, t6.8b, fold_consts.8b		// J = A3*B
-	pmull		t9.8h, ad.8b, bd3.8b			// I = A*B3
-	pmull		t3.8h, ad.8b, bd4.8b			// K = A*B4
-	b		0f
-
-.L__pmull_p8_core2:
-	tbl		t4.16b, {ad.16b}, perm1.16b		// A1
-	tbl		t5.16b, {ad.16b}, perm2.16b		// A2
-	tbl		t6.16b, {ad.16b}, perm3.16b		// A3
-
-	pmull2		t4.8h, t4.16b, fold_consts.16b		// F = A1*B
-	pmull2		t8.8h, ad.16b, bd1.16b			// E = A*B1
-	pmull2		t5.8h, t5.16b, fold_consts.16b		// H = A2*B
-	pmull2		t7.8h, ad.16b, bd2.16b			// G = A*B2
-	pmull2		t6.8h, t6.16b, fold_consts.16b		// J = A3*B
-	pmull2		t9.8h, ad.16b, bd3.16b			// I = A*B3
-	pmull2		t3.8h, ad.16b, bd4.16b			// K = A*B4
-
-0:	eor		t4.16b, t4.16b, t8.16b			// L = E + F
-	eor		t5.16b, t5.16b, t7.16b			// M = G + H
-	eor		t6.16b, t6.16b, t9.16b			// N = I + J
-
-	uzp1		t8.2d, t4.2d, t5.2d
-	uzp2		t4.2d, t4.2d, t5.2d
-	uzp1		t7.2d, t6.2d, t3.2d
-	uzp2		t6.2d, t6.2d, t3.2d
-
-	// t4 = (L) (P0 + P1) << 8
-	// t5 = (M) (P2 + P3) << 16
-	eor		t8.16b, t8.16b, t4.16b
-	and		t4.16b, t4.16b, k32_48.16b
-
-	// t6 = (N) (P4 + P5) << 24
-	// t7 = (K) (P6 + P7) << 32
-	eor		t7.16b, t7.16b, t6.16b
-	and		t6.16b, t6.16b, k00_16.16b
-
-	eor		t8.16b, t8.16b, t4.16b
-	eor		t7.16b, t7.16b, t6.16b
-
-	zip2		t5.2d, t8.2d, t4.2d
-	zip1		t4.2d, t8.2d, t4.2d
-	zip2		t3.2d, t7.2d, t6.2d
-	zip1		t6.2d, t7.2d, t6.2d
-
-	ext		t4.16b, t4.16b, t4.16b, #15
-	ext		t5.16b, t5.16b, t5.16b, #14
-	ext		t6.16b, t6.16b, t6.16b, #13
-	ext		t3.16b, t3.16b, t3.16b, #12
-
-	eor		t4.16b, t4.16b, t5.16b
-	eor		t6.16b, t6.16b, t3.16b
-	ret
-SYM_FUNC_END(__pmull_p8_core)
+	perm		.req	v27
 
 SYM_FUNC_START_LOCAL(__pmull_p8_16x64)
 	ext		t6.16b, t5.16b, t5.16b, #8
@@ -235,30 +123,13 @@ SYM_FUNC_END(__pmull_p8_16x64)
 	 */
 	.macro		pmull16x64_p8, a16, b64, c64
 	ext		t7.16b, \b64\().16b, \b64\().16b, #1
-	tbl		t5.16b, {\a16\().16b}, bd1.16b
+	tbl		t5.16b, {\a16\().16b}, perm.16b
 	uzp1		t7.16b, \b64\().16b, t7.16b
 	bl		__pmull_p8_16x64
 	ext		\b64\().16b, t4.16b, t4.16b, #15
 	eor		\c64\().16b, t8.16b, t5.16b
 	.endm
 
-	.macro		__pmull_p8, rq, ad, bd, i
-	.ifnc		\bd, fold_consts
-	.err
-	.endif
-	mov		ad.16b, \ad\().16b
-	.ifb		\i
-	pmull		\rq\().8h, \ad\().8b, \bd\().8b		// D = A*B
-	.else
-	pmull2		\rq\().8h, \ad\().16b, \bd\().16b	// D = A*B
-	.endif
-
-	bl		.L__pmull_p8_core\i
-
-	eor		\rq\().16b, \rq\().16b, t4.16b
-	eor		\rq\().16b, \rq\().16b, t6.16b
-	.endm
-
 	// Fold reg1, reg2 into the next 32 data bytes, storing the result back
 	// into reg1, reg2.
 	.macro		fold_32_bytes, p, reg1, reg2
@@ -290,16 +161,7 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	eor		\dst_reg\().16b, \dst_reg\().16b, \src_reg\().16b
 	.endm
 
-	.macro		__pmull_p64, rd, rn, rm, n
-	.ifb		\n
-	pmull		\rd\().1q, \rn\().1d, \rm\().1d
-	.else
-	pmull2		\rd\().1q, \rn\().2d, \rm\().2d
-	.endif
-	.endm
-
 	.macro		crc_t10dif_pmull, p
-	__pmull_init_\p
 
 	// For sizes less than 256 bytes, we can't fold 128 bytes at a time.
 	cmp		len, #256
@@ -429,47 +291,7 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	pmull16x64_\p	fold_consts, v3, v0
 	eor		v7.16b, v3.16b, v0.16b
 	eor		v7.16b, v7.16b, v2.16b
-
-.Lreduce_final_16_bytes_\@:
-	// Reduce the 128-bit value M(x), stored in v7, to the final 16-bit CRC.
-
-	movi		v2.16b, #0		// init zero register
-
-	// Load 'x^48 * (x^48 mod G(x))' and 'x^48 * (x^80 mod G(x))'.
-	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
-	__pmull_pre_\p	fold_consts
-
-	// Fold the high 64 bits into the low 64 bits, while also multiplying by
-	// x^64.  This produces a 128-bit value congruent to x^64 * M(x) and
-	// whose low 48 bits are 0.
-	ext		v0.16b, v2.16b, v7.16b, #8
-	__pmull_\p	v7, v7, fold_consts, 2	// high bits * x^48 * (x^80 mod G(x))
-	eor		v0.16b, v0.16b, v7.16b	// + low bits * x^64
-
-	// Fold the high 32 bits into the low 96 bits.  This produces a 96-bit
-	// value congruent to x^64 * M(x) and whose low 48 bits are 0.
-	ext		v1.16b, v0.16b, v2.16b, #12	// extract high 32 bits
-	mov		v0.s[3], v2.s[0]	// zero high 32 bits
-	__pmull_\p	v1, v1, fold_consts	// high 32 bits * x^48 * (x^48 mod G(x))
-	eor		v0.16b, v0.16b, v1.16b	// + low bits
-
-	// Load G(x) and floor(x^48 / G(x)).
-	ld1		{fold_consts.2d}, [fold_consts_ptr]
-	__pmull_pre_\p	fold_consts
-
-	// Use Barrett reduction to compute the final CRC value.
-	__pmull_\p	v1, v0, fold_consts, 2	// high 32 bits * floor(x^48 / G(x))
-	ushr		v1.2d, v1.2d, #32	// /= x^32
-	__pmull_\p	v1, v1, fold_consts	// *= G(x)
-	ushr		v0.2d, v0.2d, #48
-	eor		v0.16b, v0.16b, v1.16b	// + low 16 nonzero bits
-	// Final CRC value (x^16 * M(x)) mod G(x) is in low 16 bits of v0.
-
-	umov		w0, v0.h[0]
-	.ifc		\p, p8
-	frame_pop
-	.endif
-	ret
+	b		.Lreduce_final_16_bytes_\@
 
 .Lless_than_256_bytes_\@:
 	// Checksumming a buffer of length 16...255 bytes
@@ -495,6 +317,8 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	b.ge		.Lfold_16_bytes_loop_\@		// 32 <= len <= 255
 	add		len, len, #16
 	b		.Lhandle_partial_segment_\@	// 17 <= len <= 31
+
+.Lreduce_final_16_bytes_\@:
 	.endm
 
 //
@@ -504,7 +328,19 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 //
 SYM_FUNC_START(crc_t10dif_pmull_p8)
 	frame_push	1
+
+	mov_q		x4, 0x909010108080000
+	mov		perm.d[0], x4
+	zip1		perm.16b, perm.16b, perm.16b
+
 	crc_t10dif_pmull p8
+
+CPU_LE(	rev64		v7.16b, v7.16b			)
+CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+	str		q7, [x3]
+
+	frame_pop
+	ret
 SYM_FUNC_END(crc_t10dif_pmull_p8)
 
 	.align		5
@@ -515,6 +351,41 @@ SYM_FUNC_END(crc_t10dif_pmull_p8)
 //
 SYM_FUNC_START(crc_t10dif_pmull_p64)
 	crc_t10dif_pmull	p64
+
+	// Reduce the 128-bit value M(x), stored in v7, to the final 16-bit CRC.
+
+	movi		v2.16b, #0		// init zero register
+
+	// Load 'x^48 * (x^48 mod G(x))' and 'x^48 * (x^80 mod G(x))'.
+	ld1		{fold_consts.2d}, [fold_consts_ptr], #16
+
+	// Fold the high 64 bits into the low 64 bits, while also multiplying by
+	// x^64.  This produces a 128-bit value congruent to x^64 * M(x) and
+	// whose low 48 bits are 0.
+	ext		v0.16b, v2.16b, v7.16b, #8
+	pmull2		v7.1q, v7.2d, fold_consts.2d	// high bits * x^48 * (x^80 mod G(x))
+	eor		v0.16b, v0.16b, v7.16b		// + low bits * x^64
+
+	// Fold the high 32 bits into the low 96 bits.  This produces a 96-bit
+	// value congruent to x^64 * M(x) and whose low 48 bits are 0.
+	ext		v1.16b, v0.16b, v2.16b, #12	// extract high 32 bits
+	mov		v0.s[3], v2.s[0]		// zero high 32 bits
+	pmull		v1.1q, v1.1d, fold_consts.1d	// high 32 bits * x^48 * (x^48 mod G(x))
+	eor		v0.16b, v0.16b, v1.16b		// + low bits
+
+	// Load G(x) and floor(x^48 / G(x)).
+	ld1		{fold_consts.2d}, [fold_consts_ptr]
+
+	// Use Barrett reduction to compute the final CRC value.
+	pmull2		v1.1q, v1.2d, fold_consts.2d	// high 32 bits * floor(x^48 / G(x))
+	ushr		v1.2d, v1.2d, #32		// /= x^32
+	pmull		v1.1q, v1.1d, fold_consts.1d	// *= G(x)
+	ushr		v0.2d, v0.2d, #48
+	eor		v0.16b, v0.16b, v1.16b		// + low 16 nonzero bits
+	// Final CRC value (x^16 * M(x)) mod G(x) is in low 16 bits of v0.
+
+	umov		w0, v0.h[0]
+	ret
 SYM_FUNC_END(crc_t10dif_pmull_p64)
 
 	.section	".rodata", "a"
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 7b05094a0480..b6db5f5683e1 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -20,7 +20,7 @@
 
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
-asmlinkage u16 crc_t10dif_pmull_p8(u16 init_crc, const u8 *buf, size_t len);
+asmlinkage void crc_t10dif_pmull_p8(u16 init_crc, const u8 *buf, size_t len, u8 *out);
 asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 *buf, size_t len);
 
 static int crct10dif_init(struct shash_desc *desc)
@@ -34,16 +34,21 @@ static int crct10dif_init(struct shash_desc *desc)
 static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
 			    unsigned int length)
 {
-	u16 *crc = shash_desc_ctx(desc);
+	u16 *crcp = shash_desc_ctx(desc);
+	u16 crc = *crcp;
+	u8 buf[16];
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull_p8(*crc, data, length);
+		crc_t10dif_pmull_p8(crc, data, length, buf);
 		kernel_neon_end();
-	} else {
-		*crc = crc_t10dif_generic(*crc, data, length);
+
+		crc = 0;
+		data = buf;
+		length = sizeof(buf);
 	}
 
+	*crcp = crc_t10dif_generic(crc, data, length);
 	return 0;
 }
 
-- 
2.47.0.163.g1226f6d8fa-goog


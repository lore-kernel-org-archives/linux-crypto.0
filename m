Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D651714CF
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823262; cv=none; b=FfCQnu9VyadeOhhZ41tjiMECZhdg4DHu3NeRd9q5g//LOxFv/ttyz7Fz6GX/ZF9hdmDyZTr8ARvyvxUN+f5xX1a/Bk4fEulKohKpKz4wjUB1N6V9pCc1ukKb2BfzIMWaX9kpm1FUaYerFsBgrKAmVX5Wla+gqoM42mHKAsenEc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823262; c=relaxed/simple;
	bh=WI2990mAYR17U1iBAh16GSKfeaVM9j4KBCeYYhsAngA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GW/DCOsFs9z1QRYQFFW/aeG/qpCuCSwWjg0mI0ce1+/i7e31/4Bmt8OvHjsVP/zmx+pkKBXQnlTDgdMITA45kCkPhzUh+WDnrgtQBZFmThHPl2Smpz1EuLEtHwDDAyXVjs5DHAzM5DAbtZtjdB7d8tc6V6DB/V/jzCMst0zMVwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oWCxM6gJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oWCxM6gJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30cf121024so9579149276.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823260; x=1731428060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhfO8ohnOtNJQi1hI9D3A4FDq/9CsS5R1WgkWnITbx8=;
        b=oWCxM6gJUGRPrAhRUpmM8s9DQhdUFItg9x7mv89ZGt4c/euSgY09tbb5kHjZDn0cjC
         Yi1ZzTM+D4EM4VSE02lICVjEB2pohD8slqvqanRfzzvuKlGSRc8TZjR0d/dKXWXYJPxs
         NIeG1/meJSQ6gL29NbASWQ1AvF+6NTuP8O8N5QDJQO83MbOENsLE7keH4d51u0bxafcb
         AniVCpLSDfrETFV79dpe3pxQa4jSZ3sGyZznaY+BqEp+jGh1YPCsKm0JUwp18PgsBAIj
         RIBj46tijCcoFO5MjdBK7ahAs6YGjU8glXWPVbe36pWVgXkO/pz60NEI0xw0SLJiA5//
         cwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823260; x=1731428060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhfO8ohnOtNJQi1hI9D3A4FDq/9CsS5R1WgkWnITbx8=;
        b=DssZbj9KVVRsycIkuAU9aLLJbuc523MWD9F9aJrysmnJ12XtdXUfzc+MmK5RlGo1cY
         Xr+1AvnLaEEcgEu57dhmRDRq5/l+g5RsrOZKeRZ3sU7v9YfEM2ub0wi3qx506hZ46yXi
         4dGGHSTsAk0PdTsrgtxGcPQg7VnJoa8nsZnHsT0D7it1JF5QX55Mr04hfHuCYW6naXjR
         SbL6MypK4rA+Noe5JPCWSYAi2BHOJuvYlD6iSQyzyOITe5fTFvIi5pBPglRiIpWSNBAQ
         N+1k4LSVfgikdY7HI4khiEY1yJ8kBVwjCqD8jy3yO+TjibhEs/VfIAkldo4cTvE1amjJ
         HP1w==
X-Gm-Message-State: AOJu0YxAzj85F/K+RA4G7z4AJUzrlZQvF9bfZGBdXh2Ux3F8ByraF5gt
	+xY+pXfgEvskwZt93MLyXdQmXbpvGezUvpYpHLSGVM54pnv4Yr58JKmqFboJvnq37aWYrj0eyZ8
	QPN6vLpRngQ1utdQrMv+vQqrFQymyuv9j6Ou94CK6qIosY1nHlHBFjUeRzj6R+DiGC0CJa9qxcF
	Eht6kKYxt9765EMmrpsp9OJtLfm60SxA==
X-Google-Smtp-Source: AGHT+IEunqYkD2invRN5aFCO1Fz2RABAs2iohlsBH2Q4XA5ZLGkwm043sZB8E/a/R53LQfgmz7W0gc9F
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:ade8:0:b0:e11:5da7:337 with SMTP id
 3f1490d57ef6-e3087a4b553mr58004276.3.1730823259211; Tue, 05 Nov 2024 08:14:19
 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:05 +0100
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160859.1459261-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8874; i=ardb@kernel.org;
 h=from:subject; bh=NY3GF5MSQ9ZMgCYjt+TDh25uIssEg93ZXjzQFK1S8a0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWVk1fNL8a9calWaZXP1R9+nAsV6+azr3vvuWJZ2Y7
 b64zSy4o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkrpPhD5dxobN6Sq7uhE7z
 O7HnLTZxxZ2dH6badXipwbben/l3exn+6e86F/D8dG7AtI8fWL8tkAs6uXT10f3n5tpnKwVeUvc UZAcA
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-13-ardb+git@google.com>
Subject: [PATCH v2 5/6] crypto: arm/crct10dif - Macroify PMULL asm code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

To allow an alternative version to be created of the PMULL based
CRC-T10DIF algorithm, turn the bulk of it into a macro, except for the
final reduction, which will only be used by the existing version.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 154 ++++++++++----------
 arch/arm/crypto/crct10dif-ce-glue.c |  10 +-
 2 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 4dac32e020de..6b72167574b2 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -112,48 +112,42 @@
 	FOLD_CONST_L	.req	q10l
 	FOLD_CONST_H	.req	q10h
 
+        .macro		pmull16x64_p64, v16, v64
+	vmull.p64	q11, \v64\()l, \v16\()_L
+	vmull.p64	\v64, \v64\()h, \v16\()_H
+	veor		\v64, \v64, q11
+	.endm
+
 	// Fold reg1, reg2 into the next 32 data bytes, storing the result back
 	// into reg1, reg2.
-	.macro		fold_32_bytes, reg1, reg2
-	vld1.64		{q11-q12}, [buf]!
+	.macro		fold_32_bytes, reg1, reg2, p
+	vld1.64		{q8-q9}, [buf]!
 
-	vmull.p64	q8, \reg1\()h, FOLD_CONST_H
-	vmull.p64	\reg1, \reg1\()l, FOLD_CONST_L
-	vmull.p64	q9, \reg2\()h, FOLD_CONST_H
-	vmull.p64	\reg2, \reg2\()l, FOLD_CONST_L
+	pmull16x64_\p	FOLD_CONST, \reg1
+	pmull16x64_\p	FOLD_CONST, \reg2
 
-CPU_LE(	vrev64.8	q11, q11	)
-CPU_LE(	vrev64.8	q12, q12	)
-	vswp		q11l, q11h
-	vswp		q12l, q12h
+CPU_LE(	vrev64.8	q8, q8	)
+CPU_LE(	vrev64.8	q9, q9	)
+	vswp		q8l, q8h
+	vswp		q9l, q9h
 
 	veor.8		\reg1, \reg1, q8
 	veor.8		\reg2, \reg2, q9
-	veor.8		\reg1, \reg1, q11
-	veor.8		\reg2, \reg2, q12
 	.endm
 
 	// Fold src_reg into dst_reg, optionally loading the next fold constants
-	.macro		fold_16_bytes, src_reg, dst_reg, load_next_consts
-	vmull.p64	q8, \src_reg\()l, FOLD_CONST_L
-	vmull.p64	\src_reg, \src_reg\()h, FOLD_CONST_H
+	.macro		fold_16_bytes, src_reg, dst_reg, p, load_next_consts
+	pmull16x64_\p	FOLD_CONST, \src_reg
 	.ifnb		\load_next_consts
 	vld1.64		{FOLD_CONSTS}, [fold_consts_ptr, :128]!
 	.endif
-	veor.8		\dst_reg, \dst_reg, q8
 	veor.8		\dst_reg, \dst_reg, \src_reg
 	.endm
 
-//
-// u16 crc_t10dif_pmull(u16 init_crc, const u8 *buf, size_t len);
-//
-// Assumes len >= 16.
-//
-ENTRY(crc_t10dif_pmull)
-
+	.macro		crct10dif, p
 	// For sizes less than 256 bytes, we can't fold 128 bytes at a time.
 	cmp		len, #256
-	blt		.Lless_than_256_bytes
+	blt		.Lless_than_256_bytes\@
 
 	mov_l		fold_consts_ptr, .Lfold_across_128_bytes_consts
 
@@ -194,27 +188,27 @@ CPU_LE(	vrev64.8	q7, q7	)
 
 	// While >= 128 data bytes remain (not counting q0-q7), fold the 128
 	// bytes q0-q7 into them, storing the result back into q0-q7.
-.Lfold_128_bytes_loop:
-	fold_32_bytes	q0, q1
-	fold_32_bytes	q2, q3
-	fold_32_bytes	q4, q5
-	fold_32_bytes	q6, q7
+.Lfold_128_bytes_loop\@:
+	fold_32_bytes	q0, q1, \p
+	fold_32_bytes	q2, q3, \p
+	fold_32_bytes	q4, q5, \p
+	fold_32_bytes	q6, q7, \p
 	subs		len, len, #128
-	bge		.Lfold_128_bytes_loop
+	bge		.Lfold_128_bytes_loop\@
 
 	// Now fold the 112 bytes in q0-q6 into the 16 bytes in q7.
 
 	// Fold across 64 bytes.
 	vld1.64		{FOLD_CONSTS}, [fold_consts_ptr, :128]!
-	fold_16_bytes	q0, q4
-	fold_16_bytes	q1, q5
-	fold_16_bytes	q2, q6
-	fold_16_bytes	q3, q7, 1
+	fold_16_bytes	q0, q4, \p
+	fold_16_bytes	q1, q5, \p
+	fold_16_bytes	q2, q6, \p
+	fold_16_bytes	q3, q7, \p, 1
 	// Fold across 32 bytes.
-	fold_16_bytes	q4, q6
-	fold_16_bytes	q5, q7, 1
+	fold_16_bytes	q4, q6, \p
+	fold_16_bytes	q5, q7, \p, 1
 	// Fold across 16 bytes.
-	fold_16_bytes	q6, q7
+	fold_16_bytes	q6, q7, \p
 
 	// Add 128 to get the correct number of data bytes remaining in 0...127
 	// (not counting q7), following the previous extra subtraction by 128.
@@ -224,25 +218,23 @@ CPU_LE(	vrev64.8	q7, q7	)
 
 	// While >= 16 data bytes remain (not counting q7), fold the 16 bytes q7
 	// into them, storing the result back into q7.
-	blt		.Lfold_16_bytes_loop_done
-.Lfold_16_bytes_loop:
-	vmull.p64	q8, q7l, FOLD_CONST_L
-	vmull.p64	q7, q7h, FOLD_CONST_H
-	veor.8		q7, q7, q8
+	blt		.Lfold_16_bytes_loop_done\@
+.Lfold_16_bytes_loop\@:
+	pmull16x64_\p	FOLD_CONST, q7
 	vld1.64		{q0}, [buf]!
 CPU_LE(	vrev64.8	q0, q0	)
 	vswp		q0l, q0h
 	veor.8		q7, q7, q0
 	subs		len, len, #16
-	bge		.Lfold_16_bytes_loop
+	bge		.Lfold_16_bytes_loop\@
 
-.Lfold_16_bytes_loop_done:
+.Lfold_16_bytes_loop_done\@:
 	// Add 16 to get the correct number of data bytes remaining in 0...15
 	// (not counting q7), following the previous extra subtraction by 16.
 	adds		len, len, #16
-	beq		.Lreduce_final_16_bytes
+	beq		.Lreduce_final_16_bytes\@
 
-.Lhandle_partial_segment:
+.Lhandle_partial_segment\@:
 	// Reduce the last '16 + len' bytes where 1 <= len <= 15 and the first
 	// 16 bytes are in q7 and the rest are the remaining data in 'buf'.  To
 	// do this without needing a fold constant for each possible 'len',
@@ -277,12 +269,46 @@ CPU_LE(	vrev64.8	q0, q0	)
 	vbsl.8		q2, q1, q0
 
 	// Fold the first chunk into the second chunk, storing the result in q7.
-	vmull.p64	q0, q3l, FOLD_CONST_L
-	vmull.p64	q7, q3h, FOLD_CONST_H
-	veor.8		q7, q7, q0
-	veor.8		q7, q7, q2
+	pmull16x64_\p	FOLD_CONST, q3
+	veor.8		q7, q3, q2
+	b		.Lreduce_final_16_bytes\@
+
+.Lless_than_256_bytes\@:
+	// Checksumming a buffer of length 16...255 bytes
+
+	mov_l		fold_consts_ptr, .Lfold_across_16_bytes_consts
+
+	// Load the first 16 data bytes.
+	vld1.64		{q7}, [buf]!
+CPU_LE(	vrev64.8	q7, q7	)
+	vswp		q7l, q7h
+
+	// XOR the first 16 data *bits* with the initial CRC value.
+	vmov.i8		q0h, #0
+	vmov.u16	q0h[3], init_crc
+	veor.8		q7h, q7h, q0h
+
+	// Load the fold-across-16-bytes constants.
+	vld1.64		{FOLD_CONSTS}, [fold_consts_ptr, :128]!
+
+	cmp		len, #16
+	beq		.Lreduce_final_16_bytes\@	// len == 16
+	subs		len, len, #32
+	addlt		len, len, #16
+	blt		.Lhandle_partial_segment\@	// 17 <= len <= 31
+	b		.Lfold_16_bytes_loop\@		// 32 <= len <= 255
+
+.Lreduce_final_16_bytes\@:
+	.endm
+
+//
+// u16 crc_t10dif_pmull(u16 init_crc, const u8 *buf, size_t len);
+//
+// Assumes len >= 16.
+//
+ENTRY(crc_t10dif_pmull64)
+	crct10dif	p64
 
-.Lreduce_final_16_bytes:
 	// Reduce the 128-bit value M(x), stored in q7, to the final 16-bit CRC.
 
 	// Load 'x^48 * (x^48 mod G(x))' and 'x^48 * (x^80 mod G(x))'.
@@ -316,31 +342,7 @@ CPU_LE(	vrev64.8	q0, q0	)
 	vmov.u16	r0, q0l[0]
 	bx		lr
 
-.Lless_than_256_bytes:
-	// Checksumming a buffer of length 16...255 bytes
-
-	mov_l		fold_consts_ptr, .Lfold_across_16_bytes_consts
-
-	// Load the first 16 data bytes.
-	vld1.64		{q7}, [buf]!
-CPU_LE(	vrev64.8	q7, q7	)
-	vswp		q7l, q7h
-
-	// XOR the first 16 data *bits* with the initial CRC value.
-	vmov.i8		q0h, #0
-	vmov.u16	q0h[3], init_crc
-	veor.8		q7h, q7h, q0h
-
-	// Load the fold-across-16-bytes constants.
-	vld1.64		{FOLD_CONSTS}, [fold_consts_ptr, :128]!
-
-	cmp		len, #16
-	beq		.Lreduce_final_16_bytes		// len == 16
-	subs		len, len, #32
-	addlt		len, len, #16
-	blt		.Lhandle_partial_segment	// 17 <= len <= 31
-	b		.Lfold_16_bytes_loop		// 32 <= len <= 255
-ENDPROC(crc_t10dif_pmull)
+ENDPROC(crc_t10dif_pmull64)
 
 	.section	".rodata", "a"
 	.align		4
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index 79f3b204d8c0..60aa79c2fcdb 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -19,7 +19,7 @@
 
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
-asmlinkage u16 crc_t10dif_pmull(u16 init_crc, const u8 *buf, size_t len);
+asmlinkage u16 crc_t10dif_pmull64(u16 init_crc, const u8 *buf, size_t len);
 
 static int crct10dif_init(struct shash_desc *desc)
 {
@@ -29,14 +29,14 @@ static int crct10dif_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int crct10dif_update(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
+static int crct10dif_update_ce(struct shash_desc *desc, const u8 *data,
+			       unsigned int length)
 {
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull(*crc, data, length);
+		*crc = crc_t10dif_pmull64(*crc, data, length);
 		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
@@ -56,7 +56,7 @@ static int crct10dif_final(struct shash_desc *desc, u8 *out)
 static struct shash_alg crc_t10dif_alg = {
 	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
 	.init			= crct10dif_init,
-	.update			= crct10dif_update,
+	.update			= crct10dif_update_ce,
 	.final			= crct10dif_final,
 	.descsize		= CRC_T10DIF_DIGEST_SIZE,
 
-- 
2.47.0.199.ga7371fff76-goog


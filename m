Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A33F18FC7F
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142165; cv=none; b=PVeWnN+gqISVpGhPgcitrJw6CqORQnngChJzT0k/dsjVOIXqFb1RlV7g5HO1opdGspaUlsSZjAQ710pZYhpDEiP3sodTw9J3WKlVBIqRla70Jx3F4/3RkpNIMnmubHewiz6EaK2XD9ScFUepfw1z30LSWogAS6bZJGJigbOgN2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142165; c=relaxed/simple;
	bh=nwY684iR07A5eO6c9bY9cKtPOT58y/mdXOtnSAc1PYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W21yCN0lK7VDv49P3SVcI93G8zpb6L8tagD2/2um5aSy5luYD5U8M8quoo4tAcKB+e/iIpgmT/DkLCHtymKox3u8ebAt4J3aqzbpLm7d00qn658zayY3o0Gszn4AWYha9imhK+/nO/2RhJFY0JOQqfZjF1iTbAp9LpSrarz6XB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMombk4V; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMombk4V"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159159528so7978961276.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142162; x=1730746962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+ea6V2hCZg+NCY52pVq8zKTlUngbGyAnKf6QaYWs/I=;
        b=JMombk4VHNWkdDygECGcmi1CXY9n5MH4dd0jQA5xej7JJtuMaKz8UsEyIx9MZn/ofS
         Fv2Mh1Wewpf+i74UHRmzPnL3IK+Nad2l53Kias5FOBXp7qgtXH9oNiLvIQfpsJNJDdIZ
         PNGFY/8z8OdnQ1VvIi82ZtNI4fP/rAndM6tjqt0IHfiaqD7r8EBA4IOtV/cAprHKnU8a
         RUSJJ+TW/4wH8WqqefkZA7+GUo3Qk7jtU3MEpJK2+glJOI3yevPxrJXK8jLoOsXkoF2f
         P6MmDe7BxTAEMpeIA9RzWWSRIkK+zoKdw1EfBlXI0G7oLf0sQeYHa8gONZVj3bvPdwFl
         2Kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142162; x=1730746962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+ea6V2hCZg+NCY52pVq8zKTlUngbGyAnKf6QaYWs/I=;
        b=QUebWDBvBVoRlaHCSn+mqdXXRGDqRNY5pT6TlksAWQmKayVmW24ePMJErrMRF5qP9K
         kmHNANQ00qNMWH+XSpBFQX0I8ck9LEG5AtP26hofDeYN8NuSRmVjqQacROFnEVO5olFu
         2RwVtYmA5+TmvspNGNG0nw9axaPuIXENcLFV7icNnwZdrqBhs/Pn2ihlJ6umpY9/RnWA
         qy8vdAtJR8EFmr9jh4cpA1clN1SQFG1fFj05Dg8w/AZ0brvKVU7SDgs+1noH3FsOPhOa
         f+GKkPz9CkGBcQ+hjbj1zs2mUVkCYfClb4mZF1A9exXYMiNgejM418rQp8VUf6tZ5j/Y
         bN5Q==
X-Gm-Message-State: AOJu0YwjhK4rMc/AtrRuxJwVO0XsSrIFAFDKUgEnfHPl5TxWVKPLd9lz
	bEYr6n9lKTwz+7koAjdOHHr5V2TmnLJ88CgFio2FBe88Di24j+6bdM4HbXwg67xGDaoqfDgQsKF
	YP9MMpL41HLHUhFWfp4lt8Mh05TXYz6Vby0AbYo6MHAd29l+cgfiXISnj3YTei0FhgcM1HwypiC
	61uFoKMM7oCINKDx2Y+PkmsTsMPqCmww==
X-Google-Smtp-Source: AGHT+IE8Rd9TRCmShmTbPLcE1CtUdzs1DteQhuZC4fakDWbu1rlZa6KR9r0aRWRJLZx0de/e72Sf+en7
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:6902:8b:b0:e29:7454:e773 with SMTP id
 3f1490d57ef6-e30bc85e5b9mr10810276.5.1730142161238; Mon, 28 Oct 2024 12:02:41
 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:13 +0100
In-Reply-To: <20241028190207.1394367-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028190207.1394367-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8825; i=ardb@kernel.org;
 h=from:subject; bh=8Kp3llqJWIWDmtrbK3FJDxKfev/q+y1BeWnPR55aiXo=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/var8RfVjhpwGP7Mbf9y3YK55UT2IZOI+n/VPflZd
 wS9+mM7SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERi6xj+Byncnj8/XuhVlygv
 0+mg66v3+PfMLXkW9pLJceVGxcgjwYwMj1zW5SxTPdDm2et/qMhoX86jG5K2G95b92a9ONrt587 IBgA=
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-13-ardb+git@google.com>
Subject: [PATCH 5/6] crypto: arm/crct10dif - Macroify PMULL asm code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

To allow an alternative version to be created of the PMULL based
CRC-T10DIF algorithm, turn the bulk of it into a macro, except for the
final reduction, which will only be used by the existing version.

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
2.47.0.163.g1226f6d8fa-goog


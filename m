Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A940C4502A;
	Wed,  1 Apr 2026 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775003670; cv=none; b=IrsSeNgrITlQMLw9FIHErwvrlz3VEOzZfuFvDwZ/GxrEjPTw3DlZ51CFSX+av2hPDtJFHAz2nzW/0RHSDOWd80v9GIVsW5B0Pje46SPBwn4s5/SyWF8itUC/G7rIcb07Tuuk186A37HLoPNxNEfaB0swvgzN0wtB6QX+pJuezs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775003670; c=relaxed/simple;
	bh=VpHeH44XZng0UMFqUqD2vVptB3ioxQsCJFSniXTISVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJ3qT2Pn1E5JAQdXMzVnx34JHZcETybMcfCVSVibheIjc1VnsqL5AJEoC/ipPrh0qmQs5Dt4hCmgzeEOAKi+vVnZshMp+rimpjRa2IXjvk7kpfYmbRyK9YQD5+ROFSVbSo9jOawkX5cc7P5Tb1iXB7b/fi4skOjISG+TG2nA88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ejbe38nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ejbe38nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1107EC19423;
	Wed,  1 Apr 2026 00:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775003670;
	bh=VpHeH44XZng0UMFqUqD2vVptB3ioxQsCJFSniXTISVA=;
	h=From:To:Cc:Subject:Date:From;
	b=Ejbe38nCVKmLxyG8tPo+z6F0cAOgBozezufEDkEaSo0Z6GA++3IuTu0WlrrJ7bdRn
	 TT6theADFton7hB+oijC86cuFDP+D7WhaQw1/3txVZxUr68RU0SNaLN4k3IHZZ7G5L
	 Np4vS/Cq5z7RJWSMPJ4fOYiSOFghCp+PZIbODMSTbjBownvHuPxoWLg73oblpOk67E
	 jvT4tIczVTFudzPrXxsrNhjPfYLMWkZzq1RCKZp4on+ItsArjHN5K/KP014XGUS8Wd
	 RJmiHT23m4aEEU+HSeQ/7ECUbZiaBRHSvbSmRhyDoHNmsOWhtsT/DGCXcrR+RRm203
	 rKe/d8KfEMM1A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm64: Assume a little-endian kernel
Date: Tue, 31 Mar 2026 17:33:31 -0700
Message-ID: <20260401003331.144065-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since support for big-endian arm64 kernels was removed, the CPU_LE()
macro now unconditionally emits the code it is passed, and the CPU_BE()
macro now unconditionally discards the code it is passed.

Simplify the assembly code in lib/crypto/arm64/ accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/arm64/aes-cipher-core.S  | 10 -------
 lib/crypto/arm64/chacha-neon-core.S | 16 -----------
 lib/crypto/arm64/ghash-neon-core.S  |  2 +-
 lib/crypto/arm64/sha1-ce-core.S     |  8 +++---
 lib/crypto/arm64/sha256-ce.S        | 41 +++++++++++++----------------
 lib/crypto/arm64/sha512-ce-core.S   | 16 +++++------
 lib/crypto/arm64/sm3-ce-core.S      |  8 +++---
 7 files changed, 36 insertions(+), 65 deletions(-)

diff --git a/lib/crypto/arm64/aes-cipher-core.S b/lib/crypto/arm64/aes-cipher-core.S
index 651f701c56a86..0b05ec4be65fb 100644
--- a/lib/crypto/arm64/aes-cipher-core.S
+++ b/lib/crypto/arm64/aes-cipher-core.S
@@ -85,15 +85,10 @@
 	ldp		w4, w5, [in]
 	ldp		w6, w7, [in, #8]
 	ldp		w8, w9, [rk], #16
 	ldp		w10, w11, [rk, #-8]
 
-CPU_BE(	rev		w4, w4		)
-CPU_BE(	rev		w5, w5		)
-CPU_BE(	rev		w6, w6		)
-CPU_BE(	rev		w7, w7		)
-
 	eor		w4, w4, w8
 	eor		w5, w5, w9
 	eor		w6, w6, w10
 	eor		w7, w7, w11
 
@@ -110,15 +105,10 @@ CPU_BE(	rev		w7, w7		)
 2:	\round		w4, w5, w6, w7, w8, w9, w10, w11
 	b		0b
 3:	adr_l		tt, \ltab
 	\round		w4, w5, w6, w7, w8, w9, w10, w11, \bsz, b
 
-CPU_BE(	rev		w4, w4		)
-CPU_BE(	rev		w5, w5		)
-CPU_BE(	rev		w6, w6		)
-CPU_BE(	rev		w7, w7		)
-
 	stp		w4, w5, [out]
 	stp		w6, w7, [out, #8]
 	ret
 	.endm
 
diff --git a/lib/crypto/arm64/chacha-neon-core.S b/lib/crypto/arm64/chacha-neon-core.S
index 80079586ecc7a..cb18eec968bdf 100644
--- a/lib/crypto/arm64/chacha-neon-core.S
+++ b/lib/crypto/arm64/chacha-neon-core.S
@@ -529,14 +529,10 @@ SYM_FUNC_START(chacha_4block_xor_neon)
 	  add		a0, a0, w6
 	  add		a1, a1, w7
 	add		v3.4s, v3.4s, v19.4s
 	  add		a2, a2, w8
 	  add		a3, a3, w9
-CPU_BE(	  rev		a0, a0		)
-CPU_BE(	  rev		a1, a1		)
-CPU_BE(	  rev		a2, a2		)
-CPU_BE(	  rev		a3, a3		)
 
 	ld4r		{v24.4s-v27.4s}, [x0], #16
 	ld4r		{v28.4s-v31.4s}, [x0]
 
 	// x4[0-3] += s1[0]
@@ -553,14 +549,10 @@ CPU_BE(	  rev		a3, a3		)
 	  add		a4, a4, w6
 	  add		a5, a5, w7
 	add		v7.4s, v7.4s, v23.4s
 	  add		a6, a6, w8
 	  add		a7, a7, w9
-CPU_BE(	  rev		a4, a4		)
-CPU_BE(	  rev		a5, a5		)
-CPU_BE(	  rev		a6, a6		)
-CPU_BE(	  rev		a7, a7		)
 
 	// x8[0-3] += s2[0]
 	// x9[0-3] += s2[1]
 	// x10[0-3] += s2[2]
 	// x11[0-3] += s2[3]
@@ -574,14 +566,10 @@ CPU_BE(	  rev		a7, a7		)
 	  add		a8, a8, w6
 	  add		a9, a9, w7
 	add		v11.4s, v11.4s, v27.4s
 	  add		a10, a10, w8
 	  add		a11, a11, w9
-CPU_BE(	  rev		a8, a8		)
-CPU_BE(	  rev		a9, a9		)
-CPU_BE(	  rev		a10, a10	)
-CPU_BE(	  rev		a11, a11	)
 
 	// x12[0-3] += s3[0]
 	// x13[0-3] += s3[1]
 	// x14[0-3] += s3[2]
 	// x15[0-3] += s3[3]
@@ -595,14 +583,10 @@ CPU_BE(	  rev		a11, a11	)
 	  add		a12, a12, w6
 	  add		a13, a13, w7
 	add		v15.4s, v15.4s, v31.4s
 	  add		a14, a14, w8
 	  add		a15, a15, w9
-CPU_BE(	  rev		a12, a12	)
-CPU_BE(	  rev		a13, a13	)
-CPU_BE(	  rev		a14, a14	)
-CPU_BE(	  rev		a15, a15	)
 
 	// interleave 32-bit words in state n, n+1
 	  ldp		w6, w7, [x2], #64
 	zip1		v16.4s, v0.4s, v1.4s
 	  ldp		w8, w9, [x2, #-56]
diff --git a/lib/crypto/arm64/ghash-neon-core.S b/lib/crypto/arm64/ghash-neon-core.S
index 85b20fcd98fef..4c5799172b49c 100644
--- a/lib/crypto/arm64/ghash-neon-core.S
+++ b/lib/crypto/arm64/ghash-neon-core.S
@@ -190,11 +190,11 @@ SYM_FUNC_START(pmull_ghash_update_p8)
 
 0:	ld1		{T1.2d}, [x2], #16
 	sub		x0, x0, #1
 
 	/* multiply XL by SHASH in GF(2^128) */
-CPU_LE(	rev64		T1.16b, T1.16b	)
+	rev64		T1.16b, T1.16b
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
 	eor		T1.16b, T1.16b, T2.16b
 	eor		XL.16b, XL.16b, IN1.16b
diff --git a/lib/crypto/arm64/sha1-ce-core.S b/lib/crypto/arm64/sha1-ce-core.S
index 8fbd4767f0f0c..128d8393c94fb 100644
--- a/lib/crypto/arm64/sha1-ce-core.S
+++ b/lib/crypto/arm64/sha1-ce-core.S
@@ -78,14 +78,14 @@ SYM_FUNC_START(__sha1_ce_transform)
 
 	/* load input */
 0:	ld1		{v8.4s-v11.4s}, [x1], #64
 	sub		x2, x2, #1
 
-CPU_LE(	rev32		v8.16b, v8.16b		)
-CPU_LE(	rev32		v9.16b, v9.16b		)
-CPU_LE(	rev32		v10.16b, v10.16b	)
-CPU_LE(	rev32		v11.16b, v11.16b	)
+	rev32		v8.16b, v8.16b
+	rev32		v9.16b, v9.16b
+	rev32		v10.16b, v10.16b
+	rev32		v11.16b, v11.16b
 
 	add		t0.4s, v8.4s, k0.4s
 	mov		dg0v.16b, dgav.16b
 
 	add_update	c, ev, k0,  8,  9, 10, 11, dgb
diff --git a/lib/crypto/arm64/sha256-ce.S b/lib/crypto/arm64/sha256-ce.S
index e4bfe42a61a92..f9319aef7b329 100644
--- a/lib/crypto/arm64/sha256-ce.S
+++ b/lib/crypto/arm64/sha256-ce.S
@@ -92,14 +92,14 @@ SYM_FUNC_START(__sha256_ce_transform)
 
 	/* load input */
 0:	ld1		{v16.4s-v19.4s}, [x1], #64
 	sub		x2, x2, #1
 
-CPU_LE(	rev32		v16.16b, v16.16b	)
-CPU_LE(	rev32		v17.16b, v17.16b	)
-CPU_LE(	rev32		v18.16b, v18.16b	)
-CPU_LE(	rev32		v19.16b, v19.16b	)
+	rev32		v16.16b, v16.16b
+	rev32		v17.16b, v17.16b
+	rev32		v18.16b, v18.16b
+	rev32		v19.16b, v19.16b
 
 	add		t0.4s, v16.4s, v0.4s
 	mov		dg0v.16b, dgav.16b
 	mov		dg1v.16b, dgbv.16b
 
@@ -291,18 +291,18 @@ SYM_FUNC_START(sha256_ce_finup2x)
 	// Load the next two data blocks.
 	ld1		{v16.4s-v19.4s}, [data1], #64
 	ld1		{v20.4s-v23.4s}, [data2], #64
 .Lfinup2x_loop_have_data:
 	// Convert the words of the data blocks from big endian.
-CPU_LE(	rev32		v16.16b, v16.16b	)
-CPU_LE(	rev32		v17.16b, v17.16b	)
-CPU_LE(	rev32		v18.16b, v18.16b	)
-CPU_LE(	rev32		v19.16b, v19.16b	)
-CPU_LE(	rev32		v20.16b, v20.16b	)
-CPU_LE(	rev32		v21.16b, v21.16b	)
-CPU_LE(	rev32		v22.16b, v22.16b	)
-CPU_LE(	rev32		v23.16b, v23.16b	)
+	rev32		v16.16b, v16.16b
+	rev32		v17.16b, v17.16b
+	rev32		v18.16b, v18.16b
+	rev32		v19.16b, v19.16b
+	rev32		v20.16b, v20.16b
+	rev32		v21.16b, v21.16b
+	rev32		v22.16b, v22.16b
+	rev32		v23.16b, v23.16b
 .Lfinup2x_loop_have_bswapped_data:
 
 	// Save the original state for each block.
 	st1		{state0_a.4s-state1_b.4s}, [sp]
 
@@ -338,23 +338,20 @@ CPU_LE(	rev32		v23.16b, v23.16b	)
 	// and load from &sp[64 - len] to get the needed padding block.  This
 	// code relies on the data buffers being >= 64 bytes in length.
 	sub		w8, len, #64		// w8 = len - 64
 	add		data1, data1, w8, sxtw	// data1 += len - 64
 	add		data2, data2, w8, sxtw	// data2 += len - 64
-CPU_LE(	mov		x9, #0x80		)
-CPU_LE(	fmov		d16, x9			)
-CPU_BE(	movi		v16.16b, #0		)
-CPU_BE(	mov		x9, #0x8000000000000000	)
-CPU_BE(	mov		v16.d[1], x9		)
+	mov		x9, #0x80
+	fmov		d16, x9
 	movi		v17.16b, #0
 	stp		q16, q17, [sp, #64]
 	stp		q17, q17, [sp, #96]
 	sub		x9, sp, w8, sxtw	// x9 = &sp[64 - len]
 	cmp		len, #56
 	b.ge		1f		// will count spill into its own block?
 	lsl		count, count, #3
-CPU_LE(	rev		count, count		)
+	rev		count, count
 	str		count, [x9, #56]
 	mov		final_step, #2	// won't need count-only block
 	b		2f
 1:
 	mov		final_step, #1	// will need count-only block
@@ -395,14 +392,14 @@ CPU_LE(	rev		count, count		)
 	mov		final_step, #2
 	b		.Lfinup2x_loop_have_bswapped_data
 
 .Lfinup2x_done:
 	// Write the two digests with all bytes in the correct order.
-CPU_LE(	rev32		state0_a.16b, state0_a.16b	)
-CPU_LE(	rev32		state1_a.16b, state1_a.16b	)
-CPU_LE(	rev32		state0_b.16b, state0_b.16b	)
-CPU_LE(	rev32		state1_b.16b, state1_b.16b	)
+	rev32		state0_a.16b, state0_a.16b
+	rev32		state1_a.16b, state1_a.16b
+	rev32		state0_b.16b, state0_b.16b
+	rev32		state1_b.16b, state1_b.16b
 	st1		{state0_a.4s-state1_a.4s}, [out1]
 	st1		{state0_b.4s-state1_b.4s}, [out2]
 	add		sp, sp, #128
 	ret
 SYM_FUNC_END(sha256_ce_finup2x)
diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
index ffd51acfd1eed..0d472f5a48f95 100644
--- a/lib/crypto/arm64/sha512-ce-core.S
+++ b/lib/crypto/arm64/sha512-ce-core.S
@@ -108,18 +108,18 @@ SYM_FUNC_START(__sha512_ce_transform)
 	/* load input */
 0:	ld1		{v12.2d-v15.2d}, [x1], #64
 	ld1		{v16.2d-v19.2d}, [x1], #64
 	sub		x2, x2, #1
 
-CPU_LE(	rev64		v12.16b, v12.16b	)
-CPU_LE(	rev64		v13.16b, v13.16b	)
-CPU_LE(	rev64		v14.16b, v14.16b	)
-CPU_LE(	rev64		v15.16b, v15.16b	)
-CPU_LE(	rev64		v16.16b, v16.16b	)
-CPU_LE(	rev64		v17.16b, v17.16b	)
-CPU_LE(	rev64		v18.16b, v18.16b	)
-CPU_LE(	rev64		v19.16b, v19.16b	)
+	rev64		v12.16b, v12.16b
+	rev64		v13.16b, v13.16b
+	rev64		v14.16b, v14.16b
+	rev64		v15.16b, v15.16b
+	rev64		v16.16b, v16.16b
+	rev64		v17.16b, v17.16b
+	rev64		v18.16b, v18.16b
+	rev64		v19.16b, v19.16b
 
 	mov		x4, x3				// rc pointer
 
 	mov		v0.16b, v8.16b
 	mov		v1.16b, v9.16b
diff --git a/lib/crypto/arm64/sm3-ce-core.S b/lib/crypto/arm64/sm3-ce-core.S
index 9cef7ea7f34f0..ee7f900d7cff7 100644
--- a/lib/crypto/arm64/sm3-ce-core.S
+++ b/lib/crypto/arm64/sm3-ce-core.S
@@ -89,14 +89,14 @@ SYM_FUNC_START(sm3_ce_transform)
 	sub		x2, x2, #1
 
 	mov		v15.16b, v8.16b
 	mov		v16.16b, v9.16b
 
-CPU_LE(	rev32		v0.16b, v0.16b		)
-CPU_LE(	rev32		v1.16b, v1.16b		)
-CPU_LE(	rev32		v2.16b, v2.16b		)
-CPU_LE(	rev32		v3.16b, v3.16b		)
+	rev32		v0.16b, v0.16b
+	rev32		v1.16b, v1.16b
+	rev32		v2.16b, v2.16b
+	rev32		v3.16b, v3.16b
 
 	ext		v11.16b, v13.16b, v13.16b, #4
 
 	qround		a, v0, v1, v2, v3, v4
 	qround		a, v1, v2, v3, v4, v0

base-commit: d2a68aba8505ce88b39c34ecb3b707c776af79d4
-- 
2.53.0


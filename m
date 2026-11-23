Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427662;
	b=cXkKkk+KNIwubA4XxLCyd8AP6lXihqIKdIvpTcjDSkWhiFUtfBlWparg+6UVB+7Z6/19
	 I9rHYO+BWLVna7kUK2QmmSn2S4VCYU67J7bJGIdxD9Cj48am2UKFwTLAuzW6S3vS9a0SO
	 wrbHLCgRoV+Qpp97PeQZ/PAMRvk4e3ZWZpiatfSurBqxUwC8/oad7Nl8L9pntO1y3dGns
	 S4c0CEjypFpCgatuFervOwy10Kh79U3zDoeQWYW8jRzMnjXWJKN0BAQiap5BS4m8HRupC
	 6QqDNWsdQ7e7TBjJ6a/tPGkbh9HQQPbeLpXyOhJoQHcuXJdMmr9GLWywgpqW5ZPoF1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427662;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=7HOXkSCNWvyVWx6q6hDc6NLtC4mRnDiCjTZ1sm/RAuE=;
	b=zu9dIzR+LUsAUT3diTNIXna+G56dZAh+TkPE8SOH4kybusHj+YFnKTXFq052Vn30WiXN
	 6J8gedXJ7DoM0aRo9D9gh/pSaCEqoJc2MsLV+q2E9rt8+gJPD/FjtN8yyuFvj9ZYExBkg
	 NbqiulCa1rQidNMzRzXtpu4OprPT+mnE5/9Ogta/v3VS0D/AOF+yi2guzxyGKZHzZMJey
	 rsORGwMTtIaIBHNOIKdx9ig7X8pq8nt2k3oqURiLXwyzfc+2uErhdg/X4yowOHTT4HNwc
	 ktekrJL7VJKnM0DllE6DwrctDOuVY1Et50eysF2fgF25pfk1bSN+hVpdF2v4sUFOkMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wMIYWWZr;
	arc=none smtp.remote-ip=91.218.175.85
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8C1606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 09:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E8C1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wMIYWWZr
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=F+mh6Y3DXWZ9JkBmyCGL+5bAF/yOYFH3mf3xvdlmZjA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795427659; v=1; x=1796032459;
 b=wMIYWWZrplRSG9DfqN6gcGDXWFh4vqutDn+txSL3LZqNsNAc4Mx/5Lv0I6jinQXgC+5FQOt6
 6bh1AdVQHbH/9wuxQCoBM2fQA7F0vzNHs6M4wklHXYA5Z3VblMSTg8d5n8Y9yv0w0LzPM9paATH
 dGA+Fs5RudMVMEoZUDZH2kKg=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4a580b26a6a313ab;
	Mon, 23 Nov 2026 09:54:17 +0000
X-Mizu-Trace-ID: 4a580b26a6a313ab
X-Migadu-Flow: FLOW_OUT
From: Qingfang Deng <qingfang.deng@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@vger.kernel.org
Subject: [RFC PATCH] lib/crypto: arm64/ghash: Aggregate 4 blocks per loop
Date: Mon, 23 Nov 2026 17:53:55 +0800
Message-ID: <20261123095409.2518-1-qingfang.deng@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The byte-PMULL GHASH implementation reconstructs and reduces a field
product for every input block. Aggregate four blocks using precomputed
powers of the hash key, which the ARM64 CE version already uses:

  (Y ^ X1) * H^4 ^ X2 * H^3 ^ X3 * H^2 ^ X4 * H

Split each polynomial multiplication into 32-bit Karatsuba products,
pair them in SIMD lanes and accumulate them before reconstruction.
Reconstruct three 128-bit products and perform one Montgomery reduction
for the group. Use three byte PMULL instructions with 0xc2 for reduction
modulo x^128 + x^127 + x^126 + x^121 + 1.

Retain the low and high halves of H^4 through H, and their XORs, in
x4-x15. Use x16-x17 to construct the inner 32-bit cross operands while
independent SIMD products retire. Prepare each next key operand in
v9-v11. This avoids an expanded table of key rotations and needs no
register spills. Use the existing single-block pmull_ghash_update_p8
helper for tails.

Compare the single-block and this four-block path in the same userspace
harness on a Cortex-A53 at 1.2 GHz. Median throughput in Gbit/s:

  Bytes   Baseline   4-block
     16   0.850016   0.844973
     64   1.015665   1.723762
   1440   1.081407   1.968001
  16384   1.085286   2.032019
  65536   1.083460   2.025681

The four-block loop uses 296 instructions, and reaches about 0.980
instructions per cycle in 64 KiB measurements on Cortex-A53.

Assisted-by: LLM
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
---
 include/crypto/gf128hash.h         |   4 +
 lib/crypto/arm64/gf128hash.h       |  22 ++-
 lib/crypto/arm64/ghash-neon-core.S | 207 +++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+), 1 deletion(-)

diff --git a/include/crypto/gf128hash.h b/include/crypto/gf128hash.h
index 41c557d55965..f4638e5be087 100644
--- a/include/crypto/gf128hash.h
+++ b/include/crypto/gf128hash.h
@@ -50,6 +50,10 @@ struct ghash_key {
 #endif
 	/** @h: The hash key H, in POLYVAL format */
 	struct polyval_elem h;
+#if defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_ARM64)
+	/** @h_powers: GHASH powers H^2 through H^4, in POLYVAL format */
+	struct polyval_elem h_powers[3];
+#endif
 };
 
 /**
diff --git a/lib/crypto/arm64/gf128hash.h b/lib/crypto/arm64/gf128hash.h
index 1d1179f87f8d..afcc5da13ab6 100644
--- a/lib/crypto/arm64/gf128hash.h
+++ b/lib/crypto/arm64/gf128hash.h
@@ -15,12 +15,32 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
 asmlinkage void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
 				      const u8 *src,
 				      const struct polyval_elem *h);
+asmlinkage void pmull_ghash_update_p8_4x(size_t blocks, struct polyval_elem *dg,
+					 const u8 *src,
+					 const struct ghash_key *key);
 asmlinkage void polyval_mul_pmull(struct polyval_elem *a,
 				  const struct polyval_elem *b);
 asmlinkage void polyval_blocks_pmull(struct polyval_elem *acc,
 				     const struct polyval_key *key,
 				     const u8 *data, size_t nblocks);
 
+#define ghash_preparekey_arch ghash_preparekey_arch
+static void ghash_preparekey_arch(struct ghash_key *key,
+				  const u8 raw_key[GHASH_BLOCK_SIZE])
+{
+	const struct polyval_elem *prev = &key->h;
+
+	static_assert(offsetof(struct ghash_key, h) == 0);
+	static_assert(offsetof(struct ghash_key, h_powers) == GHASH_BLOCK_SIZE);
+	static_assert(sizeof(*key) == 4 * GHASH_BLOCK_SIZE);
+	ghash_key_to_polyval(raw_key, &key->h);
+	for (int i = 0; i < ARRAY_SIZE(key->h_powers); i++) {
+		key->h_powers[i] = *prev;
+		polyval_mul_generic(&key->h_powers[i], &key->h);
+		prev = &key->h_powers[i];
+	}
+}
+
 #define polyval_preparekey_arch polyval_preparekey_arch
 static void polyval_preparekey_arch(struct polyval_key *key,
 				    const u8 raw_key[POLYVAL_BLOCK_SIZE])
@@ -90,7 +110,7 @@ static void ghash_blocks_arch(struct polyval_elem *acc,
 {
 	if (static_branch_likely(&have_asimd) && may_use_simd()) {
 		scoped_ksimd()
-			pmull_ghash_update_p8(nblocks, acc, data, &key->h);
+			pmull_ghash_update_p8_4x(nblocks, acc, data, key);
 	} else {
 		ghash_blocks_generic(acc, &key->h, data, nblocks);
 	}
diff --git a/lib/crypto/arm64/ghash-neon-core.S b/lib/crypto/arm64/ghash-neon-core.S
index 4c5799172b49..3abeda8cfce4 100644
--- a/lib/crypto/arm64/ghash-neon-core.S
+++ b/lib/crypto/arm64/ghash-neon-core.S
@@ -218,3 +218,210 @@ SYM_FUNC_START(pmull_ghash_update_p8)
 	st1		{XL.2d}, [x1]
 	ret
 SYM_FUNC_END(pmull_ghash_update_p8)
+
+	.text
+
+	/* Prepare the next key operand while retiring the current products. */
+	.macro		__pmull_p8_4x_products, ad, p0, p1, p2, add=0, \
+			lo=x6, hi=x7, cross=0, lo2=x4, hi2=x5
+	tbl		v18.16b, {\ad\().16b}, v25.16b
+	.if		\cross
+	eor		x16, \lo, \lo, lsr #32
+	.endif
+	pmull		v19.8h, \ad\().8b, v9.8b
+	.if		\cross
+	eor		x17, \hi, \hi, lsr #32
+	.endif
+	pmull2		v20.8h, \ad\().16b, v9.16b
+	pmull		v21.8h, \ad\().8b, v10.8b
+	pmull2		v22.8h, \ad\().16b, v10.16b
+	.if		\add
+	eor		v19.16b, v19.16b, v20.16b
+	eor		\p0\().16b, \p0\().16b, v19.16b
+	.else
+	eor		\p0\().16b, v19.16b, v20.16b
+	.endif
+	pmull		v19.8h, v18.8b, v9.8b
+	pmull2		v20.8h, v18.16b, v9.16b
+	.if		\cross
+	fmov		s9, w16
+	eor		x16, \lo2, \lo2, lsr #32
+	.else
+	fmov		d9, \lo
+	.endif
+	eor		v21.16b, v21.16b, v22.16b
+	.if		\cross
+	mov		v9.s[1], w17
+	eor		x17, \hi2, \hi2, lsr #32
+	mov		v9.s[2], w16
+	.else
+	mov		v9.d[1], \hi
+	.endif
+	pmull		v22.8h, \ad\().8b, v11.8b
+	.if		\cross
+	mov		v9.s[3], w17
+	.else
+	tbl		v10.16b, {v9.16b}, v25.16b
+	.endif
+	pmull2		v23.8h, \ad\().16b, v11.16b
+	.if		\cross
+	tbl		v10.16b, {v9.16b}, v25.16b
+	.endif
+	rev32		v11.8h, v9.8h
+	eor		v19.16b, v19.16b, v20.16b
+	.if		\add
+	eor		v21.16b, v21.16b, v19.16b
+	eor		\p1\().16b, \p1\().16b, v21.16b
+	eor		v22.16b, v22.16b, v23.16b
+	eor		\p2\().16b, \p2\().16b, v22.16b
+	.else
+	eor		\p1\().16b, v21.16b, v19.16b
+	eor		\p2\().16b, v22.16b, v23.16b
+	.endif
+	.endm
+
+	.macro		__pmull_p8_4x_reconstruct, rq
+	tbl		v18.16b, {v13.16b}, v26.16b
+	tbl		v19.16b, {v16.16b}, v26.16b
+	tbl		v20.16b, {v13.16b}, v27.16b
+	tbl		v21.16b, {v16.16b}, v27.16b
+	eor		v12.16b, v12.16b, v18.16b
+	eor		v15.16b, v15.16b, v19.16b
+	rev64		v18.4s, v14.4s
+	rev64		v19.4s, v17.4s
+	eor		v12.16b, v12.16b, v20.16b
+	eor		v15.16b, v15.16b, v21.16b
+	eor		v14.16b, v14.16b, v18.16b
+	eor		v17.16b, v17.16b, v19.16b
+	tbl		v14.16b, {v14.16b}, v30.16b
+	tbl		v17.16b, {v17.16b}, v30.16b
+	eor		v12.16b, v12.16b, v14.16b
+	eor		v15.16b, v15.16b, v17.16b
+	eor		v18.16b, v12.16b, v15.16b
+	ext		v19.16b, v18.16b, v18.16b, #8
+	eor		v18.16b, v18.16b, v19.16b
+	tbl		v18.16b, {v18.16b}, v28.16b
+	eor		\rq\().16b, v12.16b, v18.16b
+	.endm
+
+	.macro		__pmull_p8_4x_cross, a, b, out
+	rev64		v18.4s, \a\().4s
+	rev64		v19.4s, \b\().4s
+	eor		v18.16b, v18.16b, \a\().16b
+	eor		v19.16b, v19.16b, \b\().16b
+	uzp1		\out\().4s, v18.4s, v19.4s
+	.endm
+
+	.macro		__pmull_p8_4x_input
+	ld1		{v18.16b-v21.16b}, [x2], #64
+	rev64		v18.16b, v18.16b
+	rev64		v19.16b, v19.16b
+	rev64		v20.16b, v20.16b
+	rev64		v21.16b, v21.16b
+	ext		v31.16b, v31.16b, v31.16b, #8
+	eor		v18.16b, v18.16b, v31.16b
+	zip2		v0.2d, v18.2d, v19.2d
+	zip1		v1.2d, v18.2d, v19.2d
+	zip2		v2.2d, v20.2d, v21.2d
+	zip1		v3.2d, v20.2d, v21.2d
+	eor		v4.16b, v0.16b, v1.16b
+	eor		v5.16b, v2.16b, v3.16b
+	.endm
+
+	.macro		__pmull_p8_4x_reduce
+	eor		v18.16b, v6.16b, v7.16b
+	ext		v19.16b, v6.16b, v7.16b, #8
+	eor		v8.16b, v8.16b, v18.16b
+	eor		v8.16b, v8.16b, v19.16b
+	zip1		v6.2d, v6.2d, v8.2d
+	zip2		v7.2d, v8.2d, v7.2d
+	pmull		v18.8h, v6.8b, v29.8b
+	pmull2		v19.8h, v6.16b, v29.16b
+	eor		v7.16b, v7.16b, v6.16b
+	uzp1		v20.16b, v18.16b, v19.16b
+	uzp2		v21.16b, v18.16b, v19.16b
+	ext		v20.16b, v20.16b, v20.16b, #1
+	shl		v23.2d, v29.2d, #56
+	pmull2		v22.8h, v20.16b, v23.16b
+	eor		v21.16b, v21.16b, v20.16b
+	eor		v7.16b, v7.16b, v21.16b
+	eor		v31.16b, v7.16b, v22.16b
+	.endm
+
+	/*
+	 * x0: block count, x1: POLYVAL accumulator, x2: GHASH input,
+	 * x3: struct ghash_key (H, H^2, H^3, H^4 in POLYVAL format).
+	 *
+	 * x4-x7 retain the low halves of H^4 through H, x8-x11 their high
+	 * halves, and x12-x15 their XORs.  x16-x17 construct the inner
+	 * Karatsuba cross operands.  No stack or callee-saved GPR is used.
+	 */
+SYM_FUNC_START(pmull_ghash_update_p8_4x)
+	cbz		x0, .Lfour_exit
+	cmp		x0, #4
+	b.lo		pmull_ghash_update_p8
+	adr_l		x4, .Lpmull_p8_4x_masks
+	ld1		{v25.16b-v28.16b}, [x4], #64
+	ld1		{v30.16b}, [x4]
+	add		x4, x3, #32
+	ld1		{v0.16b-v1.16b}, [x4]
+	ld1		{v2.16b-v3.16b}, [x3]
+	zip1		v4.2d, v1.2d, v0.2d
+	zip2		v5.2d, v1.2d, v0.2d
+	zip1		v6.2d, v3.2d, v2.2d
+	zip2		v7.2d, v3.2d, v2.2d
+	eor		v8.16b, v4.16b, v5.16b
+	eor		v9.16b, v6.16b, v7.16b
+	umov		x4, v4.d[0]
+	umov		x5, v4.d[1]
+	umov		x6, v6.d[0]
+	umov		x7, v6.d[1]
+	umov		x8, v5.d[0]
+	umov		x9, v5.d[1]
+	umov		x10, v7.d[0]
+	umov		x11, v7.d[1]
+	umov		x12, v8.d[0]
+	umov		x13, v8.d[1]
+	umov		x14, v9.d[0]
+	umov		x15, v9.d[1]
+	ld1		{v31.16b}, [x1]
+	movi		v29.16b, #0xc2
+	fmov		d9, x4
+	mov		v9.d[1], x5
+	tbl		v10.16b, {v9.16b}, v25.16b
+	rev32		v11.8h, v9.8h
+.Lfour_loop:
+	__pmull_p8_4x_input
+	__pmull_p8_4x_cross v0, v2, v31
+	__pmull_p8_4x_products v0, v12, v13, v14, 0, x6, x7
+	__pmull_p8_4x_products v2, v12, v13, v14, 1, x4, x5, 1, x6, x7
+	__pmull_p8_4x_products v31, v15, v16, v17, 0, x8, x9
+	__pmull_p8_4x_reconstruct v6
+	__pmull_p8_4x_cross v1, v3, v24
+	__pmull_p8_4x_products v1, v12, v13, v14, 0, x10, x11
+	__pmull_p8_4x_products v3, v12, v13, v14, 1, x8, x9, 1, x10, x11
+	__pmull_p8_4x_products v24, v15, v16, v17, 0, x12, x13
+	__pmull_p8_4x_reconstruct v7
+	eor		v24.16b, v24.16b, v31.16b
+	__pmull_p8_4x_products v4, v12, v13, v14, 0, x14, x15
+	__pmull_p8_4x_products v5, v12, v13, v14, 1, x12, x13, 1, x14, x15
+	__pmull_p8_4x_products v24, v15, v16, v17, 0, x4, x5
+	__pmull_p8_4x_reconstruct v8
+	__pmull_p8_4x_reduce
+	sub		x0, x0, #4
+	cmp		x0, #4
+	b.hs		.Lfour_loop
+	st1		{v31.16b}, [x1]
+	cbnz		x0, pmull_ghash_update_p8
+.Lfour_exit:
+	ret
+SYM_FUNC_END(pmull_ghash_update_p8_4x)
+
+	.section	.rodata, "a"
+	.align		4
+.Lpmull_p8_4x_masks:
+	.byte		1, 2, 3, 0, 5, 6, 7, 4, 9, 10, 11, 8, 13, 14, 15, 12
+	.byte		255, 0, 1, 2, 3, 4, 5, 255, 255, 8, 9, 10, 11, 12, 13, 255
+	.byte		255, 255, 255, 6, 7, 255, 255, 255, 255, 255, 255, 14, 15, 255, 255, 255
+	.byte		255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 255, 255, 255, 255
+	.byte		255, 255, 0, 1, 2, 3, 255, 255, 255, 255, 8, 9, 10, 11, 255, 255
-- 
2.53.0


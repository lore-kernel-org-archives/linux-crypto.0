Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.202.192.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619612;
	b=ZnZ7a5qr1lJOrMZyM0RKeVLg77kmB/lslOXRW64b8/N3Wci8PkKJI3XMj2z4yu7MMdex
	 D2l9MOESgd36ybFT0lS93u0rGcA211icZjFooQxYVGet2R6+pBSKt8cTkVK7/Q12jZdG+
	 YOGwau+exF2PvnKVytVZK1alsdK0lngcmiIuuPPLxRWs0oFV3vwSr2R5xrUldeCZe5N6+
	 +p9mvdPlR0W0EZlkh3kszw4Lrg8pMpftoRAvGsfV5XFIWq11vBIl5S+7fiw1x65yf1IYk
	 TTX+q1GGFHnQeOe0AvLBx/3uBsuxo0zEQ1v08aCXqKdnvWfOHiDfpSRwLSbiS22dizQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619612;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3GGX18uJ8BJIN7cEW4Ppz2KNkHb9I630257v72QOxDU=;
	b=e18xuHmmVfrL34HBVilmwj9exxCw5UJQPRsuMNUCNA+Qzh1fpYYQCKIIQj5y+hBFyyfD
	 MqiFMTtAtEafZuv1UyikiPYIbWirzzWifq5ZwJop6Ir1zZi2Koc9rPJEc4+xMtC2jGbqK
	 mLbeRp7TsuqmXN2SHSJNlWWTlYQxpZHGFGciGNwK+7O0Xu0fsa16OnLzyYQqr/HGd8Sh1
	 ZSc1V/HuZOx1xxOw4CLUO4QHej1wkI0ovnKmRRrmfUwDA5dTFYAsylXxzsgBPfvDDHt3A
	 szv55MEiB1uJFvqbDKE8EhjcWGE/zdCF8C+mJOoO/MHMRkZANXEVLkcbbWSYn3QJXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=strongswan.org;
	spf=pass smtp.mailfrom=strongswan.org;
	dkim=pass header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b="mu/+mH/y";
	arc=none smtp.remote-ip=109.202.192.35
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE83606A332
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 11:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AE83606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b=mu/+mH/y
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 9299A5A0004;
	Mon, 02 Nov 2026 12:39:58 +0100 (CET)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id vRMm-y695HDp; Mon,  2 Nov 2026 12:39:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1793619596;
	bh=c+kN6rKrLj7irkeN499TjTpr3h0COwqC3aMZlQjdk1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu/+mH/ymkDgVoctNdPglK7NiTq/YaG+Ru2T6DQpKuV0zEsbkvGQteZnCUSDLsITa
	 RgRqGq3bu+sO4qg92oWK/V0wL57W6NBUwhsfESK2EmH8/e3IFO9vJLakKU6KrJQ7RS
	 4p0o9+7JfcJpU9lERosl52JF4qGngzl9Lud4z6RIDYA4+JnFB2JkOH4PfXnrK3cg5Y
	 5lClYmWnJ3GY9oKsBs1p1W7yOsFLg+MJqY4IXjrkNCP4vsx6h90nQi7f1stSOzPeMP
	 3jvLg1RuYFBYm++VLCMGPPpgbavZf98dLyoLO2LzeudhVx/uKkXOpgJ/q2JhpRE0JV
	 L+R3u673qUj5g==
Received: from ee00200a.home (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 772AB5A0007;
	Mon, 02 Nov 2026 12:39:56 +0100 (CET)
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH v2 3/3] lib/crypto: x86/chacha: Add a 16-block AVX-512 function
Date: Mon,  2 Nov 2026 12:39:26 +0100
Message-ID: <20261102113926.2765176-4-martin@strongswan.org>
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>
References: <20261102113926.2765176-1-martin@strongswan.org>
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

The AVX-512VL code processes at most 8 blocks at a time in 256-bit ymm
registers. That width was chosen to avoid the heavy core down-clocking
that 512-bit zmm instructions triggered on Skylake-X.

That penalty is gone on more recent AVX-512 parts, where full 512-bit
registers can encrypt 16 blocks per invocation and roughly double the
data-level parallelism for bulk traffic. So instantiate the shared block
macro a second time at VL=64, where only the final lane-crossing
transpose differs. Enable it on top of the avx512vl path, gated only by
X86_FEATURE_PREFER_YMM, and dispatch to it for inputs larger than
8 blocks.

On a Zen 5 Strix Halo, which has the full 512-bit datapath, the
benchmark_chacha case of the ChaCha KUnit suite reports:

    Length      Before       After  Change
    ======  ==========  ==========  ======
       768   3579 MB/s   7125 MB/s  +99.1%
      1024   4786 MB/s   9401 MB/s  +96.4%
      1420   4424 MB/s   6622 MB/s  +49.7%
      2048   4827 MB/s   9345 MB/s  +93.6%
      4096   4778 MB/s   9384 MB/s  +96.4%
      8920   4637 MB/s   9004 MB/s  +94.2%
     16384   4807 MB/s   9359 MB/s  +94.7%

The additional 768 length shows the gain of a single 16-block call
over the 8-block plus 4-block calls. The 1420 length requires a
16-block call followed by an 8-block call, so the gain roughly halves.

Like the 8-block function, the 16-block one keeps the state words in
registers for the final add. Re-adding them straight from the state
matrix via embedded broadcast is about 0.5% faster on that Zen 5. But
in the 8-block function, the same costs a Tiger Lake up to 2%, and that
function carries the bulk traffic there. As a separate code path for
VL=64 isn't worth the small gain, keep the register copy for both
widths.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 lib/crypto/x86/chacha-avx512-x86_64.S | 148 +++++++++++++++++++++++++-
 lib/crypto/x86/chacha.h               |  28 ++++-
 2 files changed, 173 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index 35e73de1c870..92babb1d3844 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -17,16 +17,20 @@ CTR2BL:	.octa 0x00000000000000000000000000000000
 CTR4BL:	.octa 0x00000000000000000000000000000002
 	.octa 0x00000000000000000000000000000003
 
-.section	.rodata.cst32.CTRBL, "aM", @progbits, 32
-.align 32
+.section	.rodata.cst64.CTRBL, "aM", @progbits, 64
+.align 64
 CTRBL:	.octa 0x00000003000000020000000100000000
 	.octa 0x00000007000000060000000500000004
+	.octa 0x0000000b0000000a0000000900000008
+	.octa 0x0000000f0000000e0000000d0000000c
 
 .text
 
 .macro _define_Vi	i
 .if VL == 32
 	.set	V\i,		%ymm\i
+.elseif VL == 64
+	.set	V\i,		%zmm\i
 .else
 	.error	"Unsupported vector length"
 .endif
@@ -487,6 +491,7 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	# registers.
 	#
 	# VL=32 encrypts eight blocks in 256-bit ymm registers.
+	# VL=64 encrypts sixteen blocks in 512-bit zmm registers.
 
 	vzeroupper
 
@@ -704,6 +709,7 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	vpunpckldq	V15,V14,V30
 	vpunpckhdq	V15,V14,V31
 
+.if VL == 32
 	# interleave 64-bit words in state n, n+2
 	vpunpcklqdq	V18,V16,V0
 	vpunpcklqdq	V19,V17,V1
@@ -830,6 +836,140 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 	jl		.Lxorpart\@
 	vpxord		0x01e0(%rdx),V0,V0
 	vmovdqu64	V0,0x01e0(%rsi)
+.else
+	# interleave 64-bit words in state n, n+2 -> zmm0..15
+	vpunpcklqdq	V18,V16,V0
+	vpunpckhqdq	V18,V16,V1
+	vpunpcklqdq	V19,V17,V2
+	vpunpckhqdq	V19,V17,V3
+	vpunpcklqdq	V22,V20,V4
+	vpunpckhqdq	V22,V20,V5
+	vpunpcklqdq	V23,V21,V6
+	vpunpckhqdq	V23,V21,V7
+	vpunpcklqdq	V26,V24,V8
+	vpunpckhqdq	V26,V24,V9
+	vpunpcklqdq	V27,V25,V10
+	vpunpckhqdq	V27,V25,V11
+	vpunpcklqdq	V30,V28,V12
+	vpunpckhqdq	V30,V28,V13
+	vpunpcklqdq	V31,V29,V14
+	vpunpckhqdq	V31,V29,V15
+
+	# interleave 128-bit lanes in state n, n+4 -> zmm16..31
+	vshufi64x2	$0x88,V4,V0,V16
+	vshufi64x2	$0x88,V12,V8,V20
+	vshufi64x2	$0xdd,V4,V0,V24
+	vshufi64x2	$0xdd,V12,V8,V28
+	vshufi64x2	$0x88,V5,V1,V17
+	vshufi64x2	$0x88,V13,V9,V21
+	vshufi64x2	$0xdd,V5,V1,V25
+	vshufi64x2	$0xdd,V13,V9,V29
+	vshufi64x2	$0x88,V6,V2,V18
+	vshufi64x2	$0x88,V14,V10,V22
+	vshufi64x2	$0xdd,V6,V2,V26
+	vshufi64x2	$0xdd,V14,V10,V30
+	vshufi64x2	$0x88,V7,V3,V19
+	vshufi64x2	$0x88,V15,V11,V23
+	vshufi64x2	$0xdd,V7,V3,V27
+	vshufi64x2	$0xdd,V15,V11,V31
+
+	# fuse the final 256-bit interleave into the xor/store ladder
+	vshufi64x2	$0x88,V20,V16,V0
+	cmp		$0x0040,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0000(%rdx),V0,V0
+	vmovdqu64	V0,0x0000(%rsi)
+
+	vshufi64x2	$0x88,V21,V17,V0
+	cmp		$0x0080,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0040(%rdx),V0,V0
+	vmovdqu64	V0,0x0040(%rsi)
+
+	vshufi64x2	$0x88,V22,V18,V0
+	cmp		$0x00c0,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0080(%rdx),V0,V0
+	vmovdqu64	V0,0x0080(%rsi)
+
+	vshufi64x2	$0x88,V23,V19,V0
+	cmp		$0x0100,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x00c0(%rdx),V0,V0
+	vmovdqu64	V0,0x00c0(%rsi)
+
+	vshufi64x2	$0x88,V28,V24,V0
+	cmp		$0x0140,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0100(%rdx),V0,V0
+	vmovdqu64	V0,0x0100(%rsi)
+
+	vshufi64x2	$0x88,V29,V25,V0
+	cmp		$0x0180,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0140(%rdx),V0,V0
+	vmovdqu64	V0,0x0140(%rsi)
+
+	vshufi64x2	$0x88,V30,V26,V0
+	cmp		$0x01c0,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0180(%rdx),V0,V0
+	vmovdqu64	V0,0x0180(%rsi)
+
+	vshufi64x2	$0x88,V31,V27,V0
+	cmp		$0x0200,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x01c0(%rdx),V0,V0
+	vmovdqu64	V0,0x01c0(%rsi)
+
+	vshufi64x2	$0xdd,V20,V16,V0
+	cmp		$0x0240,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0200(%rdx),V0,V0
+	vmovdqu64	V0,0x0200(%rsi)
+
+	vshufi64x2	$0xdd,V21,V17,V0
+	cmp		$0x0280,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0240(%rdx),V0,V0
+	vmovdqu64	V0,0x0240(%rsi)
+
+	vshufi64x2	$0xdd,V22,V18,V0
+	cmp		$0x02c0,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0280(%rdx),V0,V0
+	vmovdqu64	V0,0x0280(%rsi)
+
+	vshufi64x2	$0xdd,V23,V19,V0
+	cmp		$0x0300,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x02c0(%rdx),V0,V0
+	vmovdqu64	V0,0x02c0(%rsi)
+
+	vshufi64x2	$0xdd,V28,V24,V0
+	cmp		$0x0340,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0300(%rdx),V0,V0
+	vmovdqu64	V0,0x0300(%rsi)
+
+	vshufi64x2	$0xdd,V29,V25,V0
+	cmp		$0x0380,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0340(%rdx),V0,V0
+	vmovdqu64	V0,0x0340(%rsi)
+
+	vshufi64x2	$0xdd,V30,V26,V0
+	cmp		$0x03c0,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x0380(%rdx),V0,V0
+	vmovdqu64	V0,0x0380(%rsi)
+
+	vshufi64x2	$0xdd,V31,V27,V0
+	cmp		$0x0400,%rcx
+	jl		.Lxorpart\@
+	vpxord		0x03c0(%rdx),V0,V0
+	vmovdqu64	V0,0x03c0(%rsi)
+.endif
 
 .Ldone\@:
 	vzeroupper
@@ -858,3 +998,7 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 SYM_FUNC_START(chacha_8block_xor_avx512vl)
 	_chacha_words	vl=32
 SYM_FUNC_END(chacha_8block_xor_avx512vl)
+
+SYM_FUNC_START(chacha_16block_xor_avx512)
+	_chacha_words	vl=64
+SYM_FUNC_END(chacha_16block_xor_avx512)
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index e97f1f252bcc..fdf01b07742e 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -39,9 +39,14 @@ asmlinkage void chacha_8block_xor_avx512vl(const struct chacha_state *state,
 					   u8 *dst, const u8 *src, size_t len,
 					   int nrounds);
 
+asmlinkage void chacha_16block_xor_avx512(const struct chacha_state *state,
+					  u8 *dst, const u8 *src, size_t len,
+					  int nrounds);
+
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512);
 
 static size_t chacha_advance(size_t len, size_t maxblocks)
 {
@@ -52,6 +57,23 @@ static size_t chacha_advance(size_t len, size_t maxblocks)
 static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			  size_t bytes, int nrounds)
 {
+	if (static_branch_likely(&chacha_use_avx512)) {
+		while (bytes >= CHACHA_BLOCK_SIZE * 16) {
+			chacha_16block_xor_avx512(state, dst, src, bytes,
+						  nrounds);
+			bytes -= CHACHA_BLOCK_SIZE * 16;
+			src += CHACHA_BLOCK_SIZE * 16;
+			dst += CHACHA_BLOCK_SIZE * 16;
+			state->x[12] += 16;
+		}
+		if (bytes > CHACHA_BLOCK_SIZE * 8) {
+			chacha_16block_xor_avx512(state, dst, src, bytes,
+						  nrounds);
+			state->x[12] += chacha_advance(bytes, 16);
+			return;
+		}
+	}
+
 	if (static_branch_likely(&chacha_use_avx512vl)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
 			chacha_8block_xor_avx512vl(state, dst, src, bytes,
@@ -169,7 +191,11 @@ static void chacha_mod_init_arch(void)
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
+		    boot_cpu_has(X86_FEATURE_AVX512BW)) { /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
+
+			if (!boot_cpu_has(X86_FEATURE_PREFER_YMM))
+				static_branch_enable(&chacha_use_avx512);
+		}
 	}
 }
-- 
2.53.0


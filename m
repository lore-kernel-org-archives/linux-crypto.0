Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795517957;
	b=UBlo8M6UmgmiFqcsgzlLjSRi0A2Mzk6zz5CNrNexqjjI23MLEIpYw9ba0A7wHyyMOoMX
	 H1JbaCkYdZaMheloa2hc/in98/XlKqa/02DMl7ekIuNmV3SpdhqJ1HKBgF+AQ+OSgb+aT
	 yitbrCKIOjW1YyEBw2TXKjBP6Qr4kack+dytyMyTKocOeBXayI1aGAL0ENdM325P0BlQz
	 cmh3luFoegGtUqvherpJTtL3of6budnI5O3DyvzpIdnW3eLpklSr/4eNzdZiV9OLTvUad
	 BlKBdQMKgB149crLsb2d4FVCSr68I/m1eARu1B446GE1nsmXrow536iLAawpSIkj5Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517957;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=xvwyfLk8BQWIxNQmv4AmWU7I3hB3L5j/daO6qAU9Ilg=;
	b=DwLs62SsLvZCvdogLiyMeO5dwLKKCIgX02l7ZEPHrmdrmEHMXngDTteeq2oTO+iSU6V4
	 +lKtiD+XXckF9T3nqdRNGI7YZGBkBUXnw//g0YhWJp4/Xm1ikP1kh+9ujPnNCk1zcKQ75
	 Tq5zQvYG6Ai30jKHe4HQ5qhTOqLMclRdjllp9V+BJ0AhUJdcds8hCx0KblZE8bhpLKnhU
	 KEjDTYP0S1o8qx+pY0TaqOtzvPkgCzWf6Lk1XEpFR6m82O3+E9QyGcpDaCYrAuOjiXsvM
	 82YCXhRjzjxjA8nyJ5aeNy+h4Yc3wIR9/VrQT8TJ13DEgmotVAr7rQHbh8U/E7k5EBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSM7PLqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE7A606A321
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSM7PLqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6B51F000C0;
	Tue, 24 Nov 2026 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795517956;
	bh=xvwyfLk8BQWIxNQmv4AmWU7I3hB3L5j/daO6qAU9Ilg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CSM7PLqQbtN5upHVYqsTjoBJ73ClLRRxt6Bk3Ur9KO82mnxEDc8uOs89ugb19rxYD
	 WPgwrPZaFIqeji07eSSWmVg6e6j2PvTflm7BnpGqsqY1k8flGYhabRL8VGIqMUn7Xq
	 a9T1lAcnGWQ74GRH5PyWVnuc+34VGsofaWwze2pZg+W77vqIe8I++8r9SCBsMYv0Nw
	 bgu2omfVZ83SHfjgVBa7801o7idm4qc5s5ukcgmxYeN3EEzn2eOFVFG/f81LkqLAs0
	 8Cd6f9lC/s2seoHgTWMHs/ADVvtOLkY/Rc8vuNhA2VejlhpvUUn/P06i5dHVmPprnh
	 XGQfjz8pR7gjA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3B37C198003A;
	Tue, 24 Nov 2026 05:59:14 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 05:59:14 -0500
X-ME-Sender: <xms:AW4Fa4wf8dyr9rq9UZJOhHtzYy-K-hc09VSXVgRKh00XoJJXnQYr5Q>
    <xme:AW4Fa3EKoQ1AYzQC_FMn4ZVEH4Fm3KyRrw866lrYz8zXbfxFzibxG_m-jmerXqTFj
    pB6XFtRq4kUZVkmkmFF8HDgbMNCNVJwd02Jd2WTMjsWRZUfCK2yRy4>
X-ME-Proxy-Cause: dmFkZTEkGht+ylM/Zexi05xDHRBVCPbltIGNcahMkl1PN/FY9v34bBs50qmzty7ndYQBNB
    c3CwzlpJu5qVZr/HVEGQkEuVJpQk6uF0IQk9cotwix1SMK+xafIgy5KR6nqxSwYmirYuiM
    22Yfm7J1tglKCCSvpnS/+zmwFQXefjtBDdk4PHaFDTGfO4n8jkcqtM2oXPnQ8memXlRQi/
    UYhxKqhK6wc6qXpRTHnfHTOYh5znq+3NlPQjR1pZXm4wiXgiufiFiuY6vkLgLR2QhLxvE0
    hz6bDpC3t88arEdhbWdZ36e8in2JNDQwN1OzaTaMQ+sfXglAlMbmMR9bm9DKFaOQ7h9Qjw
    GY7hM3XOy+cP6ggbcQK0iQC0n1tpfI+aHX+rhWJqx/OHxbBAzCTmTTYCWIjDfkOwajmK6J
    wWKth6tA1Nj41BOL2t+hiIMp3kHSzkZQKi/QtNp/OhNysZB4BtrnN9EkwtwPjaCjSa1JA/
    Io7SNLzux3ZSg4g5KTHxaTFQY3MSg4JB6CPDKfQoo4x26GwTIcHw9rS8LBS/VVbSiYKSs2
    J2cvQg2i8GXsU4LBS6g5r6e63DSP9ZfMbtyJPkP/3FyZkbvGA3YmD1rAh4dh4U5VJaEm4h
    vIfaIafVxFwdhXOmj2nnVqo1L3gW1hSkP43+NRlwkYdV/mYUuyRvR2L9NRiA
X-ME-Proxy: <xmx:Am4Fa3aqogtkaY8n11Gn0n4emoCFGzSFMY1lHoydw0m5ZUW293iNXA>
    <xmx:Am4Fa0OmUGtyKd4MSBjnpCEWLiOPPAdR_CeaW8yciJS_AWc9mlHJRg>
    <xmx:Am4Fa0YyvDOYqDLQKHO2Z9G6tQFKRx9_tr8QqwsQgi9tDyZK8TDehg>
    <xmx:Am4Fa62ZaneneXrYdu-suApcccD5zUNu97DmzIdWw0V-_qQWtF1rWQ>
    <xmx:Am4Fayfw29eQKJwUXl10B_Fz1aUzqJlX_oaR5dnQ0sTRtAXvCXpOkTZg>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 65863F80093; Tue, 24 Nov 2026 05:59:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 11:58:53 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Shreesh Adiga" <16567adigashreesh@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, "Demian Shulhan" <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Message-Id: <4bcc9534-6b9e-4e9e-84b3-6b792f8a4cb8@app.fastmail.com>
In-Reply-To: <20261124060006.862167-1-16567adigashreesh@gmail.com>
References: <20261124060006.862167-1-16567adigashreesh@gmail.com>
Subject: Re: [PATCH v3] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 24 Nov 2026, at 06:59, Shreesh Adiga wrote:
> Use 4-way folding in the shared NEON crc64_nvme for AArch64
> as well as AArch32. This improves performance by about 2x for 512 byte
> data size on Cortex-X925, as measured with a userspace benchmark.
>
> Add similar optimizations from x86 implementation like reducing
> the 4x to 2x and doing a tail (len >= 32) 2x fold as well as partial
> block handling to process lengths which are not multiple of 16 bytes.
>
> The partial block handling uses vqtbl1q_u8(), which AArch32 does not
> provide, so implement it for AArch32 using two vtbl2_u8() lookups, the
> same emulation used by lib/raid/raid6/arm/recov_neon_inner.c.
>
> crc64_nvme_neon() therefore accepts any len >= 128 on both
> architectures. The AArch64 dispatch code now passes the full length, and
> the AArch32 dispatch code no longer rounds chunks down to a multiple of
> 16 bytes: each chunk is 4 KiB, or the whole remaining length if less
> than 4 KiB + 128 bytes remains, so no tail is left for the generic
> implementation.
>
> On AArch64, check for PMULL with a static key, and implement the PMULL
> helpers with inline asm. With the vmull_p64() intrinsics, compilers
> build the fold constants in general purpose registers with mov/movk and
> transfer them with fmov/dup, up to 10 instructions per constant pair,
> instead of loading them from memory.
>
> Tested for correctness with the CRC KUnit tests under QEMU on both
> AArch64 and AArch32.
>
> Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
> ---
> Changes in v3:
> - Make the partial_block logic more readable as per suggestion by Ard.
>   Mark the helper functions __always_inline inside the crc64-neon.c
>   file.
>
> Changes in v2:
> - Squash in the follow-up requested by Eric: AArch32 partial block
>   support, AArch32 chunking without rounding to 16 bytes, and comments
>   explaining the inline asm and partial block handling.
> - Use uint64_t for fold_consts_4x_val and fold_consts_2x_val, fixing the
>   build failure reported.
> - Rebase onto v7.4-rc4
>
> v1: 
> https://lore.kernel.org/all/20261118160110.1662470-1-16567adigashreesh@gmail.com/
>
>  lib/crc/arm/crc64-neon.h   |  16 ++++++
>  lib/crc/arm/crc64.h        |   4 +-
>  lib/crc/arm64/crc64-neon.h |  27 +++++++---
>  lib/crc/arm64/crc64.h      |  18 ++++---
>  lib/crc/crc64-neon.c       | 106 ++++++++++++++++++++++++++++++++++---
>  5 files changed, 150 insertions(+), 21 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crc/arm/crc64-neon.h b/lib/crc/arm/crc64-neon.h
> index 645f553220ff..0d0071a92071 100644
> --- a/lib/crc/arm/crc64-neon.h
> +++ b/lib/crc/arm/crc64-neon.h
> @@ -32,3 +32,19 @@ static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, 
> uint64x2_t b)
> 
>  	return result;
>  }
> +
> +/*
> + * AArch32 does not provide this intrinsic natively because it does not
> + * implement the underlying instruction. AArch32 only provides a 64-bit
> + * wide vtbl.8 instruction, so use that instead.
> + */
> +static inline uint8x16_t vqtbl1q_u8(uint8x16_t a, uint8x16_t b)
> +{
> +	union {
> +		uint8x16_t	val;
> +		uint8x8x2_t	pair;
> +	} __a = { a };
> +
> +	return vcombine_u8(vtbl2_u8(__a.pair, vget_low_u8(b)),
> +			   vtbl2_u8(__a.pair, vget_high_u8(b)));
> +}
> diff --git a/lib/crc/arm/crc64.h b/lib/crc/arm/crc64.h
> index de274288af61..ce0ffe590596 100644
> --- a/lib/crc/arm/crc64.h
> +++ b/lib/crc/arm/crc64.h
> @@ -13,10 +13,10 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> 
>  static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
>  {
> -	if (len >= 128 && static_branch_likely(&have_pmull) &&
> +	if (static_branch_likely(&have_pmull) && len >= 128 &&
>  	    likely(may_use_simd())) {
>  		do {
> -			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
> +			size_t chunk = (len < SZ_4K + 128) ? len : SZ_4K;
> 
>  			scoped_ksimd()
>  				crc = crc64_nvme_neon(crc, p, chunk);
> diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
> index fcd5b1e6f812..d872f4d4e2e7 100644
> --- a/lib/crc/arm64/crc64-neon.h
> +++ b/lib/crc/arm64/crc64-neon.h
> @@ -1,21 +1,34 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> 
> +/*
> + * The PMULL helpers below use inline asm instead of the vmull_p64() and
> + * vmull_high_p64() intrinsics. vmull_p64() takes poly64_t scalars, so the low
> + * lanes have to be extracted with vgetq_lane_u64(). For the fold constants,
> + * compilers fold that extraction into a 64-bit immediate: recent GCC and Clang
> + * build it in a GPR with mov/movk and transfer it with fmov (Clang also
> + * rebuilds the high half used by pmull2 with mov/movk and dup), instead of
> + * loading the constant pair with a single ldr. With asm operating on whole
> + * vector registers, the constants are loaded from .rodata and pmull reads
> + * the low lanes in place.
> + */
> +
>  static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
>  {
> -	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
> -						vgetq_lane_u64(b, 0)));
> +	uint64x2_t r;
> +
> +	asm("pmull %0.1q, %1.1d, %2.1d" : "=w"(r) : "w" (a), "w" (b));
> +	return r;
>  }
> 
>  static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
>  {
> -	poly64x2_t l = vreinterpretq_p64_u64(a);
> -	poly64x2_t m = vreinterpretq_p64_u64(b);
> +	uint64x2_t r;
> 
> -	return vreinterpretq_u64_p128(vmull_high_p64(l, m));
> +	asm("pmull2 %0.1q, %1.2d, %2.2d" : "=w"(r) : "w" (a), "w" (b));
> +	return r;
>  }
> 
>  static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
>  {
> -	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 1),
> -						vgetq_lane_u64(b, 0)));
> +	return pmull64(vextq_u64(a, a, 1), b);
>  }
> diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
> index c7a69e1f3d8f..06dd08a21dd6 100644
> --- a/lib/crc/arm64/crc64.h
> +++ b/lib/crc/arm64/crc64.h
> @@ -10,19 +10,25 @@
> 
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> 
> +static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
> +
>  #define crc64_be_arch crc64_be_generic
> 
>  static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
>  {
> -	if (len >= 128 && cpu_have_named_feature(PMULL) &&
> +	if (static_branch_likely(&have_pmull) && len >= 128 &&
>  	    likely(may_use_simd())) {
> -		size_t chunk = len & ~15;
> -
>  		scoped_ksimd()
> -			crc = crc64_nvme_neon(crc, p, chunk);
> +			crc = crc64_nvme_neon(crc, p, len);
> 
> -		p += chunk;
> -		len &= 15;
> +		return crc;
>  	}
>  	return crc64_nvme_generic(crc, p, len);
>  }
> +
> +#define crc64_mod_init_arch crc64_mod_init_arch
> +static void crc64_mod_init_arch(void)
> +{
> +	if (cpu_have_named_feature(PMULL))
> +		static_branch_enable(&have_pmull);
> +}
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 1267df1310be..18eb17d5462b 100644
> --- a/lib/crc/crc64-neon.c
> +++ b/lib/crc/crc64-neon.c
> @@ -10,6 +10,12 @@
> 
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> 
> +/* x^575 mod G, x^511 mod G */
> +static const uint64_t fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
> +						0x62242240ace5045aULL };
> +/* x^319 mod G, x^255 mod G */
> +static const uint64_t fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
> +						0xe1e0bb9d45d7a44cULL };
>  /* x^191 mod G, x^127 mod G */
>  static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
>  					     0x21e9761e252621acULL };
> @@ -17,23 +23,111 @@ static const uint64_t fold_consts_val[2] = { 
> 0xeadc41fd2ba3d420ULL,
>  static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
>  					 0x34d926535897936aULL };
> 
> +static __always_inline uint64x2_t fold_single_round(uint64x2_t fold,
> +						    uint64x2_t temp,
> +						    uint64x2_t consts)
> +{
> +	uint64x2_t temp1 = pmull64(consts, fold);
> +	uint64x2_t temp2 = pmull64_high(consts, fold);
> +
> +	return temp ^ temp1 ^ temp2;
> +}
> +
> +/*
> + * Fold in the final 1 <= len <= 15 bytes. With A = fold, the remaining
> + * polynomial is A*x^(8*len) + B. Rewrite it as C1*x^128 + C2, where
> + * C1 = floor(A / x^(128 - 8*len)) and C2 = (A*x^(8*len) mod x^128) + B,
> + * then fold C1 into C2. t1 selects the len highest-degree bytes of A to
> + * form C1; ~t1 selects the remaining bytes to form A*x^(8*len) mod x^128,
> + * since tbl returns 0 for any index >= 16. The sign of t1 then selects
> + * which bytes of C2 come from B.
> + */
> +static __always_inline uint64x2_t fold_partial_block(uint64x2_t fold,
> +						     uint64x2_t consts,
> +						     const u8 *p,
> +						     size_t len)
> +{
> +	static const u8 crc_neon_shift_tab[32] = {
> +		0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8,
> +		0xf7, 0xf6, 0xf5, 0xf4, 0xf3, 0xf2, 0xf1, 0xf0,
> +		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
> +	};
> +
> +	uint8x16_t last16, f, t1, t2, a, b;
> +	int8x16_t  mask;
> +
> +	last16 = vld1q_u8(p + len - 16);
> +	f      = vreinterpretq_u8_u64(fold);
> +	t1     = vld1q_u8(crc_neon_shift_tab + len);
> +	a      = vqtbl1q_u8(f,  t1);
> +	t2     = vqtbl1q_u8(f, ~t1);
> +	mask   = vreinterpretq_s8_u8(t1) >> 7;
> +	t1     = vreinterpretq_u8_s8(mask);
> +	b      = vbslq_u8(t1, t2, last16);
> +
> +	return fold_single_round(vreinterpretq_u64_u8(a),
> +				 vreinterpretq_u64_u8(b),
> +				 consts);
> +}
> +
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
>  {
> +	/* Assumes len >= 128. */
>  	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
> +	uint64x2_t fold_consts_4x = vld1q_u64(fold_consts_4x_val);
> +	uint64x2_t fold_consts_2x = vld1q_u64(fold_consts_2x_val);
>  	uint64x2_t v0 = { crc, 0 };
>  	uint64x2_t zero = { };
> +	uint64x2_t v1, v2, v3;
> +
> +	v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
> +	v1  = vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +	v2  = vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +	v3  = vreinterpretq_u64_u8(vld1q_u8(p + 48));
> +
> +	p += 64;
> +	len -= 64;
> +	do {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
> +		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
> +		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
> 
> -	for (;;) {
> -		v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
> +		v0 = fold_single_round(v0, t0, fold_consts_4x);
> +		v1 = fold_single_round(v1, t1, fold_consts_4x);
> +		v2 = fold_single_round(v2, t2, fold_consts_4x);
> +		v3 = fold_single_round(v3, t3, fold_consts_4x);
> +		p += 64;
> +		len -= 64;
> +	} while (len >= 64);
> 
> +	v0 = fold_single_round(v0, v2, fold_consts_2x);
> +	v1 = fold_single_round(v1, v3, fold_consts_2x);
> +
> +	if (len >= 32) {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
> +		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
> +
> +		v0 = fold_single_round(v0, t0, fold_consts_2x);
> +		v1 = fold_single_round(v1, t1, fold_consts_2x);
> +		p += 32;
> +		len -= 32;
> +	}
> +
> +	v0 = fold_single_round(v0, v1, fold_consts);
> +
> +	if (len >= 16) {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
> +
> +		v0 = fold_single_round(v0, t0, fold_consts);
>  		p += 16;
>  		len -= 16;
> -		if (len < 16)
> -			break;
> -
> -		v0 = pmull64(fold_consts, v0) ^ pmull64_high(fold_consts, v0);
>  	}
> 
> +	if (len)
> +		v0 = fold_partial_block(v0, fold_consts, p, len);
> +
>  	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
>  	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
> 
>
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
> -- 
> 2.56.1

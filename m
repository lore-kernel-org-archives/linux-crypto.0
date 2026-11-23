Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458658;
	b=cn6c41CNQ91yrUMFU4C0tcLVtc+omqv+B61wePWt7qxnAHfLrmUhPahCDZCb2jDie96d
	 vgMC8gg3ONTNjJbMVQ0XXzXLexFyzsfdqMk7Ah+ngoV/DnXfK2M+5lXCY6f954MGw5+qo
	 KzWDy11Nntp84ip3wSMrJqF2FO5XJGsluf9hFUQ7nhIE92EC5Fy+RGUuPxhhRAstqYPiV
	 6qrqadz72n4IcewUVXvSwS9TC6fZO80PL+ZHG7e/jh1gjeCyTFHVcD7FyHVDFpaIaA/1K
	 j1FTsXq2msFAEMAbfoSCOutFspUuIDFQ7GkT+aSUQ3bClp42iH2wNrXw7Cc8OsYkSkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458658;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=8SQDwdiNb9DW7hMA94m7b/5EBoZ4JcTNs36C3UWb6EY=;
	b=4FBWU0jhwKnpyRYfDxxdTKiYWcbF/rMnsNEdFVXXFp9aAdvogfNv6M97x5QSvBslfNVd
	 O12pYDFh19ch82bW8HDbk3UOaGpX7uqEUisqiIBI15QkyfmK9YMnpMjJNHYKE/693HvyZ
	 sUGNj61JdeQJB7moP3I8NrbUGJpk1IdU2sZnTa16hoRX1BpykcwCktEHwK9a88m4kFusW
	 nqFV0IY1VHjV8+b7R9uxvofyhl1JcKxx/x4Bc+XqQLo2hnm5kcRSbeNO5kIvM3hFcv+yS
	 AhqcQrcN7iuMPJiXVcLECkf63WbBvfj01Pka1gLpdU0o24mcHCAY4kUej2j8DhHcXRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gI1lAK4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F7A606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gI1lAK4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F31F000C0;
	Mon, 23 Nov 2026 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795458657;
	bh=8SQDwdiNb9DW7hMA94m7b/5EBoZ4JcTNs36C3UWb6EY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gI1lAK4x7kFeNnNpvSFDhtLJPBN+P/vQbSQRpt4SEETp0+QHuviZMx70Pwu+gyrsZ
	 tdxzN1f6h9gyxXdyU4jMsLXkd61osus9nF2rRyqYtGeHBurIEHuFSoGAeS9GXBuhqw
	 Roq20ZxBptjSHFMd7dwufaEwRfeJfWSuYbzqAZJUDOKk2sfRxY/rl7kRQqUNNtJue2
	 L0NxePzh0kGABUjrwxugGS9MM6B7SVT7DLCX18igkgTqBsfYs95/EqkugdgQHfKWwX
	 auoDLQs8om9hCOAY8iXGQLeb056kPoP/o51Nc9DrJAbHXdBhMwCrfhaS7TPK2K6J6N
	 Jh1xljbyKfIIw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id D646F198004A;
	Mon, 23 Nov 2026 13:30:54 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 23 Nov 2026 13:30:54 -0500
X-ME-Sender: <xms:XYYEa2tFTKJv30hVY8m_i4sN36w6PESZJRrrStMlsLBsoPEb7_u3lA>
    <xme:XYYEa2SECkUSyyXvehzEa6WjFHqMteqLgZDnCS0qfqksb9TvI35bzSe2ZcsEp9xEg
    i1Jcctco7CRGCpnc-uiIzRgeqxJX4kzuq2QYcaYBao3r0v4Dme05eF9>
X-ME-Proxy-Cause: dmFkZTFGDkS51yMG+mrXBIJ+M89cfmaqxoDbXH+aR2Svq5j5Ml49pkPjyN408whMEUzhGd
    Pen33BGFKJVINSu7r8Yus/7ExAbWszwldjvm3qyqt9+ROai+wx27crnfGQakr3JMD3uIHV
    xzqOdFFnCnNgX4xL3Qgi8CQtHqKnPIxPIGYmSaN64PvXppPdbFzyPfyiXvblcRDK7Uu7PC
    y4r1zJNugpyb2mrG3QeqiKhyPBJg6fVkC5RZI+vZZowVxaRSgrL1qtRzA+/zuccSsvsNKd
    95vJv4FPExW9cPyJrnk5MwzAWO/PDDJ/1vUlOYZp97HofaAoar+Z54DJpzPKWtrkNNONf4
    tD6uxRXcQEpvNMVFRibLqhwu2VSnPMvDyJ3euP6HnFs2nwogXJCzIUQHdkBuAdDulShkmY
    0Y/VazHk3ZwOryPfUrHID3QyLC8WPyI9EskcxMf1Nj5STu96mLJ4HpwQ0K6DGygo6Ah0f+
    nSm+4yeLqncE7rAeg8ElNnchQ2I5cSmXWSVV4ubDIPbxSwT9gVyf3eZxKPxoQa7awg9Cxa
    8Z2MtrTlIdnIIgY2PtHT5JTv5/hNq/Hpv9ZpIkf6RKBOR8CW7HtjytJPkIPSZulDbWhwAa
    mDogGKbpcc62D14hvA/nYKpotlAMoNNYNYQFV42RKqq3kjz4JaOwOkk6UHHQ
X-ME-Proxy: <xmx:XoYEa-VjqavadDC83TUXBCq3PIDRvfvIXAQundTSzncBNREn02ekiQ>
    <xmx:XoYEa4ZUG83oKhfhfkc7tGmK84-GuLGJ6Il4ohMlDDnq4IedG8jJfg>
    <xmx:XoYEa82WXK-KS3hO1qLODfgfh-W6mpBZ9BLzF6gcwXA-WMV7Hqkt8Q>
    <xmx:XoYEayixevMR3jRUhQNlSgz9T94WGC7xcwM3s-LYpL3FgaRXorKYZw>
    <xmx:XoYEa4ZxMm-cD9mWqx3jePhMY3kOCvJ6e4aNwxgnuhJmWH0R3g_u1DB->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id AA265F8008E; Mon, 23 Nov 2026 13:30:53 -0500 (EST)
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
Date: Mon, 23 Nov 2026 19:30:33 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Shreesh Adiga" <16567adigashreesh@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, "Demian Shulhan" <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Message-Id: <708906ea-6b8a-41f2-96eb-b173083b0f34@app.fastmail.com>
In-Reply-To: <20261123144605.303362-1-16567adigashreesh@gmail.com>
References: <20261123144605.303362-1-16567adigashreesh@gmail.com>
Subject: Re: [PATCH v2] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 23 Nov 2026, at 15:45, Shreesh Adiga wrote:
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
> Changes in v2:
> - Squash in the follow-up requested by Eric: AArch32 partial block
>   support, AArch32 chunking without rounding to 16 bytes, and comments
>   explaining the inline asm and partial block handling.
> - Use uint64_t for fold_consts_4x_val and fold_consts_2x_val, fixing the
>   build failure reported. Also used uint8_t instead of u8 for
>   consistency for the partial_block array which is loaded by vld1q_u8.
> - Rebase onto v7.4-rc4
>
> v1: 
> https://lore.kernel.org/all/20261118160110.1662470-1-16567adigashreesh@gmail.com/
>
>  lib/crc/arm/crc64-neon.h   |  16 ++++++
>  lib/crc/arm/crc64.h        |   4 +-
>  lib/crc/arm64/crc64-neon.h |  27 +++++++---
>  lib/crc/arm64/crc64.h      |  18 ++++---
>  lib/crc/crc64-neon.c       | 100 ++++++++++++++++++++++++++++++++++---
>  5 files changed, 144 insertions(+), 21 deletions(-)
>
...
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 1267df1310be..313676098dee 100644
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
> @@ -17,23 +23,105 @@ static const uint64_t fold_consts_val[2] = { 
> 0xeadc41fd2ba3d420ULL,
>  static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
>  					 0x34d926535897936aULL };
> 
> +static inline uint64x2_t fold_single_round(uint64x2_t fold, uint64x2_t temp,

Please avoid inline in .c files. If it /must/ be inline, use __always_inline.
Otherwise, leave it to the compiler.

> +					   uint64x2_t consts)
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
> +static inline uint64x2_t fold_partial_block(uint64x2_t fold, uint64x2_t consts,
> +					    const u8 *p, size_t len)
> +{
> +	static const uint8_t crc_neon_shift_tab[32] = {
> +		0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8,
> +		0xf7, 0xf6, 0xf5, 0xf4, 0xf3, 0xf2, 0xf1, 0xf0,
> +		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
> +	};
> +
> +	uint8x16_t last16, t1, t2;
> +	uint64x2_t a, b;
> +
> +	last16 = vld1q_u8(p + len - 16);
> +	t1 = vld1q_u8(crc_neon_shift_tab + len);
> +	a  = vreinterpretq_u64_u8(vqtbl1q_u8(vreinterpretq_u8_u64(fold), t1));
> +	t2 = vmvnq_u8(t1);
> +	t2 = vqtbl1q_u8(vreinterpretq_u8_u64(fold), t2);
> +	t1 = vreinterpretq_u8_s8(vshrq_n_s8(vreinterpretq_s8_u8(t1), 7));
> +	b  = vreinterpretq_u64_u8(vbslq_u8(t1, t2, last16));
> +
> +	return fold_single_round(a, b, consts);

This is very hard to decipher.

Could we make this

        uint8x16_t last16, f, t1, t2, a, b;
        int8x16_t mask;                                    

        last16  = vld1q_u8(p + len - 16);
        f       = vreinterpretq_u8_u64(fold);                  
        t1      = vld1q_u8(crc_neon_shift_tab + len);
        a       = vqtbl1q_u8(f, t1);
        t2      = vqtbl1q_u8(f, ~t1);
        mask    = vreinterpretq_s8_u8(t1) >> 7;
        t1      = vreinterpretq_u8_s8(mask);
        b       = vbslq_u8(t1, t2, last16);

        return fold_single_round(vreinterpretq_u64_u8(a),
                                 vreinterpretq_u64_u8(b),
                                 consts);  
instead?

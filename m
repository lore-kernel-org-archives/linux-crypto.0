Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:36122 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbeJQFeO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 01:34:14 -0400
Date: Wed, 17 Oct 2018 00:41:50 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: streebog - add Streebog hash function
Message-ID: <20181016214150.wdicfw23f32lu36c@sole.flsd.net>
References: <20181010121254.12220-1-vt@altlinux.org>
 <20181010121254.12220-2-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20181010121254.12220-2-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 10, 2018 at 03:12:51PM +0300, Vitaly Chikunov wrote:
> Add GOST/IETF Streebog hash function (GOST R 34.11-2012, RFC 6986)
> generic hash transformation.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/Kconfig            |   12 +
>  crypto/Makefile           |    1 +
>  crypto/streebog_generic.c | 1142 +++++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/streebog.h |   34 ++
>  4 files changed, 1189 insertions(+)
>  create mode 100644 crypto/streebog_generic.c
>  create mode 100644 include/crypto/streebog.h
> 
> diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
> ...
> +#define XLPS(x, y, data) { \
> +	register u64 r0, r1, r2, r3, r4, r5, r6, r7; \
> +	int _i; \
> +	\
> +	r0 = le64_to_cpu((x)->qword[0] ^ (y)->qword[0]); \
> +	r1 = le64_to_cpu((x)->qword[1] ^ (y)->qword[1]); \
> +	r2 = le64_to_cpu((x)->qword[2] ^ (y)->qword[2]); \
> +	r3 = le64_to_cpu((x)->qword[3] ^ (y)->qword[3]); \
> +	r4 = le64_to_cpu((x)->qword[4] ^ (y)->qword[4]); \
> +	r5 = le64_to_cpu((x)->qword[5] ^ (y)->qword[5]); \
> +	r6 = le64_to_cpu((x)->qword[6] ^ (y)->qword[6]); \
> +	r7 = le64_to_cpu((x)->qword[7] ^ (y)->qword[7]); \
> +	\
> +	for (_i = 0; _i <= 7; _i++) { \
> +		(data)->qword[_i]  = cpu_to_le64(Ax[0][r0 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[1][r1 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[2][r2 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[3][r3 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[4][r4 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[5][r5 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[6][r6 & 0xFF]); \
> +		(data)->qword[_i] ^= cpu_to_le64(Ax[7][r7 & 0xFF]); \
> +		r0 >>= 8; \
> +		r1 >>= 8; \
> +		r2 >>= 8; \
> +		r3 >>= 8; \
> +		r4 >>= 8; \
> +		r5 >>= 8; \
> +		r6 >>= 8; \
> +		r7 >>= 8; \
> +	} \
> +}
> ...
> +static const struct streebog_uint512 C[12] = {
> +	{ {
> +		 cpu_to_le64(0xdd806559f2a64507ULL),
> +		 cpu_to_le64(0x05767436cc744d23ULL),
> +		 cpu_to_le64(0xa2422a08a460d315ULL),
> +		 cpu_to_le64(0x4b7ce09192676901ULL),
> +		 cpu_to_le64(0x714eb88d7585c4fcULL),
> +		 cpu_to_le64(0x2f6a76432e45d016ULL),
> +		 cpu_to_le64(0xebcb2f81c0657c1fULL),
> +		 cpu_to_le64(0xb1085bda1ecadae9ULL)
> ...
> +static const unsigned long long Ax[8][256] __aligned(16) = {
> +	{
> +	0xd01f715b5c7ef8e6ULL, 0x16fa240980778325ULL, 0xa8a42e857ee049c8ULL,
> +	0x6ac1068fa186465bULL, 0x6e417bd7a2e9320bULL, 0x665c8167a437daabULL,
> +	0x7666681aa89617f6ULL, 0x4b959163700bdcf5ULL, 0xf14be6b78df36248ULL,
> +	0xc585bd689a625cffULL, 0x9557d7fca67d82cbULL, 0x89f0b969af6dd366ULL,
> +	0xb0833d48749f6c35ULL, 0xa1998c23b1ecbc7cULL, 0x8d70c431ac02a736ULL,
> +	0xd6dfbc2fd0a8b69eULL, 0x37aeb3e551fa198bULL, 0x0b7d128a40b5cf9cULL,
> +	0x5a8f2008b5780cbcULL, 0xedec882284e333e5ULL, 0xd25fc177d3c7c2ceULL,
> +	0x5e0f5d50b61778ecULL, 0x1d873683c0c24cb9ULL, 0xad040bcbb45d208cULL,
> ...

It's possible to move cpu_to_le64 from XLPS into each value of Ax[].
This would increase source size but slightly improve performance. Does
it worth the change? My opinion is to leave it as is since big-endian
architectures are not main targets.

Thanks,

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH 2/2] crypto: blowfish - disable AVX2 implementation
Date: Wed, 05 Jun 2013 15:26:11 +0300
Message-ID: <51AF2E63.1050801@iki.fi>
References: <20130602165147.25743.88831.stgit@localhost6.localdomain6> <20130602165152.25743.90142.stgit@localhost6.localdomain6> <20130605083425.GA12202@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:57368 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3FEM01 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jun 2013 08:26:27 -0400
In-Reply-To: <20130605083425.GA12202@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05.06.2013 11:34, Herbert Xu wrote:
> On Sun, Jun 02, 2013 at 07:51:52PM +0300, Jussi Kivilinna wrote:
>> It appears that the performance of 'vpgatherdd' is suboptimal for this kind of
>> workload (tested on Core i5-4570) and causes blowfish-avx2 to be significantly
>> slower than blowfish-amd64. So disable the AVX2 implementation to avoid
>> performance regressions.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> 
> Both patches applied to crypto.  I presume you're working on
> a more permanent solution on this?

Yes, I've been looking for solution. Problem is, well, that I assumed vgather to be quicker than emulating gather using vpextr/vpinsr instructions. But it appears that vgather has about the same speed as group of vpextr/vpinsr doing gather manually. So doing

    asm volatile(
	"vpgatherdd %%xmm0, (%[ptr], %%xmm8, 4), %%xmm9;        \n\t"
	"vpcmpeqd %%xmm0, %%xmm0, %%xmm0; /* reset mask */      \n\t"
	"vpgatherdd %%xmm0, (%[ptr], %%xmm9, 4), %%xmm8;        \n\t"
	"vpcmpeqd %%xmm0, %%xmm0, %%xmm0;                       \n\t"
	:: [ptr] "r" (&mem[0]) : "memory"
    );

in loop is slightly _slower_ than manually extracting&inserting values with

    asm volatile(
        "vmovd       %%xmm8, %%eax;                             \n\t"
        "vpextrd $1, %%xmm8, %%edx;                             \n\t"
        "vmovd       (%[ptr], %%rax, 4), %%xmm10;               \n\t"
        "vpextrd $2, %%xmm8, %%eax;                             \n\t"
        "vpinsrd $1, (%[ptr], %%rdx, 4), %%xmm10, %%xmm10;      \n\t"
        "vpextrd $3, %%xmm8, %%edx;                             \n\t"
        "vpinsrd $2, (%[ptr], %%rax, 4), %%xmm10, %%xmm10;      \n\t"
        "vpinsrd $3, (%[ptr], %%rdx, 4), %%xmm10, %%xmm9;       \n\t"

        "vmovd       %%xmm9, %%eax;                             \n\t"
        "vpextrd $1, %%xmm9, %%edx;                             \n\t"
        "vmovd       (%[ptr], %%rax, 4), %%xmm10;               \n\t"
        "vpextrd $2, %%xmm9, %%eax;                             \n\t"
        "vpinsrd $1, (%[ptr], %%rdx, 4), %%xmm10, %%xmm10;      \n\t"
        "vpextrd $3, %%xmm9, %%edx;                             \n\t"
        "vpinsrd $2, (%[ptr], %%rax, 4), %%xmm10, %%xmm10;      \n\t"
        "vpinsrd $3, (%[ptr], %%rdx, 4), %%xmm10, %%xmm8;       \n\t"
	:: [ptr] "r" (&mem[0]) : "memory", "eax", "edx"
    );

vpextr/vpinsr cannot be used with 256-bit wide ymm registers, so 'vinserti128/vextracti128' is needed and make manual gather about the same speed as vpgatherdd.

Now the block cipher implementations need to use all bytes of vector register for table look-ups, and the way that this is done in the AVX implementation of Twofish (move data from vector register to generic purpose registers, handle byte-extraction and table look-ups there and move processed data back to vector register) is about two to three times faster than the way with current AVX2 implementation using vgather.

Blowfish does not do much processing in addition to table look-ups, so there is not much to that can be done. With Twofish, the table look-ups are the most computationally heavy part and I don't think that the wider vector registers in the other parts are going to give much boost. So permanent solution is likely to be revert.

-Jussi

> 
> Thanks,
> 

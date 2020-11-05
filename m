Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F03C4741F
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 16:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BA52073A
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 16:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKEQxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Nov 2020 11:53:13 -0500
Received: from foss.arm.com ([217.140.110.172]:37266 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKEQxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Nov 2020 11:53:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5DFC142F;
        Thu,  5 Nov 2020 08:53:12 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7024C3F719;
        Thu,  5 Nov 2020 08:53:11 -0800 (PST)
Date:   Thu, 5 Nov 2020 16:53:07 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     l00374334 <liqiang64@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201105165301.GH6882@arm.com>
References: <20201103121506.1533-1-liqiang64@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103121506.1533-1-liqiang64@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 03, 2020 at 08:15:05PM +0800, l00374334 wrote:
> From: liqiang <liqiang64@huawei.com>
> 
> Dear all,
> 
> Thank you for taking the precious time to read this email!
> 
> Let me introduce the implementation ideas of my code here.
> 
> In the process of using the compression library libz, I found that the adler32
> checksum always occupies a higher hot spot, so I paid attention to this algorithm.
> After getting in touch with the SVE instruction set of armv8, I realized that
> SVE can effectively accelerate adler32, so I made some attempts and got correct
> and better performance results. I very much hope that this modification can be
> applied to the kernel.
> 
> Below is my analysis process:
> 
> Adler32 algorithm
> =================
> 
> Reference: https://en.wikipedia.org/wiki/Adler-32
> 
> Assume that the buf of the Adler32 checksum to be calculated is D and the length is n:
> 
>         A = 1 + D1 + D2 + ... + Dn (mod 65521)
> 
>         B = (1 + D1) + (1 + D1 + D2) + ... + (1 + D1 + D2 + ... + Dn) (mod 65521)
>           = n×D1 + (n−1)×D2 + (n−2)×D3 + ... + Dn + n (mod 65521)
> 
>         Adler-32(D) = B × 65536 + A
> 
> In C, an inefficient but straightforward implementation is:
> 
>         const uint32_t MOD_ADLER = 65521;
> 
>         uint32_t adler32(unsigned char *data, size_t len)
>         {
>                 uint32_t a = 1, b = 0;
>                 size_t index;
> 
>                 // Process each byte of the data in order
>                 for (index = 0; index < len; ++index)
>                 {
>                         a = (a + data[index]) % MOD_ADLER;
>                         b = (b + a) % MOD_ADLER;
>                 }
> 
>                 return (b << 16) | a;
>         }
> 
> SVE vector method
> =================
> 
> Step 1. Determine the block size:
>         Use addvl instruction to get SVE bit width.
>         Assuming the SVE bit width is x here.
> 
> Step 2. Start to calculate the first block:
>         The calculation formula is:
>                 A1 = 1 + D1 + D2 + ... + Dx (mod 65521)
>                 B1 = x*D1 + (x-1)*D2 + ... + Dx + x (mod 65521)
> 
> Step 3. Calculate the follow block:
>         The calculation formula of A2 is very simple, just add up:
>                 A2 = A1 + Dx+1 + Dx+2 + ... + D2x (mod 65521)
> 
>         The calculation formula of B2 is more complicated, because
>         the result is related to the length of buf. When calculating
>         the B1 block, it is actually assumed that the length is the
>         block length x. Now when calculating B2, the length is expanded
>         to 2x, so B2 becomes:
>                 B2 = 2x*D1 + (2x-1)*D2             + ... + (x+1)*Dx + x*D(x+1) + ... + D2x + 2x
>                    = x*D1 + x*D1 + x*D2 + (x-1)*D2 + ... + x*Dx + Dx + x*1 + x + [x*D(x+1) + (x-1)*D(x+2) + ... + D2x]
>                      ^^^^   ~~~~   ^^^^   ~~~~~~~~         ^^^^   ~~   ^^^   ~   +++++++++++++++++++++++++++++++++++++
>         Through the above polynomial transformation:
>                 Symbol "^" represents the <x * A1>;
>                 Symbol "~" represents the <B1>;
>                 Symbol "+" represents the next block.
> 
>         So we can get the method of calculating the next block from
>         the previous block(Assume that the first byte number of the
>         new block starts from 1):
>                 An+1 = An + D1 + D2 + ... + Dx (mod 65521)
>                 Bn+1 = Bn + x*An + x*D1 + (x-1)*D2 + ... + Dx (mod 65521)

Putting aside people's concerns for the moment, I think this may be
formulated in a slightly more convenient way:

If
	X0, X1, ... are the data bytes
	An is 1 + Sum [i=0 .. n-1] Xi
	Bn is n + Sum [i=0 .. n-1] (n-i)Xi
		= Sum [i=1 .. n] Ai

(i.e., An, Bn are the accumulations for the first n bytes here, not the
first n blocks)

then

	A[n+v] - An = Sum[i=n .. n+v-1] Xi

	B[n+v] - Bn = v + (Sum [i=0 .. n+v-1] (n+v-i) Xi)
			- Sum [i=0 .. n-1] (n-i)Xi

		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
			+ (Sum [i=0 .. n-1] (n+v-i) Xi)
			- Sum [i=0 .. n-1] (n-i)Xi

		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
			+ Sum [i=0 .. n-1] ((n+v-i) - (n-i)) Xi

		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
			+ vSum [i=0 .. n-1] Xi

		= v + v(An - 1) + Sum [i=n .. n+v-1] (n+v-i) Xi

		= vAn + Sum [i=n .. n+v-1] (n+v-i) Xi

		= vAn + vSum [i=n .. n+v-1] Xi
			+ Sum [i=n .. n+v-1] (n-i) Xi

		= vAn + vSum [i=n .. n+v-1] Xi
			+ Sum [i=n .. n+v-1] (n-i) Xi

		= vA[n+v] + Sum [i=n .. n+v-1] (n-i) Xi

Let j = i - n; then:

	B[n+v] - Bn = vA[n+v] - Sum [j=0 .. v-1] j X[j+n]

Which gives us a multiplier j that increases with the X[] index.


I think this gives a core loop along the following lines.  I don't know
whether this is correct, or whether it works -- but feel free to take
ideas from it if it helps.

Accumulators are 32 bits.  This provides for a fair number of iterations
without overflow, but large input data will still require splitting into
chunks, with modulo reduction steps in between.  There are rather a lot
of serial dependencies in the core loop, but since the operations
involved are relatively cheap, this is probably not a significant issue
in practice: the load-to-use dependency is probably the bigger concern.
Pipelined loop unrolling could address these if necessary.

The horizontal reductions (UADDV) still probably don't need to be done
until after the last chunk.


Beware: I wasn't careful with the initial values for Bn / An, so some
additional adjustments might be needed...

--8<--

	ptrue   pP.s
	ptrue   pA.s

	mov     zA.s, #0                // accumulator for An
	mov     zB.s, #0                // accumulator for Bn
	index   zJ.s, #0, #1            // zJ.s = [0, 1, .. V-1]

	mov     zV.s, #0
	incw    zV.s                    // zV.s = [V, V, .. V]

// where V is number of elements per block
//      = the number of 32-bit elements that fit in a Z-register

	add     xLimit, xX, xLen
	b       start

loop:   
	ld1b    zX.s, pP/z, [xX]
	incw    xX

	add     zA.s, pP/m, zA.s, zX.s        // zA.s += zX.s

	msb     zX.s, pP/m, zJ.s, zB.s        // zX.s := zB.s - zX.s * zJ.s

	movprfx zB, zA
	mad     zB.s, pP/m, zV.s, zX.s        // zB.s := zX.s + zA.s * V
start:  
	whilelo pP.s, xX, xLimit
	b.first loop

// Collect the partial sums together:

	uaddv   d0, pA, z0.s
	uaddv   d1, pA, z1.s

// Finally, add 1 to d0, and xLen to d1, and do modulo reduction.

-->8--

[...]

Cheers
---Dave

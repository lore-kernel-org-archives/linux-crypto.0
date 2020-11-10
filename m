Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BB5C56201
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 13:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357FF207D3
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 13:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgKJNVE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 08:21:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7477 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbgKJNVD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 08:21:03 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CVpQW2V7rzhZ1g;
        Tue, 10 Nov 2020 21:20:51 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Nov 2020
 21:20:46 +0800
Subject: Re: [PATCH 0/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Dave Martin <Dave.Martin@arm.com>
CC:     <alexandre.torgue@st.com>, <catalin.marinas@arm.com>,
        <linux-crypto@vger.kernel.org>, <mcoquelin.stm32@gmail.com>,
        <will@kernel.org>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.apana.org.au>, <luchunhua@huawei.com>,
        <gaoguijin@huawei.com>, <colordev.jiang@huawei.com>,
        <liliang889@huawei.com>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201105165301.GH6882@arm.com>
 <f323de50-c358-88e7-6588-7d14542f2754@huawei.com>
 <20201110104629.GJ6882@arm.com>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <89a9bdcc-b96e-2f2d-6c52-ca44e0e3472c@huawei.com>
Date:   Tue, 10 Nov 2020 21:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110104629.GJ6882@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/10 18:46, Dave Martin 写道:
> On Mon, Nov 09, 2020 at 11:43:35AM +0800, Li Qiang wrote:
>> Hi Dave,
>>
>> I carefully read the ideas you provided and the sample code you gave me.:)
>>
>> 在 2020/11/6 0:53, Dave Martin 写道:
>>> On Tue, Nov 03, 2020 at 08:15:05PM +0800, l00374334 wrote:
>>>> From: liqiang <liqiang64@huawei.com>
>>>>
>>>> Dear all,
>>>>
>>>> Thank you for taking the precious time to read this email!
>>>>
>>>> Let me introduce the implementation ideas of my code here.
>>>>
>>>> In the process of using the compression library libz, I found that the adler32
>>>> checksum always occupies a higher hot spot, so I paid attention to this algorithm.
>>>> After getting in touch with the SVE instruction set of armv8, I realized that
>>>> SVE can effectively accelerate adler32, so I made some attempts and got correct
>>>> and better performance results. I very much hope that this modification can be
>>>> applied to the kernel.
>>>>
>>>> Below is my analysis process:
>>>>
>>>> Adler32 algorithm
>>>> =================
>>>>
>>>> Reference: https://en.wikipedia.org/wiki/Adler-32
>>>>
>>>> Assume that the buf of the Adler32 checksum to be calculated is D and the length is n:
>>>>
>>>>         A = 1 + D1 + D2 + ... + Dn (mod 65521)
>>>>
>>>>         B = (1 + D1) + (1 + D1 + D2) + ... + (1 + D1 + D2 + ... + Dn) (mod 65521)
>>>>           = n×D1 + (n−1)×D2 + (n−2)×D3 + ... + Dn + n (mod 65521)
>>>>
>>>>         Adler-32(D) = B × 65536 + A
>>>>
>>>> In C, an inefficient but straightforward implementation is:
>>>>
>>>>         const uint32_t MOD_ADLER = 65521;
>>>>
>>>>         uint32_t adler32(unsigned char *data, size_t len)
>>>>         {
>>>>                 uint32_t a = 1, b = 0;
>>>>                 size_t index;
>>>>
>>>>                 // Process each byte of the data in order
>>>>                 for (index = 0; index < len; ++index)
>>>>                 {
>>>>                         a = (a + data[index]) % MOD_ADLER;
>>>>                         b = (b + a) % MOD_ADLER;
>>>>                 }
>>>>
>>>>                 return (b << 16) | a;
>>>>         }
>>>>
>>>> SVE vector method
>>>> =================
>>>>
>>>> Step 1. Determine the block size:
>>>>         Use addvl instruction to get SVE bit width.
>>>>         Assuming the SVE bit width is x here.
>>>>
>>>> Step 2. Start to calculate the first block:
>>>>         The calculation formula is:
>>>>                 A1 = 1 + D1 + D2 + ... + Dx (mod 65521)
>>>>                 B1 = x*D1 + (x-1)*D2 + ... + Dx + x (mod 65521)
>>>>
>>>> Step 3. Calculate the follow block:
>>>>         The calculation formula of A2 is very simple, just add up:
>>>>                 A2 = A1 + Dx+1 + Dx+2 + ... + D2x (mod 65521)
>>>>
>>>>         The calculation formula of B2 is more complicated, because
>>>>         the result is related to the length of buf. When calculating
>>>>         the B1 block, it is actually assumed that the length is the
>>>>         block length x. Now when calculating B2, the length is expanded
>>>>         to 2x, so B2 becomes:
>>>>                 B2 = 2x*D1 + (2x-1)*D2             + ... + (x+1)*Dx + x*D(x+1) + ... + D2x + 2x
>>>>                    = x*D1 + x*D1 + x*D2 + (x-1)*D2 + ... + x*Dx + Dx + x*1 + x + [x*D(x+1) + (x-1)*D(x+2) + ... + D2x]
>>>>                      ^^^^   ~~~~   ^^^^   ~~~~~~~~         ^^^^   ~~   ^^^   ~   +++++++++++++++++++++++++++++++++++++
>>>>         Through the above polynomial transformation:
>>>>                 Symbol "^" represents the <x * A1>;
>>>>                 Symbol "~" represents the <B1>;
>>>>                 Symbol "+" represents the next block.
>>>>
>>>>         So we can get the method of calculating the next block from
>>>>         the previous block(Assume that the first byte number of the
>>>>         new block starts from 1):
>>>>                 An+1 = An + D1 + D2 + ... + Dx (mod 65521)
>>>>                 Bn+1 = Bn + x*An + x*D1 + (x-1)*D2 + ... + Dx (mod 65521)
>>>
>>> Putting aside people's concerns for the moment, I think this may be
>>> formulated in a slightly more convenient way:
>>>
>>> If
>>> 	X0, X1, ... are the data bytes
>>> 	An is 1 + Sum [i=0 .. n-1] Xi
>>> 	Bn is n + Sum [i=0 .. n-1] (n-i)Xi
>>> 		= Sum [i=1 .. n] Ai
>>
>> Yes, this can be calculated from the original expression.
>>
>>>
>>> (i.e., An, Bn are the accumulations for the first n bytes here, not the
>>> first n blocks)
>>>
>>> then
>>>
>>> 	A[n+v] - An = Sum[i=n .. n+v-1] Xi
>>>
>>> 	B[n+v] - Bn = v + (Sum [i=0 .. n+v-1] (n+v-i) Xi)
>>> 			- Sum [i=0 .. n-1] (n-i)Xi
>>>
>>> 		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
>>> 			+ (Sum [i=0 .. n-1] (n+v-i) Xi)
>>> 			- Sum [i=0 .. n-1] (n-i)Xi
>>>
>>> 		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
>>> 			+ Sum [i=0 .. n-1] ((n+v-i) - (n-i)) Xi
>>>
>>> 		= v + (Sum [i=n .. n+v-1] (n+v-i) Xi)
>>> 			+ vSum [i=0 .. n-1] Xi
>>>
>>> 		= v + v(An - 1) + Sum [i=n .. n+v-1] (n+v-i) Xi
>>>
>>> 		= vAn + Sum [i=n .. n+v-1] (n+v-i) Xi
>>>
>>> 		= vAn + vSum [i=n .. n+v-1] Xi
>>> 			+ Sum [i=n .. n+v-1] (n-i) Xi
>>>
>>> 		= vAn + vSum [i=n .. n+v-1] Xi
>>> 			+ Sum [i=n .. n+v-1] (n-i) Xi
>>>
>>> 		= vA[n+v] + Sum [i=n .. n+v-1] (n-i) Xi
>>>
>>> Let j = i - n; then:
>>>
>>> 	B[n+v] - Bn = vA[n+v] - Sum [j=0 .. v-1] j X[j+n]
>>>
>>> Which gives us a multiplier j that increases with the X[] index.
>>
>> My original approach is to multiply the byte sequence with the **decreasing**
>> sequence. I think the increasing sequence here is more friendly to the trailing
>> bytes of the loop.:-)
>>
>>>
>>>
>>> I think this gives a core loop along the following lines.  I don't know
>>> whether this is correct, or whether it works -- but feel free to take
>>> ideas from it if it helps.
>>>
>>> Accumulators are 32 bits.  This provides for a fair number of iterations
>>> without overflow, but large input data will still require splitting into
>>> chunks, with modulo reduction steps in between.  There are rather a lot
>>> of serial dependencies in the core loop, but since the operations
>>> involved are relatively cheap, this is probably not a significant issue
>>> in practice: the load-to-use dependency is probably the bigger concern.
>>> Pipelined loop unrolling could address these if necessary.
>>>
>>> The horizontal reductions (UADDV) still probably don't need to be done
>>> until after the last chunk.
>>>
>>>
>>> Beware: I wasn't careful with the initial values for Bn / An, so some
>>> additional adjustments might be needed...
>>>
>>> --8<--
>>>
>>> 	ptrue   pP.s
>>> 	ptrue   pA.s
>>>
>>> 	mov     zA.s, #0                // accumulator for An
>>> 	mov     zB.s, #0                // accumulator for Bn
>>> 	index   zJ.s, #0, #1            // zJ.s = [0, 1, .. V-1]
>>>
>>> 	mov     zV.s, #0
>>> 	incw    zV.s                    // zV.s = [V, V, .. V]
>>
>> When I actually tested this code, I found that the byte length of the
>> test must be equal to the vector length divided by 4 (that is, an integer
>> multiple of the number of words in the SVE) and the result is correct.
>>
>> And I think one of the reasons is that the value stored in zV.s needs to be
>> changed in the last cycle. It should be changed to the actual number of
>> bytes remaining in the last cycle. :)
> 
> Ah yes, you're quite right about this.  In my derivation above, v will
> need to be smaller than the vector length when processing the final,
> partial block (if any).
> 
>>
>>>
>>> // where V is number of elements per block
>>> //      = the number of 32-bit elements that fit in a Z-register
>>>
>>> 	add     xLimit, xX, xLen
>>> 	b       start
>>>
>>> loop:   
>>> 	ld1b    zX.s, pP/z, [xX]
>>> 	incw    xX
>>
>> In order to verify my conjecture, I added a bit of code to here, which is to
>> subtract the corresponding value from zV in the last loop. But it is correct
>> only when the number of bytes is less than one cycle. Test cases that exceed
>> one complete cycle will also fail.
>>
>> So I guess before calculating the last cycle, zA should be summed first,
>> because before the end of the cycle, zA and zB are scattered in the elements
>> of the vector, if the last cycle calculates zB, only part of zA is summed
>> ( Because pP/m does not count inactive elements), it should be incomplete.
>>
>> This is just my guess and has not yet been verified.:)
> 
> I think zA shouldn't be wrong, since that only accumulates active
> elements anyway.  I think it's the bogus zV multiplier involved in the
> update to zB that is the problem.
> 
>>>
>>> 	add     zA.s, pP/m, zA.s, zX.s        // zA.s += zX.s
>>>
>>> 	msb     zX.s, pP/m, zJ.s, zB.s        // zX.s := zB.s - zX.s * zJ.s
>>>
>>> 	movprfx zB, zA
>>> 	mad     zB.s, pP/m, zV.s, zX.s        // zB.s := zX.s + zA.s * V

I found the bug I encountered earlier, that is, the calculation of zB here
needs to use pA with all elements activated. The reason is the same as my
previous guess, because all elements of zA should be involved when calculating zB.
Because the original calculation formula is like this.

For example:
In the last loop:
	left byte is:	  3 |   4 |  \0 |
	zA.s is:	100 | 200 | 100 | 200 (sum = 600)
	pP.s is:	  1 |   1 |   0 |   0 (Only activate the first 2 channels)

At this time, if the calculation of zB only takes the first 2 active elements, the data
is incomplete, because according to the description of the original algorithm, zB is always
based on the sum of all the accumulated bytes.

Here we can simply change the prediction register used in the two sentences related to
zB to the one that is all true (it is pA in our code), like this:
	msb     zX.s, pA/m, zJ.s, zB.s        // zX.s := zB.s - zX.s * zJ.s

	movprfx zB, zA
	mad     zB.s, pA/m, zV.s, zX.s        // zB.s := zX.s + zA.s * V

>>> start:  
>>> 	whilelo pP.s, xX, xLimit
>>> 	b.first loop
> 
> There are a few options, I guess.
> 
> One way is to use CNTP inside the loop to get the number of active
> elements, instead of just setting zV in advance.  This approach may add
> a slight overhead, but it is worth experimenting with it.  If the
> overhead is neglibible, then this approach has the example of being
> simple to understand.
> 
> Alternatively, you could do an adjustment after the loop ends to
> subtract the appropriate amounts from zB.  Unfortunately, pP has already
> been overwritten by the time the loop ends.  If could be backed up into
> another P-register before overwriting it: this should be pretty low-
> overhead.
> 
> A final option would be to change the b.first to a b.last, so that the
> loop ends after the final full block.  Then copy-paste the loop body to
> execute once more, but using CNTP to get the element count to multiply
> by, as described above.  This makes the code a bit larger, but it
> probably the best-performance option.  You may be able to rotate the
> loop so that it breaks out after updating zA (which IIUC doesn't need to
> be done in a special way for the partial block).  This would mean you
> only have to specialise the zB update code.

Regarding the last loop, I tried to wrap another layer before and after the
core loop, and I have verified its correctness.
My code is at the end of this email.

> 
>>>
>>> // Collect the partial sums together:
>>>
>>> 	uaddv   d0, pA, z0.s
>>> 	uaddv   d1, pA, z1.s
>>>
>>> // Finally, add 1 to d0, and xLen to d1, and do modulo reduction.
>>>
>>> -->8--
>>>
>>> [...]
>>>
>>> Cheers
>>> ---Dave
>>> .
>>>
>>
>> The code you sent me provides a correct way to deal with trailing bytes,
>> I need to spend some more time to debug the problem encountered above.
>> Thank you!
>>
>> Cheers.^_^
> 
> I was cheekily leaving the testing and debugging for you to do :)
> 
> Part of my reason for interest in this is that if we enable SVE in the
> kernel, it would be good to have some clean examples for people to
> follow -- even if not this algo.  SVE is a bit different to use
> compared with fixed-length vector ISAs, so worked examples are always
> useful.
Yes it is necessary.

> 
> Cheers
> ---Dave
> .
> 

This is the main part of my newly modified code:
--8<--
        ptrue   p0.s
        ptrue   p1.s

        mov     zA.s, #0
        mov     zB.s, #0
        index   zJ.s, #0, #1
        mov     zV.s, #0
        incw    zV.s

        add     xLimit, x1, x2
        b       start		//Enter the core loop first

trailloop:			// Last cycle entrance
        cntp    x6, p1, p0.s	// Get active element count of last cycle
        cpy     zV.s, p1/m, w6	// Set zV to the actual value.

loop:				// Core loop entrance
        ld1b    zX.s, p0/z, [x1]
        incw    x1

        add     zA.s, p0/m, zA.s, zX.s	// The calculation of zA still needs to use p0
        msb     zX.s, p1/m, zJ.s, zB.s	// Change p register here
        movprfx zB, zA
        mad     zB.s, p1/m, zV.s, zX.s	// Change p register here
start:
        whilelo p0.s, x1, xLimit
        b.last  loop		// The condition for the core loop to continue is that b.last is true
        b.first trailloop	// If b.last is false and b.first is true, it means the last cycle

        uaddv   d0, p1, zA.s
        uaddv   d1, p1, zB.s

        mov     x12, v0.2d[0]
        mov     x13, v1.2d[0]
        add     x10, x10, x12
        add     x11, x11, x13
        add     x11, x11, x2

        mod65521        10, 14, 12
        mod65521        11, 14, 12
        lsl     x11, x11, #16
        orr     x0, x10, x11
        ret
-->8--

After this modification, The test results are correct when the data length is less than about 8 Kbyte,
part A will still be correct after 8K, and an overflow error will occur in part B. This is because A
only accumulates all the bytes, and the accumulative acceleration of B expands faster, because the
accumulative formula of B is:
	B = (1 + D1) + (1 + D1 + D2) + ... + (1 + D1 + D2 + ... + Dn) (mod 65521)
           = n×D1 + (n−1)×D2 + (n−2)×D3 + ... + Dn + n (mod 65521)

If we take the average value of Dx to 128 and n to 8192:
	B = (1 + 2 + ... + 8129) * 128 + 8192
	  = 4,295,499,776 (32bit overflow)

So I think the 32-bit accumulator is still not enough for part B here. :)

-- 
Best regards,
Li Qiang

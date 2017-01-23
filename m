From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH] x86/crypto: make constants readonly, allow linker to
 merge them
Date: Mon, 23 Jan 2017 16:21:11 +0100
Message-ID: <eec46e0c-0205-4ba6-46ff-75e22d83214e@redhat.com>
References: <20170119213304.18140-1-dvlasenk@redhat.com>
 <alpine.DEB.2.20.1701200006100.5358@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>, linux-crypto@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1701200006100.5358@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/20/2017 12:09 AM, Thomas Gleixner wrote:
> On Thu, 19 Jan 2017, Denys Vlasenko wrote:
>
>> A lot of asm-optimized routines in arch/x86/crypto/ keep its
>> constants in .data. This is wrong, they should be on .rodata.
>>
>> Mnay of these constants are the same in different modules.
>> For example, 128-bit shuffle mask 0x000102030405060708090A0B0C0D0E0F
>> exists in at least half a dozen places.
>>
>> There is a way to let linker merge them and use just one copy.
>> The rules are as follows: mergeable objects of different sizes
>> should not share sections. You can't put them all in one .rodata
>> section, they will lose "mergeability".
>>
>> GCC puts its mergeable constants in ".rodata.cstSIZE" sections,
>> or ".rodata.cstSIZE.<object_name>" if -fdata-sections is used.
>> This patch does the same:
>>
>> 	.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
>>
>> It is important that all data in such section consists of
>> 16-byte elements, not larger ones, and there are no implicit
>> use of one element from another.
>>
>> When this is not the case, use non-mergeable section:
>>
>> 	.section .rodata[.VAR_NAME], "a", @progbits
>>
>> This reduces .data by ~15 kbytes:
>>
>>     text    data     bss     dec      hex filename
>> 11097415 2705840 2630712 16433967  fac32f vmlinux-prev.o
>> 11112095 2690672 2630712 16433479  fac147 vmlinux.o
>
> And at the same time it increases text size by ~15k. The overall change in
> total size is 488 byte reduction. Weird.

Of course: the constants do need to go somewhere. They migrate to
.rodata.blabla sections, which eventually got appended to read-only .text

Without merging, if I would just move constants to .rodata,
there would be no net size win at all.

I did not look deepper why the overall change is smaller than expected.
It may be affected by changed padding. The linker is not too clever
about it, and also IIRC we don't actually giving it the best options
to sort sections during link time to pack them better.

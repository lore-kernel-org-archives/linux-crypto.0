From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/crypto: make constants readonly, allow linker to
 merge them
Date: Fri, 20 Jan 2017 00:09:13 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1701200006100.5358@nanos>
References: <20170119213304.18140-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>, linux-crypto@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170119213304.18140-1-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 19 Jan 2017, Denys Vlasenko wrote:

> A lot of asm-optimized routines in arch/x86/crypto/ keep its
> constants in .data. This is wrong, they should be on .rodata.
> 
> Mnay of these constants are the same in different modules.
> For example, 128-bit shuffle mask 0x000102030405060708090A0B0C0D0E0F
> exists in at least half a dozen places.
> 
> There is a way to let linker merge them and use just one copy.
> The rules are as follows: mergeable objects of different sizes
> should not share sections. You can't put them all in one .rodata
> section, they will lose "mergeability".
> 
> GCC puts its mergeable constants in ".rodata.cstSIZE" sections,
> or ".rodata.cstSIZE.<object_name>" if -fdata-sections is used.
> This patch does the same:
> 
> 	.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
> 
> It is important that all data in such section consists of
> 16-byte elements, not larger ones, and there are no implicit
> use of one element from another.
> 
> When this is not the case, use non-mergeable section:
> 
> 	.section .rodata[.VAR_NAME], "a", @progbits
> 
> This reduces .data by ~15 kbytes:
> 
>     text    data     bss     dec      hex filename
> 11097415 2705840 2630712 16433967  fac32f vmlinux-prev.o
> 11112095 2690672 2630712 16433479  fac147 vmlinux.o

And at the same time it increases text size by ~15k. The overall change in
total size is 488 byte reduction. Weird.

Thanks,

	tglx

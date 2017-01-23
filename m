From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86/crypto: make constants readonly, allow linker to
 merge them
Date: Mon, 23 Jan 2017 23:00:51 +0800
Message-ID: <20170123150051.GG20806@gondor.apana.org.au>
References: <20170119213304.18140-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>, linux-crypto@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47013 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750714AbdAWPBF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 10:01:05 -0500
Content-Disposition: inline
In-Reply-To: <20170119213304.18140-1-dvlasenk@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2017 at 10:33:04PM +0100, Denys Vlasenko wrote:
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
> 
> Merged objects are visible in System.map:
> 
> ffffffff81a28810 r POLY
> ffffffff81a28810 r POLY
> ffffffff81a28820 r TWOONE
> ffffffff81a28820 r TWOONE
> ffffffff81a28830 r PSHUFFLE_BYTE_FLIP_MASK <- merged regardless of
> ffffffff81a28830 r SHUF_MASK   <------------- the name difference
> ffffffff81a28830 r SHUF_MASK
> ffffffff81a28830 r SHUF_MASK
> ..
> ffffffff81a28d00 r K512 <- merged three identical 640-byte tables
> ffffffff81a28d00 r K512
> ffffffff81a28d00 r K512
> 
> Use of object names in section name suffixes is not strictly necessary,
> but might help if someday link stage will use garbage collection
> to eliminate unused sections (ld --gc-sections).
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

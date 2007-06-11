From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] [CRYPTO] Add optimized SHA-1 implementation for x86_64
Date: 11 Jun 2007 14:01:56 +0200
Message-ID: <p73lkeqvgwb.fsf@bingen.suse.de>
References: <20070608214242.23949.30350.stgit@dev>
	<20070608214258.23949.67358.stgit@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:59774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFKLGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2007 07:06:05 -0400
In-Reply-To: <20070608214258.23949.67358.stgit@dev>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Benjamin Gilbert <bgilbert@cs.cmu.edu> writes:

> +/* push/pop wrappers that update the DWARF unwind table */
> +#define PUSH(regname)						\
> +	push			%regname;			\
> +	CFI_ADJUST_CFA_OFFSET	8;				\
> +	CFI_REL_OFFSET		regname, 0
> +
> +#define POP(regname)						\
> +	pop			%regname;			\
> +	CFI_ADJUST_CFA_OFFSET	-8;				\
> +	CFI_RESTORE		regname

Please don't do these kinds of wrappers. They just obfuscate the code.

And BTW plain gas macros (.macro) are much nicer to read too
than cpp macros.


> +#define EXPAND(i)						\
> +	movl	OFFSET(i % 16)(DATA), TMP;			\
> +	xorl	OFFSET((i + 2) % 16)(DATA), TMP;		\

Such overlapping memory accesses are somewhat dangerous as they tend
to stall some CPUs.  Better probably to do a quad load and then extract.

If you care about the last cycle I would suggest you run 
it at least once through the Pipeline simulator in the Linux
version of AMD CodeAnalyst or through vtune.

I haven't checked in detail if it's possible but it's suspicious you
never use quad operations for anything. You keep at least half
the CPU's bits idle all the time.

> +	EXPAND(75); ROUND(SA, SB, SC, SD, SE, F2, TMP)
> +	EXPAND(76); ROUND(SE, SA, SB, SC, SD, F2, TMP)
> +	EXPAND(77); ROUND(SD, SE, SA, SB, SC, F2, TMP)
> +	EXPAND(78); ROUND(SC, SD, SE, SA, SB, F2, TMP)
> +	EXPAND(79); ROUND(SB, SC, SD, SE, SA, F2, TMP)

Gut feeling is that the unroll factor is far too large.
Have you tried a smaller one? That would save icache
which is very important in the kernel. Unlike in your micro benchmark
when kernel code runs normally caches are cold.  Smaller is faster then.
And most kernel SHA applications don't process very much data anyways
so startup costs are important.

> diff --git a/lib/Kconfig b/lib/Kconfig
> index 69fdb64..23a84ed 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -132,9 +132,14 @@ config SHA1_X86
>  	depends on (X86 || UML_X86) && !64BIT && X86_BSWAP
>  	default y
>  
> +config SHA1_X86_64
> +	bool
> +	depends on (X86 || UML_X86) && 64BIT
> +	default y
> +
>  config SHA1_GENERIC
>  	bool
> -	depends on !SHA1_X86
> +	depends on !SHA1_X86 && !SHA1_X86_64

Better define a SHA_ARCH_OPTIMIZED helper symbol, otherwise
this will get messy as more architectures add optimized versions.

-Andi

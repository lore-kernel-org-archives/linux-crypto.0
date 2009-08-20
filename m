From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] Add VMAC(AES) to Linux for intel_txt support
Date: Thu, 20 Aug 2009 20:09:49 +1000
Message-ID: <20090820100949.GA31928@gondor.apana.org.au>
References: <4A5F41C4.3050808@intel.com> <4A5F431B.6060307@intel.com> <4A805375.4030902@intel.com> <20090814032201.GA2544@gondor.apana.org.au> <4A85955F.3040807@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
To: Shane Wang <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38468 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753700AbZHTKKA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2009 06:10:00 -0400
Content-Disposition: inline
In-Reply-To: <4A85955F.3040807@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 15, 2009 at 12:48:31AM +0800, Shane Wang wrote:
>
> +/* x86_64 or amd64 */
> +#if (__GNUC__ && (__x86_64__ || __amd64__))
> +
> +#define ADD128(rh, rl, ih, il)						\
> +	asm ("addq %3, %1 \n\t"						\
> +	"adcq %2, %0"							\
> +	: "+r"(rh), "+r"(rl)						\
> +	: "r"(ih), "r"(il) : "cc")
> +
> +#define MUL64(rh, rl, i1, i2)						\
> +    asm ("mulq %3" : "=a"(rl), "=d"(rh) : "a"(i1), "r"(i2) : "cc")
> +
> +#define PMUL64 MUL64

You should not put assembly code in generic header/C files.

In this case, you may not even need them as gcc is capable of
optimising

int bar(u64, u64);
int foo(u64 a, u64 b, u64 c, u64 d)
{
        u64 e;

        b += d;
        e = a + c;
        if (e < a)
                b++;
        return bar(e, b);
}

to

foo:
.LFB2:
        addq    %rdx, %rdi
        adcq    %rcx, %rsi
        jmp     bar

If you really need the assembly, then you should add them as
arch-specific implementations of VMAC, just like AES-x86-64.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Mon, 2 Nov 2009 16:46:04 +0100
Message-ID: <20091102154604.GA26453@elte.hu>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu> <20091102142824.GA31981@gondor.apana.org.au> <20091102143258.GA23776@elte.hu> <20091102144621.GA32164@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:44224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbZKBPqP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 10:46:15 -0500
Content-Disposition: inline
In-Reply-To: <20091102144621.GA32164@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Nov 02, 2009 at 03:32:58PM +0100, Ingo Molnar wrote:
> > 
> > Please use the standard construct and put an #ifndef __ASSEMBLY__ around 
> > it.
> 
> You mean like this?
> 
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 0b20bbb..e22d237 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -10,6 +10,13 @@
>  #ifndef _ASM_X86_I387_H
>  #define _ASM_X86_I387_H
>  
> +#ifdef __ASSEMBLY__
> +
> +#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
> +#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
> +
> +#else
> +
>  #include <linux/sched.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/regset.h>
> @@ -411,4 +418,5 @@ static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
>  	}
>  }
>  
> +#endif /* __ASSEMBLY__ */
>  #endif /* _ASM_X86_I387_H */

Yeah. Or just a single block of:


  #ifndef __ASSEMBLY__
  ...
  #endif /* __ASSEMBLY__ */

around the C bits - anything outside that is good for assembly as well. 

	Ingo

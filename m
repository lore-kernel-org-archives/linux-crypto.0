From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Wed, 17 Jun 2009 18:46:22 +0200
Message-ID: <20090617164622.GB25357@elte.hu>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:54410 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZFQQqd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 12:46:33 -0400
Content-Disposition: inline
In-Reply-To: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Huang Ying <ying.huang@intel.com> wrote:

> This is used by AES-NI accelerated AES implementation and PCLMULQDQ
> accelerated GHASH implementation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/crypto/aesni-intel_glue.c |    7 -------
>  arch/x86/include/asm/i387.h        |    7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct cry
>  asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
>  			      const u8 *in, unsigned int len, u8 *iv);
>  
> -static inline int kernel_fpu_using(void)
> -{
> -	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> -		return 1;
> -	return 0;
> -}
> -
>  static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
>  {
>  	unsigned long addr = (unsigned long)raw_ctx;
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -302,6 +302,13 @@ static inline void kernel_fpu_end(void)
>  	preempt_enable();
>  }
>  
> +static inline int kernel_fpu_using(void)
> +{
> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> +		return 1;
> +	return 0;
> +}
> +

Looks sane to me. Herbert, do you ack it?

	Ingo

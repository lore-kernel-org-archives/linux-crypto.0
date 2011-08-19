From: Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Date: Fri, 19 Aug 2011 08:15:16 -0400
Message-ID: <20110819121516.GA2270@zod.bos.redhat.com>
References: <20110811164040.GB2167@zod.bos.redhat.com>
 <20110815071528.GA29656@gondor.apana.org.au>
 <20110815115038.GA2227@zod.bos.redhat.com>
 <20110816123227.GB9413@gondor.apana.org.au>
 <20110818174425.GN2227@zod.bos.redhat.com>
 <20110819000229.GA1076@gondor.apana.org.au>
 <20110819021516.GU2227@zod.bos.redhat.com>
 <20110819073224.GA3658@gondor.apana.org.au>
 <20110819081207.GA3954@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1HSMPX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Aug 2011 08:15:23 -0400
Content-Disposition: inline
In-Reply-To: <20110819081207.GA3954@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2011 at 04:12:08PM +0800, Herbert Xu wrote:
> On Fri, Aug 19, 2011 at 03:32:24PM +0800, Herbert Xu wrote:
> > 
> > Meanwhile I'll make a patch that ensures cryptd is registered
> > before aesni.
> 
> Please try this patch.  Thanks!

This worked great.  I'm confused why adding ivsize to the ablk_ecb_alg
"worked" as well, but looking at the traces again I agree this seems
like the actual problem.

Thanks!

> commit 9d4c522a113f6caa8b792ae829a25490fa87b1a2
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Aug 19 16:11:23 2011 +0800
> 
>     crypto: cryptd - Use subsys_initcall to prevent races with aesni
>     
>     As cryptd is depeneded on by other algorithms such as aesni-intel,
>     it needs to be registered before them.  When everything is built
>     as modules, this occurs naturally.  However, for this to work when
>     they are built-in, we need to use subsys_initcall in cryptd.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Josh Boyer <jwboyer@redhat.com>

> diff --git a/crypto/cryptd.c b/crypto/cryptd.c
> index e46d21a..671d4d6 100644
> --- a/crypto/cryptd.c
> +++ b/crypto/cryptd.c
> @@ -945,7 +945,7 @@ static void __exit cryptd_exit(void)
>  	crypto_unregister_template(&cryptd_tmpl);
>  }
>  
> -module_init(cryptd_init);
> +subsys_initcall(cryptd_init);
>  module_exit(cryptd_exit);
>  
>  MODULE_LICENSE("GPL");
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

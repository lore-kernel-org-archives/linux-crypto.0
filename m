From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [patch] crypto: remove a duplicate checks in __cbc_decrypt()
Date: Fri, 14 Feb 2014 19:43:51 +0200
Message-ID: <52FE55D7.7020706@iki.fi>
References: <20140213145832.GA11059@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45532 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaBNRou (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 12:44:50 -0500
In-Reply-To: <20140213145832.GA11059@elgon.mountain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13.02.2014 16:58, Dan Carpenter wrote:
> We checked "nbytes < bsize" before so it can't happen here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

> ---
> This doesn't change how the code works, but maybe their is a bug in the
> original code.  Please review?
> 
> diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
> index e6a3700489b9..e57e20ab5e0b 100644
> --- a/arch/x86/crypto/cast5_avx_glue.c
> +++ b/arch/x86/crypto/cast5_avx_glue.c
> @@ -203,9 +203,6 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
>  			src -= 1;
>  			dst -= 1;
>  		} while (nbytes >= bsize * CAST5_PARALLEL_BLOCKS);
> -
> -		if (nbytes < bsize)
> -			goto done;
>  	}
>  
>  	/* Handle leftovers */
> diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
> index 50ec333b70e6..8af519ed73d1 100644
> --- a/arch/x86/crypto/blowfish_glue.c
> +++ b/arch/x86/crypto/blowfish_glue.c
> @@ -223,9 +223,6 @@ static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
>  			src -= 1;
>  			dst -= 1;
>  		} while (nbytes >= bsize * 4);
> -
> -		if (nbytes < bsize)
> -			goto done;
>  	}
>  
>  	/* Handle leftovers */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

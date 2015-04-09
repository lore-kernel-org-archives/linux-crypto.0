From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: remove instance when test failed
Date: Thu, 9 Apr 2015 15:41:41 +0800
Message-ID: <20150409074141.GA4394@gondor.apana.org.au>
References: <1461449.htSjBpksos@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50068 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbDIHlr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 03:41:47 -0400
Content-Disposition: inline
In-Reply-To: <1461449.htSjBpksos@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 09, 2015 at 09:36:03AM +0200, Stephan Mueller wrote:
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index f1d0307..cfca1de 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -533,6 +533,13 @@ int crypto_register_instance(struct crypto_template *tmpl,
>  	if (IS_ERR(larval))
>  		goto unlock;
>  
> +	err = -EAGAIN;
> +	if (unlikely(!crypto_mod_get(&inst->alg))) {
> +		up_write(&crypto_alg_sem);
> +		crypto_unregister_instance(inst);
> +		goto err;
> +	}

Just grab the reference count as soon as you enter the function
and then you can unconditionally drop the reference count at the
end.  If you fail to grab it then just return an error and the
caller will free it for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

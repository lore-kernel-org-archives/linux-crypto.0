From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 4/4] esp: add the pcrypt hooks to esp
Date: Fri, 27 Mar 2009 16:44:57 +0800
Message-ID: <20090327084457.GC27903@gondor.apana.org.au>
References: <20090316114940.GN13998@secunet.com> <20090316115526.GR13998@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36101 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbZC0IpE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 04:45:04 -0400
Content-Disposition: inline
In-Reply-To: <20090316115526.GR13998@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 16, 2009 at 12:55:26PM +0100, Steffen Klassert wrote:
>
> @@ -447,7 +448,7 @@ static int esp_init_aead(struct xfrm_state *x)
>  	struct crypto_aead *aead;
>  	int err;
>  
> -	aead = crypto_alloc_aead(x->aead->alg_name, 0, 0);
> +	aead = crypto_alloc_aead_tfm(x->aead->alg_name, 0, 0);

I'd like this to be configurable.  After all, there's not much
point in doing this if your crypto is done through PCI.

The easiest way is to let the user specify pcrypt through the
algorithm name.  In fact, as long as pcrypt has a higher priority
than the default software algorithms, the user simply has to
instantiate it in order for it to be the default for all uses
of that algorithm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

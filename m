From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Alignment in the API, once again
Date: Thu, 2 Aug 2007 10:30:06 +0800
Message-ID: <20070802023006.GA10180@gondor.apana.org.au>
References: <20070801230240.GA18744@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4230 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753033AbXHBCaJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Aug 2007 22:30:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGQRy-00046X-Sv
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 12:30:06 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGQRy-0002fD-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 10:30:06 +0800
Content-Disposition: inline
In-Reply-To: <20070801230240.GA18744@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 01:02:40AM +0200, Sebastian Siewior wrote:
>
> I noticed this, after my code did not work properly. The reason was,
> that my private ctx was not retrieved with
> crypto_ablkcipher_ctx_aligned() (attached) but with
> crypto_ablkcipher_ctx() (and it was not properly aligned anymore).
> My fault right? 

Yeah if your ctx needs to be aligned you need to use
crypto_tfm_ctx_aligned.

> Shouldn't the behavior of crypto_blkcipher_ctx_aligned() (which is
> currently unused) be the default one?

Most of our existing algorithms don't care about alignment.

> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -160,6 +160,11 @@ static inline void *crypto_ablkcipher_ct
>  	return crypto_tfm_ctx(&tfm->base);
>  }
>  
> +static inline void *crypto_ablkcipher_ctx_aligned(struct crypto_ablkcipher *tfm)
> +{
> +	return crypto_tfm_ctx_aligned(&tfm->base);
> +}
> +
>  static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
>  	struct crypto_spawn *spawn)

Looks good.  Could you add a description and sign-off?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

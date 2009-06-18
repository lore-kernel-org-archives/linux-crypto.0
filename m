From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v7
Date: Thu, 18 Jun 2009 18:56:31 +0800
Message-ID: <20090618105631.GA5881@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B07D835A4@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kim.phillips@freescale.com, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.or,
	Loc Ho <lho@amcc.com>, Feng Kan <fkan@amcc.com>,
	Tirumala Reddy Marri <tmarri@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50880 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753298AbZFRK4h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2009 06:56:37 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B07D835A4@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2009 at 02:21:38PM -0700, Shasi Pulijala wrote:
>
> diff --git a/crypto/md5.c b/crypto/md5.c
> index 83eb529..0c74b84 100644
> --- a/crypto/md5.c
> +++ b/crypto/md5.c
> @@ -220,6 +220,21 @@ static int md5_final(struct shash_desc *desc, u8 *out)
>  	return 0;
>  }
>  
> +void md5_get_immediate_hash(struct crypto_tfm *tfm, u8 *data)
> +{
> +	struct shash_desc *desc = crypto_tfm_ctx(tfm);
> +	struct md5_ctx *mctx = shash_desc_ctx(desc);
> +	int i;
> +
> +	for (i = 0; i < MD5_HASH_WORDS; i++) {
> +		*data++ = mctx->hash[i] & 0xFF;
> +		*data++ = (mctx->hash[i] >> 8) & 0xFF;
> +		*data++ = (mctx->hash[i] >> 16) & 0xFF;
> +		*data++ = (mctx->hash[i] >> 24) & 0xFF;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(md5_get_immediate_hash);

This is not going to fly!

What if you get an optimised version of MD5 that doesn't even
use the md5_ctx format for the context?

I suggest that we enshrine this as part of our hash API because
it is quite useful.

In fact I've already added something along these lines but it isn't
quite right for your application.

They currently export/import the entire context, but What you need
is something that is not implementation-dependent.

So I suggest that we add a new function shash to export the state
in an implementation-indepedent way, e.g.,

	err = crypto_shash_partial(desc, out);

Of course we'd need crypto_shash_partsize(desc) to know how big
out should be.

For a first cut, you can implement the partial function just for
the algorithms that you need.  The others can get a filler from
the mid-layer that returns -ENOSYS.

Note that we want the partial result to just contain the current
state of the hash, excluding the byte count and any unused input.
In other words, they should be the format that you currently have
in the patch.  They should be endian-independent too, the endianness
you need would do since you're the first user :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2 PATCH 7/16] crypto: simd - Add simd skcipher helper
Date: Tue, 15 Nov 2016 22:55:27 +0800
Message-ID: <20161115145527.GB20497@gondor.apana.org.au>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tEA-0002AE-UP@gondolin.me.apana.org.au>
 <20161114022740.GD4778@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51114 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbcKOOzc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 09:55:32 -0500
Content-Disposition: inline
In-Reply-To: <20161114022740.GD4778@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 13, 2016 at 06:27:40PM -0800, Eric Biggers wrote:
> On Sun, Nov 13, 2016 at 07:45:38PM +0800, Herbert Xu wrote:
> > This patch adds the simd skcipher helper which is meant to be
> > a replacement for ablk helper.  It replaces the underlying blkcipher
> > interface with skcipher, and also presents the top-level algorithm
> > as an skcipher.
> 
> I assume this means it's planned for all users of ablk_helper to be migrated to
> crypto_simd, and ablk_helper will be removed?

Yes that's the idea.

> > +	salg = kzalloc(sizeof(*alg), GFP_KERNEL);
> > +	if (!salg) {
> > +		salg = ERR_PTR(-ENOMEM);
> > +		goto out_put_tfm;
> > +	}
> 
> Shouldn't this be 'sizeof(*salg)'?

Good catch.  I'll fix this.

> > +	tfm = crypto_alloc_skcipher(basename, CRYPTO_ALG_INTERNAL,
> > +				    CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
> > +	if (IS_ERR(tfm))
> > +		return ERR_CAST(tfm);
> > +
> > +	ialg = crypto_skcipher_alg(tfm);
> 
> It seems this really just needs an algorithm and not a transform.  Perhaps it
> should be calling crypto_find_alg() directly?

crypto_find_alg is an internal API function that should not be used
unless you're implementing a crypto_type.  Ugh I see that it is being
abused already.  I'll get this fixed.

As a rule internal.h should only be used by API implementors, not
algorithm implementors.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

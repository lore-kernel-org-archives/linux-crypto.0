Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfAFVJy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 16:09:54 -0500
Date: Sun, 6 Jan 2019 13:09:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 05/16] crypto: skcipher - add helper for simple block
 cipher modes
Message-ID: <20190106210951.GA1232@sol.localdomain>
References: <20190104041625.3259-1-ebiggers@kernel.org>
 <20190104041625.3259-6-ebiggers@kernel.org>
 <4030532.EK8pHEC8rB@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4030532.EK8pHEC8rB@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Sat, Jan 05, 2019 at 01:03:40PM +0100, Stephan Mueller wrote:
> Am Freitag, 4. Januar 2019, 05:16:14 CET schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The majority of skcipher templates (including both the existing ones and
> > the ones remaining to be converted from the "blkcipher" API) just wrap a
> > single block cipher algorithm.  This includes cbc, cfb, ctr, ecb, kw,
> > ofb, and pcbc.  Add a helper function skcipher_alloc_instance_simple()
> > that handles allocating an skcipher instance for this common case.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Apart from the comment below:
> 
> Reviewed-by: Stephan Mueller <smueller@chronox.de>
> 
> > +struct skcipher_instance *
> > +skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr
> > **tb, +			       struct crypto_alg **cipher_alg_ret)
> > +{
> > +	struct crypto_attr_type *algt;
> > +	struct crypto_alg *cipher_alg;
> > +	struct skcipher_instance *inst;
> > +	struct crypto_spawn *spawn;
> > +	u32 mask;
> > +	int err;
> > +
> > +	algt = crypto_get_attr_type(tb);
> > +	if (IS_ERR(algt))
> > +		return ERR_CAST(algt);
> > +
> > +	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
> > +		return ERR_PTR(-EINVAL);
> 
> Why not using crypto_check_attr_type? I understand that it does not return 
> algt for the next check, but maybe we can consolidate the code a bit here?

crypto_check_attr_type() isn't a great fit because as you point out, it doesn't
return 'algt' to calculate the mask.  So 'algt' would be validated twice.  Also,
most templates actually do the inline check like this.

So for now I prefer to leave this as-is, and leave for later any additional
simplification of this and the other templates doing this same check.  (Maybe we
could add a function that does both the type check and mask calculation.)

> 
> > +
> > +	mask = CRYPTO_ALG_TYPE_MASK |
> > +		crypto_requires_off(algt->type, algt->mask,
> > +				    CRYPTO_ALG_NEED_FALLBACK);
> 
> 

- Eric

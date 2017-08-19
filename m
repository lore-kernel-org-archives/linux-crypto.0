From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v8 3/4] crypto: AF_ALG -- add asymmetric cipher
Date: Sat, 19 Aug 2017 15:53:10 +0200
Message-ID: <5370549.LiGXVyRayf@positron.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <2379311.RoATi6cCiZ@positron.chronox.de> <8450990a-61bb-0f7c-70dd-643a45220d3f@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59068 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbdHSNxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Aug 2017 09:53:13 -0400
In-Reply-To: <8450990a-61bb-0f7c-70dd-643a45220d3f@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 11. August 2017, 14:51:10 CEST schrieb Tudor Ambarus:

Hi Tudor,

I have covered all your requests
> 
> > +	size_t used = 0;
> 
> initialization to zero not needed. You can directly initialize to
> ctx->used or don't initialize at all.

It is not initialized now. We cannot use ctx->used here as the socket (and 
thus the ctx data structure) is not locked yet.

> > +
> > +		/*
> > +		 * This error covers -EIOCBQUEUED which implies that we can
> > +		 * only handle one AIO request. If the caller wants to have
> > +		 * multiple AIO requests in parallel, he must make multiple
> > +		 * separate AIO calls.
> > +		 */
> > +		if (err <= 0) {
> 
> why the equal?

We must get something out of the cipher operation as otherwise something is 
wrong. In this case I would like to error out to prevent an endless loop here.

> > +static int akcipher_setprivkey(void *private, const u8 *key,
> > +			       unsigned int keylen)
> > +{
> > +	struct akcipher_tfm *tfm = private;
> > +	struct crypto_akcipher *akcipher = tfm->akcipher;
> > +	int err;
> > +
> > +	err = crypto_akcipher_set_priv_key(akcipher, key, keylen);
> > +	tfm->has_key = !err;
> > +
> > +	/* Return the maximum size of the akcipher operation. */
> > +	if (!err)
> > +		err = crypto_akcipher_maxsize(akcipher);
> 
> crypto subsystem returns zero when setkey is successful and introduces
> a new function for determining the maxsize. Should we comply with that?

The idea is that only when the the setting of the priv key fails, it returns 
the size of the expected privkey.

Which new function are you referring to?

Ciao
Stephan

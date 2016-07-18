From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: add template handling for RNGs
Date: Mon, 18 Jul 2016 09:18:18 +0200
Message-ID: <1484377.C9YnUIxR2D@tauon.atsec.com>
References: <20160718071417.GA12600@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34688 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbcGRHSZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 03:18:25 -0400
In-Reply-To: <20160718071417.GA12600@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Juli 2016, 15:14:17 schrieb Herbert Xu:

Hi Herbert,
> > 
> > diff --git a/crypto/rng.c b/crypto/rng.c
> > index b81cffb..92cc02a 100644
> > --- a/crypto/rng.c
> > +++ b/crypto/rng.c
> > @@ -232,5 +232,36 @@ void crypto_unregister_rngs(struct rng_alg *algs, int
> > count) }
> > EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
> > 
> > +void rng_free_instance(struct crypto_instance *inst)
> > +{
> > +       crypto_drop_spawn(crypto_instance_ctx(inst));
> > +       kfree(rng_instance(inst));
> > +}
> 
> Please use the new free interface, i.e.,
> 
> void rng_free_instance(struct rng_instance *inst)
> 
> and then
> 
> inst->free = rng_free_instance;
> 
> > +static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
> > +{
> > +       return container_of(alg, struct rng_alg, base);
> > +}
> > +
> > +static inline struct rng_instance *rng_instance(
> > +       struct crypto_instance *inst)
> > +{
> > +       return container_of(__crypto_rng_alg(&inst->alg),
> > +                           struct rng_instance, alg);
> > +}
> 
> These two can then be deleted.

Thanks. I will add that to the next round.
> 
> Thanks,


Ciao
Stephan

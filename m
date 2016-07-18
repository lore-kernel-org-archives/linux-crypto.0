From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/4] crypto: add template handling for RNGs
Date: Mon, 18 Jul 2016 15:14:17 +0800
Message-ID: <20160718071417.GA12600@gondor.apana.org.au>
References: <2944776.2qGGKJgDkv@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47085 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcGRHO2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 03:14:28 -0400
Content-Disposition: inline
In-Reply-To: <2944776.2qGGKJgDkv@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
> This patch adds the ability to register templates for RNGs. RNGs are
> "meta" mechanisms using raw cipher primitives. Thus, RNGs can now be
> implemented as templates to allow the complete flexibility the kernel
> crypto API provides.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
> crypto/rng.c         | 31 +++++++++++++++++++++++++++++++
> include/crypto/rng.h | 39 +++++++++++++++++++++++++++++++++++++++
> 2 files changed, 70 insertions(+)
> 
> diff --git a/crypto/rng.c b/crypto/rng.c
> index b81cffb..92cc02a 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -232,5 +232,36 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
> }
> EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
> 
> +void rng_free_instance(struct crypto_instance *inst)
> +{
> +       crypto_drop_spawn(crypto_instance_ctx(inst));
> +       kfree(rng_instance(inst));
> +}

Please use the new free interface, i.e.,

void rng_free_instance(struct rng_instance *inst)

and then

inst->free = rng_free_instance;

> +static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
> +{
> +       return container_of(alg, struct rng_alg, base);
> +}
> +
> +static inline struct rng_instance *rng_instance(
> +       struct crypto_instance *inst)
> +{
> +       return container_of(__crypto_rng_alg(&inst->alg),
> +                           struct rng_instance, alg);
> +}

These two can then be deleted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 1/4] crypto: add template handling for RNGs
Date: Tue, 9 Aug 2016 18:02:48 +0800
Message-ID: <20160809100248.GA6728@gondor.apana.org.au>
References: <35009855.guO8BxbniF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47068 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbcHIKDM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 06:03:12 -0400
Content-Disposition: inline
In-Reply-To: <35009855.guO8BxbniF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
> +
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

Please move these functions into rng.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

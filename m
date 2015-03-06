From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND 2/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Fri, 6 Mar 2015 22:44:17 +1100
Message-ID: <20150306114417.GA4949@gondor.apana.org.au>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1>
 <20150227193549.10553.52267.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58299 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbbCFLoo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 06:44:44 -0500
Content-Disposition: inline
In-Reply-To: <20150227193549.10553.52267.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2015 at 11:35:49AM -0800, Tadeusz Struk wrote:
>
> +static int skcipher_mempool_create(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct skcipher_ctx *ctx = ask->private;
> +	unsigned int len = sizeof(struct skcipher_async_req) +
> +		GET_REQ_SIZE(ctx) + GET_IV_SIZE(ctx);
> +	char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "skcipher_%p", ctx);
> +	ctx->cache = kmem_cache_create(buf, len, 0, SLAB_HWCACHE_ALIGN |
> +				       SLAB_TEMPORARY,
> +				       skcipher_cache_constructor);

Are these separate caches really necessary? It looks like an
overkill.  What's wrong with just kmalloc?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

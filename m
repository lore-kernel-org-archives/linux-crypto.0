From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Thu, 18 Jan 2018 22:39:06 +1100
Message-ID: <20180118113905.GA19904@gondor.apana.org.au>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
 <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, megha.dey@intel.com
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 09, 2018 at 04:09:04PM -0800, Megha Dey wrote:
>
> +static void mcryptd_skcipher_encrypt(struct crypto_async_request *base,
> +								int err)
> +{
> +	struct skcipher_request *req = skcipher_request_cast(base);
> +	struct mcryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct crypto_skcipher *child = ctx->child;
> +	struct skcipher_request subreq;
> +
> +	if (unlikely(err == -EINPROGRESS))
> +		goto out;
> +
> +	/* set up the skcipher request to work on */
> +	skcipher_request_set_tfm(&subreq, child);
> +	skcipher_request_set_callback(&subreq,
> +					CRYPTO_TFM_REQ_MAY_SLEEP, 0, 0);
> +	skcipher_request_set_crypt(&subreq, req->src, req->dst,
> +					req->cryptlen, req->iv);
> +
> +	/*
> +	 * pass addr of descriptor stored in the request context
> +	 * so that the callee can get to the request context
> +	 */
> +	rctx->desc = subreq;
> +	err = crypto_skcipher_encrypt(&rctx->desc);
> +
> +	if (err) {
> +		req->base.complete = rctx->complete;
> +		goto out;
> +	}
> +	return;
> +
> +out:
> +	mcryptd_skcipher_complete(req, err);
> +}

OK this looks better but it's still abusing the crypto API interface.
In particular, you're sharing data with the underlying algorithm
behind the crypto API's back.  Also, the underlying algorithm does
callback completion behind the API's back through the shared data
context.

It seems to me that the current mcryptd scheme is flawed.  You
want to batch multiple requests and yet this isn't actually being
done by mcryptd at all.  The actual batching happens at the very
lowest level, i.e., in the crypto algorithm below mcryptd.  For
example, with your patch, the batching appears to happen in
aes_cbc_job_mgr_submit.

So the mcryptd template is in fact completely superfluous.  You
can remove it and just have all the main encrypt/decrypt functions
invoke the underlying encrypt/decrypt function directly and achieve
the same result.

Am I missing something?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

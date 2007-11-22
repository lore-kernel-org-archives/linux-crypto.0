From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Thu, 22 Nov 2007 14:17:11 +0300
Message-ID: <20071122111711.GC2444@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45451 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbXKVLRu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:17:50 -0500
Content-Disposition: inline
In-Reply-To: <E1Iv7jn-00020S-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 04:48:43PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> +static int chainiv_givcrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *geniv = crypto_ablkcipher_reqtfm(req);
> +	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
> +	struct ablkcipher_request *subreq = ablkcipher_request_ctx(req);
> +	unsigned int ivsize;
> +	int err;
> +
> +	ablkcipher_request_set_tfm(subreq, ctx->cipher);
> +	ablkcipher_request_set_callback(subreq, req->base.flags &
> +						~CRYPTO_TFM_REQ_MAY_SLEEP,
> +					req->base.complete, req->base.data);
> +	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->nbytes,
> +				     req->info);
> +
> +	spin_lock_bh(&ctx->lock);

Crypto hardware can access iv in interrupt context and thus this can get
wrong data.

> +	ivsize = crypto_ablkcipher_ivsize(geniv);
> +
> +	memcpy(req->giv, ctx->iv, ivsize);
> +	memcpy(req->info, ctx->iv, ivsize);
> +
> +	err = crypto_ablkcipher_encrypt(subreq);
> +	if (err)
> +		goto unlock;

Are you sure that crypto operation has to be limited to be performed
with turned off bottom halves? I believe this is a huge limitation for
those ablkcipher devices which are not async actually...

-- 
	Evgeniy Polyakov

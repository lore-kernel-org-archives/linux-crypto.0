From: Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH 6/16] crypto: cryptd - Add support for skcipher
Date: Sun, 13 Nov 2016 17:45:47 -0800
Message-ID: <20161114014547.GB4778@google.com>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tE9-00029x-Rk@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36628 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcKNBpw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 20:45:52 -0500
Received: by mail-pg0-f44.google.com with SMTP id f188so47373416pgc.3
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 17:45:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <E1c5tE9-00029x-Rk@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 13, 2016 at 07:45:37PM +0800, Herbert Xu wrote:
> +static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
> +				    int err)
> +{
> +	struct skcipher_request *req = skcipher_request_cast(base);
> +	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct crypto_skcipher *child = ctx->child;
> +	SKCIPHER_REQUEST_ON_STACK(subreq, child);
> +
> +	if (unlikely(err == -EINPROGRESS))
> +		goto out;
> +
> +	skcipher_request_set_tfm(subreq, child);
> +	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
> +				      NULL, NULL);
> +	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
> +				   req->iv);
> +
> +	err = crypto_skcipher_encrypt(subreq);
> +	skcipher_request_zero(subreq);
> +
> +	req->base.complete = rctx->complete;
> +
> +out:
> +	cryptd_skcipher_complete(req, err);
> +}
> +
> +static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
> +				    int err)
> +{
> +	struct skcipher_request *req = skcipher_request_cast(base);
> +	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct crypto_skcipher *child = ctx->child;
> +	SKCIPHER_REQUEST_ON_STACK(subreq, child);
> +
> +	if (unlikely(err == -EINPROGRESS))
> +		goto out;
> +
> +	skcipher_request_set_tfm(subreq, child);
> +	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
> +				      NULL, NULL);
> +	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
> +				   req->iv);
> +
> +	err = crypto_skcipher_decrypt(subreq);
> +	skcipher_request_zero(subreq);
> +
> +	req->base.complete = rctx->complete;
> +
> +out:
> +	cryptd_skcipher_complete(req, err);
> +}

cryptd_skcipher_encrypt() and cryptd_skcipher_decrypt() are identical except for
whether crypto_skcipher_encrypt() or crypto_skcipher_decrypt() is used.  I
suggest having them wrap a function cryptd_skcipher_crypt() that takes in a
function pointer to crypto_skcipher_encrypt or crypto_skcipher_decrypt.
Alternatively a bool would be okay too.

Eric

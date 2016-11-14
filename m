From: Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH 4/16] crypto: xts - Convert to skcipher
Date: Sun, 13 Nov 2016 18:10:29 -0800
Message-ID: <20161114021029.GC4778@google.com>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tE7-00029P-L0@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35147 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcKNCKe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 21:10:34 -0500
Received: by mail-pf0-f179.google.com with SMTP id i88so25963051pfk.2
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 18:10:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <E1c5tE7-00029P-L0@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 13, 2016 at 07:45:35PM +0800, Herbert Xu wrote:
> +static int do_encrypt(struct skcipher_request *req, int err)
> +{
> +	struct rctx *rctx = skcipher_request_ctx(req);
> +	struct skcipher_request *subreq;
> +
> +	subreq = &rctx->subreq;
> +
> +	while (!err && rctx->left) {
> +		err = pre_crypt(req) ?:
> +		      crypto_skcipher_encrypt(subreq) ?:
> +		      post_crypt(req);
> +
> +		if (err == -EINPROGRESS ||
> +		    (err == -EBUSY &&
> +		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
> +			return err;
> +	}
> +
> +	exit_crypt(req);
> +	return err;
> +}
> +
> +static void encrypt_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req = areq->data;
> +	struct skcipher_request *subreq;
> +	struct rctx *rctx;
> +
> +	rctx = skcipher_request_ctx(req);
> +	subreq = &rctx->subreq;
> +	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
> +
> +	err = do_encrypt(req, err ?: post_crypt(req));
> +	if (rctx->left)
> +		return;
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int encrypt(struct skcipher_request *req)
> +{
> +	return do_encrypt(req, init_crypt(req, encrypt_done));
> +}
> +
> +static int do_decrypt(struct skcipher_request *req, int err)
> +{
> +	struct rctx *rctx = skcipher_request_ctx(req);
> +	struct skcipher_request *subreq;
> +
> +	subreq = &rctx->subreq;
> +
> +	while (!err && rctx->left) {
> +		err = pre_crypt(req) ?:
> +		      crypto_skcipher_decrypt(subreq) ?:
> +		      post_crypt(req);
> +
> +		if (err == -EINPROGRESS ||
> +		    (err == -EBUSY &&
> +		     req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
> +			return err;
> +	}
> +
> +	exit_crypt(req);
> +	return err;
> +}
> +
> +static void decrypt_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req = areq->data;
> +	struct skcipher_request *subreq;
> +	struct rctx *rctx;
> +
> +	rctx = skcipher_request_ctx(req);
> +	subreq = &rctx->subreq;
> +	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
> +
> +	err = do_decrypt(req, err ?: post_crypt(req));
> +	if (rctx->left)
> +		return;
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int decrypt(struct skcipher_request *req)
> +{
> +	return do_decrypt(req, init_crypt(req, decrypt_done));
>  }

There's duplicated code for encryption and decryption here.  AFAICS, the only
difference between XTS encryption and decryption is whether the block cipher is
used in encryption or decryption mode for the ECB step.  So I suggest storing a
function pointer in 'struct rctx' to either crypto_skcipher_encrypt or
crypto_skcipher_decrypt, then calling through it for the ECB step.  Then this
code can be shared.  In other words I'd like the top-level functions to look
like this:

static int encrypt(struct skcipher_request *req)
{
	struct rctx *rctx = skcipher_request_ctx(req);

	rctx->crypt = crypto_skcipher_encrypt;

	return do_crypt(req);
}

static int decrypt(struct skcipher_request *req)
{
	struct rctx *rctx = skcipher_request_ctx(req);

	rctx->crypt = crypto_skcipher_decrypt;

	return do_crypt(req);
}

I'm also wondering about the line which does
'subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;'.
Is the real intent of that to clear the CRYPTO_TFM_REQ_MAY_SLEEP flag because
the completion callback may be called in an atomic context, and if so shouldn't
it just clear that flag only, rather than all flags except
CRYPTO_TFM_REQ_MAY_BACKLOG?

> +	if (req->cryptlen > XTS_BUFFER_SIZE) {
> +		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
> +		rctx->ext = kmalloc(subreq->cryptlen, gfp);
> +	}

There's no check for failure to allocate the 'rctx->ext' memory.

> +	/* Alas we screwed up the naming so we have to mangle the
> +	 * cipher name.
> +	 */
> +	if (!strncmp(cipher_name, "ecb(", 4)) {
> +		unsigned len;
>  
> -	inst->alg.cra_ctxsize = sizeof(struct priv);
> +		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
> +		if (len < 2 || len >= sizeof(ctx->name))
> +			goto err_drop_spawn;
>  
> -	inst->alg.cra_init = init_tfm;
> -	inst->alg.cra_exit = exit_tfm;
> +		if (ctx->name[len - 1] != ')')
> +			goto err_drop_spawn;
>  
> -	inst->alg.cra_blkcipher.setkey = setkey;
> -	inst->alg.cra_blkcipher.encrypt = encrypt;
> -	inst->alg.cra_blkcipher.decrypt = decrypt;
> +		ctx->name[len - 1] = 0;
>  
> -out_put_alg:
> -	crypto_mod_put(alg);
> -	return inst;
> -}
> +		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> +			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME)
> +			return -ENAMETOOLONG;
> +	} else
> +		goto err_drop_spawn;

There should be a line which sets 'err = -EINVAL' before here.

> +static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
>  {
> -	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
> -	struct blkcipher_walk w;
> +	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	struct rctx *rctx = skcipher_request_ctx(req);
> +	struct skcipher_request *subreq;
> +	be128 *buf;
...
> +	/* calculate first value of T */
> +	buf = rctx->ext ?: rctx->buf;
> +	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> +
> +	return 0;

The 'buf' variable is assigned to but never used.

>  int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
> @@ -233,112 +416,167 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
>  }
>  EXPORT_SYMBOL_GPL(xts_crypt);

xts_crypt() is still here.  Is there a plan for its removal, since now the
generic XTS algorithm can use an accelerated ECB algorithm?

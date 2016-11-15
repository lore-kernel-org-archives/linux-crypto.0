From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2 PATCH 4/16] crypto: xts - Convert to skcipher
Date: Tue, 15 Nov 2016 22:41:41 +0800
Message-ID: <20161115144141.GA20497@gondor.apana.org.au>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tE7-00029P-L0@gondolin.me.apana.org.au>
 <20161114021029.GC4778@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41496 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753207AbcKOOmG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 09:42:06 -0500
Content-Disposition: inline
In-Reply-To: <20161114021029.GC4778@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 13, 2016 at 06:10:29PM -0800, Eric Biggers wrote:
>
> There's duplicated code for encryption and decryption here.  AFAICS, the only
> difference between XTS encryption and decryption is whether the block cipher is
> used in encryption or decryption mode for the ECB step.  So I suggest storing a
> function pointer in 'struct rctx' to either crypto_skcipher_encrypt or
> crypto_skcipher_decrypt, then calling through it for the ECB step.  Then this
> code can be shared.  In other words I'd like the top-level functions to look
> like this:

I'm all for getting rid of duplicate code.  However, I'd also
prefer to do it without using indirect function calls in this
case.

> I'm also wondering about the line which does
> 'subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;'.
> Is the real intent of that to clear the CRYPTO_TFM_REQ_MAY_SLEEP flag because
> the completion callback may be called in an atomic context, and if so shouldn't
> it just clear that flag only, rather than all flags except
> CRYPTO_TFM_REQ_MAY_BACKLOG?

The intent here is that this is the only flag that we want to
pass along.  Of course in the absence of any other flags it's a
moot point.

> > +	if (req->cryptlen > XTS_BUFFER_SIZE) {
> > +		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
> > +		rctx->ext = kmalloc(subreq->cryptlen, gfp);
> > +	}
> 
> There's no check for failure to allocate the 'rctx->ext' memory.

The code is supposed to handle a NULL rctx->ext gracefully.  Did
you find a spot where it is used without checking?

> > +		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> > +			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME)
> > +			return -ENAMETOOLONG;
> > +	} else
> > +		goto err_drop_spawn;
> 
> There should be a line which sets 'err = -EINVAL' before here.

Indeed.  Fixed here as well as in lrw.

> > +static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
> >  {
> > -	struct priv *ctx = crypto_blkcipher_ctx(desc->tfm);
> > -	struct blkcipher_walk w;
> > +	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> > +	struct rctx *rctx = skcipher_request_ctx(req);
> > +	struct skcipher_request *subreq;
> > +	be128 *buf;
> ...
> > +	/* calculate first value of T */
> > +	buf = rctx->ext ?: rctx->buf;
> > +	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> > +
> > +	return 0;
> 
> The 'buf' variable is assigned to but never used.

OK, deleted.

> >  int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
> > @@ -233,112 +416,167 @@ int xts_crypt(struct blkcipher_desc *desc, struct scatterlist *sdst,
> >  }
> >  EXPORT_SYMBOL_GPL(xts_crypt);
> 
> xts_crypt() is still here.  Is there a plan for its removal, since now the
> generic XTS algorithm can use an accelerated ECB algorithm?

It will be removed once all the arch code that uses it are converted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/16] crypto: skcipher - Add skcipher walk interface
Date: Wed, 2 Nov 2016 13:54:20 -0700
Message-ID: <20161102205420.GA17645@google.com>
References: <20161101231648.GA15967@gondor.apana.org.au>
 <E1c1iKc-0004Av-CW@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34682 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755198AbcKBUyX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 16:54:23 -0400
Received: by mail-pf0-f180.google.com with SMTP id n85so17872148pfi.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 13:54:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <E1c1iKc-0004Av-CW@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, just a few preliminary comments.  I haven't made it through
everything yet.

On Wed, Nov 02, 2016 at 07:19:02AM +0800, Herbert Xu wrote:
> +static int skcipher_walk_first(struct skcipher_walk *walk)
> +{
> +	if (WARN_ON_ONCE(in_irq()))
> +		return -EDEADLK;
> +
> +	walk->nbytes = walk->total;
> +	if (unlikely(!walk->total))
> +		return 0;
> +
> +	walk->buffer = NULL;
> +	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
> +		int err = skcipher_copy_iv(walk);
> +		if (err)
> +			return err;
> +	}
> +
> +	walk->page = NULL;
> +
> +	return skcipher_walk_next(walk);
> +}

I think the case where skcipher_copy_iv() fails may be handled incorrectly.
Wouldn't it need to set walk.nbytes to 0 so as to not confuse callers which
expect that behavior?  Or maybe it should be calling skcipher_walk_done().

> +static int skcipher_walk_skcipher(struct skcipher_walk *walk,
> +				  struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +
> +	scatterwalk_start(&walk->in, req->src);
> +	scatterwalk_start(&walk->out, req->dst);
> +
> +	walk->in.sg = req->src;
> +	walk->out.sg = req->dst;

Setting walk->in.sg and walk->out.sg is redundant with the scatterwalk_start()
calls.

> +int skcipher_walk_virt(struct skcipher_walk *walk,
> +		       struct skcipher_request *req, bool atomic)
> +{
> +	int err;
> +
> +	walk->flags &= ~SKCIPHER_WALK_PHYS;
> +
> +	err = skcipher_walk_skcipher(walk, req);
> +
> +	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
> +
> +	return err;
> +}

This gets called with uninitialized 'walk.flags'.  This was somewhat of a
theoretical problem with the old blkcipher_walk code but it looks like now it
will interact badly with the new SKCIPHER_WALK_SLEEP flag.  As far as I can see,
whether the flag will end up set or not can depend on the uninitialized value.
It would be nice if this problem could be avoided entirely be setting flags=0.

I'm also wondering about the choice to not look at 'atomic' until after the call
to skcipher_walk_skcipher().  Wouldn't this mean that the choice of 'atomic'
would not be respected in e.g. the kmalloc() in skcipher_copy_iv()?

> +int skcipher_walk_async(struct skcipher_walk *walk,
> +			struct skcipher_request *req)
> +{
> +	walk->flags |= SKCIPHER_WALK_PHYS;
> +
> +	INIT_LIST_HEAD(&walk->buffers);
> +
> +	return skcipher_walk_skcipher(walk, req);
> +}
> +EXPORT_SYMBOL_GPL(skcipher_walk_async);

I don't see any users of the "async" walking being introduced; are some planned?

Eric

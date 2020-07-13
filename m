Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F46C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 17:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F32206F0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594660248;
	bh=Gq7P0ezKdAPCwXTJpV5pyWgq7fAadI0Wl66w3zsFkbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EDNSdg5yQy5ecgSqQec/ExWQ57wQcyZK8zJgHmuxd6KOR+FnQMyw1y5WVrwKqfX3J
	 6bmZrhnSTBa7q29DHZtt2ThAVk39y7Hj8Kz+44PUwuUaOXTlCXD/voSmlENh++gtsC
	 K6TutsnSVHnbaZp430MizyIRc2XQpXocuV0tAc80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgGMRKr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgGMRKr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 13:10:47 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7124A20663;
        Mon, 13 Jul 2020 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594660246;
        bh=Gq7P0ezKdAPCwXTJpV5pyWgq7fAadI0Wl66w3zsFkbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEQGa8PoLozTle5xRZ8pkUR8spv1i3xJTKCx6fSrXI28NmkKcZTNxR2DFK8hSNAft
         vsN4b6rmB5jSzwpxe9BXeJCNY9J3vaYKeqQJOHbdtc7SrJHD8F8rZ7AS1m9c9rQNId
         PRjiO9Su97HhFiIZfP/CTWiUHt6tSHQqSb71pxx0=
Date:   Mon, 13 Jul 2020 10:10:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Elena Petrova <lenaptr@google.com>
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/1] crypto: af_alg - add extra parameters for DRBG
 interface
Message-ID: <20200713171045.GA722906@gmail.com>
References: <20200713164857.1031117-1-lenaptr@google.com>
 <20200713164857.1031117-2-lenaptr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713164857.1031117-2-lenaptr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Just some bike-shedding:

On Mon, Jul 13, 2020 at 05:48:57PM +0100, Elena Petrova wrote:
> Extending the userspace RNG interface:
>   1. adding ALG_SET_DRBG_ENTROPY setsockopt option for entropy input;
>   2. using sendmsg syscall for specifying the additional data.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>

A cover letter shouldn't really be used for a single patch.
Just put the details here in the commit message.

> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 087c0ad09d38..c3d1667db367 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -53,8 +53,24 @@ struct rng_ctx {
>  #define MAXSIZE 128
>  	unsigned int len;
>  	struct crypto_rng *drng;
> +	u8 *addtl;
> +	size_t addtl_len;
>  };
>  
> +struct rng_parent_ctx {
> +	struct crypto_rng *drng;
> +	u8 *entropy;
> +};
> +
> +static void reset_addtl(struct rng_ctx *ctx)
> +{
> +	if (ctx->addtl) {
> +		kzfree(ctx->addtl);
> +		ctx->addtl = NULL;
> +	}
> +	ctx->addtl_len = 0;
> +}

It's recommended to prefix function names.  So, reset_addtl => rng_reset_addtl.

> +static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> +{
> +	int err;
> +	struct alg_sock *ask = alg_sk(sock->sk);
> +	struct rng_ctx *ctx = ask->private;
> +
> +	reset_addtl(ctx);
> +	ctx->addtl = kzalloc(len, GFP_KERNEL);
> +	if (!ctx->addtl)
> +		return -ENOMEM;

Shouldn't the length be limited here?

Also, kmalloc would be sufficient since the memcpy_from_msg() immediately below
initializes the memory.

> +
> +	err = memcpy_from_msg(ctx->addtl, msg, len);
> +	if (err) {
> +		reset_addtl(ctx);
> +		return err;
> +	}
> +	ctx->addtl_len = len;
> +
> +	return 0;
> +}

>  static void *rng_bind(const char *name, u32 type, u32 mask)
>  {
> -	return crypto_alloc_rng(name, type, mask);
> +	struct rng_parent_ctx *pctx;
> +	void *err_ptr;
> +
> +	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
> +	if (!pctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pctx->drng = crypto_alloc_rng(name, type, mask);
> +	if (!IS_ERR(pctx->drng))
> +		return pctx;
> +
> +	err_ptr = pctx->drng;
> +	kfree(pctx);
> +	return err_ptr;
>  }

The error handling here is weird.  It would be more conventional to do something
like:

static void *rng_bind(const char *name, u32 type, u32 mask)
{
	struct rng_parent_ctx *pctx;
	struct crypto_rng *rng;

	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
	if (!pctx)
		return ERR_PTR(-ENOMEM);

	rng = crypto_alloc_rng(name, type, mask);
	if (IS_ERR(rng)) {
		kfree(pctx);
		return ERR_CAST(rng);
	}

	pctx->drng = rng;
	return pctx;
}

>  
>  static void rng_release(void *private)
>  {
> -	crypto_free_rng(private);
> +	struct rng_parent_ctx *pctx = private;
> +	if (unlikely(!pctx))
> +		return;

There should be a blank line between declarations and statements.

> +	crypto_free_rng(pctx->drng);
> +	if (pctx->entropy)
> +		kzfree(pctx->entropy);

No need to check for NULL before calling kzfree().

> +static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
> +{
> +	struct rng_parent_ctx *pctx = private;
> +	u8 *kentropy = NULL;
> +
> +	if (pctx->entropy)
> +		return -EINVAL;
> +
> +	if (entropy && len) {

Best to check just 'len', so that users get an error as expected if they
accidentally pass entry=NULL len=nonzero.

> +		kentropy = kzalloc(len, GFP_KERNEL);
> +		if (!kentropy)
> +			return -ENOMEM;
> +		if (copy_from_user(kentropy, entropy, len)) {
> +			kzfree(kentropy);
> +			return -EFAULT;
> +		}

This can use memdup_user().  Also, should there be a length limit?

> +	}
> +
> +	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> +	pctx->entropy = kentropy;

pctx->entropy could just be a bool 'has_entropy', right?  The actual value
doesn't need to be saved.

- Eric

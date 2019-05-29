Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B934C28CC0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 19:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1223F24119
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559159718;
	bh=oKIO8KHJNy76KLf2vqlbbpVQteGYBCiP2fF+2FS05w0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DRnL+MUl+z6wVMA0j9WbzStIAJK600Be0czs8W5PUzUcjfDjFmUkf7OwchArK0IhE
	 pm5N/hr9WvyPbDK2zovtTUvA6+QLQZQenA3ic5NnkPNnE67slBLq66QXFwQNbOn3wf
	 QXskmvAjhDKsYh/H8Vb1gskIANv9M6TDIhCV77Zg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfE2TzR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 15:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2TzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 15:55:16 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF4524118;
        Wed, 29 May 2019 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559159715;
        bh=oKIO8KHJNy76KLf2vqlbbpVQteGYBCiP2fF+2FS05w0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hrgWqUzkaxrCENYVuwlxOZao8FUQ6A+l9RLQesbyuzGb45vd+6PX9jO4QVndFYdC1
         ONzHhJFTkrD1iMkAxULT3+GDhQFwg1eaew7HACCdyLw0qYwobhfr2BmQajl+o2oQh9
         UyKpmJ7u5qUR94kA9isReZHrAhMRN5q35VQMHCdI=
Date:   Wed, 29 May 2019 12:55:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH v3] crypto: xxhash - Implement xxhash support
Message-ID: <20190529195512.GA141639@gmail.com>
References: <20190529154826.12147-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529154826.12147-1-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Nikolay, some more comments from another read through.  Sorry for not
noticing these in v2.

On Wed, May 29, 2019 at 06:48:26PM +0300, Nikolay Borisov wrote:
> +static int xxhash64_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct xxhash64_desc_ctx *tctx = shash_desc_ctx(desc);

This variable should be named 'dctx' (for desc_ctx), not 'tctx' (for tfm_ctx).

> +
> +	xxh64_update(&tctx->xxhstate, data, length);
> +
> +	return 0;
> +}

xxh64_update() has a return value (0 or -errno) which is not being checked,
which at first glance seems to be a bug.

However, it only returns an error in this case:

        if (input == NULL)
                return -EINVAL;

But data=NULL, length=0 are valid parameters to xxhash64_update(), so if you did
check the return value, xxhash64_update() would break.  So it's fine as-is.

However, if anyone changed xxh64_update() to an error in any other case,
xxhash64_update() would break since it ignores the error.

I suggest avoiding this complexity around error codes by changing xxh64_update()
to return void.  It can be a separate patch.

> +
> +static int xxhash64_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
> +

For consistency it should be 'dctx' here too.

> +	put_unaligned_le64(xxh64_digest(&ctx->xxhstate), out);
> +
> +	return 0;
> +}
> +

> +static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	xxhash64_update(desc, data, len);
> +	xxhash64_final(desc, out);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length, u8 *out)
> +{
> +	xxhash64_init(desc);
> +	return xxhash64_finup(desc, data, length, out);
> +}
> +

The purpose of the ->finup() and ->digest() methods is to allow the algorithm to
work more efficiently than it could if ->init(), ->update(), and ->final() were
called separately.  So, implementing them on top of xxhash64_init(),
xxhash64_update(), and xxhash64_final() is mostly pointless.

lib/xxhash.c already provides a function xxh64() which does a digest in one
step, so that should be used to implement xxhash64_digest():

static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
			 unsigned int length, u8 *out)
{
	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);

	put_unaligned_le64(xxh64(data, length, tctx->seed), out);

	return 0;
}

I suggest just deleting xxhash64_finup().

> +static struct shash_alg alg = {
> +	.digestsize	= XXHASH64_DIGEST_SIZE,
> +	.setkey		= xxhash64_setkey,
> +	.init		= xxhash64_init,
> +	.update		= xxhash64_update,
> +	.final		= xxhash64_final,
> +	.finup		= xxhash64_finup,
> +	.digest		= xxhash64_digest,
> +	.descsize	= sizeof(struct xxhash64_desc_ctx),
> +	.base		= {
> +		.cra_name	 = "xxhash64",
> +		.cra_driver_name = "xxhash64-generic",
> +		.cra_priority	 = 100,
> +		.cra_flags	 = CRYPTO_ALG_OPTIONAL_KEY,
> +		.cra_blocksize	 = XXHASH64_BLOCK_SIZE,
> +		.cra_ctxsize	 = sizeof(struct xxhash64_tfm_ctx),
> +		.cra_module	 = THIS_MODULE,
> +	}
> +};

Note that because .export() and .import() aren't set, if someone calls
crypto_shash_export() and crypto_shash_import() on an xxhash64 descriptor, the
crypto API will export and import the state by memcpy().

That's perfectly fine, but it also means that the xxh64_copy_state() function
won't be called.  Since it exists, one might assume that all state copies go
through that function.  But it's actually pointless as it just does a memcpy, so
I suggest removing it.  (As a separate patch, which you don't necessarily have
to do now.  BTW, another thing that should be cleaned up is the random
unnecessary local variable in xxh32_reset() and xxh64_reset()...)

Thanks,

- Eric

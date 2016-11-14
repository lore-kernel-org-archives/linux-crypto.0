From: Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH 1/16] crypto: skcipher - Add skcipher walk interface
Date: Sun, 13 Nov 2016 17:35:48 -0800
Message-ID: <20161114013548.GA4778@google.com>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tE4-00028Y-BC@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35829 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcKNBmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 20:42:03 -0500
Received: by mail-pg0-f50.google.com with SMTP id p66so47465191pga.2
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 17:42:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <E1c5tE4-00028Y-BC@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Sun, Nov 13, 2016 at 07:45:32PM +0800, Herbert Xu wrote:
> +int skcipher_walk_done(struct skcipher_walk *walk, int err)
> +{
> +	unsigned int nbytes = 0;
> +	unsigned int n = 0;
> +
> +	if (likely(err >= 0)) {
> +		n = walk->nbytes - err;
> +		nbytes = walk->total - n;
> +	}
> +
> +	if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
> +				    SKCIPHER_WALK_SLOW |
> +				    SKCIPHER_WALK_COPY |
> +				    SKCIPHER_WALK_DIFF)))) {
> +unmap_src:
> +		skcipher_unmap_src(walk);

Isn't it wrong to unmap the buffers when err < 0?  They won't have been mapped
yet, e.g. if the 'skcipher_walk_done(walk, -EINVAL)' case is hit.

> +	/* Short-circuit for the common/fast path. */
> +	if (!(((unsigned long)walk->iv ^ (unsigned long)walk->oiv) |
> +	     ((unsigned long)walk->buffer ^ (unsigned long)walk->page) |
> +	     (unsigned long)walk->page))
> +		goto out;

This is really saying that the IV wasn't copied and that walk->buffer and
walk->page are both NULL.  But if walk->buffer is NULL then the IV wasn't
copied.  So this can be simplified to:

	if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
		goto out;

> +int skcipher_walk_next(struct skcipher_walk *walk)
> +{

Shouldn't this be static?  There's even a static declaration earlier in the
file.

> +static int skcipher_next_slow(struct skcipher_walk *walk)
> +{
> +	bool phys = walk->flags & SKCIPHER_WALK_PHYS;
> +	unsigned alignmask = walk->alignmask;
> +	unsigned bsize = walk->chunksize;
...
> +	walk->nbytes = bsize;

skcipher_next_slow() is always setting up 'chunksize' bytes to be processed.
Isn't this wrong in the 'blocksize < chunksize' case because fewer than
'chunksize' bytes may need to be processed?

> +static inline void *skcipher_map(struct scatter_walk *walk)
> +{
> +	struct page *page = scatterwalk_page(walk);
> +
> +	return (PageHighMem(page) ? kmap_atomic(page) : page_address(page)) +
> +	       offset_in_page(walk->offset);
> +}

Is the PageHighMem() optimization really worthwhile?  It will skip kmap_atomic()
and hence preempt_disable() for non-highmem pages, so it may make it harder to
find bugs where users are sleeping when they shouldn't be.  It also seems
inconsistent that skcipher_map() will do this optimization but scatterwalk_map()
won't.

> +		if (!walk->page) {
> +			gfp_t gfp = skcipher_walk_gfp(walk);
> +
> +			walk->page = (void *)__get_free_page(gfp);
> +			if (!walk->page)
> +				goto slow_path;
> +		}
> +
> +		walk->nbytes = min_t(unsigned, n,
> +				     PAGE_SIZE - offset_in_page(walk->page));

walk->page will be page-aligned, so there's no need for offset_in_page().  Also,
'n' has already been clamped to at most one page.  So AFAICS this can simply be
'walk->nbytes = n;'.

> +int skcipher_walk_done(struct skcipher_walk *walk, int err);
...
> +void skcipher_walk_complete(struct skcipher_walk *walk, int err);

The naming is confusing: "done" vs. "complete".  They can easily be mixed up.
Would it make more sense to have something with "async" in the name for the
second one, like skcipher_walk_async_done()?

Eric

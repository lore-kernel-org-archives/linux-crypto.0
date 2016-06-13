From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 2/8] crypto: add driver-side scomp interface
Date: Mon, 13 Jun 2016 16:56:12 +0800
Message-ID: <20160613085612.GA7333@gondor.apana.org.au>
References: <1465373818-29720-1-git-send-email-giovanni.cabiddu@intel.com>
 <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41660 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161007AbcFMI4U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 04:56:20 -0400
Content-Disposition: inline
In-Reply-To: <1465373818-29720-3-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 09:16:52AM +0100, Giovanni Cabiddu wrote:
>
> +static void *scomp_map(struct scatterlist *sg, unsigned int len,
> +		       gfp_t gfp_flags)
> +{
> +	void *buf;
> +
> +	if (sg_is_last(sg))
> +		return kmap_atomic(sg_page(sg)) + sg->offset;

This doesn't work, because kmap_atomic maps a single page only
bug an SG entry can be a super-page, e.g., a set of contiguous
pages.

> +	buf = kmalloc(len, gfp_flags);

The backup path is also very unlikely to work because we'll be
hitting this with 64K sizes and this just won't work with a 4K
page size.

So up until now we've getting around this 64K issue with vmalloc,
and then we try to conserve the precious vmalloc resource by using
per-cpu allocation.

This totally breaks down once you go to DMA, where an SG list is
required.  Unfortunately, this means that there is no easy way
to linearise the data for our software implementations.

There is no easy way out I'm afraid.  I think we'll have to bite
the bullet and refit our software algos so that they handle SG
lists.

Not only will this solve the problem at hand, it'll also mean that
acomp users will never have to do vmalloc so it's a win-win.  It
also means that we won't need the scomp interface at all.

This does bring up another question of who should be allocating the
output memory.  Up until now it has been up to the user to do so.
However, if our algos can actually handle SG lists then I think it
should be fairly easy to make them do the allocation instead.  What
do you think?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scatterwalk_copychunks() fails to advance through scatterlist
Date: Tue, 20 Mar 2007 16:16:56 +1100
Message-ID: <20070320051656.GA17711@gondor.apana.org.au>
References: <20070319235508.GH29272@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nfsv4@linux-nfs.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2093 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934017AbXCTFRI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2007 01:17:08 -0400
Content-Disposition: inline
In-Reply-To: <20070319235508.GH29272@fieldses.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 19, 2007 at 07:55:08PM -0400, J. Bruce Fields wrote:
> In the loop in scatterwalk_copychunks(), if walk->offset is zero,
> then scatterwalk_pagedone rounds that up to the nearest page boundary:
> 
> 		walk->offset += PAGE_SIZE - 1;
> 		walk->offset &= PAGE_MASK;
> 
> which is a no-op in this case, so we don't advance to the next element
> of the scatterlist array:
> 
> 		if (walk->offset >= walk->sg->offset + walk->sg->length)
> 			scatterwalk_start(walk, sg_next(walk->sg));
> 
> and we end up copying the same data twice.

Thanks for the patch.  However I still have a question as to why
this is happening.

As far as I can see scatterwalk_copychunks is only called in two
places.  In both spots it only processes one block of data.  Since
we set the maximum block size to PAGE_SIZE/8 I don't see how you
can get an offset of zero and still roll over to the next page
in scatterwalk_copychunks.

So perhaps the bug is elsewhere in the original patch?

Your patch looks like a good clean-up anyway but I just wanted to
make sure that I understand what the problem is first.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

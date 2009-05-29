From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: add buffer overflow checks to testmgr
Date: Sat, 30 May 2009 08:10:55 +1000
Message-ID: <20090529221055.GA17957@gondor.apana.org.au>
References: <200905291132.55848.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49038 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbZE2WK4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 18:10:56 -0400
Content-Disposition: inline
In-Reply-To: <200905291132.55848.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2009 at 11:32:54AM -0400, Jarod Wilson wrote:
> At present, its entirely possible to add a test vector to testmgr with
> an input longer than a page in length w/o specifying a .np option, and
> overflow the page of memory allocated to {a,}xbuf[0], silently
> corrupting memory. I know, because I've accidentally done it. :)
> 
> While this doesn't currently happen in practice w/the existing code,
> due to all !np vectors being less than a 4k page in length (and the
> page allocation loop often returns contiguous pages anyway), explicit
> checks or a way to remove the 4k limit would be a good idea.
> 
> A few ways to fix and/or work around this:
> 
> 1) allocate some larger guaranteed contiguous buffers using
> __get_free_pages() or kmalloc and use them in the !np case
> 
> 2) catch the > PAGE_SIZE && !np case and then do things similar to how
> they are done in the np case
> 
> 3) catch the > PAGE_SIZE && !np case and simply exit with an error
> 
> Since there currently aren't any test vectors that are actually larger
> than a page and not tagged np, option 1 seems like a waste of memory
> and option 2 sounds like unnecessary complexity, so I'd offer up
> option 3 as the most viable alternative right now.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

I just posted exactly the same thing yesterday :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

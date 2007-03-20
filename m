From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scatterwalk_copychunks() fails to advance through scatterlist
Date: Wed, 21 Mar 2007 09:04:43 +1100
Message-ID: <20070320220443.GA25008@gondor.apana.org.au>
References: <20070319235508.GH29272@fieldses.org> <20070320051656.GA17711@gondor.apana.org.au> <20070320141614.GA12165@fieldses.org> <20070320205421.GA23929@gondor.apana.org.au> <20070320211751.GC16930@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nfsv4@linux-nfs.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2600 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbXCTWEq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2007 18:04:46 -0400
Content-Disposition: inline
In-Reply-To: <20070320211751.GC16930@fieldses.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 20, 2007 at 05:17:51PM -0400, J. Bruce Fields wrote:
> 
> By the way, the commit that I believe introduced this regression did two
> or three different things at once--I spent some time staring at it and
> can't say I really understand the change.  That's probably just me!  But
> would it be possible to split up these patches fine enough that people
> inexperienced with this code would have a better chance of understanding
> what's going on?

Good point, I'll make sure they're more granular in future.

> (And did the crypto testing module use to have some tests for buffers
> that were fragmented in odd ways, or was I imagining that?  I'd be happy
> to help come up with some test cases if it'd be useful.)

It does test fragments but it doesn't do it in the way you
suggested.  In particular, the fragments probably won't be
starting off at a page boundary.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

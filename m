From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Wed, 14 Nov 2007 22:22:53 +0800
Message-ID: <20071114142253.GA15201@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3021 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754456AbXKNOWz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2007 09:22:55 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IsJ8o-0000ua-2f
	for <linux-crypto@vger.kernel.org>; Thu, 15 Nov 2007 01:22:54 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IsJ8n-0003yp-00
	for <linux-crypto@vger.kernel.org>; Wed, 14 Nov 2007 22:22:53 +0800
Content-Disposition: inline
In-Reply-To: <20071113231132.GA10680@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 14, 2007 at 12:11:32AM +0100, Sebastian Siewior wrote:
> 
> and everything goes back to normal. I checked walk.iv and it doesn't
> change, it is still the same pointer. Do you free the walk.iv in the
> meantime or is there another BUG I don't see? The IV length is 16 bytes.
> Currently I'm lost ...

Indeed the last call to blkcipher_walk_done will free the IV if
we had to copy it due to an alignment mismatch.  Since geode has
an alignment of 16 bytes, that's almost a given.

You could copy from/to desc->info instead which would solve the
problem.

However, why does op->iv exist at all? Surely we can just use
walk->iv directly and the problem goes away completely?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Wed, 27 Jun 2012 14:52:47 +0800
Message-ID: <20120627065247.GE22920@gondor.apana.org.au>
References: <20120626161346.GB6509@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50451 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811Ab2F0Gwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 02:52:53 -0400
Content-Disposition: inline
In-Reply-To: <20120626161346.GB6509@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:13:46PM +0200, Sebastian Andrzej Siewior wrote:
> Since commit ce6dd368 ("crypto: arc4 - improve performance by adding
> ecb(arc4)) we need to pull in a blkcipher.
> 
> |ERROR: "crypto_blkcipher_type" [crypto/arc4.ko] undefined!
> |ERROR: "blkcipher_walk_done" [crypto/arc4.ko] undefined!
> |ERROR: "blkcipher_walk_virt" [crypto/arc4.ko] undefined!
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks!

> On a side note: do we pull in the blkcipher block mode for each cipher now to
> gain some extra performance like the openssl project? I was under the
> impression that is in general not worth it.

You mean normal block ciphers? Does it really make that much
of a difference?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

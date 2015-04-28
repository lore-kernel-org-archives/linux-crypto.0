From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Tue, 28 Apr 2015 09:12:32 +0800
Message-ID: <20150428011232.GC28820@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <3407264.GJDOVGtEDe@myon.chronox.de>
 <20150427082935.GA21691@gondor.apana.org.au>
 <3344357.7kIb8DDjMB@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48934 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbD1BMg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 21:12:36 -0400
Content-Disposition: inline
In-Reply-To: <3344357.7kIb8DDjMB@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 27, 2015 at 04:58:51PM +0200, Stephan Mueller wrote:
>
> This memcmp implies that the final block->A from the decrypt is memcpy'ed to 
> req->creq.info. I wanted to avoid any additional memcpy calls to not hurt 
> performance even more.

I was hoping to directly use req->creq.info in the calculation.
The blkcipher_walk code would handle the alignment for it.  But
obviously the backward walking issue threw a spanner in the works.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

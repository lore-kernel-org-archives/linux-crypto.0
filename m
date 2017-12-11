From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Mon, 11 Dec 2017 22:13:57 +1100
Message-ID: <20171211111357.GC8823@gondor.apana.org.au>
References: <20171128090518.12469-1-antoine.tenart@free-electrons.com>
 <20171128090518.12469-4-antoine.tenart@free-electrons.com>
 <20171211072946.GA8823@gondor.apana.org.au>
 <20171211074957.GC25616@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43846 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdLKLOT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:14:19 -0500
Content-Disposition: inline
In-Reply-To: <20171211074957.GC25616@kwain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 08:49:57AM +0100, Antoine Tenart wrote:
>
> So this patch is indeed fixing an issue, which should probably not be
> there in the first place. I guess you recommend using a buffer local to
> the driver instead, and only update areq->request on completion (final).

That's one way to do it.  Ideally you'd only use the local buffer
for the non-final case so that the final case just does the DMA to
the final destination.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - do not parse the dma mask from dt
Date: Tue, 18 Jul 2017 18:35:00 +0800
Message-ID: <20170718103500.GA6479@gondor.apana.org.au>
References: <20170623140525.360-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33136 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdGRKfe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:35:34 -0400
Content-Disposition: inline
In-Reply-To: <20170623140525.360-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:05:25PM +0200, Antoine Tenart wrote:
> Remove the dma mask parsing from dt as this should not be encoded into
> the engine device tree node. Keep the fallback value for now, which
> should work for the boards already supported upstream.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

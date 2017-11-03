From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell - Switch cipher algs to the skcipher
 interface
Date: Fri, 3 Nov 2017 22:24:13 +0800
Message-ID: <20171103142413.GJ9011@gondor.apana.org.au>
References: <20171013133032.6025-1-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38162 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdKCOYi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 10:24:38 -0400
Content-Disposition: inline
In-Reply-To: <20171013133032.6025-1-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 13, 2017 at 03:30:32PM +0200, Boris Brezillon wrote:
> crypto_alg is not supposed to be directly implemented by crypto engine
> driver. Drivers should instead implement specialized interfaces like
> ahash_alg or skcipher_alg.
> 
> Migrate to all cipher algorithms to the skcipher_alg interface. While at
> it, get rid of all references to ablkcipher including in internal struct
> or function names.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

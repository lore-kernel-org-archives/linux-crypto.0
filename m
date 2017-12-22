From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/17] crypto: inside-secure - various improvements
Date: Fri, 22 Dec 2017 20:11:54 +1100
Message-ID: <20171222091154.GJ32542@gondor.apana.org.au>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46530 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965461AbdLVJOp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 04:14:45 -0500
Content-Disposition: inline
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 14, 2017 at 03:26:42PM +0100, Antoine Tenart wrote:
> Hi Herbert,
> 
> This series depends on the previous one, "crypto: inside-secure - set of
> fixes"[1]. The series contains various improvements to the Inside Secure
> SafeXcel driver, which are bundled in a single series to avoid any
> conflict.
> 
> - Patches 1-4 are cosmetic fixes (typo, more comments and dead code removal).
> - Patches 5-8 are small improvements, mostly to improve the invalidation
>   path.
> - Patches 9-15 improve the request processing in the driver, by moving
>   the requests dequeing into a workqueue and the result handling into a
>   threaded IRQ thread. Other small improvements are made in the same
>   direction.
> - Patches 16-17 introduce the support of another revision of this crypto
>   engine, similar to the one already supported. This crypto engine can be
>   found on Marvell boards. (The corresponding device tree patches will follow
>   once this series lands in).

Patches 1-16 applied.  If patch 17 needs to go through the crypto
tree please let me know.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

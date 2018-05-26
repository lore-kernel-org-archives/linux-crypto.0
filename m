From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - do not use memset on MMIO
Date: Sun, 27 May 2018 00:27:01 +0800
Message-ID: <20180526162701.ql2ryktszw2u6ic4@gondor.apana.org.au>
References: <20180517132214.23528-1-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: Antoine Tenart <antoine.tenart@bootlin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180517132214.23528-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 17, 2018 at 03:22:14PM +0200, Antoine Tenart wrote:
> This patch fixes the Inside Secure driver which uses a memtset() call to
> set an MMIO area from the cryptographic engine to 0. This is wrong as
> memset() isn't guaranteed to work on MMIO for many reasons. This led to
> kernel paging request panics in certain cases. Use memset_io() instead.
> 
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Reported-by: Ofer Heifetz <oferh@marvell.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

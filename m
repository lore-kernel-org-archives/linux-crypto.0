From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - initialize first_rdesc to make
 GCC happy
Date: Fri, 20 Jul 2018 13:55:22 +0800
Message-ID: <20180720055522.desdmpxm2o7hpiqs@gondor.apana.org.au>
References: <20180713154316.15689-1-antoine.tenart@bootlin.com>
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
In-Reply-To: <20180713154316.15689-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 13, 2018 at 05:43:16PM +0200, Antoine Tenart wrote:
> In the cipher safexcel_send_req function, GCC warns that
> first_rdesc may be used uninitialized. While this should never
> happen, this patch removes the warning by initializing this
> variable to NULL to make GCC happy.
> 
> This was reported by the kbuild test robot.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

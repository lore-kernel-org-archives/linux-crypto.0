From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-aes: fix error return code in
 omap_aes_probe()
Date: Tue, 18 Jul 2017 18:37:01 +0800
Message-ID: <20170718103701.GM6479@gondor.apana.org.au>
References: <20170630070054.GA16513@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170630070054.GA16513@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 30, 2017 at 02:00:54AM -0500, Gustavo A. R. Silva wrote:
> Propagate the return value of platform_get_irq on failure.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

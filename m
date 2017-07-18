From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: brcm: add NULL check on of_match_device() return
 value
Date: Tue, 18 Jul 2017 18:38:36 +0800
Message-ID: <20170718103836.GS6479@gondor.apana.org.au>
References: <20170707063333.GA18377@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@mebeddedor.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170707063333.GA18377@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 07, 2017 at 01:33:33AM -0500, Gustavo A. R. Silva wrote:
> Check return value from call to of_match_device()
> in order to prevent a NULL pointer dereference.
> 
> In case of NULL print error message and return -ENODEV
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

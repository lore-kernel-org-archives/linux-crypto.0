From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chelsio - Fix an error code in
 chcr_hash_dma_map()
Date: Wed, 29 Nov 2017 17:31:22 +1100
Message-ID: <20171129063122.GB21575@gondor.apana.org.au>
References: <20171109212543.6dpgzvtbhi4574wr@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harsh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40608 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbdK2GcA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:32:00 -0500
Content-Disposition: inline
In-Reply-To: <20171109212543.6dpgzvtbhi4574wr@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 12:25:43AM +0300, Dan Carpenter wrote:
> The dma_map_sg() function returns zero on error and positive values on
> success.  We want to return -ENOMEM on failure here and zero on success.
> 
> Fixes: 2f47d5804311 ("crypto: chelsio - Move DMA un/mapping to chcr from lld cxgb4 driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

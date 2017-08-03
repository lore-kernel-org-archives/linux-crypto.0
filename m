From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: brcm - Support more FlexRM rings than SPU
 engines.
Date: Thu, 3 Aug 2017 14:24:24 +0800
Message-ID: <20170803062424.GJ12039@gondor.apana.org.au>
References: <1500616059-32352-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        linux-crypto@vger.kernel.org, Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500616059-32352-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 21, 2017 at 11:17:39AM +0530, Raveendra Padasalagi wrote:
> Enhance code to generically support cases where DMA rings
> are greater than or equal to number of SPU engines.
> New hardware has underlying DMA engine-FlexRM with 32 rings
> which can be used to communicate to any of the available
> 10 SPU engines.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

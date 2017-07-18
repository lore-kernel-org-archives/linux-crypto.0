From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: brcm - remove BCM_PDC_MBOX dependency in Kconfig
Date: Tue, 18 Jul 2017 18:40:06 +0800
Message-ID: <20170718104006.GV6479@gondor.apana.org.au>
References: <1499768406-8342-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>, linux-crypto@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499768406-8342-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 11, 2017 at 03:50:06PM +0530, Raveendra Padasalagi wrote:
> SPU driver is dependent on generic MAILBOX API's to
> communicate with underlying DMA engine driver.
> 
> So this patch removes BCM_PDC_MBOX "depends on" for SPU driver
> in Kconfig and adds MAILBOX as dependent module.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

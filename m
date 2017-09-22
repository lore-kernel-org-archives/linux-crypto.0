From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: brcm - Explicity ACK mailbox message
Date: Fri, 22 Sep 2017 18:15:56 +0800
Message-ID: <20170922101556.GQ16270@gondor.apana.org.au>
References: <1503999490-14527-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        Anup Patel <anup.patel@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, stable@vger.kernel.org
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503999490-14527-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 29, 2017 at 03:08:10PM +0530, Raveendra Padasalagi wrote:
> Add support to explicity ACK mailbox message
> because after sending message we can know
> the send status via error attribute of brcm_message.
> 
> This is needed to support "txdone_ack" supported in
> mailbox controller driver.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Anup Patel <anup.patel@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

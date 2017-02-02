From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp: Fix DMA operations when IOMMU is enabled
Date: Thu, 2 Feb 2017 11:14:10 -0600
Message-ID: <13ad85ce-3012-da68-2478-e0ea00e49095@amd.com>
References: <20170127212845.27618.32169.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:17829
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751477AbdBBRPR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 12:15:17 -0500
In-Reply-To: <20170127212845.27618.32169.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/27/2017 03:28 PM, Gary R Hook wrote:
> An I/O page fault occurs when the IOMMU is enabled on a
> system that supports the v5 CCP.  DMA operations use a
> Request ID value that does not match what is expected by
> the IOMMU, resulting in the I/O page fault.  Setting the
> Request ID value to 0 corrects this issue.

Herbert,

Hoping to get some 4.10 love on this patch, plus one other. Do we see
a possibility at this late date?

>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-dev-v5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index e2ce819..612898b 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -959,7 +959,7 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
>  static void ccp5_config(struct ccp_device *ccp)
>  {
>  	/* Public side */
> -	iowrite32(0x00001249, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
> +	iowrite32(0x0, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
>  }
>
>  static void ccp5other_config(struct ccp_device *ccp)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer

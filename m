From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix return value check in
 ccp_dmaengine_register()
Date: Mon, 19 Sep 2016 10:09:21 -0500
Message-ID: <682aaa59-3367-b3e5-2748-b8a8fa7adcf7@amd.com>
References: <1474128082-14996-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:24288
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932392AbcISSmD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 14:42:03 -0400
In-Reply-To: <1474128082-14996-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/17/2016 11:01 AM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Fix the retrn value check which testing the wrong variable
> in ccp_dmaengine_register().
>
> Fixes: 58ea8abf4904 ("crypto: ccp - Register the CCP as a DMA resource")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/ccp/ccp-dmaengine.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> index 94f77b0..32f645e 100644
> --- a/drivers/crypto/ccp/ccp-dmaengine.c
> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> @@ -650,7 +650,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
>  	dma_desc_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
>  					     "%s-dmaengine-desc-cache",
>  					     ccp->name);
> -	if (!dma_cmd_cache_name)
> +	if (!dma_desc_cache_name)
>  		return -ENOMEM;
>  	ccp->dma_desc_cache = kmem_cache_create(dma_desc_cache_name,
>  						sizeof(struct ccp_dma_desc),
>

Acked-by: Gary R Hook <gary.hook@amd.com>

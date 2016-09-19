From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH -next] crypto: ccp - use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
Date: Mon, 19 Sep 2016 10:10:18 -0500
Message-ID: <1e67dca9-7f27-7001-947b-e0509d9646ac@amd.com>
References: <1473910084-31739-1-git-send-email-weiyj.lk@gmail.com>
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
Received: from mail-cys01nam02on0053.outbound.protection.outlook.com ([104.47.37.53]:4807
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932265AbcISQo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 12:44:56 -0400
In-Reply-To: <1473910084-31739-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/14/2016 10:28 PM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/ccp/ccp-dmaengine.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> index ded26f4..2e5a05c 100644
> --- a/drivers/crypto/ccp/ccp-dmaengine.c
> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> @@ -299,12 +299,10 @@ static struct ccp_dma_desc *ccp_alloc_dma_desc(struct ccp_dma_chan *chan,
>  {
>  	struct ccp_dma_desc *desc;
>
> -	desc = kmem_cache_alloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
> +	desc = kmem_cache_zalloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
>  	if (!desc)
>  		return NULL;
>
> -	memset(desc, 0, sizeof(*desc));
> -
>  	dma_async_tx_descriptor_init(&desc->tx_desc, &chan->dma_chan);
>  	desc->tx_desc.flags = flags;
>  	desc->tx_desc.tx_submit = ccp_tx_submit;
>

Acked-by: Gary R Hook <gary.hook@amd.com>

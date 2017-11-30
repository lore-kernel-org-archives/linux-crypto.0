From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Thu, 30 Nov 2017 10:19:26 +0100
Message-ID: <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36508 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdK3JTb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 04:19:31 -0500
In-reply-to: <20171128154236.19192-4-antoine.tenart@free-electrons.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,

On 28.11.2017 16:42, Antoine Tenart wrote:
> The patch fixes the ahash support by only updating the result buffer
> when provided. Otherwise the driver could crash with NULL pointer
> exceptions, because the ahash caller isn't required to supply a result
> buffer on all calls.

Can you point to bug crush report ?

> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 6135c9f5742c..424f4c5d4d25 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -150,7 +150,12 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
>  
>  	if (sreq->finish)
>  		result_sz = crypto_ahash_digestsize(ahash);
> -	memcpy(sreq->state, areq->result, result_sz);
> +
> +	/* The called isn't required to supply a result buffer. Updated it only
> +	 * when provided.
> +	 */
> +	if (areq->result)
> +		memcpy(sreq->state, areq->result, result_sz);
>  
>  	dma_unmap_sg(priv->dev, areq->src,
>  		     sg_nents_for_len(areq->src, areq->nbytes), DMA_TO_DEVICE);
> 

can the driver get request for final/finup/digest with null req->result ?
If yes (?), such checks can be done before any hardware processing, saving time,
for example:

int hash_final(struct ahash_request *areq)
{
	if (!areq->result)
		return -EINVAL;
	/* normal processing here */
}


-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

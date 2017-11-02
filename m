From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH] crypto: ccm - preserve the IV buffer
Date: Thu, 2 Nov 2017 16:03:24 +0200
Message-ID: <d43b27ea-17ce-57ec-86d8-449110283374@microchip.com>
References: <20171031144235.22818-1-romain.izard.pro@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Romain Izard <romain.izard.pro@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:59595 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdKBOD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 10:03:29 -0400
In-Reply-To: <20171031144235.22818-1-romain.izard.pro@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 10/31/2017 04:42 PM, Romain Izard wrote:
> The IV buffer used during CCM operations is used twice, during both the
> hashing step and the ciphering step.
> 
> When using a hardware accelerator that updates the contents of the IV
> buffer at the end of ciphering operations, the value will be modified.
> In the decryption case, the subsequent setup of the hashing algorithm
> will interpret the updated IV instead of the original value, which can
> lead to out-of-bounds writes.
> 
> Reuse the idata buffer, only used in the hashing step, to preserve the
> IV's value during the ciphering step in the decryption case.
> 
> Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
> ---
>   crypto/ccm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 1ce37ae0ce56..0a083342ec8c 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -363,7 +363,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>   	unsigned int cryptlen = req->cryptlen;
>   	u8 *authtag = pctx->auth_tag;
>   	u8 *odata = pctx->odata;
> -	u8 *iv = req->iv;
> +	u8 *iv = pctx->idata;
>   	int err;
>   
>   	cryptlen -= authsize;
> @@ -379,6 +379,8 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>   	if (req->src != req->dst)
>   		dst = pctx->dst;
>   
> +	memcpy(iv, req->iv, 16);
> +
>   	skcipher_request_set_tfm(skreq, ctx->ctr);
>   	skcipher_request_set_callback(skreq, pctx->flags,
>   				      crypto_ccm_decrypt_done, req);
> 

Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>

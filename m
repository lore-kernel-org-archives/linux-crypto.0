From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: artpec6: set correct iv size for gcm(aes)
Date: Tue, 12 Dec 2017 12:29:19 +0100
Message-ID: <20171212112919.GB6034@Red>
References: <20171212112020.2269-1-larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org,
        Lars Persson <larper@axis.com>
To: Lars Persson <lars.persson@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37890 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdLLL3W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 06:29:22 -0500
Received: by mail-wr0-f195.google.com with SMTP id o2so20766509wro.5
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 03:29:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171212112020.2269-1-larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 12, 2017 at 12:20:20PM +0100, Lars Persson wrote:
> The IV size should not include the 32 bit counter. Because we had the
> IV size set as 16 the transform only worked when the IV input was zero
> padded.
> 
> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
> Signed-off-by: Lars Persson <larper@axis.com>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index 456278440863..4de1996120e7 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -1934,7 +1934,7 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
>  
>  	memcpy(req_ctx->hw_ctx.J0, areq->iv, crypto_aead_ivsize(cipher));
>  	// The HW omits the initial increment of the counter field.
> -	crypto_inc(req_ctx->hw_ctx.J0+12, 4);
> +	memcpy(req_ctx->hw_ctx.J0+12, "\x00\x00\x00\x01", 4);
>  
>  	ret = artpec6_crypto_setup_out_descr(common, &req_ctx->hw_ctx,
>  		sizeof(struct artpec6_crypto_aead_hw_ctx), false, false);
> @@ -2956,7 +2956,7 @@ static struct aead_alg aead_algos[] = {
>  		.setkey = artpec6_crypto_aead_set_key,
>  		.encrypt = artpec6_crypto_aead_encrypt,
>  		.decrypt = artpec6_crypto_aead_decrypt,
> -		.ivsize = AES_BLOCK_SIZE,
> +		.ivsize = 12,

GCM_AES_IV_SIZE ?

Regards

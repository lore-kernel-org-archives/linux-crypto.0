From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 1/2] crypto: dh - fix dh_max_size
Date: Fri, 12 May 2017 12:41:37 +0300
Message-ID: <beba21e2-f25e-3ca6-de0d-95f44427632b@microchip.com>
References: <1494421469-17125-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34783 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdELJll (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 05:41:41 -0400
In-Reply-To: <1494421469-17125-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore this patch set. I will send all the changes in a new
patch set.

On 10.05.2017 16:04, Tudor Ambarus wrote:
> The function should return minimum size for output buffer
> or error code if key hasn't been set.
>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  crypto/dh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/dh.c b/crypto/dh.c
> index 87e3542..53d17ff 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -148,7 +148,7 @@ static int dh_max_size(struct crypto_kpp *tfm)
>  {
>  	struct dh_ctx *ctx = dh_get_ctx(tfm);
>
> -	return mpi_get_size(ctx->p);
> +	return ctx->p ? mpi_get_size(ctx->p) : -EINVAL;
>  }
>
>  static void dh_exit_tfm(struct crypto_kpp *tfm)
>

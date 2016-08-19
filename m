From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH -next] crypto: fix missing unlock on error in sun4i_hash()
Date: Fri, 19 Aug 2016 07:40:41 +0200
Message-ID: <8aa15aa0-4aa3-793c-c9cf-e8f94caf12f1@gmail.com>
References: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33603 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbcHSFlg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 01:41:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so2053147wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2016 22:40:44 -0700 (PDT)
In-Reply-To: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19/08/2016 00:42, Wei Yongjun wrote:
> Add the missing unlock before return from function sun4i_hash()
> in the error handling case.
> 
> Fixes: 477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> index 2ee3b59..de66f47 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> @@ -245,6 +245,7 @@ int sun4i_hash(struct ahash_request *areq)
>  		if (end > areq->nbytes || areq->nbytes - end > 63) {
>  			dev_err(ss->dev, "ERROR: Bound error %u %u\n",
>  				end, areq->nbytes);
> +			spin_unlock(&ss->slock);
>  			return -EINVAL;
>  		}
>  	} else {
> 

Hello

Thanks for the finding, but it is better in that case to use the goto release_ss since it need also to stop the device.

Regards

LABBE Corentin

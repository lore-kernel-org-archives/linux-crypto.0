From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH -next v2] crypto: sun4i-ss - fix missing unlock on error
 in sun4i_hash()
Date: Tue, 23 Aug 2016 15:54:46 +0200
Message-ID: <ef5d41ec-132c-324f-7bb0-841911699ab5@gmail.com>
References: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
 <1471690133-24396-1-git-send-email-weiyj.lk@gmail.com>
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
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33704 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbcHWNyu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 09:54:50 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so18291931wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Aug 2016 06:54:50 -0700 (PDT)
In-Reply-To: <1471690133-24396-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20/08/2016 12:48, Wei Yongjun wrote:
> Add the missing unlock before return from function sun4i_hash()
> in the error handling case.
> 
> Fixes: 477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
> ---
> v1 -> v2: goto release_ss as LABBE Corentin's suggestion
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> index 2ee3b59..1afeb8e 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> @@ -245,7 +245,8 @@ int sun4i_hash(struct ahash_request *areq)
>  		if (end > areq->nbytes || areq->nbytes - end > 63) {
>  			dev_err(ss->dev, "ERROR: Bound error %u %u\n",
>  				end, areq->nbytes);
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto release_ss;
>  		}
>  	} else {
>  		/* Since we have the flag final, we can go up to modulo 4 */
> 

Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks

From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH -next] crypto: algif_rng - fix sparse non static symbol
 warning
Date: Wed, 14 Jan 2015 04:43:51 -0500
Message-ID: <20150114094351.GA15294@localhost.localdomain>
References: <1421198081-16766-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-crypto@vger.kernel.org
To: weiyj_lk@163.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59046 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbANJoV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2015 04:44:21 -0500
Content-Disposition: inline
In-Reply-To: <1421198081-16766-1-git-send-email-weiyj_lk@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2015 at 09:14:41AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warnings:
> 
> crypto/algif_rng.c:185:13: warning:
>  symbol 'rng_exit' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  crypto/algif_rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 91c06f5..67f612c 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -182,7 +182,7 @@ static int __init rng_init(void)
>  	return af_alg_register_type(&algif_type_rng);
>  }
>  
> -void __exit rng_exit(void)
> +static void __exit rng_exit(void)
>  {
>  	int err = af_alg_unregister_type(&algif_type_rng);
>  	BUG_ON(err);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH -next] crypto: algif_rng - fix sparse non static symbol warning
Date: Wed, 14 Jan 2015 04:11:14 +0100
Message-ID: <2495791.u1JdGytR9n@tachyon.chronox.de>
References: <1421198081-16766-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-crypto@vger.kernel.org
To: weiyj_lk@163.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59474 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbbANDL2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 22:11:28 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SFF03> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Wed, 14 Jan 2015 04:11:19 +0100
In-Reply-To: <1421198081-16766-1-git-send-email-weiyj_lk@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 14. Januar 2015, 09:14:41 schrieb weiyj_lk@163.com:

Hi,

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warnings:
> 
> crypto/algif_rng.c:185:13: warning:
>  symbol 'rng_exit' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Stephan Mueller <smueller@chronox.de>
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


-- 
Ciao
Stephan

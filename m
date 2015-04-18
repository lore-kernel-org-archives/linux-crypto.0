From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/3] crypto: drbg - fix drbg_generate return val check
Date: Sat, 18 Apr 2015 17:48:41 +0200
Message-ID: <3715518.jItNN4ZoNa@myon.chronox.de>
References: <2596998.Ykulm8tym0@myon.chronox.de> <2357671.arYJ3FSGcR@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34193 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbbDRPsz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 11:48:55 -0400
In-Reply-To: <2357671.arYJ3FSGcR@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. April 2015, 16:42:20 schrieb Stephan Mueller:

Hi Stephan,

> The drbg_generate returns 0 in success case. That means that
> drbg_generate_long will always only generate drbg_max_request_bytes at
> most. Longer requests will be truncated to drbg_max_request_bytes.
> 
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index b69409c..74f7c1e 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1450,7 +1450,7 @@ static int drbg_generate_long(struct drbg_state *drbg,
> slice = ((buflen - len) / drbg_max_request_bytes(drbg));
>  		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
>  		tmplen = drbg_generate(drbg, buf + len, chunk, addtl);
> -		if (0 >= tmplen)
> +		if (0 > tmplen)

Please disregard this patch :-(

I need to update that one further -- my preliminary tests worked but more 
extensive tests showed that the patch is wrong.

>  			return tmplen;
>  		len += tmplen;
>  	} while (slice > 0 && (len < buflen));


-- 
Ciao
Stephan

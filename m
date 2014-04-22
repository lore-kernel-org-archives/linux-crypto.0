From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 2/2] crypto: caam - add allocation failure handling in SPRINTFCAT macro
Date: Wed, 23 Apr 2014 01:56:41 +0200
Message-ID: <201404230156.41234.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com> <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37659 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaDVX7G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Apr 2014 19:59:06 -0400
In-Reply-To: <1397815302-15915-2-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, April 18, 2014 at 12:01:42 PM, Horia Geanta wrote:
> GFP_ATOMIC memory allocation could fail.
> In this case, avoid NULL pointer dereference and notify user.
> 
> Cc: <stable@vger.kernel.org> # 3.2+

If I recall correctly, you need to get the patch accepted into mainline before 
sending it for -stable .

> Cc: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
>  drivers/crypto/caam/error.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
> index 9f25f5296029..0eabd81e1a90 100644
> --- a/drivers/crypto/caam/error.c
> +++ b/drivers/crypto/caam/error.c
> @@ -16,9 +16,13 @@
>  	char *tmp;						\
>  								\
>  	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
> -	sprintf(tmp, format, param);				\
> -	strcat(str, tmp);					\
> -	kfree(tmp);						\
> +	if (likely(tmp)) {					\
> +		sprintf(tmp, format, param);			\
> +		strcat(str, tmp);				\
> +		kfree(tmp);					\
> +	} else {						\
> +		strcat(str, "kmalloc failure in SPRINTFCAT");	\

This entire macro looks somewhat strange.
1) Can't you just snprintf() into $str + some offset ? Something like:
   snprintf(str + strlen(str), str_total_sz - strlen(str), format, param);
   
2) Why is noone checking if the $str has enough space for contents of $tmp ?

Best regards,
Marek Vasut

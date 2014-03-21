From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH v2] crypto: caam - fix caamrng compilation warning
Date: Fri, 21 Mar 2014 05:54:52 +0000
Message-ID: <b23b60ee40ee4805863dde783da584e1@BLUPR03MB472.namprd03.prod.outlook.com>
References: <1395342028-60770-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
To: "yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Vakul Garg <vakul@freescale.com>,
	"Horia.Geanta@freescale.com" <Horia.Geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:1808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752549AbaCUGJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 02:09:30 -0400
In-Reply-To: <1395342028-60770-1-git-send-email-yashpal.dutta@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Acked-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: Yashpal Dutta [mailto:yashpal.dutta@freescale.com]
> Sent: Friday, March 21, 2014 12:30 AM
> To: linux-crypto@vger.kernel.org; Gupta Ruchika-R66431; Garg Vakul-B16394;
> Geanta Neag Horia Ioan-B05471
> Cc: Dutta Yashpal-B05456; stable@vger.kernel.org
> Subject: [PATCH v2] crypto: caam - fix caamrng compilation warning
> 
> caam_init_rng was erroneously passed pointer address instead of rng context
> pointer. This results in Linux compilation warnings
> 
> Cc: <stable@vger.kernel.org> # 3.13.6: 6e4e603: crypto: caam - Dynamic
> memory
> Cc: <stable@vger.kernel.org> # 3.13.6
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
> ---
>  drivers/crypto/caam/caamrng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 403d8d5..3529b54 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -290,7 +290,7 @@ static int __init caam_rng_init(void)
>  	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
>  	if (!rng_ctx)
>  		return -ENOMEM;
> -	caam_init_rng(&rng_ctx, dev);
> +	caam_init_rng(rng_ctx, dev);
> 
>  	dev_info(dev, "registering rng-caam\n");
>  	return hwrng_register(&caam_rng);
> --
> 1.8.1.2
> 

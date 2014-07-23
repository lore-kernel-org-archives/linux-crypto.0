From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto: caam - fix DECO RSR polling
Date: Wed, 23 Jul 2014 08:53:01 +0000
Message-ID: <06d967cbd979450da041788b63dab64f@BL2PR03MB466.namprd03.prod.outlook.com>
References: <53CCC5A5.1070004@freescale.com>
 <1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "David S. Miller" <davem@davemloft.net>
To: "Horia.Geanta@freescale.com" <Horia.Geanta@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:29237
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756127AbaGWIxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 04:53:05 -0400
In-Reply-To: <1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

<Acked-by> :- Ruchika Gupta <ruchika.gupta@freescale.com>

Tested on P4080DS. 
Ported and tested on LS1 platform also (This platform has the virtualization enabled).

Thanks,
Ruchika

> -----Original Message-----
> From: Horia Geanta [mailto:horia.geanta@freescale.com]
> Sent: Monday, July 21, 2014 6:33 PM
> To: Herbert Xu; linux-crypto@vger.kernel.org; Gupta Ruchika-R66431; Phillips
> Kim-R1AAHA
> Cc: David S. Miller
> Subject: [PATCH] crypto: caam - fix DECO RSR polling
> 
> RSR (Request Source Register) is not used when virtualization is disabled,
> thus don't poll for Valid bit.
> 
> Besides this, if used, timeout has to be reinitialized.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
> Only compile-tested.
> Ruchika / Kim, please review / test.
> 
>  drivers/crypto/caam/ctrl.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c index
> c6e9d3b2d502..84d4b95c761e 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -89,12 +89,15 @@ static inline int run_descriptor_deco0(struct device
> *ctrldev, u32 *desc,
>  	/* Set the bit to request direct access to DECO0 */
>  	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
> 
> -	if (ctrlpriv->virt_en == 1)
> +	if (ctrlpriv->virt_en == 1) {
>  		setbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
> 
> -	while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
> -	       --timeout)
> -		cpu_relax();
> +		while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
> +		       --timeout)
> +			cpu_relax();
> +
> +		timeout = 100000;
> +	}
> 
>  	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
> 
> --
> 1.8.3.1

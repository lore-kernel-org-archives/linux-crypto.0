From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto: caam - Add missing Job Ring include
Date: Tue, 19 Nov 2013 04:17:31 +0000
Message-ID: <B2B5EF0D8FDD10429C8DE6C4C2B3828209470566@039-SN2MPN1-023.039d.mgd.msft.net>
References: <7301.1384748401@ale.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Vakul Garg <vakul@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:56146
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab3KSERh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Nov 2013 23:17:37 -0500
In-Reply-To: <7301.1384748401@ale.ozlabs.ibm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Acked-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Michael Neuling
> Sent: Monday, November 18, 2013 9:50 AM
> To: Gupta Ruchika-R66431
> Cc: Garg Vakul-B16394; Herbert Xu; linux-crypto@vger.kernel.org;
> sfr@canb.auug.org.au
> Subject: [PATCH] crypto: caam - Add missing Job Ring include
> 
> linuxnext currently doesn't compile with the powerpc mpc85xx_defconfig
> giving:
> 
>   drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
>   drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function
> 'of_iomap' [-Werror=implicit-function-declaration]
> 
> In:
>   commit 313ea293e9c4d1eabcaddd2c0800f083b03c2a2e
>   Author: Ruchika Gupta <ruchika.gupta@freescale.com>
>   crypto: caam - Add Platform driver for Job Ring
> 
> We added a reference to of_iomap but did add the necessary include file.
> 
> The below adds this include.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> d23356d2..1d80bd3 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -6,6 +6,7 @@
>   */
> 
>  #include <linux/of_irq.h>
> +#include <linux/of_address.h>
> 
>  #include "compat.h"
>  #include "regs.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

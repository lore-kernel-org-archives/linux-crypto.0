From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2] crypto: caam - fix memleak in caam_jr module
Date: Thu, 3 Jul 2014 17:54:06 -0500
Message-ID: <20140703175406.548b5db8610cf286aa5e2cc9@freescale.com>
References: <75b67e0fc305452fb5075e5bee5fff9c@BL2PR03MB162.namprd03.prod.outlook.com>
	<1404389270-19588-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:36478
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752275AbaGCW7P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 18:59:15 -0400
In-Reply-To: <1404389270-19588-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 3 Jul 2014 15:07:50 +0300
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> This patch fixes a memory leak that appears when caam_jr module is unloaded.
> 
> Cc: <stable@vger.kernel.org> # 3.13+
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  drivers/crypto/caam/jr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 1d80bd3..e0b91fc 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -453,7 +453,7 @@ static int caam_jr_probe(struct platform_device *pdev)
>  	int error;
>  
>  	jrdev = &pdev->dev;
> -	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
> +	jrpriv = devm_kzalloc(jrdev, sizeof(struct caam_drv_private_jr),
>  			 GFP_KERNEL);

alignment.  Also, why are we replacing a _m_alloc with a _z_alloc?

Please start using get_maintainer.pl.

Thanks,

Kim

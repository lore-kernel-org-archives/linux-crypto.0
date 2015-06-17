From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC 06/11] crypto: caam - Enable MXC devices to select
 CAAM driver in Kconfig
Date: Wed, 17 Jun 2015 09:27:34 +0200
Message-ID: <20150617072734.GK7947@pengutronix.de>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-7-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56897 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbbFQH1h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 03:27:37 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-7-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:54PM -0700, Victoria Milhoan wrote:
> From: Steve Cornelius <steve.cornelius@freescale.com>
> 
> Allow CAAM to be selected in the kernel for Freescale i.MX6 devices if
> ARCH_MXC is enabled.
> 
> Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> ---
>  drivers/crypto/caam/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> index e7555ff..bc9aa07 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -1,6 +1,6 @@
>  config CRYPTO_DEV_FSL_CAAM
>  	tristate "Freescale CAAM-Multicore driver backend"
> -	depends on FSL_SOC
> +	depends on FSL_SOC || ARCH_MXC

Is this right? Are there other i.MX that have the CAAM IP core?
Sounds like it should be SOC_IMX6 instead.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

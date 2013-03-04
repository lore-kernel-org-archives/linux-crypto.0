From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Mon, 4 Mar 2013 08:53:06 +0100
Message-ID: <20130304075306.GA1906@pengutronix.de>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
 <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	kernel@pengutronix.de, gcembed@gmail.com, shawn.guo@linaro.org,
	arnd@arndb.de, swarren@nvidia.com
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3CDHxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Mar 2013 02:53:19 -0500
Content-Disposition: inline
In-Reply-To: <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 01, 2013 at 12:37:52PM +0100, Javier Martin wrote:
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  arch/arm/mach-imx/clk-imx27.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
> index 4c1d1e4..0b9664a 100644
> --- a/arch/arm/mach-imx/clk-imx27.c
> +++ b/arch/arm/mach-imx/clk-imx27.c
> @@ -253,6 +253,8 @@ int __init mx27_clocks_init(unsigned long fref)
>  	clk_register_clkdev(clk[nfc_baud_gate], NULL, "imx27-nand.0");
>  	clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
>  	clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
> +	clk_register_clkdev(clk[sahara_ahb_gate], "ahb", "sahara-imx27.0");
> +	clk_register_clkdev(clk[sahara_ipg_gate], "ipg", "sahara-imx27.0");

One of the first patches I want to push upstream for the next merge
window is this one:

https://patchwork.kernel.org/patch/1817741/

So the change above becomes unnecessary

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

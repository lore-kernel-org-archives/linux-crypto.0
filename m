From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH 08/12] ARM: clk-imx6q: Add CAAM clock support
Date: Thu, 30 Jul 2015 23:38:22 -0700
Message-ID: <20150730233822.2f2fc8f8302bb00db4068dbb@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
	<1438228709-27650-9-git-send-email-vicki.milhoan@freescale.com>
	<20150730061411.GK18700@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux@arm.linux.org.uk>,
	<herbert@gondor.apana.org.au>, <ruchika.gupta@freescale.com>,
	<kernel@pengutronix.de>, <shawnguo@kernel.org>,
	<horia.geanta@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0107.outbound.protection.outlook.com ([157.56.111.107]:21786
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbbGaGie (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 02:38:34 -0400
In-Reply-To: <20150730061411.GK18700@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 30 Jul 2015 08:14:11 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> On Wed, Jul 29, 2015 at 08:58:25PM -0700, Victoria Milhoan wrote:
> > Add CAAM clock support to the i.MX6 clocking infrastructure.
> > 
> > Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> > ---
> >  drivers/clk/imx/clk-imx6q.c               | 3 +++
> >  include/dt-bindings/clock/imx6qdl-clock.h | 5 ++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
> > index d046f8e..4de4943 100644
> > --- a/drivers/clk/imx/clk-imx6q.c
> > +++ b/drivers/clk/imx/clk-imx6q.c
> > @@ -381,6 +381,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> >  	clk[IMX6QDL_CLK_ASRC]         = imx_clk_gate2_shared("asrc",         "asrc_podf",   base + 0x68, 6, &share_count_asrc);
> >  	clk[IMX6QDL_CLK_ASRC_IPG]     = imx_clk_gate2_shared("asrc_ipg",     "ahb",         base + 0x68, 6, &share_count_asrc);
> >  	clk[IMX6QDL_CLK_ASRC_MEM]     = imx_clk_gate2_shared("asrc_mem",     "ahb",         base + 0x68, 6, &share_count_asrc);
> > +	clk[IMX6QDL_CAAM_MEM]         = imx_clk_gate2("caam_mem",      "ahb",               base + 0x68, 8);
> > +	clk[IMX6QDL_CAAM_ACLK]        = imx_clk_gate2("caam_aclk",     "ahb",               base + 0x68, 10);
> > +	clk[IMX6QDL_CAAM_IPG]         = imx_clk_gate2("caam_ipg",      "ipg",               base + 0x68, 12);
> >  	clk[IMX6QDL_CLK_CAN1_IPG]     = imx_clk_gate2("can1_ipg",      "ipg",               base + 0x68, 14);
> >  	clk[IMX6QDL_CLK_CAN1_SERIAL]  = imx_clk_gate2("can1_serial",   "can_root",          base + 0x68, 16);
> >  	clk[IMX6QDL_CLK_CAN2_IPG]     = imx_clk_gate2("can2_ipg",      "ipg",               base + 0x68, 18);
> > diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
> > index 8780868..f68e925 100644
> > --- a/include/dt-bindings/clock/imx6qdl-clock.h
> > +++ b/include/dt-bindings/clock/imx6qdl-clock.h
> > @@ -251,6 +251,9 @@
> >  #define IMX6QDL_CLK_VIDEO_27M			238
> >  #define IMX6QDL_CLK_MIPI_CORE_CFG		239
> >  #define IMX6QDL_CLK_MIPI_IPG			240
> > -#define IMX6QDL_CLK_END				241
> > +#define IMX6QDL_CAAM_MEM			241
> > +#define IMX6QDL_CAAM_ACLK			242
> > +#define IMX6QDL_CAAM_IPG			243
> 
> IMX6QDL_CLK_* please.

Changes made and will be available in the next revision of patches.

> 
> Sascha
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

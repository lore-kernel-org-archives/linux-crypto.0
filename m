From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH 03/12] crypto: caam - Enable and disable clocks on
 Freescale i.MX platforms
Date: Thu, 30 Jul 2015 23:32:44 -0700
Message-ID: <20150730233244.f00f40cca35944bbb21b807f@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
	<1438228709-27650-4-git-send-email-vicki.milhoan@freescale.com>
	<20150730060214.GI18700@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux@arm.linux.org.uk>,
	<herbert@gondor.apana.org.au>, <ruchika.gupta@freescale.com>,
	<kernel@pengutronix.de>, <shawnguo@kernel.org>,
	<horia.geanta@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0145.outbound.protection.outlook.com ([207.46.100.145]:7040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbbGaGc5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 02:32:57 -0400
In-Reply-To: <20150730060214.GI18700@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sascha,

Thank you for the responses. Comments inline. Changes will be 
in the next version of the patch set.

-Victoria

On Thu, 30 Jul 2015 08:02:14 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Hi Victoria,
> 
> comments inline.
> 
> On Wed, Jul 29, 2015 at 08:58:20PM -0700, Victoria Milhoan wrote:
> > ARM-based systems may disable clocking to the CAAM device on the
> > Freescale i.MX platform for power management purposes.  This patch
> > enables the required clocks when the CAAM module is initialized and
> > disables the required clocks when the CAAM module is shut down.
> > 
> > Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> > ---
> >  drivers/crypto/caam/compat.h |   1 +
> >  drivers/crypto/caam/ctrl.c   | 191 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/crypto/caam/intern.h |   5 ++
> >  3 files changed, 197 insertions(+)
> > 
> > diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
> > index f57f395..b6955ec 100644
> > --- a/drivers/crypto/caam/compat.h
> > +++ b/drivers/crypto/caam/compat.h
> > @@ -23,6 +23,7 @@
> >  #include <linux/types.h>
> >  #include <linux/debugfs.h>
> >  #include <linux/circ_buf.h>
> > +#include <linux/clk.h>
> >  #include <net/xfrm.h>
> >  
> >  #include <crypto/algapi.h>
> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > index 660cc3e..cfd8c9e 100644
> > --- a/drivers/crypto/caam/ctrl.c
> > +++ b/drivers/crypto/caam/ctrl.c
> > @@ -16,6 +16,121 @@
> >  #include "error.h"
> >  
> >  /*
> > + * ARM targets tend to have clock control subsystems that can
> > + * enable/disable clocking to our device. Support clocking
> > + * with the following functions.
> > + */
> > +#ifdef CONFIG_ARM
> > +static inline struct clk *caam_drv_get_clk_ipg(struct caam_drv_private *drv)
> > +{
> > +	return drv->caam_ipg;
> > +}
> 
> You return drv->caam_ipg on ARM and NULL on powerpc. drv->caam_ipg is
> NULL on powerpc anyway which makes this different implementations for
> ARM and powerpc unnecessary. Just access drv->caam_ipg directly where
> needed.

Agreed. I've reworked the patch to use direct references to the clocks.

> 
> > +
> > +static inline struct clk *caam_drv_get_clk_mem(struct caam_drv_private *drv)
> > +{
> > +	return drv->caam_mem;
> > +}
> > +
> > +static inline struct clk *caam_drv_get_clk_aclk(struct caam_drv_private *drv)
> > +{
> > +	return drv->caam_aclk;
> > +}
> > +
> > +static inline struct clk *caam_drv_get_clk_emislow(struct caam_drv_private *drv)
> > +{
> > +	return drv->caam_emi_slow;
> > +}
> > +
> > +static inline void caam_drv_set_clk_ipg(struct caam_drv_private *drv,
> > +					struct clk *clk)
> > +{
> > +	drv->caam_ipg = clk;
> > +}
> 
> Ditto, just access drv->caam_ipg when needed.
> 
> > +
> > +static inline void caam_drv_set_clk_mem(struct caam_drv_private *drv,
> > +					struct clk *clk)
> > +{
> > +	drv->caam_mem = clk;
> > +}
> > +
> > +static inline void caam_drv_set_clk_aclk(struct caam_drv_private *drv,
> > +					 struct clk *clk)
> > +{
> > +	drv->caam_aclk = clk;
> > +}
> > +
> > +static inline void caam_drv_set_clk_emislow(struct caam_drv_private *drv,
> > +					    struct clk *clk)
> > +{
> > +	drv->caam_emi_slow = clk;
> > +}
> > +
> > +static inline struct clk *caam_drv_identify_clk(struct device *dev,
> > +						char *clk_name)
> > +{
> > +	return devm_clk_get(dev, clk_name);
> > +}
> 
> devm_clk_get() returns NULL when the architecture does not have clk
> support, so it also seems unnecessary to have architecture specific
> implementations for this.
> 

Some of the QorIQ architectures have clock support enabled but do not
support clocking to CAAM. This causes devm_clk_get() to return an error
for these clocks instead of NULL. So, the only architecture-specific code
left in the reworked patch is caam_drv_identify_clk().

> > +
> > +static inline void caam_drv_show_clk(struct device *dev, struct clk *clk,
> > +				     char *clk_name)
> > +{
> > +	dev_info(dev, "%s clock:%d\n", clk_name, (int)clk_get_rate(clk));
> > +}
> 
> The correct format specifier for unsigned long is "%lu", no need to cast
> it to int. Besides, this information is not generally interesting, you
> can drop this.
> 

I removed this code.

> > +
> > +#else
> > +static inline struct clk *caam_drv_get_clk_ipg(struct caam_drv_private *drv)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline struct clk *caam_drv_get_clk_mem(struct caam_drv_private *drv)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline struct clk *caam_drv_get_clk_aclk(struct caam_drv_private *drv)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline struct clk *caam_drv_get_clk_emislow(struct caam_drv_private *drv)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline void caam_drv_set_clk_ipg(struct caam_drv_private *drv,
> > +					struct clk *clk)
> > +{
> > +}
> > +
> > +static inline void caam_drv_set_clk_mem(struct caam_drv_private *drv,
> > +					struct clk *clk)
> > +{
> > +}
> > +
> > +static inline void caam_drv_set_clk_aclk(struct caam_drv_private *drv,
> > +					 struct clk *clk)
> > +{
> > +}
> > +
> > +static inline void caam_drv_set_clk_emislow(struct caam_drv_private *drv,
> > +					    struct clk *clk)
> > +{
> > +}
> > +
> > +static inline struct clk *caam_drv_identify_clk(struct device *dev,
> > +						char *clk_name)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void caam_drv_show_clk(struct device *dev, struct clk *clk,
> > +				     char *clk_name)
> > +{
> > +}
> > +#endif
> > +
> > +/*
> >   * Descriptor to instantiate RNG State Handle 0 in normal mode and
> >   * load the JDKEK, TDKEK and TDSK registers
> >   */
> > @@ -304,6 +419,12 @@ static int caam_remove(struct platform_device *pdev)
> >  	/* Unmap controller region */
> >  	iounmap(ctrl);
> >  
> > +	/* shut clocks off before finalizing shutdown */
> > +	clk_disable_unprepare(caam_drv_get_clk_ipg(ctrlpriv));
> > +	clk_disable_unprepare(caam_drv_get_clk_mem(ctrlpriv));
> > +	clk_disable_unprepare(caam_drv_get_clk_aclk(ctrlpriv));
> > +	clk_disable_unprepare(caam_drv_get_clk_emislow(ctrlpriv));
> > +
> >  	return ret;
> >  }
> >  
> > @@ -391,6 +512,7 @@ static int caam_probe(struct platform_device *pdev)
> >  	struct device_node *nprop, *np;
> >  	struct caam_ctrl __iomem *ctrl;
> >  	struct caam_drv_private *ctrlpriv;
> > +	struct clk *clk;
> >  #ifdef CONFIG_DEBUG_FS
> >  	struct caam_perfmon *perfmon;
> >  #endif
> > @@ -409,6 +531,75 @@ static int caam_probe(struct platform_device *pdev)
> >  	ctrlpriv->pdev = pdev;
> >  	nprop = pdev->dev.of_node;
> >  
> > +	/* Enable clocking */
> > +	clk = caam_drv_identify_clk(&pdev->dev, "caam_ipg");
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		dev_err(&pdev->dev,
> > +			"can't identify CAAM ipg clk: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +	caam_drv_set_clk_ipg(ctrlpriv, clk);
> > +
> > +	clk = caam_drv_identify_clk(&pdev->dev, "caam_mem");
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		dev_err(&pdev->dev,
> > +			"can't identify CAAM mem clk: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +	caam_drv_set_clk_mem(ctrlpriv, clk);
> > +
> > +	clk = caam_drv_identify_clk(&pdev->dev, "caam_aclk");
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		dev_err(&pdev->dev,
> > +			"can't identify CAAM aclk clk: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +	caam_drv_set_clk_aclk(ctrlpriv, clk);
> > +
> > +	clk = caam_drv_identify_clk(&pdev->dev, "caam_emi_slow");
> > +	if (IS_ERR(clk)) {
> > +		ret = PTR_ERR(clk);
> > +		dev_err(&pdev->dev,
> > +			"can't identify CAAM emi_slow clk: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +	caam_drv_set_clk_emislow(ctrlpriv, clk);
> > +
> > +	ret = clk_prepare_enable(caam_drv_get_clk_ipg(ctrlpriv));
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = clk_prepare_enable(caam_drv_get_clk_mem(ctrlpriv));
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
> > +			ret);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = clk_prepare_enable(caam_drv_get_clk_aclk(ctrlpriv));
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = clk_prepare_enable(caam_drv_get_clk_emislow(ctrlpriv));
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
> > +			ret);
> > +		return -ENODEV;
> > +	}
> > +
> > +	caam_drv_show_clk(dev, caam_drv_get_clk_ipg(ctrlpriv), "caam_ipg");
> 
> No. Each clk_get takes a reference to the clk and must be balanced with
> clk_put. You can't just take a new reference each time you need that
> clk.

This is no longer an issue in the modified code.

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

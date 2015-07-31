From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 03/12] crypto: caam - Enable and disable clocks on
 Freescale i.MX platforms
Date: Fri, 31 Jul 2015 08:40:53 +0200
Message-ID: <20150731064053.GO18700@pengutronix.de>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438228709-27650-4-git-send-email-vicki.milhoan@freescale.com>
 <20150730060214.GI18700@pengutronix.de>
 <20150730233244.f00f40cca35944bbb21b807f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, ruchika.gupta@freescale.com,
	kernel@pengutronix.de, shawnguo@kernel.org,
	horia.geanta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48971 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbGaGk5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 02:40:57 -0400
Content-Disposition: inline
In-Reply-To: <20150730233244.f00f40cca35944bbb21b807f@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 11:32:44PM -0700, Victoria Milhoan wrote:
> Hi Sascha,
> 
> Thank you for the responses. Comments inline. Changes will be 
> in the next version of the patch set.
> 
> -Victoria
> 
> On Thu, 30 Jul 2015 08:02:14 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Hi Victoria,
> > 
> > comments inline.
> > 
> > On Wed, Jul 29, 2015 at 08:58:20PM -0700, Victoria Milhoan wrote:
> > > ARM-based systems may disable clocking to the CAAM device on the
> > > Freescale i.MX platform for power management purposes.  This patch
> > > enables the required clocks when the CAAM module is initialized and
> > > disables the required clocks when the CAAM module is shut down.
> > > 
> > > Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> > > ---
> > >  drivers/crypto/caam/compat.h |   1 +
> > >  drivers/crypto/caam/ctrl.c   | 191 +++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/crypto/caam/intern.h |   5 ++
> > >  3 files changed, 197 insertions(+)
> > > 
> > > diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
> > > index f57f395..b6955ec 100644
> > > --- a/drivers/crypto/caam/compat.h
> > > +++ b/drivers/crypto/caam/compat.h
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/types.h>
> > >  #include <linux/debugfs.h>
> > >  #include <linux/circ_buf.h>
> > > +#include <linux/clk.h>
> > >  #include <net/xfrm.h>
> > >  
> > >  #include <crypto/algapi.h>
> > > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > > index 660cc3e..cfd8c9e 100644
> > > --- a/drivers/crypto/caam/ctrl.c
> > > +++ b/drivers/crypto/caam/ctrl.c
> > > @@ -16,6 +16,121 @@
> > >  #include "error.h"
> > >  
> > >  /*
> > > + * ARM targets tend to have clock control subsystems that can
> > > + * enable/disable clocking to our device. Support clocking
> > > + * with the following functions.
> > > + */
> > > +#ifdef CONFIG_ARM
> > > +static inline struct clk *caam_drv_get_clk_ipg(struct caam_drv_private *drv)
> > > +{
> > > +	return drv->caam_ipg;
> > > +}
> > 
> > You return drv->caam_ipg on ARM and NULL on powerpc. drv->caam_ipg is
> > NULL on powerpc anyway which makes this different implementations for
> > ARM and powerpc unnecessary. Just access drv->caam_ipg directly where
> > needed.
> 
> Agreed. I've reworked the patch to use direct references to the clocks.
> 
> > 
> > > +
> > > +static inline struct clk *caam_drv_get_clk_mem(struct caam_drv_private *drv)
> > > +{
> > > +	return drv->caam_mem;
> > > +}
> > > +
> > > +static inline struct clk *caam_drv_get_clk_aclk(struct caam_drv_private *drv)
> > > +{
> > > +	return drv->caam_aclk;
> > > +}
> > > +
> > > +static inline struct clk *caam_drv_get_clk_emislow(struct caam_drv_private *drv)
> > > +{
> > > +	return drv->caam_emi_slow;
> > > +}
> > > +
> > > +static inline void caam_drv_set_clk_ipg(struct caam_drv_private *drv,
> > > +					struct clk *clk)
> > > +{
> > > +	drv->caam_ipg = clk;
> > > +}
> > 
> > Ditto, just access drv->caam_ipg when needed.
> > 
> > > +
> > > +static inline void caam_drv_set_clk_mem(struct caam_drv_private *drv,
> > > +					struct clk *clk)
> > > +{
> > > +	drv->caam_mem = clk;
> > > +}
> > > +
> > > +static inline void caam_drv_set_clk_aclk(struct caam_drv_private *drv,
> > > +					 struct clk *clk)
> > > +{
> > > +	drv->caam_aclk = clk;
> > > +}
> > > +
> > > +static inline void caam_drv_set_clk_emislow(struct caam_drv_private *drv,
> > > +					    struct clk *clk)
> > > +{
> > > +	drv->caam_emi_slow = clk;
> > > +}
> > > +
> > > +static inline struct clk *caam_drv_identify_clk(struct device *dev,
> > > +						char *clk_name)
> > > +{
> > > +	return devm_clk_get(dev, clk_name);
> > > +}
> > 
> > devm_clk_get() returns NULL when the architecture does not have clk
> > support, so it also seems unnecessary to have architecture specific
> > implementations for this.
> > 
> 
> Some of the QorIQ architectures have clock support enabled but do not
> support clocking to CAAM. This causes devm_clk_get() to return an error
> for these clocks instead of NULL. So, the only architecture-specific code
> left in the reworked patch is caam_drv_identify_clk().

I see. Wouldn't it be better to add CAAM clk support for QorIQ then?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

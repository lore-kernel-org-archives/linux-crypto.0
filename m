From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH 07/10] crypto: omap-aes - Add Device Tree Support
Date: Tue, 8 Jan 2013 12:06:33 -0700
Message-ID: <20130108190633.GB32435@animalcreek.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
 <1356109500-11719-8-git-send-email-mgreer@animalcreek.com>
 <CA+Bv8XYz6mUJs82qAz=pvhkNDFe_Vp5Nv6918UPMGFAuAaU5Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: Russ Dill <russ.dill@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m1plsmtpa01-01.prod.mesa1.secureserver.net ([64.202.165.173]:43209
	"EHLO m1plsmtpa01-01.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab3AHTGe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2013 14:06:34 -0500
Content-Disposition: inline
In-Reply-To: <CA+Bv8XYz6mUJs82qAz=pvhkNDFe_Vp5Nv6918UPMGFAuAaU5Jw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 28, 2012 at 02:06:02AM -0800, Russ Dill wrote:
> On Fri, Dec 21, 2012 at 10:04 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> > From: "Mark A. Greer" <mgreer@animalcreek.com>
> >
> > Add Device Tree suport to the omap-aes crypto
> > driver.  Currently, only support for OMAP2 and
> > OMAP3 is being added but support for OMAP4 will
> > be added in a subsequent patch.
> >
> > CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> > ---
> >  drivers/crypto/omap-aes.c | 119 ++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 93 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> > index faf522f..68bf22d 100644
> > --- a/drivers/crypto/omap-aes.c
> > +++ b/drivers/crypto/omap-aes.c
> > @@ -25,6 +25,9 @@
> >  #include <linux/dmaengine.h>
> >  #include <linux/omap-dma.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_address.h>
> >  #include <linux/io.h>
> >  #include <linux/crypto.h>
> >  #include <linux/interrupt.h>
> > @@ -819,11 +822,93 @@ static struct crypto_alg algs[] = {
> >  }
> >  };
> >
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id omap_aes_of_match[] = {
> > +       {
> > +               .compatible     = "ti,omap2-aes",
> > +       },
> > +       {},
> > +};
> > +MODULE_DEVICE_TABLE(of, omap_aes_of_match);
> 
> I think you mean for the above section to be outside of the '#ifdef
> CONFIG_OF' block.
> 
> > +static int omap_aes_get_res_of(struct omap_aes_dev *dd,
> > +               struct device *dev, struct resource *res)
> > +{
> > +       struct device_node *node = dev->of_node;
> > +       const struct of_device_id *match;
> > +       int err = 0;
> > +
> > +       match = of_match_device(of_match_ptr(omap_aes_of_match), dev);
> > +       if (!match) {
> > +               dev_err(dev, "no compatible OF match\n");
> > +               err = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       err = of_address_to_resource(node, 0, res);
> > +       if (err < 0) {
> > +               dev_err(dev, "can't translate OF node address\n");
> > +               err = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       dd->dma_out = -1; /* Dummy value that's unused */
> > +       dd->dma_in = -1; /* Dummy value that's unused */
> > +
> > +err:
> > +       return err;
> > +}
> > +#else
> > +static int omap_aes_get_res_dev(struct omap_aes_dev *dd,
> > +               struct device *dev, struct resource *res)
> > +{
> > +       return -EINVAL;
> > +}
> 
> And I think you mean this one to be omap_aes_get_res_of

Your comments should be addressed in v2 of this series,

     http://www.spinics.net/lists/linux-omap/msg84629.html

Mark
--

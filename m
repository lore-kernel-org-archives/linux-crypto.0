From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH 07/10] crypto: omap-aes - Add Device Tree Support
Date: Mon, 7 Jan 2013 16:29:50 -0700
Message-ID: <20130107232950.GB13938@animalcreek.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
 <1356109500-11719-8-git-send-email-mgreer@animalcreek.com>
 <CA+Bv8XYz6mUJs82qAz=pvhkNDFe_Vp5Nv6918UPMGFAuAaU5Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-crypto@vger.kernel.org,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, davem@davemloft.net,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
To: Russ Dill <russ.dill@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CA+Bv8XYz6mUJs82qAz=pvhkNDFe_Vp5Nv6918UPMGFAuAaU5Jw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

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

Yes, I need to rework that.

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

I do. :(

Thanks Russ. 

Mark
--

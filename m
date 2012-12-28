From: Russ Dill <russ.dill@gmail.com>
Subject: Re: [PATCH 07/10] crypto: omap-aes - Add Device Tree Support
Date: Fri, 28 Dec 2012 02:06:02 -0800
Message-ID: <CA+Bv8XYz6mUJs82qAz=pvhkNDFe_Vp5Nv6918UPMGFAuAaU5Jw@mail.gmail.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
 <1356109500-11719-8-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-crypto@vger.kernel.org,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, davem@davemloft.net,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1356109500-11719-8-git-send-email-mgreer@animalcreek.com>
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

On Fri, Dec 21, 2012 at 10:04 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
>
> Add Device Tree suport to the omap-aes crypto
> driver.  Currently, only support for OMAP2 and
> OMAP3 is being added but support for OMAP4 will
> be added in a subsequent patch.
>
> CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-aes.c | 119 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 93 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index faf522f..68bf22d 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -25,6 +25,9 @@
>  #include <linux/dmaengine.h>
>  #include <linux/omap-dma.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
>  #include <linux/io.h>
>  #include <linux/crypto.h>
>  #include <linux/interrupt.h>
> @@ -819,11 +822,93 @@ static struct crypto_alg algs[] = {
>  }
>  };
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id omap_aes_of_match[] = {
> +       {
> +               .compatible     = "ti,omap2-aes",
> +       },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, omap_aes_of_match);

I think you mean for the above section to be outside of the '#ifdef
CONFIG_OF' block.

> +static int omap_aes_get_res_of(struct omap_aes_dev *dd,
> +               struct device *dev, struct resource *res)
> +{
> +       struct device_node *node = dev->of_node;
> +       const struct of_device_id *match;
> +       int err = 0;
> +
> +       match = of_match_device(of_match_ptr(omap_aes_of_match), dev);
> +       if (!match) {
> +               dev_err(dev, "no compatible OF match\n");
> +               err = -EINVAL;
> +               goto err;
> +       }
> +
> +       err = of_address_to_resource(node, 0, res);
> +       if (err < 0) {
> +               dev_err(dev, "can't translate OF node address\n");
> +               err = -EINVAL;
> +               goto err;
> +       }
> +
> +       dd->dma_out = -1; /* Dummy value that's unused */
> +       dd->dma_in = -1; /* Dummy value that's unused */
> +
> +err:
> +       return err;
> +}
> +#else
> +static int omap_aes_get_res_dev(struct omap_aes_dev *dd,
> +               struct device *dev, struct resource *res)
> +{
> +       return -EINVAL;
> +}

And I think you mean this one to be omap_aes_get_res_of

> +#endif
> +
> +static int omap_aes_get_res_pdev(struct omap_aes_dev *dd,
> +               struct platform_device *pdev, struct resource *res)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct resource *r;
> +       int err = 0;
> +
> +       /* Get the base address */
> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!r) {
> +               dev_err(dev, "no MEM resource info\n");
> +               err = -ENODEV;
> +               goto err;
> +       }
> +       memcpy(res, r, sizeof(*res));
> +
> +       /* Get the DMA out channel */
> +       r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +       if (!r) {
> +               dev_err(dev, "no DMA out resource info\n");
> +               err = -ENODEV;
> +               goto err;
> +       }
> +       dd->dma_out = r->start;
> +
> +       /* Get the DMA in channel */
> +       r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
> +       if (!r) {
> +               dev_err(dev, "no DMA in resource info\n");
> +               err = -ENODEV;
> +               goto err;
> +       }
> +       dd->dma_in = r->start;
> +
> +err:
> +       return err;
> +}
> +
>  static int omap_aes_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
>         struct omap_aes_dev *dd;
> -       struct resource *res;
> +       struct resource res;
>         int err = -ENOMEM, i, j;
>         u32 reg;
>
> @@ -838,35 +923,18 @@ static int omap_aes_probe(struct platform_device *pdev)
>         spin_lock_init(&dd->lock);
>         crypto_init_queue(&dd->queue, OMAP_AES_QUEUE_LENGTH);
>
> -       /* Get the base address */
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(dev, "invalid resource type\n");
> -               err = -ENODEV;
> +       err = (dev->of_node) ? omap_aes_get_res_of(dd, dev, &res) :
> +                              omap_aes_get_res_pdev(dd, pdev, &res);
> +       if (err)
>                 goto err_res;
> -       }
> -       dd->phys_base = res->start;
> -
> -       /* Get the DMA */
> -       res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> -       if (!res)
> -               dev_info(dev, "no DMA info\n");
> -       else
> -               dd->dma_out = res->start;
> -
> -       /* Get the DMA */
> -       res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
> -       if (!res)
> -               dev_info(dev, "no DMA info\n");
> -       else
> -               dd->dma_in = res->start;
> -
> -       dd->io_base = ioremap(dd->phys_base, SZ_4K);
> +
> +       dd->io_base = devm_request_and_ioremap(dev, &res);
>         if (!dd->io_base) {
>                 dev_err(dev, "can't ioremap\n");
>                 err = -ENOMEM;
>                 goto err_res;
>         }
> +       dd->phys_base = res.start;
>
>         pm_runtime_enable(dev);
>         pm_runtime_get_sync(dev);
> @@ -904,7 +972,6 @@ err_algs:
>  err_dma:
>         tasklet_kill(&dd->done_task);
>         tasklet_kill(&dd->queue_task);
> -       iounmap(dd->io_base);
>         pm_runtime_disable(dev);
>  err_res:
>         kfree(dd);
> @@ -932,7 +999,6 @@ static int omap_aes_remove(struct platform_device *pdev)
>         tasklet_kill(&dd->done_task);
>         tasklet_kill(&dd->queue_task);
>         omap_aes_dma_cleanup(dd);
> -       iounmap(dd->io_base);
>         pm_runtime_disable(dd->dev);
>         kfree(dd);
>         dd = NULL;
> @@ -965,6 +1031,7 @@ static struct platform_driver omap_aes_driver = {
>                 .name   = "omap-aes",
>                 .owner  = THIS_MODULE,
>                 .pm     = &omap_aes_pm_ops,
> +               .of_match_table = omap_aes_of_match,
>         },
>  };
>
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

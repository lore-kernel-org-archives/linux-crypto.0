Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580B7C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBAE214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfFSMPM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:15:12 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:45329 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfFSMPM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 08:15:12 -0400
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C7E38200007;
        Wed, 19 Jun 2019 12:15:03 +0000 (UTC)
Date:   Wed, 19 Jun 2019 14:15:02 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: Re: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190619121502.GA3254@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

Thanks for the patch :)

On Tue, Jun 18, 2019 at 07:56:23AM +0200, Pascal van Leeuwen wrote:
>  
>  			/* Fallback to the old firmware location for the
> @@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
>  
> +	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using %d pipe(s) and %d ring(s)",
> +			16, priv->config.pes, priv->config.rings);

Adding custom messages in the kernel log has to be done carefully.
Although it's not considered stable it could be difficult to rework
later on. Also, if all driver were to print custom messages the log
would be very hard to read. But you can also argue that a single message
when probing a driver is also done in other drivers.

For this one particularly, the probe could fail later on. So if we were
to add this output, it should be done at the very end of the probe.

> -	if (priv->version == EIP197B || priv->version == EIP197D) {
> +	if ((priv->version & EIP197B) || (priv->version & EIP197D)) {

You could also use "version & (EIP197B | EIP197D)" (there are other
examples of this).

> -static int safexcel_request_ring_irq(struct platform_device *pdev, const char *name,
> +static int safexcel_request_ring_irq(void *pdev, int irqid,
> +				     int is_pci_dev,

You could probably use the DEVICE_IS_PCI flag instead.

>  				     irq_handler_t handler,
>  				     irq_handler_t threaded_handler,
>  				     struct safexcel_ring_irq_data *ring_irq_priv)
>  {

> +			dev_err(dev, "unable to get IRQ '%s'\n (err %d)",
> +				irq_name, irq);

I think there's a typo here, the \n should be at the end of the string.

> +static int safexcel_probe_generic(void *pdev,
> +				  struct safexcel_crypto_priv *priv,
> +				  int is_pci_dev)
>  {

> +	if (IS_ENABLED(CONFIG_PCI) && (priv->version & DEVICE_IS_PCI)) {

DEVICE_IS_PCI should be set in ->flags, not ->version.

> +		/*
> +		 * Request MSI vectors for global + 1 per ring -
> +		 * or just 1 for older dev images
> +		 */
> +		struct pci_dev *pci_pdev = pdev;
> +
> +		ret = pci_alloc_irq_vectors(pci_pdev,
> +					    priv->config.rings + 1,
> +					    priv->config.rings + 1,
> +					    PCI_IRQ_MSI|PCI_IRQ_MSIX);

You need a space before and after the | here.

> +		if (ret < 0) {
> +			dev_err(dev, "Failed to allocate PCI MSI interrupts");

Do not forget the \n at the end of the string.

> +		if (ret) {
> +			dev_err(dev, "Failed to initialize rings");

Also here, and probably in other places :)

> -		snprintf(irq_name, 6, "ring%d", i);
> -		irq = safexcel_request_ring_irq(pdev, irq_name, safexcel_irq_ring,
> +		irq = safexcel_request_ring_irq(pdev, i + is_pci_dev,

This 'i + is_pci_dev' is hard to read and understand. I would suggest to
use a define, or an helper to get the real irq given if a device is
probed using PCI or not. Something like "safexcel_irq_number(i, priv)"

> +			dev_err(dev, "Failed to create work queue for ring %d",
> +				i);
> +			return -ENOMEM;
>  		}
> -

Why removing this one blank line?

>  		priv->ring[i].requests = 0;
>  		priv->ring[i].busy = false;
> -

Ditto.

> +		dev_err(dev, "EIP(1)97 h/w init failed (%d)", ret);

Adding a version information in the log means all the outputs will have
to be updated if we ever support an h/w with a different name.

> +/*
> + *
> + * for Device Tree platform driver
> + *
> + */

Please follow the comment styles (you can remove set in on a single line
here, or at least remove the blank lines). (There are other examples).

> @@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_device *pdev)
>  		.compatible = "inside-secure,safexcel-eip197d",
>  		.data = (void *)EIP197D,
>  	},
> +	/* For backward compatibiliry and intended for generic use */
>  	{
> -		/* Deprecated. Kept for backward compatibility. */
>  		.compatible = "inside-secure,safexcel-eip97",
>  		.data = (void *)EIP97IES,
>  	},
>  	{
> -		/* Deprecated. Kept for backward compatibility. */
>  		.compatible = "inside-secure,safexcel-eip197",
>  		.data = (void *)EIP197B,
>  	},

I'm not sure about this. The compatible should describe what the
hardware is, and the driver can then decide if it has special things to
do or not. It is not used to configure the driver to be used with a
generic use or not.

Do you have a practical reason to do this?

> +static int crypto_is_pci_probe(struct pci_dev *pdev,
> +	 const struct pci_device_id *ent)

The alignment is wrong here.

> +{
> +	if (IS_ENABLED(CONFIG_PCI)) {

Can this be called with CONFIG_PCI disabled?

> +		dev_info(dev, "Probing PCIE device: vendor %04x, device %04x, subv %04x, subdev %04x, ctxt %lx",
> +			 ent->vendor, ent->device, ent->subvendor,
> +			 ent->subdevice, ent->driver_data);

Please drop this new message. If the userspace needs it, I believe there
are clean ways to get it.

> +		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +		if (!priv) {
> +			dev_err(dev, "Failed to allocate memory");
> +			return -ENOMEM;

No need to have a debug message when returning ENOMEM.

> +		/* enable the device */
> +		rc = pcim_enable_device(pdev);
> +		if (rc) {
> +			dev_err(dev, "pci_enable_device() failed");

Please use error messages describing the issue rather than printing the
function names. (There are other examples).

> +		if (priv->version & XILINX_PCIE) {
> +			dev_info(dev, "Device identified as FPGA based development board - applying HW reset");
> +
> +			rc = pcim_iomap_regions(pdev, 4, "crypto_safexcel");
> +			if (rc) {
> +				dev_err(dev, "pcim_iomap_regions() failed for BAR4");
> +				return rc;
> +			}
> +
> +			pciebase = pcim_iomap_table(pdev)[2];
> +			val = readl(pciebase + XILINX_IRQ_BLOCK_ID);
> +			if ((val >> 16) == 0x1fc2) {

Try not to use magic values, use defines with a meaningful name.

> +				dev_info(dev, "Detected Xilinx PCIE IRQ block version %d, multiple MSI support enabled",
> +					 (val & 0xff));

Same comments as the other dev_info().

> +
> +				/* Setup MSI identity map mapping */
> +				writel(0x03020100,
> +				       pciebase + XILINX_USER_VECT_LUT0);
> +				writel(0x07060504,
> +				       pciebase + XILINX_USER_VECT_LUT1);
> +				writel(0x0b0a0908,
> +				       pciebase + XILINX_USER_VECT_LUT2);
> +				writel(0x0f0e0d0c,
> +				       pciebase + XILINX_USER_VECT_LUT3);

Use defines here.

> +			/* HW reset FPGA dev board */
> +			// assert reset
> +			writel(1, priv->base + XILINX_GPIO_BASE);
> +			wmb(); /* maintain strict ordering for accesses here */
> +			// deassert reset
> +			writel(0, priv->base + XILINX_GPIO_BASE);
> +			wmb(); /* maintain strict ordering for accesses here */

It seems the driver here access to a GPIO controller, to assert and
de-assert reset, which is outside the crypto engine i/o range. If true,
this is not acceptable in the upstream kernel: those GPIO or reset
should be accessed through the dedicated in-kernel API and be
implemented in separate drivers (maybe a reset driver here).

> +void crypto_is_pci_remove(struct pci_dev *pdev)
> +{
> +	if (IS_ENABLED(CONFIG_PCI)) {

Can this be accessed with CONFIG_PCI disabled?

> +static const struct pci_device_id crypto_is_pci_ids[] = {
> +	{
> +		.vendor = 0x10ee,
> +		.device = 0x9038,
> +		.subvendor = 0x16ae,
> +		.subdevice = 0xc522,
> +		.class = 0x00000000,
> +		.class_mask = 0x00000000,

You should use proper defines here, and define the vendor ID in a
generic way in the kernel. You can look for the use of PCI_DEVICE and
PCI_DEVICE_DATA as a starting point.

> +		// assume EIP197B for now
> +		.driver_data = XILINX_PCIE | DEVICE_IS_PCI | EIP197B,

We do use the data (here and for dt compatibles) to store a flag about
the version. I think XILINX_PCIE and DEVICE_IS_PCI should be flags, and
you should be able to set them using pci_dev->vendor_id (or other ids).

Also, you should prefix XILINX_PCIE and DEVICE_IS_PCI with an "unique"
name, which should be driver-specific to avoid colliding with other
possible global definitions. In this driver we do use EIP197_ and
SAFEXCEL_ a lot for historical reasons, you can pick one :)

> +static struct pci_driver crypto_is_pci_driver = {
> +	.name          = "crypto-safexcel",
> +	.id_table      = crypto_is_pci_ids,
> +	.probe         = crypto_is_pci_probe,
> +	.remove        = crypto_is_pci_remove,
> +};

More generally, you should protect all the PCI specific functions and
definitions between #ifdef.

> +MODULE_AUTHOR("Pascal van Leeuwen <pvanleeuwen@insidesecure.com>");

I think this is usually done in a separate patch, when one has made
numerous contributions to a driver.

I tested it on my hardware and the boot tests passed nicely, so it seems
there were no regressions (I'll make more tests though).

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

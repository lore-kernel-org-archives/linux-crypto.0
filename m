Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787DEC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FC752082C
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbfFTNGT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:06:19 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:37013 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731733AbfFTNGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 09:06:19 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 181B6FF820;
        Thu, 20 Jun 2019 13:06:09 +0000 (UTC)
Date:   Thu, 20 Jun 2019 15:06:09 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190620130609.GA4642@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619121502.GA3254@kwain>
 <AM6PR09MB352354E57F4CB4C9FD6F39B4D2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB352354E57F4CB4C9FD6F39B4D2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Jun 19, 2019 at 02:22:19PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Tue, Jun 18, 2019 at 07:56:23AM +0200, Pascal van Leeuwen wrote:
> > >
> > >  			/* Fallback to the old firmware location for the
> > > @@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
> > >
> > > +	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using %d pipe(s) and %d
> > ring(s)",
> > > +			16, priv->config.pes, priv->config.rings);
> > 
> > Adding custom messages in the kernel log has to be done carefully.
> > Although it's not considered stable it could be difficult to rework
> > later on. Also, if all driver were to print custom messages the log
> > would be very hard to read. But you can also argue that a single message
> > when probing a driver is also done in other drivers.
> > 
> Hmm ... don't know what the rules for logging are exactly, but from my
> perspective, I'm dealing with a zillion different HW configurations so 
> some feedback whether the driver detected the *correct* HW parameters - 
> or actually, whether I stuffed the correct image into my FPGA :o) - is 
> very convenient to have. And not just for my local development, but also 
> to debug deployments in the field at customer sites.

I understand it can be convenient, it's just a matter of having a
logging message for you that will end up in many builds for many users.
They do not necessarily have the same needs. So it's a matter of
compromise, one or two messages at boot can be OK, more is likely to
become an issue.

> Also, looking at my log, there's other drivers that are similarly 
> (or even more) verbose.

There are *always* other examples in the kernel :)

> If it's a really considered a problem, I could make it dev_dbg?

Sure. I would say adding one message at boot like this one seems OK. But
the others would need to be debugging messages.

> > For this one particularly, the probe could fail later on. So if we were
> > to add this output, it should be done at the very end of the probe.
> > 
> I'm in doubt about this one. I understand that you want to reduce the
> logging in that case, but at the same time that message can convey
> information as to WHY the probing fails later on ...

If the drivers fails to probe, there will be other messages. In that
case is this one really needed? I'm not sure.

> i.e. if it detects, say, 4 pipes on a device that, in fact, only has
> 2, then that may be the very reason for the FW init to fail later on.

In case of failure you'll need anyway to debug and understand what's
going on. By adding new prints, or enabling debugging messages.

> > > -static int safexcel_request_ring_irq(struct platform_device *pdev, const char *name,
> > > +static int safexcel_request_ring_irq(void *pdev, int irqid,
> > > +				     int is_pci_dev,
> > 
> > You could probably use the DEVICE_IS_PCI flag instead.
> > 
> I'm not currently passing priv to that function, so I can't access
> priv->version directly. I could pass a priv pointer instead and use
> the flag, but passing a bool constant seemed to be more efficient?

That right, whatever you prefer then.

> > > +static int safexcel_probe_generic(void *pdev,
> > > +				  struct safexcel_crypto_priv *priv,
> > > +				  int is_pci_dev)
> > >  {
> > 
> > > +	if (IS_ENABLED(CONFIG_PCI) && (priv->version & DEVICE_IS_PCI)) {
> > 
> > DEVICE_IS_PCI should be set in ->flags, not ->version.
> > 
> As far as I could tell from the existing code, "version" was
> a highlevel indication of the device *type* (EIP97/EIP197B/D)
> while flags was more about low-level *features*.

Using the same argument I would say the way the device is accessed is
very run-time dependent, and it has nothing to do with the version of
the h/w (the same engine could be accessed through different ways given
the platform).

Maybe the name 'feature' is too specific, I agree with you.

> So in my humble opinion, version was the correct location, it
> is just a confusing name. (i.e. you can have many *versions*
> of an EIP197B, for instance ...)

That would be an issue with the driver. We named the 'version' given the
knowledge we had of the h/w, it might not be specific enough. Or maybe
you can think of this as being a "family of engine versions". The idea
is the version is what the h/w is capable of, not how it's being
wired/accessed.

> > > +		/*
> > > +		 * Request MSI vectors for global + 1 per ring -
> > > +		 * or just 1 for older dev images
> > > +		 */
> > > +		struct pci_dev *pci_pdev = pdev;
> > > +
> > > +		ret = pci_alloc_irq_vectors(pci_pdev,
> > > +					    priv->config.rings + 1,
> > > +					    priv->config.rings + 1,
> > > +					    PCI_IRQ_MSI|PCI_IRQ_MSIX);
> > 
> > You need a space before and after the | here.
> > 
> Ok, will add (checkpatch did not complain though)

It may complain with --strict on this one. (Well, I'm sure many --strict
tests won't pass on the existing upstream code, no worries :)).

> > > +		if (ret < 0) {
> > > +			dev_err(dev, "Failed to allocate PCI MSI interrupts");
> > 
> > Do not forget the \n at the end of the string.
> > 
> Actually, I removed all "\n"'s from my messages as I 
> understood they are not needed? If they are really needed,
> I can add them to all log strings again ... anyone else?

The simple answer is: everybody set the \n, so at least for consistency
we should have them.

> > > @@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_device *pdev)
> > >  		.compatible = "inside-secure,safexcel-eip197d",
> > >  		.data = (void *)EIP197D,
> > >  	},
> > > +	/* For backward compatibiliry and intended for generic use */
> > >  	{
> > > -		/* Deprecated. Kept for backward compatibility. */
> > >  		.compatible = "inside-secure,safexcel-eip97",
> > >  		.data = (void *)EIP97IES,
> > >  	},
> > >  	{
> > > -		/* Deprecated. Kept for backward compatibility. */
> > >  		.compatible = "inside-secure,safexcel-eip197",
> > >  		.data = (void *)EIP197B,
> > >  	},
> > 
> > I'm not sure about this. The compatible should describe what the
> > hardware is, and the driver can then decide if it has special things to
> > do or not. It is not used to configure the driver to be used with a
> > generic use or not.
> > 
> > Do you have a practical reason to do this?
> 	
> I have to admit I don't fully understand how these compatible
> strings work. All I wanted to achieve is provide some generic
> device tree entry to point to this driver, to be used for 
> devices other than Marvell. No need to convey b/d that way
> (or even eip97/197, for that matter) as that can all be probed.

Compatibles are used in device trees, which intend to be a description
of the hardware (not the configuration of how the hardware should be
used). So we can't have a compatible being a restricted configuration
use of a given hardware. But I think here you're right, and there is
room for a more generic eip197 compatible: the b/d versions only have
few differences and are part of the same family, so we can have a very
specific compatible plus a "family" one. Something like:

  compatible = "inside-secure,safexcel-eip197d", "inside-secure,safexcel-eip197";

This would need to be in a separated patch, and this should be
documented in:
Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt

> > > +		/* enable the device */
> > > +		rc = pcim_enable_device(pdev);
> > > +		if (rc) {
> > > +			dev_err(dev, "pci_enable_device() failed");
> > 
> > Please use error messages describing the issue rather than printing the
> > function names. (There are other examples).
> > 
> But ... that IS the issue, isn't it? Well, apart from the actual
> return code. What message text would you suggest?

Yes, it is the issue. We generally use a sentence instead of function
names (something alongside s/_/ / :)).

> > > +			/* HW reset FPGA dev board */
> > > +			// assert reset
> > > +			writel(1, priv->base + XILINX_GPIO_BASE);
> > > +			wmb(); /* maintain strict ordering for accesses here */
> > > +			// deassert reset
> > > +			writel(0, priv->base + XILINX_GPIO_BASE);
> > > +			wmb(); /* maintain strict ordering for accesses here */
> > 
> > It seems the driver here access to a GPIO controller, to assert and
> > de-assert reset, which is outside the crypto engine i/o range. If true,
> > this is not acceptable in the upstream kernel: those GPIO or reset
> > should be accessed through the dedicated in-kernel API and be
> > implemented in separate drivers (maybe a reset driver here).
> > 
> Hmmm ... this is some *local* GPIO controller *inside*
> the FPGA device (i.e. doesn't even leave the silicon die).
> It's inside the range of the (single!) PCIE device, it's not
> a seperate device and thus cannot be managed as such ...
> 
> Effectively, it's just an MMIO mapped register no different
> from any other slave accessible register.
> If I had given it a less explicit name, nobody would've cared.

OK, that makes sense. If the register accessed is within the register
bank of the crypto engine you can keep this.

> > > +static struct pci_driver crypto_is_pci_driver = {
> > > +	.name          = "crypto-safexcel",
> > > +	.id_table      = crypto_is_pci_ids,
> > > +	.probe         = crypto_is_pci_probe,
> > > +	.remove        = crypto_is_pci_remove,
> > > +};
> > 
> > More generally, you should protect all the PCI specific functions and
> > definitions between #ifdef.
> > 
> I asked the mailing list and the answer was I should NOT use #ifdef,
> but instead use IS_ENABLED to *only* remove relevant function bodies.
> Which is exactly what I did (or tried to do, anyway).

My bad, I realise there's a mistake in my comment. That should have
been: you should protect all the PCI specific functions and definitions
with #if IS_ENABLED(...). When part of a function should be excluded
you can use if(IS_ENABLED(...)), but if the entire function can be left
out, #if is the way to go.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

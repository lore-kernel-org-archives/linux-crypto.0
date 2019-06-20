Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCAEC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 15:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0639D2070B
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 15:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFTPg5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 11:36:57 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45157 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfFTPg4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 11:36:56 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 51BFB2000B;
        Thu, 20 Jun 2019 15:36:52 +0000 (UTC)
Date:   Thu, 20 Jun 2019 17:36:51 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190620153651.GD4642@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-3-git-send-email-pvanleeuwen@insidesecure.com>
 <20190619121502.GA3254@kwain>
 <AM6PR09MB352354E57F4CB4C9FD6F39B4D2E50@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190620130609.GA4642@kwain>
 <AM6PR09MB352373E464F758B8D69C62B6D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR09MB352373E464F758B8D69C62B6D2E40@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Thu, Jun 20, 2019 at 02:47:30PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Wed, Jun 19, 2019 at 02:22:19PM +0000, Pascal Van Leeuwen wrote:
> > > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > > On Tue, Jun 18, 2019 at 07:56:23AM +0200, Pascal van Leeuwen wrote:
> > > > >
> > > > >  			/* Fallback to the old firmware location for the
> > > > > @@ -294,6 +291,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
> > > > >
> > > > > +	dev_info(priv->dev, "EIP(1)97 HW init: burst size %d beats, using %d pipe(s) and %d
> > > > ring(s)",
> > > > > +			16, priv->config.pes, priv->config.rings);
> > > >
> > > > Adding custom messages in the kernel log has to be done carefully.
> > > > Although it's not considered stable it could be difficult to rework
> > > > later on. Also, if all driver were to print custom messages the log
> > > > would be very hard to read. But you can also argue that a single message
> > > > when probing a driver is also done in other drivers.
> > > >
> > > Hmm ... don't know what the rules for logging are exactly, but from my
> > > perspective, I'm dealing with a zillion different HW configurations so
> > > some feedback whether the driver detected the *correct* HW parameters -
> > > or actually, whether I stuffed the correct image into my FPGA :o) - is
> > > very convenient to have. And not just for my local development, but also
> > > to debug deployments in the field at customer sites.
> > 
> > I understand it can be convenient, it's just a matter of having a
> > logging message for you that will end up in many builds for many users.
> > They do not necessarily have the same needs. So it's a matter of
> > compromise, one or two messages at boot can be OK, more is likely to
> > become an issue.
> > 
> OK, got it. So I have to stuff all my logging into one or two very long lines :-P
> (just kidding)

Hehe :-)

> > > > For this one particularly, the probe could fail later on. So if we were
> > > > to add this output, it should be done at the very end of the probe.
> > > >
> > > I'm in doubt about this one. I understand that you want to reduce the
> > > logging in that case, but at the same time that message can convey
> > > information as to WHY the probing fails later on ...
> > 
> > If the drivers fails to probe, there will be other messages. In that
> > case is this one really needed? I'm not sure.
> > 
> > > i.e. if it detects, say, 4 pipes on a device that, in fact, only has
> > > 2, then that may be the very reason for the FW init to fail later on.
> > 
> > In case of failure you'll need anyway to debug and understand what's
> > going on. By adding new prints, or enabling debugging messages.
> > 
> If it fails for me locally, I can do that. If it somehow fails "in the field",
> I think most people won't be able to recompile their own Linux
> kernel with debug messages let alone add their own debug messages.
> 
> Anyway, I'll just make everything dev_dbg to avoid further discussion.

There's always the 'loglevel' command-line parameter, but yes, that
probably do not cover all cases.

> > > So in my humble opinion, version was the correct location, it
> > > is just a confusing name. (i.e. you can have many *versions*
> > > of an EIP197B, for instance ...)
> > 
> > That would be an issue with the driver. We named the 'version' given the
> > knowledge we had of the h/w, it might not be specific enough. Or maybe
> > you can think of this as being a "family of engine versions". The idea
> > is the version is what the h/w is capable of, not how it's being
> > wired/accessed.
> 
> Well ... I want to avoid the whole discussion about the naming of the
> variable (which can be trivially changed) and what the intention may
> have been,  if you allow me.
> 
> Fact is ... this variable is what receives .data / .driver_data from the 
> OF or PCI match table. So it is a means of conveying a value that is 
> specific to the table entry that was matched. No more,  no less.
> In "your" device tree case you want to distinguish between 
> Armada 39x, Armada 7K/8K and Armada 9K. In "my" PCI case I
> want to potentially distinguish multiple FPGA boards/images.
> 
> It wouldn't make much sense to me to do the vendor/subvendor/
> device/subdevice decoding all over again in my probe routine.
> So what exactly is so very wrong with the way I'm doing this?

I think what is an issue for me here is the re-use of a variable
intended to only control the version of the engine. And the way this
engine is probed/accessed has nothing to do with this.

One solution, that I think would work for both of us, would be to still
keep this information in .data (as you did) but to organise it within a
struct so that the version information is split from the way the device
is accessed. Would that work for you?

('version' can probably be a value and not a bitfield then).

I'm sorry if the discussion about this point seems disproportionate
compared to technical aspect, but I would like to avoid possible
maintenance issues in the future with conditions looking like:

  if (version == EIP197)

Which could easily be merged in a big patch but would break the
existing, given on what h/w the submitter tested the changes.

> > > > > @@ -1189,13 +1249,12 @@ static int safexcel_remove(struct platform_device *pdev)
> > > > >  		.compatible = "inside-secure,safexcel-eip197d",
> > > > >  		.data = (void *)EIP197D,
> > > > >  	},
> > > > > +	/* For backward compatibiliry and intended for generic use */
> > > > >  	{
> > > > > -		/* Deprecated. Kept for backward compatibility. */
> > > > >  		.compatible = "inside-secure,safexcel-eip97",
> > > > >  		.data = (void *)EIP97IES,
> > > > >  	},
> > > > >  	{
> > > > > -		/* Deprecated. Kept for backward compatibility. */
> > > > >  		.compatible = "inside-secure,safexcel-eip197",
> > > > >  		.data = (void *)EIP197B,
> > > > >  	},
> > > >
> > > > I'm not sure about this. The compatible should describe what the
> > > > hardware is, and the driver can then decide if it has special things to
> > > > do or not. It is not used to configure the driver to be used with a
> > > > generic use or not.
> > > >
> > > > Do you have a practical reason to do this?
> > >
> > > I have to admit I don't fully understand how these compatible
> > > strings work. All I wanted to achieve is provide some generic
> > > device tree entry to point to this driver, to be used for
> > > devices other than Marvell. No need to convey b/d that way
> > > (or even eip97/197, for that matter) as that can all be probed.
> > 
> > Compatibles are used in device trees, which intend to be a description
> > of the hardware (not the configuration of how the hardware should be
> > used). So we can't have a compatible being a restricted configuration
> > use of a given hardware. But I think here you're right, and there is
> > room for a more generic eip197 compatible: the b/d versions only have
> > few differences and are part of the same family, so we can have a very
> > specific compatible plus a "family" one. Something like:
> > 
> >   compatible = "inside-secure,safexcel-eip197d", "inside-secure,safexcel-eip197";
> > 
> > This would need to be in a separated patch, and this should be
> > documented in:
> > Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> > 
> Ok, then I'll leave that part untouched for now.
> (I only changed the comments anyway ...)

Feel free to send a patch later on :) (Even if it's only about the
comment, it is important as well).

> > > > > +static struct pci_driver crypto_is_pci_driver = {
> > > > > +	.name          = "crypto-safexcel",
> > > > > +	.id_table      = crypto_is_pci_ids,
> > > > > +	.probe         = crypto_is_pci_probe,
> > > > > +	.remove        = crypto_is_pci_remove,
> > > > > +};
> > > >
> > > > More generally, you should protect all the PCI specific functions and
> > > > definitions between #ifdef.
> > > >
> > > I asked the mailing list and the answer was I should NOT use #ifdef,
> > > but instead use IS_ENABLED to *only* remove relevant function bodies.
> > > Which is exactly what I did (or tried to do, anyway).
> > 
> > My bad, I realise there's a mistake in my comment. That should have
> > been: you should protect all the PCI specific functions and definitions
> > with #if IS_ENABLED(...). When part of a function should be excluded
> > you can use if(IS_ENABLED(...)), but if the entire function can be left
> > out, #if is the way to go.
> > 
> Ok  #if instead of if or #ifdef,that makes sense.
> So can I just put all the PCI stuff into one big #if then?

Right.

You may also want to check for for helpers only defined if CONFIG_OF
is selected, as the driver could be compiled for a kernel with only
CONFIG_PCI enabled.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

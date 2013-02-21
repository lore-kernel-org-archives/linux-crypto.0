From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 16:23:10 +0100
Message-ID: <20130221152310.GA1906@pengutronix.de>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
 <201302211259.26763.arnd@arndb.de>
 <CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
 <201302211440.59577.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: javier Martin <javier.martin@vista-silicon.com>,
	kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3BUPXU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 10:23:20 -0500
Content-Disposition: inline
In-Reply-To: <201302211440.59577.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 21, 2013 at 02:40:59PM +0000, Arnd Bergmann wrote:
> On Thursday 21 February 2013, javier Martin wrote:
> > We know about the existence of DT and the constant migration process
> > that is taking place towards it.
> > 
> > Moreover we are strongly interested in converting the Visstrim SM10
> > platform to DT. Unfortunately, there are several issues that need to
> > be solved so that Visstrim M10 can be fully converted to DT:
> > - full SoC camera DT support
> > - DT support for ov7670
> > - pinctrl support for i.MX27
> 
> Ok, I see. Full device tree support is certainly asking too much then.
> 
> > Furthermore, we have limited resources at the moment and we have to
> > decide priorities. But having an hybrid platform-DT support is our
> > next task for Visstrim M10.
> 
> Ok, cool.
> 
> > However, I understand your concern about new drivers having DT
> > support. Maybe a good approach could be that I added compile-tested
> > only DT support for this driver and remove platform support for
> > mainline submission (although we maintain it internally in our
> > repositories).
> > 
> > What do you think?
> 
> Sounds good. Since it sounds like the hardware is available in all
> imx27 device, maybe someone else can test your driver on an imx27
> board that already has partial DT support when you add it to
> arch/arm/boot/dts/imx27.dtsi?
> 
> Is there any reason why an imx27 based board would not support this
> driver? Are there any other chips that could use it, e.g. imx25 or
> imx6?

Neither i.MX25, i.MX31 nor i.MX21 have this unit. I haven't checked the
others, but I assume this is i.MX27 only.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

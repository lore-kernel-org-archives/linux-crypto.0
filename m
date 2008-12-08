From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v4]
Date: Mon, 8 Dec 2008 12:12:39 -0600
Message-ID: <20081208121239.756f3e38.kim.phillips@freescale.com>
References: <1228256232.4770.47.camel@jhsiao-usb>
	<20081204193256.12dbc306.kim.phillips@freescale.com>
	<200812050641.13753.sr@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, jhsiao@amcc.com,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stefan Roese <sr@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:39755 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYLHSJc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 13:09:32 -0500
In-Reply-To: <200812050641.13753.sr@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 5 Dec 2008 06:41:13 +0100
Stefan Roese <sr@denx.de> wrote:

> On Friday 05 December 2008, Kim Phillips wrote:
> > > diff --git a/arch/powerpc/boot/dts/canyonlands.dts
> > > b/arch/powerpc/boot/dts/canyonlands.dts index 79fe412..b0f0096 100644
> > > --- a/arch/powerpc/boot/dts/canyonlands.dts
> > > +++ b/arch/powerpc/boot/dts/canyonlands.dts
> > > @@ -116,6 +116,13 @@
> > >  			dcr-reg = <0x010 0x002>;
> > >  		};
> > >
> > > +		CRYPTO: crypto@180000 {
> > > +			compatible = "amcc,ppc460ex-crypto", "amcc,ppc4xx-crypto";
> > > +			reg = <4 0x00180000 0x80400>;
> > > +			interrupt-parent = <&UIC0>;
> > > +			interrupts = <0x1d 0x4>;
> >
> > that's odd, according to the current canyonlands.dts, irq 0x1d is
> > already assigned to UART2 (and the request_irq this driver makes
> > doesn't specify a shared flag).
> 
> UART2 is using irq 0x1d from UIC1. Using 0x1d/UIC0 is correct for Security 
> EIP-94 according to the latest users manual. No sharing needed.

ok, I didn't notice the machine had four interrupt controllers (!),
thanks.

Kim

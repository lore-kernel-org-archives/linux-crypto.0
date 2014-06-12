From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
Date: Thu, 12 Jun 2014 18:14:28 -0500
Message-ID: <20140612181428.949158069d52c9eac10f1911@freescale.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
	<20140611175306.c537deb1fe570d5d90b77d86@freescale.com>
	<57d6ef23d7194c90a9931d3e421b0e00@BL2PR03MB466.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:15929
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbaFLXTl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:41 -0400
In-Reply-To: <57d6ef23d7194c90a9931d3e421b0e00@BL2PR03MB466.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 12 Jun 2014 04:56:14 -0500
Gupta Ruchika-R66431 <ruchika.gupta@freescale.com> wrote:

> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Thursday, June 12, 2014 4:23 AM
> > >  	/* Check to see if QI present. If so, enable */
> > > -	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
> > > -				  CTPR_QI_MASK);
> > > +	ctrlpriv->qi_present =
> > > +			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
> > > +				  CTPR_MS_QI_MASK);
> > 
> > alignment
> Ok. I will correct it.
> > 
> > >  	/* Report "alive" for developer to see */
> > > -	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
> > > +	dev_info(dev, "device ID = 0x%08x (Era %d)\n", caam_id,
> > >  		 caam_get_era());
> > 
> > Why are we dropping the upper 32 bits here?
> The upper 32 bit contain the IP ID of SEC, the major number and the minor number while the lower 32 bits have the details of the compile option, integration and configuration options of SEC. So device ID is actually contained only in the most significant 32 bits which are being printed here.
> 

that may be true, but you're changing the driver to not display
information it previously did, in a seemingly totally unrelated
manner.  This is a regression IMO - if you want the compile options
specifically labelled in the display, then do that, but don't
start hiding information from the user just because the h/w didn't
pass an endianness change properly.

Kim

From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto:caam - Modify width of few read only registers
Date: Thu, 12 Jun 2014 09:56:14 +0000
Message-ID: <57d6ef23d7194c90a9931d3e421b0e00@BL2PR03MB466.namprd03.prod.outlook.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
 <20140611175306.c537deb1fe570d5d90b77d86@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:59444
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932784AbaFLJ4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2014 05:56:35 -0400
In-Reply-To: <20140611175306.c537deb1fe570d5d90b77d86@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim

> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Thursday, June 12, 2014 4:23 AM
> To: Gupta Ruchika-R66431
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
> 
> On Tue, 29 Apr 2014 15:34:37 +0530
> Ruchika Gupta <ruchika.gupta@freescale.com> wrote:
> 
> > Few read only registers like CHAVID, CTPR etc were wrongly defined as
> > 64 bit registers. This functioned properly on the powerpc platforms.
> > However ARM SoC's wouldn't function correctly if these registers are
> > defined as 64 bit. So correcting the definition to two 32 bit registers.
> 
> please rewrite, adding the details of the problem posted toward the end of
> this thread, e.g., what registers are affected, and how that renders
> MCFGR:DWT ineffective in this case.
Ok. I will add the details in the commit message.
> 
> >  	/* Check to see if QI present. If so, enable */
> > -	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
> > -				  CTPR_QI_MASK);
> > +	ctrlpriv->qi_present =
> > +			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
> > +				  CTPR_MS_QI_MASK);
> 
> alignment
Ok. I will correct it.
> 
> >  	/* Report "alive" for developer to see */
> > -	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
> > +	dev_info(dev, "device ID = 0x%08x (Era %d)\n", caam_id,
> >  		 caam_get_era());
> 
> Why are we dropping the upper 32 bits here?
The upper 32 bit contain the IP ID of SEC, the major number and the minor number while the lower 32 bits have the details of the compile option, integration and configuration options of SEC. So device ID is actually contained only in the most significant 32 bits which are being printed here.

Ruchika
> 
> Kim

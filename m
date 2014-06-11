From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
Date: Wed, 11 Jun 2014 17:53:06 -0500
Message-ID: <20140611175306.c537deb1fe570d5d90b77d86@freescale.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:41443
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbaFKW6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jun 2014 18:58:31 -0400
In-Reply-To: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 29 Apr 2014 15:34:37 +0530
Ruchika Gupta <ruchika.gupta@freescale.com> wrote:

> Few read only registers like CHAVID, CTPR etc were wrongly defined
> as 64 bit registers. This functioned properly on the powerpc platforms.
> However ARM SoC's wouldn't function correctly if these registers
> are defined as 64 bit. So correcting the definition to two 32 bit registers.

please rewrite, adding the details of the problem posted toward the
end of this thread, e.g., what registers are affected, and how that
renders MCFGR:DWT ineffective in this case.

>  	/* Check to see if QI present. If so, enable */
> -	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
> -				  CTPR_QI_MASK);
> +	ctrlpriv->qi_present =
> +			!!(rd_reg32(&topregs->ctrl.perfmon.comp_parms_ms) &
> +				  CTPR_MS_QI_MASK);

alignment

>  	/* Report "alive" for developer to see */
> -	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
> +	dev_info(dev, "device ID = 0x%08x (Era %d)\n", caam_id,
>  		 caam_get_era());

Why are we dropping the upper 32 bits here?

Kim

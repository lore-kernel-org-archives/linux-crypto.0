From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
Date: Tue, 6 May 2014 15:32:05 -0500
Message-ID: <20140506153205.1fae83075e1c15e5495b4a87@freescale.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
	<20140501154513.70af868ccc62066a2d5a8870@freescale.com>
	<b1d6e178b6d44b749e4f41f9ff2a9152@BL2PR03MB466.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:52388
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754191AbaEFUxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 16:53:13 -0400
In-Reply-To: <b1d6e178b6d44b749e4f41f9ff2a9152@BL2PR03MB466.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 6 May 2014 05:11:23 -0500
Gupta Ruchika-R66431 <ruchika.gupta@freescale.com> wrote:

> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Friday, May 02, 2014 2:15 AM
> > 
> > On Tue, 29 Apr 2014 15:34:37 +0530
> > Ruchika Gupta <ruchika.gupta@freescale.com> wrote:
> > 
> > > Few read only registers like CHAVID, CTPR etc were wrongly defined as
> > > 64 bit registers. This functioned properly on the powerpc platforms.
> > > However ARM SoC's wouldn't function correctly if these registers are
> > > defined as 64 bit.
> > 
> > why wouldn't they function correctly?
> 
> The SEC IP guide states these registers as 2 32 bit registers. So register definition in

I'm looking at LS2100A's SEC reference manual, it clearly has the
CHAVID defined as one, single 64-bit register.  What are you looking
at?

> crypto code should also have them defined as 32 bit registers. Defining them as 64 bit in this case would be incorrect.
> 
> Endianness of the CAAM IP varies with core's endiannes. In ARM SoC's , CAAM block is also little endian.  So in case the 2 - 32 bit registers are treated as a 64 bit register, the result would be word swapped as compared to powerpc platforms. As a result, the reads won't return the right result.
> 
> For eg.
> For the 2 32 bit registers CHAVID_MS(at address 0x0) and CHAVID_LS(address 0x4) , if core reads them as 64 bit word, 
> 
> In powerpc (big endian) platform -
> CHAVID_MS would be available in most significant portion of the 64 bit word.
> CHAVID_LS would be the in least significant portion.
> This is as expected.
> 
> In ARM (little endian) platform, 64 bit read would result in -
> CHAVID_MS in Least significant portion of the word and 
> CHAVID_LS in the most significant location. 
> This result is word swapped and  the value read wouldn't be correct.

hmm, have you looked at using the DWT "Double Word Transpose" bit in
the MCFGR?

Kim

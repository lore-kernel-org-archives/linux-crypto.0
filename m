From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: RE: [PATCH] crypto:caam - Modify width of few read only registers
Date: Wed, 11 Jun 2014 04:36:49 +0000
Message-ID: <fe1c6071301043d9b362840c6dfdf0cf@BL2PR03MB466.namprd03.prod.outlook.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
	<20140501154513.70af868ccc62066a2d5a8870@freescale.com>
	<b1d6e178b6d44b749e4f41f9ff2a9152@BL2PR03MB466.namprd03.prod.outlook.com>
	<20140506153205.1fae83075e1c15e5495b4a87@freescale.com>
	<058f7766878a469888c9dc3ab80e47d4@BL2PR03MB466.namprd03.prod.outlook.com>
 <20140507185442.02b5ec3c4e40baf6ef8d13b4@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:36901
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750893AbaFKEgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jun 2014 00:36:52 -0400
In-Reply-To: <20140507185442.02b5ec3c4e40baf6ef8d13b4@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim,

I contacted the Hardware folks and below is the statement from them :

Unfortunately setting the DWT bit will also affect the operation of 
job descriptors, so I don't think that is a viable option.  It looks 
like you will have to change the software to access all 32-bit 
registers as 32-bit quantities, even if two 32-bit registers appear to 
be two halves of a 64-bit register.  If you do that it will work 
correctly on both big-endian and little-endian SoCs.

Regards,
Ruchika
> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Thursday, May 08, 2014 5:25 AM
> To: Gupta Ruchika-R66431
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au
> Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
> 
> On Tue, 6 May 2014 23:09:15 -0500
> Gupta Ruchika-R66431 <ruchika.gupta@freescale.com> wrote:
> 
> > Hi Kim,
> 
> Hi Ruchika,
> 
> > > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > > Sent: Wednesday, May 07, 2014 2:02 AM
> > >
> > > On Tue, 6 May 2014 05:11:23 -0500
> > > Gupta Ruchika-R66431 <ruchika.gupta@freescale.com> wrote:
> > >
> > > > > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > > > > Sent: Friday, May 02, 2014 2:15 AM
> > > > >
> > > > > On Tue, 29 Apr 2014 15:34:37 +0530 Ruchika Gupta
> > > > > <ruchika.gupta@freescale.com> wrote:
> > > > >
> > > > > > Few read only registers like CHAVID, CTPR etc were wrongly
> > > > > > defined as
> > > > > > 64 bit registers. This functioned properly on the powerpc
> platforms.
> > > > > > However ARM SoC's wouldn't function correctly if these
> > > > > > registers are defined as 64 bit.
> > > > >
> > > > > why wouldn't they function correctly?
> > > >
> > > > The SEC IP guide states these registers as 2 32 bit registers. So
> > > > register definition in
> > >
> > > I'm looking at LS2100A's SEC reference manual, it clearly has the
> > > CHAVID defined as one, single 64-bit register.  What are you looking at?
> >
> > In the first version of guide they were defined as 64 bit. They were later
> changed to 32 bit once issue was reported while testing on emulator. Latest
> guide of LS2100 has them modified. A register width column has also been
> added in the memory map now.
> 
> I love how they try to cover up h/w bugs by amending the documentation...
> 
> > > > crypto code should also have them defined as 32 bit registers.
> > > > Defining
> > > them as 64 bit in this case would be incorrect.
> > > >
> > > > Endianness of the CAAM IP varies with core's endiannes. In ARM
> > > > SoC's , CAAM
> > > block is also little endian.  So in case the 2 - 32 bit registers
> > > are treated as a 64 bit register, the result would be word swapped
> > > as compared to powerpc platforms. As a result, the reads won't return the
> right result.
> > > >
> > > > For eg.
> > > > For the 2 32 bit registers CHAVID_MS(at address 0x0) and
> > > > CHAVID_LS(address 0x4) , if core reads them as 64 bit word,
> > > >
> > > > In powerpc (big endian) platform - CHAVID_MS would be available in
> > > > most significant portion of the 64 bit
> > > word.
> > > > CHAVID_LS would be the in least significant portion.
> > > > This is as expected.
> > > >
> > > > In ARM (little endian) platform, 64 bit read would result in -
> > > > CHAVID_MS in Least significant portion of the word and CHAVID_LS
> > > > in the most significant location.
> > > > This result is word swapped and  the value read wouldn't be correct.
> > >
> > > hmm, have you looked at using the DWT "Double Word Transpose" bit in
> > > the MCFGR?
> > I am not able to locate this bit in MCFGR.
> 
> It's bit 19:  "Double Word Transpose. Setting this bit affects whether the
> two words within a Dword are transposed when a double-word register is
> accessed, ..."
> 
> > However there are few swapping options present in Job ring configuration
> and QICTL registers. Are you referring to these ?
> 
> no.  Plus, those don't sound relevant to accessing CHAVID...
> 
> > Since these are 32 bit registers by nature, shouldn't we just treat them as
> 32 bit instead of enabling the swapping option .
> 
> depends on the definition of 'treat':  I'd rather still use the superior 64-
> bit accessors on all possible arches, if we can get them to work.
> 
> Kim

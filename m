From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [BUG?] crypto: caam: little/big endianness on ARM vs PPC
Date: Tue, 4 Aug 2015 20:55:50 +0300
Message-ID: <55C0FCA6.6070806@freescale.com>
References: <20150615155907.GC7947@pengutronix.de>
 <CALHpu34FHKTHr-2TZ-6Tmctev3WjBVTKfDbr6TYOJiOt+yDvfQ@mail.gmail.com>
 <20150615171848.GP7557@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-kernel@vger.kernel.org>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	<linux-crypto@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	<linux-arm-kernel@lists.infradead.org>,
	Scott Wood <scottwood@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jon Nettleton <jon.nettleton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:46528
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753915AbbHDR4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 13:56:02 -0400
In-Reply-To: <20150615171848.GP7557@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/15/2015 8:18 PM, Russell King - ARM Linux wrote:
> On Mon, Jun 15, 2015 at 06:33:17PM +0200, Jon Nettleton wrote:
>> Funny enough I tackled this problem over the weekend as well.  My
>> approach was to switch the driver over to use the *_relaxed() io
>> functions and then special case the bits missing from the various
>> ARCHs.  Basically adding setbits32 and clrbits32 for !PPC
>> architectures and letting PPC and ARM share a writeq/readq set of
>> functions.  I left the existing LITTLE_ENDIAN special case until I
>> could verify if it was needed, or had been tested.
> 
> I'll follow up here with what I've mentioned elsewhere, and some further
> thoughts.
> 
> I think this shows the dangers of using struct { } to define register
> offsets.  Let's start here:
> 
> /*
>  * caam_job_ring - direct job ring setup
>  * 1-4 possible per instantiation, base + 1000/2000/3000/4000
>  * Padded out to 0x1000
>  */
> struct caam_job_ring {
>         /* Input ring */
>         u64 inpring_base;       /* IRBAx -  Input desc ring baseaddr */
>         u32 rsvd1;
> 
> Apparently, this is a CPU-endian 64-bit value (it's not defined using
> le64 or be64 which would "fix" it's endian.)

The IP in question (CAAM) has different endianness, depending on the
integration on the SoC. Would it be ok to #define a sec64 type which
would translate either to be64 or le64?

> 
> The second question, which comes up in light of the breakage that's
> being reported is: is this really a 64-bit register, or is it a pair
> of 32-bit registers side-by-side?
> 
> The documentation I'm looking at doesn't document the register at
> base + 0x1000, but documents the one at base + 0x1004, and the one
> at 0x1004 is given the name "IRBAR0_LS", which presumably stands
> for "input ring base address register 0, least significant".
> 
> As the code originally stood for PPC, IRBAR0_LS is also at 0x1004,
> but appears to be big endian.
> 
> On ARM, IRBAR0_LS appears at the same address, but is little endian.

In some cases, CAAM endianness does not match CPU endianness (for e.g.
i.MX). We're talking about default endianness here, both for CAAM and
for CPU - no CONFIG_CPU_{BIG,LITTLE}_ENDIAN.
ARCH	CPU	CAAM	SoC
PPC	BIG	BIG	P4080, T4240 etc.
ARM	LITTLE	LITTLE	LS1021A, LS2085A etc.
ARM	LITTLE	BIG	i.MX6, i.MX7, LS1043A

> This is *not* a 64-bit register at all, but is a pair of 32-bit
> registers side by side.  Moreover, readq() should not be used - no
> amount of arch mangling could ever produce a sane readq() which
> coped with this.
> 
> So, the CAAM code is buggy in this regard: using readq() here when
> endian-portability is required is wrong.  It's got to be two 32-bit
> reads or two 32-bit writes in the appropriate endian.
> 
> Also, note that there's a big difference between __raw_readl() and
> readl_relaxed().  readl_relaxed() is always little-endian.  __raw_readl()
> is god-knows-what-the-archtecture-decides endian.  Switching PPC
> drivers from __raw_readl() to readl_relaxed() is really not a good
> idea unless someone from the PPC camp reviews and tests the code.
> 
> So, what I'd suggest is just fixing rd_reg64() and wr_reg64() to do
> the right thing: keeping the two 32-bit words in the same order
> irrespective of the endian-ness, and staying with the __raw_*
> accessors until PPC people can look at this.

Agree that the I/O accessors need to be revisited.
Unfortunately, the proposed change does not work for LE CAAM (LS1021A).
I'll send a fix.

Thanks,
Horia

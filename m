From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
Date: Sat, 24 May 2014 14:34:46 +0200
Message-ID: <201405241434.46807.marex@denx.de>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com> <058f7766878a469888c9dc3ab80e47d4@BL2PR03MB466.namprd03.prod.outlook.com> <20140507185442.02b5ec3c4e40baf6ef8d13b4@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Gupta Ruchika-R66431" <ruchika.gupta@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35003 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEXRvj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 13:51:39 -0400
In-Reply-To: <20140507185442.02b5ec3c4e40baf6ef8d13b4@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 08, 2014 at 01:54:42 AM, Kim Phillips wrote:
[...]

> > In the first version of guide they were defined as 64 bit. They were
> > later changed to 32 bit once issue was reported while testing on
> > emulator. Latest guide of LS2100 has them modified. A register width
> > column has also been added in the memory map now.
> 
> I love how they try to cover up h/w bugs by amending the
> documentation...

Typical, yes :-(

[...]

> > Since these are 32 bit registers by nature, shouldn't we just treat them
> > as 32 bit instead of enabling the swapping option .
> 
> depends on the definition of 'treat':  I'd rather still use the
> superior 64-bit accessors on all possible arches, if we can get them
> to work.

Was there any resolution for this problem ?

Best regards,
Marek Vasut

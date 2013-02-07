From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH] crypto: caam - set RDB bit in security configuration
 register
Date: Thu, 7 Feb 2013 04:38:46 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B9417E955@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1360151266-28428-1-git-send-email-vakul@freescale.com>
 <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Liu Shengzhou-B36685 <B36685@freescale.com>,
	Porosanu Alexandru-B06830 <B06830@freescale.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4326 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab3BGEiw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Feb 2013 23:38:52 -0500
In-Reply-To: <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Thursday, February 07, 2013 7:03 AM
> To: Garg Vakul-B16394
> Cc: linux-crypto@vger.kernel.org; Herbert Xu; David S. Miller; Liu
> Shengzhou-B36685; Porosanu Alexandru-B06830; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] crypto: caam - set RDB bit in security configuration
> register
> 
> On Wed, 6 Feb 2013 17:17:46 +0530
> Vakul Garg <vakul@freescale.com> wrote:
> 
> > This change is required for post SEC-5.0 devices which have RNG4.
> > Setting RDB
> 
> wrap your commit message text to 75 chars
Ok 


> 
> > in security configuration register allows CAAM to use the "Random Data
> Buffer"
> > to be filled by a single request. The Random Data Buffer is large
> > enough for ten packets to get their IVs from a single request. If the
> > Random Data Buffer is not enabled, then each IV causes a separate
> > request, and RNG4 hardware cannot keep up resulting in lower IPSEC
> throughput.
> 
> Linux kernel IPSec or another IPSEC stack?  how much lower?

We measured USDPAA IPSEC throughput to be 1.9 times better on T4240 with this change.

> 
> > +	if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
> > +		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
> > +
> 
> this belongs further down - at the end of the RNG4 initialization
> section.

Ok

> 
> Kim

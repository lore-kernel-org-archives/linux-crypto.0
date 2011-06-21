From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hwrng: ppc4xx - add support for ppc4xx TRNG
Date: Tue, 21 Jun 2011 13:59:55 -0500
Message-ID: <1308682795.4954.42.camel@calx>
References: <20110621121955.GB2414@zod.rchland.ibm.com>
	 <1308671762.4954.0.camel@calx>
	 <20110621113836.fbf14710.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:54412 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab1FUTAA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2011 15:00:00 -0400
In-Reply-To: <20110621113836.fbf14710.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-06-21 at 11:38 -0500, Kim Phillips wrote:
> [adding linux-crypto]
> 
> On Tue, 21 Jun 2011 10:56:02 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > On Tue, 2011-06-21 at 08:19 -0400, Josh Boyer wrote:
> > > +static struct hwrng ppc4xx_rng = {
> > > +	.name = MODULE_NAME,
> > > +	.data_present = ppc4xx_rng_data_present,
> > > +	.data_read = ppc4xx_rng_data_read,
> > > +};
> 
> under what criteria should new hwrng drivers use the new hwrng API?

If the RNG is not fundamentally u32-based (like this one), it's strongly
encouraged. We'll eventually abandon the old interface, but I don't
think there's any hurry.

-- 
Mathematics is the supreme nostalgia of our time.

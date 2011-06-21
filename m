From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] hwrng: ppc4xx - add support for ppc4xx TRNG
Date: Tue, 21 Jun 2011 11:38:36 -0500
Message-ID: <20110621113836.fbf14710.kim.phillips@freescale.com>
References: <20110621121955.GB2414@zod.rchland.ibm.com>
	<1308671762.4954.0.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	<linuxppc-dev@lists.ozlabs.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:32364
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab1FUQjC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2011 12:39:02 -0400
In-Reply-To: <1308671762.4954.0.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[adding linux-crypto]

On Tue, 21 Jun 2011 10:56:02 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Tue, 2011-06-21 at 08:19 -0400, Josh Boyer wrote:
> > +static struct hwrng ppc4xx_rng = {
> > +	.name = MODULE_NAME,
> > +	.data_present = ppc4xx_rng_data_present,
> > +	.data_read = ppc4xx_rng_data_read,
> > +};

under what criteria should new hwrng drivers use the new hwrng API?

See commit bb347d9 "hwrng: virtio-rng - Convert to new API".

Kim

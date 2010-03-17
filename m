From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/2] sec: omap sha1 & md5 driver
Date: Wed, 17 Mar 2010 13:49:36 -0700
Message-ID: <20100317204936.GK2900@atomide.com>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
 <2f55c827126b6cfc3b09b5b6df7532fc5ea4403e.1268830685.git.dmitry.kasatkin@nokia.com>
 <20100317170805.GB3857@gandalf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Felipe Balbi <me@felipebalbi.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54431 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0CQUsW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Mar 2010 16:48:22 -0400
Content-Disposition: inline
In-Reply-To: <20100317170805.GB3857@gandalf>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Felipe Balbi <me@felipebalbi.com> [100317 10:04]:
> On Wed, Mar 17, 2010 at 03:12:50PM +0200, Dmitry Kasatkin wrote:
> > Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
> > was not ported to new crypto APIs and removed from the source tree.
> 
> > +#include <linux/version.h>
> > +#include <linux/err.h>
> > +#include <linux/device.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/errno.h>
> > +#include <linux/cryptohash.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel.h>
> > +#include <linux/clk.h>
> > +#include <linux/irq.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/delay.h>
> > +#include <linux/crypto.h>
> > +#include <crypto/scatterwalk.h>
> > +#include <crypto/algapi.h>
> > +#include <crypto/sha.h>
> > +#include <crypto/hash.h>
> > +#include <crypto/internal/hash.h>
> > +
> > +#include <plat/cpu.h>
> > +#include <plat/dma.h>
> > +#include <mach/irqs.h>
> > +#include <mach/io.h>
> > +

Please include linux/io.h instead of mach/io.h.

Tony

From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v4 7/8] crypto: omap-sham: Add code to use dmaengine API
Date: Tue, 20 Nov 2012 17:10:28 -0800
Message-ID: <20121121011027.GT18567@atomide.com>
References: <1353351301-6453-1-git-send-email-mgreer@animalcreek.com>
 <1353351301-6453-8-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64011 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818Ab2KUBKe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2012 20:10:34 -0500
Content-Disposition: inline
In-Reply-To: <1353351301-6453-8-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Mark A. Greer <mgreer@animalcreek.com> [121119 10:58]:
> @@ -27,6 +29,10 @@
>  #include <linux/platform_device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/dma-mapping.h>
> +#ifndef OMAP_SHAM_DMA_PRIVATE
> +#include <linux/dmaengine.h>
> +#include <linux/omap-dma.h>
> +#endif
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
>  #include <linux/crypto.h>

I think you should be able to drop the OMAP_SHAM_DMA_PRIVATE
from the include after I'll post one more patch to move the
omap private DMA header to linux/dma-mapping.h that we already
have until the dmaengine conversion is completed.

> @@ -37,8 +43,10 @@
>  #include <crypto/hash.h>
>  #include <crypto/internal/hash.h>
>  
> +#ifdef OMAP_SHAM_DMA_PRIVATE
>  #include <plat/dma.h>

And then this can be dropped.

>  #include <mach/irqs.h>

But this needs to go too, as we have that only for omap1 when
ARM multiplatform is enabled for omap2+. The interrupt should
be passed in platform_data.

However, if there are some indirect dependencies for omap1,
you can just put it into ifdef CONFIG_ARCH_OMAP1 for now.

There's probably the same issue for the other series you
posted.

Regards,

Tony

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: reorder OMAP TRNG driver code
Date: Wed, 21 Aug 2013 21:51:42 +1000
Message-ID: <20130821115142.GI23287@gondor.apana.org.au>
References: <1377022073-28198-1-git-send-email-olof@lixom.net>
 <52144E4C.4050405@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olof Johansson <olof@lixom.net>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38653 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457Ab3HULvr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 07:51:47 -0400
Content-Disposition: inline
In-Reply-To: <52144E4C.4050405@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 21, 2013 at 10:51:16AM +0530, Lokesh Vutla wrote:
> Hi Olof,
> On Tuesday 20 August 2013 11:37 PM, Olof Johansson wrote:
> > The newly added omap4 support in the driver was added without
> > consideration for building older configs. When building omap1_defconfig,
> > it resulted in:
> > 
> > drivers/char/hw_random/omap-rng.c:190:12: warning: 'omap4_rng_init' defined but not used [-Wunused-function]
> > drivers/char/hw_random/omap-rng.c:215:13: warning: 'omap4_rng_cleanup' defined but not used [-Wunused-function]
> > drivers/char/hw_random/omap-rng.c:251:20: warning: 'omap4_rng_irq' defined but not used [-Wunused-function]
> > 
> > Move the code around so it is grouped with its operations struct, which
> > for the omap4 case means also under the #ifdef CONFIG_OF, where it needs
> > to be.
> > 
> Missed testing this. Thanks for the patch.
> Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

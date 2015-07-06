From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/10] crypto: omap-aes: Use BIT() macro
Date: Mon, 6 Jul 2015 15:42:24 +0800
Message-ID: <20150706074224.GD20192@gondor.apana.org.au>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-5-git-send-email-lokeshvutla@ti.com>
 <20150702075903.GD4033@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lokesh Vutla <lokeshvutla@ti.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, t-kristo@ti.com, nsekhar@ti.com
To: Felipe Balbi <balbi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60520 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbGFHm2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 03:42:28 -0400
Content-Disposition: inline
In-Reply-To: <20150702075903.GD4033@saruman.tx.rr.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 02:59:03AM -0500, Felipe Balbi wrote:
> On Thu, Jul 02, 2015 at 10:48:34AM +0530, Lokesh Vutla wrote:
> > Use BIT()/GENMASK() macros for all register definitions instead of
> > hand-writing bit masks.
> > 
> > Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> > ---
> >  drivers/crypto/omap-aes.c |   36 ++++++++++++++++++------------------
> >  1 file changed, 18 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> > index 96fc7f7..d974ab6 100644
> > --- a/drivers/crypto/omap-aes.c
> > +++ b/drivers/crypto/omap-aes.c
> > @@ -52,30 +52,30 @@
> >  #define AES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
> >  
> >  #define AES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
> > -#define AES_REG_CTRL_CTR_WIDTH_MASK	(3 << 7)
> > -#define AES_REG_CTRL_CTR_WIDTH_32		(0 << 7)
> > -#define AES_REG_CTRL_CTR_WIDTH_64		(1 << 7)
> > -#define AES_REG_CTRL_CTR_WIDTH_96		(2 << 7)
> > -#define AES_REG_CTRL_CTR_WIDTH_128		(3 << 7)
> > -#define AES_REG_CTRL_CTR		(1 << 6)
> > -#define AES_REG_CTRL_CBC		(1 << 5)
> > -#define AES_REG_CTRL_KEY_SIZE		(3 << 3)
> > -#define AES_REG_CTRL_DIRECTION		(1 << 2)
> > -#define AES_REG_CTRL_INPUT_READY	(1 << 1)
> > -#define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
> > -#define AES_REG_CTRL_MASK		FLD_MASK(24, 2)
> > +#define AES_REG_CTRL_CTR_WIDTH_MASK	GENMASK(8, 7)
> > +#define AES_REG_CTRL_CTR_WIDTH_32	0
> > +#define AES_REG_CTRL_CTR_WIDTH_64	BIT(7)
> > +#define AES_REG_CTRL_CTR_WIDTH_96	BIT(8)
> > +#define AES_REG_CTRL_CTR_WIDTH_128	GENMASK(8, 7)
> > +#define AES_REG_CTRL_CTR		BIT(6)
> > +#define AES_REG_CTRL_CBC		BIT(5)
> > +#define AES_REG_CTRL_KEY_SIZE		GENMASK(4, 3)
> > +#define AES_REG_CTRL_DIRECTION		BIT(2)
> > +#define AES_REG_CTRL_INPUT_READY	BIT(1)
> > +#define AES_REG_CTRL_OUTPUT_READY	BIT(0)
> > +#define AES_REG_CTRL_MASK		GENMASK(24, 2)
> 
> this was defined a couple patches ago, why didn't you define it with
> GENMASK() to start with ?

Indeed, this should be folded into the earlier patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

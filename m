From: Oleksij Rempel <ore@pengutronix.de>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 19 Jul 2017 20:13:03 +0200
Message-ID: <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
 <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50849 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754360AbdGSSNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 14:13:12 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 04:53:21PM +0000, Horia Geantă wrote:
> On 7/19/2017 7:32 PM, Oleksij Rempel wrote:
> > On Wed, Jul 19, 2017 at 12:49:47PM +0000, Horia Geantă wrote:
> >> On 7/19/2017 10:45 AM, Oleksij Rempel wrote:
> >>> According documentation, it is NIST certified TRNG.
> >>> So, set high quality to let the HWRNG framework automatically use it.
> >>>
> >>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >>> ---
> >>>  drivers/crypto/caam/caamrng.c | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> >>> index 41398da3edf4..684c0bc88dfd 100644
> >>> --- a/drivers/crypto/caam/caamrng.c
> >>> +++ b/drivers/crypto/caam/caamrng.c
> >>> @@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +/*
> >>> + * hwrng register struct
> >>> + * The trng is suppost to have 100% entropy, and thus
> >>> + * we register with a very high quality value.
> >>> + */
> >>>  static struct hwrng caam_rng = {
> >>>  	.name		= "rng-caam",
> >>>  	.cleanup	= caam_cleanup,
> >>>  	.read		= caam_read,
> >>> +	.quality	= 999,
> >>
> >> Why not 1024, i.e. where is 999 coming from?
> > 
> > It comes from s390-trng.c driver.
> > Should I use 1024 instead?
> > 
> AFAICT the range for quality is from 0 to 1024 (no entropy -> perfect
> entropy).
> 
> 1024 should be used since I'd expect a HW TRNG to provide perfect
> entropy unless otherwise stated.

I assume 1024 can be given only on verified HW with accessible verilog
files and compared with resulting chip :)
May be this would be a good example https://www.sifive.com/

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

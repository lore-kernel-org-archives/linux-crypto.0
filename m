From: Oleksij Rempel <ore@pengutronix.de>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 19 Jul 2017 18:32:49 +0200
Message-ID: <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 12:49:47PM +0000, Horia Geantă wrote:
> On 7/19/2017 10:45 AM, Oleksij Rempel wrote:
> > According documentation, it is NIST certified TRNG.
> > So, set high quality to let the HWRNG framework automatically use it.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/crypto/caam/caamrng.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> > index 41398da3edf4..684c0bc88dfd 100644
> > --- a/drivers/crypto/caam/caamrng.c
> > +++ b/drivers/crypto/caam/caamrng.c
> > @@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * hwrng register struct
> > + * The trng is suppost to have 100% entropy, and thus
> > + * we register with a very high quality value.
> > + */
> >  static struct hwrng caam_rng = {
> >  	.name		= "rng-caam",
> >  	.cleanup	= caam_cleanup,
> >  	.read		= caam_read,
> > +	.quality	= 999,
> 
> Why not 1024, i.e. where is 999 coming from?

It comes from s390-trng.c driver.
Should I use 1024 instead?

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

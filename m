From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Mon, 7 Mar 2016 14:03:04 +0100
Message-ID: <20160307130304.GA791@pengutronix.de>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
 <1456761156-27664-3-git-send-email-s.trumtrar@pengutronix.de>
 <CAOMZO5BN-1U6vX0HAHWX30t+23NnqEpOw6AttSgvqaZnq=cN6Q@mail.gmail.com>
 <20160229213850.GS2613@pengutronix.de>
 <CAOMZO5BLYumOrBuoB5-RgzLAJ=o4zp9ocv4jcZRy=p6Pky1SyQ@mail.gmail.com>
 <20160301074937.GU2613@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fabio Estevam <festevam@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Matt Mackall <mpm@selenic.com>,
	Shawn Guo <shawnguo@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48233 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbcCGNDT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 08:03:19 -0500
Content-Disposition: inline
In-Reply-To: <20160301074937.GU2613@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Tue, Mar 01, 2016 at 08:49:37AM +0100, Uwe Kleine-K=F6nig wrote:
> Hello Fabio,
>=20
> On Mon, Feb 29, 2016 at 08:54:19PM -0300, Fabio Estevam wrote:
> > On Mon, Feb 29, 2016 at 6:38 PM, Uwe Kleine-K=F6nig
> > <u.kleine-koenig@pengutronix.de> wrote:
> > > On Mon, Feb 29, 2016 at 06:16:50PM -0300, Fabio Estevam wrote:
> > >> On Mon, Feb 29, 2016 at 12:52 PM, Steffen Trumtrar
> > >> <s.trumtrar@pengutronix.de> wrote:
> > >>
> > >> > +       ret =3D clk_prepare_enable(rngc->clk);
> > >> > +       if (ret)
> > >> > +               return ret;
> > >> > +
> > >> > +       rngc->irq =3D platform_get_irq(pdev, 0);
> > >> > +       if (!rngc->irq) {
> > >> > +               dev_err(&pdev->dev, "FSL RNGC couldn't get irq=
\n");
> > >> > +               clk_disable_unprepare(rngc->clk);
> > >> > +
> > >> > +               return ret;
> > >>
> > >> You are returning the wrong error code here:
> > >>
> > >> Better do like this:
> > >>
> > >>        rngc->irq =3D platform_get_irq(pdev, 0);
> > >>        if (rngc->irq < 0) {
> > >
> > > rngc->irq is unsigned, so this is never true.
> > >
> > >>                dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n"=
);
> > >>                clk_disable_unprepare(rngc->clk);
> > >>                return rngc->irq;
> > >>        }
> > >
> > > So here comes my better approach:
> >=20
> > As irq is only used inside probe it can be removed from struct mxc_=
rngc.
>=20
> Good idea.
>=20

Actually it is currently used in the mxc_rngc_init function, but I thin=
k I can
just move the call there into the probe function and get rid of the irq=
 in the
struct.

> > Or maybe like this:
> >=20
> >          ret =3D platform_get_irq(pdev, 0);
> >          if (ret < 0) {
> >                  dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n")=
;
> >                  clk_disable_unprepare(rngc->clk);
> >                  return ret;
> >          }
>=20

This looks better, yes. I will change that, of course.

> Some people think platform_get_irq returning 0 should be handled as
> error.

And who is right? drivers/of/unittest.c checks for irq < 0 for example.

Thanks,
Steffen

--=20
Pengutronix e.K.                           |                           =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |

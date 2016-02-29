From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Mon, 29 Feb 2016 22:38:50 +0100
Message-ID: <20160229213850.GS2613@pengutronix.de>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
 <1456761156-27664-3-git-send-email-s.trumtrar@pengutronix.de>
 <CAOMZO5BN-1U6vX0HAHWX30t+23NnqEpOw6AttSgvqaZnq=cN6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
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
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57860 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbcB2VjC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Feb 2016 16:39:02 -0500
Content-Disposition: inline
In-Reply-To: <CAOMZO5BN-1U6vX0HAHWX30t+23NnqEpOw6AttSgvqaZnq=cN6Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 29, 2016 at 06:16:50PM -0300, Fabio Estevam wrote:
> On Mon, Feb 29, 2016 at 12:52 PM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
>=20
> > +       ret =3D clk_prepare_enable(rngc->clk);
> > +       if (ret)
> > +               return ret;
> > +
> > +       rngc->irq =3D platform_get_irq(pdev, 0);
> > +       if (!rngc->irq) {
> > +               dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
> > +               clk_disable_unprepare(rngc->clk);
> > +
> > +               return ret;
>=20
> You are returning the wrong error code here:
>=20
> Better do like this:
>=20
>        rngc->irq =3D platform_get_irq(pdev, 0);
>        if (rngc->irq < 0) {

rngc->irq is unsigned, so this is never true.

>                dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
>                clk_disable_unprepare(rngc->clk);
>                return rngc->irq;
>        }

So here comes my better approach:

	ret =3D platform_get_irq(pdev, 0);
	if (ret <=3D 0) {
		if (ret =3D=3D 0)
			ret =3D -EINVAL;
		dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
		clk_disable_unprepare(rngc->clk);

		return ret;
	}

	rngc->irq =3D ret;

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |

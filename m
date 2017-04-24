From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Mon, 24 Apr 2017 10:57:32 +0200
Message-ID: <20170424085731.wbg53t5lcler4mng@kwain>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-3-antoine.tenart@free-electrons.com>
 <8ff65d6a5e5e4d388d3c5a384e4f5fd6@IL-EXCH01.marvell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="usqqbxv35p7yf3fg"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com"
        <gregory.clement@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "thomas.petazzoni@free-electrons.com"
        <thomas.petazzoni@free-electrons.com>,
        "boris.brezillon@free-electrons.com"
        <boris.brezillon@free-electrons.com>,
        Ofer Heifetz <oferh@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        "robin.mu
To: Igal Liberman <igall@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50764 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167247AbdDXI5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 04:57:34 -0400
Content-Disposition: inline
In-Reply-To: <8ff65d6a5e5e4d388d3c5a384e4f5fd6@IL-EXCH01.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--usqqbxv35p7yf3fg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Igal,

On Mon, Apr 24, 2017 at 08:50:32AM +0000, Igal Liberman wrote:
> [...]
>=20
> > +	priv->clk =3D of_clk_get(dev->of_node, 0);
> > +	if (!IS_ERR(priv->clk)) {
> > +		ret =3D clk_prepare_enable(priv->clk);
> > +		if (ret) {
> > +			dev_err(dev, "unable to enable clk (%d)\n", ret);
> > +			return ret;
> > +		}
> > +	} else {
> > +		/* The clock isn't mandatory */
> > +		if (PTR_ERR(priv->clk) =3D=3D -EPROBE_DEFER)
> > +			return -EPROBE_DEFER;
> > +	}
> > +
> > +	ret =3D dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>=20
> The correct address width of the engine in Marvell SoCs is 40bit.

Oops. I'll update.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--usqqbxv35p7yf3fg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJY/b37AAoJEFxNi8it27zYTQQP/0Ykn9mwFxs8jglmAb8r4buC
H/j09jFdy+Tg4Ez9iutaoqLfjriLRxF10J6fYAJsrm0nHzTwRbeaOY+HYpurVeTU
HtICQKreiHf1r3acwDaqwFVl1r94arP6Pk11MDlGKqOmDEg7iDHhExYzp9ZLrwFv
+hwcF4PusL9nizEwx9qTcfW1J6KhP+9EwbmqpCAH1xKxOtetCNfOlzFE7+iLpO5e
BnrZQJJySaZaIo92p0K2yy67ZoPt3bv5PvI0z6dYmSQv8tWLVCzQiupBRHU2lV6e
P8fNE7IFrROoBpUx74UQzQD2OFmPWU6FyWmYsYikRqJ4GxO+rqklExDf6T6bRPN+
IbV8cwImiT8NVySZWnp44O1SbEjPMk8iBovOJIcFB7gEEyRuhc6gshZDfGNNLrql
mnQlTU011qGfRUy7y/GtmQN1MYxkCiaoi8uvE086B2rei/Po+Mdz3EN8ze+UcQ+/
DcaCUNxsTiaiWPBhpca/BT0xTjMqyxxXzEe5ie9gjYGv5Ft9zMHXOm4K2jDRCwKk
21aDCqSdwpCsBB0CeCMVT1Whr68RJmUwE22Yc6JhSxN0VI53K6bozMuhfaMGnKR4
d6P8KD2Z2t0l50CuO2pE7ThtKdFPzpscy26yFVXsI8bkoqs5FLrCg7nnEPl8XNjw
WaoOkLk0GmTjrHcASVgl
=epT4
-----END PGP SIGNATURE-----

--usqqbxv35p7yf3fg--

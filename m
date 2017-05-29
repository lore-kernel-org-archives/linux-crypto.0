From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 10/11] crypto: sun4i-ss: fix large block size support
Date: Mon, 29 May 2017 11:15:04 +0200
Message-ID: <20170529091503.GB3169@kwain>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
 <20170524190652.13278-11-antoine.tenart@free-electrons.com>
 <20170526145501.GA19284@Red>
 <20170529080944.GA3169@kwain>
 <20170529082931.ocoatlnpl7fvtgfu@flea.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53951 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdE2JPP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:15:15 -0400
Content-Disposition: inline
In-Reply-To: <20170529082931.ocoatlnpl7fvtgfu@flea.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

On Mon, May 29, 2017 at 10:29:31AM +0200, Maxime Ripard wrote:
> On Mon, May 29, 2017 at 10:09:44AM +0200, Antoine Tenart wrote:
> > > Which speed are the SS clocks ?
> >=20
> > The AHB SS clk is running at 300 MHz and the SS clk at 150 MHz. SS clk
> > is at the expected rate but the AHB SS clk has a higher rate that what's
> > expected.
> >=20
> > In the probing function only the SS clk rate is explicitly set. I tried
> > to set the AHB clk rate as well and removed the delays. This didn't fix
> > the framework selftests at boot time. Is there any reason the AHB SS clk
> > rate isn't explicitly set when probing the driver? (Should it?)
>=20
> It probably shouldn't.
>=20
> The AHB clock is shared by most of the drivers, some of them actually
> using that clock to generate their signals.
>=20
> You would have to unbreak all those drivers first, which is probably
> not needed at all. I haven't seen a case where a block had a module
> clock and did care for its AHB clock rate.

OK, makes sense.

I'll wait for Corentin to test the series, and I'll send a v2 only
fixing the typos then.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZK+aXAAoJEFxNi8it27zYvOwQAI0RNBfV+r0PofXYXNtDBLG+
pLq9g4aQx7PrwdOSDbVMxuYMqgxLiW6S4J1iqK2HYeuzyQ3MP6Oa61SjVK0Vw2WN
UTZjkiHsauMAkNbA99tIFjXqp4PYnHpz7Q0ZOlovfJceH3HRumyUYeLs4qcbGVFl
ICAHwo9Qrse3m7WUR8dVDbo/NxXg8dPUe0JH2m3AFJxsj63Risedfg7FP6HfnkY6
LDUQ90jvXUVqmI2/13q3lvb1W4xA48XUKqLItX5AhSVN33DAFaCIttXnaGToVLVU
Oy1kMzMUIoDetED7+JDY7kQI9vOKRKtVipwMvr0oK8wK5NlOR0Eq6WFNrWVsGtEc
fcb3gFUBUz4V8LlwVRDd6jf0BqRNuuJ44/EFmkPqYEqhRZ7vS2YR32YvQ0da36xG
cnx4R6lCEFCs1C+ljtJHwfMPrQ0JP6Ib1VwHlzh3gy6DkARy6nTSHYX9cXCo0Rh9
Grmwin+G9jQ8X/fiP3i4hMXiv8aXD+IAkQawsjEfEfZQRGyjBXdED4+YReMc8BFT
ViPts533mMiEAF8jw+9f6D1NLI3S1ISUsgAEJcEWF/dnYz81IgAlPIe/rRIy++Iz
H6v6F1bksEzKIdk68lzZjh1Vrxgovn/26+D0BR34Rhqw+6W9N3XJv9cyLhF0G7DZ
dpB16iR8uVVArQiRmw73
=vXyt
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 12/12] ARM: sun5i: add a cryptographic engine node
Date: Tue, 30 May 2017 08:51:47 +0200
Message-ID: <20170530065147.GB5802@kwain>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
 <20170529202738.2167-13-antoine.tenart@free-electrons.com>
 <20170530064811.idsv66mvfyh2tyiw@flea.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        clabbe.montjoie@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41806 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdE3Gv6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:51:58 -0400
Content-Disposition: inline
In-Reply-To: <20170530064811.idsv66mvfyh2tyiw@flea.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

On Tue, May 30, 2017 at 08:48:11AM +0200, Maxime Ripard wrote:
> On Mon, May 29, 2017 at 10:27:38PM +0200, Antoine Tenart wrote:
> > Add a node for the cryptographic engine that can be found on sun5i SoCs.
> > This cryptographic engine is compatible with the Allwinner cryptographic
> > accelerator driver.
> >=20
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/sun5i.dtsi | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
> > index 5175f9cc9bed..9bfefa2c7224 100644
> > --- a/arch/arm/boot/dts/sun5i.dtsi
> > +++ b/arch/arm/boot/dts/sun5i.dtsi
> > @@ -355,6 +355,14 @@
> >  			status =3D "disabled";
> >  		};
> > =20
> > +		crypto: crypto-engine@01c15000 {
> > +			compatible =3D "allwinner,sun4i-a10-crypto";
>=20
> you should add a SoC-specific compatible here, just so that if we ever
> need to fix something in there we don't have to update our DT.

Sure. I'll also make patches for the other sunXi crypto nodes as they do
no have SoC-specific compatibles either.

Thanks,
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZLRaDAAoJEFxNi8it27zY/gwP/0jI1YU1qbMfNCnBmaL28vnh
xZH0h/ro9yalzOWuO+U84wObCQhs3aLsVEcJbVVfFl+P8YTxTpNmB4ie42MEk+XS
taRqdpCtom6fQ3tacUPCEISSJgMcgpHvr87+DYtHejSYBJpwNhtynxjSriCN4pdv
bpwoIq5BTeBAMji4ocEhlKV1JfzlLufmAbj6dpISTIxvkKoFtUsBP9p/YwAntbN8
i7pagKqSE+KENygrzrR4tfZxvEC9xAeB8SmJ5hevwPInpBDpm0E0Knjp8DrEj4Q1
2nvMgxeAn7Rul9IAL6djXmbFfWbegXohrIbRdN44fZaHcL2IWoWRV0t3vcaXq48c
cf5XvKh82zugM0mda8yPYMi7kvvaRExrU/lum1izrDEmO+J9f+GWvXxCa9kjAcql
66Wj65VDEyJFJ4AMk/D7fTkQbVFWaNuj9v5azKr5xhSiq8jui25lOQj2fIddlSBm
HlNPmgpS0241cNqxnaLxx7KGs4PjO5yyeq876Adb5j4PyGykU9TzKvk6wncg/e8H
SLi6uqVEVTb9pgRk8IUQlvKkL1YIsImESNsIbntVikdsNV5jMF2c5dpLaXnxy29C
3oPnY+Fr8KU7Bs/UesyKjeGRQO+l5/3HGNHPS/xUz30q+GwGx2aaybdZ0+KJFgGy
0RZabavMr5SxT9EY2M1u
=w47F
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--

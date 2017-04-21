From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Fri, 21 Apr 2017 14:05:52 +0200
Message-ID: <20170421120552.phujnp4csesm6p3h@kwain>
References: <20170419071418.18995-1-antoine.tenart@free-electrons.com>
 <20170419071418.18995-3-antoine.tenart@free-electrons.com>
 <20170421073056.GA2041@Red>
 <20170421092935.fszux3qg5hbwwobj@kwain>
 <20170421113645.GA18422@Red>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wiaffaqdldqcfrub"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41982 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1038742AbdDUMFz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 08:05:55 -0400
Content-Disposition: inline
In-Reply-To: <20170421113645.GA18422@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--wiaffaqdldqcfrub
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2017 at 01:36:45PM +0200, Corentin Labbe wrote:
> > > > +	memset(ipad + keylen, 0, blocksize - keylen);
> > > > +	memcpy(opad, ipad, blocksize);
> > > > +
> > > > +	for (i =3D 0; i < blocksize; i++) {
> > > > +		ipad[i] ^=3D 0x36;
> > > > +		opad[i] ^=3D 0x5c;
> > >=20
> > > What are these constant ?
> >=20
> > They are defined in the HMAC RFC, as ipad and opad values. See
> > https://www.ietf.org/rfc/rfc2104.txt.
> >=20
>=20
> Since many driver use them, I think defining them in include/ should be d=
one (HMAC_IPAD/HMAC_OPAD)
> I will send a patch for it.

OK, I'll send a following up patch on this driver when your series is
merged.

Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--wiaffaqdldqcfrub
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY+fWgAAoJEFxNi8it27zYs/8P/jl1WRKBurOoED3pvrF/UlmH
t8TOTpO1iRe9jWB6u5ZqtH8cEKy8WtXQeguAbwrrRDLinhPBE4eVhkmnYY60Z3/G
+SSg8ZxCW8Ep3ya3Q6mq3FCXT91IV9UnYR+6YR1NXOQDFdp3/7JG44DMycAFak72
Me/0sh9eRtKQq/QDjHvTxaShn/QYZBdGJVeaMBCOYwsXXJQTqdnGyJ5fnESWMXOv
mQLswYSNSntKfYNmvHlZOw/vaPM6j/hbQ65jr94ukdlzUTURn3ocd+qMgpqXIp90
vNzX26rMc85JBrF+0jzgXJF9qwsSTc6jeD71Odp6LUmHwuEw9E7qSj49TvFi0Chn
bPczj8Shl+te+Ee+H2no2aQrdhPl+DqkkRupupIksn/rR5SiLRcwRvbg8NlYCZvz
k1nrPsRyPeXpa2xbBffHSEK1Ws6ZM92DUTuMcnPYrLtR318/zqzHZmeugg1+eWqA
jLtf99mXEm0UPv44F9sEWiFDslI+yTKFbsU+O879DI0P9lJ8dZQJhBA08J/G5n7L
lRs6AfsSaEhYbcvDZxWcsyFuH+7mQh8NJwhIDWN97TaLDFy43ZH55bjJH2mEerlV
b+aJWc4MwH8y2JRVekH8l+ffpPtOBCFK7XBAQmhCgIfx64JakSnckLWGW4rrGt2V
0cVadFkhy7UDSFjAmvrs
=FfZ7
-----END PGP SIGNATURE-----

--wiaffaqdldqcfrub--

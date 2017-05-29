From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v6 4/5] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Mon, 29 May 2017 11:21:07 +0200
Message-ID: <20170529092107.GA24048@kwain>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
 <20170524141035.21031-5-antoine.tenart@free-electrons.com>
 <CANc+2y46roki41fd_yURACWeXNzjyBEk_kOwiLEr_D=zFyaWuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, jason@lakedaemon.net,
        andrew@lunn.ch,
        Gregory Clement <gregory.clement@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        oferh@marvell.com, Igal Liberman <igall@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, robin.murphy@arm.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:54497 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdE2JVY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:21:24 -0400
Content-Disposition: inline
In-Reply-To: <CANc+2y46roki41fd_yURACWeXNzjyBEk_kOwiLEr_D=zFyaWuQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sun, May 28, 2017 at 11:09:43AM +0530, PrasannaKumar Muralidharan wrote:
> On 24 May 2017 at 19:40, Antoine Tenart
> <antoine.tenart@free-electrons.com> wrote:
> > Add support for Inside Secure SafeXcel EIP197 cryptographic engine,
> > which can be found on Marvell Armada 7k and 8k boards. This driver
> > currently implements: ecb(aes), cbc(aes), sha1, sha224, sha256 and
> > hmac(sah1) algorithms.
> >
> > Two firmwares are needed for this engine to work. Their are mostly used
> > for more advanced operations than the ones supported (as of now), but we
> > still need them to pass the data to the internal cryptographic engine.
> >
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>=20
> As you have got help from other people for testing, wouldn't it be
> nice to add tested-by tag?

Well, they're listed as authors of the driver: not only they helped to
test it but they developed parts of it. The tested-by tag doesn't apply
here.

Thanks,
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZK+gDAAoJEFxNi8it27zYY9EP+weB+07DYAdjl6UT5FM8/dRa
XvbSDqbU0a5lqLwZBd5Zv884JPPNqKwAkMJAXt2cmjaQoH2RrijkVlI9N45sKH9q
SSGXWj3yNvSX77kCev9Rb+Y4fl95cLuT6qkz14v9I/USPVfrXTXWDQvYbg55N8tQ
mjJYRW2jhHwhXNBVT2Vcd4/5QtACxMPcdOH7Rtw77V1nmijBB+6/CbtFif12IGic
jta2XS443JhnJTMWd4jgNz22h46i2cKL1fA7oj6xW3QP/CVj15YN+yTU6OHczOt0
3YoGaa1U9fmJSYgGYuDtDGnXIUftQMk3dWgdV2RYUFdEWJsM5OCET0XvsP16yMbU
+sYmdAnb+tcmi7t0lm3IhCIaZ+jYM2Bd98Y5hnmLG3H2/5qjhcYpTqmA+qQDyUz5
jM73GX5FZLKxxWhaKAZCj75SDGf15eOQiMNLCYxsbPWFEZrmQtOypVK09+kghto6
HGcsj1dUHhjCqN0TwUxz7NQYR6UohJAKS3sI4U7mj7YzlN6tr/1XWz0JNoD2XxfZ
RCwVm2yyV0cjOgnnwR+rPOwdxTXV7oZQXp5W6325c+IDt6WVU/rPcWQnQ8QV8zLq
fkAhS1kCaWM9VgoXmEaDago3uuUxcD5UKU5dT8j0fsnbWW5Dg5M/ScRXliIk2Q4Y
JzcG1P7FCixoj1QRpfmq
=Fldh
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--

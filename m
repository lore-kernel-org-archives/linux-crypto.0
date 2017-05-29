From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 10/11] crypto: sun4i-ss: fix large block size support
Date: Mon, 29 May 2017 10:09:44 +0200
Message-ID: <20170529080944.GA3169@kwain>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
 <20170524190652.13278-11-antoine.tenart@free-electrons.com>
 <20170526145501.GA19284@Red>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52090 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdE2IKB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 04:10:01 -0400
Content-Disposition: inline
In-Reply-To: <20170526145501.GA19284@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Corentin,

On Fri, May 26, 2017 at 04:55:01PM +0200, Corentin Labbe wrote:
> On Wed, May 24, 2017 at 09:06:51PM +0200, Antoine Tenart wrote:
> > =20
> > +	/*
> > +	 * The datasheet isn't very clear about when to retrieve the digest. =
The
> > +	 * bit SS_DATA_END is cleared when the engine has processed the data =
and
> > +	 * when the digest is computed *but* it doesn't mean the digest is
> > +	 * available in the diesgt registers. Hence the delay to be sure we c=
an
>=20
> Small typo here (diesgt/digest)

Oops. I'll fix it.

> This behaviour is very strange since I didnt get it on other platform.
> Could you give me the board name where you get it ?

I used a CHIP (sun5i-r8-chip).

> Does any wmb() after the writel(..SS_DATA_END..) do the trick ?

Nope. I tried this and it didn't help.

> Which speed are the SS clocks ?

The AHB SS clk is running at 300 MHz and the SS clk at 150 MHz. SS clk
is at the expected rate but the AHB SS clk has a higher rate that what's
expected.

In the probing function only the SS clk rate is explicitly set. I tried
to set the AHB clk rate as well and removed the delays. This didn't fix
the framework selftests at boot time. Is there any reason the AHB SS clk
rate isn't explicitly set when probing the driver? (Should it?)

> Anyway the whole serie seems good, I will test it just after this weekend.

Let me know if your tests went well, I'll send a v2 fixing the typo
below then (and setting the AHB SS clk rate explicitly if needed).

Thanks,
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZK9dGAAoJEFxNi8it27zY8RoP/3n+8tSmXiwqIJH/DYIhOhml
fFRueP4TqFQzvdybeqpqNd/zmlnhbHOfKR4OVYhqgkWs7bnAU99wfHB0IdE71JwP
9ykaO6c0m0jCPBsx0cC4uooywcSXvqGAxMXukW2vp96QiikYVvddRD1Arhl5ypKb
DcAQMWFr0S9cy1VxlXt4es8F+kTGonG0ZTUts14p362N5el+w5VEgXLcATXiFV8Q
7mzflLFowgFwfT769I1162WD6MEvsz3f6OcyN2lD1yV8mA2XGRJrj+ryUWL9Cy9J
KflS92C/14rVcqy4u3GyDdHKV4cSR2SmKxkP0bGLVu6otBvsARXk5e2iSbHx+xS7
gILTNuTrTohiKFH/gkwImNItrvyrPGv8AS6EFX3H27LnNYbvMalD0c11OxbrCXkQ
7HhXrFo+UD97BaaRZ47xkcrAH0huocSH4cbxgLZg1yDTxnNW5bZO5BR8Z17wFCsc
GX+nz2y5j67AKGdu25yZUydi60D1hhudrkpqmgtyHWAG+VGeR6dIN+xw2rw6Clsj
qs9HfwIOGEPP2oVXIzbTGM5l3EZ7t5KHqPKWdZs41HRFlRBmrX0Z7vqo8OtDhosv
pj4XobctOEWCGKwxODqMrOz2y81dIkfe8WoOgzcRnlawmOi41Jkxpnsf3ieOoBjI
IX3pO6smM4k5rd1X0vPp
=WwMo
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

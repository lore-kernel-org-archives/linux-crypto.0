From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH] crypto: inside-secure - do not parse the dma mask from dt
Date: Fri, 23 Jun 2017 16:35:42 +0200
Message-ID: <20170623143542.GA26089@kwain>
References: <20170623140525.360-1-antoine.tenart@free-electrons.com>
 <CAK8P3a2U58VE6nn1fA79W+Vx7Y2fTn5-fLS6h4TQ5Qw_8ZcRtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        oferh@marvell.com, igall@marvell.com, nadavh@marvell.com,
        linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46711 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWOfo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:35:44 -0400
Content-Disposition: inline
In-Reply-To: <CAK8P3a2U58VE6nn1fA79W+Vx7Y2fTn5-fLS6h4TQ5Qw_8ZcRtg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Fri, Jun 23, 2017 at 04:29:58PM +0200, Arnd Bergmann wrote:
> On Fri, Jun 23, 2017 at 4:05 PM, Antoine Tenart
> <antoine.tenart@free-electrons.com> wrote:
> >
> > As pointed our by Arnd (ic Cc) parsing the dma mask from the dt node of
> > the engine is broken. This property will be removed from the device
> > trees having an inside-secure safexcel engine node. While the
> > inside-secure won't fail because of this (as it will fallback to a
> > 64 bits mask), the code handling the dma-mask property is dead. This
> > patch removes it.
>=20
> Do we also need a patch to update the DT binding?

You're right, we need to update the bindings documentation. I'll send a
patch for this as well.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZTSc+AAoJEFxNi8it27zYuKIP/1TwgWRKK3IcWF94rpIiBlnp
UAwJAEY9TcO8MjXpsEM95Zv89sz3bpAaan04hWNaeobjei02nGPsMYhqc37YzYsF
/SDS9pZlpNwB9XVzWPKeiSS4CTixu8quUa5ln4uK1cJHuVj5KgqErweg3sOPVrNW
2ggHePmpQvSODSxV//gV7NDV8KWBKkaMD6wOZpInm9gd5Qo6xGJGiz/nM+OhZkmf
eDgZhqoy8m5L6rCZxfXxk+PKlurwdJxjlaO3xyfyDSthIiWVgpgR//pfaY+m31hN
DigFo5ba06jSxnU1abl2/jlPEnOLdPXNRVDxqJ4MPTwKFsdBhFABrQg4GlZ5iw7Z
iVIWtXg+/7XQdBJHePCKEF4rQLDiaIne45PayCUJ6f04mDfIpwWWTNkgJnqCMg+Z
rrp4SSHs4FYDceZfRIXQ09KaO2vu/0WO/SOJdlmakUiutyCFrgYnFpAJLQ+QX5+e
0BYVKE8xqw2XFzTaG0xS8MnG8ZCNsNu9nVnN0pvNKDkAtIjA11JaJFTPJmQ8r7Y9
ale3M5CbmiWT1sNEQZrBgbAQYHJMrAiebWEuL3qVFjOT2Zu7ulc/+8JEj51t7Ejm
RRejr5pgbXWutnds8mM6iEtWK4xr3JCrPevxX8zJ9hFqp9bXeMlqY/j9No1ZKT5e
RVSl/QzmflujUqj4bL9S
=w0Lo
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--

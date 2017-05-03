From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Wed, 3 May 2017 16:03:12 +0200
Message-ID: <20170503140312.civ5uxkksauhqfyp@kwain>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-3-antoine.tenart@free-electrons.com>
 <6ed16e7e-7f7a-795f-ee82-d2d97c3a5540@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x2pkhhp3vywp3dhj"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        oferh@marvell.com, linux-arm-kernel@lists.infradead.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46099 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdECODO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 10:03:14 -0400
Content-Disposition: inline
In-Reply-To: <6ed16e7e-7f7a-795f-ee82-d2d97c3a5540@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--x2pkhhp3vywp3dhj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robin,

On Wed, May 03, 2017 at 12:57:25PM +0100, Robin Murphy wrote:
> On 24/04/17 08:54, Antoine Tenart wrote:
> > +
> > +#include <asm/dma-mapping.h>
>=20
> <linux/dma-mapping.h> everywhere, please.
>=20
> Other than that, the DMA aspects all look much nicer now, thanks.

I'll update and resend a series when the next -rc1 is out.

Thanks!
Antoine

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--x2pkhhp3vywp3dhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJZCeMeAAoJEFxNi8it27zYMLsP/0MgFd4Ec23L5egh43VVQwIu
krNpKUcHUVppxoMbF6N0qhI6kujHuFZv29IuKVGPaegfBmEMfrYlLii1t8dfyb0b
wIzif+kXItddyu1lo5nJLEl/4mYWTIDompkhCzFbTIrP8iXvjUAJmgavMGfttTVd
0+GYBJEyJKTOpcWt/SAylaO2NbBpTaqfVtf/LvsPb1dmd8Zf0EVgKxB+lKRlLygV
49J/74rMqLKEiYbmgS22O5YuLqTHpS6Y92MOcQZ/TA4PNvNoV9SUcMbHPdN4IW+I
vuOzPCqAcvkkA4Re2mztLWsxc/+IuvZGSMhY6bMWyb2pR5+MAhO5Gzk2SD9hPF5P
BirupTG042VfiIpFdo0rTQMZBd9dl6amq+j/NfijTYYX0VU5eVryR4/jfZXPbARA
dpx0KfguwYsYAnY/hLbLpTEfdE2NHVZEuTffJ3X/T21Dy+NLO8yb7+1M+OtUXoij
C9/28ly6ZprpVvFaykGxeiZKAJ1uFufa5xrxvloTPJD8VpWAM+1KaGaaEY/wShAB
PrG9WNfpAD5pRJaamsR1j1pjXBhhByVJDUk84XXGFxXRqdXqtikSux1yTSyONyS6
PmVdvWxvluDwhIPo/Pw46Ur+zOGV9xw85VKdXqMZlyoX8W7JM5ggVv11K+LunYcU
w2i/yhoWXpYx4MLGupQM
=WLjV
-----END PGP SIGNATURE-----

--x2pkhhp3vywp3dhj--

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v3 12/13] ARM: sun5i: add a cryptographic engine node
Date: Fri, 2 Jun 2017 15:21:24 +0200
Message-ID: <20170602132124.z6wnz4n7id5zx6ya@flea.lan>
References: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
 <20170601193905.28829-13-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zoafwltavybyclio"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        clabbe.montjoie@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41518 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdFBNVf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 09:21:35 -0400
Content-Disposition: inline
In-Reply-To: <20170601193905.28829-13-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--zoafwltavybyclio
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 01, 2017 at 09:39:04PM +0200, Antoine Tenart wrote:
> Add a node for the cryptographic engine that can be found on sun5i SoCs.
> This cryptographic engine is compatible with the Allwinner cryptographic
> accelerator driver.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied, thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--zoafwltavybyclio
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZMWZTAAoJEBx+YmzsjxAgkZoQAMKXGrHrqWyWlSHbmrJyPFMJ
elMPVOU4ISBk36xY6zoneKCLQN6GiHKycYVnujQujp+Y7qcw2A4VEOxStzaVfAit
XTN2WUhk5Zd7Kw2lEwZTBYRUG8RGC5m5Xp07leuSnVs2VsC68HJ2UEAJ352vkmhV
W+aM9bu1zZciYgpf6fGi3M1E7fRVaVFJzUFG8FR2HUnZvOVps/3wQgYnnpGO8Sdj
YU0JgCyrkEIK0qOaV5LciKoEQ3mFV0TC7tbg0EQrze3mWqcdQ6F3TTEHy4u3O8sZ
8xTM3Jkd40x2gJOF7sQtLggCpcBon3v/1KfCyHgXFtmVtd34On2HQuSljFL/gh7E
yyryHfTxAO1W3apFUt61HUIKze1AbASBZYCyUpnVDR6CKhq1TC2p7MO2wq948YsP
JWNg31WSrgRuNbMF2JMDeGuq8NvKdni9oZygprRvLFm6XLGXWcXZVtfAI14Plvln
i4DP4MrtAC7fa8B1+9XlsjKLZk4GMUduPgVHldfHNDnLgO9pLwxoMqV15wD2ABBW
E792B+qNtwD4BNoXgpso0c41tz28ZMguQ/pyaIb1P/IzingDwo029GgvGgf23slB
Bd8PPODJmSPw9VmQ9SdAa0n41gJ8i4buPw7LmNg/TADisDhJ3aBp06F7/NWpDFtO
kdXffKuVQ0Sp6xVCtrMm
=PDWE
-----END PGP SIGNATURE-----

--zoafwltavybyclio--

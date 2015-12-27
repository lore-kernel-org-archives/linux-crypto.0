From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [RFC PATCH 3/5] crypto: sunxi-ss: fix dev_dbg() output type
Date: Sun, 27 Dec 2015 23:05:49 +0100
Message-ID: <20151227220549.GV30359@lukather>
References: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
 <1450787267-26836-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FclElvQKoGCylS3A"
Cc: Chen-Yu Tsai <wens@csie.org>, arnd@arndb.de, marc.zyngier@arm.com,
	catalin.marinas@arm.com, will.deacon@arm.com,
	linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753564AbbL0WFv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Dec 2015 17:05:51 -0500
Content-Disposition: inline
In-Reply-To: <1450787267-26836-4-git-send-email-andre.przywara@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--FclElvQKoGCylS3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22, 2015 at 12:27:45PM +0000, Andre Przywara wrote:
> The length parameter in this dev_dbg() call is actually a size_t,
> so use the proper type to avoid warnings when compiling for 64-bit
> architectures.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FclElvQKoGCylS3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWgGC9AAoJEBx+YmzsjxAghREQAJW6BnkfMfW2KUmlqbgz6UBk
JTKDlIrtQTDdGjlnT4xvCa9WBPMSbTdcqqlnESj8ZUiRYZ1eTRzXoyvw9DwafgfY
VUv/QO0xC/707mID4AuND8ou21PQUk6+jD0+hBUoaoxaItvdxnMWOnYJycwg0ADZ
nqpmX5/GzeE3fmMiahWl8HN6Xu0kkWjQ1cEXc0RTOKk5+b6FdEl56nnaC3TBPRJf
6MGhpJ7A9JFM3a1FSQQITLnAG272ADlowvDjisUyxpJJwdPWv+znggneKM0ZivGf
R2Gruj4YdzVEIAeTf6kQtJA1OcRl6Ti/2r7fg5PyR40+XvdceIuiNFzI5ckf7R/K
u/ZGFCvyabLaTpL9wR/E35Lw5D4JjNyUPpU5bsOgLOqOUD/+0hlXXSIGe5kGqsV3
MX4jL2L9ftIyPpRKwndxmvlEeFfcB++Q4Xy4KLxUcE/jtY5j+pql9Nz2VLWKvYCj
iU15EdqrXA/8wR1yPyKiOFSiEhbdQ++PpDFst5oWDWEb6pEN1NaY7SP4qksYWG4c
dIuCak69np89xG3z/RNN850l8/WoosTxvkC4lS+fkU9J8gy77G6BoX9u2S5gDTvo
AsOa+xmhjnUV+mWfTyEIVgv9EiKPL8S06uuxFjXeqyWAx9HvM4X8NJIJY+rrVWK9
8LThLxXJwBauJ9sMcqq9
=Wmrq
-----END PGP SIGNATURE-----

--FclElvQKoGCylS3A--

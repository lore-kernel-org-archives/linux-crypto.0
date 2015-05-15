From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v9 1/4] ARM: sun7i: dt: Add Security System to A20 SoC DTS
Date: Fri, 15 May 2015 09:31:14 +0200
Message-ID: <20150515073114.GO4004@lukather>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
 <1431608341-10936-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9DptZICXTlJ7FQ09"
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
	joe@perches.com, tj@kernel.org, arnd@arndb.de,
	boris.brezillon@free-electrons.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-sunxi@googlegroups.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431608341-10936-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--9DptZICXTlJ7FQ09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2015 at 02:58:58PM +0200, LABBE Corentin wrote:
> The Security System is a hardware cryptographic accelerator that support
> AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> It could be found on many Allwinner SoC.
>=20
> This patch enable the Security System on the Allwinner A20 SoC Device-tre=
e.
>=20
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index fdd1817..9a823ce 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -679,6 +679,14 @@
>  			status =3D "disabled";
>  		};
> =20
> +		crypto: crypto-engine@01c15000 {
> +			compatible =3D "allwinner,sun4i-a20-crypto";

This looks wrong. It's either sun4i-a10 or sun7i-a20.

It looks good otherwise.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9DptZICXTlJ7FQ09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVVaDCAAoJEBx+YmzsjxAg2ysP/0hqR6HFLACLSj2ikvh/qa9h
CkAfYvcTOCe4OuzdKPygpQoZDsVkBRiAHouIg25gaIW34FGDRNWC6p0MIqiPKK7R
kD6ZWr6esunCp37hLpYjyhOTdV182Jd3LIPMmZ5iHppf+FVdV/SHKIJd7Oa3MWK1
MehIZ93WiTJnX1/VzbJkIz5CfbSImEkrn5HO3PF+BC50KljDlot05L12ommqGNdQ
ADWj0Kbx3KPrLM3ugE2c58c5jDK36qU6OXbIj3Eks/J3JozeHOy6pD2kxPd42vw1
3EBVl6GnpIqfJ7AX8m8UkkZtn2nTT4nj3EsoOQzh3DjHOEPc5Yh+RFRKY91YZ3ea
ygZlpxzkgaxQtRlcQIMsh3dTOszKZemIt74F2A88DAkyTmEEDV5sYYb6ZL0TAfaQ
GbvjPe18CXLkQF7WpOcCw9EXs6CQPNBt8CPnAv1BV/KWD/CF4hagqUyFEWSf3+Dl
MbKSA3CAj8b0AGrk2VRCWSfVDl03eB2nxA0YVgq3j/7IqdXvb8zltmZ/8XIFtcsb
ttH+mW2fZA9M5xqfn5D59BqVewYFOJG2g6p9Riho4REtsnjH4Ep2GXVBZ3sbTjEG
UQo8B9wv6XvbWOYESz3GWVvA+H7/eMJarDzZxxt2Xqh5kn23uOFnD8rU1or8Onah
al4Q2ntc/aoqt75ysBKH
=sLMj
-----END PGP SIGNATURE-----

--9DptZICXTlJ7FQ09--

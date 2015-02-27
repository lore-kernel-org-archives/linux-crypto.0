From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Fri, 27 Feb 2015 17:01:55 +0100
Message-ID: <201502271701.56059@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <1424958600-18881-8-git-send-email-pali.rohar@gmail.com> <20150227154319.GT11056@atomide.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3567900.KJ299vtNQS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150227154319.GT11056@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart3567900.KJ299vtNQS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 27 February 2015 16:43:20 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150226 05:54]:
> > Harmattan system on Nokia N9 and N950 devices uses omap
> > crypto support. Bootloader on those devices is known that
> > it enables HW crypto support. This patch just include
> > omap36xx.dtsi directly, so aes and sham is enabled.
>=20
> Let's also remove omap36xx-hs.dtsi with this patch if no other
> users.
>=20

Removing both -hs files is done by last patch in this series.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3567900.KJ299vtNQS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTwlPQACgkQi/DJPQPkQ1L9WwCgi5bGveyREntli9FX/OZjUauZ
oDoAniRo/mlDpyOwfiptTJuL96NX/kFR
=TnWn
-----END PGP SIGNATURE-----

--nextPart3567900.KJ299vtNQS--

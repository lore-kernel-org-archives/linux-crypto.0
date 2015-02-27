From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Fri, 27 Feb 2015 13:40:44 +0100
Message-ID: <201502271340.44659@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <20150226224605.GC14117@fuloong-minipc.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3273710.BD1604DdiW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41912 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbB0Mks (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 07:40:48 -0500
In-Reply-To: <20150226224605.GC14117@fuloong-minipc.musicnaut.iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart3273710.BD1604DdiW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 26 February 2015 23:46:05 Aaro Koskinen wrote:
> Hi,
>=20
> On Thu, Feb 26, 2015 at 02:49:50PM +0100, Pali Roh=C3=A1r wrote:
> > This patch series fix crypto support for omap3 devices which
> > use DT.
> >=20
> > It enables AES and SHAM on N9/N950 and SHAM on N900. AES is
> > still disabled for N900.
>=20
> (Please format your lines somewhere near < 76 chars,
> especially in commit logs, otherwise "git log" looks ugly on
> 80 char terminals.)
>=20
> I tested these with stock bootloaders, and devices boot
> normally and I can now modprobe omap-aes (on N9 and N950) and
> omap-sham (on all three):
>=20
> 	omap-aes 480c5000.aes: OMAP AES hw accel rev: 2.6
> 	omap-sham 480c3000.sham: hw accel on OMAP rev 0.9
>=20
> However I get these when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> is not set:
>=20
> 	alg: hash: Chunking test 1 failed for omap-sha1
> 	alg: hash: Chunking test 1 failed for omap-md5
> 	alg: hash: Chunking test 1 failed for omap-hmac-sha1
> 	alg: hash: Chunking test 1 failed for omap-hmac-md5
>=20
> But that's probably unrelated to this series. For patches 1-8,
> feel free to add:
>=20
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>=20
> A.

Hi, thanks for testing!

Now I'm happy that I can load omap-aes and omap-sham drivers on=20
real n900 device, qemu n900 and after your tests also on real n9=20
and n950 without any kernel crash or oops. Of course omap-aes is=20
disabled on n900, but loading omap-aes.ko (accidentally) does not=20
hurt.

It looks like there are other parts in md5 and sha broken, but=20
first step is load & register all drivers without kernel crash.=20
And this is working now.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3273710.BD1604DdiW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTwZcwACgkQi/DJPQPkQ1JAmQCfXzpNKlP95Si6cJYsrpuDqdDo
E70AoMQeM3yvnR7qRzKkoyB8U5mFd275
=7JS1
-----END PGP SIGNATURE-----

--nextPart3273710.BD1604DdiW--

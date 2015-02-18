From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Nokia N900: omap aes is broken
Date: Wed, 18 Feb 2015 13:21:03 +0100
Message-ID: <201502181321.03774@pali>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1470245.kTVVyj3tAD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart1470245.kTVVyj3tAD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I tried to test OMAP AES driver on Nokia N900 with special Nokia=20
bootloader which enable L3 firewall for OMAP AES HW support.

I modified arch/arm/boot/dts/omap34xx-hs.dtsi file and commented=20
aes line which disable aes support in DT.

Then I booted kernel and loaded omap-aes.ko module. And I got=20
this output in dmesg:

[    0.222930] platform 480c5000.aes: Cannot lookup hwmod 'aes'
[   27.758148] omap-aes 480c5000.aes: _od_fail_runtime_resume:=20
=46IXME: missing hwmod/omap_dev info
[   27.765960] omap-aes 480c5000.aes: omap_aes_probe: failed to=20
get_sync(-19)
[   29.257690] omap-aes 480c5000.aes: initialization failed.

So it looks like some initialization data are missing for Nokia=20
N900 (omap3430 device).

Can somebody look at it? I have patched 2.6.28 kernel were omap=20
aes support on this N900 device (with special bootloader) is=20
working.

Maybe some other data are missing in DT or in hwmod?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1470245.kTVVyj3tAD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTkg68ACgkQi/DJPQPkQ1KHcgCff71oZYJ5CTGEzlePbftNV0ZI
FZAAn279Bf+NFEoic5UFb+RihjOtPJhM
=jV0S
-----END PGP SIGNATURE-----

--nextPart1470245.kTVVyj3tAD--

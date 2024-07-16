Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F21DFD1
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jul 2024 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721148841; cv=none; b=NAu2XUjZ/FJ2GjJWX21E8X8PVmSyGDh+2jDku3MF+mtHTlMLsS6btdV8LdkFLaC7SL9sZyqmMh/vOAU1X5pbHVRq8tdnmrSoAd6FGunNq4MVENsybmsFV2hboG8sdK37R0JkNdyxtn/SSZcNgdXcb9vNhl3lP0XfFcKdT1mWLxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721148841; c=relaxed/simple;
	bh=ydyeU6YgMma1RTJeP9OvOi5vFDqe9FDKQY6qcxrZbAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWLz4s42UzQXIm+A19/VfSIQ7bIE1vZBvrcV8I6pmZ8+fVRnMJDgNzLvzpKD/mQsquKdYlLY0dQsbY1yb/FQHqm71BhQAkexKQY7O0hg/L4DbZvJJLiT6+xGqHj82iMzmjwgpGgL6ImhkW9hg2XSCJ8LyvYiyj/G6SFTzUHHKNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=pHTARJ15; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="pHTARJ15"
X-Envelope-To: wens@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721148837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5LfLDYrWV6XH9tEvbhTXtMaCXvO/AkDTGH8eTmG5CE=;
	b=pHTARJ15xwSNqRWCeZQd7XDD2A2vZA29ETHmtQEbZJs+Zvai1AYpNLVCg65TeByf72wW5B
	CxhR2mojaz2EnEDjK3A0YOe9kOY6Qml7laRrvtcdz5VQqBYbJIXnxW5Ap7K8WlPft3iT2A
	2vJIeVxBvXBGv0rPD5bXsouRFxtWoDAnAE0mmyQn+O1S/7iOvfbd+kLToNSTuVU4uf1V5c
	XepkscePTKVriX4zM54iOOrBV67CFSb8W590Q3NYK1i5yAkS0pEvXSlohtLW6yvP6GDrvw
	g2OLmgzkQtMxrKRk42/BMA+Jw9UZ2IKW+xA0mDsPhe0s5t8cvIAYq1qk8rO3dQ==
X-Envelope-To: daniel@makrotopia.org
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: robh@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: ardb@kernel.org
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: olivia@selenic.com
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: heiko@sntech.de
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: wens@kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
 Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Dragan Simic <dsimic@manjaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 16 Jul 2024 18:53:43 +0200
Message-ID: <3190961.CRkYR5qTbq@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
References:
 <cover.1720969799.git.daniel@makrotopia.org> <6779787.ZJYUc1KeCW@bagend>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2094959.0xhRiLIBVh";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart2094959.0xhRiLIBVh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: wens@kernel.org
Date: Tue, 16 Jul 2024 18:53:43 +0200
Message-ID: <3190961.CRkYR5qTbq@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

On Tuesday, 16 July 2024 17:18:48 CEST Chen-Yu Tsai wrote:
> On Jul 16, 2024 at 10:13=E2=80=AFPM Diederik de Haas <didi.debian@cknow.o=
rg> wrote:
> > On Tuesday, 16 July 2024 15:59:40 CEST Diederik de Haas wrote:
> > > For shits and giggles, I tried it on my PineTab2 too (also rk3566):
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > root@pinetab2:~# uname -a
> > > Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
> > > (2024-04-24) aarch64 GNU/Linux
> > >=20
> > > root@pinetab2:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
> > > 1+0 records in
> > > 1+0 records out
> > > 100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s
> > >=20
> > > root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > > rngtest 5
> > > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > > This is free software; see the source for copying conditions.
> > > There is NO warranty; not even for MERCHANTABILITY or
> > > FITNESS FOR A PARTICULAR PURPOSE.
> > >=20
> > > rngtest: starting FIPS tests...
> > > rngtest: bits received from input: 20000032
> > > rngtest: FIPS 140-2 successes: 730
> > > rngtest: FIPS 140-2 failures: 270
> > > rngtest: FIPS 140-2(2001-10-10) Monobit: 266
> > > rngtest: FIPS 140-2(2001-10-10) Poker: 23
> > > rngtest: FIPS 140-2(2001-10-10) Runs: 9
> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > > rngtest: input channel speed: (min=3D2.615; avg=3D137.889;
> > > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D24.643;
> > > avg=3D34.518; max=3D68.364)Mibits/s rngtest: Program run time: 149674=
336
> > > microseconds
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > That's looking quite a lot better ... and I have no idea why.
> > >=20
> > > The Q64-A is used as headless server and the PineTab2 is not,
> > > but I connected to both over SSH and they were freshly booted
> > > into, thus I haven't actually/normally used the PT2 since boot.
> >=20
> > I did freshly install rng-tools5 package before running the test, so
> > I rebooted again to make sure that wasn't a factor:
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > root@pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > ...
> >=20
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 704
> > rngtest: FIPS 140-2 failures: 296
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 293
> > rngtest: FIPS 140-2(2001-10-10) Poker: 32
> > rngtest: FIPS 140-2(2001-10-10) Runs: 10
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=3D2.612; avg=3D137.833;
> > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D24.391;
> > avg=3D34.416; max=3D68.364)Mibits/s rngtest: Program run time: 149736205
> > microseconds
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > So that 704/296 vs 730/270 in the previous run on the PT2.
> >=20
> > In case it helps:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > root@quartz64a:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> > /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> > /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> > /sys/devices/virtual/misc/hw_random/rng_quality:900
> > /sys/devices/virtual/misc/hw_random/rng_selected:0
> >=20
> > root@pinetab2:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> > /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> > /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> > /sys/devices/virtual/misc/hw_random/rng_quality:900
> > /sys/devices/virtual/misc/hw_random/rng_selected:0
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> On my Rock 3A:
>=20
> wens@rock-3a:~$ sudo cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There
> is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
> PARTICULAR PURPOSE.
>=20
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 992
> rngtest: FIPS 140-2 failures: 8
> rngtest: FIPS 140-2(2001-10-10) Monobit: 7
> rngtest: FIPS 140-2(2001-10-10) Poker: 0
> rngtest: FIPS 140-2(2001-10-10) Runs: 0
> rngtest: FIPS 140-2(2001-10-10) Long run: 1
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D2.658; avg=3D140.067;
> max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D26.751;
> avg=3D34.901; max=3D65.320)Mibits/s rngtest: Program run time: 147367594
> microseconds
>=20
> wens@rock-3a:~$ uname -a
> Linux rock-3a 6.10.0-rc7-next-20240712-12899-g7df602fe7c8b #9 SMP Mon
> Jul 15 00:39:32 CST 2024 aarch64 GNU/Linux

I wondered if ``dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null`` befo=
re
the actual test run made a difference.
Tried it on my Quartz64 Model A: no

Then I tried it on my Quartz64 Model B:

root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
=2E..
rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 120
rngtest: FIPS 140-2 failures: 880
rngtest: FIPS 140-2(2001-10-10) Monobit: 879
rngtest: FIPS 140-2(2001-10-10) Poker: 332
rngtest: FIPS 140-2(2001-10-10) Runs: 91
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D2.615; avg=3D138.117; max=3D9765625.00=
0)Kibits/s
rngtest: FIPS tests speed: (min=3D20.777; avg=3D34.535; max=3D68.857)Mibits=
/s
rngtest: Program run time: 149461754 microseconds

root@quartz64b:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 5.71466 s, 17.5 kB/s

root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
=2E..
rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 104
rngtest: FIPS 140-2 failures: 896
rngtest: FIPS 140-2(2001-10-10) Monobit: 892
rngtest: FIPS 140-2(2001-10-10) Poker: 335
rngtest: FIPS 140-2(2001-10-10) Runs: 79
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D2.613; avg=3D138.098; max=3D9765625.00=
0)Kibits/s
rngtest: FIPS tests speed: (min=3D20.465; avg=3D34.587; max=3D69.107)Mibits=
/s
rngtest: Program run time: 149475187 microseconds

root@quartz64b:~# uname -a
Linux quartz64b 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow (2024-04-2=
4) aarch64 GNU/Linux

:-O
--nextPart2094959.0xhRiLIBVh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZpallwAKCRDXblvOeH7b
bmjPAQD6logzWaUtnOETe12wBYy+NoJgFGha1R1zEDTfdu4D1AEA81gYEi/v6W0p
YUlq9l6j6PPA90JPuehY8gWuammC3wE=
=s6Oo
-----END PGP SIGNATURE-----

--nextPart2094959.0xhRiLIBVh--




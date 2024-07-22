Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A127518637
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2024 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721675049; cv=none; b=iP8inpfAvnptX8jnyR0VzkG5Qo39WsJzFaqiDB/PcM6lFf3jq7Pdri1C3q8aPbUFw7Lf2n9faSv4Sr4wYCtrwKlRsrYgFxT7BqJr0n7qmuEQoHEC5mcpuWrIWo1nJeyAyAVkuJ/4KBFPL5jNHhTCMuDXNVOKcOjKkcCjzteb7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721675049; c=relaxed/simple;
	bh=8sLTIyS8TZWjmlWYCZZ1+fuTzwlxAzROzLQ+A6GLbMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ru3QLNOXq03ZU3ILPy7rIx2AnfCIoHk9t7ndoHhIr0KyfFxy0CTqh3E1UEQhKlISUub7S48CvxfMig+S0EqUhWqOq8p1QRbBzGJVSzzM4kLMMLG9KHQsbYYAWSln/NrWIvzR786LxDBE3aaXY4PIBHVtJlqhYaz4G0o9tb1f4IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=aBI+0EK3; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="aBI+0EK3"
X-Envelope-To: wens@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721675044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vCehHTNE0yJwghwUTXXSJntL5vplfQCDdSOUf961ASQ=;
	b=aBI+0EK3wjLxJSZThjUWcQviQSjA/o39gjU7+8eXu4hFQE5Inwz0rQjd5C1uSkpT/+AIhk
	SFgp7iseg3AzPFgPvvH9JiEy/lCdZ+nn1j4b3m5MasY+QZ8enEk/DarMP9w/KdeQqfX0L2
	Icn5we5tV7++NxWd1JF+12mAaGgt1PMlVmOJfBSinCr0nGml260axTI+4n5Mt6ZC/q9ee6
	LhT9ukw60icBwfjSEeM6sDll6GbuhWPFuzaG5mPZdf1IKo8G2l6vglSrcSUVBaClTMULWB
	ZCJQsBm4vGwePZaujkbUHoex0pWxPXrYnqOuxY6qdUXBabGkND7vsqP3Bh33+g==
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
To: Chen-Yu Tsai <wens@kernel.org>
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
Date: Mon, 22 Jul 2024 21:03:52 +0200
Message-ID: <4406786.zLnsZ2vfAB@bagend>
Organization: Connecting Knowledge
In-Reply-To:
 <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
References:
 <cover.1720969799.git.daniel@makrotopia.org> <3190961.CRkYR5qTbq@bagend>
 <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2509603.0URhkfn4ud";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart2509603.0URhkfn4ud
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 22 Jul 2024 21:03:52 +0200
Message-ID: <4406786.zLnsZ2vfAB@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

On Monday, 22 July 2024 19:57:05 CEST Chen-Yu Tsai wrote:
> On Wed, Jul 17, 2024 at 12:54=E2=80=AFAM Diederik de Haas <didi.debian@ck=
now.org>=20
wrote:
> > On Tuesday, 16 July 2024 17:18:48 CEST Chen-Yu Tsai wrote:
> > > On Jul 16, 2024 at 10:13=E2=80=AFPM Diederik de Haas <didi.debian@ckn=
ow.org>=20
wrote:
> > > > On Tuesday, 16 July 2024 15:59:40 CEST Diederik de Haas wrote:
> > > > > For shits and giggles, I tried it on my PineTab2 too (also rk3566=
):
> > > > >=20
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > root@pinetab2:~# uname -a
> > > > > Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
> > > > > (2024-04-24) aarch64 GNU/Linux
> > > > >=20
> > > > > root@pinetab2:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/=
null
> > > > > 1+0 records in
> > > > > 1+0 records out
> > > > > 100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s
> > > > >=20
> > > > > root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > > > > rngtest 5
> > > > > ...
> > > > > rngtest: starting FIPS tests...
> > > > > rngtest: bits received from input: 20000032
> > > > > rngtest: FIPS 140-2 successes: 730
> > > > > rngtest: FIPS 140-2 failures: 270
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >=20
> > > > > That's looking quite a lot better ... and I have no idea why.
> > > > >=20
> > > > > The Q64-A is used as headless server and the PineTab2 is not,
> > > > > but I connected to both over SSH and they were freshly booted
> > > > > into, thus I haven't actually/normally used the PT2 since boot.
> > > >=20
> > > > I did freshly install rng-tools5 package before running the test, so
> > > > I rebooted again to make sure that wasn't a factor:
> > > >=20
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > root@pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > > > rngtest 5
> > > > ...
> > > > rngtest: starting FIPS tests...
> > > > rngtest: bits received from input: 20000032
> > > > rngtest: FIPS 140-2 successes: 704
> > > > rngtest: FIPS 140-2 failures: 296
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >=20
> > > > So that 704/296 vs 730/270 in the previous run on the PT2.
> > > >=20
> > > On my Rock 3A:
> > >=20
> > > wens@rock-3a:~$ sudo cat /dev/hwrng | rngtest -c 1000
> > > rngtest 5
> > > ...
> > > rngtest: starting FIPS tests...
> > > rngtest: bits received from input: 20000032
> > > rngtest: FIPS 140-2 successes: 992
> > > rngtest: FIPS 140-2 failures: 8
> > >=20
> > > wens@rock-3a:~$ uname -a
> > > Linux rock-3a 6.10.0-rc7-next-20240712-12899-g7df602fe7c8b #9 SMP Mon
> > > Jul 15 00:39:32 CST 2024 aarch64 GNU/Linux
> >=20
> > I wondered if ``dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null`` =
before
> > the actual test run made a difference.
> > Tried it on my Quartz64 Model A: no
> >=20
> > Then I tried it on my Quartz64 Model B:
> >=20
> > root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > ...
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 120
> > rngtest: FIPS 140-2 failures: 880
> >=20
> > root@quartz64b:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
> > 1+0 records in
> > 1+0 records out
> > 100000 bytes (100 kB, 98 KiB) copied, 5.71466 s, 17.5 kB/s
> >=20
> > root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > ...
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 104
> > rngtest: FIPS 140-2 failures: 896
> >=20
> > root@quartz64b:~# uname -a
> > Linux quartz64b 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
> > (2024-04-24) aarch64 GNU/Linux>=20
> > :-O
>=20
> I pulled out my Quartz64 model B, and the results seem better than yours.
>=20
> root@quartz64:~# sudo dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 859
> rngtest: FIPS 140-2 failures: 141
> root@quartz64:~# sudo dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 843
> rngtest: FIPS 140-2 failures: 157

I noticed you used ``dd`` instead of ``cat``, so I tried again ...

Quartz64-A:
root@quartz64a:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
rngtest 5
=2E..
rngtest: starting FIPS tests...                                            =
                  =20
rngtest: bits received from input: 20000032                                =
                  =20
rngtest: FIPS 140-2 successes: 411                                         =
                  =20
rngtest: FIPS 140-2 failures: 589

root@quartz64a:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: starting FIPS tests...          =20
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 391        =20
rngtest: FIPS 140-2 failures: 609

root@quartz64a:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
1+0 records in                            =20
1+0 records out                  =20
100000 bytes (100 kB, 98 KiB) copied, 5.66202 s, 17.7 kB/s

root@quartz64a:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 386                                         =
                  =20
rngtest: FIPS 140-2 failures: 614

root@quartz64a:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 356
rngtest: FIPS 140-2 failures: 644

Quartz64-B:
root@quartz64b:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 118
rngtest: FIPS 140-2 failures: 882

root@quartz64b:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 133
rngtest: FIPS 140-2 failures: 867

root@quartz64b:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null

root@quartz64b:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 97
rngtest: FIPS 140-2 failures: 903

root@quartz64b:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 130
rngtest: FIPS 140-2 failures: 870

And lastly on PineTab2:
root@pinetab2:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 705
rngtest: FIPS 140-2 failures: 295

root@pinetab2:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 678
rngtest: FIPS 140-2 failures: 322

root@pinetab2:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null

root@pinetab2:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 681
rngtest: FIPS 140-2 failures: 319

root@pinetab2:~# dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
=2E..
rngtest: FIPS 140-2 successes: 669
rngtest: FIPS 140-2 failures: 331


So my Q64-B tests are consistently MUCH worse then your Q64-B tests ...
This seems BAD to me, now that we even have completely different results pe=
r=20
device of the EXACT same model?!? Hardware revision may be different (I hav=
e a=20
v1.4), but it seems rather pointless to go into that direction.

It then also seems rather pointless to try it with different parameters if =
the=20
results on the same SBC model can vary this much.

Thanks for your tests,
  Diederik

--nextPart2509603.0URhkfn4ud
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZp6tGAAKCRDXblvOeH7b
bnIPAP9eRr0EgWFfuf4HAEy2gbcjRS0YYCyCeha4MjfASco9EQD/XQXNEecekolM
xPv/OQmXAzX1hHLrt8gX4KRIaxkJ8wc=
=5Ged
-----END PGP SIGNATURE-----

--nextPart2509603.0URhkfn4ud--




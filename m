Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2219B3E1
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jul 2024 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721138396; cv=none; b=FsF7v/7RciOk220CwNs9+5jTbzjnFwKtcDdqr4masN0x7j5rU76CX7MsGNBjvuzWR7N1TFHcwYFvOrwFBdUNI+IsyVGtepY79fQQSzx7EvazlcTFA1NuTFyYK5pvGpqALw5iuCoVp4JjPX2DIXWCDH2XHGknLuODExU23KkraEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721138396; c=relaxed/simple;
	bh=ugPkZqPlLHlzHo68r0Y23CUqNW2j6hAe2CeBbr7UlCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cowS/LBfduetcI5Dy1G4BK2ILbgofrSz93vQ4SUAq7+KY/B5sNKoBeOSqa4KEiDLJFiLUsA7qbnQEseAnVFjC16f+cOjuJV6DjxBFPx+IaHhqybZHnVJ4IplhTdY7MsL6fmKfwK4R0iRJJbOb3uksTmMsaUjsKdXJ8t20dXFcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=cvbTtkvu; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="cvbTtkvu"
X-Envelope-To: daniel@makrotopia.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721138392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z/6hLi0hpFU/NJWzKKvk3gXmqqY3bcj2xGhKR9ye2lU=;
	b=cvbTtkvuVRQtoPFPFc9QFmkPK72CWGEk6X6JjaXxorm963a3ava45U7yBk4gCIPBlYmBhQ
	ZJ7u/tk0f0rV0fWnZCvesGO6FaRkbcgVbsBvvdUNfgzhPgOptfnRsBCo5es0KEwqpBpIJL
	TFEivEKK+SYfUSdm+Ll8Enj4u21F2YOp7UDSYmqNCZoh3gdPiJthnabHgSAj85V/yN0lQo
	04hrxAX6MxxGdKreyXeg26F6G0Gzk5/3IAp4xQJhQjfJMxcIqh92W4juyOmeCQfqNpf9eP
	ccg72E/I+lEaKDXzE5E6apwuq80Qd9rKah876lUEyBYDi6SRrpoM3NcKy5N0FA==
X-Envelope-To: wens@kernel.org
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: heiko@sntech.de
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: olivia@selenic.com
X-Envelope-To: robh@kernel.org
X-Envelope-To: krzk+dt@kernel.org
X-Envelope-To: conor+dt@kernel.org
X-Envelope-To: p.zabel@pengutronix.de
X-Envelope-To: dsimic@manjaro.org
X-Envelope-To: ukleinek@debian.org
X-Envelope-To: sebastian.reichel@collabora.com
X-Envelope-To: cristian.ciocaltea@collabora.com
X-Envelope-To: s.hauer@pengutronix.de
X-Envelope-To: martin@kaiser.cx
X-Envelope-To: ardb@kernel.org
X-Envelope-To: linux-crypto@vger.kernel.org
X-Envelope-To: devicetree@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Diederik de Haas <didi.debian@cknow.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Heiko Stuebner <heiko@sntech.de>,
 linux-rockchip@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
 Dragan Simic <dsimic@manjaro.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 16 Jul 2024 15:59:40 +0200
Message-ID: <1874451.yxlQQexqVa@bagend>
Organization: Connecting Knowledge
In-Reply-To: <ZpZ1RSSYaLo45kUI@makrotopia.org>
References:
 <cover.1720969799.git.daniel@makrotopia.org> <6425788.NZdkxuyfQg@bagend>
 <ZpZ1RSSYaLo45kUI@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2139056.YYODicKxRJ";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart2139056.YYODicKxRJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Daniel Golle <daniel@makrotopia.org>
Date: Tue, 16 Jul 2024 15:59:40 +0200
Message-ID: <1874451.yxlQQexqVa@bagend>
Organization: Connecting Knowledge
In-Reply-To: <ZpZ1RSSYaLo45kUI@makrotopia.org>
MIME-Version: 1.0

Hi Daniel,

On Tuesday, 16 July 2024 15:27:33 CEST Daniel Golle wrote:
> On Tue, Jul 16, 2024 at 02:34:40PM +0200, Diederik de Haas wrote:
> > [...]
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 362
> > rngtest: FIPS 140-2 failures: 638
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 634
> > rngtest: FIPS 140-2(2001-10-10) Poker: 106
> > rngtest: FIPS 140-2(2001-10-10) Runs: 43
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=2.638; avg=139.351;
> > max=9765625.000)Kibits/s rngtest: FIPS tests speed: (min=21.169;
> > avg=36.158; max=68.610)Mibits/s rngtest: Program run time: 148109761
> > microseconds
> > ===============================================================
> > 
> > That's almost twice as many failures as successes ...
> 
> That's bad news, and apparently different from Aurelien's initial
> testing of the driver.
> 
> Can you try if the result is also that bad when using his version of
> the driver:
> 
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/20221128184718.1
> 963353-3-aurelien@aurel32.net/
> 
> If so, we can try to increase RK_RNG_SAMPLE_CNT, and we may need
> different values depending on the SoC...

I had been using a rebased version (with fixed includes) of Aurelien's
patch set and I switched to 'your' version somewhere in the 6.10-rcX
cycle, but I didn't record exactly when.
But I had a 6.9.2 kernel of which I'm confident has that rebased patch set:

=========================================================== 
root@quartz64a:~# uname -a
Linux quartz64a 6.9+unreleased-arm64 #1 SMP Debian 6.9.2-1~cknow (2024-04-24) aarch64 GNU/Linux

root@quartz64a:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 5.6801 s, 17.6 kB/s
root@quartz64a:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions. 
There is NO warranty; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 361
rngtest: FIPS 140-2 failures: 639
rngtest: FIPS 140-2(2001-10-10) Monobit: 637
rngtest: FIPS 140-2(2001-10-10) Poker: 115
rngtest: FIPS 140-2(2001-10-10) Runs: 34
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=2.603; avg=137.548; max=9765625.000)Kibits/s
rngtest: FIPS tests speed: (min=21.479; avg=37.156; max=89.547)Mibits/s
rngtest: Program run time: 149992805 microseconds
=========================================================== 

So that's consistent(ly bad).

For shits and giggles, I tried it on my PineTab2 too (also rk3566):

=========================================================== 
root@pinetab2:~# uname -a
Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow (2024-04-24) aarch64 GNU/Linux

root@pinetab2:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s

root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 730
rngtest: FIPS 140-2 failures: 270
rngtest: FIPS 140-2(2001-10-10) Monobit: 266
rngtest: FIPS 140-2(2001-10-10) Poker: 23
rngtest: FIPS 140-2(2001-10-10) Runs: 9
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=2.615; avg=137.889; max=9765625.000)Kibits/s
rngtest: FIPS tests speed: (min=24.643; avg=34.518; max=68.364)Mibits/s
rngtest: Program run time: 149674336 microseconds
=========================================================== 

That's looking quite a lot better ... and I have no idea why.

The Q64-A is used as headless server and the PineTab2 is not,
but I connected to both over SSH and they were freshly booted
into, thus I haven't actually/normally used the PT2 since boot.

HTH,
  Diederik
--nextPart2139056.YYODicKxRJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZpZ8zAAKCRDXblvOeH7b
biPgAP4w2EctjF1IbZ6okanhouXKBT7puVwkG4ARRF2EXzy2aAD9EBom0mLY87MC
ruDMJ4tVdTkx+/wFphSdl9PKA5TEZg4=
=5K2E
-----END PGP SIGNATURE-----

--nextPart2139056.YYODicKxRJ--




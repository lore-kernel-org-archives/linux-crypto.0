Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8296B19AA42
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jul 2024 12:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721133299; cv=none; b=fTDyQ8Go/pKYxzwLAIEyL5UuLOXE5rAxKcU6TwL2dJrxP4IiUrZfhGcKMscTjvSC48Qm4pA1BkyK1UXnPYxXLrKNUYQk7U+B5D584SPx3ffrGbO41WajgELOjy1hvw2RIC4RvATwlB/JyilrhYBf3amwcVMruXLa1m0Kow2oUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721133299; c=relaxed/simple;
	bh=V/F4UTvvEy3NCSvKyNNAWr4zGMGneWAsO6rPvWKaGvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shipyQyy2WQraJfi1mPVPCpvLyfAW5eNv/hT/wxFlV7YVFVEq9O/m4gQuHzE3wRO3Lo1WKhXVe5GE7CdSNzCztJIcIjJTlGj9TDyyCJrjDMVwfg3B/oOJYnJ+5Tya0XjDVMQasvI1nnEVZCl69fgm5tjXvY9UUAqRnWzodTsf84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=PGWN6knR; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="PGWN6knR"
X-Envelope-To: wens@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1721133292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TUFna8KX4ihrtDkjdAKNgLT+tJDIS3c9nXtfNbeflQI=;
	b=PGWN6knRfOiyzyBmePMrs5eNI9XnN46/sa44jaUfrDReHR8E3BZIou5l4AikCZxA07uLKi
	AODkX8ezbh6Pb09qom3tdW5X9394/BSWmdfmtcopPuSqwhP9nYVY6HoB/LRv0brek/TFd4
	EyM8HD2LwKk1TOuAzvVY4TzEWfDV8cBlm6UBWAmehEwuAv+NCOk0HOeL6ptO6uMjRxy6OK
	vHFPHadXuHJM+hoOHerbWBFM+nvU8F9D6Pil5tETn67vCBGlckMI9khfEm3OMxRErGF2Ar
	bfB/A2dndy2llg0q9w2k80vW1CZeI53j3FFYERh4kEjMSJtNMjtwtV9DFi0ZZA==
X-Envelope-To: aurelien@aurel32.net
X-Envelope-To: herbert@gondor.apana.org.au
X-Envelope-To: heiko@sntech.de
X-Envelope-To: linux-rockchip@lists.infradead.org
X-Envelope-To: daniel@makrotopia.org
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
To: Chen-Yu Tsai <wens@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Heiko Stuebner <heiko@sntech.de>,
 linux-rockchip@lists.infradead.org, Daniel Golle <daniel@makrotopia.org>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>, Dragan Simic <dsimic@manjaro.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Date: Tue, 16 Jul 2024 14:34:40 +0200
Message-ID: <6425788.NZdkxuyfQg@bagend>
Organization: Connecting Knowledge
In-Reply-To: <cover.1720969799.git.daniel@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5537839.MQpQnaDgsY";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Migadu-Flow: FLOW_OUT

--nextPart5537839.MQpQnaDgsY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Tue, 16 Jul 2024 14:34:40 +0200
Message-ID: <6425788.NZdkxuyfQg@bagend>
Organization: Connecting Knowledge
In-Reply-To: <cover.1720969799.git.daniel@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
MIME-Version: 1.0

On Sunday, 14 July 2024 17:15:35 CEST Daniel Golle wrote:
> Rockchip SoCs used to have a random number generator as part of their
> crypto device.
> 
> However newer Rockchip SoCs like the RK3568 have an independent True
> Random Number Generator device. This patchset adds a driver for it and
> enables it in the device tree.
> 
> Tested on FriendlyARM NanoPi R5C.
> 
> ...
> 
> Aurelien Jarno (3):
>   dt-bindings: rng: Add Rockchip RK3568 TRNG
>   hwrng: add hwrng driver for Rockchip RK3568 SoC
>   arm64: dts: rockchip: add DT entry for RNG to RK356x
> 
>  .../bindings/rng/rockchip,rk3568-rng.yaml     |  61 +++++
>  MAINTAINERS                                   |   7 +
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi      |   9 +
>  drivers/char/hw_random/Kconfig                |  14 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/rockchip-rng.c         | 227 ++++++++++++++++++
>  6 files changed, 319 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml create mode
> 100644 drivers/char/hw_random/rockchip-rng.c

I just did the following test on my Quartz64 Model A running kernel 6.10
+ a number of patches, including this one:

===============================================================
root@quartz64a:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 5.64507 s, 17.7 kB/s
root@quartz64a:~# cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions. 
There is NO warranty; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 362
rngtest: FIPS 140-2 failures: 638
rngtest: FIPS 140-2(2001-10-10) Monobit: 634
rngtest: FIPS 140-2(2001-10-10) Poker: 106
rngtest: FIPS 140-2(2001-10-10) Runs: 43
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=2.638; avg=139.351; max=9765625.000)Kibits/s
rngtest: FIPS tests speed: (min=21.169; avg=36.158; max=68.610)Mibits/s
rngtest: Program run time: 148109761 microseconds
===============================================================

That's almost twice as many failures as successes ...
--nextPart5537839.MQpQnaDgsY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZpZo4AAKCRDXblvOeH7b
boR5AQCgqaoiNWyzbxb+45ldj8zkL/JfpahT6y+T00sZkniBUQEAq8WpWtRZKF2U
KCvP/JqsEptPp3b08vRkAwxriNImTgc=
=mIG+
-----END PGP SIGNATURE-----

--nextPart5537839.MQpQnaDgsY--




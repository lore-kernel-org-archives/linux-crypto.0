Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1742C19DF94;
	Tue, 16 Jul 2024 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721143143; cv=none; b=BcECQXWyvGZlOJ/ExR7sMR84clTrqiF1ZKBCyNzmhVWahu+fTsbWa+WBDSvEM9XjC2CzXMmN2zdkZCbyFE2srykBJEYraTHqjNGa4v5WXVsLFZro+yAEw9R/uWN7528qvRc/+mU4vpKA5r33bxgkKqQu0WSS0kl1e+QcZkr0SEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721143143; c=relaxed/simple;
	bh=ew0DUC6MaE6u+UzFSNobyhXBsg3O1+ceZPDokVRCnHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L4pGKpiLGbx4b7meD9D0pSB9bspUUc6sdiaA4e63VqijLpffwvwMCldGzVCrhmvDd4f5FDNgSczxQAY0vXrv+l7s/ElI3vyHIQONA2JnAC76DKg798KF9omqeCp/EHUKTyRL/Qj5Dy83OA6u6HOxiPap4VHmyMc4ME2DcDVzli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZctcsBOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZctcsBOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A650CC4AF0E;
	Tue, 16 Jul 2024 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721143142;
	bh=ew0DUC6MaE6u+UzFSNobyhXBsg3O1+ceZPDokVRCnHg=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=ZctcsBOpv9ofocppDrZbIZjm9QjwtfppEiQeQjnUxPVOxxlPdbAAxQUKbrgu1FegS
	 sF7+igEC7p2D+fg3+EVOSY6SiTGYlDN/44CazelzbxFsm2iULk74LTivVqKUDTjepX
	 87ulq96XX+LiBGaXb0pC1UE6RX9YuCtaH7Yd/Y9/YkkCiAUq9wME3O8GyvrQ9W2vMr
	 7DPoPxMQaIyKZL5Y8/j5ozndJfDJGSnV0N/AoA5sPmFoqf6BpNPniyIEx9M/ShFbKH
	 fOoMusfuDz2aRUiJF5VfhAIMQxcbNYjDxXLfGZaDE+d4AmS1ZYftuRFlQtYx3BMAOv
	 WMv9Xe5npAZZg==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2eecd2c6432so79900371fa.3;
        Tue, 16 Jul 2024 08:19:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUdC/xWu81zf4mVLnPVHAb1FvfVZjx9YFFwGrHspFrXTrwmOEajR12SOX78e0AHtz13QVe6mFFhKGSlRE/NSYEPMy+hY/DvqMUIXCXhpcGrpG9UYxfl/lGrgnahsyf30RbpZY73HShawpNroQq0yw6Xq5asOTUJtMN/O9iovOvpzmq66/GAFA==
X-Gm-Message-State: AOJu0YzBJyPJMVQzYcMqoVXiwVK1t9ZS4onnooNkfSD0M/prD8DyXotm
	eyaJi5Vq/9b98dgFpGkEljXJ3rwsOOqOBpW3Xeeq7bq+xqYLre0RzkQ7yHuSiK6v4N+KRgYhp5z
	WrLPuFnPpNIv+C+jZXRRJwTD1qNQ=
X-Google-Smtp-Source: AGHT+IGgTQNktVxwYAstssWzXF6vbd4odzQf/DxzVb3yYZx/iVdhb5gYCoqcMNPEIUfZAHP/M7KxAYXUu95sg+jO0hM=
X-Received: by 2002:a2e:b615:0:b0:2ec:6756:e3e7 with SMTP id
 38308e7fff4ca-2eef41e9ce5mr21397391fa.40.1721143140917; Tue, 16 Jul 2024
 08:19:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <ZpZ1RSSYaLo45kUI@makrotopia.org>
 <1874451.yxlQQexqVa@bagend> <6779787.ZJYUc1KeCW@bagend>
In-Reply-To: <6779787.ZJYUc1KeCW@bagend>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 16 Jul 2024 23:18:48 +0800
X-Gmail-Original-Message-ID: <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
Message-ID: <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>, linux-rockchip@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Ard Biesheuvel <ardb@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Philipp Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Dragan Simic <dsimic@manjaro.org>, 
	Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner <heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2024 at 10:13=E2=80=AFPM Diederik de Haas <didi.debian@ckno=
w.org> wrote:
>
> On Tuesday, 16 July 2024 15:59:40 CEST Diederik de Haas wrote:
> > For shits and giggles, I tried it on my PineTab2 too (also rk3566):
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > root@pinetab2:~# uname -a
> > Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow (2024-0=
4-24)
> > aarch64 GNU/Linux
> >
> > root@pinetab2:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
> > 1+0 records in
> > 1+0 records out
> > 100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s
> >
> > root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > This is free software; see the source for copying conditions.
> > There is NO warranty; not even for MERCHANTABILITY or
> > FITNESS FOR A PARTICULAR PURPOSE.
> >
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 730
> > rngtest: FIPS 140-2 failures: 270
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 266
> > rngtest: FIPS 140-2(2001-10-10) Poker: 23
> > rngtest: FIPS 140-2(2001-10-10) Runs: 9
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=3D2.615; avg=3D137.889;
> > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D24.643;
> > avg=3D34.518; max=3D68.364)Mibits/s rngtest: Program run time: 14967433=
6
> > microseconds
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > That's looking quite a lot better ... and I have no idea why.
> >
> > The Q64-A is used as headless server and the PineTab2 is not,
> > but I connected to both over SSH and they were freshly booted
> > into, thus I haven't actually/normally used the PT2 since boot.
>
> I did freshly install rng-tools5 package before running the test, so
> I rebooted again to make sure that wasn't a factor:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> root@pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
>
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 704
> rngtest: FIPS 140-2 failures: 296
> rngtest: FIPS 140-2(2001-10-10) Monobit: 293
> rngtest: FIPS 140-2(2001-10-10) Poker: 32
> rngtest: FIPS 140-2(2001-10-10) Runs: 10
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D2.612; avg=3D137.833; max=3D9765625.=
000)Kibits/s
> rngtest: FIPS tests speed: (min=3D24.391; avg=3D34.416; max=3D68.364)Mibi=
ts/s
> rngtest: Program run time: 149736205 microseconds
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> So that 704/296 vs 730/270 in the previous run on the PT2.
>
> In case it helps:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> root@quartz64a:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> /sys/devices/virtual/misc/hw_random/rng_quality:900
> /sys/devices/virtual/misc/hw_random/rng_selected:0
>
> root@pinetab2:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> /sys/devices/virtual/misc/hw_random/rng_quality:900
> /sys/devices/virtual/misc/hw_random/rng_selected:0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

On my Rock 3A:

wens@rock-3a:~$ sudo cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There
is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 992
rngtest: FIPS 140-2 failures: 8
rngtest: FIPS 140-2(2001-10-10) Monobit: 7
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 1
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D2.658; avg=3D140.067; max=3D9765625.00=
0)Kibits/s
rngtest: FIPS tests speed: (min=3D26.751; avg=3D34.901; max=3D65.320)Mibits=
/s
rngtest: Program run time: 147367594 microseconds

wens@rock-3a:~$ uname -a
Linux rock-3a 6.10.0-rc7-next-20240712-12899-g7df602fe7c8b #9 SMP Mon
Jul 15 00:39:32 CST 2024 aarch64 GNU/Linux


ChenYu

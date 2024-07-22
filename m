Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D24816F0D6;
	Mon, 22 Jul 2024 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721671041; cv=none; b=iJVXhp3x7K6aWpvkKeGoqCbf8yuLWeLlHzD00HHKFeKanVoebSVR0fNsVoZf5TeP3t+ZnKO+DhkXSFnV1rP6oLcI5G7ZVycuO4+g4igtTncO4m4WsJ0zFD3IXD/JxSaTGWcJs11OSFu+nDHj8a/QOgOEtc4B85uuOXZkFRub8jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721671041; c=relaxed/simple;
	bh=gLe2umgqwhHYuD0lOMCuwPcdgZ3WgUSWvxweYSYrAeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ju/Xqe2IS5VHtQCiCjefncCa5oKCsruRrFTUVn78IWy0tqQaPdK3i822130We0epiFeWWosgYDs7Tnp1V85qc4XiC2Krw08QFk5lcdnpWw6CyHG+WxJ89/pgehgGLGg848kM8qobpvOIhfATDq2XH+6KkK0cgRDd0VsehBqZOKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evn7FQ2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evn7FQ2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ADBC4AF15;
	Mon, 22 Jul 2024 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721671040;
	bh=gLe2umgqwhHYuD0lOMCuwPcdgZ3WgUSWvxweYSYrAeA=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=evn7FQ2R94h8tEX5h6K1R7y5QTqbDdU3a06nixSfTicpUr4SDZqjVUUtVmqtamDa6
	 kTcxYo0NqtAR6TPsg6t4jzThRScj67a6K8QyRBCyCDPcRv5Xv1k0+DM8afXQc9+sB8
	 NdyTwLxDQEjr/6dcIaQ33cPWcOGWvBzWdhzr1pAYpAN8QEoWce9JzWzut5NVN0qXXf
	 XA+FWLxzXEmj3cnJO22WF+fI3wDyYk7QfdwW8hfp8THjF3h2YXg89S/zzxg/xiLtIy
	 VH8C7Aqnn8JSkrYG/Qr0TTCQzdRal4U8cWKUEXtH4fCD5SP65daf43qglB4c6kUK1R
	 1IIWDeb/w1Zng==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ef2fccca2cso15422891fa.1;
        Mon, 22 Jul 2024 10:57:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQZJNIukkn9vAsFRQ+lU0QbvFwDW0z63yocS8nV+9pzGTs014KicvgXEau22EBr35jVobB0ZWwq8WAM236w4i0UTi3v5g6LBX/XxVyp3+4xwauYnqYQA50BYwuAmNzW8WKGmcn2FQssdwjfEQy989POVwoI4trYwyXHI97mZhQ8mp9jvPLzw==
X-Gm-Message-State: AOJu0YxMgzME9lEJ3Y8rFQNqjRfvm7MtMcWIR0UsjlDdwMET2QgriOT/
	js+fJ51ZA0F0emMHkNr8f1CE+aEZmkyWkYHK0xcXimsvsJwHluKQGlOPOUngZvAmLiVXAGggnkt
	VTn6DW/wftYkh9A2Lb79s+QMh54M=
X-Google-Smtp-Source: AGHT+IEG03JkqirBP9XkQG4NM1JUJU5kVRXR7Lg2r8kdI7m+ph+YlmCwtxJCdn/y0qIZNAsmNDBdM3/fapg0DIQIWd4=
X-Received: by 2002:a2e:a54b:0:b0:2ef:2f4b:deeb with SMTP id
 38308e7fff4ca-2ef2f4c1181mr32945621fa.23.1721671038811; Mon, 22 Jul 2024
 10:57:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <6779787.ZJYUc1KeCW@bagend>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com> <3190961.CRkYR5qTbq@bagend>
In-Reply-To: <3190961.CRkYR5qTbq@bagend>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 23 Jul 2024 01:57:05 +0800
X-Gmail-Original-Message-ID: <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
Message-ID: <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
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

On Wed, Jul 17, 2024 at 12:54=E2=80=AFAM Diederik de Haas <didi.debian@ckno=
w.org> wrote:
>
> On Tuesday, 16 July 2024 17:18:48 CEST Chen-Yu Tsai wrote:
> > On Jul 16, 2024 at 10:13=E2=80=AFPM Diederik de Haas <didi.debian@cknow=
.org> wrote:
> > > On Tuesday, 16 July 2024 15:59:40 CEST Diederik de Haas wrote:
> > > > For shits and giggles, I tried it on my PineTab2 too (also rk3566):
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > root@pinetab2:~# uname -a
> > > > Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
> > > > (2024-04-24) aarch64 GNU/Linux
> > > >
> > > > root@pinetab2:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/nu=
ll
> > > > 1+0 records in
> > > > 1+0 records out
> > > > 100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s
> > > >
> > > > root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > > > rngtest 5
> > > > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > > > This is free software; see the source for copying conditions.
> > > > There is NO warranty; not even for MERCHANTABILITY or
> > > > FITNESS FOR A PARTICULAR PURPOSE.
> > > >
> > > > rngtest: starting FIPS tests...
> > > > rngtest: bits received from input: 20000032
> > > > rngtest: FIPS 140-2 successes: 730
> > > > rngtest: FIPS 140-2 failures: 270
> > > > rngtest: FIPS 140-2(2001-10-10) Monobit: 266
> > > > rngtest: FIPS 140-2(2001-10-10) Poker: 23
> > > > rngtest: FIPS 140-2(2001-10-10) Runs: 9
> > > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > > > rngtest: input channel speed: (min=3D2.615; avg=3D137.889;
> > > > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D24.643=
;
> > > > avg=3D34.518; max=3D68.364)Mibits/s rngtest: Program run time: 1496=
74336
> > > > microseconds
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > That's looking quite a lot better ... and I have no idea why.
> > > >
> > > > The Q64-A is used as headless server and the PineTab2 is not,
> > > > but I connected to both over SSH and they were freshly booted
> > > > into, thus I haven't actually/normally used the PT2 since boot.
> > >
> > > I did freshly install rng-tools5 package before running the test, so
> > > I rebooted again to make sure that wasn't a factor:
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > root@pinetab2:~# cat /dev/hwrng | rngtest -c 1000
> > > rngtest 5
> > > ...
> > >
> > > rngtest: starting FIPS tests...
> > > rngtest: bits received from input: 20000032
> > > rngtest: FIPS 140-2 successes: 704
> > > rngtest: FIPS 140-2 failures: 296
> > > rngtest: FIPS 140-2(2001-10-10) Monobit: 293
> > > rngtest: FIPS 140-2(2001-10-10) Poker: 32
> > > rngtest: FIPS 140-2(2001-10-10) Runs: 10
> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > > rngtest: input channel speed: (min=3D2.612; avg=3D137.833;
> > > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D24.391;
> > > avg=3D34.416; max=3D68.364)Mibits/s rngtest: Program run time: 149736=
205
> > > microseconds
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > So that 704/296 vs 730/270 in the previous run on the PT2.
> > >
> > > In case it helps:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > root@quartz64a:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> > > /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> > > /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> > > /sys/devices/virtual/misc/hw_random/rng_quality:900
> > > /sys/devices/virtual/misc/hw_random/rng_selected:0
> > >
> > > root@pinetab2:~# grep . /sys/devices/virtual/misc/hw_random/rng_*
> > > /sys/devices/virtual/misc/hw_random/rng_available:rockchip-rng
> > > /sys/devices/virtual/misc/hw_random/rng_current:rockchip-rng
> > > /sys/devices/virtual/misc/hw_random/rng_quality:900
> > > /sys/devices/virtual/misc/hw_random/rng_selected:0
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > On my Rock 3A:
> >
> > wens@rock-3a:~$ sudo cat /dev/hwrng | rngtest -c 1000
> > rngtest 5
> > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > This is free software; see the source for copying conditions.  There
> > is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
> > PARTICULAR PURPOSE.
> >
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 992
> > rngtest: FIPS 140-2 failures: 8
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 7
> > rngtest: FIPS 140-2(2001-10-10) Poker: 0
> > rngtest: FIPS 140-2(2001-10-10) Runs: 0
> > rngtest: FIPS 140-2(2001-10-10) Long run: 1
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=3D2.658; avg=3D140.067;
> > max=3D9765625.000)Kibits/s rngtest: FIPS tests speed: (min=3D26.751;
> > avg=3D34.901; max=3D65.320)Mibits/s rngtest: Program run time: 14736759=
4
> > microseconds
> >
> > wens@rock-3a:~$ uname -a
> > Linux rock-3a 6.10.0-rc7-next-20240712-12899-g7df602fe7c8b #9 SMP Mon
> > Jul 15 00:39:32 CST 2024 aarch64 GNU/Linux
>
> I wondered if ``dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null`` be=
fore
> the actual test run made a difference.
> Tried it on my Quartz64 Model A: no
>
> Then I tried it on my Quartz64 Model B:
>
> root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 120
> rngtest: FIPS 140-2 failures: 880
> rngtest: FIPS 140-2(2001-10-10) Monobit: 879
> rngtest: FIPS 140-2(2001-10-10) Poker: 332
> rngtest: FIPS 140-2(2001-10-10) Runs: 91
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D2.615; avg=3D138.117; max=3D9765625.=
000)Kibits/s
> rngtest: FIPS tests speed: (min=3D20.777; avg=3D34.535; max=3D68.857)Mibi=
ts/s
> rngtest: Program run time: 149461754 microseconds
>
> root@quartz64b:~# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
> 1+0 records in
> 1+0 records out
> 100000 bytes (100 kB, 98 KiB) copied, 5.71466 s, 17.5 kB/s
>
> root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 104
> rngtest: FIPS 140-2 failures: 896
> rngtest: FIPS 140-2(2001-10-10) Monobit: 892
> rngtest: FIPS 140-2(2001-10-10) Poker: 335
> rngtest: FIPS 140-2(2001-10-10) Runs: 79
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D2.613; avg=3D138.098; max=3D9765625.=
000)Kibits/s
> rngtest: FIPS tests speed: (min=3D20.465; avg=3D34.587; max=3D69.107)Mibi=
ts/s
> rngtest: Program run time: 149475187 microseconds
>
> root@quartz64b:~# uname -a
> Linux quartz64b 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow (2024-04=
-24) aarch64 GNU/Linux
>
> :-O

I pulled out my Quartz64 model B, and the results seem better than yours.

root@quartz64:~# sudo dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There
is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 859
rngtest: FIPS 140-2 failures: 141
rngtest: FIPS 140-2(2001-10-10) Monobit: 137
rngtest: FIPS 140-2(2001-10-10) Poker: 10
rngtest: FIPS 140-2(2001-10-10) Runs: 5
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D134.990; avg=3D143.460; max=3D157.836)=
Kibits/s
rngtest: FIPS tests speed: (min=3D34.742; avg=3D40.675; max=3D41.285)Mibits=
/s
rngtest: Program run time: 136667679 microseconds
root@quartz64:~# sudo dd if=3D/dev/hwrng bs=3D256 | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There
is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 843
rngtest: FIPS 140-2 failures: 157
rngtest: FIPS 140-2(2001-10-10) Monobit: 155
rngtest: FIPS 140-2(2001-10-10) Poker: 13
rngtest: FIPS 140-2(2001-10-10) Runs: 7
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D134.977; avg=3D143.669; max=3D157.906)=
Kibits/s
rngtest: FIPS tests speed: (min=3D37.036; avg=3D40.666; max=3D41.285)Mibits=
/s
rngtest: Program run time: 136459178 microseconds

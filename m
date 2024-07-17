Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57587374C2;
	Wed, 17 Jul 2024 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721213070; cv=none; b=VvycXjcNb1xO6C5LArYlShAs3xU7l3u1xczq07f1BpxLv679WdOPq0ZSmqkO+Z3RoSiiLQH4e5N2LellLFaiCHk/qB4iHmY2vEe9xf1QsHl3ii02wzuxMVkkxn+/aR7GYhDchevh6nHp2RozBYLyGBe4qgymSbyPWjTRQBINks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721213070; c=relaxed/simple;
	bh=ihWm/diQMKXpd3btQliC3n+mMuTecFBg60ksAzUtocY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJ9ARkmIMZ1DfEbWWQ83J2r4ieQh3vJF6ClRKky2ryxxRHzjan2NGnLzAadRdB+A0UEJ7TJbyW9dCOix4sYotUfXKFWVBNtiT82+TzBvXddSc9v1dCM4fnxgn6KTGGm51iCqUdokyl4SUNrfwsXWVJYzPB/Lv6xt16kMVgiQJQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sU28r-000000007mC-3VdG;
	Wed, 17 Jul 2024 10:44:13 +0000
Date: Wed, 17 Jul 2024 11:44:06 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: wens@kernel.org, linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Kaiser <martin@kaiser.cx>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Olivia Mackall <olivia@selenic.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <ZpegdlebtJ11qUbh@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
 <2451882.5D0I8gZW9r@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2451882.5D0I8gZW9r@bagend>

On Wed, Jul 17, 2024 at 10:22:18AM +0200, Diederik de Haas wrote:
> On Wednesday, 17 July 2024 04:58:51 CEST Chen-Yu Tsai wrote:
> > On Wed, Jul 17, 2024 at 10:25=E2=80=AFAM Daniel Golle <daniel@makrotopi=
a.org> wrote:
> > > On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
> > > > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> > > > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > >=20
> > > > I don't know if it means something, but I noticed that I have
> > > > ``Long run: 0`` with all my poor results,
> > > > while Chen-Yu had ``Long run: 1``.
> > > >=20
> > > > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
> > > > very poor result (100% failure):
> > > > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5B=
ydtW6
> > > > rB2S7jg+dnoX8hAoWg@mail.gmail.com/>=20
> > > The conclusions I draw from that rather ugly situation are:
> > >  - The hwrng should not be enabled by default, but it should by done
> > > =20
> > >    for each board on which it is known to work well.
> > > =20
> > >  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
> > > =20
> > >    defined in DT for each board:
> > >    * introduce new 'rochchip,rng-sample-count' property
> > >    * read 'quality' property already used for timeriomem_rng
> > >=20
> > > I will prepare a follow-up patch taking those conclusions into accoun=
t.
> > >=20
> > > Just for completeness, here my test result on the NanoPi R5C:
> > > root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
> > > rngtest 6.15
> > > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > > This is free software; see the source for copying conditions.  There =
is NO
> > > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
> > > PURPOSE.
> > >=20
> > > rngtest: starting FIPS tests...
> > > rngtest: bits received from input: 20000032
> > > rngtest: FIPS 140-2 successes: 875
> > > rngtest: FIPS 140-2 failures: 125
> > > rngtest: FIPS 140-2(2001-10-10) Monobit: 123
> > > rngtest: FIPS 140-2(2001-10-10) Poker: 5
> > > rngtest: FIPS 140-2(2001-10-10) Runs: 4
> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > > rngtest: input channel speed: (min=3D85.171; avg=3D141.102;
> > > max=3D4882812.500)Kibits/s rngtest: FIPS tests speed: (min=3D17.809;
> > > avg=3D19.494; max=3D60.169)Mibits/s rngtest: Program run time: 139628=
605
> > > microseconds
> >=20
> > I doubt this is per-board. The RNG is inside the SoC, so it could be a =
chip
> > quality thing.=20
>=20
> I agree with ChenYu (and others) that this is isn't a per-board level thi=
ng.
> I'd even go further: 's/I doubt/It can't be that/' (for the same reason=
=20
> though; this is inside the SoC).

There are quite a lot of options regarding the implementation of an in-SoC
RNG. Many of them rely on external components, such as a resistor or simply
a pin left floating. Others may be influenced by the power delivery setup.
Or rely on "thermal noise generated from inherently random quantum mechanic=
al
properties of silicon" (Intel).

I don't know which design Rockchip chose, but just because the RNG is
inside the SoC I wouldn't exclude the option that the quality it
delivers may depend also on external components on the board, or even
the dielectric properties of the board material itself, or (in case of
bad designs) environmental circumstances such as the amount of
electromagnetic noise around, and that then again depends on relative
humidity, exposure to sunlight, ... The latter would be really bad, of
course, because then we would have some kind of hidden sensor rather
than a RNG, but nothing is too stupid to not show up when engineers of
proprietary technologies are left alone.

So imho only empirical data can tell.

>=20
> Before I saw these latest emails, I was going to suggest:
> 1. Enable it only on RK3568 for now. I would be fine if this would be acc=
epted=20
> by the maintainer
>=20
> 2. Ask that you make a special version (for me) where I could play with t=
he=20
> params without having to compile a new kernel for each variant (it genera=
lly=20
> takes me more then 24h on my Q64-A). Either through kernel module propert=
ies=20
> or properties defined in the DeviceTree is fine with me.

+1 Will do.

>=20
> 3. Based on the results make  a choice to not enable it on rk3566 at all =
or=20
> (indeed) introduce DT properties to configure it differently per SoC.
>=20
> 4. Hope/Ask for more test results
>=20
> > On the RK3399 we also saw wildly varying results.
>=20
> On my Rock64('s) (RK3328) it doesn't work at all:
>=20
> ```
> root@cs21:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> cat: /dev/hwrng: No such device
> rngtest: entropy source drained
> ```
>=20
> Cheers,
>   Diederik



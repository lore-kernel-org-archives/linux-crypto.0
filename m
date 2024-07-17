Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A58442F;
	Wed, 17 Jul 2024 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721183115; cv=none; b=uGvdrUuAV0yfcmoGRlz7iNfhqPV6MsKSLDiRO0M5HKI8j5BB5nfy7jStYViKsmpl7sW97rgyUenx4Rv9tbM/JoVAPU8alXl/o3SHgaTrR04v/3CfLd8k6/Rj9D8DK+OZRRXou1Ns8xkm11QDLFsR5qEJntE7lCgWDelmuy96AiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721183115; c=relaxed/simple;
	bh=hTsCtKMMwpYJJaYHd+VYy/lZb1GbRWgDEPKlTd/+vwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVFxNCA3YiQlIEsxzBb1TXGJgrFUwPblqfJMQatR7KBHs8Yg1sqUeWW2crLjd5YJhm1pCyi+jw7JVxL8ye3HlboFUZXtRQdTAkqi432XoVMBF6oj/Ovf/XA4fO4xg5ARq2ejQXU5sJzD7lDwmWUwvMOlz7++RoSf5if8Zg7MAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sTuLk-000000006Cr-1FJG;
	Wed, 17 Jul 2024 02:25:00 +0000
Date: Wed, 17 Jul 2024 03:24:55 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, linux-rockchip@lists.infradead.org,
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
Message-ID: <ZpcrdwZBNFu-YlZt@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend>
 <3220752.Q7WYUMVHaa@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3220752.Q7WYUMVHaa@bagend>

On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
> On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
>=20
> I don't know if it means something, but I noticed that I have
> ``Long run: 0`` with all my poor results,
> while Chen-Yu had ``Long run: 1``.
>=20
> Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
> very poor result (100% failure):
> https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6r=
B2S7jg+dnoX8hAoWg@mail.gmail.com/

The conclusions I draw from that rather ugly situation are:
 - The hwrng should not be enabled by default, but it should by done
   for each board on which it is known to work well.
 - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
   defined in DT for each board:
   * introduce new 'rochchip,rng-sample-count' property
   * read 'quality' property already used for timeriomem_rng

I will prepare a follow-up patch taking those conclusions into account.

Just for completeness, here my test result on the NanoPi R5C:
root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
rngtest 6.15
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO =
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 875
rngtest: FIPS 140-2 failures: 125
rngtest: FIPS 140-2(2001-10-10) Monobit: 123
rngtest: FIPS 140-2(2001-10-10) Poker: 5
rngtest: FIPS 140-2(2001-10-10) Runs: 4
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D85.171; avg=3D141.102; max=3D4882812.5=
00)Kibits/s
rngtest: FIPS tests speed: (min=3D17.809; avg=3D19.494; max=3D60.169)Mibits=
/s
rngtest: Program run time: 139628605 microseconds

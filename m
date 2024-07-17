Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BDE6FC7;
	Wed, 17 Jul 2024 03:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721186122; cv=none; b=QfYmq6XCPGrvAD6eGbNmIGMIHBYFsSCkcj0+DtMJD+uT61uSltn+HRLY6tzePhlWbuCjYrS75cV7UVpqwzw1/Axlys5KCHfB0HMiUxm3LAr9Rk3lt5hUdRFdQACvwGnv9N4o+YLS9agMb6QQ4C14j9qQhtsJShF0V+u4KZZaGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721186122; c=relaxed/simple;
	bh=0XXAFXG/mhKhZLx8Pv4AZgz7Len+bOQYJP+Is+WaBVY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=b69sdfF8bFgKp3oYb5jBFscQKHkKizzoU4it1XNIYePZ5sdVN2o5XR9azfR9QjZBF1miaNEkrZRjaZCfMyWWNPHbR0HMxBrBEl565SFAuRr/lzj63Vt2/Xs6f5XW11GVwlSBgaODpy21YDE1RNymongPj2aaah3KcdkxKDY0nn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=m3KqP9U7; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="m3KqP9U7"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721186116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wx9wftMefKQGgxd4tgye4KZ94L9HNLNj4qERF5WWHdU=;
	b=m3KqP9U7ME7JQrwhR69D0rTanEjTBHOGgHUQNTwM+bth7qXiLW2WNT2fjKncXPMKnuYUk9
	bkMpRl4db/D8PL/PRoAv4Jqhr/t3E3cgBAeMBFgOpVf+rr1PwGN9cV59G1LSvPUBEYVoNK
	d/05KWxnJzVl4YQb3ftPjF99qSBtrnaTR0jUWzY3Iy+ZW1Q4UajL3qKGQ/KG+MSLW9QGvV
	W0ITpQfA2ujelg9r2MfhfWoC5TAVsYgYlcQ8pC/OaY0Nlq7q8ThqiCW55hLegIkcEkDQQH
	JW/LSu6xHcoEaWam2yHKNjyQ+650b7qgl5j0OqiX+s4BGRUCkhQNzwzR+nkcLg==
Date: Wed, 17 Jul 2024 05:14:22 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Diederik de Haas <didi.debian@cknow.org>, Chen-Yu Tsai
 <wens@kernel.org>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, Conor
 Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, Martin Kaiser <martin@kaiser.cx>, Sascha
 Hauer <s.hauer@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Ard Biesheuvel <ardb@kernel.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, Philipp Zabel
 <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, Heiko
 Stuebner <heiko@sntech.de>, Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
In-Reply-To: <ZpcrdwZBNFu-YlZt@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend> <3220752.Q7WYUMVHaa@bagend>
 <ZpcrdwZBNFu-YlZt@makrotopia.org>
Message-ID: <ff7e706b7d4f7924c8a3e0d9c6418d4e@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Daniel,

On 2024-07-17 04:24, Daniel Golle wrote:
> On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
>> On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
>> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> 
>> I don't know if it means something, but I noticed that I have
>> ``Long run: 0`` with all my poor results,
>> while Chen-Yu had ``Long run: 1``.
>> 
>> Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
>> very poor result (100% failure):
>> https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
> 
> The conclusions I draw from that rather ugly situation are:
>  - The hwrng should not be enabled by default, but it should by done
>    for each board on which it is known to work well.
>  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
>    defined in DT for each board:
>    * introduce new 'rochchip,rng-sample-count' property
>    * read 'quality' property already used for timeriomem_rng
> 
> I will prepare a follow-up patch taking those conclusions into account.

Please note that Chen-Yu ran the tests on a board based on the RK3568,
while Diederik ran the tests on boards based on the RK3566.  The 
observed
difference in the test results suggests that something differs betwen
these two SoC variants, instead of having the actual boards contributing
something to the whole thing.

In other words, I think that enabling the HWRNG on per-board basis isn't
the right thing to do, but it should be enabled on per-SoC basis, after
enough testing is performed on the particular SoC.  The same applies to
defining any HWRNG properties in the DT.

If we really had to enable the HWRNG on per-board basis, that would mean
that some issues exist for certain SoC batches, affecting some boards.
AFAIK, the actual board design can't affect the operation of the HWRNG,
so any HWRNG issues associated with some boards can have their SoCs as
the only root cause.  Consequently, if any board experiences issues,
we should discard its SoC as having unreliable HWRNG, because another
sample of the same board, or a sample of some other board based on the
same SoC, may or may not experience the same issues.

I hope all this makes sense.

> Just for completeness, here my test result on the NanoPi R5C:
> root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.15
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There
> is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
> PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 875
> rngtest: FIPS 140-2 failures: 125
> rngtest: FIPS 140-2(2001-10-10) Monobit: 123
> rngtest: FIPS 140-2(2001-10-10) Poker: 5
> rngtest: FIPS 140-2(2001-10-10) Runs: 4
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=85.171; avg=141.102; 
> max=4882812.500)Kibits/s
> rngtest: FIPS tests speed: (min=17.809; avg=19.494; max=60.169)Mibits/s
> rngtest: Program run time: 139628605 microseconds

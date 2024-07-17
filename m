Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5153FC2;
	Wed, 17 Jul 2024 03:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187288; cv=none; b=kE0LzjUTY8OoWwfkP5GOXO8zW3VJq7QrJcqcEn77ilAoQp5x18C9OgT37GvOoNGD15ymYYJVkiKz78ICqq5ssTQWwLldbSoeNkMxS4qZOlqCSWag/48oPVl5egsiSJcTvJCwK5HEbTujDs6MW5+V6xuYt2C2c9vJuYLRel1QvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187288; c=relaxed/simple;
	bh=revVXqJxO5Mf0DgXjmCC7hn/x0r6Xkl1oGS5IVp/IUc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=qZeO3T9hB6vcaNalHD5LmkJOSgK0By0r7ChytqdpL+KBMCRgXtjVFSfW/qH1d6NfyXEzODTFfmoci0kwszP7FmNnvAOSyKRtbvXlo+LPw8RL55gwNFiIpQnXIHIj0FvRI7TT4x0yeatUNvomZwOTU22PRiV54mztOTpeUUo39l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=p+uAR7xB; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="p+uAR7xB"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721187282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=COav+P6D8Thnl7OBoNjZIZeMCNp9srdIVybeCzhIGtw=;
	b=p+uAR7xBEblapW+azWLMXCG+GlZoxItPsx4n3sxBTD9eM28VtYID7izMfpBrQ93U+mSe5g
	AyVN4JdqCDWKTFevB7ghr/0mO0mldYbt1uxNpflIz+sH2j0CgNAzRAxGwisOlkHsh2BT41
	bQu1ZYP9aPsC8D05iVs9m9Iyu/idZ55crhrM5AZJCBQuIU/EQKhk8Zd9l9w3teEncZ4tv+
	bTbujhtjVzgwXpumwXmNj6BoGgO4W41fNiKdLD5lFD2okBhjmtEdIZogiAQ769cURmHoi/
	bZjsEDNFJ0w4g8HENPBdES9LUTvMTwROcAhwrFamJVLRW0fZnXUrn2L65nbpCA==
Date: Wed, 17 Jul 2024 05:34:41 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: wens@kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>, Diederik de Haas
 <didi.debian@cknow.org>, linux-rockchip@lists.infradead.org,
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
In-Reply-To: <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend> <3220752.Q7WYUMVHaa@bagend>
 <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
Message-ID: <d5071401e8032af610c01a9d5887f186@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Chen-Yu,

On 2024-07-17 04:58, Chen-Yu Tsai wrote:
> On Wed, Jul 17, 2024 at 10:25 AM Daniel Golle <daniel@makrotopia.org> 
> wrote:
>> 
>> On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
>> > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
>> > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> >
>> > I don't know if it means something, but I noticed that I have
>> > ``Long run: 0`` with all my poor results,
>> > while Chen-Yu had ``Long run: 1``.
>> >
>> > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
>> > very poor result (100% failure):
>> > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
>> 
>> The conclusions I draw from that rather ugly situation are:
>>  - The hwrng should not be enabled by default, but it should by done
>>    for each board on which it is known to work well.
>>  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
>>    defined in DT for each board:
>>    * introduce new 'rochchip,rng-sample-count' property
>>    * read 'quality' property already used for timeriomem_rng
>> 
>> I will prepare a follow-up patch taking those conclusions into 
>> account.
>> 
>> Just for completeness, here my test result on the NanoPi R5C:
>> root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
>> rngtest 6.15
>> Copyright (c) 2004 by Henrique de Moraes Holschuh
>> This is free software; see the source for copying conditions.  There 
>> is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A 
>> PARTICULAR PURPOSE.
>> 
>> rngtest: starting FIPS tests...
>> rngtest: bits received from input: 20000032
>> rngtest: FIPS 140-2 successes: 875
>> rngtest: FIPS 140-2 failures: 125
>> rngtest: FIPS 140-2(2001-10-10) Monobit: 123
>> rngtest: FIPS 140-2(2001-10-10) Poker: 5
>> rngtest: FIPS 140-2(2001-10-10) Runs: 4
>> rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>> rngtest: input channel speed: (min=85.171; avg=141.102; 
>> max=4882812.500)Kibits/s
>> rngtest: FIPS tests speed: (min=17.809; avg=19.494; 
>> max=60.169)Mibits/s
>> rngtest: Program run time: 139628605 microseconds
> 
> I doubt this is per-board. The RNG is inside the SoC, so it
> could be a chip quality thing.

Totally agreed.  I see no way how a board design could affect the
HWRNGs built into Rockchip SoCs.  I even checked the RK3399 and
RK3566 Hardware Design Guides to be extra sure.

> On the RK3399 we also saw wildly varying results.

In my opinion, that qualifies the RK3399's HWRNG as unsuitable for
general use.  Having a HWRNG that fails to pass the tests on _some_
units is simply not acceptable from the security standpoint.

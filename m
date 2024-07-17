Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A94B665;
	Wed, 17 Jul 2024 05:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721193515; cv=none; b=O3x6pa8n3O9Tus0mthllfgn6dMsAJyeikTV/8Dslz/9VTxUF3h6t9itfLJXDj5yUjXkfhTryascnfDeal/O1iTvg8R1iHKLyH09naECB/wvRKIkj/wZdYhUSXqWGwBSH3rtauEdfbdFGjK+ocU6ydwg3/CxDlpQjvIuT+Z9q2pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721193515; c=relaxed/simple;
	bh=zI3v/iof2qXRITRXL94cpHC4Z1tce4Y/9I5j0ewg0Gg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=LT4HUrr6/WRCCn67C1v17PSWMRqtFT77NpIvm2LdmAVsYFka45aKiaQjt4cVAMuvFncLvxTg/l7Z02fOqCQt4bscNgW3N+DDF+qEIWo374iySJQjy+qVcTINrWsJpxVbe4Udzk3ptIZF/ruq/7zxlg6UWgqZHKBfVCagMPnmogU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=C7VUIFMQ; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="C7VUIFMQ"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721193509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Js8sqWzBerizJJcE4j5H4vl9+Y+2wmbUBag2iVhUq3E=;
	b=C7VUIFMQIuP+oVILPDwvq0+0o+4rFBFzNG/TZyExlB4EAu+uoePvGMgjCORFe24tfQjLAk
	qkDlcHlbZ3yTY+pm18hs4GzOWpxi4qolVdJdrbvi90CjMz8fF98iV7H2uL3KNblXnyOKPw
	ES/kNCcIVrBZkBURazqPobqH5auKN41ZwnPKlF0f6+uotziIN0miKbwYieklGE2kiErhU3
	bYrbC7Gg9VoMqz/botOtjjhGylvBuDjeRBpPLlO9pRFxUyQDgtcUnDRFx8Ef1wFES0wI5X
	Z+dq6FXa/f8elR74+CSNIlxp7d08lXtb3bTdEGmzWp70PEX1v9Btwc6F7PI78g==
Date: Wed, 17 Jul 2024 07:18:25 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Anand Moon <linux.amoon@gmail.com>
Cc: wens@kernel.org, Daniel Golle <daniel@makrotopia.org>, Diederik de Haas
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
 Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
In-Reply-To: <CANAwSgSYMkUKeAR7=zcDLDVo7vJMwemRxP-iba-ByDtRq75yyw@mail.gmail.com>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend> <3220752.Q7WYUMVHaa@bagend>
 <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
 <CANAwSgSYMkUKeAR7=zcDLDVo7vJMwemRxP-iba-ByDtRq75yyw@mail.gmail.com>
Message-ID: <51011274265ab684763287e4c02b6cd4@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Anand,

On 2024-07-17 07:06, Anand Moon wrote:
> On Wed, 17 Jul 2024 at 08:29, Chen-Yu Tsai <wens@kernel.org> wrote:
>> 
>> On Wed, Jul 17, 2024 at 10:25 AM Daniel Golle <daniel@makrotopia.org> 
>> wrote:
>> >
>> > On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
>> > > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
>> > > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> > >
>> > > I don't know if it means something, but I noticed that I have
>> > > ``Long run: 0`` with all my poor results,
>> > > while Chen-Yu had ``Long run: 1``.
>> > >
>> > > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
>> > > very poor result (100% failure):
>> > > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
>> >
>> > The conclusions I draw from that rather ugly situation are:
>> >  - The hwrng should not be enabled by default, but it should by done
>> >    for each board on which it is known to work well.
>> >  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
>> >    defined in DT for each board:
>> >    * introduce new 'rochchip,rng-sample-count' property
>> >    * read 'quality' property already used for timeriomem_rng
>> >
>> > I will prepare a follow-up patch taking those conclusions into account.
>> >
>> > Just for completeness, here my test result on the NanoPi R5C:
>> > root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
>> > rngtest 6.15
>> > Copyright (c) 2004 by Henrique de Moraes Holschuh
>> > This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>> >
>> > rngtest: starting FIPS tests...
>> > rngtest: bits received from input: 20000032
>> > rngtest: FIPS 140-2 successes: 875
>> > rngtest: FIPS 140-2 failures: 125
>> > rngtest: FIPS 140-2(2001-10-10) Monobit: 123
>> > rngtest: FIPS 140-2(2001-10-10) Poker: 5
>> > rngtest: FIPS 140-2(2001-10-10) Runs: 4
>> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
>> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>> > rngtest: input channel speed: (min=85.171; avg=141.102; max=4882812.500)Kibits/s
>> > rngtest: FIPS tests speed: (min=17.809; avg=19.494; max=60.169)Mibits/s
>> > rngtest: Program run time: 139628605 microseconds
>> 
>> I doubt this is per-board. The RNG is inside the SoC, so it could be a 
>> chip
>> quality thing. On the RK3399 we also saw wildly varying results.
>> 
> I feel the latest rng-tool only supports Intel platform x86_64 and 
> i386.
> It has no proper support for Arm64 and Armv7
> It is heavily modified for the X86 platform
> so it's not suitable for testing on other platforms.
> 
> If we enable HWRNG on all the Rockchip platforms it will be better.
> 
> [1] https://github.com/nhorman/rng-tools

I don't see what could be tweaked in rngtest(1) to support any platform
better than the other, and still remain a valid test.  It just applies
certain FIPS test(s) to the random data obtained from /dev/hwrng or some
other source, and if that testing is tweaked in any way, then the test
results aren't valid on any platform.

In other words, perhaps the other components of rng-tools are tweaked to
support "mainstream" platforms better, but rngtest(1) simply must not be
tweaked in any way.

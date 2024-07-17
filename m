Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151739FEB;
	Wed, 17 Jul 2024 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721205091; cv=none; b=ZthLeAK1EP1mk5cQINUWW4RJG85KGW0Nf9IgvKRCA/f3+/tGMNnIhekGDYMahxmQz89oroXi7iQHccTGaauhptJNQlpK9tH38zw5QzUYNhGhC/IVIzT633rZrtqGmBJyZQzgD/3p3r8HQ2ZaS3jyw4cYvBZS25S3EupAlBkgrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721205091; c=relaxed/simple;
	bh=e52W9gDmTSwXYqbXdTNHJh+IUg5OVm4eoYTt/66PdPs=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=hmkm+8Cy67hnoPozMOWT9B+kwcbRYXNxsbH7wbNUGhfqtZg9y9mknxbGY7ggBRF5UfKy8CXPL0UIK6CHCEQMZ0KCH2i3w3N9YSBaLDPErrUb+7ZED4IhwSyPu0pVauNPkPE08UODFfKUkVzhh33q3eXBoJtta4P1ZOxhl2DqNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=MA0cPLpQ; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="MA0cPLpQ"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721205086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djaTs/VXwkde5ykilmezCihZKxxTBjysv9dBh/bulSc=;
	b=MA0cPLpQgynOCTGF3xZ7pX9SK2i58JLa7/0jsJS1Id8InlVCPmjxeW4Q/GMrMUNKN4gLNs
	24eQupFiIzNlvEQqlN/q06ryLe6oOheQgQVibDHG5U4yBli8Gkm0dHFuJKYRpPMS7wDSwa
	zHLA1eJW0jrfoGoYxa3QLdY0/QxlFNqpdiMXd3zfjlocyRgLt5i8RqY1h/6t/L/K7BLfvN
	Ag7BNNYY/y56aqr9oeUqXxicfNvD6wZuXtawK0C2OKBlP9Z0mdLk4dAiud1T9ldnOf+htB
	8G0p20FQgWUEuLsPDLYvCgJmcRbx2MD0B75xG9AaHOe0rvjns5PcLuLsCXM9MA==
Date: Wed, 17 Jul 2024 10:31:22 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Daniel Golle <daniel@makrotopia.org>, wens@kernel.org,
 linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Kaiser <martin@kaiser.cx>, Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>, Ard Biesheuvel
 <ardb@kernel.org>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, Philipp Zabel
 <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, Heiko
 Stuebner <heiko@sntech.de>, Anand Moon <linux.amoon@gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
In-Reply-To: <2451882.5D0I8gZW9r@bagend>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
 <2451882.5D0I8gZW9r@bagend>
Message-ID: <8357f8b7a55f88186b8a222457ba5fcf@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Diederik,

On 2024-07-17 10:22, Diederik de Haas wrote:
> On Wednesday, 17 July 2024 04:58:51 CEST Chen-Yu Tsai wrote:
>> On Wed, Jul 17, 2024 at 10:25 AM Daniel Golle <daniel@makrotopia.org> 
>> wrote:
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
>> > > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6
>> > > rB2S7jg+dnoX8hAoWg@mail.gmail.com/>
>> > The conclusions I draw from that rather ugly situation are:
>> >  - The hwrng should not be enabled by default, but it should by done
>> >
>> >    for each board on which it is known to work well.
>> >
>> >  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
>> >
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
>> > This is free software; see the source for copying conditions.  There is NO
>> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
>> > PURPOSE.
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
>> > rngtest: input channel speed: (min=85.171; avg=141.102;
>> > max=4882812.500)Kibits/s rngtest: FIPS tests speed: (min=17.809;
>> > avg=19.494; max=60.169)Mibits/s rngtest: Program run time: 139628605
>> > microseconds
>> 
>> I doubt this is per-board. The RNG is inside the SoC, so it could be a 
>> chip
>> quality thing.
> 
> I agree with ChenYu (and others) that this is isn't a per-board level 
> thing.
> I'd even go further: 's/I doubt/It can't be that/' (for the same reason
> though; this is inside the SoC).
> 
> Before I saw these latest emails, I was going to suggest:
> 1. Enable it only on RK3568 for now. I would be fine if this would be 
> accepted
> by the maintainer

I think we need more testing on more units of the RK3568 SoC, simply
because the HWRNG may work badly on some units.  I know that it sucks,
but we basically need just one "bad apple" to mark an SoC as having
an unreliable HWRNG, which is IMHO the only right thing to do.

Of course, unless we can prove that tweaking the HWRNG knobs makes such
"bad apples" work well.

> 2. Ask that you make a special version (for me) where I could play with 
> the
> params without having to compile a new kernel for each variant (it 
> generally
> takes me more then 24h on my Q64-A). Either through kernel module 
> properties
> or properties defined in the DeviceTree is fine with me.
> 
> 3. Based on the results make  a choice to not enable it on rk3566 at 
> all or
> (indeed) introduce DT properties to configure it differently per SoC.

See above; unfortunately, we already have some "bad RK3566 apples".

> 4. Hope/Ask for more test results
> 
>> On the RK3399 we also saw wildly varying results.
> 
> On my Rock64('s) (RK3328) it doesn't work at all:
> 
> ```
> root@cs21:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> cat: /dev/hwrng: No such device
> rngtest: entropy source drained
> ```

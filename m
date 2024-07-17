Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CA812;
	Wed, 17 Jul 2024 05:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721192791; cv=none; b=MZ2SN0/kAbqdoyRVZdsldmsw9hfNmiKolsn1+rsE8xUTxUGysuzJUsnfcTD1iS4iiaOszJ7uNT4LtHjW7MqY0CW/w3GFY0wwz5Nr0RyEbuPl1gPxuzFmoXL0LyJ2d7qGAXs2dvNCnyGauwH3/wSklkZ+qa2fIvWfa4JJLC0kAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721192791; c=relaxed/simple;
	bh=BmfL3ybli5os9BFCQ4pMPq4tg/YHlvX8g8Rrou8rygw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vbd8Di/6rJvZIih8lCWKw4KF/XVS61yhgfQEsp3pJj86RZmj1AE3Ridbj0SXEiSPcrEETTqI7IphqT92APTPiJY+ClF0lugGfmmEVqa/BVIq1xZOQ6sVyH2VTfMH5GMMg2+g8gv81cTFLE4m4C9VBRB3rAp+6c5vwDIWv320Ah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRNmxiSq; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRNmxiSq"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5c661e75ff6so278819eaf.2;
        Tue, 16 Jul 2024 22:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721192788; x=1721797588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mySpAEp/UqJ28m/AyDd/FGgPzMIYTnGpdOicI1nuZ1I=;
        b=HRNmxiSqPoul74DHIPijphYUJbP4RyuAxQjfyOyTIVS/S7Kqvu2wO+d/nerXTYoRYj
         9IfpuNbKeXeKa5yo+dKqohUHA3PfPLO0WJkrjplCRA2Uew6cCWeqj9NeO6WxH38YaV8Z
         zxkueIqu1lyXSjVPGJPDyxdo/e6Q1e+rnbmM/FCz2Kzi2/0RajuldSTvQoUeXYR4zpwN
         OHv7ZOnyv0mTwuGcsZOL7e4j2mNiG4Yfv0cRqrDFxH5o2QD0fM8rbQBknd4wigDhvkAF
         G6a2xIe61gaBxzyG6MxTG+OJ42TEqyEvXmeGKC807/TzKARKZBWZo7etjI0U1bnVoAl3
         aVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721192788; x=1721797588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mySpAEp/UqJ28m/AyDd/FGgPzMIYTnGpdOicI1nuZ1I=;
        b=KKLusC3KYEoDobABZ9YLZ7QUv47Bf5zfXeUq5TNtJsDMIW9uKgPFtMUCIKjqSmAVOg
         dBzSPFi+aufGNTAmjsvdsEZDzrSQWmEZGFyEtyW1TRNJiu5NIXHbIYbYw2eCTvcONumW
         TcZ3HrwTxeNnyJx32Q6o5jwAkhCzf1+0SI5lwR/LrTXnCmfBgya9kAUJQYoAQqRK5t+1
         ucRSZdhlslsKkKYEzZ1A8et5uA7IF4jsfpuzMxxZ6HjHAiQ/27KpvVoDiA+wlB1chtqo
         GN0fXWs6AsFusa7IVbVZm4u73LxxCQOX93SDuCYnIwrbvbV3Y39EosdM9a1P9KIqKG2X
         T5aw==
X-Forwarded-Encrypted: i=1; AJvYcCWxYx8NIXbQ2qPEr7H6DOcGiX1oUgdnvHQsFL3g9uAgXd+bFNZoFFsFOmpD7jyruTglFT/2isOPvuhe1Rnckb91gCTsM2P+AEgD/4ddRfQm7GppxjJKEYHzE4+p9o0XuJ/vSyoWr1muHIgFihIQ8YNIQN+bZpF7YMl3aXJcXdnOPm67h4rknQ==
X-Gm-Message-State: AOJu0Yybv9RbFFJo9S4VQVz++y/jYjVKZ7xGL9cGPXNbASpmQZHVzOs5
	3Y/renZLUNAM2bCZKZpkXiXSFm9DjUT6h1PG/wM9D2W1/Jgro7MvdO4ESOywbqFD32iqSlQx2zq
	0jEM3W5P8B3IC4EU3wDQu7rFeGHRjFF/W
X-Google-Smtp-Source: AGHT+IG0x7r2SO5JuYCgDDmNjlCcdKICzLNJNWdqyf5y6Pt0K3ICDXDlTHRr0lhRn45awdtmHoObwkJXboJUTte0dRA=
X-Received: by 2002:a05:6820:210:b0:5ce:f75b:1755 with SMTP id
 006d021491bc7-5d41c7ee5fcmr724545eaf.4.1721192788465; Tue, 16 Jul 2024
 22:06:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720969799.git.daniel@makrotopia.org> <CAGb2v67zxs03xScN8OfWXR1gf8tddJciXrjw3FQZcL7pR3ocxA@mail.gmail.com>
 <3190961.CRkYR5qTbq@bagend> <3220752.Q7WYUMVHaa@bagend> <ZpcrdwZBNFu-YlZt@makrotopia.org>
 <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
In-Reply-To: <CAGb2v65Mm5s96asU7iaAC_sJnUk=Yuh+zMJJBbmSgETWrPLoFA@mail.gmail.com>
From: Anand Moon <linux.amoon@gmail.com>
Date: Wed, 17 Jul 2024 10:36:12 +0530
Message-ID: <CANAwSgSYMkUKeAR7=zcDLDVo7vJMwemRxP-iba-ByDtRq75yyw@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
To: wens@kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>, Diederik de Haas <didi.debian@cknow.org>, 
	linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
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

Hi All,

On Wed, 17 Jul 2024 at 08:29, Chen-Yu Tsai <wens@kernel.org> wrote:
>
> On Wed, Jul 17, 2024 at 10:25=E2=80=AFAM Daniel Golle <daniel@makrotopia.=
org> wrote:
> >
> > On Tue, Jul 16, 2024 at 07:19:35PM +0200, Diederik de Haas wrote:
> > > On Tuesday, 16 July 2024 18:53:43 CEST Diederik de Haas wrote:
> > > > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > >
> > > I don't know if it means something, but I noticed that I have
> > > ``Long run: 0`` with all my poor results,
> > > while Chen-Yu had ``Long run: 1``.
> > >
> > > Different SoC (RK3399), but Anand had ``Long run: 0`` too on their
> > > very poor result (100% failure):
> > > https://lore.kernel.org/linux-rockchip/CANAwSgTTzZOwBaR9zjJ5VMpxm5Byd=
tW6rB2S7jg+dnoX8hAoWg@mail.gmail.com/
> >
> > The conclusions I draw from that rather ugly situation are:
> >  - The hwrng should not be enabled by default, but it should by done
> >    for each board on which it is known to work well.
> >  - RK_RNG_SAMPLE_CNT as well as the assumed rng quality should be
> >    defined in DT for each board:
> >    * introduce new 'rochchip,rng-sample-count' property
> >    * read 'quality' property already used for timeriomem_rng
> >
> > I will prepare a follow-up patch taking those conclusions into account.
> >
> > Just for completeness, here my test result on the NanoPi R5C:
> > root@OpenWrt:~# cat /dev/hwrng | rngtest -c 1000
> > rngtest 6.15
> > Copyright (c) 2004 by Henrique de Moraes Holschuh
> > This is free software; see the source for copying conditions.  There is=
 NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURP=
OSE.
> >
> > rngtest: starting FIPS tests...
> > rngtest: bits received from input: 20000032
> > rngtest: FIPS 140-2 successes: 875
> > rngtest: FIPS 140-2 failures: 125
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 123
> > rngtest: FIPS 140-2(2001-10-10) Poker: 5
> > rngtest: FIPS 140-2(2001-10-10) Runs: 4
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=3D85.171; avg=3D141.102; max=3D48828=
12.500)Kibits/s
> > rngtest: FIPS tests speed: (min=3D17.809; avg=3D19.494; max=3D60.169)Mi=
bits/s
> > rngtest: Program run time: 139628605 microseconds
>
> I doubt this is per-board. The RNG is inside the SoC, so it could be a ch=
ip
> quality thing. On the RK3399 we also saw wildly varying results.
>
I feel the latest rng-tool only supports Intel platform x86_64 and i386.
It has no proper support for Arm64 and Armv7
It is heavily modified for the X86 platform
so it's not suitable for testing on other platforms.

If we enable HWRNG on all the Rockchip platforms it will be better.

[1] https://github.com/nhorman/rng-tools

> ChenYu

Thanks


-Anand

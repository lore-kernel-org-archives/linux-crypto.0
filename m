Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8414A4414;
	Sun, 21 Jul 2024 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721569878; cv=none; b=tIklgapWRyv3M6hecocdI6TD73yQu5ueH3nX7nJZSVjMmS7n2MrwpJafr272gcaFmCASVEc3R1bhKg2WQ18foeuiuIrsf4c7y3Z/9RFDchtpUvo5wX2UZm+Uyorkoc49sTNIKS/iomDagkoyV8V2RsiNKRN2D2AcNKf+f66S+bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721569878; c=relaxed/simple;
	bh=bhnvYX34GXcziuOg5YrQZ/XfjZkMwzt4iDes0G8BDQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=faalTA8NL4ZGB3kkkFd0YI1VJ5WhLrDbFw7CuPbjEfTiGfarJ5YRLdHkcd0qauTNo8VcYtZ/g8TMs+pYrUzt6LWUB22HoS5x4xknWdoAcywePtZjokGmn/bNkVQsqNxf4WVvsRPxm8G3Nhx6QbeD0JhN/gZ9QqBQ61Io1KDp81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=aLmpJabu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aLmpJabu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B50C4AF0E;
	Sun, 21 Jul 2024 13:51:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aLmpJabu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721569873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UuD2foEERRRpEhFk8ZpQ8lRWoO79GE6pHriVooejuIw=;
	b=aLmpJabuHZeu7wwRM2n57ZNB8BQWoPvyRakoEAvHJyLbNf6tBJvNvbt7nLOAjU5kXG/0ht
	+eXvrHkRfkZt5cHS0pSrCYaVFgI2fT2Rm1dkpCDWNkbtZV2bE7k4WtPLeVD0sZjElUAcMQ
	Z2GPVQFgwFXhG7laKecg92oPBjFtOZI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a0ce794 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 21 Jul 2024 13:51:13 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-70847d0cb1fso1889825a34.3;
        Sun, 21 Jul 2024 06:51:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUcduXVeunKRKwNyWhAVuGpSbhSp/uyDeeLGIMqx+E/SZQYHQv+O2hQnUzafl7V7TCuVO96Bu9fOYT+JBZYELqCU8CZleyrMS41UAjPN11bS/6A+cuCBDuC52HSKidq/6uo3AQGT6WqtAnyP8CgVw+XAsOjadLzq0ZOpjAQossIzffOkn6Ltw==
X-Gm-Message-State: AOJu0YxvuVFmnV2gDlc3l4IQsS39A2uDYllg3n7jgoGzWND0r8o9ImVG
	gwV/tqmoyvf3qsP++aQOr57KbCuBkk5+I5+e+htYlKiHpNVkoWyA0l8I7X8cFxWlpDIw3ItceSG
	axIwlhylOfCAfs3bTsnhFFKG9y1Y=
X-Google-Smtp-Source: AGHT+IFsMlVRtNwCXluUUXjW9ka5Q7ZhDwyasPEQ56gn6Eo7mx7wDJvxEZ5Eug0XalQazDCf32gnVeHUc/x5z7LJ0Gw=
X-Received: by 2002:a05:6870:7193:b0:260:e2ed:1abe with SMTP id
 586e51a60fabf-2612163699cmr4854499fac.39.1721569871308; Sun, 21 Jul 2024
 06:51:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1721522430.git.daniel@makrotopia.org> <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>
 <Zpz5-2q-C0oQBqoa@zx2c4.com> <Zp0R3YtzDoi02P1K@makrotopia.org>
In-Reply-To: <Zp0R3YtzDoi02P1K@makrotopia.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 21 Jul 2024 15:51:00 +0200
X-Gmail-Original-Message-ID: <CAHmME9pAgDV_kQZXTDG0LiX7W6+SBL3+fNsF6B-RyTMXRMxBnw@mail.gmail.com>
Message-ID: <CAHmME9pAgDV_kQZXTDG0LiX7W6+SBL3+fNsF6B-RyTMXRMxBnw@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Dragan Simic <dsimic@manjaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sascha Hauer <s.hauer@pengutronix.de>, 
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>, Martin Kaiser <martin@kaiser.cx>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 21, 2024 at 3:49=E2=80=AFPM Daniel Golle <daniel@makrotopia.org=
> wrote:
>
> On Sun, Jul 21, 2024 at 02:07:23PM +0200, Jason A. Donenfeld wrote:
> > On Sun, Jul 21, 2024 at 01:48:38AM +0100, Daniel Golle wrote:
> > > From: Aurelien Jarno <aurelien@aurel32.net>
> > >
> > > Enable the just added Rockchip RNG driver for RK356x SoCs.
> > >
> > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > ---
> > >  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  7 +++++++
> > >  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
> > >  2 files changed, 17 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/bo=
ot/dts/rockchip/rk3568.dtsi
> > > index f1be76a54ceb..b9c6b2dc87fa 100644
> > > --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > > +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > > @@ -257,6 +257,13 @@ power-domain@RK3568_PD_PIPE {
> > >     };
> > >  };
> > >
> > > +&rng {
> > > +   rockchip,sample-count =3D <1000>;
> > > +   quality =3D <900>;
> >
> > As I already wrote you for v7, quality is out of 1024, not 1000, so thi=
s
> > won't hit 90% as you intend.
>
> It's not actually 90%. Around 125 out of 1000 test runs are failing on
> the R5C boards I got here, so that makes it 87.5% which is pretty close
> to the 87.9% of the 900/1024 figure there, hence I kept it 900 despite
> your comment.

Just do 922?

>
> >
> > But also, I think putting this in the DT is a mistake. Other drivers
> > don't generally do this, and if the hardware is actually the same piece
> > to piece (it is...), then there's not per-manufactured unit tweaking
> > needed. So keep this in the actual driver C like other drivers.
>
> So quality should be assigned using the DT compatible, right?
> And if needed we should have several of them, one for each SoC (if
> testing now turns out to show that the results are specific for the SoC
> rather than for the board).

No, do it in the C. If you don't have evidence of such crazy
complexity and diversity, don't overengineer for it. Nothing else does
this in the DT.

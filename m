Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC02F8C34
	for <linux-crypto@vger.kernel.org>; Fri,  4 Jul 2025 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751650582; cv=none; b=uLkCJWNsCm5/9Kgh8amsJaHcOKQkvoDRqYa2vh3d7iu42YfBzsXMi3XI/4l74jw6+pHq/hi5kBNd3Wjq9SS0i8eQ/cKs13pV/RgeV1X0xXhHz5qkLmBIdovUQNaICNYakFXZUSaMipRlb37BSFbOhSQT0xif0f4U4rvVU/XitPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751650582; c=relaxed/simple;
	bh=GmYJZP6Xc+LYEezxq1PksUUUJoTuFJ2anrOieQhfEiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F2iPIcR64iCUsi3loeekP943+cYkQKsJUS1Q18PJ+cHLvvS2UVfgJXKd/1rzfwgNLTlkLeErFkBdCgMIMhsSm+/g90Lll89kc8QfEm0dwgsqSHJc/wRxzzWztDK4KZUJIydWdA3eY52iTkq+j8OM6C2Iyb3N7fgidlFg5B+R/BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=JG/aj/Wp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="JG/aj/Wp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0c4945c76so164858766b.3
        for <linux-crypto@vger.kernel.org>; Fri, 04 Jul 2025 10:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751650578; x=1752255378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gMVsSx3VDJCjM0/V6JS1Ju4gdqnvsZW/tG6WKrnPP0=;
        b=JG/aj/Wp8joH3ZjJdiHbBsx1j8PFAMMtHCadbJigMjkx7zR8Gk6iBuEJjyoDpD/qwy
         GdMb+BI7R9vUZXFs6BaMVceR0cAfe6h2GL6N/iZMivqTlIOLe6yzyRJXrqynFJT4m+z4
         ETmICqjLPUqVpxx++E2nSKvTvWmBQRbZTJSA50yHeLjU2DQEp8f1CHn9Bp00r+bewLYA
         UHyW6tYJ5d/6R4hexxDqpuSBPf1b5jENlbdTrWDimoChpYoAlx0SLiW1Qse+GqeEdazM
         Hh6VK25RWbcHYbor7cJmJ+hk1HNxjrps8qn3wwvAKAoFB0jFb3ZxfLPGu2uiChBhvlKh
         ee4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751650578; x=1752255378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/gMVsSx3VDJCjM0/V6JS1Ju4gdqnvsZW/tG6WKrnPP0=;
        b=u7ZtbZGSkuP8UkQtlpKu/u95IcGL5mORwReEAE2wb/eFm4Frge+9EUCaxS6lqGyid7
         Olnnjq7PEcLVXqACcK7uW3+mkdMmyI897sDUq2zvcHcW+HWIkShr5Fjp1VHSWsHXqwn+
         FEeH3Xte04auqWYqOVIzCcDjyEez9a7JRP7Odgb1lEhwW+2J7ap2zwYFwvUnDmTrvKB/
         WSGpcf1ZZOlQ9lNVvYZwJImlbyL10fFzz2hvWp1+Ov1PHFsXnXdQ7cgfvoIcoXBUuEO8
         56j0LhGBVJ0/50SPel325q6+T8ndkHQns4n7Zb9lLWwu9pvbN/gfkNsNE9O8Aj7X+8f2
         P2Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVM0ox2/pYDHxWJ9Tx1rc5LjVnlXUojdWu6kk2b7fSZK5nXiglL1Keamu1BRCYx0f6OzsGd9msC0Ja2jDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQIPFcXeefk9awQoLwUKi/wA8RzpnYhKJMoC77RciZ8iZ609eD
	PCHfJMGNsagFmHFh/+H8SkZt6egnkFh/amauODkvHoPGgiMbFmQovStnUbDmpEP27dtmV+9Q7F9
	An/S901vcl99xCcHFc8UZe+KDaHNIv5OTLRokK50ggQ==
X-Gm-Gg: ASbGnctGs5ROnpZViYg+Vot1cIhz6/36uKcmo7LfsnHcAgk+Bjz5/H6XEgCyAKRfZwX
	HQVD/4bH1xZtNCByD4GpAPEEl4trHJNZaTsmFEuhJDrGqs7JbTKASPSgA8iarXrzbqeavfBMXui
	qSdh7SqATW1+0r/79BDNSynufsLZDhkqCnKSclPhdkB+R5
X-Google-Smtp-Source: AGHT+IHeJ1Z6kLI9F18nPlTXJDs+kXmK3fscjH5F6AOkcbqCoHLdbo6tfPeiaHhkgOp4rTxkpu1/up/L9rb3ERUcPTE=
X-Received: by 2002:a17:907:9629:b0:ae0:628a:5093 with SMTP id
 a640c23a62f3a-ae3fe4581b0mr339627066b.3.1751650577806; Fri, 04 Jul 2025
 10:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702183856.1727275-1-robert.marko@sartura.hr>
 <20250702183856.1727275-2-robert.marko@sartura.hr> <ea353170-6e03-4231-afc2-3dc45253931d@app.fastmail.com>
 <CA+HBbNHxiU5+xVJTyPQFuCJLyEs5_MpybSBEgxi25bzaGfiVHA@mail.gmail.com> <421d61db-27eb-4ad2-bd98-eb187fd14b1e@microchip.com>
In-Reply-To: <421d61db-27eb-4ad2-bd98-eb187fd14b1e@microchip.com>
From: Robert Marko <robert.marko@sartura.hr>
Date: Fri, 4 Jul 2025 19:36:06 +0200
X-Gm-Features: Ac12FXwPCk_M7U49drkBOHMtvL2YaDYQKpMa88sHXtdMqEAGjR9SQcLiyG85r7Q
Message-ID: <CA+HBbNEiKWS71jtF_jqV9bdX9HVroaZSGMaeD-xFM8sm0kLtCw@mail.gmail.com>
Subject: Re: [PATCH v8 01/10] arm64: Add config for Microchip SoC platforms
To: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Russell King <linux@armlinux.org.uk>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
	Andi Shyti <andi.shyti@kernel.org>, Lee Jones <lee@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>, 
	Daniel Machon <daniel.machon@microchip.com>, luka.perkov@sartura.hr, 
	Conor Dooley <Conor.Dooley@microchip.com>, 
	Lars Povlsen - M31675 <Lars.Povlsen@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 3:56=E2=80=AFPM Nicolas Ferre
<nicolas.ferre@microchip.com> wrote:
>
> Robert, Arnd,
>
> On 03/07/2025 at 14:25, Robert Marko wrote:
> > On Wed, Jul 2, 2025 at 9:57=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> =
wrote:
> >>
> >> On Wed, Jul 2, 2025, at 20:35, Robert Marko wrote:
> >>> Currently, Microchip SparX-5 SoC is supported and it has its own symb=
ol.
> >>>
> >>> However, this means that new Microchip platforms that share drivers n=
eed
> >>> to constantly keep updating depends on various drivers.
> >>>
> >>> So, to try and reduce this lets add ARCH_MICROCHIP symbol that driver=
s
> >>> could instead depend on.
> >>
> >> Thanks for updating the series to my suggestion!
> >>
> >>> @@ -174,6 +160,27 @@ config ARCH_MESON
> >>>          This enables support for the arm64 based Amlogic SoCs
> >>>          such as the s905, S905X/D, S912, A113X/D or S905X/D2
> >>>
> >>> +menuconfig ARCH_MICROCHIP
> >>> +     bool "Microchip SoC support"
> >>> +
> >>> +if ARCH_MICROCHIP
> >>> +
> >>> +config ARCH_SPARX5
> >>> +     bool "Microchip Sparx5 SoC family"
> >>
> >> This part is the one bit I'm not sure about: The user-visible
> >> arm64 CONFIG_ARCH_* symbols are usually a little higher-level,
> >> so I don't think we want both ARCH_MICROCHIP /and/ ARCH_SPARX5
> >> here, or more generally speaking any of the nested ARCH_*
> >> symbols.
>
> Well, having a look at arch/arm64/Kconfig.platforms, I like how NXP is
> organized.
>
> SPARX5, LAN969x or other MPU platforms, even if they share some common
> IPs, are fairly different in terms of internal architecture or feature se=
t.
> So, to me, different ARCH_SPARX5, ARCH_LAN969X (as Robert proposed) or
> future ones make a lot sense.
> It will help in selecting not only different device drivers but
> different PM architectures, cores or TrustZone implementation...
>
> >> This version of your patch is going to be slightly annoying
> >> to existing sparx5 users because updating an old .config
> >> breaks when ARCH_MICROCHIP is not enabled.
>
> Oh, yeah, indeed. Even if I find Robert's proposal ideal.
>
> Alexandre, Lars, can you evaluate this level of annoyance?
>
> >> The two options that I would prefer here are
> >>
> >> a) make ARCH_SPARX5 a hidden symbol in order to keep the
> >>     series bisectable, remove it entirely once all references
> >>     are moved over to ARCH_MICROCHIP
> >>
> >> b) Make ARCH_MICROCHIP a hidden symbol that is selected by
> >>     ARCH_SPARX5 but keep the menu unchanged.
> >
> > Hi Arnd,
> > Ok, I see the issue, and I would prefer to go with option b and do
> > what I did for
> > AT91 with the hidden ARCH_MICROCHIP symbol to avoid breaking current co=
nfigs.
>
> Yep, but at the cost of multiple entries for Microchip arm64 SoCs at the
> "Platform selection" menu level. Nuvoton or Cavium have this already, so
> it's probably fine.

Yes, this is why I went with a menu instead, to me it is much cleaner.

So, how would you guys want me to proceed?

a) Keep the menu-based config symbol
or
b) Like for AT91, add a hidden symbol and keep the individual SoC-s in
the top level
platform menu?

Regards,
Robert

>
> >> Let's see what the sparx5 and at91 maintainers think about
> >> these options.
> >
> > Sounds good, let's give them some time before I respin this series.
>
> Thanks to both of you. Best regards,
>    Nicolas



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr

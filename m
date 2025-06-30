Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54BD25BEE8
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289694; cv=none; b=iOXj9IAoEO6FkBhGZxqzxS1nwZvUcrP6hIfB2Mw7c7UKLD/dBpMqBSbzuMlj4Xn8lvRV9SFbk8+VIH4MTfEkSIIGpHTja4YoeMgl48C/jZFuhYwvVOIJ+P16KEm8g5S9s89SB1aT4V2Pbu5p3NuuCRneYHIxIvbIQN4z9TiBZz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289694; c=relaxed/simple;
	bh=wYSk7fxInjdJNOHqBT3fau/40lgp1kFco8w401sE950=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GzoL6uRAyEa9h5Q/XPaDoI7mQKgwjrzk0pFyqy+yKYwx2whpxgqZW3iyKtYgdbntYig8s2/3+ANAN8dGn2ekBvELrknizcF7y4ye5orclJGYUkrSWR9oXwGmA0xJyu7Ew5WtyB6eAzayWemr1wzxov5W50GGyRnMHthhYn61W+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ZQTv4zdI; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ZQTv4zdI"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae223591067so375138266b.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 06:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751289691; x=1751894491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2I8CsrHjtRtD5BaYjtdOSFNgRck9IxhroTpwRBGBREc=;
        b=ZQTv4zdIh7dZ1Lg/rGgUPmWqnPT5GKG51d2hj3rr+Iar5/ZdgH8ostY0HGD9nH98oF
         eLRWZgiyAITEb6Z/oyXegjB/VS4cCK9L3P7t7+tyEjFsfjg/dygDensV6bQF1hvoGx5c
         d5gRhGF+PhBCLXbX2rAInJUHXRKouIPD2NBcwh2jGNn8Ih3bqVNq0Kam+RtqQB4QBVAC
         Ngn7WKq6Tz+uOwudmI+78VjSWRXZYyztWpu1dVtyMw7dWEIFzV0AgVniYKzRoxHVCH97
         SFmR0ZISn2FInckrd0R5ptTd95F6m1/KV+sUy6BAideGWb3nEgqWSKIFtN8pT9Jhp1zB
         9CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751289691; x=1751894491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2I8CsrHjtRtD5BaYjtdOSFNgRck9IxhroTpwRBGBREc=;
        b=vLYbpfl/vRWCp3UtkG32fmj4E3UunHbDuIKrOaVY7lYeAXm/mKMpcXDg9Sd+6z93j+
         j6KivUIvJixJ2UDp4BX3i8PijFUJN4MSYleZ7pi6NB1X60L/gqriIs9aykEPOtwmHLZg
         VbaxWvLSRhMsU3WI5ac06rRYroMnXw0eZtp0uk1lNzXDrW7Rg623qIj7IhW5kCUO6eWX
         d+vi7Rtm2VL0zSfaI/1AOD28F3xxbfnlaIjFalbQbYVFFkD0lGyejazgVJ4WfTokZ+Dt
         i92GvBS8mwIpfvqWoaRUZD+XgffYRdJuEUAhKt5OVI4+Vou0jdtbLUbBN8LFLYG5O+iL
         0+kw==
X-Forwarded-Encrypted: i=1; AJvYcCXFX+/1gHcYegXEB3XtsgG8YwxziHCIUtAFs6CV2MxbRp5wcOIqxUJcm1CJpuucaeatvu0eBi6G2XGwJPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp8RvFXmjyfqMg4NUb2+Nj8Am5d8MAn6YUugRoG/fLI47m6Tj0
	OqMJQgYeO4s0dtNtgnqGx+wR1KMOuzPecRkX1/8xRNTtKTE9z1e1I811gd1BF/qXMc/3y2jdEzQ
	TIHZELAjry3vlX+ZOdfG4uxuybv2cmr0+hd6G3KS0Nw==
X-Gm-Gg: ASbGnctR2j1/1qe695kpXzz1zf57NDtV8UlWEz0laHNVwaqE09WVmpkPXq1hGPVP8kK
	JgmGTZtSoWf5olFe6QQs4YYM5/YoCdTOEdSYYgu/h5RXwSQP4PpXPo0wBD+S1rVWJQ0lTrgYAP8
	Ckw7XluGXEaFu5gONpoPgaut1wQ2GOp32841tqtYK0q8UKN4vNhcc7
X-Google-Smtp-Source: AGHT+IExvta/iWzBmIlIztBuCgl2cUU6u80HBaLHyHvJJXhxVNxMY8nK4KaXwhnRKNkDAhQ4ZeG0igRs73XqWwJLjCE=
X-Received: by 2002:a17:906:df08:b0:ae0:a88e:6f20 with SMTP id
 a640c23a62f3a-ae34fd88f8cmr778815366b.15.1751289691157; Mon, 30 Jun 2025
 06:21:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613114148.1943267-1-robert.marko@sartura.hr> <3ba837f8-70bb-4b9e-a9f9-0e71b9e073c4@app.fastmail.com>
In-Reply-To: <3ba837f8-70bb-4b9e-a9f9-0e71b9e073c4@app.fastmail.com>
From: Robert Marko <robert.marko@sartura.hr>
Date: Mon, 30 Jun 2025 15:21:19 +0200
X-Gm-Features: Ac12FXxhA2Gp9rwQDhKKgV4ARb8lKQ6I8YMqCzExRny5q7pcafJNPwE_zl3e6I4
Message-ID: <CA+HBbNFd5hCKqUZY25Sws-o-0QALLue-JROyze_9biyuZZv4mg@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] arm64: lan969x: Add support for Microchip LAN969x SoC
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
	Andi Shyti <andi.shyti@kernel.org>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, ore@pengutronix.de, luka.perkov@sartura.hr, 
	Daniel Machon <daniel.machon@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 8:34=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Fri, Jun 13, 2025, at 13:39, Robert Marko wrote:
> > This patch series adds basic support for Microchip LAN969x SoC.
> >
> > It introduces the SoC ARCH symbol itself and allows basic peripheral
> > drivers that are currently marked only for AT91 to be also selected for
> > LAN969x.
> >
> > DTS and further driver will be added in follow-up series.
> >
> > Robert Marko (6):
> >   arm64: lan969x: Add support for Microchip LAN969x SoC
> >   spi: atmel: make it selectable for ARCH_LAN969X
> >   i2c: at91: make it selectable for ARCH_LAN969X
> >   dma: xdmac: make it selectable for ARCH_LAN969X
> >   char: hw_random: atmel: make it selectable for ARCH_LAN969X
> >   crypto: atmel-aes: make it selectable for ARCH_LAN969X
>
> If the drivers on ARCH_LAN969X are largely shared with those on
> ARCH_AT91, should they perhaps depend on a common symbol?
>
> That could be either the existing ARCH_AT91 as we do with LAN966,
> or perhaps ARCH_MICROCHIP, which is already used for riscv/polarfire.

Hi Arnd, I thought about this, but I am not sure whether its worth it
since we need
LAN969x arch anyway for other drivers that currently depend on LAN966x
or SparX-5
but will be extended for LAN969x (I have this already queued locally
but need this to
land first).

I hope this makes sense

Regards,
Robert
>
>     Arnd



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr

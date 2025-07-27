Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D870E212FAD
	for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2025 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620934; cv=none; b=r/l7kyI1veVrEtywZ25ZNZag7cksY4PQDJLzKJK+SyzdPhpZfJkaHYeLAsrojq0pkzF49wxOxtjNYuN4g8B9m0CmwQaOkN3AqWqVnwqK1qeu6b6Y/IXPbgOPiNLyBWqhMOuf/QweexLNIfEmVg+TBnyzWzs0/M9A3ZJHVtCJtyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620934; c=relaxed/simple;
	bh=BQ/JpxXpuSy7PbBgcydNfVF2w4td5TfhH0Fzlc5REsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfU/DKc3e2ouGBxt0hqBypvWFMQSiL9OBHUKTgjFVNjEMGAwTWHkN65TwtUGHQ5N6KR4GygoaqG+FOpSqQ2JNoFnXByYi3srVwYQs8FQDjd/BuEiWLLtvL8NlqxKP/3bD0HXwgFYRrdVwYzHzztmTCZoytA3z928ER5tFkNq2HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=c0uvMYtE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="c0uvMYtE"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6150be62be4so1575991a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2025 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1753620931; x=1754225731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMxifAIqWO9udZ2NZ9E8Ene5GRXydyVi9Idk6pBIlxA=;
        b=c0uvMYtEJFdVp+74ymehaYZDUS3V+nzKzazfRjmJE/+EjM/hG0j+ExWD5KtIVAt4q8
         WpIU1wLnfTY9d6P1VCdHTl72WRScOnUW06Oa9K2VQ2YkVRWOsHkHu/l2ayLPgvHOp1jE
         Z43U+D9AzbHIwn58Yw1mJfIgYZjM8O7z7pQENFkXfsyVgJoaiBp4+cgM0LX9S36ykbjx
         D7vQwOPooQhha+KSrhae+b76IU8DJME/6pehdSOtQacsxeYuvK66Pc6gs9V2C8A3yPY8
         MmDhdskiPqiQ2ao0Gw1vJq4x8kRY13jiIYoVu5ihckQrjba6bM7Lq3ND51FZgPP5Btbj
         lvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753620931; x=1754225731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMxifAIqWO9udZ2NZ9E8Ene5GRXydyVi9Idk6pBIlxA=;
        b=iz0dXYHsST4vQvuXyThIvf4mg8HCz2do6525aUUR/lB+piL0ebv8dB92WIUfGSPWKZ
         37r5Xqs64CJ1xgZhYhXTAOP/Elu60L7fsqOZ+akWjCHYzXxtKwnp4Bu9cTgalkNcwotk
         Xa9kMX1WfTlwa88kR7RZGNvUnQrp5OTC7t39EBdb4+9MeSSEjVmzaDMrZHRWq3h0Ojd5
         fC36Bx7eCAGR2gFPeLTZPx78XuzjvbnAOseZoMN6LH7Ukowc/ek8I1rZrUfkXFhVi15G
         KZ5iK2/BBfR4DDJY9Z2dzUt8+7LaLeAd0u/1m7jh8isfzYPGZJ5+bKEsVSI8cWoXFvVm
         SZxg==
X-Forwarded-Encrypted: i=1; AJvYcCVHdihrxvGN/dFfP54rU75z5Pv0VOL8BxPEdGpg6mRHEb0BKC7q4CsnSV6j4GF5EjIqNF2L4hwsmsK3Ie0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdD3kdsSsnKjELYW+uDPE65X56yT3T7panYD7p0T/68rLY8PCO
	8x3x3h1BpO4xjKPCnY3ItDjwn/GvwIn/pjvWkSKTNT0vlvWtma3AM6sdV8emm9GHOJCUMpYuIPL
	zsAGs1nnQkyinRZ0KXiacW9kcCERZUrvajX6+WH5CtQ==
X-Gm-Gg: ASbGncuKVbIHuJlz5r4cj/s/gLg9aaT+qO/Nol7lzgekqkn7QG53hmE7O9KUfhbXysq
	vLSoHFEzM8NdAl5xK8H/JGKbEjc7IrpQKRJYrZHsFJO7/EMCdkap96l+EGpGe4pItdX1FkwwIWF
	3OppTNYVsr6zeSBPTMCwgPnkEuuZPHCaa4KGrvIbJfkZoB2TEFjZoIxesSCUCX1hiKQ/dynM0HS
	ouP8A==
X-Google-Smtp-Source: AGHT+IFVYv/O72cHjaH5k5VUlfobYK4W+S80N+a/c4/0HwzwQr74guF3QvQjE4eDoMLi3m7pid4RHeYV0xM1EOGkTOc=
X-Received: by 2002:a17:907:3d12:b0:ae6:eff6:165c with SMTP id
 a640c23a62f3a-af619601218mr939373066b.48.1753620930791; Sun, 27 Jul 2025
 05:55:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702183856.1727275-5-robert.marko@sartura.hr>
 <175325995961.1695705.8338983998485530536.b4-ty@kernel.org> <20250724100442.GX11056@google.com>
In-Reply-To: <20250724100442.GX11056@google.com>
From: Robert Marko <robert.marko@sartura.hr>
Date: Sun, 27 Jul 2025 14:55:19 +0200
X-Gm-Features: Ac12FXzmHtBtU7jmLL2NxVGb2Ntptau88LQnJUIPvAdvZ644oi9yAP7lpOAawqY
Message-ID: <CA+HBbNGscSseYHT36FqazfH_BXZi9zKdbPkroJGby7Vd+=ZJSA@mail.gmail.com>
Subject: Re: (subset) [PATCH v8 04/10] mfd: at91-usart: Make it selectable for ARCH_MICROCHIP
To: Lee Jones <lee@kernel.org>
Cc: linux@armlinux.org.uk, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, 
	catalin.marinas@arm.com, will@kernel.org, olivia@selenic.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	andi.shyti@kernel.org, broonie@kernel.org, gregkh@linuxfoundation.org, 
	jirislaby@kernel.org, arnd@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org, 
	o.rempel@pengutronix.de, daniel.machon@microchip.com, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 12:04=E2=80=AFPM Lee Jones <lee@kernel.org> wrote:
>
> On Wed, 23 Jul 2025, Lee Jones wrote:
>
> > On Wed, 02 Jul 2025 20:36:02 +0200, Robert Marko wrote:
> > > LAN969x uses the Atmel USART, so make it selectable for ARCH_MICROCHI=
P to
> > > avoid needing to update depends in future if other Microchip SoC-s us=
e it
> > > as well.
> > >
> > >
> >
> > Applied, thanks!
> >
> > [04/10] mfd: at91-usart: Make it selectable for ARCH_MICROCHIP
> >         commit: ef37a1e2485724f5287db1584d8aba48e8ba3f41
>
> Reverted as it caused issues in -next.
>
> https://lore.kernel.org/all/20250724115409.030d0d08@canb.auug.org.au/

Hi Lee,
This patch depends on the first 3 patches in the series, which have
not yet been merged.

Regards,
Robert
>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr

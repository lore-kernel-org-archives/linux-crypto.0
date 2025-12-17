Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67013342169
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974840; cv=none; b=TbFJbavmpGXCbNXSSKa0YBI1L+q1neSquD1tCanoBC0Okczv2Hqif9I208koFuAOo/bnEDiRA3TA9B74FFeGv7VctOKdaqr3yGBhKDhFTlxn7Vp2Gm3WF5s3V3Fa4crZWErqBqUKM+iatS4TEW/rSOLm9NT3ooKozOtsx5g4qdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974840; c=relaxed/simple;
	bh=s8GEKXnaSXfLaP2KVal8xoX7Yub2x5YeO61XyI9SmwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vDZDKTHKJKB1ue6PaCbdKWLm3sUEc9wnhtSMOk7pK5mEULUXNkbnC/xuptbSWOCrmVtf1mHqcwGNXCG1Xsbj9EVq27uKUD7OBirubo+II6/mCOyqabuPDrIKlfvxihQYwk+XEClnRdQmcO/99qXb8DO2WHFYOLeyihaNJGU3wFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=A2rYCXgU; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="A2rYCXgU"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7697e8b01aso1029269666b.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 04:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765974835; x=1766579635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8GEKXnaSXfLaP2KVal8xoX7Yub2x5YeO61XyI9SmwQ=;
        b=A2rYCXgUYr9ALJpNgKYHWr7vJr+BFYlLRilkjQiry5X9M3LQQ88mX4hFh1RagqJ6lZ
         uLtt7f7uVrILg7+B+4YELj4FONtVCFqJA7XwsLHNNYAUI6dirg68L6UOFtUVg/pflSZn
         976Z2ay8EvD2m28JR88LPxi35onEJ8E+FN4FGVILCcgQKmTMqb22K5nAnVyqmLxQDd6O
         LbFKdJDvIY/Y8kWMUSdGNCbLVuKFxZCVvOnWjidEXE282hJwaojoXOnOsdvcE8Yo8AOE
         MRm/wjI6RrNDNxlhO3goPl87r39rYRTEA/cEsAWTInxIkFYA/Fm8IQlepQjUUy1g/gnO
         RIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765974835; x=1766579635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s8GEKXnaSXfLaP2KVal8xoX7Yub2x5YeO61XyI9SmwQ=;
        b=P5mrt6WyOPFeNoTQFebt6PQlSMhpHL4HPNPqTIhv5HSeMkkpWZEvyo/0KsSrTFdTk6
         fv81wJMKZ1WRnL90fM7X0G7ci0/xAnRKRD48ApbijBunzgF7TWYIfYSWISFb9Z2kHFoX
         W9oaLH/zSzCxMN4zpeHTaB3ZIQt+v0E5rcdhFsTWBy/ASUE8ttTdJGABQQLaFhbt+JQ4
         x4XlGb/GPxT3qlxBk3RsLikgC9hT67UrAF6a+AXh9EYCmhVZpTeVWgeqphuZ/Rm5y9FT
         OZB/aB6yaw4EOzO5rLt3E0BVr50rE8UDMH/ar8jegJlQxntcibfhadygAHznXq6qIU7W
         Uq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdWZ71vT94QK8vj2XdsTRhEd5Em0nB2UouH19SEuzUd8dCqrLoXU9NZomYwbGyevGquozO7FjPwW8XvHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu1YfSUn05vKEWD3aBUqn8JWja53rdMByaSvMBP5CJhXVd5pi8
	ZuMEI+MNFjLMSQXKtgC9f/k2Hn7y/KkRFHks7WF4p02OGtZssDLN/9hwY2T203izGOEaH64PUvh
	s/emvduKALBbd2J3LY3BL3CmL1FSAtBPH+whCOKjTRQ==
X-Gm-Gg: AY/fxX4sxHBxJpJRNBydP2s+hb+SPg3Lmzg6xEpK6uiMZltskhM4jF9TGY+1uZL6Y/h
	KOeqkBjn9ACOt5bIn6IvxIF0OqHfLfFkxUudJOyLym5dJAs/0lVA3MA/xTV7H0g1GZwi0yYx4p3
	LHLAxWeWsPtqe1BtDK6IIpT7j/L0/Y+MY7v4vQIB0asW1DAg+kQa5J8tYBPlouTezDvGYGbEnom
	ujItqUL4uejQ2qEo0omTYYB5j+qTU5bQoZrJ/Xt0czCk3VQyDkw7rh2WMQXd/quEjFWgNCXypz+
	CPBLYEMb+95peGirLulrfZ5aRlOHSJKdaVVqxwp8gVhMprYgHOMj
X-Google-Smtp-Source: AGHT+IE7Hjde/+kkViqYv1A0LhGo3fNDzXkWHEO+dWmCgW+32Gp4be+4LUgDpSNymwFzE86qvkEGL0RYLcWs3u76qoo=
X-Received: by 2002:a17:907:3d43:b0:b7c:e320:5250 with SMTP id
 a640c23a62f3a-b7d238ebd71mr1711209066b.7.1765974834580; Wed, 17 Dec 2025
 04:33:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
 <20251215163820.1584926-4-robert.marko@sartura.hr> <202512161628415e9896d1@mail.local>
 <CA+HBbNFG+xNokn5VY5G6Cgh41NZ=KteRi0D9c0B15xb77mzv8w@mail.gmail.com>
 <202512161726449fe42d71@mail.local> <20251216-underarm-trapped-626f16d856f5@spud>
 <2025121622404642e6f789@mail.local>
In-Reply-To: <2025121622404642e6f789@mail.local>
From: Robert Marko <robert.marko@sartura.hr>
Date: Wed, 17 Dec 2025 13:33:42 +0100
X-Gm-Features: AQt7F2rRCO2ytZ0VdvYzTGe4b0Ox8AKF-v29YqVKrXuogSLDfcjlg9rn0S9yxlg
Message-ID: <CA+HBbNGPWcwzCSGbMCU-n8Y+g6SjBSKcS7p6Mmrn3gFCWCSCeA@mail.gmail.com>
Subject: Re: [PATCH v2 04/19] dt-bindings: arm: move AT91 to generic Microchip binding
To: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Conor Dooley <conor@kernel.org>, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, nicolas.ferre@microchip.com, claudiu.beznea@tuxon.dev, 
	Steen.Hegelund@microchip.com, daniel.machon@microchip.com, 
	UNGLinuxDriver@microchip.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, vkoul@kernel.org, linux@roeck-us.net, 
	andi.shyti@kernel.org, lee@kernel.org, andrew+netdev@lunn.ch, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, linusw@kernel.org, 
	olivia@selenic.com, radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com, 
	gregkh@linuxfoundation.org, jirislaby@kernel.org, mturquette@baylibre.com, 
	sboyd@kernel.org, richardcochran@gmail.com, wsa+renesas@sang-engineering.com, 
	romain.sioen@microchip.com, Ryan.Wanner@microchip.com, 
	lars.povlsen@microchip.com, tudor.ambarus@linaro.org, 
	kavyasree.kotagiri@microchip.com, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org, 
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-clk@vger.kernel.org, mwalle@kernel.org, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 11:40=E2=80=AFPM Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> On 16/12/2025 19:21:27+0000, Conor Dooley wrote:
> > On Tue, Dec 16, 2025 at 06:26:44PM +0100, Alexandre Belloni wrote:
> > > On 16/12/2025 17:56:20+0100, Robert Marko wrote:
> > > > On Tue, Dec 16, 2025 at 5:29=E2=80=AFPM Alexandre Belloni
> > > > <alexandre.belloni@bootlin.com> wrote:
> > > > >
> > > > > On 15/12/2025 17:35:21+0100, Robert Marko wrote:
> > > > > > Create a new binding file named microchip.yaml, to which all Mi=
crochip
> > > > > > based devices will be moved to.
> > > > > >
> > > > > > Start by moving AT91, next will be SparX-5.
> > > > >
> > > > > Both lines of SoCs are designed by different business units and a=
re
> > > > > wildly different and while both business units are currently owne=
d by
> > > > > the same company, there are no guarantees this will stay this way=
 so I
> > > > > would simply avoid merging both.
> > > >
> > > > Hi Alexandre,
> > > >
> > > > The merge was requested by Conor instead of adding a new binding fo=
r LAN969x [1]
> > > >
> > > > [1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/202=
51203122313.1287950-2-robert.marko@sartura.hr/
> > > >
> > >
> > > I would still keep them separate, SparX-5 is closer to what is
> > > devicetree/bindings/mips/mscc.txt than to any atmel descended SoCs.
> >
> > If you don't want the sparx-5 stuff in with the atmel bits, that's fine=
,
> > but I stand over my comments about this lan969x stuff not getting a fil=
e
> > of its own.
> > Probably that means putting it in the atmel file, alongside the lan966x
> > boards that are in there at the moment.
>
> I'm fine with this.

Works for me, will switch to it in v3.

Regards,
Robert

>
> --
> Alexandre Belloni, co-owner and COO, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr

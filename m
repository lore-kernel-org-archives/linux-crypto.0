Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F56241CB6
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289510; cv=none; b=RkOnTAf9RhWGiQMukF8TcEwSzjFQl8ZEI0VZnvL1fFpqX6O/ir9zJd2bJtRjU4bBq1EaiArm6FvDWg8lt0D/supGMccipLEnG+ONGHGRGRiXCGdsZPCk/pA0lijx2jV8tnhnHfmggbB76fKb6rhKMMhvAU4Z4bHQsQUTWBE8+o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289510; c=relaxed/simple;
	bh=lTodMpiU5uuVCAXQ/xJnIx+Vmi4vwQ6HLDXj4qTx9vQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RdIqbMSZJpOHUS+MEuOjM5mLBmrfNwNU77nJwBw7XX48I9ylDfpkU7mvzUzNmdaHCBlzaKtbPF1flafzwFWo88KEXC9hyLXAvvcKQK+tASqkt67Ektk0EzBZBKpHwG3lejU/XEUcbQsgpnf0PjIL9eMfxIYo5NQJOMRb+lKS5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=pRx/iQt2; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="pRx/iQt2"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ae0df6f5758so370319366b.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 06:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751289505; x=1751894305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9zeJ4WnqwFH5BMqvuX+OeeKVaWRigfICDw1jtDlC48=;
        b=pRx/iQt2r9Pvyaa2L1OuB1hChLu7PshuT+14UlIp68vk5Y49Ad/UPWyyphWic5nit5
         WLlnh9uTrgCLh6e3KLYHKpAvjIKzleg6DlI0nXbxCHiXjgbzs+8dDevv9wSnpfy+IwAA
         //FF7oQK4EH89QibGMWK/3onxFx9XswMdCSp2MBoG4Nou3HrBgqvtPw5ZPQMWyOSZjs2
         M4836LLojD8qCTqeEDXpPAD3gjgiNQqhbUkpxwWfBhlMS9idNOZOfdGlvJulxTdrOnE6
         alnsshOQzru5++3lEOPFYiNd9rYd+evD3jXbSls//rZn1WttZnBlEObW2KbWYFVFttfb
         rthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751289505; x=1751894305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9zeJ4WnqwFH5BMqvuX+OeeKVaWRigfICDw1jtDlC48=;
        b=UQbZHjJfu23uRi6koBxl4UxvDwPWsNBeFcO52ZSdbkP0NxcRaTpll65I9uG8jyB3ye
         zC4ELcbuhYGzr4Wct4rtqdjRzkYUoiiz7+L55lADlbqCKLrzoQQN5heDhVkHxzc81xRs
         JnQyczUBvOU8cZwPioucYO6Bun5ckrZ32JPcnJxua6xbnPdRs1rbdIVTGMRUVM3Ygbkp
         lYr74P7PVyAm2lEs4oDASSm2FU4IK6Sy5EHdgZbmylU8nRGKAkG9UX9Jxjp3fDcjElwA
         1UlEPZVR8Djg6n5qt7wuV1CVxppz2ifE7BAgnlypPNybpzznQRnzEa1OJ3LaAJEer5FO
         Fsiw==
X-Forwarded-Encrypted: i=1; AJvYcCXkMaycWzfSlnKPI+xQ8ytrfhLyzJORQxUVvgrSuXIqPCPGICepCmRZkyCs+C5Mz8RBTz0NmWlte7X4ccs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmeRPA1WkIwTNxqCXkDEjaJgG/CzfA0E9FIuMiaT3qzmM5HEL8
	t0yojnwb01zfwzXgpIyfPo4OQtRK/CNrhxRJviO0vsMD+CLHqSQFoIkmh4/MuQY3jwWVqEcf/zV
	cRRHozLeCWj9224butBUbt0TCIX+T3TokJgwYJcwHjA==
X-Gm-Gg: ASbGncth92TdWHjEw+16e2nTU/jkQ+cAX+BKAYGwL9iQUNikW1t3b8mTXXCQtbjxUsN
	dWKODbEg3ElkAqh1KF7gy3SwJwXB7T597C/h+lZ/4dI5UtdmbbU6FfXcU3Cy2QfIFjWLOCV9Mpd
	7SmbPhYr1OauRj+QhEbIWEV0Frkx7/uK9o1cdWTyifxw==
X-Google-Smtp-Source: AGHT+IEawzH6slgwqh8lMlGexpCFs5UFNCtQJR4Lc0uD06pbIw6jclmGMPNliNKtJ0yxh9f1sHZF7joTilZ8ACzkvCc=
X-Received: by 2002:a17:907:75c8:b0:ade:36e4:ceba with SMTP id
 a640c23a62f3a-ae35018e67cmr951593466b.52.1751289505046; Mon, 30 Jun 2025
 06:18:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613114148.1943267-1-robert.marko@sartura.hr>
 <20250613114148.1943267-2-robert.marko@sartura.hr> <20250616102103.faoc5tqp22we67zl@DEN-DL-M70577>
In-Reply-To: <20250616102103.faoc5tqp22we67zl@DEN-DL-M70577>
From: Robert Marko <robert.marko@sartura.hr>
Date: Mon, 30 Jun 2025 15:18:14 +0200
X-Gm-Features: Ac12FXweyWpZVaFd_k9KiyWdnFDxPWGB4lbqdU7LoxWxkr8ipI5ijfQoLUWnGLg
Message-ID: <CA+HBbNGWSA8QNzcN1HRosSd7qibM8G0u05cxiia6grGJJ0meoQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] arm64: lan969x: Add support for Microchip LAN969x SoC
To: Daniel Machon <daniel.machon@microchip.com>
Cc: catalin.marinas@arm.com, will@kernel.org, olivia@selenic.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	andi.shyti@kernel.org, broonie@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, kernel@pengutronix.de, 
	ore@pengutronix.de, luka.perkov@sartura.hr, arnd@arndb.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 12:21=E2=80=AFPM Daniel Machon
<daniel.machon@microchip.com> wrote:
>
> > This adds support for the Microchip LAN969x ARMv8-based SoC switch fami=
ly.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Acked-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  arch/arm64/Kconfig.platforms | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platform=
s
> > index a541bb029aa4..834910f11864 100644
> > --- a/arch/arm64/Kconfig.platforms
> > +++ b/arch/arm64/Kconfig.platforms
> > @@ -133,6 +133,20 @@ config ARCH_SPARX5
> >           security through TCAM-based frame processing using versatile
> >           content aware processor (VCAP).
> >
> > +config ARCH_LAN969X
> > +       bool "Microchip LAN969X SoC family"
> > +       select PINCTRL
> > +       select DW_APB_TIMER_OF
>
> The lan969x SoC uses the clk-lan966x driver. Would it not make sense to s=
elect
> it here?

HI Daniel,
To me it made more sense to select individual drivers directly in the
config, cause we need pinctrl
etc as well and I dont think it scales selecting it directly via ARCH.

Regards,
Robert
>
>   +       select COMMON_CLK_LAN966X
>
> > +       help
> > +         This enables support for the Microchip LAN969X ARMv8-based
> > +         SoC family of TSN-capable gigabit switches.
> > +
> > +         The LAN969X Ethernet switch family provides a rich set of
> > +         switching features such as advanced TCAM-based VLAN and QoS
> > +         processing enabling delivery of differentiated services, and
> > +         security through TCAM-based frame processing using versatile
> > +         content aware processor (VCAP).
> > +
> >  config ARCH_K3
> >         bool "Texas Instruments Inc. K3 multicore SoC architecture"
> >         select PM_GENERIC_DOMAINS if PM
> > --
> > 2.49.0
> >
>
> /Daniel



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr

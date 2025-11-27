Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77889320CD1
	for <linux-crypto@vger.kernel.org>; Thu, 27 Nov 2025 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764232642; cv=none; b=YYlBdHWFn79sl6xcAfHaaiJvxc8SZNhTwtsRuHx/vYhcaL8bEwMmu+KySQGnQJE+kixpdN0zz57nwHYm7IpeJb5I4TFM9sgsey/nRIi6yq0W7cbGBs0amT/uxhCnKq4BMSkyJc+alZXGv6uDckTwDvUk3e1Q12K2+NK/n7EKMM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764232642; c=relaxed/simple;
	bh=/k8EWPhfGokPGMRiqiH2p4Mjc5NgvkT0g+q1DuCM1Vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KqbNXhs3MFYrgFGMP6tU+zO+hKab6DDaz5GnoxI3EmCkLy4Yy/+YmzDdWaJ55+BcIh9seGnyc+rDPSJjMPyYHbMday6EiagnAyVbY+wR2duahAyQliRfjWiO4T2qCgdRkL7wGu02fRhLUQvMpUinSoXUDKTOFI+mh+MvRYG2NQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-93725308c15so411634241.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Nov 2025 00:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764232638; x=1764837438;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bIb8SaPvztgKHHZzH8CWgVAXI7TZRDphVAmy2KGknFI=;
        b=CHg5h1mhPec6KPG25D3FYUb0ONt/Po0pdDBHVbuDiFVRFwtMqomSu33lUTZgJpPL8N
         mSjxiUqTtGgsvamQSP6V8YGoGo6/YdA0Nt4jERFQQA/irZEtF+hjna1y6Xx4jes+OHum
         cVIPHbQrBsPX0thEU+55gtfUg2O+pNXhf5vEz4XjU7bzc8vlDRs80IS1H2sOe1yDHDRV
         UW6wIwLeKloiie0JMoln6DqSNvQXHFN5bl3w0bmKdL9Eir545TGmImoDA9NzTEMYZDX5
         8a4ycTjF/BBi4YzWQYexE/d2qgjaFZRV4zIUef2gwudhNnlxLRZpznCHYA4MRL8UVmDg
         EzPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsOi8x0JrNZ5Bcl552OTqysry3s2Mqe3ZDrhnB4vsxnS7S1H5booKrKCq7JNRkbyRqNM3+69FdVwyAcQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj7naVyaLe8V90UpdmJURbol9EnhRRwTt7wnTtQYvYKyZTysEq
	c+xTVbADhnwiiV+oF2rF9xLlQzIu/IIoV6RuufplDVSOFhNCmvw8xFLRyS1fDLIh
X-Gm-Gg: ASbGnctmgks/d/ah1JQXuEct9UK9zLS/4AkG/gb9zQ0uJqDrcH7A4pcIOMnAUaZybcN
	SBgdefWvDniiWfAMdQnjzXLckTDag9/BRPkdTa1BQWYv5zz8tpgGiVjfcmJEvYbkcKq6D3At2Q4
	BZ0Iappy7efpYwn4NEh8U3YQJ/RsC71qAQeXEYanbBOzOS2cfP0pQoPSVDs24KbrFWgIw31DNsL
	QfMp6pzNESrtEDPtH/1svJmcyt3Jj5Zj6Zf8H+BJX5+kbJY35UrvYlAD/HvjnvaWGFmrmPX4muu
	bfGyUXf5Tj+F6qBBeOKRRzxWtoxGqeUJqY1sXfCJH+t4oNLdUn/y6ZsPYPNAfoL7VGAJWRGW093
	OMdFbVsNoWwJKH55xHMB0UvmW8IUCGYs32l16ol8+lOFlGzSUjA4nib56WM+ZbsJ1hPU9EvJ7fG
	aPrkbsquBarRc3F1L4SRHakf8ddlee6sTeIQ2bVfcdDXERFGPYB+S8k2P2TlE=
X-Google-Smtp-Source: AGHT+IHmgG++/LcDPFul/Hl9fteNya+6p+T0BQj8XmHU/b1eGaDd/vf9zcYXSOLmuz5CzmctuY6y0g==
X-Received: by 2002:a05:6102:3910:b0:5dd:c484:957a with SMTP id ada2fe7eead31-5e1c41baeacmr10495027137.21.1764232638175;
        Thu, 27 Nov 2025 00:37:18 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-93cd75f2eb4sm328529241.10.2025.11.27.00.37.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 00:37:16 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93917ebde8aso1062019241.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Nov 2025 00:37:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXwIVkBXWEycZuYRfjXK/XezNW99dD7281PBukP1kMJTN6Fqu3yQcF4j4PDglwUL+2w+LcUu/6348l18ys=@vger.kernel.org
X-Received: by 2002:a05:6102:1623:b0:5db:e32d:a3ff with SMTP id
 ada2fe7eead31-5e1c41a822amr12513289137.19.1764232635987; Thu, 27 Nov 2025
 00:37:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-1-5309548c9555@yoseli.org> <aSdjT9BLzGF3_5PB@akranes.kaiser.cx>
In-Reply-To: <aSdjT9BLzGF3_5PB@akranes.kaiser.cx>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 27 Nov 2025 09:37:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUGmw+Pa43oqcGzt0x7ED2FGw0=U7XddvdaUZ3GFmsxsQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkVv9s4nivghVE7rDnIpugWqg40dFmqyxV-7HzaTJ-oT-X1ymFUQxkCVvQ
Message-ID: <CAMuHMdUGmw+Pa43oqcGzt0x7ED2FGw0=U7XddvdaUZ3GFmsxsQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] hwrng: imx-rngc: Use optional clock
To: Martin Kaiser <martin@kaiser.cx>
Cc: Jean-Michel Hautbois via B4 Relay <devnull+jeanmichel.hautbois.yoseli.org@kernel.org>, 
	Greg Ungerer <gerg@linux-m68k.org>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>, Frank Li <Frank.Li@nxp.com>
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

On Wed, 26 Nov 2025 at 21:30, Martin Kaiser <martin@kaiser.cx> wrote:
> Thus wrote Jean-Michel Hautbois via B4 Relay (devnull+jeanmichel.hautbois.yoseli.org@kernel.org):
>
> > From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>
> > Change devm_clk_get() to devm_clk_get_optional() to support platforms
> > where the RNG clock is always enabled and not exposed via the clock
> > framework (such as ColdFire MCF54418).
>
> > Reviewed-by: Frank Li <Frank.Li@nxp.com>
> > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > ---
> >  drivers/char/hw_random/imx-rngc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> > diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> > index 241664a9b5d9..d6a847e48339 100644
> > --- a/drivers/char/hw_random/imx-rngc.c
> > +++ b/drivers/char/hw_random/imx-rngc.c
> > @@ -259,7 +259,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
> >       if (IS_ERR(rngc->base))
> >               return PTR_ERR(rngc->base);
>
> > -     rngc->clk = devm_clk_get(&pdev->dev, NULL);
> > +     rngc->clk = devm_clk_get_optional(&pdev->dev, NULL);
> >       if (IS_ERR(rngc->clk))
> >               return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk), "Cannot get rng_clk\n");
>
> The clock is not optional on a standard imx25 system. If it's missing in the
> device tree, the rngb will not work and we should not load the driver.

As the clocks property is marked required in
Documentation/devicetree/bindings/rng/imx-rng.yaml, "make dtbs_check"
should flag a missing clock.

> Should we call devm_clk_get or devm_clk_get_optional, depending on the
> detected device?

That can quickly lead to complex code.  Nowadays it is fine to rely on
"make dtbs_check" for some part of the validation.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

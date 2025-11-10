Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252BE2F7AA2
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762767114; cv=none; b=KUxeHTiFe5xxKve1hFhKkywAA8Fc58Ec4/Dsf7tP2JJZjTV3NSPLWai1W5XXTWJhFatFwhhWci2/jQzkB0tBlL99sr2vWrlvzFVeRl9kRpmVnYcjsN5bsIBzyNG9fm7bfMBQp+TvGxHUGxGGEUq31EW+bTJ7wrkZQq+Gru+ppJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762767114; c=relaxed/simple;
	bh=/fJzjpPCho25zV5kgp+Mt+JXbM7T0RiVyjwGWi7iCBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DoFigdI6jWTFumTuMEUMTzTxLJmf+LI6Ew0wHaGXHghrTDYcYcE3FZn+eLt/m+9R7aB1482xu8XNqi/WClv4nLUCFVsOsveMeiN5i3wpyYHYqeCy9YO7DjgeZ4+UjZ0C7d7EcJTeYrWtaaMhETJnopwg7kKqymAODiFYutcRlpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5dbd2b7a7e3so2336527137.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 01:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762767112; x=1763371912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRtPdzI1Yw78zykFlB0XCziKqeVOXzigJtW+jsiVzcI=;
        b=rSlf08PhJFbfRBdO5Xu4w77ijHr5ZyVqiqZ3P3p+F63Xfg5o+GuuB9N5QuVIjqIJXT
         WuXE4x0SUEycgQj4oTGu5PknRL6J3Szx8zF1SEqNZVkNtG+nV679PM2hnC+lTpGOvJ3q
         kpWKEO3QCuaIAI0+y61hpUw1fuCg/rL5+cMO1zDRKLzaFgTfOeqhfIRJneGgH1rUHs7V
         o6aO64/80rO6hD5ksSwyK95Zwvh6FF6CjBy6mmUhBIukbvHza9iTChpKUDnPypq/J+Yu
         XCXXAWHZgWGwI3BpIAD91OFgQ1oVqA74Hm4tSPTaGL6s8S0uRqdueHVhpfmNziIMsnhW
         +Dsg==
X-Forwarded-Encrypted: i=1; AJvYcCVJRDUHvK3Pkp2EDhkPUXMvSVs8H4dCCltX4Sap/K/m1hDTY0+QPqoSechCgm6p3hOWd32tLC3poBnpUIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKLP+5gBbXNfzzmzZbeuyX0FSVBor4vgw+WTemsJiPVvtOmvyO
	5B95aojjKl8s5r140BYmUP60mjOBmjoYjOzJNh2hyLx0O2uv29ViWctpgvanVmgR
X-Gm-Gg: ASbGncuYtb0y2ATA+tmrOIfMPyXQAUHzQBhuGUIUsKy6Ufepsv3p5pnMzbBqSeN4T3e
	8zUXRV/OVudW+Bv85xYIy3/UvfdMWLYNbH35aDFdCyhZqHZMvM2A4c5qa4/2w01GWggxN+Zm2Vo
	GjjzN39dZWKLtIT9dfkINgRCnXglXXpuRU4p/8/NBMBDk4TuhsT/a9bnZlyuMKuZ3p1SL+qzXW/
	BmbBKI572nhemYUmFBC9kvr+Qxak+X6YP+viqIHKcQr5w69yuJ+urgcAIK1WyowK0MwueJAtW3F
	vcX5Wd6rWzT9JegyB6U7pLj4sdVaiDfkRD5R1R4WGncPM9k4tSrei2Kt16CEYKwK04EExzNs+XL
	SU9kQbkNJv/DO94nPaHC9KloUHpBf2MkV735dFn6rEXDN5pcEBj9d5fe6DIHASQJ4FQpd86feY5
	iIo6KBP1FUpnG5JNPGgCA0OP/WzsCnXCnJvHtdRqX1FQ==
X-Google-Smtp-Source: AGHT+IFqHRiZCnc4ZBhIR/7XtCIfLNkGXDFeHxcH2hZaWCdCCMl/AaKndC1rod9zimD8D2AI2+ew6Q==
X-Received: by 2002:a05:6102:c04:b0:520:dbc0:6ac4 with SMTP id ada2fe7eead31-5ddc46497a0mr2779300137.2.1762767111962;
        Mon, 10 Nov 2025 01:31:51 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55995862fe0sm6848037e0c.21.2025.11.10.01.31.50
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 01:31:50 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93728bac144so896057241.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 01:31:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXuIatCbIo6ue0U6oCowCj4wgC65ktLRAyCiyxUpNj16di7cyAq94alzVtLjs3ScPLXGDQAGWj0d7UQjQE=@vger.kernel.org
X-Received: by 2002:a05:6102:c04:b0:520:dbc0:6ac4 with SMTP id
 ada2fe7eead31-5ddc46497a0mr2779273137.2.1762767109934; Mon, 10 Nov 2025
 01:31:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
 <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
 <CAMuHMdWL76hY-Pv30ooSM1J6XkVWbRXSLTDCjfpPOvhFN4tKyA@mail.gmail.com> <12779401.O9o76ZdvQC@jeanmichel-ms7b89>
In-Reply-To: <12779401.O9o76ZdvQC@jeanmichel-ms7b89>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 10 Nov 2025 10:31:37 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW26uKBUnYB5c3XAzKPKFVGNoOOwra_u_NOjPCV20Y-AA@mail.gmail.com>
X-Gm-Features: AWmQ_blSVM0mC21k2j7-_pQqo1T8ZhoFgD5EPrlyILfYI73Lumvke_itdhGi4eY
Message-ID: <CAMuHMdW26uKBUnYB5c3XAzKPKFVGNoOOwra_u_NOjPCV20Y-AA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jean-Michel,

On Mon, 10 Nov 2025 at 09:34, Jean-Michel Hautbois
<jeanmichel.hautbois@yoseli.org> wrote:
> Le lundi 10 novembre 2025, 09:15:11 heure normale d=E2=80=99Europe centra=
le Geert
> Uytterhoeven a =C3=A9crit :
> > On Fri, 7 Nov 2025 at 11:29, Jean-Michel Hautbois
> > <jeanmichel.hautbois@yoseli.org> wrote:
> > > Add platform device support for the MCF54418 RNGB hardware with clock
> > > enabled at platform initialization.
> > >
> > > The imx-rngc driver now uses devm_clk_get_optional() to support both
> > > Coldfire (always-on clock) and i.MX platforms (managed clock).
> > >
> > > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/char/hw_random/Kconfig
> > > +++ b/drivers/char/hw_random/Kconfig
> > > @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
> > >
> > >  config HW_RANDOM_IMX_RNGC
> > >
> > >         tristate "Freescale i.MX RNGC Random Number Generator"
> > >         depends on HAS_IOMEM
> > >
> > > -       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6=
UL ||
> > > COMPILE_TEST +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SL=
L ||
> > > SOC_IMX6UL || M5441x || COMPILE_TEST
> > Is the same RNG present in other Coldfire SoCs?
>
> According to the RM, it is only present in MCF54416 and MCF54418.

I guess that is sufficient to make it depend on COLDFIRE?

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

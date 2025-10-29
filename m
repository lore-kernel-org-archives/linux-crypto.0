Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519E1DF994
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748509; cv=none; b=Vo84qPiBs0/LemKEqCEhuGv9yNRzMdpEldRPqNkSm6en9uWECUiC1+zZf5zfatMbYiwtScK2sMDmEL7f9SARLvvMU3ALxYz1o9BpOYVdw+ZfjVLLa5ex2tphNJsjQUivP5YA/OEnqpxzGcBlonKBGlthj0fwwMYt5QZ3zdXWj00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748509; c=relaxed/simple;
	bh=QXFJ9Wye89l5k56IzhXHnCZ5vP4dVOGIaGxaTnibrdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WyUIF75pfbrnS1qhypCli0esTg7+Ns6KVyvtTDHHbfCdsbaO6SbrUWhAv0j/BvJTMJKJwT+fBO0u60Q5xlNn5mU1OoXOFoQnAcDN9GTHZJWbxdHeZwUFlGlAEQGDufPKYNr8NBzoCWhsck23CH8kAEWsOvhs9GgPDvBSGwLJlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-932e88546a8so720969241.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748506; x=1762353306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohi/8MFIs+pUNYTuSKDH5KUVpFMJO5wn0YyhdMa7QIc=;
        b=tCstj4btcW/AlbThE6RpAExWkwEUItJiFod12HyS4oRvugLoAetm+RfsSrfZYeJDDD
         3Uzk0Ddi1YDAX/raM+D1jKXTRYkFf1gNZP6a+CnWEOAH72Odklwx5WK+/0rNGWCasZVZ
         XxlH0Ywrq2/2+P77sMK8H+GQ/xwZJBqPbmaNEYSXIn5RqD1s50LtTMXWUo/6Ud7VQwsx
         W7C3FCUogdtIzYjfRpXKFDBkXiWERpsI+RF9zlbDN6kC5sYT1KT3VWQf9QjeKrPEZNAC
         4uWIs76fWfME2BwhtSK5VF7w+Xmszd2mXSVKGULFcM+gNvMrxKdZdFU1cqzojeqZCvjs
         NJcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUISRk+7ALwZHPE/3JFoDHHFgx6UbWEMoaFn8XCIPqkDdh/Rfq91azXOCie5Fh5BIPN1+MO1RAf74CP6zE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoDbu/4feGB4BZcI1KGUbAzSnoVegar46WZq+c4KSitMBqCYXt
	mJIW/+yjsHWSQ/J3aGXpSvA7/eJNbwMZN18c1vy0bA4IZBUTa1DZfa5Xprs8roaE
X-Gm-Gg: ASbGncvtMeXX/FvtyRq5SLLD68dFlINZblXbLZLhxcri1j2GSV5XWd4DgTqT2WN3LNK
	QcEJzFhurl0rNcSNwFtjTV2rbIEARcKcb7NkpcU1xS6HLBG0kpquSk2P5Sq+CNC82g9aNRbYcxy
	ZFMbV21qaH/c83XdlVlvt2tonKfgoxBVFamu62FO7Xiu1xT1dfbT/4fk2avAGG5B6S5GuZDXVpl
	LJp2FFFLCogcAqvNgBMyindUzJjYYta1441AyirekVRJ2Q+xniil17M5817QD/8sP/bsQHNEt6l
	X/x54KX1xNMBWh7ydw4X1qZbiAW1xV4DRYJqSa7gtpnG9h0mielFi+vzrZbbrTMuGkb5ofhhr8H
	usez1qBZNRKz1EXISRFay5UwLcTfy3oCir7LF5VXjh3rwmZPSGsay10V6evFz3DpuHVgVECPsoH
	YhamPsPokNkYahZ9WxPBUGM66nnbexGuTJHufRPOoZ6sSs77RJarfR
X-Google-Smtp-Source: AGHT+IHtmAAjvElMpX46WiMeR3GLAh4wCKBjZp1LDfDYSkTmfTp10NS4NYi/3Ja3DzoQ5YpratoAxQ==
X-Received: by 2002:a05:6102:3eca:b0:51c:4443:16c7 with SMTP id ada2fe7eead31-5db8fbfc887mr1342437137.6.1761748505945;
        Wed, 29 Oct 2025 07:35:05 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5db4e521e0fsm5059668137.6.2025.10.29.07.35.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:35:04 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-8eafd5a7a23so729849241.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:35:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVM9/e8+fgex+IGuCecSU2Z8Lq9EKDELZvFbazeYQF/9xb9dIFEJ2iClOqdeFXPrpBY+tKJxK95UAPHikw=@vger.kernel.org
X-Received: by 2002:a05:6102:2acd:b0:5db:9b88:1fec with SMTP id
 ada2fe7eead31-5db9b88219emr535412137.9.1761748503547; Wed, 29 Oct 2025
 07:35:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <ac3e718c5de6a23375055dd3c2e4ed6daf7542d5.1761588465.git.geert+renesas@glider.be>
 <CACRpkdYMv+R-NJ5R4+UyhK1+DJia0z72kZgt45+0eubXMuGpEw@mail.gmail.com>
In-Reply-To: <CACRpkdYMv+R-NJ5R4+UyhK1+DJia0z72kZgt45+0eubXMuGpEw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 29 Oct 2025 15:34:52 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUvLH-8yNRoqBdTB+mcmOUedwVGpJ_HGdq8sqgLNB4dvw@mail.gmail.com>
X-Gm-Features: AWmQ_blZ8dUVr2aBwtWAAkAOaE93AtUSPNFDpslgvmXepFfW4tMWIOUWnRJkksY
Message-ID: <CAMuHMdUvLH-8yNRoqBdTB+mcmOUedwVGpJ_HGdq8sqgLNB4dvw@mail.gmail.com>
Subject: Re: [PATCH v5 18/23] pinctrl: ma35: Convert to common
 field_{get,prep}() helpers
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
	Shan-Chun Hung <schung@nuvoton.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@ieee.org>, 
	David Laight <david.laight.linux@gmail.com>, Vincent Mailhol <mailhol.vincent@wanadoo.fr>, 
	Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, 
	Michael Hennerich <Michael.Hennerich@analog.com>, Kim Seer Paller <kimseer.paller@analog.com>, 
	David Lechner <dlechner@baylibre.com>, =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, 
	Andy Shevchenko <andy@kernel.org>, Richard Genoud <richard.genoud@bootlin.com>, 
	Cosmin Tanislav <demonsingur@gmail.com>, Biju Das <biju.das.jz@bp.renesas.com>, 
	Jianping Shen <Jianping.Shen@de.bosch.com>, linux-clk@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, qat-linux@intel.com, 
	linux-gpio@vger.kernel.org, linux-aspeed@lists.ozlabs.org, 
	linux-iio@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 29 Oct 2025 at 15:21, Linus Walleij <linus.walleij@linaro.org> wrot=
e:
> On Mon, Oct 27, 2025 at 7:44=E2=80=AFPM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>
> > Drop the driver-specific field_get() and field_prep() macros, in favor
> > of the globally available variants from <linux/bitfield.h>.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > v5:
> >   - Extracted from "bitfield: Add non-constant field_{prep,get}()
> >     helpers".
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!

> I guess this needs to go with the rest of the patches?

There is no hard requirement for that, but if 07/23 goes in, why not
include this one, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

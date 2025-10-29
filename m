Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054E34F47A
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748687; cv=none; b=QdGT/pVoLXueCtnJvONbAtwW0zstbkHBdN6ir6oTaz/F9j50A4YccsA48eGCQKaNNlYq0CHC21YS7o0Lb/tHzwSSXSKuqg73WXxer8dMLsI/biFiXGWpAaQvZ+FK8AiNp4h6ic93fMcoQlR3JgF2vQWk7PHXYXYsS/U78zRr6qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748687; c=relaxed/simple;
	bh=RiCdWEkCDNsJiKATmU0RbHd3Kb5B/0yb//UgjVnVdPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uNP0ubq0LrHLZ5h8xRa2DrSDiO8GnN9/sYYqCjpsLNLulA4+L8wcL/Q4rh7fD7tKXp/9y6cvMkRHViE5GALQTdgr1L4iJJIggB9hw1IhWGAEuIJKubY2iDZvB9dtuluzE6qAlQB4fB4t6IyRRTeLRG1lI0Cz7KrFcyK9jJZ4vSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87d8fa51993so85456396d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748685; x=1762353485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmTxX9Lp/E6iQMSfd9sSFodFiE1yd68ZDUJdx86zE5s=;
        b=cgC8Dgr2MIA0uEFSUHOz/U+EjNc9spl4/8B71CjcMoaeUg//hvHGDXDdmX1WIckH7Q
         BkVrCrT4NS/xF0dW+ZGsla/AU30CErR4oyFX/6t27SwLZoQSIX3xeDt/BflyrbOcXOHr
         is3aeKFqEnt2pF41bpDLVDHGENXiyxU92t0vFb1+uZoLpMbD3nsILIAXrsKcAYP4tmaT
         oBmNMUAIVVEnJ08gMuNkFMVlf+giyYLWFNOi4Muec2MXxs33d68AONIJVxsU74qx0Fsu
         L+vr+myExZazFko/MUS7oLp6AS50voE9Mxo1cjmJK+W9PsvuPRkKeB2Gyefr7xVchTfo
         hKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM1EBqr5IRATGEfntWb2r95WXYLjtzPFJAZbCxpDhNoYSb0cR5Roe0yMI+BlvgmH8nXRZbSijRB81Ntf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXyeKpT85xtW4XuC1nfc9G9R4rOZYrvktyqk62sNVwNpwnLJJ7
	NSD/JiN/VujOQmDUannVVH/9Qt1ZuyZm41fCNao7yzzGC/8CeCIEErHyMNX+KIsY
X-Gm-Gg: ASbGnctbYeKV66gQkS72F8yXHJhj2KH02F+3ZZXHCguLqurP2QEG+zBj5hqv9BqWYgJ
	M360YqNiiBilsBRGdSESiYi8ueH+d/MiR9d2CVTsAHn2ebyL+pv/ydiAeoowfvz9Yf8vVIEu/CE
	wQBSOQ2xXuSL+Xu/w+06BMRev+HX5M0gOJ/TuAoFmMs+0It8DHJ0w+u4RDm8zhONcu1gIHC//02
	+gM3tSxTm4e/PAYCbt20cOb/FVQewSsCrjFumvKS00HgE7eoYwqAsMOHAv1KX7W5swklOKBQ2Ia
	JinUDQ6LqIvwj2ygFeE1P8AgPhs2Gm8MwYAAIvJaLVnd/1zepUmaJbt7hHU7ttcSWHTC7cZN68l
	W+DPiGxuTFpXnPhqkh90awMyC+gG/ZgaZ5FH2HFeoRGCZN5yp1MOPNvgI1qQxICfo7o1tPyBg9H
	ZAv9yPOnTsjZRSfkQImp4gq/dTl+df2yE2xyDsAQgrkymrVHa04QeU0wUC
X-Google-Smtp-Source: AGHT+IF98NDfGUYE6oIp8i8m2kuem0BpuNr9K84BWtPA5jHnAdc0IebDtSj+4h0dAmgEQcEJCpYUPw==
X-Received: by 2002:a05:6214:5004:b0:87c:27d9:14ee with SMTP id 6a1803df08f44-88009bd6ee5mr30671246d6.35.1761748684389;
        Wed, 29 Oct 2025 07:38:04 -0700 (PDT)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com. [209.85.160.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fd3c48f20sm86600916d6.32.2025.10.29.07.38.04
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:38:04 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed0f3d4611so19927881cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:38:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVXc7Qpko8oz3l2vJSPdA0VGvoFeDhNAZLOOn7V/KnR0/KTSDT6tcooJtvDe820L1VTi+2g19+KD3B/2pY=@vger.kernel.org
X-Received: by 2002:a05:6102:3e95:b0:5db:38a1:213b with SMTP id
 ada2fe7eead31-5db90656011mr932905137.27.1761748238614; Wed, 29 Oct 2025
 07:30:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
 <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com>
In-Reply-To: <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 29 Oct 2025 15:30:27 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWriu9eUHMSKcv7ojSqbquP3=z2oaquQZLx5nmN0EcGaA@mail.gmail.com>
X-Gm-Features: AWmQ_blleyKJMjc4oETFxToQhJJ0bdzSdD1fdMmRWAHt71coVgn8wIHcAFgDdM8
Message-ID: <CAMuHMdWriu9eUHMSKcv7ojSqbquP3=z2oaquQZLx5nmN0EcGaA@mail.gmail.com>
Subject: Re: [PATCH v5 07/23] pinctrl: ma35: #undef field_{get,prep}() before
 local definition
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

On Wed, 29 Oct 2025 at 15:20, Linus Walleij <linus.walleij@linaro.org> wrot=
e:
> On Mon, Oct 27, 2025 at 7:43=E2=80=AFPM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>
> > Prepare for the advent of globally available common field_get() and
> > field_prep() macros by undefining the symbols before defining local
> > variants.  This prevents redefinition warnings from the C preprocessor
> > when introducing the common macros later.
> >
> > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Do you want me to just merge this patch to the pinctrl tree or do
> you have other plans?

My plan (cfr. cover letter) was to take it myself, as this is a hard
dependency for 11/23.
Thanks!

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

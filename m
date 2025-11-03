Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE692FD1C2
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 10:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165081; cv=none; b=EKWzf+RbyK4vZVfnYpAvoGiadGRaG0uVpU/gux/zcRnBuxlzRL2o0ZzYwJXyoLGOsXiK+UobzXUrbYszHar6m4ZZXz324Vjca9ZHVyxW/YFKBh3iWqplI05chSZoHv1vX9dTxPf/IEXFlvvHP22T/i1KScfhnmvNYly1vWMrzcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165081; c=relaxed/simple;
	bh=mTHQRbPtXcLW9RC24UimP00dT4bpQ240D8TduWco7Ms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZRyl4wC4MFBiGD5G3lH3hjtCIp3ZoKhBq+ydhJtjYjfcdoJ4B0W5na49RmCG2HUqfeXV7uO/xzSNZ/UsfHi9IUZPP9pyBqKLDrJXxrzbwFLM9YL7fD4MhjAluYQNiMVecXdjxJMavtXxw3oSXx+lcecr3I44HvvCeytb1dgcvqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b9a6ff216faso920798a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 02:18:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165079; x=1762769879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WN9rH9/69UaI2zM1r1sL3pcOf4U1LH9TZ13cniByZO0=;
        b=okKi15S/jPFlDt/Q3Aj2V+jsKML6Ll2FD8hZukgyqHFSktnmyc0k2rzixaG74/9iPj
         ixGXSXrxOOKNDBCEbcQQRCC1Y/gfC4GTU1i6tLc7B9kLrzeH9751wOuTM8Zoj166ii2u
         63qhqOLgFH1vD4cD4YbqSHcckDz/WkrkbIr+aTb3NnJJw8rHy5+O/HJYBOCNHqVewGIB
         BfMwUDZkwYR/GwUUOxrV9fp8Sw1foJjxfeiFiiemHA0Fqt3c1t+ltbugYOVdxyNj5Nbm
         AL/fzv7GgSBjm+VWnjksTc6d96cffzGeQcDjjNKqoprIUNWMQL7nXL+oeSlOFZevE88C
         LtJw==
X-Forwarded-Encrypted: i=1; AJvYcCVqZ/5dg8N/HZq2+wEPNcmbYwQDOtK1CWWPKmxc606zIX2u7ATAdzzArFrYgub37i1HlpW5JVDA9/STPu0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiDhJ8ffq/lC1Nlh3INJyGLGaeu/ujhjlK/ZE8mf3cGAvAKZ5h
	N3l/EkHMHTV7O/WJCMEjfM0cmhgOYYnqrvS1uHjmdnMaRHg6iRWvaapTCJ8R7y9x
X-Gm-Gg: ASbGncvaSr4ZMAD91+0S/rFInphLbWiEWdPr5jcpvpoXVvL6Ze1ehOyTeIIFsp29k5t
	arJM0jM4iSZ7aMUIjWX7AzQO/mBJ2MY1XgpAqPIjlpzu42ZBFwvnUt248ouZMkdSS5s8uOjLXCk
	pd6Ijk9wjyn2lIgfXsw9j7PY/mFAoU20phxL4z+RBZJzv7w2qZmzON1zzbuppmayN6y+aiPzumm
	zGqM/KtadiIEBA7DgBCUq5YR3BNbTnTiSlBW8SiXbk28yLeqfxdsN51EEgYsaIITDq5ULjtBFpr
	1o0F8ljkeWFBispvjSuQodljzgMRo+5EwC6EnObeXdDGuKlgRVCV8TUAWpSYxV6kQvUnCZGV1mT
	lcMB5Zz8rs50JYiNTKGK3tfHSG2BeSpmD8BvAHoiSrmT+NLIs46Aw0cl1iCdr9S8OthvdmWvqdL
	/urS8RQnz62ey6f35uVQ+5vtdOEmA2DGQqVZhd0DaLCL/BEWiKFhM+gXH2Ape2cG8GZ84=
X-Google-Smtp-Source: AGHT+IG5uZWXkAJQPJCJgOXJNIgXS3ilHuFLq+FZIHCONhNjdZbtso+6uUOjGw8WdQLTPoOCie7NZg==
X-Received: by 2002:a17:902:c408:b0:288:e46d:b32b with SMTP id d9443c01a7336-2951a3b7984mr191474925ad.17.1762165079252;
        Mon, 03 Nov 2025 02:17:59 -0800 (PST)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com. [209.85.210.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952e9a3972sm108303985ad.46.2025.11.03.02.17.58
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 02:17:59 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso1183914b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 02:17:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUOvx4Z2QmWtJU3heL1uQyb3PWbDZMNUccRNUp5G+2xCxE39Du19Znm85rxmQnz3GLmRF3ckJLiWhHAfM4=@vger.kernel.org
X-Received: by 2002:a05:6102:418d:b0:5db:f031:84ce with SMTP id
 ada2fe7eead31-5dbf031902dmr85155137.29.1762164587067; Mon, 03 Nov 2025
 02:09:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <97549838f28a1bb7861cfb42ee687f832942b13a.1761588465.git.geert+renesas@glider.be>
 <20251102104326.0f1db96a@jic23-huawei>
In-Reply-To: <20251102104326.0f1db96a@jic23-huawei>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 3 Nov 2025 11:09:36 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUkm2hxSW1yeKn8kZkSrosr8V-QTrHKSMkY2CPJ8UH_BQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmxzzzgoIljXMDy5wJmHF15bg4ZKICGjY8c2_gWom3ME9XAPzMw0ghLXn4
Message-ID: <CAMuHMdUkm2hxSW1yeKn8kZkSrosr8V-QTrHKSMkY2CPJ8UH_BQ@mail.gmail.com>
Subject: Re: [PATCH -next v5 10/23] iio: imu: smi330: #undef
 field_{get,prep}() before definition
To: Jonathan Cameron <jic23@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
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

Hi Jonathan,

On Sun, 2 Nov 2025 at 11:43, Jonathan Cameron <jic23@kernel.org> wrote:
> On Mon, 27 Oct 2025 19:41:44 +0100
> Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>
> > Prepare for the advent of globally available common field_get() and
> > field_prep() macros by undefining the symbols before defining local
> > variants.  This prevents redefinition warnings from the C preprocessor
> > when introducing the common macros later.
> >
> > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> So this is going to make a mess of merging your series given this is
> queued up for next merge window.
>
> I can pick this one up perhaps and we loop back to the replacement of
> these in a future patch?  Or perhaps go instead with a rename
> of these two which is probably nicer in the intermediate state than
> undefs.

Renaming would mean a lot of churn.
Just picking up the #undef patch should be simple and safe? The
removal of the underf and redef can be done in the next cycle.
Thanks!

> > --- a/drivers/iio/imu/smi330/smi330_core.c
> > +++ b/drivers/iio/imu/smi330/smi330_core.c
> > @@ -68,7 +68,9 @@
> >  #define SMI330_SOFT_RESET_DELAY 2000
> >
> >  /* Non-constant mask variant of FIELD_GET() and FIELD_PREP() */
> > +#undef field_get
> >  #define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
> > +#undef field_prep
> >  #define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
> >
> >  #define SMI330_ACCEL_CHANNEL(_axis) {                                        \

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573C629ACF6
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760962812; cv=none; b=XaNrz57Dq0+MB4iiFeq8nzUozeng4D71TZ8OL47vnBMZAP3vtipu4xyCjyHYU1FwzzbIjH3M+Dp6Besuez03Hi0WKSfTC3k1hTPluDgA7QXmPloQWaxEEhxaY/OyEYyl2A1iEcSyJxskplcoEiykqeNhnlmfF21ZBOENk6b2iis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760962812; c=relaxed/simple;
	bh=zQJyABbFIFRgraIjRfB4Kv0edNHngRx2HTU3PnrqMSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QHsDTkQPE1yNimj2nn7m4u765vmJpgVowbyfdj7PypJjOz7uB8ulGGW+KwD0HOGFp/AnkL2ivW4+WvUSK36ZKYdCFEecrfDEroP9gtmZAtWLWymMBzflPW6n0QzfjKemWW1SWUsy4GKlvvjXLkrrizb8uPHiDw3nIu5ujuzEfI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-430c97cbe0eso25346855ab.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 05:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760962808; x=1761567608;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pomt2ITXhIHlFit8dq3w5svz3PMdwi8h98cx9ZzxHC0=;
        b=s8pBo+9Q8bEIvMbDV0nNwRsiauXj17NOiUtkW/3vK2d33gdKCECjgt/zlYz5cllydU
         hTVklyTNJHacma75ClSgr9WtT/Ej81O4krSt/0iSPlyPfr3fYrff8z4ENrDwXSQGNmbT
         FWsK76Wi7ijoEnMHqiouOPJvs7xWjaBMtgYUlE37HGCyreaHKp+nfmYMUaMAJvus/g8F
         fXjhCeTUxNZCl6PGhPeidswP+FUcu4JKlFYsQSC3FnhReGmo21/3JfF0ZAMxfzJD7As7
         HAsgN/sL1UXBZT2roF+xDv61mzerBTvII99PbEQxdNK7wY6053e+6MA+Sedk2BSPxi7q
         6GpA==
X-Forwarded-Encrypted: i=1; AJvYcCVasvKWd2YICyLybbrlWq03yVNjaFQK0i0fapw+2RJw34CygmkiSHqfgnIML0ljHzrpy+IyCkasIPAeKQk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy72ji0vFrc69Mojl3Fpsjfs3UOq8RStBa40u1Fv5zOTYM3pVkP
	u7gXpsS5KufbNNI9G+h59i3c9XcBPcq36QPUwKXH/iFH4naQIekwFVvFyG0z1LCR
X-Gm-Gg: ASbGnctOe0D5n07oo80MLqCfNr7kGJ7RnYeK38A9fdovzyPCFCo2vN5wPZOT5P0u6PE
	k0nhyB6nZV7+zUtdrexSiQfCiVwGq9FJ23ILw6i3AfV0DsnzNLr66l4QvyKCNcK0XgeW7TyT2fi
	cx6lSTeomtbrxCxW/m2pf5n5IjM2t3U3ThwWM65gkdAJ4QXVOQc/oJdMVa7F/dIjOal/nbjcq7O
	1i+8Jp4m1/mHE8F5PayHczTSuccBKZENZzils3eqLtMnnPY9M4PFzzqxb6cQDMiMQbqls9SIKjp
	9mVqp+C3iMbtfgwuWy2ozCFGiXoAG03HSQ1gkEMKbHmV0mBISXuN8ACBMAw1PHmHxk9eMRcLHww
	EznQT81yJilQmn4kUOdHGKb2cYs1tI/Jy6QeQetLTvdz3NCa9wJ1x1/+V8e65TjK6VM0R/4dsA9
	FvLWKVSd8sEe14KD+K//fduhJYzIYHbGZiPpJm3lxHpZxQ6Wlo
X-Google-Smtp-Source: AGHT+IG4KjcKEsNFJQuEhZutMRUZHygfD5PLw7D3+P6Gx932gtqxvPW5QxLAJ7iTHwfzpSqzpFL/6w==
X-Received: by 2002:a05:6e02:1d9d:b0:430:ab98:7b1f with SMTP id e9e14a558f8ab-430c52beddbmr196508315ab.18.1760962808041;
        Mon, 20 Oct 2025 05:20:08 -0700 (PDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a979ab14sm2834657173.65.2025.10.20.05.20.07
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 05:20:07 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-93e7e87c21bso290414839f.3
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 05:20:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXsAVFvb/TMIjbe/+7t/MYCiBE14JfAfN5KTZgMlcEuAypZhuCGAt7NYoCGVDyEL5nVYhjBzbKtrq4t/XY=@vger.kernel.org
X-Received: by 2002:a05:6102:50a2:b0:5d5:f6ae:38ca with SMTP id
 ada2fe7eead31-5d7dd6f4c27mr3609494137.41.1760962417639; Mon, 20 Oct 2025
 05:13:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760696560.git.geert+renesas@glider.be> <792d176149bc4ffde2a7b78062388dc2466c23ca.1760696560.git.geert+renesas@glider.be>
 <aPJwtZSMgZLDzxH8@yury>
In-Reply-To: <aPJwtZSMgZLDzxH8@yury>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 20 Oct 2025 14:13:26 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXCoqZmSqRAfujib=2fk0Ob1FiPYWBj8vMXfuXNoKhfVg@mail.gmail.com>
X-Gm-Features: AS18NWDS1vbUG4-z_--VlQ3gjSspwjijy0fs8EPqX7O88cWCZQUNQKHTmAYei1k
Message-ID: <CAMuHMdXCoqZmSqRAfujib=2fk0Ob1FiPYWBj8vMXfuXNoKhfVg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] bitfield: Drop underscores from macro parameters
To: Yury Norov <yury.norov@gmail.com>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
	Shan-Chun Hung <schung@nuvoton.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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

Hi Yury,

On Fri, 17 Oct 2025 at 18:37, Yury Norov <yury.norov@gmail.com> wrote:
> On Fri, Oct 17, 2025 at 12:54:09PM +0200, Geert Uytterhoeven wrote:
> > There is no need to prefix macro parameters with underscores.
> > Remove the underscores.
> >
> > Suggested-by: David Laight <david.laight.linux@gmail.com>
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > v4:
> >   - Update recently introduced FIELD_MODIFY() macro,

> > --- a/include/linux/bitfield.h
> > +++ b/include/linux/bitfield.h
> > @@ -60,68 +60,68 @@
> >
> >  #define __bf_cast_unsigned(type, x)  ((__unsigned_scalar_typeof(type))(x))
> >
> > -#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                    \
> > +#define __BF_FIELD_CHECK(mask, reg, val, pfx)                                \
> >       ({                                                              \
> > -             BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),          \
> > -                              _pfx "mask is not constant");          \
> > -             BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");    \
> > -             BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
> > -                              ~((_mask) >> __bf_shf(_mask)) &        \
> > -                                     (0 + (_val)) : 0,               \
> > -                              _pfx "value too large for the field"); \
> > -             BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >     \
> > -                              __bf_cast_unsigned(_reg, ~0ull),       \
> > -                              _pfx "type of reg too small for mask"); \
> > -             __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
> > -                                           (1ULL << __bf_shf(_mask))); \
> > +             BUILD_BUG_ON_MSG(!__builtin_constant_p(mask),           \
> > +                              pfx "mask is not constant");           \
> > +             BUILD_BUG_ON_MSG((mask) == 0, pfx "mask is zero");      \
> > +             BUILD_BUG_ON_MSG(__builtin_constant_p(val) ?            \
> > +                              ~((mask) >> __bf_shf(mask)) &  \
> > +                                     (0 + (val)) : 0,                \
> > +                              pfx "value too large for the field"); \
> > +             BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >       \
> > +                              __bf_cast_unsigned(reg, ~0ull),        \
> > +                              pfx "type of reg too small for mask"); \
> > +             __BUILD_BUG_ON_NOT_POWER_OF_2((mask) +                  \
> > +                                           (1ULL << __bf_shf(mask))); \
> >       })
>
> I agree that underscored parameters are excessive. But fixing them has
> a side effect of wiping the history, which is a bad thing.
>
> I would prefer to save a history over following a rule that seemingly
> is not written down. Let's keep this untouched for now, and if there
> will be a need to move the code, we can drop underscores as well.

Fair enough.
So I assume you are fine with not having underscored parameters in
new code, like in [PATCH v4 2/4]?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

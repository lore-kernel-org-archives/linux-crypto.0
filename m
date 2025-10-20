Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B45B311978
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 13:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760965632; cv=none; b=Nhs4OkWFR1SkwDWcVCpDU70eg7oAtqu+E79GLNHfoKL0Y/LwwwYUBCuax/PNa0y0RqPsUFPxSVzd6YWjEtbnyHuFrv1MqAI5JICmxcemblvtnsVtczyGXcTU3NR5ZkS6f7WnYBFPQhHMeKZB7RzUkwxnaeNSZMHpNvrjCZNAbWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760965632; c=relaxed/simple;
	bh=+BhpvIfdxxZ/aCetXMa1dsKCSF78eaw36kKX1XCRo0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkEfcQNyHdHIvg6DlJjQPyFFKVyjvpGrKTvwR2T/8ol0EGB5PKAXBD6aGy/6mmUHqd+X95Kdp/YS7Pzx5zPJ5FTNeWpYIiujwINVtJn1x0+8aXuDfs2O/K86wdOl1c2SJvhgoYhaxkOFN9ysySSTT1jkrqgK7XkJRlYTZ5Eyl9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-879b99b7ca8so66430336d6.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 06:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760965627; x=1761570427;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTAfAvg+E5E0/JeW2qvrB22XDr/x/zemAkA2zC9bvaY=;
        b=jpxa6oXMONiZESldQV+QKlq4R9Bt1a1SIRAhc2bTjnwQ6/y7ojV0tBnZMyJbtEx098
         L8VjUKleLXJyl3v4ejHHogIw1iPd5mePApVtG9val8EWo/qRRG2ziSoDhaMurbhoSgKW
         L+d7cU7nPKvri1bGWOm6YI8skDl+gbt36dvC2Yr91r9OXQ9ezIhEcyN4Q9+u7wtBp9Yw
         QXALmSJ61M/65R+aO7dNm9PmgIzYJgxZkGGbRc2NZe48URwcXJ8yRn6flNi3m+mkl+Bb
         HrBfmrOYy/19WZpBEwHE2PrawSOcAev/IjGvtkdyYWD2hNdcUsxcwuuPAwz3qyV3Pry8
         II0w==
X-Forwarded-Encrypted: i=1; AJvYcCUgUbbFyGy4ZtDMdYsfi3LeccZrlO/aU/QRFh32BgjOmBmMqIauCIIAdMM2cUUgpdUtArSWYFBA2hld478=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFcsa/Q+MzWbcn7RvtFVQR15tiPePsJBFPtK7C9VQL7AVqAJCy
	SFFV3ku2oZRFrqyIhosgleRDbMK1BRp9NvI8G1xLxpgZs9elvxA1MLPsyMK3RJbJ
X-Gm-Gg: ASbGncvl7PsH8QSeIqoFtTYo1NT9Tl+mVDPwpqKLb31mJYvk/a1lZT+Cgc2dsWfq9uY
	BBYyhcrszWPtLO5+9u7jbNoFpxgtYSZqha7RSPeUtcRRLEUccMM5sxhjRYL/Wnq8cwii8bmw6EL
	sjMrtJOTs1tgBATkjbpTphSPuK2XJ9kroqcYzJrsoXjH9Gk2qsL/IH4plItdIQUjN+Kr1Y1mpBz
	6F8+KKb4pVlMgm6v9zaj2DqYsY+xlyIvZZEVe1fT5AONapqNx2Z9QsETqABMCJQQqbpLGtpPmsO
	kKno7ud1X7zFZ9dEKJbnSWowGDNAFWjm9tyYX6EQ3hw7v8assW7YEtkTXZeJDS47FjnZhptGDD0
	sx0XajrYVtE+w2BSunGSr9lddFr8NCwFTwo8lStX110uwhZHqobXOwgpygpia+MkfOagdoPhdDA
	/C2TnyOP7tGrk0JAgKg6q8/4Wz8K4TuFUs0dobGgg6Pw==
X-Google-Smtp-Source: AGHT+IHiTIIYoV+RpkApOGMmBkgwXuGT6D/NE+qYjJVzfvm98tNeBElsmZA716dJfZXfRxrtAeigSQ==
X-Received: by 2002:a05:622a:28b:b0:4e8:a54d:cce0 with SMTP id d75a77b69052e-4e8a54dcd87mr131974281cf.53.1760965626570;
        Mon, 20 Oct 2025 06:07:06 -0700 (PDT)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cc9cacd0sm556529085a.3.2025.10.20.06.07.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:07:06 -0700 (PDT)
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-890deb84f95so456717885a.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 06:07:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXzSGmfjdlAKpcZwJ2Rr+tp4QSJrh7iFzUu8TCcOn+du6LPqRkOU8oecRBIpARDGVpTAbupLLVoxCH4WeE=@vger.kernel.org
X-Received: by 2002:a05:6102:f09:b0:5d5:f6ae:38d1 with SMTP id
 ada2fe7eead31-5db093f61bfmr207405137.38.1760965235930; Mon, 20 Oct 2025
 06:00:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760696560.git.geert+renesas@glider.be> <67c1998f144b3a21399672c8e4d58d3884ae2b3c.1760696560.git.geert+renesas@glider.be>
 <aPKQMdyMO-vrb30X@yury>
In-Reply-To: <aPKQMdyMO-vrb30X@yury>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 20 Oct 2025 15:00:24 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXq7xubX4a6SZWcC1HX+_TsKeQigDVQrWvA=js5bhaUiQ@mail.gmail.com>
X-Gm-Features: AS18NWBop_uORR3NT3_HDoVoJ_Tyxhm-9TufWw0aoroSF1IMR97eq1M8wyRugog
Message-ID: <CAMuHMdXq7xubX4a6SZWcC1HX+_TsKeQigDVQrWvA=js5bhaUiQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] bitfield: Add non-constant field_{prep,get}() helpers
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
	linux-kernel@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Yury,

On Fri, 17 Oct 2025 at 20:51, Yury Norov <yury.norov@gmail.com> wrote:
> On Fri, Oct 17, 2025 at 12:54:10PM +0200, Geert Uytterhoeven wrote:
> > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > constants.  However, it is very common to prepare or extract bitfield
> > elements where the bitfield mask is not a compile-time constant.
> >
> > To avoid this limitation, the AT91 clock driver and several other
> > drivers already have their own non-const field_{prep,get}() macros.
> > Make them available for general use by consolidating them in
> > <linux/bitfield.h>, and improve them slightly:
> >   1. Avoid evaluating macro parameters more than once,
> >   2. Replace "ffs() - 1" by "__ffs()",
> >   3. Support 64-bit use on 32-bit architectures.
> >
> > This is deliberately not merged into the existing FIELD_{GET,PREP}()
> > macros, as people expressed the desire to keep stricter variants for
> > increased safety, or for performance critical paths.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Acked-by: Crt Mori <cmo@melexis.com>
> > ---
> > v4:
> >   - Add Acked-by,
> >   - Rebase on top of commit 7c68005a46108ffa ("crypto: qat - relocate
> >     power management debugfs helper APIs") in v6.17-rc1,
> >   - Convert more recently introduced upstream copies:
> >       - drivers/edac/ie31200_edac.c
> >       - drivers/iio/dac/ad3530r.c
>
> Can you split out the part that actually introduces the new API?

Unfortunately not, as that would cause build warnings/failures due
to conflicting redefinitions.
That is a reason why I want to apply this patch ASAP: new copies show
up all the time.

> > --- a/include/linux/bitfield.h
> > +++ b/include/linux/bitfield.h
> > @@ -220,4 +220,40 @@ __MAKE_OP(64)
> >  #undef __MAKE_OP
> >  #undef ____MAKE_OP
> >
> > +/**
> > + * field_prep() - prepare a bitfield element
> > + * @mask: shifted mask defining the field's length and position
> > + * @val:  value to put in the field
> > + *
> > + * field_prep() masks and shifts up the value.  The result should be
> > + * combined with other fields of the bitfield using logical OR.
> > + * Unlike FIELD_PREP(), @mask is not limited to a compile-time constant.
> > + */
> > +#define field_prep(mask, val)                                                \
> > +     ({                                                              \
> > +             __auto_type __mask = (mask);                            \
> > +             typeof(mask) __val = (val);                             \
> > +             unsigned int __shift = sizeof(mask) <= 4 ?              \
> > +                                    __ffs(__mask) : __ffs64(__mask); \
> > +             (__val << __shift) & __mask;    \
>
> __ffs(0) is undef. The corresponding comment in
> include/asm-generic/bitops/__ffs.h explicitly says: "code should check
> against 0 first".

An all zeroes mask is a bug in the code that calls field_{get,prep}().

> I think mask = 0 is a sign of error here. Can you add a code catching
> it at compile time, and maybe at runtime too? Something like:
>
>  #define __field_prep(mask, val)
>  ({
>         unsigned __shift = sizeof(mask) <= 4 ? __ffs(mask) : __ffs64(mask);
>         (val << __shift) & mask;
>  })
>
>  #define field_prep(mask, val)
>  ({
>         unsigned int __shift;
>         __auto_type __mask = (mask), __ret = 0;
>         typeof(mask) __val = (val);
>
>         BUILD_BUG_ON_ZERO(const_true(mask == 0));

Futile, as code with a constant mask should use FIELD_PREP() instead.

>
>         if (WARN_ON_ONCE(mask == 0))
>                 goto out;
>
>         __ret = __field_prep(__mask, __val);
>  out:
>         ret;
>  })

Should we penalize all users (this is a macro, thus inlined everywhere)
to protect against something that is clearly a bug in the caller?
E.g. do_div() does not check for a zero divisor either.

> > +
> > +/**
> > + * field_get() - extract a bitfield element
> > + * @mask: shifted mask defining the field's length and position
> > + * @reg:  value of entire bitfield
> > + *
> > + * field_get() extracts the field specified by @mask from the
> > + * bitfield passed in as @reg by masking and shifting it down.
> > + * Unlike FIELD_GET(), @mask is not limited to a compile-time constant.
> > + */
> > +#define field_get(mask, reg)                                         \
> > +     ({                                                              \
> > +             __auto_type __mask = (mask);                            \
> > +             typeof(mask) __reg =  (reg);                            \
>
> This would trigger Wconversion warning. Consider
>         unsigned reg = 0xfff;
>         field_get(0xf, reg);
>
> <source>:6:26: warning: conversion to 'int' from 'unsigned int' may change the sign of the result [-Wsign-conversion]
>     6 |     typeof(mask) __reg = reg;
>       |                          ^~~
>
> Notice, the __auto_type makes the __mask to be int, while the reg is

Apparently using typeof(mask) has the same "issue"...

> unsigned int. You need to do:
>
>         typeof(mask) __reg = (typeof(mask))(reg);

... so the cast is just hiding the issue? Worse, the cast may prevent the
compiler from flagging other issues, e.g. when accidentally passing
a pointer for reg.

>
> Please enable higher warning levels for the next round.

Enabling -Wsign-conversion gives lots of other (false positive?)
warnings.

> Also, because for numerals __auto_type is int, when char is enough - are
> you sure that the macro generates the optimal code? User can workaround it
> with:
>
>         field_get((u8)0xf, reg)
>
> but it may not be trivial. Can you add an example and explanation please?

These new macros are intended for the case where mask is not a constant.
So typically it is a variable of type u32 or u64.

> > +             unsigned int __shift = sizeof(mask) <= 4 ?              \
> > +                                    __ffs(__mask) : __ffs64(__mask); \
>
> Can you use BITS_PER_TYPE() here?

Yes, I could use BITS_PER_TYPE(unsigned long) here, to match the
parameter type of __ffs() (on 64-bit platforms, __ffs() can be used
unconditionally anyway), at the expense of making the line much longer
so it has to be split.  Is that worthwhile?

>
> > +             (__reg & __mask) >> __shift;    \
> > +     })
> > +
>
> When mask == 0, we shouldn't touch 'val' at all. Consider
>
>         field_get(0, get_user(ptr))
>
> In this case, evaluating 'reg' is an error, similarly to memcpy().

Again, a zero mask is a bug.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

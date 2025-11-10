Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93A82E92B0
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762767604; cv=none; b=qfOMmZXmQcejx7Z0SxPF1H3WSkl+kJxej4juD8k09MFwM5MmiuIsgQ02FMF5Pg/kCk0a41F9zByirOCOoOwpYwO2lHm1RBjg+K3+KfgkV00rijahiLN/sQhKTQuEm3xvPvWetqn8Y6IR8Z9YJ4clClt6DOayZw7ATGti9dFBxCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762767604; c=relaxed/simple;
	bh=SmCYeZZA+MZ4YAMzw1eRf/lethvMOqxmL8UnzEdKQB8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HnJExqNN5DbBRcHzKgnqAAcFKIDBwhyEXQ1N6JiclhOjXYpyDSchNcFW5CY2hO5smnpEd9Kh21Ihm/g/Em6GLUELLOjFb2R/oCQuK0ydsNk5r+erCTrn0coTkmz9eZO5dEuCf3OBtMmfSGNKujt21U6TCtc/Kke6BiWc5MGmzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-559836d04f6so1802715e0c.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 01:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762767600; x=1763372400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lsrcVDrEohRhH3DeIYD/Jz8ulaHSwnUzTLywFA/cyng=;
        b=hxuQGl5YviNltEgYapXUOip+SEwZtIM13RUC0BfEPIuvPvB0dWVodrC0IQ2Tbn1Lp/
         nm7V/mj5EZyjUYE0ezHDMeV1xhCbZ+83rqhsHDrMYHRYLHPdLtaLUnprtT2MI8FvQMqy
         tayVscqLfFZyE0cC/mCwAADOLW68ZLjQUNmQStv1WfVUVcI7S25WvxRoGo0iJw1gRhrm
         1BCmp/0+iSEsxPUbw9j4tOJGmNksotPlK/QJ/FTlZ75zP+9WXIfPZXAqChsl3oFNiGlj
         yBlO86JhfBpki8XdwKqTajG0bShs1d9C3v2bpN0CiIBWlNRBbsdIpw8z9GyiQ+jFxlDh
         rEtw==
X-Forwarded-Encrypted: i=1; AJvYcCVxn1MMe7Gnbq/k09aWKbRqyRh84g1cDt20zdkyviwUBsZexf/5PZ9g4xoByymtlPeOYScu2NmS5iOFuuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJN4DwJFZNzWRtJwe4NhkvVk5ns0APkuKfT8Jv+EH26UlO3sew
	0KDwvx+zyx5WzMqotEBBUDeBcD/d3/aOT1a/VRIbBgmmad4dKGvYRIvY4nOYfFdv
X-Gm-Gg: ASbGncs81xaRqkAF86EUVr5L+Yg+DIhG9bBExg9hcrDV6VYtQM2S7nuFk+M5NY4UVt7
	Bli45xhyr7ltH6b8qYePMn6HXZ3eqnW4IuNqg6QcofZunF4HgJKFtR4O3DzqByoQELE7X9QxmQi
	y9r7Phml3cGLDwhedx+qMUmBJ7GtKxZFtYSZ+2kDAVQiqmUjeFMT3yYdOx5KSFZ5IWwDH5sG20/
	MZkIwNwQdJbNEXxOnOXGCb1g+mfkbYQ1iHwgUh0yghjsGToO/MGW6STKzQ1dJ6tn0x+OHqThkxd
	3llGY+YyG6TMtmr80PPzXMyuEgWmfXXMFrqOxNi8hfQ7yRI92oiDH8U+31CE6pEYwohphcAw/J8
	4G/kz/ii3PoHqGu+dOcsEZ0ZhXXnyUQc/VH8E7d+BvMCcH9t2XGIDZpEKB7ugQ+EBIc8PkHk14v
	IhWmUBnkhPE6ZWIYlguPRE90Ar1YQlk8Xe6wJ+gRu3gtdXJ9GgrGrsQcYR
X-Google-Smtp-Source: AGHT+IEdu6AyAuFvGmGjq/5juO+dPa/jw2JIVVnwdzjhAlolpOgfrnMfVu1r5tuvIyR+nlwefq9RBg==
X-Received: by 2002:a05:6122:4687:b0:559:6092:936c with SMTP id 71dfb90a1353d-559b32c51a6mr2795926e0c.12.1762767600295;
        Mon, 10 Nov 2025 01:40:00 -0800 (PST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559957fb3c1sm7040196e0c.12.2025.11.10.01.40.00
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 01:40:00 -0800 (PST)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5598b58d816so1888229e0c.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 01:40:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWhg6baZgEZc3X+MdnEfYV4TQhDpQmqcwokkeZ9DWgvsVcf7G+ubfcH75iqOqikxSh7T75aL7RXJhy74oQ=@vger.kernel.org
X-Received: by 2002:a05:6102:162a:b0:5dd:8a20:d6eb with SMTP id
 ada2fe7eead31-5ddc47517c6mr2576190137.25.1762767247552; Mon, 10 Nov 2025
 01:34:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1762435376.git.geert+renesas@glider.be> <cfc32f8530d5c0d4a7fb33c482a4bf549f26ec24.1762435376.git.geert+renesas@glider.be>
 <aQy0T2vUINze_6_q@smile.fi.intel.com> <CAMuHMdXVUJq36GvNUQE8FnHsX+=1jG4GOJ_034r=fgr_Rw4Djg@mail.gmail.com>
 <aQzIIqNnTY41giH_@smile.fi.intel.com> <CAMuHMdW8ndAdGnSHopYFMWvw7wk7wKz_7+N91M1jRHoqK1KBrg@mail.gmail.com>
 <c62eb5a727f149fb9d8b4a4c8d77418a@realtek.com> <CAHp75VeMqvywS20603yDSo-C3KCu+i+8vvDNuz3h9e8Ma9BOCw@mail.gmail.com>
In-Reply-To: <CAHp75VeMqvywS20603yDSo-C3KCu+i+8vvDNuz3h9e8Ma9BOCw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 10 Nov 2025 10:33:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVUdey27RTX8mLsB5wsTfuW_mP_hF503AaF2QyS4awDcw@mail.gmail.com>
X-Gm-Features: AWmQ_bkW2UuenDn6w7Wole8ay3msAtk8Ugj-awLiClF7uVATEqk1c30upT0lUKU
Message-ID: <CAMuHMdVUdey27RTX8mLsB5wsTfuW_mP_hF503AaF2QyS4awDcw@mail.gmail.com>
Subject: Re: [PATCH v6 12/26] bitfield: Add less-checking __FIELD_{GET,PREP}()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Andy Shevchenko <andriy.shevchenko@intel.com>, 
	Yury Norov <yury.norov@gmail.com>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
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
	Jianping Shen <Jianping.Shen@de.bosch.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "qat-linux@intel.com" <qat-linux@intel.com>, 
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, 
	"linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>, 
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, 
	"linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>, 
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ady,

On Fri, 7 Nov 2025 at 09:00, Andy Shevchenko <andy.shevchenko@gmail.com> wr=
ote:
> On Fri, Nov 7, 2025 at 3:16=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> =
wrote:
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Thu, 6 Nov 2025 at 17:09, Andy Shevchenko
> > > <andriy.shevchenko@intel.com> wrote:
> > > > On Thu, Nov 06, 2025 at 03:49:03PM +0100, Geert Uytterhoeven wrote:
> > > > > On Thu, 6 Nov 2025 at 15:44, Andy Shevchenko
> > > > > <andriy.shevchenko@intel.com> wrote:
> > > > > > On Thu, Nov 06, 2025 at 02:34:00PM +0100, Geert Uytterhoeven wr=
ote:
> > > > > > > The BUILD_BUG_ON_MSG() check against "~0ull" works only with =
"unsigned
> > > > > > > (long) long" _mask types.  For constant masks, that condition=
 is usually
> > > > > > > met, as GENMASK() yields an UL value.  The few places where t=
he
> > > > > > > constant mask is stored in an intermediate variable were fixe=
d by
> > > > > > > changing the variable type to u64 (see e.g. [1] and [2]).
> > > > > > >
> > > > > > > However, for non-constant masks, smaller unsigned types shoul=
d be valid,
> > > > > > > too, but currently lead to "result of comparison of constant
> > > > > > > 18446744073709551615 with expression of type ... is always
> > > > > > > false"-warnings with clang and W=3D1.
> > > > > > >
> > > > > > > Hence refactor the __BF_FIELD_CHECK() helper, and factor out
> > > > > > > __FIELD_{GET,PREP}().  The later lack the single problematic =
check, but
> > > > > > > are otherwise identical to FIELD_{GET,PREP}(), and are intend=
ed to be
> > > > > > > used in the fully non-const variants later.
> > >
> > > > > > > +     BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >      =
         \
> > > > > > > +                      __bf_cast_unsigned(reg, ~0ull),       =
         \
> > > > > > > +                      pfx "type of reg too small for mask")
> > > > > >
> > > > > > Perhaps we may convert this (and others?) to static_assert():s =
at some point?
> > > > >
> > > > > Nick tried that before, without success:
> > > > > https://lore.kernel.org/all/CAKwvOdm_prtk1UQNJQGidZm44Lk582S3p=3D=
of0y46+rVjnSgXJg@mail.gmail.com
> > > >
> > > > Ah, this is unfortunate.
> > >
> > > Of course, it might be an actual bug in the i915 driver...
> > >
> > > The extra checking in field_prep() in case the compiler can
> > > determine that the mask is a constant already found a possible bug
> > > in drivers/net/wireless/realtek/rtw89/core.c:rtw89_roc_end():
> > >
> > >     rtw89_write32_mask(rtwdev, reg, B_AX_RX_FLTR_CFG_MASK, rtwdev->ha=
l.rx_fltr);
> > >
> > > drivers/net/wireless/realtek/rtw89/reg.h:
> > >
> > >     #define B_AX_RX_MPDU_MAX_LEN_MASK GENMASK(21, 16)
> > >     #define B_AX_RX_FLTR_CFG_MASK ((u32)~B_AX_RX_MPDU_MAX_LEN_MASK)
> > >
> > > so it looks like B_AX_RX_FLTR_CFG_MASK is not the proper mask for
> > > this operation...
> >
> > The purpose of the statements is to update values excluding bits of
> > B_AX_RX_MPDU_MAX_LEN_MASK. The use of B_AX_RX_FLTR_CFG_MASK is tricky, =
but
> > the operation is correct because bit 0 is set, so __ffs(mask) returns 0=
 in
> > rtw89_write32_mask(). Then, operation looks like
> >
> >    orig =3D read(reg);
> >    new =3D (orig & ~mask) | (data & mask);
> >    write(new);
> >
> > Since we don't use FIELD_{GET,PREP} macros with B_AX_RX_FLTR_CFG_MASK, =
how
> > can you find the problem? Please guide us. Thanks.
>
> Isn't FIELD_MODIFY() what you want to use?

FIELD_MODIFY() is a rather recent addition.
That is also the reason why I didn't add a non-const field_modify() yet
(I didn't want to risk delaying this series even more ;-)

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

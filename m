Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8F15855E
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 08:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762504881; cv=none; b=XLZUZHSo5eLgPu4gq9R0Ema49VPQNYPLA7u6wDatCtjBZR3Cu7PsrJmVzPxFqwtNM+niM3821nfOVvQFSBX0Mh6O8llmxl/ut9r4mSm7xZ9Bmyj+nyQqZn6hUNAylUXe0bUCiPHi2q6sJcCi6zghziDdfxNgeXsPEpS+cEdDWUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762504881; c=relaxed/simple;
	bh=9JcvPVILVy97hsdXJNb7VMxu6BBjGO1PhoJ8NRS9yLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lm9UlBmOdhKfLN+gHbs9/VcLE+AHHVDcyz1BBo8vNcUnYclg1Soj+yrjwjANcpd2fRoVRCExUiCvD+4QbY1Y/JnS7JCZgEzZiglu4ur7+2VKYNyg29ZJ9jbl/KcYClDjkJuNdx3OnJ46MEKRFn6qM0y8R6ACNaxWl73wdeAIDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-932c2071cf5so275736241.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:41:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762504879; x=1763109679;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsHZezS59+NExnNGIIdIy6ER8EF0CQG8kO0yNppcdcI=;
        b=fB0eOAn/azPNvvc+yzjJezu/TwLvjzf5L25zwbpJ1CnAo7tnIN+Szh3CfkWDh6aqhh
         W7BqedsvLb7DJ4aF65zYurqwRAcn2PhZ2oh8fQPQKQTt0manOtQq8JEJVD53JwVYN9W/
         WQGpwQSuQ6NQmrPD8R5oq1qaZLZhlLEBlZwqlyMnf8sQmvlzIHTV+xInb2JAoRbsFS/r
         lv83anpV8gqq4NhzeuvMH1JDBERsPZC6Muy/l8QZR/cnM59WfqKMQ1waUydL1oaq/mS1
         Ijjqqzo5890BRRvyG7IYUJ3BId6Kbs4IFK4defhcnKwB83QmR5uNf761lRMC6y2b8m79
         UoFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkjQfxDtBg9IoYEPWVs39VNnfleNX0Zvz/MopP2CXzNeT8HRYXcieR9YIDM7b2UNdlH7FcB9ZhMCoZD88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5zF7RGWBl3hhB2jg85qtVx607YH1HP4qoI5kg555fsayFqPQV
	BXM9VWAtMI4fnBB0EYrOSAXJ8qxHxdpWD4vdWrmjLFg9MQ7I4pjbXmbUdOGhkWe1K10=
X-Gm-Gg: ASbGncsQVJMHnCjoy0wG/7+i1yg+XQ7vyIt/XnRlpWSCNCj4zP3gE35pSVjhL4WuJ6h
	IN03CL5IV47XZRMHmxsodNpNApvY0eRumxLk9kdnOBvbBwqWVwvjaWACc2gNEI0tuZuNHMb4LyG
	MFA1Tl3GyDDSmnKrBTFGJKsozohPypomV3hHJ/22+qvXtueUWmuOMqXRlnU4Zi/dopzr5whsd1U
	OBpi84y6s6O/T4U9V7INauW2/PNKiXauhLm6r5wwODBh1qyZtiLqeXtLlLeeZdnDJpwwqPKfgqc
	kvFr1AeU4b29lORcVISyyovDfr1552O+L4w0SvqR/gLDBM6dCw41W8T7I1601DhycCHxzwjvMAx
	SEArOfGu196EtMf5zo6hruIxR04enuc2F86UAcLqOtWhDWRk2IdCYOeMAqkUdIpkgdZDyKyFEsx
	zmSwiMQygog4iY5xWwCe/IXRnyPLAPR7d/edcXGf6rjl5+peoAuz4J
X-Google-Smtp-Source: AGHT+IH0IjJst2+raS5xq79fdHPLVBD0bG2cn14RL0feuTd7JZsNM+pe+MZN1j12HLbSqoLBxP9Btg==
X-Received: by 2002:a05:6102:374c:b0:5db:aee2:9964 with SMTP id ada2fe7eead31-5ddb9b7dd5fmr268979137.9.1762504878925;
        Fri, 07 Nov 2025 00:41:18 -0800 (PST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9370898d9d1sm2158891241.12.2025.11.07.00.41.18
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 00:41:18 -0800 (PST)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5598942c187so273636e0c.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:41:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXaw4rEpZCQF2LstALBdedGx5doGbkRM7an1d0MOwTMvoSZYOEniafECV5/JG+FNUNRYpDP0t0kXnXwRc8=@vger.kernel.org
X-Received: by 2002:a05:6102:4425:b0:5db:e32d:a3ff with SMTP id
 ada2fe7eead31-5ddb9e056aemr278996137.19.1762504514580; Fri, 07 Nov 2025
 00:35:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1762435376.git.geert+renesas@glider.be> <cfc32f8530d5c0d4a7fb33c482a4bf549f26ec24.1762435376.git.geert+renesas@glider.be>
 <aQy0T2vUINze_6_q@smile.fi.intel.com> <CAMuHMdXVUJq36GvNUQE8FnHsX+=1jG4GOJ_034r=fgr_Rw4Djg@mail.gmail.com>
 <aQzIIqNnTY41giH_@smile.fi.intel.com> <CAMuHMdW8ndAdGnSHopYFMWvw7wk7wKz_7+N91M1jRHoqK1KBrg@mail.gmail.com>
 <c62eb5a727f149fb9d8b4a4c8d77418a@realtek.com>
In-Reply-To: <c62eb5a727f149fb9d8b4a4c8d77418a@realtek.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 7 Nov 2025 09:35:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU3hWDOWXxuOJcBA7tphBT7X-0H+g0-oq0tZdKw+O5W3A@mail.gmail.com>
X-Gm-Features: AWmQ_bkZe8xF0tkRpW5gVlylkcfm2r3jZb2Xa1XdOQVS8F7wx8KXagIs6XSHJvI
Message-ID: <CAMuHMdU3hWDOWXxuOJcBA7tphBT7X-0H+g0-oq0tZdKw+O5W3A@mail.gmail.com>
Subject: Re: [PATCH v6 12/26] bitfield: Add less-checking __FIELD_{GET,PREP}()
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Yury Norov <yury.norov@gmail.com>, 
	Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
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

Hi Ping-Ke,

On Fri, 7 Nov 2025 at 02:16, Ping-Ke Shih <pkshih@realtek.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > The extra checking in field_prep() in case the compiler can
> > determine that the mask is a constant already found a possible bug
> > in drivers/net/wireless/realtek/rtw89/core.c:rtw89_roc_end():
> >
> >     rtw89_write32_mask(rtwdev, reg, B_AX_RX_FLTR_CFG_MASK, rtwdev->hal.rx_fltr);
> >
> > drivers/net/wireless/realtek/rtw89/reg.h:
> >
> >     #define B_AX_RX_MPDU_MAX_LEN_MASK GENMASK(21, 16)
> >     #define B_AX_RX_FLTR_CFG_MASK ((u32)~B_AX_RX_MPDU_MAX_LEN_MASK)
> >
> > so it looks like B_AX_RX_FLTR_CFG_MASK is not the proper mask for
> > this operation...
>
> The purpose of the statements is to update values excluding bits of
> B_AX_RX_MPDU_MAX_LEN_MASK. The use of B_AX_RX_FLTR_CFG_MASK is tricky, but
> the operation is correct because bit 0 is set, so __ffs(mask) returns 0 in
> rtw89_write32_mask(). Then, operation looks like
>
>    orig = read(reg);
>    new = (orig & ~mask) | (data & mask);
>    write(new);

Thanks for your quick confirmation!
So the intention really is to clear bits 22-31, and write the rx_fltr
value to bits 0-15?

if the clearing is not needed, it would be better to use
#define B_AX_RX_FLTR_CFG_MASK GENMASK(15, 0)

If the clearing is needed, I still think it would be better to
change B_AX_RX_FLTR_CFG_MASK, and split the clearing off in a separate
operation, to make it more explicit and obvious for the casual reader.

> Since we don't use FIELD_{GET,PREP} macros with B_AX_RX_FLTR_CFG_MASK, how
> can you find the problem? Please guide us. Thanks.

I still have "[PATCH/RFC 17/17] rtw89: Use bitfield helpers"
https://lore.kernel.org/all/f7b81122f7596fa004188bfae68f25a68c2d2392.1637592133.git.geert+renesas@glider.be/
in my local tree, which started flagging the use of a discontiguous
mask with the improved checking in field_prep().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

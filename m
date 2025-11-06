Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D468619D07E
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440567; cv=none; b=cowasI+be4jGGX2le78ZmedcfgYKcEba+k9gIp5ZZEsKlAMfjqOGAyce/lrSr0WvwwJLBIEG4DnNNBXleKj0+fsg7pQbGkgG6HIlHGJlJltyZy3asPIA2AnNftHWezGz9Q7Ud9SyULxGljcTfBp9an4cofSLDSO53CfNyosLdu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440567; c=relaxed/simple;
	bh=HaefBq/9gx/xpe6H9SR+jXE6I2U49/Bi4dkyZMOckp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L/heQQLw6GVlAu97XtCVhG7MPZzo3kFOysz5TECHb6A/XKzJNDpPpJKwmDfirJwaoO5emao2uVmHHd74OU+XnJniu2iE1ENUQD+NF/iVrFzvrbjJruKnrmmofIHmGb4sr2zbDg/FcJgFw42de4qCH74D8wD7u91Ju0H2J/5O8UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b72b495aa81so29652966b.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 06:49:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440562; x=1763045362;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZxZVtMOHoNocoyXPFvfejRTHivuCeFc8a9lYqiVNw1Y=;
        b=eCPv5zPSKX8KVR0mEVSDkKCamH8TxoMYukoL8oCAI9FvjarBueyisbyd1ALsQSZaEM
         TAdqsoBF1O/2+XfbjWRqi69KgnbojP40qDyIjEXvQ9WB5UtWNCPxPhJdIacBOvAJK2wo
         BEHOWP4tvuLImZ+euhpTVQHdWcbgzdoAR28OYl/WXFX679Ptt9B9Hy95nxdPgX2FeIL3
         NJA1wvJ1E2t8jNhOGLt05NTOYnSIHnr1POp1xnnOmpQQO9jI+30brmT5+VRlqs+cFq47
         nAWGYZXaNSQABFoUOCc4jiaaqMWqDJ4qFp9L3SCbJhPoGSBY94pElL8hJda+JTFXU7v4
         7W6A==
X-Forwarded-Encrypted: i=1; AJvYcCWUUQKkV7885Nb4ek11wrAufyF4NMJ/AQDWBX71rD6MM7fgqBR4b7Mh1oz7imKzUA9oKzWSb8f1L1G8iSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBh76NHeqP9vmyXBuoTqec1tK6SBowFy5M2i8d3LkfwJOzS8Ka
	QM9erbrJE9NSA9uhvg6/DkFj5WB92RczD6mTbXZhCsACawcy83/odlZmv5B0pSBcjKU=
X-Gm-Gg: ASbGncuQVvf5FJg8sRZRB4Txxk0u25++9n2EZUYURPeADy5U0su6IHgXUdd9daY5IAO
	p2ionBdFYwGCpa++FVn8ZbcIkKWGAf/XVoa5O47ZNwkvwryWXvG1BQJu8qineEhVCq0JW/a23tZ
	H0vBgcfuHUNI9uQYzccrlqmhWCDfAhpM5gDPPJCw/avBLiZwsUSm7hcfYj8BpDdSZVheGVUj4Ru
	zbPliNq3i3xEuLfRifj7aDJt0/bjLzYc2LJfCMFPliDktTxfV8tbCnv4fL6pmeluCWGeA++CfpK
	rQB9LyfS7LfZCHzetJrVdqkdaVGneXhRp82QHSQGRijsDo2bkGcsst7R0gp32g+cHv+MP2j+c6C
	sJOfovl5S7fxgabeSPnyQMxOnlN2MWXL6WzEozMJhyhcDI4hVRfpUcq+jzy/EimRyDS4OTskJzy
	O4ivNtMUpxxxO94CSo8Dd9n2tpLp7UPZvVLq/aLa2BFmM/9AK9
X-Google-Smtp-Source: AGHT+IGWjsWWeD1UwiFAhNBQpIdYzOBPdOyf1sxIvXPB08Q5h8B9Yz12MUHOEUvzkC172ZeIQ2975g==
X-Received: by 2002:a17:907:3f1b:b0:b46:6718:3f30 with SMTP id a640c23a62f3a-b726556f945mr722331866b.51.1762440562096;
        Thu, 06 Nov 2025 06:49:22 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72896c8127sm226493766b.73.2025.11.06.06.49.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 06:49:16 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so1566395a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 06:49:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVNeQ9YsvRsNfAvqt62jDKGKxP67fFKUXNrkbg9BVsU8bU+WOitRBP2L7pTIcMWeDpwM9i0b8rm36bESFw=@vger.kernel.org
X-Received: by 2002:a05:6402:1ed5:b0:640:b643:f3c5 with SMTP id
 4fb4d7f45d1cf-641058cf323mr7301623a12.16.1762440555932; Thu, 06 Nov 2025
 06:49:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1762435376.git.geert+renesas@glider.be> <cfc32f8530d5c0d4a7fb33c482a4bf549f26ec24.1762435376.git.geert+renesas@glider.be>
 <aQy0T2vUINze_6_q@smile.fi.intel.com>
In-Reply-To: <aQy0T2vUINze_6_q@smile.fi.intel.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 6 Nov 2025 15:49:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXVUJq36GvNUQE8FnHsX+=1jG4GOJ_034r=fgr_Rw4Djg@mail.gmail.com>
X-Gm-Features: AWmQ_bnZOzLGAFcWzxKh1EIKjH4MNs7moeVCtN8xGb6mN65nYBliBYrABdUBf0M
Message-ID: <CAMuHMdXVUJq36GvNUQE8FnHsX+=1jG4GOJ_034r=fgr_Rw4Djg@mail.gmail.com>
Subject: Re: [PATCH v6 12/26] bitfield: Add less-checking __FIELD_{GET,PREP}()
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>, Michael Turquette <mturquette@baylibre.com>, 
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
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, linux-clk@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, qat-linux@intel.com, 
	linux-gpio@vger.kernel.org, linux-aspeed@lists.ozlabs.org, 
	linux-iio@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andy,

On Thu, 6 Nov 2025 at 15:44, Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
> On Thu, Nov 06, 2025 at 02:34:00PM +0100, Geert Uytterhoeven wrote:
> > The BUILD_BUG_ON_MSG() check against "~0ull" works only with "unsigned
> > (long) long" _mask types.  For constant masks, that condition is usually
> > met, as GENMASK() yields an UL value.  The few places where the
> > constant mask is stored in an intermediate variable were fixed by
> > changing the variable type to u64 (see e.g. [1] and [2]).
> >
> > However, for non-constant masks, smaller unsigned types should be valid,
> > too, but currently lead to "result of comparison of constant
> > 18446744073709551615 with expression of type ... is always
> > false"-warnings with clang and W=1.
> >
> > Hence refactor the __BF_FIELD_CHECK() helper, and factor out
> > __FIELD_{GET,PREP}().  The later lack the single problematic check, but
> > are otherwise identical to FIELD_{GET,PREP}(), and are intended to be
> > used in the fully non-const variants later.
> >
> > [1] commit 5c667d5a5a3ec166 ("clk: sp7021: Adjust width of _m in
> >     HWM_FIELD_PREP()")
> > [2] commit cfd6fb45cfaf46fa ("crypto: ccree - avoid out-of-range
> >     warnings from clang")
>
> Also can be made as
>
> Link: https://git.kernel.org/torvalds/c/5c667d5a5a3ec166 [1]

Nooooh... torvalds might click on it, and complain ;-)

> > +     BUILD_BUG_ON_MSG(__bf_cast_unsigned(mask, mask) >               \
> > +                      __bf_cast_unsigned(reg, ~0ull),                \
> > +                      pfx "type of reg too small for mask")
>
> Perhaps we may convert this (and others?) to static_assert():s at some point?

Nick tried that before, without success:
https://lore.kernel.org/all/CAKwvOdm_prtk1UQNJQGidZm44Lk582S3p=of0y46+rVjnSgXJg@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

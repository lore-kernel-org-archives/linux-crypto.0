Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178932ED4E
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698949; cv=none; b=aUPKfRnfO1UcXsKmgBOmpPRH9eFAI3WsRZG0xyehGOpmy7sizTvdzt3Ia9j6rP2/FH/qBIPup7B9noZD9HuWHlx9OU6qNOSjhbgaEd280Gb3FgklEUxlmQU+sjudI6BwCWFIT1wprAVlPTBIfIkjP0cIThJFQSX86VpAzbwNcpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698949; c=relaxed/simple;
	bh=7roeWK5AtO/7ZwDK0dlN3Uu9wiMocaa5toCTUlYqJaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mM3ANKyBxH2C8guyKaAl9djuq2p1gvwsCi8IOWWQOTSdvYn0yo7yn6MSCo26aVZ2RnMjKMb6YV7PXMVKrMNAtUTiUW7i4EH5SMNPACBXHBBcZ+JDOVUuYVNeyarsSmEpeKvrJ5arg5Mk+TdBFOZtBnWcHEt71AsGnNJix10iC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7930132f59aso2477447b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 04:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760698947; x=1761303747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPE9WHNZsdRI3QmdRcH/wWeYzKksV+R5Ry8aWltKbjU=;
        b=KT5ugBkqALmCLxMyPk1JoULYjZCwb32zQpJGwPzeUg4DDiB9vL6Hvj4hpMpcOccPOq
         jXedyW9jaIjFTKCFHsaSuRnb+vylVlYJFxxa7TR3XSC0cX0w1uRZVLQ1wrZZcsqHGEU9
         AYEWs06SOEst5nY1p34bAUFIRgyHDsAIJvhHYxZLJ5ulUFBokr+g/71xNW6lC5e7r8CF
         EHlwJShIVzcI0GE9A9GnF3h/b4uNvAleQ/1OHzy1l79vZ9wcuI9bPoP1NAQ+0uTgLOov
         b9LOVar/helrUyBMfFJGIQedLmmhhW0kUh9/ytOjssHrSDyjHSr+al758z6+fFdFOPVB
         Hxvw==
X-Forwarded-Encrypted: i=1; AJvYcCUTcQF0O825sNQgSUyCe503cLMa/MLRP/AxZZmdM6rZ1f2Zgsw6kO/v8C9+KpXr/hJcX7e88uKq+ziEPUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YySsvi0OtRj7ObkxLCqAVB/SVKxNvgb9ikjC76YR3ttYFsqchZy
	o0pSxawak4226qU9d2vjykGPcOvG14WE+R0r9elG55GoWi7XstsfS2ZIWf1MjOm9
X-Gm-Gg: ASbGncsEyIge6oi5U9in9VB81XnmtSm9IIMy5F6W6keTk6lLhR4x2DXXz8SOu+vO6rw
	bEZQAE6KFTU+DgTb1XYIT+EibUKZ720C+8qrrzf5PsgS80uy/YM1clwFCWOnAMM0F2o9qXwcAnc
	Z7HiPo8bTYZP0JzRMdb/K0wTKSx94SpH7DsIdy+HpmQ3/eMB7c9aGcmH6fewnv/KSbDBqvFbipX
	XcZqF7dCkUHc7Io9uJ4dQ5qj1yTcG+nzbvYTFo4G8KqYlf3hkp0wM9Sovz2xJNSOFxUoI305xDy
	EmGiECPtKFhKPZWToJek4ZMbLlLy0PS/po8bGI5ZEJAQxu7/t/rr4yQ2O6S44nX7CnLQ+WmhjVi
	MP0lMi8URQvIFSjvm6P51efItfd+UVvVQn49wAmyxLhC4UdYvuE3KphcDgAKGDN+ZSGgJrSyfI4
	Mz6laGWOvJlyUTd0gpcU2Hmm9OkEGuwtjL6yCJn0H/9DKAEUckQkv/
X-Google-Smtp-Source: AGHT+IH1YcMZ+OFtdoh9Zj/bRflii2DR/MhFIFvaEBjkQJmSpglVpOtSexRT9Wya/RYRVC+LpSddyA==
X-Received: by 2002:a05:6a00:4652:b0:77f:11bd:749a with SMTP id d2e1a72fcca58-7a220d2330amr3343443b3a.20.1760698947339;
        Fri, 17 Oct 2025 04:02:27 -0700 (PDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com. [209.85.210.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d09671asm25520325b3a.47.2025.10.17.04.02.26
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 04:02:27 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7930132f59aso2477405b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 04:02:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU6p/Ro5ozIAB81Z5pgY0Q0JqzskscOJ1Q5jFAS9+VkeWa1CtJkUARwdzh2mqogGWt1ypwMSCgvf12bYtc=@vger.kernel.org
X-Received: by 2002:a05:6102:5111:b0:5d5:f766:333e with SMTP id
 ada2fe7eead31-5d7dd5934demr1126362137.15.1760698513447; Fri, 17 Oct 2025
 03:55:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739540679.git.geert+renesas@glider.be> <2d30e5ffe70ce35f952b7d497d2959391fbf0580.1739540679.git.geert+renesas@glider.be>
 <20250214073402.0129e259@kernel.org> <20250214164614.29bbc620@pumpkin>
In-Reply-To: <20250214164614.29bbc620@pumpkin>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 17 Oct 2025 12:55:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXost7vL5uTocMGtrqhEk5AY3QUWvyP5w7_hBtf3MkMfA@mail.gmail.com>
X-Gm-Features: AS18NWAcP6voBjoIoEi-7RxJ0pdmzXqhfe5FdHBNP60R0y-DyUBofdEL44euygw
Message-ID: <CAMuHMdXost7vL5uTocMGtrqhEk5AY3QUWvyP5w7_hBtf3MkMfA@mail.gmail.com>
Subject: Re: [PATCH treewide v3 2/4] bitfield: Add non-constant
 field_{prep,get}() helpers
To: David Laight <david.laight.linux@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
	Shan-Chun Hung <schung@nuvoton.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alex Elder <elder@ieee.org>, 
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>, linux-clk@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, qat-linux@intel.com, linux-gpio@vger.kernel.org, 
	linux-aspeed@lists.ozlabs.org, linux-iio@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Fri, 14 Feb 2025 at 17:46, David Laight <david.laight.linux@gmail.com> wrote:
> On Fri, 14 Feb 2025 07:34:02 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 14 Feb 2025 14:55:51 +0100 Geert Uytterhoeven wrote:
> > > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > > constants.  However, it is very common to prepare or extract bitfield
> > > elements where the bitfield mask is not a compile-time constant.
> > >
> > > To avoid this limitation, the AT91 clock driver and several other
> > > drivers already have their own non-const field_{prep,get}() macros.
> > > Make them available for general use by consolidating them in
> > > <linux/bitfield.h>, and improve them slightly:
> > >   1. Avoid evaluating macro parameters more than once,
> > >   2. Replace "ffs() - 1" by "__ffs()",
> > >   3. Support 64-bit use on 32-bit architectures.
> > >
> > > This is deliberately not merged into the existing FIELD_{GET,PREP}()
> > > macros, as people expressed the desire to keep stricter variants for
> > > increased safety, or for performance critical paths.
> >
> > I really really think that people should just use the static inline
> > helpers if the field is not constant. And we should do something like
> > below so that people can actually find them.
>
> Especially since you really don't want to be calling ffs() on variables.

It is not that bad, as most temporary architectures have an instruction
for that.

> Much better to have saved the low bit and field width/mask.

While that would allow some space saving (only 10 or 12 bits needed to
store low + width), gcc would generate quite some code to create the
mask (even on PowerPC, where I expected a single instruction would
do ;-).


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

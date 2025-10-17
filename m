Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFA25A34F
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 16:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717332; cv=none; b=cJvVs2iWl4pmfbWhPsnOfxZ6LPED3cTSDPYZ22yA3ohbtfE9N5RDZKlTV6ykGICpx9KNVAhFqWtx2cjKBFO+WtaJNL5GzTw05Q5dnqiM2qaVm53fx0/7J7aMGYPOM0m99+35BVBjR/RT7Tr94kS0Gio1Dq+Eh3f3gwr8KajZb0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717332; c=relaxed/simple;
	bh=5UuF/HjwkQMRQp3toEpBUcYrHBj825aq+Tc6Itk11zY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KSak0vUNNcNtHBC+QlJG0Cvs9hCb5kxyU0Zu/26dvqB88a7GIhO7Kv7/atgbN3ncHZHtQjf4cJQ744DQFViCDviXFGW2XXXRyHKou4SKkiBlReZciY0BkfeU8hfqQso37k8HlYc3G3EC2fwIsmFlApO2y25dUx8wIVZS1JR/Q50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-651d30a5bebso42925eaf.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 09:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717328; x=1761322128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D4mf9FdrvOGmLornKgNki0gXD9BcM6SCmzEl3gfV4Zs=;
        b=pB9jMqQSMvzShDJmLYbhph5swd1uZ1F8SHOqBDRfQIUtgY1P09InbPRP7phiazpnd/
         YuaSpzUMsEG92xGmSp+pL1JzkOp7Eh3Z35qYCJb49V2XNbDzyL06I1xttL1RRsEXyIq0
         NgAo/IfyAvoU4sR3m/5r8xOi7pgSoU5kAYWyQQjw4cXQ//WcGpfiSlNZfR1a2E5kq+cF
         63UZSLZefN740gb+tMP7u3CZZxtgw9WRRoDQ98LUTYgLGV5s2e1U7ADojF2Ij21m1Fup
         jYEaZjyPNUSnwJNi3q7ft4gfLLS9nU00LyUY+eRVbLtxUh1oqfHJRxG5KGZydIlymmHV
         gBgg==
X-Forwarded-Encrypted: i=1; AJvYcCXoTEQPTnCrSMcEUnq7eG74V8NXwoflMsBwBH7t6R9pBotytcWIUQWito+vtCDlqRuRpnlFAUdTuWsltyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXGnFXsn1zN6obSqwhpIIqXycg9alSV6G4BH6d/ZwY3mHlMILI
	6IlpssBuM9b5W1eN7pU7bY1qb6lujIAKraCnOddMwM5LPVfA7xDcXGJWfjS7DGWn
X-Gm-Gg: ASbGnctpXiM4LD++kB1c2Sg+6LF0cWDcyMXM0HXkmUR7nj+KjO6rySTCRbAv0NzlKj1
	nGJG1xWVH3G1+U6UclkGIkB00ZYZUd9/oWJlzuPZhj156beZ88y3NoE8vrb6LLVV9Gz9t6Hq3nM
	RJhG2BarGAcNd5oT43+8nluVQr+SsVWTr1dqRFsNBKap0cWJUBDpjZ4KH5uBjQx3LDuUs2KM9wP
	RbJ5vEYC0OzL+iDbU9JnoN4+GrRtXZx9io8fz+2Y0kEvzcJhGDVLHQTZwK+xfaIgHS8A4agEhG2
	/HvvfhryO2p/AKvt4lA8RizYiHioCR7IgEesbdpuQgf7YOZkyfGzFqOletTRtyk/uXQVRm4QzYD
	0Cmib2QDJx0+zg9PsWSa4tdXKazg5RVtHQaMwjpHOFSaG13PwJSwbfapYFSFB2JpdcnyEgoXJAE
	J8x9EnFR3Rq9xYOa2LZ2MEJHtaoi7VDgiD8PXjQlBr6DWZzy//
X-Google-Smtp-Source: AGHT+IFAkPLJtDVNFU2UsY8InX8cqnk8c5o6DsV8gteRQotLFEBoG0iJjDoba321hHQBHToXmxsU6A==
X-Received: by 2002:a05:6820:4dec:b0:650:73:b922 with SMTP id 006d021491bc7-651c7e3bf62mr1831355eaf.6.1760717328476;
        Fri, 17 Oct 2025 09:08:48 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-651d3af185esm7103eaf.8.2025.10.17.09.08.47
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 09:08:47 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7bcfafec537so1568509a34.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 09:08:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUfgYpIWH2qnLa3GpgcUaXZSL9cDCzSxbqUtfDPBvWd71Gfj0nq/qVp3Z/rRUf32hYOn3CArg4Zo8Ebm2s=@vger.kernel.org
X-Received: by 2002:a05:6102:40c6:10b0:5d7:dec6:389a with SMTP id
 ada2fe7eead31-5d7dec64177mr1309355137.9.1760716852567; Fri, 17 Oct 2025
 09:00:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739540679.git.geert+renesas@glider.be> <2d30e5ffe70ce35f952b7d497d2959391fbf0580.1739540679.git.geert+renesas@glider.be>
 <20251017081912.2ad26705@kernel.org>
In-Reply-To: <20251017081912.2ad26705@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 17 Oct 2025 18:00:41 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVS5KmVkv_pmc+R-EXik-Z1_7nuiHM=vm1Cu8v91wmLBQ@mail.gmail.com>
X-Gm-Features: AS18NWD4CQztq7yi6j63q-9XtnW0otWo2wOw8z0_Fp7R-6z_qrlZWB5IqFYEbBg
Message-ID: <CAMuHMdVS5KmVkv_pmc+R-EXik-Z1_7nuiHM=vm1Cu8v91wmLBQ@mail.gmail.com>
Subject: Re: [PATCH treewide v3 2/4] bitfield: Add non-constant
 field_{prep,get}() helpers
To: Jakub Kicinski <kuba@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
	Shan-Chun Hung <schung@nuvoton.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alex Elder <elder@ieee.org>, 
	David Laight <david.laight.linux@gmail.com>, Vincent Mailhol <mailhol.vincent@wanadoo.fr>, 
	linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-renesas-soc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	qat-linux@intel.com, linux-gpio@vger.kernel.org, 
	linux-aspeed@lists.ozlabs.org, linux-iio@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Jakub,

On Fri, 17 Oct 2025 at 17:19, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 14 Feb 2025 14:55:51 +0100 Geert Uytterhoeven wrote:
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
>
> We already have helpers for this, please just don't know they exist :/
>
> The "const" version of the helpers are specifically defined to work
> on masks generated with BIT() and GENMASK(). If the mask is not
> constant we should expect it to have a well defined width.
>
> I strongly prefer that we do this instead and convert the users to
> the fixed-width version:
>
> ---->8----------------
>
> Subject: bitfield: open code the fixed-width non-const helpers so that people see them
>
> There is a number of useful helpers defined in bitfield.h but
> they are mostly invisible to the reader because they are all
> generated by macros. Open code the 32b versions (which are
> most commonly used) to give developers a chance to discover them.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks, but this is more or less the same code which you suggested
before [1], and to which I just replied[2] after looking at the
generated assembler output on various architectures.

> @@ -188,6 +193,81 @@ static __always_inline u64 field_mask(u64 field)
>         return field / field_multiplier(field);
>  }
>  #define field_max(field)       ((typeof(field))field_mask(field))
> +
> +/**
> + * u32_encode_bits() - prepare a u32 bitfield element (non-const)
> + * @v: value to put in the field
> + * @field: shifted mask defining the field's length and position
> + *
> + * Equivalent of FIELD_PREP() for u32, field does not have to be constant.
> + *
> + * Note that the helper is available for other field widths (generated below).
> + */
> +static __always_inline __u32 u32_encode_bits(u32 v, u32 field)
> +{
> +       if (__builtin_constant_p(v) && (v & ~field_mask(field)))
> +               __field_overflow();
> +       return ((v & field_mask(field)) * field_multiplier(field));

Unfortunately gcc emits actual divisions or __*div*() calls, and
multiplications in the non-constant case.

So I don't think this is suitable as-is.

> +}

[1] https://lore.kernel.org/all/20250214073402.0129e259@kernel.org
[2] https://lore.kernel.org/all/CAMuHMdU+0HGG22FbO3wNmXtbUm9RhTopYrGghF6UrkFu-iww2A@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

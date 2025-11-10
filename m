Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF92F39BF
	for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762765190; cv=none; b=RmWruaGZPAivZMsUzUP50CJ2aH5yL+I5d1JYL+Ru6UsEvMRVVvjic7W6pHSgz2xZBlTHKnnYoiomvEmehoWoKNmt/sgOHgzRMXfmI4Z23VP3tu9QAV0r5pKll15C7ZyZz1qx9W53v/+sGh/ka/RmPSWLLFkVZMXRuzy8tjuv7UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762765190; c=relaxed/simple;
	bh=JRmjklDdMnXYPa/YzcCMj4xR0iBgS1Ed7pmHd076aaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eFuxdM9WW2JhVBwcGf8ZY/BKeiFnDvqLK1STa6hsQb1wAbxdsuJ+KVVvqHzGKT5nD/PwRmqcimgHhBWVYMuYolWYVIjdV8nQilgKjS7Z63yChkhWM10AsHA4PBhjHo+YyYMyLdkaKRSu22m3k7ArEkmmyhzvSpg4wvCOHxjTw58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-55999cc2a87so340653e0c.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 00:59:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762765188; x=1763369988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuaR1c68u39/qbD5w07qCJ9IxeheIz5/8CL8hB/l6OE=;
        b=GmJ8zMu8fEvf0Dnj3T5si4545ho4/xeKy/Z4bnHRvi6pDqADxCLqZk7fZnsKORSiyZ
         6RHCkj86iWloeHu0Fs6cU74yrBV8PiNH8r1Ik2VHVow5PVE23EtPjOTZFZ1yGNlEKJJP
         ZaiMjec1JbGosaZXsnAoob/KqCpiTcVf+idC5M/U6ZnET4mnF/IUhZ3fESUAIx/tahqE
         rljffZqDfIbAA2UVeN0Riw2XVgCSNlVCEf9k76/q+soO7deAJa1tYoB135oxKTXWzMWo
         ry+aRiZyr+FkGb9Yny7hueTsmYvyl57ebYqOyMShtt8bQxzH0953ZHXD6RN6jg8EBGCU
         zaKA==
X-Forwarded-Encrypted: i=1; AJvYcCU7hoNiai1zVCXd8KFmzJ9d1S+OEPPYVnltC+wK2ZKnd1W7fjg/iMZSNCqWQSNJdxeTGSyKwGNbbZsBchk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhS5Hr8Pn/8GTsEKy8HhPhWwn0/uF93x5MeqpxnpfQGCcRo+IX
	06jsQuyDcoqhPu9UGIicgaKzcbCdvc2XIebYWo9Zy3QEmO2exhT9Q0Ue7u5fm3rC
X-Gm-Gg: ASbGncsOJWvxZLrKUBkT6nujFQz74FRGP7C+LKgIQmQpQ/DPqUoDnJ4Ak2QySB8Aide
	MhPtt6/YBxo+fs/+8a/mLN7q/xYwRD1OhFNRc48HcqGunF6+x1wBQ177zSI/PGY5Dq/pMKw4dRM
	33QJQCyuwIiXlf4+uExXNrojRNCUphxruKXMyxwjxO3I0KaZF86WlxOsjDTy6f2wcmlLVqjYEwd
	CkmyW23nFlffQ43MHLkXToG67PceviPm2vsZa3zpPauJAJUTe/5SP+evNNqgRKreUHFvfY3fuwf
	HHDce0IjtlOWRyHMThHVhF5ZDLED1fNCfPqTEe7DNj9Cpk2tiaB1gLC5E35ybMliIS+m1NwGujj
	uFpiEHYqQ71xgBlPcf/q+fZXFp8ikmrDol5DYGdcrkcsHbjQCFOSKv7JOTtxXhMQyjx/LvGZpXs
	jrvK9r1oZp2K/f4lmIvI474phCKQWOByARG8T9an606q+NbFaESxHG
X-Google-Smtp-Source: AGHT+IEBXM/xTHFOeHr1BecB5IthKiaExqAc1uMPx5ZmzgMgx5IFJlrW5mLeJ7wcCD5+TLSlejGRdg==
X-Received: by 2002:a05:6122:4687:b0:559:6e78:a43a with SMTP id 71dfb90a1353d-559b328ca8fmr2226248e0c.9.1762765187749;
        Mon, 10 Nov 2025 00:59:47 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5599582860asm7179669e0c.16.2025.11.10.00.59.45
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 00:59:46 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5db2d2030bbso715169137.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Nov 2025 00:59:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVh62lviFNFJRT9u16PBfhyFVcFCsdyZnFK7yazJhWvBZyEVaDEaPQspINXBvunaU+dJYpA9OfBSML45cA=@vger.kernel.org
X-Received: by 2002:a05:6102:950:b0:5db:fb4c:3a89 with SMTP id
 ada2fe7eead31-5ddc471358fmr2304047137.19.1762765185596; Mon, 10 Nov 2025
 00:59:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <97549838f28a1bb7861cfb42ee687f832942b13a.1761588465.git.geert+renesas@glider.be>
 <20251102104326.0f1db96a@jic23-huawei> <CAMuHMdUkm2hxSW1yeKn8kZkSrosr8V-QTrHKSMkY2CPJ8UH_BQ@mail.gmail.com>
 <20251109125956.106c9a1a@jic23-huawei>
In-Reply-To: <20251109125956.106c9a1a@jic23-huawei>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 10 Nov 2025 09:59:34 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX8c1VkBuPDpJ5mpCcRH+zEX4F1bQKFf_V8N9ZZtCYqxA@mail.gmail.com>
X-Gm-Features: AWmQ_bmD7LCstBufqr7pTwqKUhf3WnheTdaFZy-l1C13xKAmQ3xomq2Nqy5MxZo
Message-ID: <CAMuHMdX8c1VkBuPDpJ5mpCcRH+zEX4F1bQKFf_V8N9ZZtCYqxA@mail.gmail.com>
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

On Sun, 9 Nov 2025 at 14:01, Jonathan Cameron <jic23@kernel.org> wrote:
> On Mon, 3 Nov 2025 11:09:36 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, 2 Nov 2025 at 11:43, Jonathan Cameron <jic23@kernel.org> wrote:
> > > On Mon, 27 Oct 2025 19:41:44 +0100
> > > Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> > >
> > > > Prepare for the advent of globally available common field_get() and
> > > > field_prep() macros by undefining the symbols before defining local
> > > > variants.  This prevents redefinition warnings from the C preprocessor
> > > > when introducing the common macros later.
> > > >
> > > > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > >
> > > So this is going to make a mess of merging your series given this is
> > > queued up for next merge window.
> > >
> > > I can pick this one up perhaps and we loop back to the replacement of
> > > these in a future patch?  Or perhaps go instead with a rename
> > > of these two which is probably nicer in the intermediate state than
> > > undefs.
> >
> > Renaming would mean a lot of churn.
> > Just picking up the #undef patch should be simple and safe? The
> > removal of the underf and redef can be done in the next cycle.
> > Thanks!
>
> Only 1 call of each of these in the driver, so churn is small either way.
>
> To avoid a bisection problem if your tree merges first I need to modify
> this stuff in the original patch or leave it for Linus to deal with as
> a merge conflict resolution which is mess I'd rather do without.

If you add the #undef, there won't be any bisection problem?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

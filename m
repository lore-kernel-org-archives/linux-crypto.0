Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1A82C11EB
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748892; cv=none; b=Gc7ZmJ9gWEWP6GoAhQ8aqh1VAvjfuVzwgzSjljGOE9G2zFvdllTQHoJ3HRHk5mpxEBiZOxNljZY3Z8xnOBOBuhCjX0XZU2jMvmQ7XgokSLGvt+XgnBBnlD7mocWVfCoh2OmFWHjjmYR1vDH5CduD30LkRT5UghXIZ4YZJfp6oVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748892; c=relaxed/simple;
	bh=FbqavNtq8VJC+dwAXLJIaCG9l+pt4WVO7NOuPi3OYaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mZKu6DlpYZz2LqE8JmNvT2m8ERMyUN+2t/p00yPzJZY3yU1f+u7eqhu8vk1s3EOh5JJE9Hsijf1neHJ2u7ZJkGK0+QmZdTQRDxJDPZyxiZPe2n0HLz4keAzseKqx9S2WLW4lvsa9bUc8haByiaPl+eYSuPJzJ0iQevy+/B9gZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-89ec7919c71so547524885a.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748890; x=1762353690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNDkhDDabcFgtYSzLRibzijDMaquJ035sDb5A+sIiAE=;
        b=AsAQbHhRpw4S46jGhwVmtMHHytHG4DQEHd+51o1wtBqwQg+fs5YWvBjwu3KHVPf9RR
         83xzIqJ9+88tC6Kdbdb5x8cJWkDpnL5RsaOJFXD8H0CcLM9OiTn3rl3/HsDR/1va7WaG
         vYjeeyPECsA32ProbCK79qxRsz9bsVRBK4R4fap0//QyObgmq2wOuQo8vsUhc2a0rU4v
         1V8KzN6K6mvWfT+909QWmicDFgThiubv2fdrHzDAOyq0yS2AG/UVaSU2ybvsbjssgzn0
         CcfYysZpXVZ4C88CdIOhrGg62jzgCuMUUyemtk1cK73pTnvIDxj+Yavhl2wBbzXn38cX
         jaqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNbh80QTDU23lHNn4GxIo18aX415LbM906q3gF7eEHxUq8UNgzdrztT0aFFFvPXtCm1kzFLh6n6v8mSxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSpvCLNwyqQovdAEi+4Ro/tULwaC3gj0ML8GMRzeeuHG8YQRMd
	HPVw8IapZUfAdX6FF/QiuxW7JV4r73wuo2x+Q6FRDzRXAYVh5w8edlY5MEYqQdcP
X-Gm-Gg: ASbGnctji/Q3PN5uWCXNATPDPFPKc1EkBSOePg017O1HrZGKX0moVCw+HvU151w3iFs
	X5A5k9FM0eNOTY4gOtf/rmeUewrJvGpMOKI3lFaVo1tiPCoT8aEHe2FnITw0RifoS1X0r++JLv6
	/ppjXs5ULcvn5vgolo6rTzFJQS/LoCrC0eGm5vOmN3ebhRG06Se5cBDmCfsYAob/uOkqqiwEXei
	zlASQw5DwlwALlsZbj66sJ4dWFaWB2kZtCbJ5VEXNZsQlgoaAOqraUDkJQWc3FpJ2pmXjsZarqi
	Suemx9oy0aYhuWm68xrZ7AuFs2g0PhOtiizlzx1L9/QkdVZFB1gPittGknTQa7xu0ZNy10D81tP
	JVr6ryw2IgZ4qnRd1oHFZs25nHTk+sf2HdxGbZYJ+W0f0Ei3FwzSX3oWVCtrmSvMHIEKNZ8UNC1
	+pux8P1smlpddwiHnds3kmeXxzJjmFGhb6WDBoVsNeXmHz2RX8PCcUHz40
X-Google-Smtp-Source: AGHT+IH6KOf9X/uHKjAGPRKHr5pzTtKjZ8rJQn0q5ULSOmfX9X3cREHhnwi886oOtsRlP5n8Gm4iMw==
X-Received: by 2002:a05:620a:19a0:b0:84a:907e:50ed with SMTP id af79cd13be357-8a8e52e36d9mr369029585a.47.1761748889746;
        Wed, 29 Oct 2025 07:41:29 -0700 (PDT)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25c8b849sm1056249885a.46.2025.10.29.07.41.29
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 07:41:29 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ecef02647eso34071301cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:41:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVBrplYiYep4uRqs9+Zj0/z4KGQf2M2XDLTJrGxsN979BjIe8BFwhwdo0uZm2qk7byJ39Q8QWlKB3K0ehM=@vger.kernel.org
X-Received: by 2002:a05:6102:26d3:b0:5d6:156f:fedb with SMTP id
 ada2fe7eead31-5db90694687mr933346137.36.1761748440676; Wed, 29 Oct 2025
 07:34:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
 <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com> <aQIlB8KLhVuSqQvt@yury>
In-Reply-To: <aQIlB8KLhVuSqQvt@yury>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 29 Oct 2025 15:33:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUTR2VnQ++j_ccUN3-GzKmSzS3H3QNyYqZNacfOBXD50Q@mail.gmail.com>
X-Gm-Features: AWmQ_blqiXGJheNiHtKi_cJSwq0gfFP8sAonrx_tsjN_f5pUMr0aiWqvAOsiPck
Message-ID: <CAMuHMdUTR2VnQ++j_ccUN3-GzKmSzS3H3QNyYqZNacfOBXD50Q@mail.gmail.com>
Subject: Re: [PATCH v5 07/23] pinctrl: ma35: #undef field_{get,prep}() before
 local definition
To: Yury Norov <yury.norov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
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
Content-Transfer-Encoding: quoted-printable

Hi Yury,

On Wed, 29 Oct 2025 at 15:30, Yury Norov <yury.norov@gmail.com> wrote:
> On Wed, Oct 29, 2025 at 03:19:45PM +0100, Linus Walleij wrote:
> > On Mon, Oct 27, 2025 at 7:43=E2=80=AFPM Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > Prepare for the advent of globally available common field_get() and
> > > field_prep() macros by undefining the symbols before defining local
> > > variants.  This prevents redefinition warnings from the C preprocesso=
r
> > > when introducing the common macros later.
> > >
> > > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Do you want me to just merge this patch to the pinctrl tree or do
> > you have other plans?
>
> There's a couple nits from Andy, and also a clang W=3D1 warning to
> address. So I think, v6 is needed.

Indeed....

> But overlall, the series is OK, and I'd like to take it in bitmaps
> branch as it's more related to bits rather than a particular
> subsystem.

OK, fine for me (if I can still get an immutable branch ;-)

Note that as of today there are two more to fix in next:
commit d21b4338159ff7d7 ("mtd: rawnand: sunxi: introduce ecc_mode_mask
in sunxi_nfc_caps") in next-20251029
commit 6fc2619af1eb6f59 ("mtd: rawnand: sunxi: rework pattern found
registers") in next-20251029

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

Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55142253F3A
	for <linux-crypto@vger.kernel.org>; Sun,  2 Nov 2025 23:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762125305; cv=none; b=eJGgwyvJEOs6zutO/4P3RE4ST7UHup8RhpZFZkh0ex7tFVpg5bsiMGoePsMYT/8nyei3kRjcm2m3LgUu7IG3kdCtwmBTYqPvk56ul1ylYnTFH6p3zd5I2eiCVV00Yr4Y6FJb6vKgE/EzIy4HJvBr0hK2kfk/yhdO0UPvZTnUHjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762125305; c=relaxed/simple;
	bh=gJ+z+fSwzGRoLTASac48Xt/red+jojCgmvvYT9GdSRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aMj4yVYc/aNJaJFt+YDRHDDkNAGQ5JVlHfb+0L1GstD+4Lt6NA1EF8+3cufyi0XXKfHxuXYaLlTjaS9iuMxhUwCwnWWLBbXqux5vFfQoiPC5heLfjKgj5KexFxriBUt+FMyL6A3a+xqTFtGFYYIwE/GPwsE36Jvk/M/9I9hMbZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=veGqDOkc; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="veGqDOkc"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-378e8d10494so38645991fa.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Nov 2025 15:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762125301; x=1762730101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhefXJf25nlZX433BsR2ypBCZ8ChrLrkfTMoigu+ucU=;
        b=veGqDOkc2KbhhYjsZ6lnbXmmedGeZoZMglsu3m9z2Ag0Z0bdrOYId3GZuEWhYWx0wI
         QEl0Q9LXRGXaHhR55y8x6ETnqRedFkOF1K1RR49+BaYHgSdEqcTfNCnEhQt7o6Je59Cf
         KVvfDY/Kk/QDbmSmB9l2fTmu3WGrWtGh5AOzwj9esPRfhpfNIkiz3MlTjJg+M+N/ndpa
         geV2axmVI2rxVLB6HmhRYF8WTJ7KIFl1p7BcApKDg8NPbtSvw53jfFdBap4gPtbQ0+Hb
         QYdytI+Gj6ya4I1KUy/71GBHTtwcAGNq9roNc6o/vDW32qf0M8U5G9RKh2EfePP2Cxni
         qfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762125301; x=1762730101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhefXJf25nlZX433BsR2ypBCZ8ChrLrkfTMoigu+ucU=;
        b=NOwGWSoDW5jOVICzsrsoT2PRlbNwCl0HY6T1mrsCuoNX/Wsm99XoQGP6sRHPA+PpcA
         SrqNmHcbIcDgalQte16xLrg99A9WyFjtg0XVyIGJrF/NEPpZSc9+432uhMhcPDnWgKwp
         uXlRdivbJqpV/lGVzjLinyfoCTDcyY7zJHofrZEZQcJzH0HxfbOVHiTccKXMWIs7BbCL
         IBgayWSq7q8BhryMUx+ERF8DqoxHYW7qLn+PI6F3s/ea1vX3fuH5uv3cTJQj7nWbdacn
         aUOWkKnjZKlzG+VkixNMisH59TTzuv4z8vS/pxTbFd8tPx9SNZKft68rj/w+2p/qQ7kV
         IPHA==
X-Forwarded-Encrypted: i=1; AJvYcCVpkBcASOvZKRRXCDp01J1iooTN3HRO93RFe48SbT2T4stFJ0XXls0MFn1/ud6kneoyiPPQtK0Un3LL04k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP0YDtSfJJWoq7B3ulbXciawRqk+0Dssn29pEDnVKj0CvxHj1G
	thY6furXykkzlNBVCw7jbN9JyxRVm5IbevqUEA5XbU2t8aZvS+FFXicGyh+PrtCq/kXcHP2LO3O
	A8wS+P6NcpW8fZFJWUlJ9PT77py2Ifz0yZOnh7V36sw==
X-Gm-Gg: ASbGncse6qDmdtkkTe6W5GomV454agbvtiEN3or9DZCoi+jhZJjIu0QIkSmTFiXXGlS
	kW4cDdU5vk61BBgm2iCQQOfOSzhojImlal7+abI+32b3iDKBmIRWJMo/ywdKO68eoQwbhZ4mUxu
	iEApiITrM5AePWSzAAi4kDWCkUfNk/XFk06dzHmbVK4Y/HlARBIJgb0J9LI306C9cSnLHf3PPAv
	BPKANd9SkqtSKfPJBqZNqSXZfLCPY6iRUZTmbSoB1pok+RsizvIA+cO4NKBA8946lZrS/REH2U/
	8yGf8A==
X-Google-Smtp-Source: AGHT+IHNOSftU4LA4kaZ2zit5fbsUjeer+Cqtnxd6HV9vMAwCSf0ZxvdazFj8kc8iFBA+Oyhy9hRt9pMH+krWfgjY8s=
X-Received: by 2002:a05:6512:1453:20b0:594:2646:2350 with SMTP id
 2adb3069b0e04-594264628f8mr1107502e87.21.1762125301355; Sun, 02 Nov 2025
 15:15:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
 <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com> <CAMuHMdWriu9eUHMSKcv7ojSqbquP3=z2oaquQZLx5nmN0EcGaA@mail.gmail.com>
In-Reply-To: <CAMuHMdWriu9eUHMSKcv7ojSqbquP3=z2oaquQZLx5nmN0EcGaA@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 3 Nov 2025 00:14:50 +0100
X-Gm-Features: AWmQ_bkG07aYa3yfLgn8mo--U0KGtThYfcOHYFtKUjSupbZy0y5m0bQWTypUrbs
Message-ID: <CACRpkdbR+5jh+OqYAU4vyUP-aQSjgMG3RRBkUTWnWz=VEy2Oew@mail.gmail.com>
Subject: Re: [PATCH v5 07/23] pinctrl: ma35: #undef field_{get,prep}() before
 local definition
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>, Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>, 
	Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>, 
	Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Jacky Huang <ychuang3@nuvoton.com>, 
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
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 3:59=E2=80=AFPM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> On Wed, 29 Oct 2025 at 15:20, Linus Walleij <linus.walleij@linaro.org> wr=
ote:
> > On Mon, Oct 27, 2025 at 7:43=E2=80=AFPM Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> >
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
> My plan (cfr. cover letter) was to take it myself, as this is a hard
> dependency for 11/23.

OK go ahead:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I see there are other review comments, I trust you will fix them up
and merge the result nicely.

Yours,
Linus Walleij

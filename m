Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA7925F98E
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 14:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761747602; cv=none; b=C3+FArjZrofXEdT3OjjSZsoyLP5DgXgEO9Plh4/5cDabL0aRkAk8/T9hhw61PDx9Qh1bzNGwjy0f+oju8L5XKsrtdhEGurUIyIfEJxOESxCcwZmnvhLw4UbJm9jsrCpr5wl/pKjag9f6M2jvtsGXnX8mGvDkgAlNxZCoqJfc6Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761747602; c=relaxed/simple;
	bh=1CX+8+kOSf10qsVFbiIqXKLPwxKNZKPK3M5tdY2U3zQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxQvePdgj56XmLMOXowSyvlRbchtj6TU7gjEof6/ANRU8tAcz6Rxyx/OlWj6UVh8dqG9EQQ13gjYXITNowwk480qPK0E01agfdVn7awkWWSmAmLG2vSENoXwwiG/BhOqs/sugygGSiWiiPY0sBuF9eC5BIiZH1YRPRzp+MP5gy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=STdMHBQT; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="STdMHBQT"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-591ec7af7a1so7346540e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761747598; x=1762352398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOeCj7atBm+jp74qXquxytnJSCplsW/eyoN4u7SHchg=;
        b=STdMHBQT12yVVhenBH9kjtzktzfxhBOPKOo9apSlTLueZcsupwgg31te2NoZ1MYB8V
         MSCDsKHm3FOvPOU5eIBCDfHMdlRjXQ/WaIfGw7guwrNmTT3BzH6WS72IQ0rngTeIuIKG
         geIpbGtk9/KkbvqJ4ys0/EumZ1gCsCKUv+qxxEKzmywlju+PTnHhCdTYr2IGsTbcyPmT
         1dv7mnHne5W/9nCZuPRS5MOiokEytiREtrQcf4/hBmfAUMtMcLusUKfTMKcUvAn01g/8
         YYl2+QIB5DhWKuvrDaYdcUxOB+ZWEQK/1a4i5MEDu6ruYYw7g+OmbE5blhnTFS7GFVRk
         77Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747598; x=1762352398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOeCj7atBm+jp74qXquxytnJSCplsW/eyoN4u7SHchg=;
        b=Dlzv4vMf2z81dOI5x7ZIiell7ZHoxYYnZDRSd8fkoDafXB1hE/t75teXCTT54s3KYm
         BBTtXmJRceLYltILtTrg4ZgwlY6P7bE1yANRGjAXWzGy1ANkCyNvEdeht3heVfmMJGqi
         7cE1lf/5HHH7tqUqBtmxG08RzPaGHslTJCzk/RpGE7tDsovQm4/+mN7FcLZiIYCW0paC
         YTOBlnMA0zSdprdNHTL+NL0vU6fCDYvsCSx+lCtWje20fRdwNmCvOcc4o5lR66hz0zKT
         Hi5m6Jjb9GjKRk+XQEX+RNhDeI2iHnASej5QZkUrDjEqjMf5P52YftA9ilUOjnF5McvP
         Moyg==
X-Forwarded-Encrypted: i=1; AJvYcCXvtbc/FP2qCKK1uIB6rde7ixW0QjSLG3WIoSTbYWPbE2N5asT64okY3WPmLUo8YFYryf6WI9Go8fgQ4Dk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGZkB3LtSS858ToOB/KWcROBaeWPt5eTGmZCGxYRURhvzNzOXA
	Iz8pdcezhhkYam1Kiu6LG5wPHOJsfqY1ehLGi/MWrhAmPkR9nvMFOX4v7Go6upM/RyS1/c6/Vl/
	udk0WfuGUSz8h5yWlGptFvTzgQBmvixJ7GXotOlFw5w==
X-Gm-Gg: ASbGnctKvCRGiSVEjLuVIMAe/yoNr6zbryeN7BqPpj1dO+3QoJubdEoBsUCnvfnmuHG
	nOcBnGmogHJmJLuNfq4xkvxV1VsuQYcRbx9d5Vnu1Rn2qLu7Q+OFtGIsVgKGaQBqubq/TYlz5Hx
	1ddZjoh4DpDZglBBqg9Fiin68HoSs1PwBw0bRB3aBtD0EYqT0sbT2HMVQTHZ9ei/+f9AcGfBWLj
	VeRq/vF0NgTsJnk+sZ97ZyVER4jqUi7R8EeFwQ/5+RHBa1AFlSD8qIpE3hvJd8t5Chf3PLaBRXo
	GHIJvg==
X-Google-Smtp-Source: AGHT+IG59+bQUerf6uihfCFWCYSjQICr8Xo4ZbiwSS1E65/x2rl3ls+2t5ioYCJKzMBcQXa5Sk43LYjN69G8TJb8SWg=
X-Received: by 2002:a05:6512:3055:b0:592:fc68:5b9d with SMTP id
 2adb3069b0e04-594128623cfmr1174582e87.10.1761747597543; Wed, 29 Oct 2025
 07:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761588465.git.geert+renesas@glider.be> <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
In-Reply-To: <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 29 Oct 2025 15:19:45 +0100
X-Gm-Features: AWmQ_bk2MMp0FQz04qrj-8hmhOAMRkHeQZjiqCVvFpO75M_-67m5zTnOfqmkGUQ
Message-ID: <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com>
Subject: Re: [PATCH v5 07/23] pinctrl: ma35: #undef field_{get,prep}() before
 local definition
To: Geert Uytterhoeven <geert+renesas@glider.be>
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

Hi Geert,

thanks for your patch!

On Mon, Oct 27, 2025 at 7:43=E2=80=AFPM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> Prepare for the advent of globally available common field_get() and
> field_prep() macros by undefining the symbols before defining local
> variants.  This prevents redefinition warnings from the C preprocessor
> when introducing the common macros later.
>
> Suggested-by: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Do you want me to just merge this patch to the pinctrl tree or do
you have other plans?

Yours,
Linus Walleij

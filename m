Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9880C25229C
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748237; cv=none; b=ak6ubKQcRcOqslhm0IjcJlNyqs1iFG/FQq/8ejJhbT1TylNdHl8t1BRgQ7B2LxM054LH3VT63t4/gjJfCan0i9uM2TAX+u8zfPGAT7ZgeyI+QbIUuOuZjQ3eg8jBBJulxmccyfIk7sS6nfxt7GEe35wxHvNlIaNiGtB/v16HY2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748237; c=relaxed/simple;
	bh=7qSqb+8qhf4bmtYpSevPKgH9NpBXdJ7Y+QlL0CxIedM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfvhfMv1HRAgeJH11uCJGDPTxhyb6Qk2FdUs/OBgHfdX8w13rA7AZjFiLz8hgTgxpjrgJZZP1LC+Ji5vhHMTglHgQ518JDojivcxBVuZ/rN9txf7PThT1KuKYBuaVtJ8vuA2canfVrlsXsAAUKJgskyhkrrAByrujAVmTd07XjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVwISxo1; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVwISxo1"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ecee8ce926so36901281cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761748233; x=1762353033; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JnpQqG3KsjO8HR5ITuKL9a0uCELInljqSPlsEDY9f3Y=;
        b=HVwISxo10QqmrSYJm8NEWiPwMQdAiacHa63OSUEAOSCJl5S1CA8h1XtfTBJ+HmBrua
         w0YVot9mWsIVPfNpcf5bUtJMJXLuR8HvqT4uo56qtjCKmLUSQiBatizK3mNSYFVNIqyT
         YawDnfkurMYiTvK7GaRIEg9H7V06d4KB0okYHxfQLUJ8A0wxiAMZLhq6yzxKrBJvE948
         ydDUTAKK8c26FesuIPJAp59RrcCTDy4fWxTiLBQNwkkz17hNB535tNRdNm6xv25uX473
         +duWPWlmevzjZB4BKgqyMhXV20EeZDWiiTFHXfrcKqcTmGlM9nxBaHBuIZ7w/752aBPM
         1Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748233; x=1762353033;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JnpQqG3KsjO8HR5ITuKL9a0uCELInljqSPlsEDY9f3Y=;
        b=wsg8LIRWurHc53r9JsMnJL17FOsz5gE/Rk9aiG1+X1gzGYmqGJzLy4stYesnT+Sbwj
         mmVfADyl0jYHYGH8GtiLEYfeBxGeoGyOQyh0Vh0S75mT7b7c26vMPFZq3Gk9lCi3QXah
         8mp5hLjcaF1jlyztnbzLxtDA3QOgwqiMVrERP/w+dOp0p3W4SolbD/jkQeVYMuItEPo8
         qXgZoYK4Zf9Q4y6pAJNcdzGLFPARj68zSz3cW+yXKmv9i48myZQRRgpqsIQVXfwTVvtm
         xWdGTC/pCdCIOBN02lM1QSYGj+rMCQsunfiyq30yAh1uXTOu0qPLqrxyfzaBovE+5yLl
         mT7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqwiJSySsPF6GuGEPjkP4G5cSxynRSE2t9sQyAKP6/5xzL443pXIc6tHYLDB6SV1G8s5z0u6x8GgKnp0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxso5Z3Cq/hqBFRMVrbMfRQBMxyg2lVluVH7v3YKIK1vpHY2KZs
	6qIyAjOlnxqzY4tyh8QFXQppnEaduaGh0M/07eBe5PTjVkqU1ysroP26
X-Gm-Gg: ASbGncs7Ljvd8AcPur7RSLh4IJzOZNEzJF9pQMD+H6v3trhXP/rG0PegmgSWavMxheQ
	t3/1GiTRg70yH4rGiaKbepOVnTO130hA2zJyLAI39VtHPlZdj+FyCqvFIL1GJNLp7lnnYOyxzG4
	FQBp0YilsCkqv2aN+rdFoXd/tiXeNT0yybCIJRWX430QPHxHQ0L3tPXdcBx6yJHdDrNNYMIDqG/
	A6tqh031OvE+RErTZyxWl37T1eyYdsHHHzY/QtErQgsTA9Ou/DHBLRG4r1quBhqBUDdmxMzI48Q
	qZfGEKCe9hXP/5CpvN0/tIkIbz0PMF+o1Kq7Uu6FRfhOC+0tj7tSbVvjdusjU5KMfqOOWCjfuNs
	0YPQ+T0nXVFi8jFVQcqful3jhOw0b0zLbrWhpa/GiRi0DVhJ3ucQiYznNpsNOAVbVJOViBQdS
X-Google-Smtp-Source: AGHT+IHd6ZEI/4efuxlvOLVTSJQH1JkXxxhkGirHmvwiRC9eDvjzIFKRpIZ05PrXMHCHH/Mrsnw0AA==
X-Received: by 2002:a05:622a:24a:b0:4e8:93fc:f8c9 with SMTP id d75a77b69052e-4ed15b53cd6mr36770551cf.15.1761748233098;
        Wed, 29 Oct 2025 07:30:33 -0700 (PDT)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc51e3809sm96571096d6.26.2025.10.29.07.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:30:32 -0700 (PDT)
Date: Wed, 29 Oct 2025 10:30:31 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Crt Mori <cmo@melexis.com>, Jonathan Cameron <jic23@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Jacky Huang <ychuang3@nuvoton.com>,
	Shan-Chun Hung <schung@nuvoton.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@ieee.org>,
	David Laight <david.laight.linux@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Kim Seer Paller <kimseer.paller@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Jianping Shen <Jianping.Shen@de.bosch.com>,
	linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-renesas-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-edac@vger.kernel.org, qat-linux@intel.com,
	linux-gpio@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
	linux-iio@vger.kernel.org, linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/23] pinctrl: ma35: #undef field_{get,prep}() before
 local definition
Message-ID: <aQIlB8KLhVuSqQvt@yury>
References: <cover.1761588465.git.geert+renesas@glider.be>
 <03a492c8af84a41e47b33c9a974559805d070d8d.1761588465.git.geert+renesas@glider.be>
 <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda6ykSZ0k9q4ChBW5NuPZvmjVjH2LPxyp3RB-=fJLBPFg@mail.gmail.com>

On Wed, Oct 29, 2025 at 03:19:45PM +0100, Linus Walleij wrote:
> Hi Geert,
> 
> thanks for your patch!
> 
> On Mon, Oct 27, 2025 at 7:43 PM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> 
> > Prepare for the advent of globally available common field_get() and
> > field_prep() macros by undefining the symbols before defining local
> > variants.  This prevents redefinition warnings from the C preprocessor
> > when introducing the common macros later.
> >
> > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Do you want me to just merge this patch to the pinctrl tree or do
> you have other plans?

There's a couple nits from Andy, and also a clang W=1 warning to
address. So I think, v6 is needed.

But overlall, the series is OK, and I'd like to take it in bitmaps
branch as it's more related to bits rather than a particular
subsystem.

Thanks,
Yury

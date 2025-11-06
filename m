Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58EE29B789
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762443632; cv=none; b=uxh+m8yTjx5eOmp03HBsQRCHo1I3gjpwfZdzh4vFC5oGfY0mxM8ij/SVqXEQKj32RhdbVGzySplqMvWLJWHKiadcaD9FBnEb5eFE4AnhodFHO8uFIJlLG0mlOI5EC5bzsCndjSMKFTRzaO08PAQbaXP7NPBCOaSIKvAAH0aY3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762443632; c=relaxed/simple;
	bh=bPYWoT/GHriiQOAtYqZ8RIEg/mdLe3X0Fy0Cau6Ehaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7PxAUIlEo2YjQUBkk8AqqiSXW12iN6t1wTReH0vOYtmg2X1yWgDSeFzZA+/CbOKAv1Hq1w1avLNlT/32XGMhRpBbwDL61YJTnWzXfv8EIFHeaIoIo8z+ENhOPFYEMCJz6QGVL1LfIuZnKvpPRzJ/VPhVAdo5Y3RaMEpZCxwVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=mtvz5v52; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="mtvz5v52"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47755a7652eso8467355e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 07:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1762443629; x=1763048429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1Wk3Zb6iHABuxMtqYWJQhotr9eHGE3DttWEmz8jd9g=;
        b=mtvz5v52aKC7EZ6exceptOGN/yR8gwoXsD6+ODVzB9kwg3a747NB7nAIIRkFLLuLQR
         XBcjKQN5CZNpKd1ZcguBqMiX2nSvC0Z1oG4hopafKH8vJx+eI4zGuJAJwrSH9ktm9bUP
         ef5TD6xf7LgbjHen8vXyrF1x4MZh1P2Rn6KmzqAaAkc2ej7h2JXr9LBezDKJBzCJWyb/
         kLk8+T9ZGQe0OQH6XEgJfMkwIarLnluWJZ4U2rBWJ/A9Cu8+7CHNuyhqwbPZS+Pgd3lb
         Lp2qBmseBwR7R4lAID9txgDYo+nALkyWLvigN2v5GkBKoQN4Y1Ocwb6z5ztpSHoMdW0J
         FBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762443629; x=1763048429;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1Wk3Zb6iHABuxMtqYWJQhotr9eHGE3DttWEmz8jd9g=;
        b=Z9+PKPFeobso28HNlv/qn62pDtHdILbWbjMZKYsNAUO3Lx7eHRVgCBsHf6yOXSY4lg
         J02xe1jlpItkBBUYdKmLm66MLD8dRZmHRy1GunkNEXaT4daZJuW1/IH/gFmkTI1o/Sub
         WTsojK2gG9hXXcS1aEZ5uif8EAaQEVCaxV0OXUwa2b/2LMVvTt+FKneHu7udN5+T1CAS
         g+4EMkSxzjVFv3IEQdnp88du2Y8ICEBDPLXxXsrBzr2oypiqQh/6Ca3Y4X6T/vyZFhOl
         jTzjFKeeWotwJpCtNMVdh5luZU6jmz3VinQy+mCy9WJShQQH3BEbBONSDBmlps9/287/
         cEFg==
X-Forwarded-Encrypted: i=1; AJvYcCU92bSMgpPPTMLosxBqt8AyK/jXbToRThHkJU2xux3DQtLCq7amTxpaXaYmniVNztFo8jtMVeDGTgURSl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzyHbvWJrtmxtkSuBI7Um1vuwR3xEZgoaU2dTrF92wxi0DiLeY
	ShsfmPB2S4CXoiHEPJnOnpyJyVTF612TnPjwVdv+rWBSjgKvsK4SEHLsnm2rQiCawcg=
X-Gm-Gg: ASbGncuVO44d4oOO1tDz9yUisQukd5bbG36uxQGFeVJhNW6JYmpiPz8DNjuMPjA1IGk
	6xR+OfEAhnAItL7t58KfhWHw4zCz3xU+X4m6Jba7h02G0FZG//1UeK0XJtb2sz0V3p60NV262Xv
	gAATlIBdppr3HgmSnFbKzi6ETynn2KRbHR/vEwy2S7lUsNTKtAV1/8/w+aPyEVZkM6hunXKgH3t
	xUKBFzcveJYSAtG23HMQTmXWOvAK9xJIZfazVkOIBQVvoV1pC3xXFaAAfqGNTk4Y+mLtzIWUseh
	UvDpZz7pSSI2bhTveH2bnybxuW6NvAUZFFIJ3GB3mO66LBywf2MCuKKWCbFdWBvjNHQ3piPuq04
	2r8FyQW6KToHxTq7DUkQlsKJn3JRHObyeRBYtDqg5ClZo9ytBafokWfB5RkrA3KZcW0VxKnkjmf
	ejNw556R14NAlKOvRjTrw=
X-Google-Smtp-Source: AGHT+IFjpy8Et4z+rAreshTApQ1UnG8la7y5eDtsFm4fqVoBZudQUf3WRA0jtYYTZf5YlVXK7dWKmw==
X-Received: by 2002:a5d:5d0c:0:b0:3f7:b7ac:f3d2 with SMTP id ffacd0b85a97d-429e3309cc9mr7040773f8f.43.1762443629298;
        Thu, 06 Nov 2025 07:40:29 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429ec767edasm5003126f8f.43.2025.11.06.07.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 07:40:28 -0800 (PST)
Message-ID: <e0c8b161-3e08-48a0-89ef-8e0ea8b76672@tuxon.dev>
Date: Thu, 6 Nov 2025 17:40:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/26] soc: renesas: rz-sysc: Convert to common
 field_get() helper
To: Geert Uytterhoeven <geert+renesas@glider.be>,
 Yury Norov <yury.norov@gmail.com>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, David Miller
 <davem@davemloft.net>, Linus Walleij <linus.walleij@linaro.org>,
 Bartosz Golaszewski <brgl@bgdev.pl>, Joel Stanley <joel@jms.id.au>,
 Andrew Jeffery <andrew@codeconstruct.com.au>, Crt Mori <cmo@melexis.com>,
 Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
 Jacky Huang <ychuang3@nuvoton.com>, Shan-Chun Hung <schung@nuvoton.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Johannes Berg <johannes@sipsolutions.net>, Jakub Kicinski <kuba@kernel.org>,
 Alex Elder <elder@ieee.org>, David Laight <david.laight.linux@gmail.com>,
 Vincent Mailhol <mailhol.vincent@wanadoo.fr>, Jason Baron
 <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
 Tony Luck <tony.luck@intel.com>,
 Michael Hennerich <Michael.Hennerich@analog.com>,
 Kim Seer Paller <kimseer.paller@analog.com>,
 David Lechner <dlechner@baylibre.com>, =?UTF-8?Q?Nuno_S=C3=A1?=
 <nuno.sa@analog.com>, Andy Shevchenko <andy@kernel.org>,
 Richard Genoud <richard.genoud@bootlin.com>,
 Cosmin Tanislav <demonsingur@gmail.com>,
 Biju Das <biju.das.jz@bp.renesas.com>,
 Jianping Shen <Jianping.Shen@de.bosch.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-renesas-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-edac@vger.kernel.org, qat-linux@intel.com, linux-gpio@vger.kernel.org,
 linux-aspeed@lists.ozlabs.org, linux-iio@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1762435376.git.geert+renesas@glider.be>
 <ed045ec4db284ca8b4ec0c5b6ff334e459d14096.1762435376.git.geert+renesas@glider.be>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <ed045ec4db284ca8b4ec0c5b6ff334e459d14096.1762435376.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/25 15:34, Geert Uytterhoeven wrote:
> Drop the driver-specific field_get() macro, in favor of the globally
> available variant from <linux/bitfield.h>.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

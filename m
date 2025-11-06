Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A1303CA8
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762443900; cv=none; b=Aov0loDftvVdibt/Kek8yiZU4ywH5c6Rp6xEC/RMQLTxE+mSkOUZMI/DgqdZaJhazdUqWzELCvMjnY8qUwg9kOx9GhuXRS5nk/O3OsTMZVNNtj7Otm0uOtxneAxnkLBKoUgQkBie+W+XgJmFAQ8YzADuwZ/B69Ylal3+4+7vaDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762443900; c=relaxed/simple;
	bh=ir86bNXUyXX52mY7hjK0YW1lIK6fPwyN3rKPVErB4Dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1FM7h2P1u1sc6+NIZk1rltcT+UdqxreUsIcEnU+Jc6xyHIPLX4hKP/8WxP+2Rwgt3S79APyAj9OyFvpQDrBVLXME2G7nTcskKAEJ28WJkjTJtTxNa2BIdKKQKHq9I5tc7iTcVraq4aKIYhue8ikl0gkLexYbEEZ2Sv7hBGPdEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=oyafMGVj; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="oyafMGVj"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4775ae77516so13327925e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 07:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1762443897; x=1763048697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FDBfIt+d555CHw458VAbNG3bfHQEwmpPFewi9LatYFE=;
        b=oyafMGVj8rfucZtwMDNT7+phmmyZ8dNEZOYEY9Q57QHqZJoyoIJ9OQJpzpssPwAAUY
         p1cucHLkqadoykScHTYiZZygeQ/2+y+X9FXBBrzheC8maMeT3KaSdcKzfJuIAtFiKMVD
         9bTv3YnG5FJcmpkd662vPds4xEsAH7Ni3IcYRWHdk2BAh9rtXwffQmy39LFYYprGFkbP
         NHwOTlJfQ9UI2vyII4ONRiqWKMGAT4G38zP5/ICf0lH6eDc/WqOChblx20cnzIVdMf/s
         +pkDF7X4DR5yijB/jniXDKERhHa0ItlV6wMuNhqGMXQxnO3rr/fg61KyjIC7zgKqc47F
         I4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762443897; x=1763048697;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDBfIt+d555CHw458VAbNG3bfHQEwmpPFewi9LatYFE=;
        b=i8DS/2CKq0RzDveICa5D7GMcGRGZqj1TF9Q22781Uv9JemW9hr+7L5ONYRchx4w5+G
         or8eOhlLzH4zy2PfSlLlxYeYGjTAi2n43H7liJ5qh0XHNnpMVv3MImf3pr9rFS2a4Lg9
         veKy71geAYbnvwUhzguP7b2CUcZgwxFssjJd3kq1DcyNdFZto3G4DC/DE5wE02Sr5Li+
         CZHbMvBxfR3jL9SSWjQas3XYR4DI5fvwNMNyQPkEl6xy39apC+uY5mCj4mQpn5AXpe5C
         CKEGQ6X7j3hL0o6K4x5njiFy8A/aJJWlvDtMQlTYlyCQk6HGX3Eza2gOBGaPznzNKmoQ
         NxAg==
X-Forwarded-Encrypted: i=1; AJvYcCVGn7UVOPOEMaOCqfwd7kTTFtepjBVlID7Ok+uL5Hm38bifnjOij9dJRr+AhvyIb+9i/ffG6CehrUfnQko=@vger.kernel.org
X-Gm-Message-State: AOJu0YzefWIquXw8N4BXLJiSK60bSpezjbgj6KDyhESarGWGkQ14OVHV
	4MjVvqHjUOkGhcPVAj6dV8lAJSRO5I6MAUIOlJ2Q7Utxi0TgoblDOehJPz/iMbw7m0w=
X-Gm-Gg: ASbGncvTEPH4sGxkfdSgh8WzlkOFnUqx7qUoXIF+ACT3sIqY+ANXc0lFOqv6oKalhcU
	lfMKBE0Ftx92KIdDi/I8xM0RZSkiU+7iDc86+V/fudCJAs2yirOWr7W6dHYPgucBf6OtIanz0ij
	cFudOgLHCrH/F4mFR8nt5E3xPILpsEyUn4YYJpEhgCEtibtd50ZmmZCY/Bto7qTq8PssGiXD+0c
	iDEka6lt1OFInu74dfbFgmLvuSkvto6yl3RsioHPj7/vpwgiU9/4tPt3V8zBDyEV/lYN2/JZG8F
	ZfEy5qoo5MYkQsD8oLxZbHg3NR1NDEBcECLQL7vgrKiyXgc2OvSp+9mYR6sJr6QyPm2I9tgUOzk
	QlX1Gb/E7yhfmweJby0YD3Esc11DasLk1TdwuDk3Crs83mf20cGBo6ND/HD3AVYIme6RdKymEdq
	r1d2yd6hNr
X-Google-Smtp-Source: AGHT+IEAc10N1RtkN4NVSk1Zu24SSpZFPG8gHp4xc27V6x28O5IWRTQBVQkr2p/iYh6QAS/I0T8A6w==
X-Received: by 2002:a05:6000:310a:b0:429:c8f6:5873 with SMTP id ffacd0b85a97d-429e32edf7bmr7715744f8f.22.1762443896966;
        Thu, 06 Nov 2025 07:44:56 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40375bsm5553906f8f.8.2025.11.06.07.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 07:44:56 -0800 (PST)
Message-ID: <509b427c-5586-4c92-88ad-16bbde7c3f92@tuxon.dev>
Date: Thu, 6 Nov 2025 17:44:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/26] clk: at91: Convert to common field_{get,prep}()
 helpers
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
 <7414c080bbacc3c5be00c0eec4f5cbca386acaf3.1762435376.git.geert+renesas@glider.be>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <7414c080bbacc3c5be00c0eec4f5cbca386acaf3.1762435376.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/25 15:34, Geert Uytterhoeven wrote:
> Drop the driver-specific field_get() and field_prep() macros, in favor
> of the globally available variants from <linux/bitfield.h>.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>


Acked-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

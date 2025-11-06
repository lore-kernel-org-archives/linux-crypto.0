Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083DF2848BB
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762443408; cv=none; b=EgxyQCp9vh1XEldmzRPBN3odlNwPNHa4cP6nfRA94hkyFpqPaQRaDDlwIEau6by3NzDDVfSJTjRZhGAuGdvpgPU4PCgZG1vD9GuODo6dAEed6cEU8hYkrvtrQLdpESlOMfr8LlQqKza8I+kzlHa8+DW1CtSewUMDXG9IFHtC16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762443408; c=relaxed/simple;
	bh=xk6l2WOOOp6czqXIg1WfykCAiMAdHCUw6VSHs/tqjfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X4V7btwnNz5oEKdDT4+mgBQqPhSfIB9qcLO5FDZwEsPUS4iLzrvry3VteNbm4p4GsLsrk1hXTUgN69qxgh0C0Fn5RZgc0SjHihIMpE/vdVCHybB3xdolO3F7mweDjqZyMx/iwgkwU5GFWUPRWWOzgy87Xv5OBIdRF9s2JwoA24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=RCBBHmI5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="RCBBHmI5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47114a40161so11363125e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 07:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1762443404; x=1763048204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NoiFfWZaW31Ma9mD3WuZZQSDOEMD5VY8nTTYH6Ca1fs=;
        b=RCBBHmI5NJuL/b0QMZqwJKF7ud8TA4ryMo59VDUQpnay3XsUAvEHe9LO/fOzuRpsZT
         Jx1NFanVf4S6AnMyYzJCnljlJyN6jxlel+V/rblI5B/Ke6DaEPf+ndUzWrqDMCP+HdnB
         uDl16AbXtCY5QarJXQGxMW4weytJLsYo/hhgWgTWp6oEXUmaIM9yVLpkAXqAknXGbXx1
         QuqO79EbjR+FpS9ROH8ywiCYKLR1Vo0TveRfPl4UAmhu6xulcIFSO5a0/1OJf0Rjev67
         yegxuQY82ZCP4p/4NvCgTDGdk/lzzVLD1htvb51kbSpM+eaB4whicLPwz/DWF4glUFn4
         0IHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762443404; x=1763048204;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NoiFfWZaW31Ma9mD3WuZZQSDOEMD5VY8nTTYH6Ca1fs=;
        b=eaXHt/DtwKRGiR9uw4xLSDBDCdWmJivqnZ848i9ydepLvBr0BsmWPk43rkuJWyx5Sm
         fShVdAsWLr2ZButHDIj9Y9BJvAf6jXrhWpZwRbI7+YBrO4wszFeplXKsX0Mwc1Gm1iao
         9aBGM8U4HTOo+U3on2ZrermPkA7cYah+tKj3qvwo+zNoYsKE1Wcg8RDoyssp1NHg4z5V
         bFvZu/ihbEtOhlPROkCdgAJYzdr/5yL1XtNrW37NKVywbrr/bZuTj1UHr/Sg/qkpg0hK
         Je9jmjKZpPEV+NW9D0tmqLEGHX0DNCIAy6Wecn50q68qtjzNbi2haghdfBOWhmyuYajg
         +N3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYmHyIzoMtvo6t0tmnrVFy5qLNFl33RfHmWUKURfrbnPcOGsH0TFxys6Qsm9OcKxvHMcsvKpYoWLu2gVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOCoRzqFS+27Fu5MftXjy3Ir2FbfbcQiLixqQcYloxRw2GZiVo
	uSx5FGBIA45oucYFT+sB+nlkxoIuv9cJQ4o6XCNMTBEzN80/Oc3hyujp6iVyN3xGr+8=
X-Gm-Gg: ASbGncs8/LZjZunPrKOXkcR3d2X+ekzPqZNFlXrlVapbsMMuBmxyUgu7fCxhYNeBhu9
	+JIWETZ8swVs7JIhGN7aKirszoLjFnfdk1x0GOqzXXwKM7X8naWntT+z+Hv8UHSdlQVmB+rlQhx
	S4/2SMHpNR8o54x3sH7OilLCwJkDrghkpJg8c6upvpK6t2JZXPIRUus0ia4wCZ5UM6f+u9P9EIJ
	JDcV8n/XWDwmOg5MRVx7D29uNzGGrwtniUIjQX1YqTUZQKKpIHrEfYg8+Dr0p/CZgtbh3Fa1DiC
	JPnKq0oWeOUsthiAUX/8FvDJzvwCX8BOd3RbwkMLFTjJiwv1HF7YqGvCIOxQzcyQNgdTzO+JyJh
	07MjubwM9/25zQJa9yWnCA2se/W6eOkfrOzXuAIzEUhs57lR6we7ty4lEfdouW9y+L8Unj27pVL
	vdKDUc6yGbCLvqoxMRpTc=
X-Google-Smtp-Source: AGHT+IHm/6/RnHvUQpqjyEKIYZGBSjHuPRp5b3DBLGbL1GoDEzCDZheRRGUhzX2BHAHpgilQLx/Q7g==
X-Received: by 2002:a05:600c:621a:b0:471:14f5:126f with SMTP id 5b1f17b1804b1-4775ce206f3mr59734595e9.33.1762443404278;
        Thu, 06 Nov 2025 07:36:44 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477622f42a5sm98437525e9.1.2025.11.06.07.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 07:36:43 -0800 (PST)
Message-ID: <d1b02488-7722-4b39-bb8e-f7e5c8e11b1e@tuxon.dev>
Date: Thu, 6 Nov 2025 17:36:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/26] clk: at91: pmc: #undef field_{get,prep}() before
 definition
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
 <939d8c6da1f468026b1bb201413ba08b1d0751fd.1762435376.git.geert+renesas@glider.be>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <939d8c6da1f468026b1bb201413ba08b1d0751fd.1762435376.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/25 15:33, Geert Uytterhoeven wrote:
> Prepare for the advent of globally available common field_get() and
> field_prep() macros by undefining the symbols before defining local
> variants.  This prevents redefinition warnings from the C preprocessor
> when introducing the common macros later.
> 
> Suggested-by: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Acked-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1EA19CC28
	for <linux-crypto@vger.kernel.org>; Tue, 22 Apr 2025 11:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745322142; cv=none; b=D8C8Xg5mqP9Ee+Lt8pnaJv7RwhRoueMIJqCgNRCi3QBFzWGnN8ZZ5UgMGtlPsPCWgI4HWvM4JcPYhUr8HpClUUYzMEuJFpf6cKp/01JxOjB/jUwzwIxA4PudoXffgr/JWOO/ZN1DVHTMobCHqVFnDIqznUJpwq+pKmiZyytrlZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745322142; c=relaxed/simple;
	bh=JKE184lpOsbPrO/7aA0AY/dhX9Uo/v/klX5HLzOqM+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b0737YxVaSr3T2v79aG4g10M0aGyKLmomgmGZ/JRRgNF3/DlIoQa1HSirDcNr8o6rpp85G22JANe8b1PA6Jx4wvgVuWH6Q6aFPQA81i1fmTiJ5hRbm+KwPhGVXmFjqfGFYV8YepXPObfYZvDwzSEi+lrCKdEEeGnf0xJL4Z/k84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c2xrWOo/; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c2xrWOo/"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30bfc8faef9so46964371fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Apr 2025 04:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745322139; x=1745926939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKE184lpOsbPrO/7aA0AY/dhX9Uo/v/klX5HLzOqM+8=;
        b=c2xrWOo/pSPNDno9WPia3pw+yri4OVuu4Mmt2UISEaC+qgUKjrtmEtNPMiV3C388T3
         vsMJ+46u+BQcnc+x/jxw73izecEyuqFdzYpijEaJJ2BZWR0n3/dVL3hRntJj8BM55n6w
         frdfXVr9TnkoaCtmx8YZaqn97Rdak+bHbUzE6bOqSvIRe2gl/PeGAQjlmn82X8ANpH3W
         ZB5JS+ZMvS8B0bJT9Q1nLc2ZcztoCmx2D3tGICINN6id4LbUkL3LmVFVvKVfUZNaSh+d
         HGvHBkthtsW7GYqlO7LdAAgX7E3nfAL1IncfYjLy1j/2taiCMJAEh28vdOKN42ncWUkF
         sxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745322139; x=1745926939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKE184lpOsbPrO/7aA0AY/dhX9Uo/v/klX5HLzOqM+8=;
        b=r2SskmPtfNMrnkWeids7AQUJGCdUHVjmAX3XEEOo3kiR6LL1plP0olOQAIBUt45lwf
         PgUgEvzIPX8NOajTXcKZpYa69BjfIlRrFYZ8yUE5tKZ7xrToAp09hG+SePF+O+ZkXDVs
         EtQ0UEgKUzXuZexBVGGMz/cXVmOEqFV6b0iE55ZBa6kU66rr4V0U4YuXOz25yqRygr1y
         tjtw2VMOed2W4vZQcBybKvDqP5Stmq1zxIN3SiMRzCxnwNYzhCEfLLYeP9aI1i57qlsI
         HaqXf/ahYx9OBdWNp3lWszp1BZY307SLeJxKa7toh3hk3BpGFd7htGvq/OMutfvP/Kbl
         m2yA==
X-Gm-Message-State: AOJu0YzCNbCz3ugH6KB1/b8rSiT78s6HfJ28eB4p9avMzMhIVTEhA290
	OlX448RgA0MpAG5hno7w9jxpHBBx8WojIC1MlF8r02IMRlzkp4dA80RzaMMmPuuOxZEkp+XX7/v
	8XIX7GeDUK4XB/OKYDS/J5Vm6ZHCDUbdHX1OwmQ==
X-Gm-Gg: ASbGncupOB2sbKgvA7WTPcRtU0xr59yAyJl9zsPODMIqN24Oh0JMCB9wBuidUW+gLQ/
	a7Y5r/l/rImXNXbqlTCkxSC91LNfYGnvK/me2De0+69cOLo1LDMVADFhW9Zzzzwpb3l/uYBtnFK
	uNT7ZRfR2kpTvTttYB5sWWBg==
X-Google-Smtp-Source: AGHT+IFm0QuF+MKzFVuJfeElIzDwo5DNp4RQe/j6WQIWdZRVRgiFC+4alaFtOW4po2uWD3T3nU+AwhkSj7DYWaP/Qtw=
X-Received: by 2002:a2e:bc88:0:b0:30b:9813:b010 with SMTP id
 38308e7fff4ca-31090554278mr45541741fa.31.1745322139074; Tue, 22 Apr 2025
 04:42:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422095718.17360-1-kabel@kernel.org>
In-Reply-To: <20250422095718.17360-1-kabel@kernel.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 22 Apr 2025 13:42:07 +0200
X-Gm-Features: ATxdqUFgffJrkHBIiGCKHha-7JyV-dOWeH_lR9YCYT2CA8Voz9ZgL4-ux_Xly6Y
Message-ID: <CACRpkdZ5EBiyEwEY68_bufnO-qFFH-XKzv5RmRn6=K+rN_NFBQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Set hwrng quality to lowest possible
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 11:57=E2=80=AFAM Marek Beh=C3=BAn <kabel@kernel.org=
> wrote:

> According to the review by Bill Cox [1], the Atmel SHA204A random number
> generator produces random numbers with very low entropy.
>
> Set the lowest possible entropy for this chip just to be safe.
>
> [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.=
html
>
> Fixes: da001fb651b00e1d ("crypto: atmel-i2c - add support for SHA204A ran=
dom number generator")
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>

Ugh
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I would even tag:
Cc: stable@vger.kernel.org

on this, but it's up to Herbert.

Yours,
Linus Walleij

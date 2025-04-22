Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ACC1E0DEB;
	Tue, 22 Apr 2025 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745316181; cv=none; b=IeQQbaHecoP42TRcETTG20I9PbKpWreocHXO1xfXFnBXkYIq2ld0OfVFShBKO4CMxwXs4nplvBSMcvUXRHuUC9BQ3j+PWi6Ycjc6jEePubasCzetNrmmsgEjQeujYDR3CHFSonb3A+NcQ1s4B/A/BpKjOvJT3Nm9JKkO8/vOIfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745316181; c=relaxed/simple;
	bh=ToRg4CeRUOUVtP4ZSt1QrM8CjfKlNnOozBNBrYE2698=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTUl7gmQzOVGXzTUKwvJibJLMwM7m5SSupEScRUHrKWPvXVmHPIoxwPQlcKEl1VQLBCMfPUzsU/p1APU3QF+Ed0CsyirMtJUQRndSVrdJsIanK6wGWkoPpxwUezKvG/O5vd4eyqZX0A4HhYCgI5Aagi97CL0wjdfpeCkNogFKSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMzGWhvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMzGWhvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2F5C4AF0B;
	Tue, 22 Apr 2025 10:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745316181;
	bh=ToRg4CeRUOUVtP4ZSt1QrM8CjfKlNnOozBNBrYE2698=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LMzGWhvnQOus9OmqwM22LXNODp1pWEOmno+GVGLi4GVTojz0xsEUEQn8Ir0C8hy2N
	 EWQ07HQk8p5OXTNN0ATsErSLCE0PDS2S3d1QFl6hDASCASrudDwQNwzUT/NYmipQdK
	 MHnA9H6mz5YB4rxn6OXcjN3hlryh5oY4WZExT8cweH1dveJ66dHpUQoEN/aS9qE8Cx
	 pGeB/Eo+IQkKZPQYE/6EmFIyofPfWnUtrJ97kHDx8bir5xY9itCRsde0siz1ABiqpn
	 LKtFaNdCBKIUt4sauhV1f9M3EZOx6afknolOlBJnhKeW1P4sNGbgT2is9dkpMnx0eo
	 cZG30LbEZ3udg==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso6446027e87.3;
        Tue, 22 Apr 2025 03:03:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV19kh4R5NRZl+S15WJvSX6p0/djkrh9byJtMaBvNZiqje7VghuOlaauAFSTy9/uGfSSYgbh6SCo8yvFGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBU7y5Jqo9dW49nxDhPfblg44D6r9EKqYP7a2FQE0+bs0HE+cz
	IFkP92vtMLITK5FAbiOJE3H/JF1PQ24ogndM+zL6KHF8sNKNiP7dzqFVKTYWYma/WsRXVpPpTpJ
	POsYNZMkwxkS2R3aLjIvHXMle8oU=
X-Google-Smtp-Source: AGHT+IEyHKXRp4nAwbh4JgmSsEY+YxuekgICFOguGtsRj7qggKe6wA1CgUf+picRpfTOM44oWguOLA20ETib8MAK5Zo=
X-Received: by 2002:a05:6512:1045:b0:54a:f6e9:2c04 with SMTP id
 2adb3069b0e04-54d6e635483mr2952442e87.26.1745316179390; Tue, 22 Apr 2025
 03:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422095718.17360-1-kabel@kernel.org>
In-Reply-To: <20250422095718.17360-1-kabel@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 22 Apr 2025 12:02:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFO3fxEcv5VPxtGnq-x0+iZnUHau2WKtiFHg1f6XQc_qg@mail.gmail.com>
X-Gm-Features: ATxdqUEfv1VpLPveqLUDgYOhJXSwckyrQ-acm7s0JA2Maoz21Kx5GCvlcSz_xRA
Message-ID: <CAMj1kXFO3fxEcv5VPxtGnq-x0+iZnUHau2WKtiFHg1f6XQc_qg@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Set hwrng quality to lowest possible
To: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Linus Walleij <linus.walleij@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Apr 2025 at 11:57, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
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
> ---
>  drivers/crypto/atmel-sha204a.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>

Wow, that is terrible

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 75bebec2c757..0fcf4a39de27 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -163,6 +163,12 @@ static int atmel_sha204a_probe(struct i2c_client *cl=
ient)
>         i2c_priv->hwrng.name =3D dev_name(&client->dev);
>         i2c_priv->hwrng.read =3D atmel_sha204a_rng_read;
>
> +       /*
> +        * According to review by Bill Cox [1], this HWRNG has very low e=
ntropy.
> +        * [1] https://www.metzdowd.com/pipermail/cryptography/2014-Decem=
ber/023858.html
> +        */
> +       i2c_priv->hwrng.quality =3D 1;
> +
>         ret =3D devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
>         if (ret)
>                 dev_warn(&client->dev, "failed to register RNG (%d)\n", r=
et);
> --
> 2.49.0
>

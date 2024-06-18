Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82DC63AE;
	Tue, 18 Jun 2024 04:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718684797; cv=none; b=Xx+zkDJGSgLNn3rqeQn1ESNrUAJYACb998usQkIjVVc4PsX6Qj3MUcXJy7mIqbO+r+lAaH+UY+clYZJ8nFwANLFcWia+TBl1Hv1DVojhxU0JhjyaUxr8ugGsHBM33GkjeYElpZclJBhWbUZyakX9QmZenFIdjljXr6UYNndLi9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718684797; c=relaxed/simple;
	bh=1j6EHgbnaeEoxUDtFTjZfx0qzbM1+6oLEzsVID/Qu4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zn7vxbl0JdIqCmWzM0OMWRk2E+ar1Rzhsdb9i6Byin3wEPkir3Q7najaqkJXsvcprcfWDZJDX1pcaFU+CN5e+u9nFyBinlknQInDfQuO1fEeIyEr3XT96DpVnqJ420Hf0URTAHew3yh49p6i1hNEtTyfQrSE5mFG6Wr12Uy33YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jz81jFZW; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jz81jFZW"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5baf982f56dso2986048eaf.3;
        Mon, 17 Jun 2024 21:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718684795; x=1719289595; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KEMaT1TlaEmcm8Kdg8m3ufqBtJYJy4jB0+SosRoAgvY=;
        b=jz81jFZWoMrhuP0VMBveeI5gp2CAHTHCCbNB/nI6tLCRjbbzzWjZazFlrCAKhUHYgQ
         KH7JJIJL095RGBNInD7pumTkXf3lDRSGSZXdt9hq62kShroxqzGy+P9Gk7XP21YjBba3
         XcKG5dDuZc5eN8ZrNGMT8J75OJcotebVvG+qgs1IOHqBiDZJfsxzXZVifM7DhG7ERKlK
         OIAQp2/hkguI2ZNiz7oHNUNetmVLYi0Mlbi06t9EiG5toIZaRwRQB/j7vSH0HYBCIHRg
         XFNYrH6Rm7mGLvsw5utilJfz+hG7csQBheKRl4QYxDwTAwMQ3ekIFdKM7c3qn9cXl1Ao
         CWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718684795; x=1719289595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KEMaT1TlaEmcm8Kdg8m3ufqBtJYJy4jB0+SosRoAgvY=;
        b=gvoK7I1Nl1pNrsGR60b1bEtMWVY2seQzqf49ZVdQ+lZWnSNfjcqEEwpOnGmQMAYMb1
         bYJop8AeDvnyruCGijD+9tEhX0m4+7/mPKz6rfXEX86l3MN5fQ6A1gydBA3YAmJJHhiS
         dqIknMCprqcCvZLyssRAZ4aw6OlF+psgBT+uDpMIjiBX3k6dTe3NsGp19Udq2diZhvN3
         pVjpWYbjANaEsos0mP9UmL2Va8VEzmOid23buW1pX1beD+SbmoQcDkybhe8LYIt0XUW2
         BF+LMl+ZbDwkBKKdp4cBqH+PMLTtMVnG+g9ga0TwCAbyVN/xKf89KDBekwTyXgoZrLmi
         Z0vQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6WIg+tRnGQUbXrZX+B2cwyKYF3e09i1oq0Nr5wqbA4zhoW8mREObHugH8IQond+6Z2EN7PhVA5fUX0JjweDc5TgQOX1puqCGPj2rdVeTUdicdXhUegpwjzhnKpiFC00SVSLpRJrZVFgrvW9J8pq81gtAoc4z3DZXT5i9NU4SRNphsItsTpQouplXy87s8ARJYtdEtC/wB12w3IcHcFoWDdALTsn6TgkiB
X-Gm-Message-State: AOJu0YxHQ2PhvFmGlo5Nhu53YgLcmzcSc+vsY95q2eAnvIk+DJNSbiNu
	FKDZT6AqlHSqL63MqL87XNxy9hxs7cC3PCRzFyCKTdDshj6V+IYytGyW7JALB0RAza/OIAbNcgh
	J14hDTzkmTDzQESf3PF3TGll7eohTX73t
X-Google-Smtp-Source: AGHT+IF+6ZHdp1vXryGnLrg4Z1+4ufKKFh1FZggdKzi7824NQ4NQwCLJWiNAN6LMB5TnJe0MHOkZqr45TC6yCcUF66k=
X-Received: by 2002:a05:6820:554:b0:5ba:ea6f:acb8 with SMTP id
 006d021491bc7-5bdadbdecefmr11947268eaf.3.1718684794716; Mon, 17 Jun 2024
 21:26:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618003743.2975-1-semen.protsenko@linaro.org> <20240618003743.2975-5-semen.protsenko@linaro.org>
In-Reply-To: <20240618003743.2975-5-semen.protsenko@linaro.org>
From: Anand Moon <linux.amoon@gmail.com>
Date: Tue, 18 Jun 2024 09:56:19 +0530
Message-ID: <CANAwSgSaYip=oqtLfTzFMq_HWGJMMbEXOqKWC8ANzxNZmBFXTw@mail.gmail.com>
Subject: Re: [PATCH 4/7] hwrng: exynos: Implement bus clock control
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sam,

On Tue, 18 Jun 2024 at 06:08, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>
> Some SoCs like Exynos850 might require the SSS bus clock (PCLK) to be
> enabled in order to access TRNG registers. Add and handle optional PCLK
> clock accordingly to make it possible.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
>  drivers/char/hw_random/exynos-trng.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
> index 88a5088ed34d..4520a280134c 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -47,7 +47,8 @@
>  struct exynos_trng_dev {
>         struct device   *dev;
>         void __iomem    *mem;
> -       struct clk      *clk;
> +       struct clk      *clk;   /* operating clock */
> +       struct clk      *pclk;  /* bus clock */
>         struct hwrng    rng;
>  };
>
> @@ -141,10 +142,23 @@ static int exynos_trng_probe(struct platform_device *pdev)
>                 goto err_clock;
>         }
>
> +       trng->pclk = devm_clk_get_optional(&pdev->dev, "pclk");

Use devm_clk_get_optional_enabled to avoid clk_prepare_enable

> +       if (IS_ERR(trng->pclk)) {
> +               ret = dev_err_probe(&pdev->dev, PTR_ERR(trng->pclk),
> +                                   "cannot get pclk");
> +               goto err_clock;
> +       }
> +
> +       ret = clk_prepare_enable(trng->pclk);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Could not enable the pclk.\n");
> +               goto err_clock;
> +       }
> +
>         ret = clk_prepare_enable(trng->clk);

Use devm_clk_get_enabled for this clock

>         if (ret) {
>                 dev_err(&pdev->dev, "Could not enable the clk.\n");
> -               goto err_clock;
> +               goto err_clock_enable;
>         }
>
>         ret = devm_hwrng_register(&pdev->dev, &trng->rng);
> @@ -160,6 +174,9 @@ static int exynos_trng_probe(struct platform_device *pdev)
>  err_register:
>         clk_disable_unprepare(trng->clk);
>
> +err_clock_enable:
> +       clk_disable_unprepare(trng->pclk);
> +
>  err_clock:
>         pm_runtime_put_noidle(&pdev->dev);
>
> @@ -174,6 +191,7 @@ static void exynos_trng_remove(struct platform_device *pdev)
>         struct exynos_trng_dev *trng = platform_get_drvdata(pdev);
>
>         clk_disable_unprepare(trng->clk);
> +       clk_disable_unprepare(trng->pclk);
>
>         pm_runtime_put_sync(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
> --
> 2.39.2
>
>

Thanks
-Anand

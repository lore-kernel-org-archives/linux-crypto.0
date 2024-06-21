Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFF16E894;
	Fri, 21 Jun 2024 10:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965107; cv=none; b=EMlOoU16/nXGgecZI1gbJMsN3NmVkVA4i8ASgGrtcZXhRF9aDa2oTCVNTQubeo4TuziayHjo2qDFAY8CQM7VZVmtX7n5C1tPOs1O0Hb3x4WgfQ8UgQZtoHBZanLhBfeIzyTOYQuyScZnENAUX5XhMGHy8HZP+wTa1UMKnZmwZp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965107; c=relaxed/simple;
	bh=U1hz+8/bzdauintFQu1B2mPpB7R33BaC4FjDhvSa8R8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CF66zbRaZhfBl5cR98eZLKip/yKkwR/kG5e4ekIQmTEPNzwHmWUnSf3sIRns3XbYHtSbS1T7CqGRzB5sOYtg+C9BXtG8AWKtI9LFnJvrDy6gy0aejGmgI0K16TWjiL8a4KOwLMf3Tjqe3M+soEEKphHtBpfVMNs3Fhu8iduZO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AN4S2eu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AN4S2eu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB288C4AF09;
	Fri, 21 Jun 2024 10:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718965107;
	bh=U1hz+8/bzdauintFQu1B2mPpB7R33BaC4FjDhvSa8R8=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=AN4S2eu+2StK8dntclq6UzVlpDLAtIOCFvnr1RahBqyXLmC2oLqjkYJR456Ms+40R
	 hKf49obq+VfQyyGDiFPJaNQKXjHTMd4eN7RmAR61ZmQhI5cBjA/FRNba68ucSrY3yb
	 aCW+yht4NYfHN8sRxRhggSGoxgvHOoijcDFiM2MmjCXua1hOm1ga7PWMgXJWKnm4pe
	 /8j1uoPfogZRlPIpXkl2jMKZvbHsLtG47/0y9tbngsb2Scy6jGuxJq89FS8o6L4FwG
	 XXSGFPQsedLRozheV3qz5odtHkmUg+uZYkaftLv2QfZ5cEK8AMvZ3xVvIjknpgpfAS
	 JFR2P5xf0Szwg==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2eaea28868dso24069441fa.3;
        Fri, 21 Jun 2024 03:18:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7d2g+D4gxEQYt5ryeyKB0yYrtjiDitrv+x9OrgnWoBumVMB8F4Dun1Pn2O/dQ2yw2UsiDhupTJYNygw0Zl1toFq5nxaGXCoiUs/rJYw9tOsK3ihwHJciCnY4laP/y1ILuQBqCTQsYwqBlwOHSH87SnRStYh3rg0RQVDsjhah5HHxIFTRCZA==
X-Gm-Message-State: AOJu0YyfoRL72EYB0c7HH8yCWy7jxl/5K/7pP5+qgB12yBwtkf+t6tvF
	WEMT8lhK2gpVXFCwGWcCdOvKEEVtK5vfrw3c4rCJVQdDOTUKzNjfAmnB5x7QrTVeC9VCOMpA9H9
	pdwp92FhelEUYjBYi68RRa5heVLg=
X-Google-Smtp-Source: AGHT+IHO98/2KxxNQSI6Iov2uFjwnOJvJY9CeBR3g6jopu9QSIJvgzBeO6l1TKdjqUov1zSWO5URR/C24lztI0UaSCk=
X-Received: by 2002:a05:651c:1311:b0:2ec:4a91:c38b with SMTP id
 38308e7fff4ca-2ec4a91d4b4mr22199161fa.5.1718965106029; Fri, 21 Jun 2024
 03:18:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1718921174.git.daniel@makrotopia.org> <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
 <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
In-Reply-To: <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Fri, 21 Jun 2024 18:18:13 +0800
X-Gmail-Original-Message-ID: <CAGb2v66VHXvBGH9X9nj1=fSnCgP035HEMU-L2NShg08rE5Qnug@mail.gmail.com>
Message-ID: <CAGb2v66VHXvBGH9X9nj1=fSnCgP035HEMU-L2NShg08rE5Qnug@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
To: Daniel Golle <daniel@makrotopia.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>, 
	Dragan Simic <dsimic@manjaro.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 5:58=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 21/06/2024 03:25, Daniel Golle wrote:
> > From: Aurelien Jarno <aurelien@aurel32.net>
> >
>
> > +
> > +static int rk_rng_init(struct hwrng *rng)
> > +{
> > +     struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> > +     int ret;
> > +
> > +     /* start clocks */
> > +     ret =3D clk_bulk_prepare_enable(rk_rng->clk_num, rk_rng->clk_bulk=
s);
> > +     if (ret < 0) {
> > +             dev_err((struct device *) rk_rng->rng.priv,
> > +                     "Failed to enable clks %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     /* set the sample period */
> > +     writel(RK_RNG_SAMPLE_CNT, rk_rng->base + TRNG_RNG_SAMPLE_CNT);
> > +
> > +     /* set osc ring speed and enable it */
> > +     writel_relaxed(TRNG_RNG_CTL_LEN_256_BIT |
> > +                    TRNG_RNG_CTL_OSC_RING_SPEED_0 |
> > +                    TRNG_RNG_CTL_ENABLE,
> > +                    rk_rng->base + TRNG_RNG_CTL);
>
> I doubt relaxed write is here intentional. Enabling should be last
> instruction, so this should be ordered write.

I agree that the driver should just do all non-relaxed writes for simplicit=
y.
The penalty isn't that severe since commit 22ec71615d82 ("arm64: io: Relax
implicit barriers in default I/O accessors").

Just to clarify, writes to devices are always ordered. The non-relaxed
writes are ordered to _memory writes_, which doesn't really matter for
this driver.

ChenYu


> > +
> > +     return 0;
> > +}
> > +
> > +static void rk_rng_cleanup(struct hwrng *rng)
> > +{
> > +     struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> > +
> > +     /* stop TRNG */
> > +     writel_relaxed(0, rk_rng->base + TRNG_RNG_CTL);
>
> This should not be relaxed. This might lead to very tricky to debug issue=
s.
>
> > +
> > +     /* stop clocks */
> > +     clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
> > +}
> > +
> > +static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool =
wait)
> > +{
> > +     struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> > +     size_t to_read =3D min_t(size_t, max, RK_RNG_MAX_BYTE);
> > +     u32 reg;
> > +     int ret =3D 0;
> > +
> > +     ret =3D pm_runtime_get_sync((struct device *) rk_rng->rng.priv);
>
> Why this cannot be just simpler pm_runtime_resume_and_get()?
>
> > +     if (ret < 0)
> > +             goto out;
>
> This does not look like correct error path. Device was not busy here.
>
> > +
> > +     /* Start collecting random data */
> > +     writel_relaxed(TRNG_RNG_CTL_START, rk_rng->base + TRNG_RNG_CTL);
> > +
> > +     ret =3D readl_poll_timeout(rk_rng->base + TRNG_RNG_CTL, reg,
> > +                              !(reg & TRNG_RNG_CTL_START),
> > +                              RK_RNG_POLL_PERIOD_US,
> > +                              RK_RNG_POLL_TIMEOUT_US);
> > +     if (ret < 0)
> > +             goto out;
> > +
> > +     /* Read random data stored in the registers */
> > +     memcpy_fromio(buf, rk_rng->base + TRNG_RNG_DOUT, to_read);
> > +out:
> > +     pm_runtime_mark_last_busy((struct device *) rk_rng->rng.priv);
> > +     pm_runtime_put_sync_autosuspend((struct device *) rk_rng->rng.pri=
v);
> > +
> > +     return to_read;
> > +}
> > +
> > +static int rk_rng_probe(struct platform_device *pdev)
> > +{
> > +     struct device *dev =3D &pdev->dev;
> > +     struct rk_rng *rk_rng;
> > +     int ret;
> > +
> > +     rk_rng =3D devm_kzalloc(dev, sizeof(*rk_rng), GFP_KERNEL);
> > +     if (!rk_rng)
> > +             return -ENOMEM;
> > +
> > +     rk_rng->base =3D devm_platform_ioremap_resource(pdev, 0);
> > +     if (IS_ERR(rk_rng->base))
> > +             return PTR_ERR(rk_rng->base);
> > +
> > +     rk_rng->clk_num =3D devm_clk_bulk_get_all(dev, &rk_rng->clk_bulks=
);
> > +     if (rk_rng->clk_num < 0)
> > +             return dev_err_probe(dev, rk_rng->clk_num,
> > +                                  "Failed to get clks property\n");
> > +
> > +     rk_rng->rst =3D devm_reset_control_array_get(&pdev->dev, false, f=
alse);
> > +     if (IS_ERR(rk_rng->rst))
> > +             return dev_err_probe(dev, PTR_ERR(rk_rng->rst),
> > +                                  "Failed to get reset property\n");
> > +
> > +     reset_control_assert(rk_rng->rst);
> > +     udelay(2);
> > +     reset_control_deassert(rk_rng->rst);
> > +
> > +     platform_set_drvdata(pdev, rk_rng);
> > +
> > +     rk_rng->rng.name =3D dev_driver_string(dev);
> > +#ifndef CONFIG_PM
> > +     rk_rng->rng.init =3D rk_rng_init;
> > +     rk_rng->rng.cleanup =3D rk_rng_cleanup;
> > +#endif
> > +     rk_rng->rng.read =3D rk_rng_read;
> > +     rk_rng->rng.priv =3D (unsigned long) dev;
> > +     rk_rng->rng.quality =3D 900;
> > +
> > +     pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
> > +     pm_runtime_use_autosuspend(dev);
> > +     pm_runtime_enable(dev);
> > +
> > +     ret =3D devm_hwrng_register(dev, &rk_rng->rng);
> > +     if (ret)
> > +             return dev_err_probe(&pdev->dev, ret, "Failed to register=
 Rockchip hwrng\n");
> > +
> > +     dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>
> Drop, driver should be silent on success.
>
>
> Best regards,
> Krzysztof
>
>

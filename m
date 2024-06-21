Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2459716EB6D;
	Fri, 21 Jun 2024 10:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718964313; cv=none; b=YqJIct9sHG8gLhmdXy6TTv/dk8pHQATeAiXZrhyeR4BtRuEhKjsyFtfKromtfGy44CaUK1i9qXCHz4YIEmKBhZozTtVeXjREOyx0yAECbIydmMuF2U506I11nL5aullkMQctgFJpBx1ZT9agyeBsfBAleaZnA/G6kRJLedz48Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718964313; c=relaxed/simple;
	bh=sWooJUNnSRTxZaphXkNkS4PHKpxvylR8017xEvjmVTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kk2Zsl+FU+a9RemZq1krDQBSdus1h+dxvjdYQIeeeB3zG7J83O/pinQXMKC7yaiiMpWVtYzDv9etYaBatsToz0zrD1uBItNenmZgOK4czhGYMgyarCMQCoe7J2JdriE45LIM1HF3pyhAwu78zyW9hvgMstWEhEp4iTLqWAEdExw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSOXbhtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSOXbhtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857F4C4AF08;
	Fri, 21 Jun 2024 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718964312;
	bh=sWooJUNnSRTxZaphXkNkS4PHKpxvylR8017xEvjmVTo=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc:From;
	b=VSOXbhtbI8XUEtiujkkmCHEn2uIXfgznyRGR9aV94a/ippMZJYHPlVIHXdb2huCpx
	 6S2eVWywRBKpEGgm5PjVHXzzd9DY4PU0AZiMn9vlngP19Gd9k8V/TdUSNXDf4Q0zGW
	 WuYTbQQENYV6EJK75Hxq5b5nemh7xJiv7Mr5u/4SZW1c2656fXC3aM+70xl99tqbeU
	 wwgr7KtYbnRefB9osmwBy7e4I14WUSdAmT6tV3bJJL2dXzqkt5TLEEE6KMB4BR1pOp
	 Wg6dS+4i1dGj5m1UOZTi+dNidbcEqj6M6pC26vieY+k+RF/QCqJtqFe6CxdllGzMUq
	 aj18SdEOU8tLA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ebe40673d8so19840071fa.3;
        Fri, 21 Jun 2024 03:05:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX+RrWs1+pc7hbPuYIgBu9UiOiSb+endDE9ztHYmUDxHFbMWZ2Yan2D+wKvoeL6DWk/hrfsUnvK3RzniCX01eGRA1b0nQRB/98sRYr/nXEEhHk8y+hMym+Gkw8atk3vz1s5xSLqtEdyTbt4xaS1+Bv0VYlLw5abVVwgXyCWWtQZrZ/1SJKu8g==
X-Gm-Message-State: AOJu0Yxlhyel3oB5HMRISmsMD/fIhkrmYV1Vp0wrhzoVeoLRS9+OwZz4
	KJSmN6d2gaYZma2xYYHh7CXP2leYJpi9B4F++94jMfp9bMkJteefUZxhFN7uD1bp2Tyrgbz6szl
	YnoSo3RPNt97F/tAkoXd8aCxoUrw=
X-Google-Smtp-Source: AGHT+IG0/TKUdLOJXVBxNUhWdxczbTTZyRwZYLSRed8/6CELFGOI4aCq3MuLoVJkEn+d7Fh05SdBmvc3Ckl0Rmk2h6o=
X-Received: by 2002:a2e:9098:0:b0:2ec:165a:224a with SMTP id
 38308e7fff4ca-2ec3cfe69a9mr52136071fa.36.1718964310821; Fri, 21 Jun 2024
 03:05:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1718921174.git.daniel@makrotopia.org> <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
In-Reply-To: <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Fri, 21 Jun 2024 18:04:58 +0800
X-Gmail-Original-Message-ID: <CAGb2v67nETGOHj4dWbZE1AWHOpVA58-votveV7Q=bP7eTjFQdA@mail.gmail.com>
Message-ID: <CAGb2v67nETGOHj4dWbZE1AWHOpVA58-votveV7Q=bP7eTjFQdA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>, 
	Dragan Simic <dsimic@manjaro.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 9:25=E2=80=AFAM Daniel Golle <daniel@makrotopia.org=
> wrote:
>
> From: Aurelien Jarno <aurelien@aurel32.net>
>
> Rockchip SoCs used to have a random number generator as part of their
> crypto device, and support for it has to be added to the corresponding
> driver. However newer Rockchip SoCs like the RK356x have an independent
> True Random Number Generator device. This patch adds a driver for it,
> greatly inspired from the downstream driver.
>
> The TRNG device does not seem to have a signal conditionner and the FIPS
> 140-2 test returns a lot of failures. They can be reduced by increasing
> RK_RNG_SAMPLE_CNT, in a tradeoff between quality and speed. This value
> has been adjusted to get ~90% of successes and the quality value has
> been set accordingly.
>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> [daniel@makrotpia.org: code style fixes]
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  MAINTAINERS                           |   1 +
>  drivers/char/hw_random/Kconfig        |  14 ++
>  drivers/char/hw_random/Makefile       |   1 +
>  drivers/char/hw_random/rockchip-rng.c | 229 ++++++++++++++++++++++++++
>  4 files changed, 245 insertions(+)
>  create mode 100644 drivers/char/hw_random/rockchip-rng.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 77d449c89bf2..299b8c1a5fb5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19493,6 +19493,7 @@ M:      Daniel Golle <daniel@makrotopia.org>
>  M:     Aurelien Jarno <aurelien@aurel32.net>
>  S:     Maintained
>  F:     Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> +F:     drivers/char/hw_random/rockchip-rng.c
>
>  ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
>  M:     Jacob Chen <jacob-chen@iotwrt.com>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kcon=
fig
> index 442c40efb200..2b62cd08f91a 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -573,6 +573,20 @@ config HW_RANDOM_JH7110
>           To compile this driver as a module, choose M here.
>           The module will be called jh7110-trng.
>
> +config HW_RANDOM_ROCKCHIP
> +       tristate "Rockchip True Random Number Generator"
> +       depends on HW_RANDOM && (ARCH_ROCKCHIP || COMPILE_TEST)
> +       depends on HAS_IOMEM
> +       default HW_RANDOM
> +       help
> +         This driver provides kernel-side support for the True Random Nu=
mber
> +         Generator hardware found on some Rockchip SoC like RK3566 or RK=
3568.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called rockchip-rng.
> +
> +         If unsure, say Y.
> +
>  endif # HW_RANDOM
>
>  config UML_RANDOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Mak=
efile
> index 32549a1186dc..01f012eab440 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -48,4 +48,5 @@ obj-$(CONFIG_HW_RANDOM_XIPHERA) +=3D xiphera-trng.o
>  obj-$(CONFIG_HW_RANDOM_ARM_SMCCC_TRNG) +=3D arm_smccc_trng.o
>  obj-$(CONFIG_HW_RANDOM_CN10K) +=3D cn10k-rng.o
>  obj-$(CONFIG_HW_RANDOM_POLARFIRE_SOC) +=3D mpfs-rng.o
> +obj-$(CONFIG_HW_RANDOM_ROCKCHIP) +=3D rockchip-rng.o
>  obj-$(CONFIG_HW_RANDOM_JH7110) +=3D jh7110-trng.o
> diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_rand=
om/rockchip-rng.c
> new file mode 100644
> index 000000000000..6070abb73847
> --- /dev/null
> +++ b/drivers/char/hw_random/rockchip-rng.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * rockchip-rng.c True Random Number Generator driver for Rockchip SoCs
> + *
> + * Copyright (c) 2018, Fuzhou Rockchip Electronics Co., Ltd.
> + * Copyright (c) 2022, Aurelien Jarno
> + * Authors:
> + *  Lin Jinhan <troy.lin@rock-chips.com>
> + *  Aurelien Jarno <aurelien@aurel32.net>
> + */
> +#include <linux/clk.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>

Need to explicitly include linux/platform_device.h for |struct platform_dev=
ice|
and devm_platform_iomap_resource().

> +#include <linux/pm_runtime.h>
> +#include <linux/reset.h>
> +#include <linux/slab.h>
> +
> +#define RK_RNG_AUTOSUSPEND_DELAY       100
> +#define RK_RNG_MAX_BYTE                        32
> +#define RK_RNG_POLL_PERIOD_US          100
> +#define RK_RNG_POLL_TIMEOUT_US         10000
> +
> +/*
> + * TRNG collects osc ring output bit every RK_RNG_SAMPLE_CNT time. The v=
alue is
> + * a tradeoff between speed and quality and has been adjusted to get a q=
uality
> + * of ~900 (~90% of FIPS 140-2 successes).
> + */
> +#define RK_RNG_SAMPLE_CNT              1000
> +
> +/* TRNG registers from RK3568 TRM-Part2, section 5.4.1 */
> +#define TRNG_RST_CTL                   0x0004
> +#define TRNG_RNG_CTL                   0x0400
> +#define TRNG_RNG_CTL_LEN_64_BIT                (0x00 << 4)
> +#define TRNG_RNG_CTL_LEN_128_BIT       (0x01 << 4)
> +#define TRNG_RNG_CTL_LEN_192_BIT       (0x02 << 4)
> +#define TRNG_RNG_CTL_LEN_256_BIT       (0x03 << 4)
> +#define TRNG_RNG_CTL_OSC_RING_SPEED_0  (0x00 << 2)
> +#define TRNG_RNG_CTL_OSC_RING_SPEED_1  (0x01 << 2)
> +#define TRNG_RNG_CTL_OSC_RING_SPEED_2  (0x02 << 2)
> +#define TRNG_RNG_CTL_OSC_RING_SPEED_3  (0x03 << 2)
> +#define TRNG_RNG_CTL_ENABLE            BIT(1)
> +#define TRNG_RNG_CTL_START             BIT(0)
> +#define TRNG_RNG_SAMPLE_CNT            0x0404
> +#define TRNG_RNG_DOUT                  0x0410
> +
> +struct rk_rng {
> +       struct hwrng rng;
> +       void __iomem *base;
> +       struct reset_control *rst;
> +       int clk_num;
> +       struct clk_bulk_data *clk_bulks;
> +};
> +
> +static int rk_rng_init(struct hwrng *rng)
> +{
> +       struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> +       int ret;
> +
> +       /* start clocks */
> +       ret =3D clk_bulk_prepare_enable(rk_rng->clk_num, rk_rng->clk_bulk=
s);
> +       if (ret < 0) {
> +               dev_err((struct device *) rk_rng->rng.priv,
> +                       "Failed to enable clks %d\n", ret);
> +               return ret;
> +       }
> +
> +       /* set the sample period */
> +       writel(RK_RNG_SAMPLE_CNT, rk_rng->base + TRNG_RNG_SAMPLE_CNT);
> +
> +       /* set osc ring speed and enable it */
> +       writel_relaxed(TRNG_RNG_CTL_LEN_256_BIT |
> +                      TRNG_RNG_CTL_OSC_RING_SPEED_0 |
> +                      TRNG_RNG_CTL_ENABLE,
> +                      rk_rng->base + TRNG_RNG_CTL);
> +
> +       return 0;
> +}
> +
> +static void rk_rng_cleanup(struct hwrng *rng)
> +{
> +       struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> +
> +       /* stop TRNG */
> +       writel_relaxed(0, rk_rng->base + TRNG_RNG_CTL);
> +
> +       /* stop clocks */
> +       clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
> +}
> +
> +static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wa=
it)
> +{
> +       struct rk_rng *rk_rng =3D container_of(rng, struct rk_rng, rng);
> +       size_t to_read =3D min_t(size_t, max, RK_RNG_MAX_BYTE);
> +       u32 reg;
> +       int ret =3D 0;
> +
> +       ret =3D pm_runtime_get_sync((struct device *) rk_rng->rng.priv);
> +       if (ret < 0)
> +               goto out;
> +
> +       /* Start collecting random data */
> +       writel_relaxed(TRNG_RNG_CTL_START, rk_rng->base + TRNG_RNG_CTL);
> +
> +       ret =3D readl_poll_timeout(rk_rng->base + TRNG_RNG_CTL, reg,
> +                                !(reg & TRNG_RNG_CTL_START),
> +                                RK_RNG_POLL_PERIOD_US,
> +                                RK_RNG_POLL_TIMEOUT_US);
> +       if (ret < 0)
> +               goto out;
> +
> +       /* Read random data stored in the registers */
> +       memcpy_fromio(buf, rk_rng->base + TRNG_RNG_DOUT, to_read);
> +out:
> +       pm_runtime_mark_last_busy((struct device *) rk_rng->rng.priv);
> +       pm_runtime_put_sync_autosuspend((struct device *) rk_rng->rng.pri=
v);
> +
> +       return to_read;
> +}
> +
> +static int rk_rng_probe(struct platform_device *pdev)
> +{
> +       struct device *dev =3D &pdev->dev;
> +       struct rk_rng *rk_rng;
> +       int ret;
> +
> +       rk_rng =3D devm_kzalloc(dev, sizeof(*rk_rng), GFP_KERNEL);
> +       if (!rk_rng)
> +               return -ENOMEM;
> +
> +       rk_rng->base =3D devm_platform_ioremap_resource(pdev, 0);
> +       if (IS_ERR(rk_rng->base))
> +               return PTR_ERR(rk_rng->base);
> +
> +       rk_rng->clk_num =3D devm_clk_bulk_get_all(dev, &rk_rng->clk_bulks=
);
> +       if (rk_rng->clk_num < 0)
> +               return dev_err_probe(dev, rk_rng->clk_num,
> +                                    "Failed to get clks property\n");
> +
> +       rk_rng->rst =3D devm_reset_control_array_get(&pdev->dev, false, f=
alse);
> +       if (IS_ERR(rk_rng->rst))
> +               return dev_err_probe(dev, PTR_ERR(rk_rng->rst),
> +                                    "Failed to get reset property\n");
> +
> +       reset_control_assert(rk_rng->rst);
> +       udelay(2);
> +       reset_control_deassert(rk_rng->rst);
> +
> +       platform_set_drvdata(pdev, rk_rng);
> +
> +       rk_rng->rng.name =3D dev_driver_string(dev);
> +#ifndef CONFIG_PM
> +       rk_rng->rng.init =3D rk_rng_init;
> +       rk_rng->rng.cleanup =3D rk_rng_cleanup;
> +#endif
> +       rk_rng->rng.read =3D rk_rng_read;
> +       rk_rng->rng.priv =3D (unsigned long) dev;
> +       rk_rng->rng.quality =3D 900;
> +
> +       pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
> +       pm_runtime_use_autosuspend(dev);
> +       pm_runtime_enable(dev);

You can use devm_pm_runtime_enable(dev) here and simply get rid of the
remove function, and also no explicit cleanup needed.

> +
> +       ret =3D devm_hwrng_register(dev, &rk_rng->rng);
> +       if (ret)
> +               return dev_err_probe(&pdev->dev, ret, "Failed to register=
 Rockchip hwrng\n");

This is missing cleanup for pm_runtime_enable().

> +
> +       dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
> +
> +       return 0;
> +}
> +
> +static int rk_rng_remove(struct platform_device *pdev)

Return type of remove callback has been changed to void. This needs to be
updated.


ChenYu

> +{
> +       pm_runtime_disable(&pdev->dev);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int rk_rng_runtime_suspend(struct device *dev)
> +{
> +       struct rk_rng *rk_rng =3D dev_get_drvdata(dev);
> +
> +       rk_rng_cleanup(&rk_rng->rng);
> +
> +       return 0;
> +}
> +
> +static int rk_rng_runtime_resume(struct device *dev)
> +{
> +       struct rk_rng *rk_rng =3D dev_get_drvdata(dev);
> +
> +       return rk_rng_init(&rk_rng->rng);
> +}
> +#endif
> +
> +static const struct dev_pm_ops rk_rng_pm_ops =3D {
> +       SET_RUNTIME_PM_OPS(rk_rng_runtime_suspend,
> +                               rk_rng_runtime_resume, NULL)
> +       SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +                               pm_runtime_force_resume)
> +};
> +
> +static const struct of_device_id rk_rng_dt_match[] =3D {
> +       { .compatible =3D "rockchip,rk3568-rng", },
> +       { /* sentinel */ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, rk_rng_dt_match);
> +
> +static struct platform_driver rk_rng_driver =3D {
> +       .driver =3D {
> +               .name   =3D "rockchip-rng",
> +               .pm     =3D &rk_rng_pm_ops,
> +               .of_match_table =3D rk_rng_dt_match,
> +       },
> +       .probe  =3D rk_rng_probe,
> +       .remove =3D rk_rng_remove,
> +};
> +
> +module_platform_driver(rk_rng_driver);
> +
> +MODULE_DESCRIPTION("Rockchip True Random Number Generator driver");
> +MODULE_AUTHOR("Lin Jinhan <troy.lin@rock-chips.com>, Aurelien Jarno <aur=
elien@aurel32.net>");
> +MODULE_LICENSE("GPL");
> --
> 2.45.2
>

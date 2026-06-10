Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE803DB31B
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781102830; cv=pass; b=fiW8cMw/SAP2qLDzcBElZGEWOhqnEUgeUuDRG6Avjrwvn235E0Zr9x8lswqV3ADpjSDCwW4keBhezRtCa5tLESL1Vp2JUPWK+QE1aRjweaVQL4H3CIlhnKGhhfYJugI0JGhegWedpIm0NulZKHKkXxXNortG5wSu50bOi8e2Axc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781102830; c=relaxed/simple;
	bh=+3FXE/p9YBXMrAUbUzwT6v4+ObS7tZG8SkRsrbD6o3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Urqir4QV1188GqfXQ+KuaGlDYfc+hdnjWc72CXOjHK/A1rghtfs2qjlfVP+RHGwBl2QsXo6agVJpv08GvE9K+8fLeLT6YmWeVHwxzGCV/VK0AiKLSrSnwKQ0lB4iXgMlK91fFYV3/uEmjoElVnx8jpHmab0zQKdenPJD0i5kzIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IiqKsi7P; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IiqKsi7P"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-68ced97b6eeso9265844a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 07:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781102827; cv=none;
        d=google.com; s=arc-20240605;
        b=F0wpWS+KZQ9n1af0trVh2y0VXh5hifgBc1HzRU0/6WwhWOUrHpGYWAHWEghfdDf9+4
         IIcDqDGnI4gx6V/0aXGHbHvD0DfamUDLow15z0JViEvYvIQCzfs2eZM1bvfqZsy6DuPt
         UNSwmZk55RLRJ7Dd8fJU0wlGmAKSj3Ap5YOjApAf78QNqrlF5Q9sSOPNiE3iB9yP7iGm
         UVZ7ugz26q/GBS6/FvV9M9jC65WcIzZ7fM+76JpM+YhaxFmtNl83yqrh7nGgEf2IUyDU
         EEA/JmmHZKYq7BOVYsEzLn7Nnm9Osj9DkF+BYvl0h+VgeIjJ42BDfe8lYrf96cQuuD4M
         ShnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CyD3QFtMqslcSf2mJfFV+i9938i59wMcpqc0b8cm3Js=;
        fh=oXnSoDMGtUoFSMQtW/r2TZJsxklgBHwj8EaW97sOaJM=;
        b=EUqMockwxRQjHmLQMFA3tfj98/4fno5cUeqHcAgD4QBxURorxaCDrYbP1BUJIp2a+r
         r1JmYJedXNDUzkE47xGPblAFuEfEvYnfZIExVOBwi7W7P9SMFnOZ7i3DBT4IfiNqfzD6
         5W372l40zRLU1CYmeA56s6gdtEYRRDeovPGfd9XZbqp7Fwm0dyBkVnNjvuu4UqiI96Sm
         Z80S52uAMo5gpvBkVS3ZZuF+sifodsecBITVQpX+nOgrZvEL8cQb/8uRnp7YwVCLqMFD
         CGLsPsNQIDV4IazWgk/qG3d/Mo5HdOO0xs5LTR8eRHK31DB96TGuAl7wxiVdrCPYqJ/e
         m72w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1781102827; x=1781707627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyD3QFtMqslcSf2mJfFV+i9938i59wMcpqc0b8cm3Js=;
        b=IiqKsi7P71Va0DI/iw69+LJuLVGNLFdAlxr9pqD+ybzhk9nVL8q9gTbPzw0TlF3fFv
         vvaK6yMZ9RmohD+rTkGQgpKeVkliyXATGJAtsVO6QaBj7vwW1jUjx58fBblz94+9JlhG
         38mTHmL5Ju7cMOztkh3+e140ymCbu+hOJ1NpXlRSbK6eeeLtLv4xdo+TD3N1y44u356Z
         JPGiqEeypMTm5QHQ3J93/54+GLzKdWkByCcsGquuRiFJfRbgsMhmfTwa87CRKnVtAOil
         NnWgNhbiAXldCIG4G65PK28F376CGIP8YaVXfrFyFOenX7PNTW/MBUdYGFJXtgRlZ17N
         Cmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781102827; x=1781707627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CyD3QFtMqslcSf2mJfFV+i9938i59wMcpqc0b8cm3Js=;
        b=Rx452xiYDWgC5gwZnSoHmXpWZK1kBFzD69IsskEr5WWYlZ8YXpUaSvNQeEYcePosMc
         88Br8bOZwRBTsk3ATyHlis4F6I3PT/Lt78Upnj3Gn8+JdZyFNOFRZkhGikLFVHZnH2ld
         NMMGHjKclNFkFVQNAtZ85kTTIU05iGSMV6A1mb42FGaCeLXR9e9Yjz1QzqXBACubFUz6
         cCTl+cGhsv8wFzO9GdXNOXOI55mcpSzlCuk/F1z9+LQtvrpcP9GpDtWM5N/FnZOWHoKs
         dDoGdvWWF0aXbv/s0XjlzREST8niVZI4otOBP43d+dVM1rRCUteU91CJLvz/mrCJdxwz
         vGuQ==
X-Gm-Message-State: AOJu0Yw+t/8BGkQaIFT7onZSpd3axteInUmWfRVnr7bVqTpvq4nyv3XB
	5Kh2hi9JUdoWnL4bBGx0Nb5NKUuPANg/86Q9iJvy6BIPyzThh7vDlKEMalAj/h35AclYUFtepHB
	2N+j8At2U55WXKEtBTjLpJqS8bOmb/Yz4VmfHksXYlw==
X-Gm-Gg: Acq92OGr+YB04UmI0TYKri6BbRO4Rd2xZDdKiHdzc0s3rdNCcvTsSDswnpn4s5MYQQd
	i1YqzQdY2U1jD0mNkAcVMZt63v+B0X6+sGjUwubj2ccyL1Wbm4KTgEZBQDy5fCqXjIUQGOZ3Un2
	n+gbYikEtGMTRB/YbtTe5QZdhxaFnkBMydf1MUkSqj4HzW8u6Z1O4pzbo4QpqBOG4FpYYt1UOD/
	b5qgczlsNj8ObNzZcsKkBMxAlcFCxYOuvTbvA0DOIIynhcecZb1AqovY3RMtKSr3Ifq1MgxSqFD
	o4dpATv0Q0AiNLZ0pVHFGGZblYC1q2+cOSlxWQ3OxyTE0okxLtAACUYvjI2Y9FY=
X-Received: by 2002:a05:6402:5304:b0:68b:d82b:fbf with SMTP id
 4fb4d7f45d1cf-68fa53605f1mr12086168a12.26.1781102826290; Wed, 10 Jun 2026
 07:47:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260531175932.32171-1-ebiggers@kernel.org>
In-Reply-To: <20260531175932.32171-1-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 10 Jun 2026 15:46:54 +0100
X-Gm-Features: AVVi8Cf7Tc5WF83bzw-4SdQYGkXWDq5rzm0KTqS8yJHg2nLW9FVMA1Vw4CrWrzk
Message-ID: <CADrjBPo3BpSk49oasf_9g06xrBMkw+NiKo10xDKjWr8sJ+Zc-Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: exynos-rng - Remove exynos-rng driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-samsung-soc@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Sun, 31 May 2026 at 19:02, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This driver has no purpose.  It doesn't feed into the Linux RNG, nor
> does it implement the hwrng interface.  It is accessible only via the
> "rng" algorithm type of AF_ALG, which isn't used in practice.  Everyone
> uses either the Linux RNG, or rarely /dev/hwrng.
>
> Moreover, this is a PRNG whose only source of entropy is the 160-bit
> seed the user passes in.  So this can be used only by a user who already
> has a source of cryptographically secure random numbers, such as
> /dev/random.  Which they can, and do, just use in the first place.
>
> Just remove this driver.  There's no need to keep useless code around.
>
> Note that the other crypto_rng drivers in drivers/crypto/ are similarly
> unused and are being removed too.  This commit just handles exynos-rng.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

If the driver is being removed, should the binding documentation for
this driver not also be deleted (see
Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml)?

Peter

>  MAINTAINERS                         |   8 -
>  arch/arm/configs/exynos_defconfig   |   1 -
>  arch/arm/configs/multi_v7_defconfig |   1 -
>  drivers/crypto/Kconfig              |  18 --
>  drivers/crypto/Makefile             |   1 -
>  drivers/crypto/exynos-rng.c         | 399 ----------------------------
>  6 files changed, 428 deletions(-)
>  delete mode 100644 drivers/crypto/exynos-rng.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 882214b0e7db..a7f2762baac1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23701,18 +23701,10 @@ L:    linux-samsung-soc@vger.kernel.org
>  S:     Supported
>  F:     Documentation/devicetree/bindings/mailbox/google,gs101-mbox.yaml
>  F:     drivers/mailbox/exynos-mailbox.c
>  F:     include/linux/mailbox/exynos-message.h
>
> -SAMSUNG EXYNOS PSEUDO RANDOM NUMBER GENERATOR (RNG) DRIVER
> -M:     Krzysztof Kozlowski <krzk@kernel.org>
> -L:     linux-crypto@vger.kernel.org
> -L:     linux-samsung-soc@vger.kernel.org
> -S:     Maintained
> -F:     Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml
> -F:     drivers/crypto/exynos-rng.c
> -
>  SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
>  M:     =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>  L:     linux-samsung-soc@vger.kernel.org
>  S:     Maintained
>  F:     Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yam=
l
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_=
defconfig
> index 84070e9698e8..8b072a5c0a5e 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -362,11 +362,10 @@ CONFIG_CRYPTO_LZ4=3Dm
>  CONFIG_CRYPTO_USER_API_HASH=3Dm
>  CONFIG_CRYPTO_USER_API_SKCIPHER=3Dm
>  CONFIG_CRYPTO_USER_API_RNG=3Dm
>  CONFIG_CRYPTO_USER_API_AEAD=3Dm
>  CONFIG_CRYPTO_AES_ARM_BS=3Dm
> -CONFIG_CRYPTO_DEV_EXYNOS_RNG=3Dy
>  CONFIG_CRYPTO_DEV_S5P=3Dy
>  CONFIG_DMA_CMA=3Dy
>  CONFIG_CMA_SIZE_MBYTES=3D96
>  CONFIG_FONTS=3Dy
>  CONFIG_FONT_7x14=3Dy
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi=
_v7_defconfig
> index bcc9aabc1202..3672dd12df60 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -1327,11 +1327,10 @@ CONFIG_CRYPTO_GHASH_ARM_CE=3Dm
>  CONFIG_CRYPTO_AES=3Dm
>  CONFIG_CRYPTO_AES_ARM_BS=3Dm
>  CONFIG_CRYPTO_AES_ARM_CE=3Dm
>  CONFIG_CRYPTO_DEV_SUN4I_SS=3Dm
>  CONFIG_CRYPTO_DEV_FSL_CAAM=3Dm
> -CONFIG_CRYPTO_DEV_EXYNOS_RNG=3Dm
>  CONFIG_CRYPTO_DEV_S5P=3Dm
>  CONFIG_CRYPTO_DEV_ATMEL_AES=3Dm
>  CONFIG_CRYPTO_DEV_ATMEL_TDES=3Dm
>  CONFIG_CRYPTO_DEV_ATMEL_SHA=3Dm
>  CONFIG_CRYPTO_DEV_MARVELL_CESA=3Dm
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 3449b3c9c6ad..39c7b195bb33 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -373,25 +373,10 @@ config CRYPTO_DEV_SAHARA
>         select CRYPTO_ENGINE
>         help
>           This option enables support for the SAHARA HW crypto accelerato=
r
>           found in some Freescale i.MX chips.
>
> -config CRYPTO_DEV_EXYNOS_RNG
> -       tristate "Exynos HW pseudo random number generator support"
> -       depends on ARCH_EXYNOS || COMPILE_TEST
> -       depends on HAS_IOMEM
> -       select CRYPTO_RNG
> -       help
> -         This driver provides kernel-side support through the
> -         cryptographic API for the pseudo random number generator hardwa=
re
> -         found on Exynos SoCs.
> -
> -         To compile this driver as a module, choose M here: the
> -         module will be called exynos-rng.
> -
> -         If unsure, say Y.
> -
>  config CRYPTO_DEV_S5P
>         tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
>         depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
>         depends on HAS_IOMEM
>         select CRYPTO_AES
> @@ -402,20 +387,17 @@ config CRYPTO_DEV_S5P
>           algorithms execution.
>
>  config CRYPTO_DEV_EXYNOS_HASH
>         bool "Support for Samsung Exynos HASH accelerator"
>         depends on CRYPTO_DEV_S5P
> -       depends on !CRYPTO_DEV_EXYNOS_RNG && CRYPTO_DEV_EXYNOS_RNG!=3Dm
>         select CRYPTO_SHA1
>         select CRYPTO_MD5
>         select CRYPTO_SHA256
>         help
>           Select this to offload Exynos from HASH MD5/SHA1/SHA256.
>           This will select software SHA1, MD5 and SHA256 as they are
>           needed for small and zero-size messages.
> -         HASH algorithms will be disabled if EXYNOS_RNG
> -         is enabled due to hw conflict.
>
>  config CRYPTO_DEV_NX
>         bool "Support for IBM PowerPC Nest (NX) cryptographic acceleratio=
n"
>         depends on PPC64
>         help
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 283bbc650b5b..e141ab0dd741 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -9,11 +9,10 @@ obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) +=3D atmel-i2c.o
>  obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) +=3D atmel-ecc.o
>  obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) +=3D atmel-sha204a.o
>  obj-$(CONFIG_CRYPTO_DEV_CCP) +=3D ccp/
>  obj-$(CONFIG_CRYPTO_DEV_CCREE) +=3D ccree/
>  obj-$(CONFIG_CRYPTO_DEV_CHELSIO) +=3D chelsio/
> -obj-$(CONFIG_CRYPTO_DEV_EXYNOS_RNG) +=3D exynos-rng.o
>  obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) +=3D caam/
>  obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
>  obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) +=3D img-hash.o
>  obj-$(CONFIG_CRYPTO_DEV_MARVELL) +=3D marvell/
> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
> deleted file mode 100644
> index 2aaa98f9b44e..000000000000
> --- a/drivers/crypto/exynos-rng.c
> +++ /dev/null
> @@ -1,399 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * exynos-rng.c - Random Number Generator driver for the Exynos
> - *
> - * Copyright (c) 2017 Krzysztof Kozlowski <krzk@kernel.org>
> - *
> - * Loosely based on old driver from drivers/char/hw_random/exynos-rng.c:
> - * Copyright (C) 2012 Samsung Electronics
> - * Jonghwa Lee <jonghwa3.lee@samsung.com>
> - */
> -
> -#include <linux/clk.h>
> -#include <linux/crypto.h>
> -#include <linux/err.h>
> -#include <linux/io.h>
> -#include <linux/module.h>
> -#include <linux/mutex.h>
> -#include <linux/of.h>
> -#include <linux/platform_device.h>
> -
> -#include <crypto/internal/rng.h>
> -
> -#define EXYNOS_RNG_CONTROL             0x0
> -#define EXYNOS_RNG_STATUS              0x10
> -
> -#define EXYNOS_RNG_SEED_CONF           0x14
> -#define EXYNOS_RNG_GEN_PRNG            BIT(1)
> -
> -#define EXYNOS_RNG_SEED_BASE           0x140
> -#define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0x4)=
)
> -#define EXYNOS_RNG_OUT_BASE            0x160
> -#define EXYNOS_RNG_OUT(n)              (EXYNOS_RNG_OUT_BASE + (n * 0x4))
> -
> -/* EXYNOS_RNG_CONTROL bit fields */
> -#define EXYNOS_RNG_CONTROL_START       0x18
> -/* EXYNOS_RNG_STATUS bit fields */
> -#define EXYNOS_RNG_STATUS_SEED_SETTING_DONE    BIT(1)
> -#define EXYNOS_RNG_STATUS_RNG_DONE             BIT(5)
> -
> -/* Five seed and output registers, each 4 bytes */
> -#define EXYNOS_RNG_SEED_REGS           5
> -#define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
> -
> -enum exynos_prng_type {
> -       EXYNOS_PRNG_UNKNOWN =3D 0,
> -       EXYNOS_PRNG_EXYNOS4,
> -       EXYNOS_PRNG_EXYNOS5,
> -};
> -
> -/*
> - * Driver re-seeds itself with generated random numbers to hinder
> - * backtracking of the original seed.
> - *
> - * Time for next re-seed in ms.
> - */
> -#define EXYNOS_RNG_RESEED_TIME         1000
> -#define EXYNOS_RNG_RESEED_BYTES                65536
> -
> -/*
> - * In polling mode, do not wait infinitely for the engine to finish the =
work.
> - */
> -#define EXYNOS_RNG_WAIT_RETRIES                100
> -
> -/* Context for crypto */
> -struct exynos_rng_ctx {
> -       struct exynos_rng_dev           *rng;
> -};
> -
> -/* Device associated memory */
> -struct exynos_rng_dev {
> -       struct device                   *dev;
> -       enum exynos_prng_type           type;
> -       void __iomem                    *mem;
> -       struct clk                      *clk;
> -       struct mutex                    lock;
> -       /* Generated numbers stored for seeding during resume */
> -       u8                              seed_save[EXYNOS_RNG_SEED_SIZE];
> -       unsigned int                    seed_save_len;
> -       /* Time of last seeding in jiffies */
> -       unsigned long                   last_seeding;
> -       /* Bytes generated since last seeding */
> -       unsigned long                   bytes_seeding;
> -};
> -
> -static struct exynos_rng_dev *exynos_rng_dev;
> -
> -static u32 exynos_rng_readl(struct exynos_rng_dev *rng, u32 offset)
> -{
> -       return readl_relaxed(rng->mem + offset);
> -}
> -
> -static void exynos_rng_writel(struct exynos_rng_dev *rng, u32 val, u32 o=
ffset)
> -{
> -       writel_relaxed(val, rng->mem + offset);
> -}
> -
> -static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
> -                              const u8 *seed, unsigned int slen)
> -{
> -       u32 val;
> -       int i;
> -
> -       /* Round seed length because loop iterates over full register siz=
e */
> -       slen =3D ALIGN_DOWN(slen, 4);
> -
> -       if (slen < EXYNOS_RNG_SEED_SIZE)
> -               return -EINVAL;
> -
> -       for (i =3D 0; i < slen ; i +=3D 4) {
> -               unsigned int seed_reg =3D (i / 4) % EXYNOS_RNG_SEED_REGS;
> -
> -               val =3D seed[i] << 24;
> -               val |=3D seed[i + 1] << 16;
> -               val |=3D seed[i + 2] << 8;
> -               val |=3D seed[i + 3] << 0;
> -
> -               exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(seed_reg));
> -       }
> -
> -       val =3D exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
> -       if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
> -               dev_warn(rng->dev, "Seed setting not finished\n");
> -               return -EIO;
> -       }
> -
> -       rng->last_seeding =3D jiffies;
> -       rng->bytes_seeding =3D 0;
> -
> -       return 0;
> -}
> -
> -/*
> - * Start the engine and poll for finish.  Then read from output register=
s
> - * filling the 'dst' buffer up to 'dlen' bytes or up to size of generate=
d
> - * random data (EXYNOS_RNG_SEED_SIZE).
> - *
> - * On success: return 0 and store number of read bytes under 'read' addr=
ess.
> - * On error: return -ERRNO.
> - */
> -static int exynos_rng_get_random(struct exynos_rng_dev *rng,
> -                                u8 *dst, unsigned int dlen,
> -                                unsigned int *read)
> -{
> -       int retry =3D EXYNOS_RNG_WAIT_RETRIES;
> -
> -       if (rng->type =3D=3D EXYNOS_PRNG_EXYNOS4) {
> -               exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
> -                                 EXYNOS_RNG_CONTROL);
> -       } else if (rng->type =3D=3D EXYNOS_PRNG_EXYNOS5) {
> -               exynos_rng_writel(rng, EXYNOS_RNG_GEN_PRNG,
> -                                 EXYNOS_RNG_SEED_CONF);
> -       }
> -
> -       while (!(exynos_rng_readl(rng,
> -                       EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) =
&& --retry)
> -               cpu_relax();
> -
> -       if (!retry)
> -               return -ETIMEDOUT;
> -
> -       /* Clear status bit */
> -       exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
> -                         EXYNOS_RNG_STATUS);
> -       *read =3D min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
> -       memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
> -       rng->bytes_seeding +=3D *read;
> -
> -       return 0;
> -}
> -
> -/* Re-seed itself from time to time */
> -static void exynos_rng_reseed(struct exynos_rng_dev *rng)
> -{
> -       unsigned long next_seeding =3D rng->last_seeding + \
> -                                    msecs_to_jiffies(EXYNOS_RNG_RESEED_T=
IME);
> -       unsigned long now =3D jiffies;
> -       unsigned int read =3D 0;
> -       u8 seed[EXYNOS_RNG_SEED_SIZE];
> -
> -       if (time_before(now, next_seeding) &&
> -           rng->bytes_seeding < EXYNOS_RNG_RESEED_BYTES)
> -               return;
> -
> -       if (exynos_rng_get_random(rng, seed, sizeof(seed), &read))
> -               return;
> -
> -       exynos_rng_set_seed(rng, seed, read);
> -
> -       /* Let others do some of their job. */
> -       mutex_unlock(&rng->lock);
> -       mutex_lock(&rng->lock);
> -}
> -
> -static int exynos_rng_generate(struct crypto_rng *tfm,
> -                              const u8 *src, unsigned int slen,
> -                              u8 *dst, unsigned int dlen)
> -{
> -       struct exynos_rng_ctx *ctx =3D crypto_rng_ctx(tfm);
> -       struct exynos_rng_dev *rng =3D ctx->rng;
> -       unsigned int read =3D 0;
> -       int ret;
> -
> -       ret =3D clk_prepare_enable(rng->clk);
> -       if (ret)
> -               return ret;
> -
> -       mutex_lock(&rng->lock);
> -       do {
> -               ret =3D exynos_rng_get_random(rng, dst, dlen, &read);
> -               if (ret)
> -                       break;
> -
> -               dlen -=3D read;
> -               dst +=3D read;
> -
> -               exynos_rng_reseed(rng);
> -       } while (dlen > 0);
> -       mutex_unlock(&rng->lock);
> -
> -       clk_disable_unprepare(rng->clk);
> -
> -       return ret;
> -}
> -
> -static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
> -                          unsigned int slen)
> -{
> -       struct exynos_rng_ctx *ctx =3D crypto_rng_ctx(tfm);
> -       struct exynos_rng_dev *rng =3D ctx->rng;
> -       int ret;
> -
> -       ret =3D clk_prepare_enable(rng->clk);
> -       if (ret)
> -               return ret;
> -
> -       mutex_lock(&rng->lock);
> -       ret =3D exynos_rng_set_seed(ctx->rng, seed, slen);
> -       mutex_unlock(&rng->lock);
> -
> -       clk_disable_unprepare(rng->clk);
> -
> -       return ret;
> -}
> -
> -static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
> -{
> -       struct exynos_rng_ctx *ctx =3D crypto_tfm_ctx(tfm);
> -
> -       ctx->rng =3D exynos_rng_dev;
> -
> -       return 0;
> -}
> -
> -static struct rng_alg exynos_rng_alg =3D {
> -       .generate               =3D exynos_rng_generate,
> -       .seed                   =3D exynos_rng_seed,
> -       .seedsize               =3D EXYNOS_RNG_SEED_SIZE,
> -       .base                   =3D {
> -               .cra_name               =3D "stdrng",
> -               .cra_driver_name        =3D "exynos_rng",
> -               .cra_priority           =3D 300,
> -               .cra_ctxsize            =3D sizeof(struct exynos_rng_ctx)=
,
> -               .cra_module             =3D THIS_MODULE,
> -               .cra_init               =3D exynos_rng_kcapi_init,
> -       }
> -};
> -
> -static int exynos_rng_probe(struct platform_device *pdev)
> -{
> -       struct exynos_rng_dev *rng;
> -       int ret;
> -
> -       if (exynos_rng_dev)
> -               return -EEXIST;
> -
> -       rng =3D devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> -       if (!rng)
> -               return -ENOMEM;
> -
> -       rng->type =3D (uintptr_t)of_device_get_match_data(&pdev->dev);
> -
> -       mutex_init(&rng->lock);
> -
> -       rng->dev =3D &pdev->dev;
> -       rng->clk =3D devm_clk_get(&pdev->dev, "secss");
> -       if (IS_ERR(rng->clk)) {
> -               dev_err(&pdev->dev, "Couldn't get clock.\n");
> -               return PTR_ERR(rng->clk);
> -       }
> -
> -       rng->mem =3D devm_platform_ioremap_resource(pdev, 0);
> -       if (IS_ERR(rng->mem))
> -               return PTR_ERR(rng->mem);
> -
> -       platform_set_drvdata(pdev, rng);
> -
> -       exynos_rng_dev =3D rng;
> -
> -       ret =3D crypto_register_rng(&exynos_rng_alg);
> -       if (ret) {
> -               dev_err(&pdev->dev,
> -                       "Couldn't register rng crypto alg: %d\n", ret);
> -               exynos_rng_dev =3D NULL;
> -       }
> -
> -       return ret;
> -}
> -
> -static void exynos_rng_remove(struct platform_device *pdev)
> -{
> -       crypto_unregister_rng(&exynos_rng_alg);
> -
> -       exynos_rng_dev =3D NULL;
> -}
> -
> -static int __maybe_unused exynos_rng_suspend(struct device *dev)
> -{
> -       struct exynos_rng_dev *rng =3D dev_get_drvdata(dev);
> -       int ret;
> -
> -       /* If we were never seeded then after resume it will be the same =
*/
> -       if (!rng->last_seeding)
> -               return 0;
> -
> -       rng->seed_save_len =3D 0;
> -       ret =3D clk_prepare_enable(rng->clk);
> -       if (ret)
> -               return ret;
> -
> -       mutex_lock(&rng->lock);
> -
> -       /* Get new random numbers and store them for seeding on resume. *=
/
> -       exynos_rng_get_random(rng, rng->seed_save, sizeof(rng->seed_save)=
,
> -                             &(rng->seed_save_len));
> -
> -       mutex_unlock(&rng->lock);
> -
> -       dev_dbg(rng->dev, "Stored %u bytes for seeding on system resume\n=
",
> -               rng->seed_save_len);
> -
> -       clk_disable_unprepare(rng->clk);
> -
> -       return 0;
> -}
> -
> -static int __maybe_unused exynos_rng_resume(struct device *dev)
> -{
> -       struct exynos_rng_dev *rng =3D dev_get_drvdata(dev);
> -       int ret;
> -
> -       /* Never seeded so nothing to do */
> -       if (!rng->last_seeding)
> -               return 0;
> -
> -       ret =3D clk_prepare_enable(rng->clk);
> -       if (ret)
> -               return ret;
> -
> -       mutex_lock(&rng->lock);
> -
> -       ret =3D exynos_rng_set_seed(rng, rng->seed_save, rng->seed_save_l=
en);
> -
> -       mutex_unlock(&rng->lock);
> -
> -       clk_disable_unprepare(rng->clk);
> -
> -       return ret;
> -}
> -
> -static SIMPLE_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_suspend,
> -                        exynos_rng_resume);
> -
> -static const struct of_device_id exynos_rng_dt_match[] =3D {
> -       {
> -               .compatible =3D "samsung,exynos4-rng",
> -               .data =3D (const void *)EXYNOS_PRNG_EXYNOS4,
> -       }, {
> -               .compatible =3D "samsung,exynos5250-prng",
> -               .data =3D (const void *)EXYNOS_PRNG_EXYNOS5,
> -       },
> -       { },
> -};
> -MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
> -
> -static struct platform_driver exynos_rng_driver =3D {
> -       .driver         =3D {
> -               .name   =3D "exynos-rng",
> -               .pm     =3D &exynos_rng_pm_ops,
> -               .of_match_table =3D exynos_rng_dt_match,
> -       },
> -       .probe          =3D exynos_rng_probe,
> -       .remove         =3D exynos_rng_remove,
> -};
> -
> -module_platform_driver(exynos_rng_driver);
> -
> -MODULE_DESCRIPTION("Exynos H/W Random Number Generator driver");
> -MODULE_AUTHOR("Krzysztof Kozlowski <krzk@kernel.org>");
> -MODULE_LICENSE("GPL v2");
>
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
> --
> 2.54.0
>
>

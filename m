From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 18 Oct 2016 21:39:17 +0530
Message-ID: <CANc+2y63p1b5ATDY0oU4nLckk9CJhSs3CXGHy=NwoXn_awP9aA@mail.gmail.com>
References: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33789 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933622AbcJRQJV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 12:09:21 -0400
In-Reply-To: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

I have a few minor comments.

On 18 October 2016 at 18:04, Corentin Labbe <clabbe.montjoie@gmail.com> wrote:
> From: LABBE Corentin <clabbe.montjoie@gmail.com>
>
> The Security System have a PRNG.
> This patch add support for it as an hwrng.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig                   |  8 ++++
>  drivers/crypto/sunxi-ss/Makefile         |  1 +
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c  | 14 +++++++
>  drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c | 70 ++++++++++++++++++++++++++++++++
>  drivers/crypto/sunxi-ss/sun4i-ss.h       |  8 ++++
>  5 files changed, 101 insertions(+)
>  create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 4d2b81f..38f7aca 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -538,6 +538,14 @@ config CRYPTO_DEV_SUN4I_SS
>           To compile this driver as a module, choose M here: the module
>           will be called sun4i-ss.
>
> +config CRYPTO_DEV_SUN4I_SS_PRNG
> +       bool "Support for Allwinner Security System PRNG"
> +       depends on CRYPTO_DEV_SUN4I_SS
> +       select HW_RANDOM
> +       help
> +         This driver provides kernel-side support for the Pseudo-Random
> +         Number Generator found in the Security System.
> +
>  config CRYPTO_DEV_ROCKCHIP
>         tristate "Rockchip's Cryptographic Engine driver"
>         depends on OF && ARCH_ROCKCHIP
> diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
> index 8f4c7a2..ca049ee 100644
> --- a/drivers/crypto/sunxi-ss/Makefile
> +++ b/drivers/crypto/sunxi-ss/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sun4i-ss.o
>  sun4i-ss-y += sun4i-ss-core.o sun4i-ss-hash.o sun4i-ss-cipher.o
> +sun4i-ss-$(CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG) += sun4i-ss-hwrng.o
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> index 3ac6c6c..fa739de 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -359,6 +359,16 @@ static int sun4i_ss_probe(struct platform_device *pdev)
>                 }
>         }
>         platform_set_drvdata(pdev, ss);
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
> +       /* Voluntarily made the PRNG optional */
> +       err = sun4i_ss_hwrng_register(&ss->hwrng);
> +       if (!err)
> +               dev_info(ss->dev, "sun4i-ss PRNG loaded");
> +       else
> +               dev_err(ss->dev, "sun4i-ss PRNG failed");
> +#endif
> +
>         return 0;
>  error_alg:
>         i--;
> @@ -386,6 +396,10 @@ static int sun4i_ss_remove(struct platform_device *pdev)
>         int i;
>         struct sun4i_ss_ctx *ss = platform_get_drvdata(pdev);
>
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
> +       sun4i_ss_hwrng_remove(&ss->hwrng);
> +#endif
> +
>         for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
>                 switch (ss_algs[i].type) {
>                 case CRYPTO_ALG_TYPE_ABLKCIPHER:
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c b/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
> new file mode 100644
> index 0000000..95fadb7
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
> @@ -0,0 +1,70 @@
> +#include "sun4i-ss.h"
> +
> +static int sun4i_ss_hwrng_init(struct hwrng *hwrng)
> +{
> +       struct sun4i_ss_ctx *ss;
> +
> +       ss = container_of(hwrng, struct sun4i_ss_ctx, hwrng);
> +       get_random_bytes(ss->seed, SS_SEED_LEN);
> +
> +       return 0;
> +}
> +
> +static int sun4i_ss_hwrng_read(struct hwrng *hwrng, void *buf,
> +                              size_t max, bool wait)
> +{
> +       int i;
> +       u32 v;
> +       u32 *data = buf;
> +       const u32 mode = SS_OP_PRNG | SS_PRNG_CONTINUE | SS_ENABLED;
> +       size_t len;
> +       struct sun4i_ss_ctx *ss;
> +
> +       ss = container_of(hwrng, struct sun4i_ss_ctx, hwrng);
> +       len = min_t(size_t, SS_DATA_LEN, max);
> +
> +       spin_lock_bh(&ss->slock);

Is spin_lock_bh really required here? I could see it is being used in
sun4i-ss-hash.c but could not find any comment/info about the need.

> +       writel(mode, ss->base + SS_CTL);
> +
> +       /* write the seed */
> +       for (i = 0; i < SS_SEED_LEN / 4; i++)
> +               writel(ss->seed[i], ss->base + SS_KEY0 + i * 4);
> +       writel(mode | SS_PRNG_START, ss->base + SS_CTL);
> +
> +       /* Read the random data */
> +       readsl(ss->base + SS_TXFIFO, data, len / 4);
> +
> +       if (len % 4 > 0) {
> +               v = readl(ss->base + SS_TXFIFO);
> +               memcpy(data + len / 4, &v, len % 4);
> +       }

hwrng core asks for "rng_buffer_size()" of data which is a multiple of
4. So len % 4 will be 0. I think the above check is not required. Feel
free to correct if I am wrong.

> +       /* Update the seed */
> +       for (i = 0; i < SS_SEED_LEN / 4; i++) {
> +               v = readl(ss->base + SS_KEY0 + i * 4);
> +               ss->seed[i] = v;
> +       }
> +
> +       writel(0, ss->base + SS_CTL);
> +       spin_unlock_bh(&ss->slock);
> +       return len;
> +}
> +
> +int sun4i_ss_hwrng_register(struct hwrng *hwrng)
> +{
> +       hwrng->name = "sun4i Security System PRNG";
> +       hwrng->init = sun4i_ss_hwrng_init;
> +       hwrng->read = sun4i_ss_hwrng_read;
> +       hwrng->quality = 1000;
> +
> +       /* Cannot use devm_hwrng_register() since we need to hwrng_unregister
> +        * before stopping clocks/regulator
> +        */
> +       return hwrng_register(hwrng);
> +}
> +
> +void sun4i_ss_hwrng_remove(struct hwrng *hwrng)
> +{
> +       hwrng_unregister(hwrng);
> +}
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
> index f04c0f8..1297510 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss.h
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
> @@ -23,6 +23,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <linux/hw_random.h>
>  #include <crypto/md5.h>
>  #include <crypto/sha.h>
>  #include <crypto/hash.h>
> @@ -125,6 +126,9 @@
>  #define SS_RXFIFO_EMP_INT_ENABLE       (1 << 2)
>  #define SS_TXFIFO_AVA_INT_ENABLE       (1 << 0)
>
> +#define SS_SEED_LEN (192 / 8)
> +#define SS_DATA_LEN (160 / 8)
> +
>  struct sun4i_ss_ctx {
>         void __iomem *base;
>         int irq;
> @@ -134,6 +138,8 @@ struct sun4i_ss_ctx {
>         struct device *dev;
>         struct resource *res;
>         spinlock_t slock; /* control the use of the device */
> +       struct hwrng hwrng;
> +       u32 seed[SS_SEED_LEN / 4];
>  };
>
>  struct sun4i_ss_alg_template {
> @@ -199,3 +205,5 @@ int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
>                         unsigned int keylen);
>  int sun4i_ss_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
>                          unsigned int keylen);
> +int sun4i_ss_hwrng_register(struct hwrng *hwrng);
> +void sun4i_ss_hwrng_remove(struct hwrng *hwrng);
> --
> 2.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

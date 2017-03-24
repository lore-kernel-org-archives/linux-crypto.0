From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 2/5] crypto: stm32 - Support for STM32 CRC32 crypto module
Date: Fri, 24 Mar 2017 09:58:31 +0530
Message-ID: <CANc+2y4w=HhB230CD4MfxhvFZ2vM7Wsphz0zawhr0nVDSkREzQ@mail.gmail.com>
References: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com> <1490109211-4869-3-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
To: Fabien Dessenne <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33475 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753503AbdCXE2e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 00:28:34 -0400
In-Reply-To: <1490109211-4869-3-git-send-email-fabien.dessenne@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 March 2017 at 20:43, Fabien Dessenne <fabien.dessenne@st.com> wrote:
> This module registers a CRC32 ("Ethernet") and a CRC32C (Castagnoli)
> algorithm that make use of the STMicroelectronics STM32 crypto hardware.
>
> Theses algorithms are compatible with the little-endian generic ones.
> Both algorithms use ~0 as default seed (key).
> With CRC32C the output is xored with ~0.
>
> Using TCRYPT CRC32C speed test, this shows up to 900% speedup compared
> to the crc32c-generic algorithm.

Comparing with crc3c-generic alogrithm does not sound like a good
metric for someone who has to decide between hw crypto or not.
Wouldn't it be better if the comparison is between crc32 using NEON
with hw crypto module? It will help in choosing between hw crypto or
arch optimised crc routiene.

> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
> ---
>  drivers/crypto/Kconfig             |   2 +
>  drivers/crypto/Makefile            |   1 +
>  drivers/crypto/stm32/Kconfig       |   8 +
>  drivers/crypto/stm32/Makefile      |   2 +
>  drivers/crypto/stm32/stm32_crc32.c | 324 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 337 insertions(+)
>  create mode 100644 drivers/crypto/stm32/Kconfig
>  create mode 100644 drivers/crypto/stm32/Makefile
>  create mode 100644 drivers/crypto/stm32/stm32_crc32.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 473d312..922b323 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -619,4 +619,6 @@ config CRYPTO_DEV_BCM_SPU
>           Secure Processing Unit (SPU). The SPU driver registers ablkcipher,
>           ahash, and aead algorithms with the kernel cryptographic API.
>
> +source "drivers/crypto/stm32/Kconfig"
> +
>  endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 7396094..95bf2f9 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
>  obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
>  obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
>  obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
> +obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32/
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
> diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
> new file mode 100644
> index 0000000..792335b
> --- /dev/null
> +++ b/drivers/crypto/stm32/Kconfig
> @@ -0,0 +1,8 @@
> +config CRYPTO_DEV_STM32
> +       tristate "Support for STM32 crypto accelerators"
> +       depends on ARCH_STM32
> +       select CRYPTO_HASH
> +       help
> +          This enables support for the CRC32 hw accelerator which can be found
> +         on STMicroelectronis STM32 SOC.
> +
> diff --git a/drivers/crypto/stm32/Makefile b/drivers/crypto/stm32/Makefile
> new file mode 100644
> index 0000000..73b4c6e
> --- /dev/null
> +++ b/drivers/crypto/stm32/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_CRYPTO_DEV_STM32) += stm32_cryp.o
> +stm32_cryp-objs := stm32_crc32.o
> diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
> new file mode 100644
> index 0000000..7652822
> --- /dev/null
> +++ b/drivers/crypto/stm32/stm32_crc32.c
> @@ -0,0 +1,324 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2017
> + * Author: Fabien Dessenne <fabien.dessenne@st.com>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/bitrev.h>
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include <crypto/internal/hash.h>
> +
> +#include <asm/unaligned.h>
> +
> +#define DRIVER_NAME             "stm32-crc32"
> +#define CHKSUM_DIGEST_SIZE      4
> +#define CHKSUM_BLOCK_SIZE       1
> +
> +/* Registers */
> +#define CRC_DR                  0x00000000
> +#define CRC_CR                  0x00000008
> +#define CRC_INIT                0x00000010
> +#define CRC_POL                 0x00000014
> +
> +/* Registers values */
> +#define CRC_CR_RESET            BIT(0)
> +#define CRC_CR_REVERSE          (BIT(7) | BIT(6) | BIT(5))
> +#define CRC_INIT_DEFAULT        0xFFFFFFFF
> +
> +/* Polynomial reversed */
> +#define POLY_CRC32              0xEDB88320
> +#define POLY_CRC32C             0x82F63B78
> +
> +struct stm32_crc {
> +       struct list_head list;
> +       struct device    *dev;
> +       void __iomem     *regs;
> +       struct clk       *clk;
> +       u8               pending_data[sizeof(u32)];
> +       size_t           nb_pending_bytes;
> +};
> +
> +struct stm32_crc_list {
> +       struct list_head dev_list;
> +       spinlock_t       lock; /* protect dev_list */
> +};
> +
> +static struct stm32_crc_list crc_list = {
> +       .dev_list = LIST_HEAD_INIT(crc_list.dev_list),
> +       .lock     = __SPIN_LOCK_UNLOCKED(crc_list.lock),
> +};
> +
> +struct stm32_crc_ctx {
> +       u32 key;
> +       u32 poly;
> +};
> +
> +struct stm32_crc_desc_ctx {
> +       u32    partial; /* crc32c: partial in first 4 bytes of that struct */
> +       struct stm32_crc *crc;
> +};
> +
> +static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
> +{
> +       struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
> +
> +       mctx->key = CRC_INIT_DEFAULT;
> +       mctx->poly = POLY_CRC32;
> +       return 0;
> +}
> +
> +static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
> +{
> +       struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
> +
> +       mctx->key = CRC_INIT_DEFAULT;
> +       mctx->poly = POLY_CRC32C;
> +       return 0;
> +}
> +
> +static int stm32_crc_setkey(struct crypto_shash *tfm, const u8 *key,
> +                           unsigned int keylen)
> +{
> +       struct stm32_crc_ctx *mctx = crypto_shash_ctx(tfm);
> +
> +       if (keylen != sizeof(u32)) {
> +               crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +               return -EINVAL;
> +       }
> +
> +       mctx->key = get_unaligned_le32(key);
> +       return 0;
> +}
> +
> +static int stm32_crc_init(struct shash_desc *desc)
> +{
> +       struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
> +       struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
> +       struct stm32_crc *crc;
> +
> +       spin_lock_bh(&crc_list.lock);
> +       list_for_each_entry(crc, &crc_list.dev_list, list) {
> +               ctx->crc = crc;
> +               break;
> +       }
> +       spin_unlock_bh(&crc_list.lock);
> +
> +       /* Reset, set key, poly and configure in bit reverse mode */
> +       writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
> +       writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
> +       writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
> +
> +       /* Store partial result */
> +       ctx->partial = readl(ctx->crc->regs + CRC_DR);
> +       ctx->crc->nb_pending_bytes = 0;
> +
> +       return 0;
> +}
> +
> +static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
> +                           unsigned int length)
> +{
> +       struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
> +       struct stm32_crc *crc = ctx->crc;
> +       u32 *d32;
> +       unsigned int i;
> +
> +       if (unlikely(crc->nb_pending_bytes)) {
> +               while (crc->nb_pending_bytes != sizeof(u32) && length) {
> +                       /* Fill in pending data */
> +                       crc->pending_data[crc->nb_pending_bytes++] = *(d8++);
> +                       length--;
> +               }
> +
> +               if (crc->nb_pending_bytes == sizeof(u32)) {
> +                       /* Process completed pending data */
> +                       writel(*(u32 *)crc->pending_data, crc->regs + CRC_DR);
> +                       crc->nb_pending_bytes = 0;
> +               }
> +       }
> +
> +       d32 = (u32 *)d8;
> +       for (i = 0; i < length >> 2; i++)
> +               /* Process 32 bits data */
> +               writel(*(d32++), crc->regs + CRC_DR);
> +
> +       /* Store partial result */
> +       ctx->partial = readl(crc->regs + CRC_DR);
> +
> +       /* Check for pending data (non 32 bits) */
> +       length &= 3;
> +       if (likely(!length))
> +               return 0;
> +
> +       if ((crc->nb_pending_bytes + length) >= sizeof(u32)) {
> +               /* Shall not happen */
> +               dev_err(crc->dev, "Pending data overflow\n");
> +               return -EINVAL;
> +       }
> +
> +       d8 = (const u8 *)d32;
> +       for (i = 0; i < length; i++)
> +               /* Store pending data */
> +               crc->pending_data[crc->nb_pending_bytes++] = *(d8++);
> +
> +       return 0;
> +}
> +
> +static int stm32_crc_final(struct shash_desc *desc, u8 *out)
> +{
> +       struct stm32_crc_desc_ctx *ctx = shash_desc_ctx(desc);
> +       struct stm32_crc_ctx *mctx = crypto_shash_ctx(desc->tfm);
> +
> +       /* Send computed CRC */
> +       put_unaligned_le32(mctx->poly == POLY_CRC32C ?
> +                          ~ctx->partial : ctx->partial, out);
> +
> +       return 0;
> +}
> +
> +static int stm32_crc_finup(struct shash_desc *desc, const u8 *data,
> +                          unsigned int length, u8 *out)
> +{
> +       return stm32_crc_update(desc, data, length) ?:
> +              stm32_crc_final(desc, out);
> +}
> +
> +static int stm32_crc_digest(struct shash_desc *desc, const u8 *data,
> +                           unsigned int length, u8 *out)
> +{
> +       return stm32_crc_init(desc) ?: stm32_crc_finup(desc, data, length, out);
> +}
> +
> +static struct shash_alg algs[] = {
> +       /* CRC-32 */
> +       {
> +               .setkey         = stm32_crc_setkey,
> +               .init           = stm32_crc_init,
> +               .update         = stm32_crc_update,
> +               .final          = stm32_crc_final,
> +               .finup          = stm32_crc_finup,
> +               .digest         = stm32_crc_digest,
> +               .descsize       = sizeof(struct stm32_crc_desc_ctx),
> +               .digestsize     = CHKSUM_DIGEST_SIZE,
> +               .base           = {
> +                       .cra_name               = "crc32",
> +                       .cra_driver_name        = DRIVER_NAME,
> +                       .cra_priority           = 200,
> +                       .cra_blocksize          = CHKSUM_BLOCK_SIZE,
> +                       .cra_alignmask          = 3,
> +                       .cra_ctxsize            = sizeof(struct stm32_crc_ctx),
> +                       .cra_module             = THIS_MODULE,
> +                       .cra_init               = stm32_crc32_cra_init,
> +               }
> +       },
> +       /* CRC-32Castagnoli */
> +       {
> +               .setkey         = stm32_crc_setkey,
> +               .init           = stm32_crc_init,
> +               .update         = stm32_crc_update,
> +               .final          = stm32_crc_final,
> +               .finup          = stm32_crc_finup,
> +               .digest         = stm32_crc_digest,
> +               .descsize       = sizeof(struct stm32_crc_desc_ctx),
> +               .digestsize     = CHKSUM_DIGEST_SIZE,
> +               .base           = {
> +                       .cra_name               = "crc32c",
> +                       .cra_driver_name        = DRIVER_NAME,
> +                       .cra_priority           = 200,
> +                       .cra_blocksize          = CHKSUM_BLOCK_SIZE,
> +                       .cra_alignmask          = 3,
> +                       .cra_ctxsize            = sizeof(struct stm32_crc_ctx),
> +                       .cra_module             = THIS_MODULE,
> +                       .cra_init               = stm32_crc32c_cra_init,
> +               }
> +       }
> +};

Will be better if the priority is based on benchmark result. ARM arch
optimised crc32 also defines its priority as 200. Choose a higher
priority if the hw crypto is either faster or consumes less power.

Regards,
PrasannaKumar

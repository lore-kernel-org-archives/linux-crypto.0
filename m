From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Add crypto driver support for some MediaTek chips
Date: Fri, 2 Dec 2016 09:18:36 +0100
Message-ID: <20161202081836.GA20128@Red>
References: <1480649205-52695-1-git-send-email-ryder.lee@mediatek.com>
 <1480649205-52695-2-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Sean Wang <sean.wnag-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480649205-52695-2-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello

I have some minor comment inline

On Fri, Dec 02, 2016 at 11:26:44AM +0800, Ryder Lee wrote:
> This adds support for the MediaTek hardware accelerator on
> mt7623/mt2701/mt8521p SoC.
> 
> This driver currently implement:
> - SHA1 and SHA2 family(HMAC) hash alogrithms.
> - AES block cipher in CBC/ECB mode with 128/196/256 bits keys.

I see also a PRNG but is seems not really used.

> 
> Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/crypto/Kconfig                 |   17 +
>  drivers/crypto/Makefile                |    1 +
>  drivers/crypto/mediatek/Makefile       |    2 +
>  drivers/crypto/mediatek/mtk-aes.c      |  734 +++++++++++++++++
>  drivers/crypto/mediatek/mtk-platform.c |  575 +++++++++++++
>  drivers/crypto/mediatek/mtk-platform.h |  230 ++++++
>  drivers/crypto/mediatek/mtk-regs.h     |  194 +++++
>  drivers/crypto/mediatek/mtk-sha.c      | 1384 ++++++++++++++++++++++++++++++++
>  8 files changed, 3137 insertions(+)
>  create mode 100644 drivers/crypto/mediatek/Makefile
>  create mode 100644 drivers/crypto/mediatek/mtk-aes.c
>  create mode 100644 drivers/crypto/mediatek/mtk-platform.c
>  create mode 100644 drivers/crypto/mediatek/mtk-platform.h
>  create mode 100644 drivers/crypto/mediatek/mtk-regs.h
>  create mode 100644 drivers/crypto/mediatek/mtk-sha.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 4d2b81f..5d9c803 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -553,6 +553,23 @@ config CRYPTO_DEV_ROCKCHIP
>  	  This driver interfaces with the hardware crypto accelerator.
>  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
>  
> +config CRYPTO_DEV_MEDIATEK
> +	tristate "MediaTek's Cryptographic Engine driver"
> +	depends on ARM && ARCH_MEDIATEK
> +	select NEON
> +	select KERNEL_MODE_NEON
> +	select ARM_CRYPTO
> +	select CRYPTO_AES
> +	select CRYPTO_BLKCIPHER
> +	select CRYPTO_SHA1_ARM_NEON
> +	select CRYPTO_SHA256_ARM
> +	select CRYPTO_SHA512_ARM
> +	select CRYPTO_HMAC

Why do you select accelerated algos ?
Adding COMPILE_TEST could be helpfull also.

[...]
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/scatterlist.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/algapi.h>
> +#include <crypto/aes.h>
> +#include "mtk-platform.h"
> +#include "mtk-regs.h"
> +

Sort headers in alphabetical order

[...]
> +
> +	mtk_aes_unregister_algs();
> +	mtk_aes_record_free(cryp);
> +}
> +EXPORT_SYMBOL(mtk_cipher_alg_release);

Why not EXPORT_SYMBOL_GPL ?
Furthermore do you really need it to be exported ?

[...]
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include "mtk-platform.h"
> +#include "mtk-regs.h"
> +

Sort headers in alphabetical order

[...]
> +
> +static void mtk_prng_reseed(struct mtk_cryp *cryp)
> +{
> +	/* 8 words to seed the PRNG to provide IVs */
> +	void __iomem *base = cryp->base;
> +	const u32 prng_key[8] = {0x48c24cfd, 0x6c07f742,
> +				0xaee75681, 0x0f27c239,
> +				0x79947198, 0xe2991275,
> +				0x21ac3c7c, 0xd008c4b4};

Why do you seed with thoses constant ?

[...]
> +
> +static int mtk_accelerator_init(struct mtk_cryp *cryp)
> +{
> +	int i, err;
> +
> +	/* Initialize advanced interrupt controller(AIC) */
> +	for (i = 0; i < 5; i++) {

I see this 5 for interrupt away, so perhaps a define could be used

[...]

here 

> +	for (i = 0; i < 5; i++) {
> +		cryp->irq[i] = platform_get_irq(pdev, i);
> +		if (cryp->irq[i] < 0) {
> +			dev_err(cryp->dev, "no IRQ:%d resource info\n", i);
> +			return -ENXIO;
> +		}
> +	}
[...]

> +#ifndef __MTK_PLATFORM_H_
> +#define __MTK_PLATFORM_H_
> +
> +#include <linux/crypto.h>
> +#include <crypto/internal/hash.h>
> +#include <linux/interrupt.h>

Sort headers in alphabetical order

[...]
> +#define MTK_DESC_FIRST		BIT(23)
> +#define MTK_DESC_BUF_LEN(x)	((x) & 0x1ffff)
> +#define MTK_DESC_CT_LEN(x)	(((x) & 0xff) << 24)
> +
> +#define WORD(x)			((x) >> 2)

dangerous and ambigous define

[...]
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/algapi.h>
> +#include <crypto/sha.h>
> +#include <crypto/internal/hash.h>

Sort headers in alphabetical order
[...]

Generally more function comment could be helpfull.

Regards
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Lionel DEBIEVE <lionel.debieve@st.com>
Subject: Re: [PATCH v5] crypto : stm32 - Add STM32F4 CRC32 support
Date: Wed, 16 Aug 2017 08:45:12 +0000
Message-ID: <f3752a1c-5eca-344d-ee04-1f840c877f75@st.com>
References: <408e795dea80840a909bab590ea498848e5e3800.1501766734.git.cosardindar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Alexandre TORGUE <alexandre.torgue@st.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Fabien DESSENNE <fabien.dessenne@st.com>,
 "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Cosar Dindar <cosardindar@gmail.com>, "herbert@gondor.apana.org.au"
 <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <408e795dea80840a909bab590ea498848e5e3800.1501766734.git.cosardindar@gmail.com>
Content-Language: en-US
Content-ID: <306493D5B2369143A3DBD67EBA66D170@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Cosar,
Sorry for the delay to feedback.
This implementation is in the good way. But it should be better to use 
platform data and use array with type of algs instead of
duplicating the algo description for each platform. If we add a new 
platform, with another type of crc, we will again duplicate the section.
This is how I did it in stm32-hash.c.
BR,
Lionel

On 08/03/2017 03:46 PM, Cosar Dindar wrote:
> This patch adds CRC (CRC32 Crypto) support for STM32F4 series.
>
> As an hardware limitation polynomial and key setting are not supported.
> They are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).
> CRC32C Castagnoli algorithm is not used.
>
> Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> ---
> Changes in v5:
>    - shash_alg struct definitons are defined seperately according to
>      the platform type.
> Changes in v4:
>    - Edited patch summary.
> Changes in v3:
>    - Rearranged patch order to fix build test error.
> Changes in v2:
>    - Patchset created instead of one patch.
>
>   drivers/crypto/stm32/stm32_crc32.c | 101 ++++++++++++++++++++++++++++++++-----
>   1 file changed, 89 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
> index ec83b1e..39b28b8 100644
> --- a/drivers/crypto/stm32/stm32_crc32.c
> +++ b/drivers/crypto/stm32/stm32_crc32.c
> @@ -1,12 +1,14 @@
>   /*
>    * Copyright (C) STMicroelectronics SA 2017
>    * Author: Fabien Dessenne <fabien.dessenne@st.com>
> + * Author: Cosar Dindar <cosardindar@gmail.com>
>    * License terms:  GNU General Public License (GPL), version 2
>    */
>   
>   #include <linux/bitrev.h>
>   #include <linux/clk.h>
>   #include <linux/module.h>
> +#include <linux/of.h>
>   #include <linux/platform_device.h>
>   
>   #include <crypto/internal/hash.h>
> @@ -37,8 +39,12 @@ struct stm32_crc {
>   	struct device    *dev;
>   	void __iomem     *regs;
>   	struct clk       *clk;
> +	struct shash_alg *algs;
>   	u8               pending_data[sizeof(u32)];
>   	size_t           nb_pending_bytes;
> +	bool             key_support;
> +	bool             poly_support;
> +	bool             reverse_support;
>   };
>   
>   struct stm32_crc_list {
> @@ -106,13 +112,31 @@ static int stm32_crc_init(struct shash_desc *desc)
>   	}
>   	spin_unlock_bh(&crc_list.lock);
>   
> -	/* Reset, set key, poly and configure in bit reverse mode */
> -	writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
> -	writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
> -	writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
> +	/* set key */
> +	if (ctx->crc->key_support) {
> +		writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
> +	} else if (mctx->key != CRC_INIT_DEFAULT) {
> +		dev_err(ctx->crc->dev, "Unsupported key value! Should be: 0x%x\n",
> +			CRC_INIT_DEFAULT);
> +		return -EINVAL;
> +	}
> +
> +	/* set poly */
> +	if (ctx->crc->poly_support)
> +		writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
> +
> +	/* reset and configure in bit reverse mode if supported */
> +	if (ctx->crc->reverse_support)
> +		writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
> +	else
> +		writel(CRC_CR_RESET, ctx->crc->regs + CRC_CR);
> +
> +	/* store partial result */
> +	if (!ctx->crc->reverse_support)
> +		ctx->partial = bitrev32(readl(crc->regs + CRC_DR));
> +	else
> +		ctx->partial = readl(ctx->crc->regs + CRC_DR);
>   
> -	/* Store partial result */
> -	ctx->partial = readl(ctx->crc->regs + CRC_DR);
>   	ctx->crc->nb_pending_bytes = 0;
>   
>   	return 0;
> @@ -135,7 +159,12 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
>   
>   		if (crc->nb_pending_bytes == sizeof(u32)) {
>   			/* Process completed pending data */
> -			writel(*(u32 *)crc->pending_data, crc->regs + CRC_DR);
> +			if (!ctx->crc->reverse_support)
> +				writel(bitrev32(*(u32 *)crc->pending_data),
> +				       crc->regs + CRC_DR);
> +			else
> +				writel(*(u32 *)crc->pending_data,
> +				       crc->regs + CRC_DR);
>   			crc->nb_pending_bytes = 0;
>   		}
>   	}
> @@ -143,10 +172,16 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
>   	d32 = (u32 *)d8;
>   	for (i = 0; i < length >> 2; i++)
>   		/* Process 32 bits data */
> -		writel(*(d32++), crc->regs + CRC_DR);
> +		if (!ctx->crc->reverse_support)
> +			writel(bitrev32(*(d32++)), crc->regs + CRC_DR);
> +		else
> +			writel(*(d32++), crc->regs + CRC_DR);
>   
>   	/* Store partial result */
> -	ctx->partial = readl(crc->regs + CRC_DR);
> +	if (!ctx->crc->reverse_support)
> +		ctx->partial = bitrev32(readl(crc->regs + CRC_DR));
> +	else
> +		ctx->partial = readl(crc->regs + CRC_DR);
>   
>   	/* Check for pending data (non 32 bits) */
>   	length &= 3;
> @@ -192,7 +227,7 @@ static int stm32_crc_digest(struct shash_desc *desc, const u8 *data,
>   	return stm32_crc_init(desc) ?: stm32_crc_finup(desc, data, length, out);
>   }
>   
> -static struct shash_alg algs[] = {
> +static struct shash_alg algs_for_f7[] = {
>   	/* CRC-32 */
>   	{
>   		.setkey         = stm32_crc_setkey,
> @@ -237,12 +272,37 @@ static struct shash_alg algs[] = {
>   	}
>   };
>   
> +static struct shash_alg algs_for_f4[] = {
> +	/* CRC-32 */
> +	{
> +		.setkey         = stm32_crc_setkey,
> +		.init           = stm32_crc_init,
> +		.update         = stm32_crc_update,
> +		.final          = stm32_crc_final,
> +		.finup          = stm32_crc_finup,
> +		.digest         = stm32_crc_digest,
> +		.descsize       = sizeof(struct stm32_crc_desc_ctx),
> +		.digestsize     = CHKSUM_DIGEST_SIZE,
> +		.base           = {
> +			.cra_name               = "crc32",
> +			.cra_driver_name        = DRIVER_NAME,
> +			.cra_priority           = 200,
> +			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
> +			.cra_alignmask          = 3,
> +			.cra_ctxsize            = sizeof(struct stm32_crc_ctx),
> +			.cra_module             = THIS_MODULE,
> +			.cra_init               = stm32_crc32_cra_init,
> +		}
> +	}
> +};
> +
>   static int stm32_crc_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct stm32_crc *crc;
>   	struct resource *res;
>   	int ret;
> +	int algs_size;
>   
>   	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
>   	if (!crc)
> @@ -269,13 +329,29 @@ static int stm32_crc_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> +	/* set key, poly and reverse support if device is of F7 series */
> +	if (of_device_is_compatible(crc->dev->of_node, "st,stm32f7-crc")) {
> +		crc->key_support = true;
> +		crc->poly_support = true;
> +		crc->reverse_support = true;
> +	}
> +
>   	platform_set_drvdata(pdev, crc);
>   
>   	spin_lock(&crc_list.lock);
>   	list_add(&crc->list, &crc_list.dev_list);
>   	spin_unlock(&crc_list.lock);
>   
> -	ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
> +	/* For F4 series only CRC32 algorithm will be used */
> +	if (of_device_is_compatible(crc->dev->of_node, "st,stm32f4-crc")) {
> +		crc->algs = algs_for_f4;
> +		algs_size = ARRAY_SIZE(algs_for_f4);
> +	} else {
> +		crc->algs = algs_for_f7;
> +		algs_size = ARRAY_SIZE(algs_for_f7);
> +	}
> +
> +	ret = crypto_register_shashes(crc->algs, algs_size);
>   	if (ret) {
>   		dev_err(dev, "Failed to register\n");
>   		clk_disable_unprepare(crc->clk);
> @@ -295,7 +371,7 @@ static int stm32_crc_remove(struct platform_device *pdev)
>   	list_del(&crc->list);
>   	spin_unlock(&crc_list.lock);
>   
> -	crypto_unregister_shash(algs);
> +	crypto_unregister_shash(crc->algs);
>   
>   	clk_disable_unprepare(crc->clk);
>   
> @@ -304,6 +380,7 @@ static int stm32_crc_remove(struct platform_device *pdev)
>   
>   static const struct of_device_id stm32_dt_ids[] = {
>   	{ .compatible = "st,stm32f7-crc", },
> +	{ .compatible = "st,stm32f4-crc", },
>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, stm32_dt_ids);

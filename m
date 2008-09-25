From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: AMCC Crypto4xx Device Driver
Date: Thu, 25 Sep 2008 10:54:14 -0500
Message-ID: <20080925105414.15ed7a89.kim.phillips@freescale.com>
References: <0CA0A16855646F4FA96D25A158E299D6050D18FF@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"James Hsiao" <jhsiao@amcc.com>, <linux-crypto@vger.kernel.org>
To: "Loc Ho" <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:40120 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbYIYPtj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Sep 2008 11:49:39 -0400
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6050D18FF@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 19 Sep 2008 16:46:43 -0700
"Loc Ho" <lho@amcc.com> wrote:

>  arch/powerpc/boot/dts/kilauea.dts       |   10 +

powerpc dts patches are reviewed on linuxppc-dev list.  For ppc4xx, it
looks like new bindings are accompanied with a patch to
Documentation/powerpc/booting-without-of.txt.

> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> +		CRYPTO: crypto@ef700000 {
> +			device_type = "crypto";	

device_type is deprecated, remove.

> +			compatible = "crypto4xx-crypto", "amcc,crypto4xx-crypto";

compatible values should always contain the vendor prefix. is crypto
occuring twice for a reason?  how about just a single entry:
"amcc,ppc4xx-crypto"?

> @@ -342,5 +351,6 @@
>  				0x0 0x0 0x0 0x3 &UIC2 0xd 0x4 /* swizzled int C */
>  				0x0 0x0 0x0 0x4 &UIC2 0xe 0x4 /* swizzled int D */>;
>  		};
> +

whitespace change not necessary

> +config CRYPTO_DEV_PPC4XX
> +	tristate "Driver AMCC PPC4XX crypto accelerator"
> +	select CRYPTO_HASH
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_BLKCIPHER

this looks like an ABLKCIPHER driver (BLKCIPHER depends on
ABLKCIPHER).  plus, shouldn't this depend on PPC and 4xx too?

> diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c

> +#include <crypto/internal/hash.h>

does something need to move up to include/crypto/hash.h?

> +	/* Application only provided ptr for the rctx
> +	* we alloc memory for it. And along we alloc memory for the sa in it */

please see Documentation/CodingStyle for how to format comments.

> +	ctx->use_rctx = 1;
> +	rc = crypto4xx_alloc_sa_rctx(ctx, rctx);
> +	if (rc)
> +		goto err_nomem;
> +	sa  = (struct dynamic_sa_ctl *)(rctx->sa_out);
> +	offset = get_dynamic_sa_offset_iv_field(rctx);

where is offset being used?

> +	/* copy req->iv to state_record->iv */
> +	if (req->info)
> +		crypto4xx_memcpy_le(rctx->state_record, req->info,
> +				get_dynamic_sa_iv_size(rctx));
> +	else
> +		memset(rctx->state_record, 0, get_dynamic_sa_iv_size(rctx));
> +	sa->sa_command_0.bf.dir = CRYPTO_OUTBOUND;
> +	rctx->hash_final = 0;
> +	rctx->is_hash = 0;
> +	rctx->pd_ctl = 0x1;
> +	rctx->direction = CRYPTO_OUTBOUND;
> +	return crypto4xx_setup_crypto(&req->base);
> +
> +err_nomem:
> +	return -ENOMEM;

not much going on here; doing the return straight up instead of the
goto indirection is easier to read.

> +static inline int crypto4xx_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct crypto4xx_ctx *rctx = ablkcipher_request_ctx(req);
> +	struct dynamic_sa_ctl *sa  = NULL;
> +	int    rc;
> +	u32 offset;
> +
> +	/* Application only provided ptr for the rctx
> +	* we alloc memory for it. And along we alloc memory for the sa in it*/
> +	ctx->use_rctx = 1;
> +	rc = crypto4xx_alloc_sa_rctx(ctx, rctx);
> +	if (rc != 0)
> +		goto err_nomem;

same here (and other places).

> +	sa  = (struct dynamic_sa_ctl *)(rctx->sa_in);
> +	offset = get_dynamic_sa_offset_iv_field(rctx);

again, can't see offset being used here.

> +	/* copy req->iv to state_record->iv */
> +	if (req->info)
> +		crypto4xx_memcpy_le(rctx->state_record, req->info,
> +				get_dynamic_sa_iv_size(rctx));
> +	else
> +		memset(rctx->state_record, 0, get_dynamic_sa_iv_size(rctx));
> +	sa->sa_command_0.bf.dir = CRYPTO_INBOUND;
> +	rctx->hash_final = 0;
> +	rctx->is_hash = 0;
> +	rctx->pd_ctl = 1;
> +	rctx->direction = CRYPTO_INBOUND;
> +
> +	return crypto4xx_setup_crypto(&req->base);
> +
> +err_nomem:
> +	return -ENOMEM;
> +}
> +/**
> + * Support Crypto Algorithms
> + */
> +struct crypto_alg crypto4xx_basic_alg[] = {
> +
> +	/* Crypto AES modes */
> +	{.cra_name 		= "cbc(aes)",
> +	 .cra_driver_name 	= "cbc-aes",

"cbc-aes-ppc4xx"?

> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 16,	/* 128-bits block */
> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type 		= &crypto_ablkcipher_type,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u 		= {.ablkcipher = {
> +	 .min_keysize 		= 16,	/* AES min key size is 128-bits */
> +	 .max_keysize 		= 32,	/* AES max key size is 256-bits */
> +	 .ivsize 		= 16,	/* IV size is 16 bytes */
> +	 .setkey 		= crypto4xx_setkey_aes_cbc,
> +	 .encrypt 		= crypto4xx_encrypt,
> +	 .decrypt 		= crypto4xx_decrypt,
> +	 } }
> +	},
> +	/* Hash SHA1, SHA2 */
> +	{.cra_name 		= "sha1",
> +	 .cra_driver_name 	= "sha1",

-ppc4xx.

> +	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
> +	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> +	 .cra_blocksize 	= 64,	/* SHA1 block size is 512-bits */
> +	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
> +	 .cra_alignmask 	= 0,
> +	 .cra_type   		= &crypto_ahash_type,
> +	 .cra_init 		= crypto4xx_sha1_alg_init,
> +	 .cra_module 		= THIS_MODULE,
> +	 .cra_u  		= {.ahash = {
> +	 .digestsize 		= 20,	/* Disgest is 160-bits */
> +	 .init   		= crypto4xx_hash_init,
> +	 .update 		= crypto4xx_hash_update,
> +	 .final  		= crypto4xx_hash_final,
> +	 .digest 		= crypto4xx_hash_digest,
> +	 } }
> +	},
> +	/* Terminator */
> +	{.cra_name = "" }

save space and use ARRAY_SIZE

> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> +struct crypto4xx_core_device lsec_core;

this is global, and it thus doesn't handle > 1 device.  shouldn't this
be the device's private data pointed to by its struct device?

> +/**
> + * PPC4XX Crypto Engine Initialization Routine
> + */
> +int32_t crypto4xx_init(struct crypto4xx_device  *dev)

this (and the others) should be static, no?

> +#ifdef CONFIG_USING_PD_DONE_INT

this is not being defined anywhere; remove?

> +void crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
> +{
> +	ctx->sa_in = pci_alloc_consistent(NULL, size * 4,

dma_alloc_consistent?

> +void ppc4xx_fill_one_page(dma_addr_t addr, u32 length,
> +			  u32 idx, u32 *next_sd,
> +			  u32 *offset, u32 *nbytes)
> +{
> +	struct crypto4xx_device *dev = &(lsec_core.dev);
> +	u32 len;
> +
> +	if (length > dev->scatter_buffer_size) {
> +		memcpy(phys_to_virt(addr),
> +			dev->scatter_buffer_va +
> +			idx*dev->scatter_buffer_size + (*offset),
> +			dev->scatter_buffer_size);
> +		*offset = 0;
> +		length -= dev->scatter_buffer_size;
> +		*nbytes -= dev->scatter_buffer_size;
> +		if (idx == PPC4XX_LAST_SD)
> +			idx = 0;
> +		else
> +			idx++;
> +		*next_sd = idx;
> +		ppc4xx_fill_one_page(addr + dev->scatter_buffer_size, length,
> +			     idx, next_sd, offset, nbytes);

doesn't recursing like this create an opportunity to unnecessarily
overflow the stack?

> +	} else {
> +		struct ahash_request *ahash_req;
> +		ahash_req = ahash_request_cast(req);
> +		if (ctx->use_rctx) {
> +			rctx = ahash_request_ctx(ahash_req);
> +			return crypto4xx_build_pd(dev, req, pd_entry, rctx,
> +					ahash_req->src,
> +					(struct scatterlist *)
> +					ahash_req->result,
> +					ahash_req->nbytes,
> +					AHASH);
> +		} else {
> +		return crypto4xx_build_pd(dev, req, pd_entry, ctx,
> +					ahash_req->src,
> +					(struct scatterlist *)
> +					ahash_req->result,
> +					ahash_req->nbytes,
> +					AHASH);

bad alignment

> +	/* include address for kasumi that is eip06*/

where in the code does this comment apply?

> +	rc = of_address_to_resource(ofdev->node, 0, &res);
> +	if (rc)
> +		return -ENODEV;
> +
> +	lsec_core.ce_phy_address = res.start;
> +	lsec_core.ce_base = ioremap(lsec_core.ce_phy_address, 0x80400);

0x80400 should be obtained from device tree.  use of_iomap?

> +
> +	/* need to setup pdr, rdr, gdr and sdr */
> +	rc = crypto4xx_start_device(&lsec_core.dev);
> +	if (rc)
> +		goto err_register_intr;
> +
> +	/* Register security algorithms with Linux CryptoAPI */
> +	rc = crypto4xx_register_alg(&lsec_core.dev, crypto4xx_basic_alg);
> +	if (rc)
> +		goto err_register_alg;
> +
> +	CRYPTUTL_PRINTK(KERN_INFO, "Loaded AMCC PPC4XX crypto "
> +			"accelerator driver v%s\n", PPC4XX_SEC_VERSION_STR);
> +
> +	return rc;
> +
> +err_register_intr:
> +err_register_alg:

use a single err_register label?

> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
> +/**
> + * Debugging Macro
> + *
> + */
> +#define PPC4XX_SEC_DEBUG
> +#define PFX	"CRYPTO4XX: "
> +
> +#if !defined(PPC4XX_SEC_DEBUG)
> +#	define CRYPTUTL_PRINTK(ll, fmt, ...)
> +#else
> +#	define CRYPTUTL_PRINTK(ll, fmt, ...) \
> +	do { \
> +		printk(ll PFX fmt "\n", ##__VA_ARGS__); \
> +} while (0);
> +#endif

there already exists a debug print infrastructure for device drivers,
e.g. dev_err, dev_dbg, dev_info..

> +#define PPC4XX_INT_DESCR_CNT		4
> +#define PPC4XX_INT_TIMEOUT_CNT		0
> +/* FIXme arbitory number*/

?

> +#define PPC4XX_INT_CFG			1
> +
> +#ifdef CONFIG_405EX
> +#define SDR0_SRST0			0x00000200
> +#define SRST0_CRYP			0x00000008
> +#else
> +#define SDR0_SRST0			0x00000201
> +#define SRST0_CRYP			0x08000000
> +#endif

4xx should be multiplatform-capable these days (if not, it will be).
The driver should be able to figure out whether it's running on a 405EX
dynamically.

> +struct crypto4xx_device;
> +extern struct crypto4xx_core_device lsec_core;
> +extern struct crypto_alg crypto4xx_basic_alg[];
> +extern u32 crypto4xx_write32(u32 reg, u32 val);
> +extern u32 crypto4xx_read32(u32 reg, u32 *val);
> +extern u32 crypto4xx_get_pd_from_pdr(struct crypto4xx_device *dev);
> +extern u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx);
> +
> +extern struct ce_pd *crypto4xx_get_pdp(struct crypto4xx_device *dev,
> +				       dma_addr_t *pd_dma, u32 idx);
> +extern struct ce_gd *crypto4xx_get_gdp(struct crypto4xx_device *dev,
> +				       dma_addr_t *gd_dma, u32 idx);
> +extern struct ce_sd *crypto4xx_get_sdp(struct crypto4xx_device *dev,
> +				       dma_addr_t *sd_dma, u32 idx);
> +extern void crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
> +extern u32 crypto4xx_alloc_sa_rctx(struct crypto4xx_ctx *ctx,
> +				   struct crypto4xx_ctx *rctx);
> +
> +
> +extern struct crypto4xx_ctx *crypto4xx_alloc_ctx
> +		(struct crypto4xx_ctx   *ctx);
> +
> +extern void crypto4xx_free_ctx(struct crypto4xx_ctx   *ctx);
> +extern u32 crypto4xx_build_pdr(struct crypto4xx_device  *dev);
> +extern u32 crypto4xx_build_gdr(struct crypto4xx_device  *dev);
> +extern u32 crypto4xx_build_sdr(struct crypto4xx_device  *dev);
> +
> +extern u32 crypto4xx_pd_done(struct crypto4xx_core_device *lsec, u32 idx);
> +
> +extern u32 crypto4xx_start_device(struct crypto4xx_device *dev);
> +
> +extern u32 crypto4xx_stop_all(void);
> +extern u32 crypto4xx_config_clear(void);
> +
> +extern void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
> +extern u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
> +extern void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx);
> +
> +extern u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
> +extern u32 get_dynamic_sa_offset_iv_field(struct crypto4xx_ctx *ctx);
> +extern void dump_dynamic_sa_iv_field(struct crypto4xx_ctx *ctx);
> +extern u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx);
> +
> +
> +extern void crypto4xx_memcpy_be(unsigned int *dst,
> +				const unsigned char *buf, int len);
> +extern void crypto4xx_memcpy_le(unsigned int *dst,
> +				const unsigned char *buf, int len);
> +extern int crypto4xx_setup_crypto(struct crypto_async_request *req);
> +
> +extern u32 crypto4xx_check_pd_done(struct crypto4xx_device  *dev);
> +extern  void crypto4xx_alg_exit(struct crypto_tfm *tfm);
> +extern void crypto4xx_free_sa_rctx(struct crypto4xx_ctx *rctx);
> +extern int crypto4xx_handle_req(struct crypto_async_request *req);
> +extern u32 crypto4xx_build_pd(struct crypto4xx_device  *dev,
> +			      struct crypto_async_request *req,
> +			      u32 pd_entry,
> +			      struct crypto4xx_ctx *ctx,
> +			      struct scatterlist *src,
> +			      struct scatterlist *dst,
> +			      u16 datalen,
> +			      u8 type);

please only use declarations if you have a cyclic dependency in a c file.

also, and probably most importantly, I didn't see any locking code in
this driver - how do you enforce mutually exclusive access to the
device?

Kim

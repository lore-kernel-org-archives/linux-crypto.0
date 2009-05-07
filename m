From: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [WIP] crypto: add support for Orion5X crypto engine
Date: Thu, 7 May 2009 22:39:22 +0100
Message-ID: <20090507213922.GV32548@trinity.fluff.org>
References: <20090507210321.GB27695@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Nicolas Pitre <nico@cam.org>,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk>
Content-Disposition: inline
In-Reply-To: <20090507210321.GB27695@Chamillionaire.breakpoint.cc>
List-Unsubscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=unsubscribe>
List-Archive: <http://lists.arm.linux.org.uk/lurker/list/linux-arm-kernel.html>
List-Post: <mailto:linux-arm-kernel@lists.arm.linux.org.uk>
List-Help: <mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=help>
List-Subscribe: <http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.arm.linux.org.uk?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.arm.linux.org.uk
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.arm.linux.org.uk
List-Id: linux-crypto.vger.kernel.org

On Thu, May 07, 2009 at 11:03:21PM +0200, Sebastian Andrzej Siewior wrote:
> update since last post, unfortunately not much:
> - interrupt handler fix
> - s/mav/mv
> 
> the dm-crypt still crashes but a few delays seem to help argh....
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  drivers/crypto/Kconfig      |    9 +
>  drivers/crypto/Makefile     |    1 +
>  drivers/crypto/mv_crypto.c |  725 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 735 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/crypto/mv_crypto.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index e522144..fa564b5 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -157,6 +157,15 @@ config S390_PRNG
>  	  ANSI X9.17 standard. The PRNG is usable via the char device
>  	  /dev/prandom.
>  
> +config CRYPTO_DEV_MARVELL_CRYPTO_ENGINE
> +	tristate "Marvell's Cryptographic Engine"
> +	depends on PLAT_ORION
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_AES
> +	help
> +	  This driver allows you utilize the cryptographic engine which can be
> +	  found on certain SoC like QNAP's TS-209.
> +
>  config CRYPTO_DEV_HIFN_795X
>  	tristate "Driver HIFN 795x crypto accelerator chips"
>  	select CRYPTO_DES
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 73557b2..6020a58 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -2,5 +2,6 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
>  obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
> +obj-$(CONFIG_CRYPTO_DEV_MARVELL_CRYPTO_ENGINE) += mv_crypto.o
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
> diff --git a/drivers/crypto/mv_crypto.c b/drivers/crypto/mv_crypto.c
> new file mode 100644
> index 0000000..40eb083
> --- /dev/null
> +++ b/drivers/crypto/mv_crypto.c
> @@ -0,0 +1,725 @@
> +/*
> + * Support for Marvell's crypto engine which can be found on some Orion5X
> + * boards.
> + *
> + * Author: Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
> + * License: GPL
> + *
> + */
> +#include <linux/io.h>
> +#include <linux/crypto.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/scatterlist.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <crypto/algapi.h>
> +#include <crypto/aes.h>
> +
> +enum engine_status {
> +	engine_idle,
> +	engine_busy,
> +	engine_w_dequeue,
> +};
> +
> +struct req_progress {
> +	struct sg_mapping_iter src_sg_it;
> +	struct sg_mapping_iter dst_sg_it;
> +
> +	/* src mostly */
> +	int this_sg_b_left;
> +	int src_start;
> +	int crypt_len;
> +	/* dst mostly */
> +	int this_dst_sg_b_left;
> +	int dst_start;
> +	int total_req_bytes;
> +};

kerneldoc style documentation wouldn't go amiss here.
> +
> +static void reg_write(void __iomem *mem, u32 val)
> +{
> +	__raw_writel(val, mem);
> +}
> +
> +static u32 reg_read(void __iomem *mem)
> +{
> +	return __raw_readl(mem);
> +}

do you really need to wrapper these? 
it is also readl/writel for pointers obtained from ioremap()

> +#define DIGEST_INITIAL_VAL_A	0xdd00
> +#define DES_CMD_REG		0xdd58
> +
> +#define SEC_ACCEL_CMD		0xde00
> +#define SEC_CMD_EN_SEC_ACCL0	(1 << 0)
> +#define SEC_CMD_EN_SEC_ACCL1	(1 << 1)
> +#define SEC_CMD_DISABLE_SEC	(1 << 2)
> +
> +#define SEC_ACCEL_DESC_P0	0xde04
> +#define SEC_DESC_P0_PTR(x)	(x)
> +
> +#define SEC_ACCEL_DESC_P1	0xde14
> +#define SEC_DESC_P1_PTR(x)	(x)
> +
> +#define SEC_ACCEL_CFG		0xde08
> +#define SEC_CFG_STOP_DIG_ERR	(1 << 0)
> +#define SEC_CFG_CH0_W_IDMA	(1 << 7)
> +#define SEC_CFG_CH1_W_IDMA	(1 << 8)
> +#define SEC_CFG_ACT_CH0_IDMA	(1 << 9)
> +#define SEC_CFG_ACT_CH1_IDMA	(1 << 10)
> +
> +#define SEC_ACCEL_STATUS	0xde0c
> +#define SEC_ST_ACT_0		(1 << 0)
> +#define SEC_ST_ACT_1		(1 << 1)
> +
> +
> +/*
> + * FPGA_INT_STATUS looks like a FPGA leftover and is undocumented. I asumme
> + * that it was part of an IRQ-controller in FPGA and someone forgot to remove
> + * it while switching to the core and moving to SEC_ACCEL_INT_STATUS.
> + */
> +#define FPGA_INT_STATUS		0xdd68
> +#define SEC_ACCEL_INT_STATUS	0xde20
> +#define SEC_INT_AUTH_DONE	(1 << 0)
> +#define SEC_INT_DES_E_DONE	(1 << 1)
> +#define SEC_INT_AES_E_DONE	(1 << 2)
> +#define SEC_INT_AES_D_DONE	(1 << 3)
> +#define SEC_INT_ENC_DONE	(1 << 4)
> +#define SEC_INT_ACCEL0_DONE	(1 << 5)
> +#define SEC_INT_ACCEL1_DONE	(1 << 6)
> +#define SEC_INT_ACC0_IDMA_DONE	(1 << 7)
> +#define SEC_INT_ACC1_IDMA_DONE	(1 << 8)
> +
> +#define SEC_ACCEL_INT_MASK	0xde24
> +
> +#define AES_KEY_LEN	(8 * 4)
> +
> +struct sec_accel_config {
> +
> +	u32 config;
> +#define CFG_OP_MAC_ONLY		0
> +#define CFG_OP_CRYPT_ONLY	1
> +#define CFG_OP_MAC_CRYPT	2
> +#define CFG_OP_CRYPT_MAC	3
> +#define CFG_MACM_MD5		(4 << 4)
> +#define CFG_MACM_SHA1		(5 << 4)
> +#define CFG_MACM_HMAC_MD5	(6 << 4)
> +#define CFG_MACM_HMAC_SHA1	(7 << 4)
> +#define CFG_ENCM_DES		(1 << 8)
> +#define CFG_ENCM_3DES		(2 << 8)
> +#define CFG_ENCM_AES		(3 << 8)
> +#define CFG_DIR_ENC		(0 << 12)
> +#define CFG_DIR_DEC		(1 << 12)
> +#define CFG_ENC_MODE_ECB	(0 << 16)
> +#define CFG_ENC_MODE_CBC	(1 << 16)
> +#define CFG_3DES_EEE		(0 << 20)
> +#define CFG_3DES_EDE		(1 << 20)
> +#define CFG_AES_LEN_128		(0 << 24)
> +#define CFG_AES_LEN_192		(1 << 24)
> +#define CFG_AES_LEN_256		(2 << 24)
> +
> +	u32 enc_p;
> +#define ENC_P_SRC(x)		(x)
> +#define ENC_P_DST(x)		((x) << 16)
> +
> +	u32 enc_len;
> +#define ENC_LEN(x)		(x)
> +
> +	u32 enc_key_p;
> +#define ENC_KEY_P(x)		(x)
> +
> +	u32 enc_iv;
> +#define ENC_IV_POINT(x)		((x) << 0)
> +#define ENC_IV_BUF_POINT(x)	((x) << 16)
> +
> +	u32 mac_src_p;
> +#define MAC_SRC_DATA_P(x)	(x)
> +#define MAC_SRC_TOTAL_LEN(x)	((x) << 16)
> +
> +	u32 mac_digest;
> +	u32 mac_iv;
> +}__attribute__ ((packed));
> +	/*
> +	 * /-----------\ 0
> +	 * | ACCEL CFG |	4 * 8
> +	 * |-----------| 0x20
> +	 * | CRYPT KEY |	8 * 4
> +	 * |-----------| 0x40
> +	 * |  IV   IN  |	4 * 4
> +	 * |-----------| 0x40 (inplace)
> +	 * |  IV BUF   |	4 * 4
> +	 * |-----------| 0x50
> +	 * |  DATA IN  |	16 * x
> +	 * |-----------| 0x50 (inplace operation)
> +	 * |  DATA OUT |	16 * x
> +	 * \-----------/
> +	 */
> +#define SRAM_CONFIG		0x00
> +#define SRAM_DATA_KEY_P		0x20
> +#define SRAM_DATA_IV		0x40
> +#define SRAM_DATA_IV_BUF	0x40
> +#define SRAM_DATA_IN_START	0x50
> +#define SRAM_DATA_OUT_START	0x50
> +
> +struct mv_ctx {
> +	u8 aes_enc_key[AES_KEY_LEN];
> +	u32 aes_dec_key[8];
> +	int key_len;
> +	u32 need_calc_aes_dkey;
> +};
> +
> +enum crypto_op {
> +	COP_AES_ECB,
> +	COP_AES_CBC,
> +};
> +
> +struct mv_req_ctx {
> +	enum crypto_op op;
> +	int decrypt;
> +};
> +
> +#if 0
> +static void hex_dump(unsigned char *info, unsigned char *buf, unsigned int len)
> +{
> +	printk(KERN_ERR "%s\n", info);
> +	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
> +			16, 1,
> +			buf, len, false);
> +	printk(KERN_CONT "\n");
> +}
> +#endif

#if 0 considered bad.

> +static void compute_aes_dec_key(struct mv_ctx *ctx)
> +{
> +	struct crypto_aes_ctx gen_aes_key;
> +	int key_pos;
> +
> +	if (!ctx->need_calc_aes_dkey)
> +		return;
> +
> +	crypto_aes_expand_key(&gen_aes_key, ctx->aes_enc_key, ctx->key_len);
> +
> +	key_pos = ctx->key_len + 24;
> +	memcpy(ctx->aes_dec_key, &gen_aes_key.key_enc[key_pos], 4 * 4);
> +	switch (ctx->key_len) {
> +	case AES_KEYSIZE_256:
> +		key_pos -= 2;
> +		/* fall */
> +	case AES_KEYSIZE_192:
> +		key_pos -= 2;
> +		memcpy(&ctx->aes_dec_key[4], &gen_aes_key.key_enc[key_pos], 4 * 4);
> +		break;
> +	}
> +	ctx->need_calc_aes_dkey = 0;
> +}
> +
> +static int mv_setkey_aes(struct crypto_ablkcipher *cipher, const u8 *key,
> +		unsigned int len)
> +{
> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> +	struct mv_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	switch (len) {
> +	case AES_KEYSIZE_128:
> +	case AES_KEYSIZE_192:
> +	case AES_KEYSIZE_256:
> +		break;
> +	default:
> +		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +	ctx->key_len = len;
> +	ctx->need_calc_aes_dkey = 1;
> +
> +	memcpy(ctx->aes_enc_key, key, AES_KEY_LEN);
> +	return 0;
> +}
> +static void mv_process_current_q(int first_block);
> +
> +#define MAX_REQ_SIZE	(8000)
> +
> +static void setup_data_in(struct ablkcipher_request *req)
> +{
> +	int ret;
> +	void *buf;
> +
> +	if (!cpg->p.this_sg_b_left) {
> +		ret = sg_miter_next(&cpg->p.src_sg_it);
> +		BUG_ON(!ret);
> +		cpg->p.this_sg_b_left = cpg->p.src_sg_it.length;
> +		cpg->p.src_start = 0;
> +	}
> +
> +	cpg->p.crypt_len = min(cpg->p.this_sg_b_left, MAX_REQ_SIZE);
> +
> +	buf = cpg->p.src_sg_it.addr;
> +	buf += cpg->p.src_start;
> +
> +	memcpy(cpg->sram + SRAM_DATA_IN_START, buf, cpg->p.crypt_len);
> +	cpg->p.this_sg_b_left -= cpg->p.crypt_len;
> +	cpg->p.src_start += cpg->p.crypt_len;
> +}
> +
> +static void mv_crypto_algo_completion(void)
> +{
> +	struct ablkcipher_request *req = cpg->cur_req;
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +
> +	if (req_ctx->op != COP_AES_CBC)
> +		return ;
> +
> +	memcpy(req->info, cpg->sram + SRAM_DATA_IV_BUF, 16);
> +}
> +
> +static void dequeue_complete_req(void)
> +{
> +	struct ablkcipher_request *req = cpg->cur_req;
> +//	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +//	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +	void *buf;
> +	int ret;
> +
> +	cpg->p.total_req_bytes += cpg->p.crypt_len;
> +	do {
> +		int dst_copy;
> +
> +		if (!cpg->p.this_dst_sg_b_left) {
> +			ret = sg_miter_next(&cpg->p.dst_sg_it);
> +			BUG_ON(!ret);
> +			cpg->p.this_dst_sg_b_left = cpg->p.dst_sg_it.length;
> +			cpg->p.dst_start = 0;
> +		}
> +
> +		buf = cpg->p.dst_sg_it.addr;
> +		buf += cpg->p.dst_start;
> +
> +		dst_copy = min(cpg->p.crypt_len, cpg->p.this_dst_sg_b_left);
> +
> +		memcpy(buf, cpg->sram + SRAM_DATA_OUT_START, dst_copy);
> +
> +		cpg->p.this_dst_sg_b_left -= dst_copy;
> +		cpg->p.crypt_len -= dst_copy;
> +		cpg->p.dst_start += dst_copy;
> +	} while (cpg->p.crypt_len > 0);
> +
> +	BUG_ON(cpg->eng_st != engine_w_dequeue);
> +	if (cpg->p.total_req_bytes < req->nbytes) {
> +		/* process next scatter list entry */
> +		cpg->eng_st = engine_busy;
> +		mv_process_current_q(0);
> +	} else {
> +		sg_miter_stop(&cpg->p.src_sg_it);
> +		sg_miter_stop(&cpg->p.dst_sg_it);
> +		mv_crypto_algo_completion();
> +		cpg->eng_st = engine_idle;
> +		req->base.complete(&req->base, 0);
> +	}
> +}
> +
> +static void mv_process_current_q(int first_block)
> +{
> +	struct ablkcipher_request *req = cpg->cur_req;
> +	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +	struct sec_accel_config op;
> +
> +	switch (req_ctx->op) {
> +	case COP_AES_ECB:
> +		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
> +		break;
> +	case COP_AES_CBC:
> +		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
> +		op.enc_iv = ENC_IV_POINT(SRAM_DATA_IV) | ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);
> +		if (first_block)
> +			memcpy(cpg->sram + SRAM_DATA_IV, req->info, 16);
> +		break;
> +	}
> +	if (req_ctx->decrypt) {
> +		op.config |= CFG_DIR_DEC;
> +		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key, AES_KEY_LEN);
> +	} else {
> +		op.config |= CFG_DIR_ENC;
> +		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key, AES_KEY_LEN);
> +	}
> +
> +	switch (ctx->key_len) {
> +	case AES_KEYSIZE_128:
> +		op.config |= CFG_AES_LEN_128;
> +		break;
> +	case AES_KEYSIZE_192:
> +		op.config |= CFG_AES_LEN_192;
> +		break;
> +	case AES_KEYSIZE_256:
> +		op.config |= CFG_AES_LEN_256;
> +		break;
> +	}
> +	op.enc_p = ENC_P_SRC(SRAM_DATA_IN_START) |
> +		ENC_P_DST(SRAM_DATA_OUT_START);
> +	op.enc_key_p = SRAM_DATA_KEY_P;
> +
> +	setup_data_in(req);
> +	op.enc_len = cpg->p.crypt_len;
> +	memcpy(cpg->sram + SRAM_CONFIG, &op,
> +			sizeof(struct sec_accel_config));
> +
> +	reg_write(cpg->reg + SEC_ACCEL_DESC_P0, SRAM_CONFIG);
> +	/* GO */
> +	reg_write(cpg->reg + SEC_ACCEL_CMD, SEC_CMD_EN_SEC_ACCL0);
> +
> +	/*
> +	 * XXX: add timer if the interrupt does not occur for some mystery
> +	 * reason
> +	 */
> +}
> +
> +static int count_sgs(struct ablkcipher_request *req)
> +{
> +	int total_bytes;
> +	int i = 0;
> +
> +	total_bytes = req->nbytes;
> +
> +	do {
> +		total_bytes -= req->src[i].length;
> +		i++;
> +
> +	} while (total_bytes > 0);
> +
> +	return i;
> +}
> +
> +static void mv_enqueue_new_req(struct ablkcipher_request *req)
> +{
> +	int num_sgs;
> +
> +	cpg->cur_req = req;
> +	memset(&cpg->p, 0, sizeof(struct req_progress));
> +
> +	num_sgs = count_sgs(req);
> +	sg_miter_start(&cpg->p.src_sg_it, req->src, num_sgs, 0);
> +	sg_miter_start(&cpg->p.dst_sg_it, req->dst, num_sgs, 0);
> +	mv_process_current_q(1);
> +}
> +
> +static int queue_manag(void *data)
> +{
> +	unsigned long flags;
> +	enum engine_status old_st;
> +
> +	do {
> +		struct ablkcipher_request *req;
> +		struct crypto_async_request *async_req = NULL;
> +		struct crypto_async_request *backlog;
> +
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +		spin_lock_irqsave(&cpg->lock, flags);
> +		old_st = cpg->eng_st;
> +
> +		backlog = crypto_get_backlog(&cpg->queue);
> +		spin_unlock_irqrestore(&cpg->lock, flags);
> +
> +		if (old_st == engine_w_dequeue)
> +			dequeue_complete_req();
> +
> +		spin_lock_irqsave(&cpg->lock, flags);
> +		if (cpg->eng_st == engine_idle) {
> +			async_req = crypto_dequeue_request(&cpg->queue);
> +			if (async_req) {
> +				BUG_ON(cpg->eng_st != engine_idle);
> +				cpg->eng_st = engine_busy;
> +			}
> +		}
> +		spin_unlock_irqrestore(&cpg->lock, flags);
> +
> +		if (backlog) {
> +			backlog->complete(backlog, -EINPROGRESS);
> +			backlog = NULL;
> +		}
> +
> +		if (async_req) {
> +			req = container_of(async_req, struct ablkcipher_request, base);
> +			mv_enqueue_new_req(req);
> +			async_req = NULL;
> +		}
> +
> +		schedule();
> +
> +	} while (!kthread_should_stop());
> +	return 0;
> +}
> +
> +static int mv_handle_req(struct ablkcipher_request *req)
> +{
> +//	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	unsigned long flags;
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +	int ret;
> +
> +	spin_lock_irqsave(&cpg->lock, flags);
> +	ret = ablkcipher_enqueue_request(&cpg->queue, req);
> +/*	if (cpg->eng_st == engine_idle) */
> +	wake_up_process(cpg->queue_th);
> +	spin_unlock_irqrestore(&cpg->lock, flags);
> +	return ret;
> +}
> +
> +static int mv_enc_aes_ecb(struct ablkcipher_request *req)
> +{
> +//	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +
> +	req_ctx->op = COP_AES_ECB;
> +	req_ctx->decrypt = 0;
> +
> +	return mv_handle_req(req);
> +}
> +
> +static int mv_dec_aes_ecb(struct ablkcipher_request *req)
> +{
> +	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +
> +	req_ctx->op = COP_AES_ECB;
> +	req_ctx->decrypt = 1;
> +
> +	compute_aes_dec_key(ctx);
> +	return mv_handle_req(req);
> +}
> +
> +static int mv_enc_aes_cbc(struct ablkcipher_request *req)
> +{
> +//	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +
> +	req_ctx->op = COP_AES_CBC;
> +	req_ctx->decrypt = 0;
> +
> +	return mv_handle_req(req);
> +}
> +
> +static int mv_dec_aes_cbc(struct ablkcipher_request *req)
> +{
> +	struct mv_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> +	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
> +
> +	req_ctx->op = COP_AES_CBC;
> +	req_ctx->decrypt = 1;
> +
> +	compute_aes_dec_key(ctx);
> +	return mv_handle_req(req);
> +}
> +
> +static int mv_cra_init(struct crypto_tfm *tfm)
> +{
> +	tfm->crt_ablkcipher.reqsize = sizeof(struct mv_req_ctx);
> +	return 0;
> +}
> +
> +irqreturn_t crypto_int(int irq, void *priv)
> +{
> +//	struct crypto_priv *cp = priv;
> +	u32 val;
> +
> +	val = reg_read(cpg->reg + SEC_ACCEL_INT_STATUS);
> +	if (!(val & SEC_INT_ACCEL0_DONE))
> +		return IRQ_NONE;
> +
> +	val &= ~SEC_INT_ACCEL0_DONE;
> +	reg_write(cpg->reg + FPGA_INT_STATUS, val);
> +	reg_write(cpg->reg + SEC_ACCEL_INT_STATUS, val);
> +	BUG_ON(cpg->eng_st != engine_busy);
> +	cpg->eng_st = engine_w_dequeue;
> +	wake_up_process(cpg->queue_th);
> +	return IRQ_HANDLED;
> +}
> +
> +struct crypto_alg mv_aes_alg_ecb = {
> +	.cra_name		= "ecb(aes)",
> +	.cra_driver_name	= "mv-ecb-aes",
> +	.cra_priority	= 300,
> +	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	.cra_blocksize	= 16,
> +	.cra_ctxsize	= sizeof(struct mv_ctx),
> +	.cra_alignmask	= 0,
> +	.cra_type	= &crypto_ablkcipher_type,
> +	.cra_module	= THIS_MODULE,
> +	.cra_init	= mv_cra_init,
> +	.cra_u		= {
> +		.ablkcipher = {
> +			.min_keysize	=	AES_MIN_KEY_SIZE,
> +			.max_keysize	=	AES_MAX_KEY_SIZE,
> +			.setkey		=	mv_setkey_aes,
> +			.encrypt	=	mv_enc_aes_ecb,
> +			.decrypt	=	mv_dec_aes_ecb,
> +		},
> +	},
> +};
> +
> +struct crypto_alg mv_aes_alg_cbc = {
> +	.cra_name		= "cbc(aes)",
> +	.cra_driver_name	= "mv-cbc-aes",
> +	.cra_priority	= 300,
> +	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	.cra_blocksize	= AES_BLOCK_SIZE,
> +	.cra_ctxsize	= sizeof(struct mv_ctx),
> +	.cra_alignmask	= 0,
> +	.cra_type	= &crypto_ablkcipher_type,
> +	.cra_module	= THIS_MODULE,
> +	.cra_init	= mv_cra_init,
> +	.cra_u		= {
> +		.ablkcipher = {
> +			.ivsize		=	AES_BLOCK_SIZE,
> +			.min_keysize	=	AES_MIN_KEY_SIZE,
> +			.max_keysize	=	AES_MAX_KEY_SIZE,
> +			.setkey		=	mv_setkey_aes,
> +			.encrypt	=	mv_enc_aes_cbc,
> +			.decrypt	=	mv_dec_aes_cbc,
> +		},
> +	},
> +};
> +
> +static int m_probe(struct platform_device *pdev)
> +{
> +	struct crypto_priv *cp;
> +	struct resource *res;
> +	int irq;
> +	int ret;
> +
> +	if (cpg) {
> +		printk(KERN_ERR "Second crypto dev?\n");
> +		return -EBUSY;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
> +	if (!res)
> +		return -ENODEV;

Returning -ENODEV is considered harmful, it will not trigger any warning
from the driver core.

> +	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> +	if (!cp)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&cp->lock);
> +	crypto_init_queue(&cp->queue, 50);
> +	cp->reg = ioremap(res->start, res->end - res->start + 1);
> +	if (!cp->reg) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
> +	if (!res) {
> +		ret = -ENODEV;
> +		goto err_unmap_reg;
> +	}

and see above.

> +	cp->sram = ioremap(res->start, res->end - res->start + 1);
> +	if (!cp->sram) {
> +		ret = -ENOMEM;
> +		goto err_unmap_reg;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0 || irq == NO_IRQ) {
> +		ret = irq;
> +		goto err_unmap_sram;
> +	}
> +	cp->irq = irq;
> +
> +	platform_set_drvdata(pdev, cp);
> +	cpg = cp;
> +
> +	cp->queue_th = kthread_run(queue_manag, cp, "mv_crypto");
> +	if (IS_ERR(cp->queue_th)) {
> +		ret = PTR_ERR(cp->queue_th);
> +		goto err_thread;
> +	}
> +
> +	ret = request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->dev), cp);
> +	if (ret)
> +		goto err_unmap_sram;
> +
> +	reg_write(cpg->reg + SEC_ACCEL_INT_MASK, SEC_INT_ACCEL0_DONE);
> +	reg_write(cpg->reg + SEC_ACCEL_CFG, SEC_CFG_STOP_DIG_ERR);
> +
> +	ret = crypto_register_alg(&mv_aes_alg_ecb);
> +	if (ret) {
> +		printk(KERN_ERR "Reg of algo failed: %d\n", ret);
> +		goto err_reg;
> +	}
> +	ret = crypto_register_alg(&mv_aes_alg_cbc);
> +	if (ret) {
> +		printk(KERN_ERR "Reg of algo failed: %d\n", ret);
> +		goto err_unreg_ecb;
> +	}
> +	return 0;
> +err_unreg_ecb:
> +	crypto_unregister_alg(&mv_aes_alg_ecb);
> +err_thread:
> +	free_irq(irq, cp);
> +err_reg:
> +	kthread_stop(cp->queue_th);
> +err_unmap_sram:
> +	iounmap(cp->sram);
> +err_unmap_reg:
> +	iounmap(cp->reg);
> +err:
> +	kfree(cp);
> +	cpg = NULL;
> +	platform_set_drvdata(pdev, NULL);
> +	return ret;
> +}
> +
> +static int m_remove(struct platform_device *pdev)
> +{
> +	struct crypto_priv *cp = platform_get_drvdata(pdev);
> +
> +	crypto_unregister_alg(&mv_aes_alg_ecb);
> +	crypto_unregister_alg(&mv_aes_alg_cbc);
> +	kthread_stop(cp->queue_th);
> +	free_irq(cp->irq, cp);
> +	memset(cp->sram, 0, 8 * 1024);
> +	iounmap(cp->sram);
> +	iounmap(cp->reg);
> +	kfree(cp);
> +	cpg = NULL;
> +	return 0;
> +}
> +
> +static struct platform_driver marvell_crypto = {
> +	.probe          = m_probe,
> +	.remove         = m_remove,
> +	.driver         = {
> +		.owner  = THIS_MODULE,
> +		.name   = "mv,orion5x-crypto",
> +	},
> +};
> +
> +static int __init crypto_init(void)
> +{
> +	return platform_driver_register(&marvell_crypto);
> +}
> +module_init(crypto_init);
> +
> +static void __exit crypto_exit(void)
> +{
> +	platform_driver_unregister(&marvell_crypto);
> +}
> +module_exit(crypto_exit);
> +
> +MODULE_AUTHOR("Sebastian Andrzej Siewior <sebastian@breakpoint.cc>");
> +MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
> +MODULE_LICENSE("GPL");

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

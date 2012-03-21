From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: ux500: Add driver for CRYP hardware.
Date: Tue, 20 Mar 2012 19:35:10 -0500
Message-ID: <20120320193510.d979777aca3d1af0b6ac12dd@freescale.com>
References: <1331714748-25136-1-git-send-email-andreas.westin@stericsson.com>
	<1331714748-25136-2-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:36556
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab2CUAgw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2012 20:36:52 -0400
In-Reply-To: <1331714748-25136-2-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Mar 2012 09:45:46 +0100
Andreas Westin <andreas.westin@stericsson.com> wrote:

> +config CRYPTO_DEV_UX500
> +	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"

> +	#depends on ARCH_U8500

guessing this should be either removed or modified to include u5500?

> +config CRYPTO_DEV_UX500_CRYP
> +	tristate "UX500 crypto driver for CRYP block"
> +	depends on CRYPTO_DEV_UX500
> +	select CRYPTO_DES
> +	help
> +	  This is the driver for the crypto block CRYP.

what will its module be called?

> +config CRYPTO_DEV_UX500_DEBUG
> +	bool "Activate ux500 platform debug-mode for crypto and hash block"
> +	depends on CRYPTO_DEV_UX500_CRYP || CRYPTO_DEV_UX500_HASH
> +	default n
> +	help
> +	  Say Y if you want to add debug prints to ux500_hash and
> +	  ux500_cryp devices.

there are better ways to do this now - see dynamic-debug-howto.txt.

> +	int peripheralID2 = 0;

mixed-case name

> +
> +	if (NULL == device_data)
> +		return -EINVAL;
> +
> +	if (cpu_is_u8500())
> +		peripheralID2 = CRYP_PERIPHERAL_ID2_DB8500;
> +	else if (cpu_is_u5500())
> +		peripheralID2 = CRYP_PERIPHERAL_ID2_DB5500;
> +
> +	/* Check Peripheral and Pcell Id Register for CRYP */
> +	if ((CRYP_PERIPHERAL_ID0 ==
> +		readl_relaxed(&device_data->base->periphId0))
> +	    && (CRYP_PERIPHERAL_ID1 ==
> +		    readl_relaxed(&device_data->base->periphId1))
> +	    && (peripheralID2 ==
> +		    readl_relaxed(&device_data->base->periphId2))
> +	    && (CRYP_PERIPHERAL_ID3 ==
> +		    readl_relaxed(&device_data->base->periphId3))
> +	    && (CRYP_PCELL_ID0 ==
> +		    readl_relaxed(&device_data->base->pcellId0))
> +	    && (CRYP_PCELL_ID1 ==
> +		    readl_relaxed(&device_data->base->pcellId1))
> +	    && (CRYP_PCELL_ID2 ==
> +		    readl_relaxed(&device_data->base->pcellId2))
> +	    && (CRYP_PCELL_ID3 ==
> +		    readl_relaxed(&device_data->base->pcellId3))) {

mixed-case names

> +		return 0;
> +	}
> +
> +	return -EPERM;
> +}
> +
> +/**
> + * cryp_activity - This routine enables/disable the cryptography function.
> + * @device_data: Pointer to the device data struct for base address.
> + * @cryp_activity: Enable/Disable functionality
> + */
> +void cryp_activity(struct cryp_device_data *device_data,
> +		   enum cryp_crypen cryp_crypen)

comment should say @cryp_crypen:

> +void cryp_flush_inoutfifo(struct cryp_device_data *device_data)
> +{
> +	/*
> +	 * We always need to disble the hardware before trying to flush the

                             disable

> +		 * After the keyprepartion for decrypting is done you should set

                             key preparation

> +int cryp_configure_key_values(struct cryp_device_data *device_data,
> +			      enum cryp_key_reg_index key_reg_index,
> +			      struct cryp_key_value key_value)
> +{
> +	while (cryp_is_logic_busy(device_data))
> +		cpu_relax();
> +
> +	switch (key_reg_index) {
> +	case CRYP_KEY_REG_1:
> +		writel_relaxed(key_value.key_value_left,
> +		       &device_data->base->key_1_l);

alignment issues, presumably after a s/writel/writel_relaxed/g
during development (should make it easy to re-check all occurrences).

> +/**
> + * cryp_write_indata - This routine writes 32 bit data into the data input
> + *		       register of the cryptography IP.
> + * @device_data: Pointer to the device data struct for base address.
> + * @write_data: Data word to write
> + */
> +int cryp_write_indata(struct cryp_device_data *device_data, u32 write_data)
> +{
> +	writel_relaxed(write_data, &device_data->base->din);
> +
> +	return 0;
> +}
> +
> +/**
> + * cryp_read_outdata - This routine reads the data from the data output
> + *		       register of the CRYP logic
> + * @device_data: Pointer to the device data struct for base address.
> + * @read_data: Read the data from the output FIFO.
> + */
> +int cryp_read_outdata(struct cryp_device_data *device_data, u32 *read_data)
> +{
> +	*read_data = readl_relaxed(&device_data->base->dout);
> +
> +	return 0;
> +}

I would say these should be made void, static, inline, etc., but
they only have one callsite each - are they necessary at all?

> + * Protection configuration structure for setting privilage access

                                                     privileged

> + * CRYP power management specifc structure.

                            specific

> +/**
> + * uint8p_to_uint32_be - 4*uint8 to uint32 big endian
> + * @in: Data to convert.
> + */
> +static inline u32 uint8p_to_uint32_be(u8 *in)
> +{
> +	return  (u32)in[0]<<24 |
> +		((u32)in[1]<<16) |
> +		((u32)in[2]<<8) |
> +		((u32)in[3]);
> +}

use cpu_to_be32

> +/**
> + * swap_bits_in_byte - mirror the bits in a byte
> + * @b: the byte to be mirrored
> + * The bits are swapped the following way:
> + *  Byte b include bits 0-7, nibble 1 (n1) include bits 0-3 and
> + *  nibble 2 (n2) bits 4-7.
> + *
> + *  Nibble 1 (n1):
> + *  (The "old" (moved) bit is replaced with a zero)
> + *  1. Move bit 6 and 7, 4 positions to the left.
> + *  2. Move bit 3 and 5, 2 positions to the left.
> + *  3. Move bit 1-4, 1 position to the left.
> + *
> + *  Nibble 2 (n2):
> + *  1. Move bit 0 and 1, 4 positions to the right.
> + *  2. Move bit 2 and 4, 2 positions to the right.
> + *  3. Move bit 3-6, 1 position to the right.
> + *
> + *  Combine the two nibbles to a complete and swapped byte.
> + */
> +
> +static inline u8 swap_bits_in_byte(u8 b)

can't exactly tell - is this because the h/w needs its keys
provided in bitwise-reverse order?  and for decryption only?

> +{
> +#define R_SHIFT_4_MASK  (0xc0) /* Bits 6 and 7, right shift 4 */
> +#define R_SHIFT_2_MASK  (0x28) /* (After right shift 4) Bits 3 and 5,
> +				  right shift 2 */
> +#define R_SHIFT_1_MASK  (0x1e) /* (After right shift 2) Bits 1-4,
> +				  right shift 1 */
> +#define L_SHIFT_4_MASK  (0x03) /* Bits 0 and 1, left shift 4 */
> +#define L_SHIFT_2_MASK  (0x14) /* (After left shift 4) Bits 2 and 4,
> +				  left shift 2 */
> +#define L_SHIFT_1_MASK  (0x78) /* (After left shift 1) Bits 3-6,
> +				  left shift 1 */

unnecessary parens

> +static irqreturn_t cryp_interrupt_handler(int irq, void *param)
> +{
> +	struct cryp_ctx *ctx;
> +	int i;
> +	struct cryp_device_data *device_data;
> +
> +	if (param == NULL) {
> +		BUG_ON(!param);
> +		return IRQ_HANDLED;
> +	}

this makes no sense - plus, when would !param be true in the first
place?

> +
> +	/* The device is coming from the one found in hw_crypt_noxts. */
> +	device_data = (struct cryp_device_data *)param;
> +
> +	ctx = device_data->current_ctx;
> +
> +	if (ctx == NULL) {
> +		BUG_ON(!ctx);
> +		return IRQ_HANDLED;
> +	}

same here

> +
> +	dev_dbg(ctx->device->dev, "[%s] (len: %d) %s, ", __func__, ctx->outlen,
> +		cryp_pending_irq_src(device_data, CRYP_IRQ_SRC_OUTPUT_FIFO) ?
> +		"out" : "in");
> +
> +	if (cryp_pending_irq_src(device_data,
> +				 CRYP_IRQ_SRC_OUTPUT_FIFO)) {
> +		if (ctx->outlen / ctx->blocksize > 0) {
> +			for (i = 0; i < ctx->blocksize / 4; i++) {
> +				cryp_read_outdata(device_data,
> +						 (u32 *)ctx->outdata);
> +				ctx->outdata += 4;
> +				ctx->outlen -= 4;
> +			}
> +
> +			if (ctx->outlen == 0) {
> +				cryp_disable_irq_src(device_data,
> +						     CRYP_IRQ_SRC_OUTPUT_FIFO);
> +			}
> +		}
> +	} else if (cryp_pending_irq_src(device_data,
> +					CRYP_IRQ_SRC_INPUT_FIFO)) {
> +		if (ctx->datalen / ctx->blocksize > 0) {
> +			for (i = 0 ; i < ctx->blocksize / 4; i++) {
> +				cryp_write_indata(device_data,
> +						 *((u32 *)ctx->indata));
> +				ctx->indata += 4;
> +				ctx->datalen -= 4;
> +			}
> +
> +			if (ctx->datalen == 0)
> +				cryp_disable_irq_src(device_data,
> +						   CRYP_IRQ_SRC_INPUT_FIFO);
> +
> +			if (ctx->config.algomode == CRYP_ALGO_AES_XTS) {
> +				CRYP_PUT_BITS(&device_data->base->cr,
> +					      CRYP_START_ENABLE,
> +					      CRYP_CR_START_POS,
> +					      CRYP_CR_START_MASK);
> +
> +				cryp_wait_until_done(device_data);
> +			}
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}

curious again - why are irq's being disabled in the IRQ handler, and
then only reenabled upon a new request - why can't they stay
enabled?  Is this due to the 'polling mode' option somehow not being
mutually exclusive with an interrupt-based request?

> +static int mode_is_aes(enum cryp_algo_mode mode)
> +{
> +	return	(CRYP_ALGO_AES_ECB == mode) ||
> +		(CRYP_ALGO_AES_CBC == mode) ||
> +		(CRYP_ALGO_AES_CTR == mode) ||
> +		(CRYP_ALGO_AES_XTS == mode);

unnecessary inner parens

> +	if (ctx->updated == 0) {
> +		cryp_flush_inoutfifo(device_data);
> +		if (cfg_keys(ctx) != 0) {
> +			dev_err(ctx->device->dev, "[%s]: cfg_keys failed!",
> +				__func__);
> +			return -EPERM;

-EINVAL?

> +		}
> +
> +		if ((ctx->iv) &&
> +		    (CRYP_ALGO_AES_ECB != ctx->config.algomode) &&
> +		    (CRYP_ALGO_DES_ECB != ctx->config.algomode) &&
> +		    (CRYP_ALGO_TDES_ECB != ctx->config.algomode)) {

unnecessary inner parens

> +		if (!ctx->device->dma.sg_dst_len) {
> +			dev_dbg(ctx->device->dev,
> +				"[%s]: Could not map the sg list "
> +				"(FROM_DEVICE)", __func__);

message text strings are allowed to exceed the 80 char line limit,
for grep-ability reasons.

> +			regulator_disable(
> +					       device_data->pwr_regulator);

join last 2 lines

> +		/*
> +		 * ctx->outlen is decremented in the cryp_interrupt_handler
> +		 * function. We had to add cpu_relax() (barrier) to make sure
> +		 * that gcc didn't optimze away this variable.

                                   optimize

> +		 */
> +		while (ctx->outlen > 0)
> +			cpu_relax();

do we need a timeout check in case h/w goes in the weeds?

> +static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +{
> +	struct cryp_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	pr_debug(DEV_DBG_NAME " [%s]", __func__);
> +
> +	ctx->blocksize = crypto_tfm_alg_blocksize(tfm);
> +
> +	ctx->config.algodir = CRYP_ALGORITHM_ENCRYPT;
> +	ctx->config.algomode = CRYP_ALGO_AES_ECB;
> +
> +	ctx->indata = in;
> +	ctx->outdata = out;
> +	ctx->datalen = ctx->blocksize;
> +
> +	if (cryp_hw_calculate(ctx))
> +		pr_err("ux500_cryp:crypX: [%s]: cryp_hw_calculate() failed!",
> +				__func__);

shouldn't this error be propagated to the higher level API?

> +}

> +/**
> + * struct crypto_alg aes_alg
> + */
> +static struct crypto_alg aes_alg = {
> +	.cra_name		=	"aes",
> +	.cra_driver_name	=	"aes-ux500",
> +	.cra_priority		=	300,
> +	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
> +	.cra_blocksize		=	AES_BLOCK_SIZE,
> +	.cra_ctxsize		=	sizeof(struct cryp_ctx),
> +	.cra_alignmask		=	3,
> +	.cra_module		=	THIS_MODULE,
> +	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
> +	.cra_u			=	{
> +		.cipher = {
> +			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
> +			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
> +			.cia_setkey		=	aes_setkey,
> +			.cia_encrypt		=	aes_encrypt,
> +			.cia_decrypt		=	aes_decrypt
> +		}
> +	}
> +};

each of the entry points already assign algodir, algomode, and
blocksize; why not add the corresponding values in a template struct
here, that embeds the crypto_alg structs instead (see struct
talitos_alg_template).  The code would be greatly simplified.
Don't know if it would help, but see also commit 4b00434 "crypto:
Add bulk algorithm registration interface" (in Herbert's crypto-2.6
tree).

Kim

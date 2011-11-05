From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Fri, 4 Nov 2011 20:22:02 -0500
Message-ID: <20111104202202.882b4d84473ba616cacda7d7@freescale.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>
To: <vwadekar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3.bigfish.com ([94.245.120.74]:44636 "EHLO
	DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751413Ab1KEBiH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Nov 2011 21:38:07 -0400
In-Reply-To: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 4 Nov 2011 16:44:16 +0530
<vwadekar@nvidia.com> wrote:

> +/* Define sub-commands */
> +enum {
> +	SUBCMD_VRAM_SEL = 0x1,
> +	SUBCMD_CRYPTO_TABLESEL = 0x3,

SUBCMD_CRYPTO_TABLE_SEL, to match VRAM_SEL for a more consistent
naming convention

> +	SUBCMD_KEYTABLESEL = 0x8,

SUBCMD_KEY_TABLE_SEL?

> +/* memdma_vd command */
> +#define MEMDMA_DIR_DTOVRAM		0 /* sdram -> vram */
> +#define MEMDMA_DIR_VTODRAM		1 /* vram -> sdram */
> +#define MEMDMABITSHIFT_DIR		25
> +#define MEMDMABITSHIFT_NUM_WORDS	12

MEMDMA_DIR_SHIFT, MEMDMA_NUM_WORDS_SHIFT

> +
> +/* command queue bit shifts */
> +enum {
> +	CMDQBITSHIFT_KEYTABLEADDR = 0,
> +	CMDQBITSHIFT_KEYTABLEID = 17,
> +	CMDQBITSHIFT_VRAMSEL = 23,
> +	CMDQBITSHIFT_TABLESEL = 24,
> +	CMDQBITSHIFT_OPCODE = 26,

same here. Seems to better suit existing naming strategy in this
driver.

> +static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
> +	int nblocks, int mode, bool upd_iv)
> +{
> +	u32 cmdq[AES_HW_MAX_ICQ_LENGTH];
> +	int qlen = 0, i, eng_busy, icq_empty, ret;
> +	u32 value;
> +
> +	/* reset all the interrupt bits */
> +	aes_writel(eng, 0xFFFFFFFF, INTR_STATUS);
> +
> +	/* enable error, dma xfer complete interrupts */
> +	aes_writel(dd, 0x33, INT_ENB);
> +	enable_irq(INT_VDE_BSE_V);

is it really necessary to manually control the enabling and
disabling of IRQs?  If so, add a comment explaining why.

> +	cmdq[qlen++] = CMD_DMASETUP << CMDQBITSHIFT_OPCODE;
> +	cmdq[qlen++] = in_addr;
> +	cmdq[qlen++] = CMD_BLKSTARTENGINE << CMDQBITSHIFT_OPCODE | (nblocks-1);
> +	cmdq[qlen++] = CMD_DMACOMPLETE << CMDQBITSHIFT_OPCODE;

qlen appears to be AES_HW_MAX_ICQ_LENGTH -> would this be simpler?:

cmdq[0] = ..
cmdq[1] = ..

..and later qlen references be replaced with AES_HW_MAX_ICQ_LENGTH.

> +	value = aes_readl(dd, CMDQUE_CONTROL);
> +	/* access SDRAM through AHB */
> +	value &= ~CMDQ_CTRL_SRC_STM_SEL_FIELD;
> +	value &= ~CMDQ_CTRL_DST_STM_SEL_FIELD;
> +	value |= (CMDQ_CTRL_SRC_STM_SEL_FIELD | CMDQ_CTRL_DST_STM_SEL_FIELD |
> +		CMDQ_CTRL_ICMDQEN_FIELD);

arm arch could really use some set/clr/clrsetbits helpers..

> +	aes_writel(dd, value, CMDQUE_CONTROL);
> +	dev_dbg(dd->dev, "cmd_q_ctrl=0x%x", value);
> +
> +	value = (0x1 << SECURE_INPUT_ALG_SEL_SHIFT) |
> +		((dd->ctx->keylen * 8) << SECURE_INPUT_KEY_LEN_SHIFT) |
> +		((u32)upd_iv << SECURE_IV_SELECT_SHIFT);
> +
> +	if (mode & FLAGS_CBC) {
> +		value |= ((((mode & FLAGS_ENCRYPT) ? 2 : 3)
> +				<< SECURE_XOR_POS_SHIFT) |
> +			(0 << SECURE_INPUT_SEL_SHIFT) |
> +			(((mode & FLAGS_ENCRYPT) ? 2 : 3)
> +				<< SECURE_VCTRAM_SEL_SHIFT) |
> +			((mode & FLAGS_ENCRYPT) ? 1 : 0)
> +				<< SECURE_CORE_SEL_SHIFT |
> +			(0 << SECURE_RNG_ENB_SHIFT) |
> +			(0 << SECURE_HASH_ENB_SHIFT));

simpler and easier to read if we don't assign 0 to
context-irrelevant bitfields - I'm assuming such fields are
non-overlapping and already guaranteed to be 0.

> +	for (i = 0; i < qlen - 1; i++) {
> +		do {
> +			value = aes_readl(dd, INTR_STATUS);
> +			eng_busy = value & BIT(0);
> +			icq_empty = value & BIT(3);

name BIT(0) and BIT(3)?

> +static struct tegra_aes_slot *aes_find_key_slot(struct tegra_aes_dev *dd)

> +	spin_unlock(&list_lock);
> +	return found ? slot : NULL;

leave blank lines before return statements

> +static int aes_set_key(struct tegra_aes_dev *dd)
> +{
> +	u32 value, cmdq[2];
> +	struct tegra_aes_ctx *ctx = dd->ctx;
> +	int i, eng_busy, icq_empty, dma_busy;
> +	bool use_ssk = false;
> +
> +	if (!ctx) {
> +		dev_err(dd->dev, "%s: context invalid\n", __func__);
> +		return -EINVAL;
> +	}

when would this condition be met?

> +	if (use_ssk)
> +		goto out;

return 0;

> +
> +	/* copy the key table from sdram to vram */

> +	cmdq[0] = 0;

not needed

> +	cmdq[0] = CMD_MEMDMAVD << CMDQBITSHIFT_OPCODE |
> +		(MEMDMA_DIR_DTOVRAM << MEMDMABITSHIFT_DIR) |
> +		(AES_HW_KEY_TABLE_LENGTH_BYTES/sizeof(u32))
> +			<< MEMDMABITSHIFT_NUM_WORDS;

alignment, unnecessary parens, operators at end of prior line:

        cmdq[0] = CMD_MEMDMAVD << CMDQBITSHIFT_OPCODE |
		  MEMDMA_DIR_DTOVRAM << MEMDMABITSHIFT_DIR |
		  AES_HW_KEY_TABLE_LENGTH_BYTES / sizeof(u32) <<
		  MEMDMABITSHIFT_NUM_WORDS;


> +	cmdq[1] = (u32)dd->ivkey_phys_base;
> +
> +	for (i = 0; i < ARRAY_SIZE(cmdq); i++)
> +		aes_writel(dd, cmdq[i], ICMDQUE_WR);

ARRAY_SIZE is 2 here - why not use a single temporary variable and
two individual aes_writel()s?

> +		value = aes_readl(dd, INTR_STATUS);
> +		eng_busy = value & BIT(0);
> +		icq_empty = value & BIT(3);
> +		dma_busy = value & BIT(23);

name bits 0, 3, and 23.

> +	} while (eng_busy & (!icq_empty) & dma_busy);
> +
> +	/* settable command to get key into internal registers */

> +	value = 0;

not needed.

> +	value = CMD_SETTABLE << CMDQBITSHIFT_OPCODE |
> +		SUBCMD_CRYPTO_TABLESEL << CMDQBITSHIFT_TABLESEL |
> +		SUBCMD_VRAM_SEL << CMDQBITSHIFT_VRAMSEL |
> +		(SUBCMD_KEYTABLESEL | ctx->slot->slot_num)
> +			<< CMDQBITSHIFT_KEYTABLEID;

alignment

> +static int tegra_aes_handle_req(struct tegra_aes_dev *dd)

> +	dd->iv = (u8 *)req->info;
> +	dd->ivlen = AES_BLOCK_SIZE;

fyi, getting the iv length from crypto_ablkcipher_ivsize() would be
more futureproof.

> +	if (ctx->flags & FLAGS_NEW_KEY) {
> +		/* copy the key */
> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);

do you really need the overlapping memset?

> +		ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
> +		  (u32)dd->dma_buf_out, 1, FLAGS_CBC, false);

alignment.  Casts necessary?

> +		ret = aes_start_crypt(dd, addr_in, addr_out, nblocks,
> +			dd->flags, true);

alignment

> +static int tegra_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +	unsigned int keylen)

alignment:

static int tegra_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
			    unsigned int keylen)


> +{
> +	struct tegra_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
> +	struct tegra_aes_dev *dd = aes_dev;
> +	struct tegra_aes_slot *key_slot;
> +
> +	if (!ctx || !dd) {

when would this condition be met?

> +		pr_err("ctx=0x%x, dd=0x%x\n",
> +			(unsigned int)ctx, (unsigned int)dd);
> +		return -EINVAL;
> +	}
> +
> +	if ((keylen != AES_KEYSIZE_128) && (keylen != AES_KEYSIZE_192) &&
> +		(keylen != AES_KEYSIZE_256)) {
> +		dev_err(dd->dev, "unsupported key size\n");

crypto_ablkcipher_set_flags(.., CRYPTO_TFM_RES_BAD_KEY_LEN);

> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dd->dev, "keylen: %d\n", keylen);
> +
> +	ctx->dd = dd;
> +
> +	if (key) {

when would this condition not be met?

> +#define INT_ERROR_MASK 0xFFF000

perhaps this belongs in the header file

> +static irqreturn_t aes_irq(int irq, void *dev_id)
> +{
> +	struct tegra_aes_dev *dd = (struct tegra_aes_dev *)dev_id;
> +	u32 value = aes_readl(dd, INTR_STATUS);
> +
> +	dev_dbg(dd->dev, "irq_stat: 0x%x", value);
> +	if (value & INT_ERROR_MASK)
> +		aes_writel(dd, intr_err_mask, INTR_STATUS);
> +
> +	value = aes_readl(dd, INTR_STATUS);

why read the IRQ status twice?

> +	if (!(value & ENGINE_BUSY_FIELD))
> +		complete(&dd->op_complete);
> +
> +done:

label not used

> +	return IRQ_HANDLED;

need to return IRQ_NONE if device reports no valid IRQ status.

> +static int tegra_aes_cbc_decrypt(struct ablkcipher_request *req)
> +{
> +	return tegra_aes_crypt(req, FLAGS_CBC);
> +}

insert blank line here

> +static int tegra_aes_ofb_encrypt(struct ablkcipher_request *req)

> +static int tegra_aes_get_random(struct crypto_rng *tfm, u8 *rdata,
> +	unsigned int dlen)

alignment

> +	memset(dd->buf_in, 0, AES_BLOCK_SIZE);
> +	memcpy(dd->buf_in, dt, DEFAULT_RNG_BLK_SZ);

unnecessary memset

> +	/* copy the key to the key slot */
> +	memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> +	memcpy(dd->ivkey_base, seed + DEFAULT_RNG_BLK_SZ, AES_KEYSIZE_128);

64 byte memset vs. 16 byte memcpy - is the memset still needed?

> +	/* set seed to the aes hw slot */
> +	memset(dd->buf_in, 0, AES_BLOCK_SIZE);
> +	memcpy(dd->buf_in, dd->iv, DEFAULT_RNG_BLK_SZ);

memset not necessary - both are 16 byte ops.

> +	ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
> +	  (u32)dd->dma_buf_out, 1, FLAGS_CBC, false);

fix alignment.  

> +static struct crypto_alg algs[] = {
> +	{
> +		.cra_name = "ecb(aes)",
> +		.cra_driver_name = "ecb-aes-tegra",
> +		.cra_priority = 300,
> +		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +		.cra_blocksize = AES_BLOCK_SIZE,
> +		.cra_ctxsize = sizeof(struct tegra_aes_ctx),
> +		.cra_alignmask = 3,
> +		.cra_type = &crypto_ablkcipher_type,
> +		.cra_module = THIS_MODULE,
> +		.cra_init = tegra_aes_cra_init,
> +		.cra_exit = tegra_aes_cra_exit,
> +		.cra_u.ablkcipher = {
> +			.min_keysize = AES_MIN_KEY_SIZE,
> +			.max_keysize = AES_MAX_KEY_SIZE,
> +			.setkey = tegra_aes_setkey,
> +			.encrypt = tegra_aes_ecb_encrypt,
> +			.decrypt = tegra_aes_ecb_decrypt,

cra_priority, cra_ctxsize, cra_module, cra_init, cra_exit are
constant throughout the array, and can thus be assigned once prior
to alg registration.

> +static int tegra_aes_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct tegra_aes_dev *dd;
> +	struct resource *res;
> +	int err = -ENOMEM, i = 0, j;
> +
> +	if (aes_dev)
> +		return -EEXIST;

when would this condition be met?

> +
> +	dd = kzalloc(sizeof(struct tegra_aes_dev), GFP_KERNEL);
> +	if (dd == NULL) {
> +		dev_err(dev, "unable to alloc data struct.\n");
> +		return -ENOMEM;;

return err;

> diff --git a/drivers/crypto/tegra-aes.h b/drivers/crypto/tegra-aes.h

> +/* interrupt status reg masks and shifts */
> +#define DMA_BUSY_SHIFT		(9)

single value expressions don't need parens; here and throughout the
reset of the file.

> +#define DMA_BUSY_FIELD	(0x1 << DMA_BUSY_SHIFT)

alignment

> +#define ICQ_EMPTY_SHIFT		(3)
> +#define ICQ_EMPTY_FIELD	(0x1 << ICQ_EMPTY_SHIFT)

alignment

Kim

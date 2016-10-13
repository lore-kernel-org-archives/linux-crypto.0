From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 6/6] crypto: ccp - Enable 3DES function on v5 CCPs
Date: Thu, 13 Oct 2016 17:13:47 -0500
Message-ID: <57107694-b585-e353-392b-9792cb8595e1@amd.com>
References: <20161013144542.19759.6924.stgit@taos>
 <20161013145343.19759.84415.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0042.outbound.protection.outlook.com ([104.47.36.42]:20352
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753140AbcJMWO7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 18:14:59 -0400
In-Reply-To: <20161013145343.19759.84415.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/13/2016 09:53 AM, Gary R Hook wrote:
> Wire up support for Triple DES in ECB mode.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/Makefile          |    1 
>  drivers/crypto/ccp/ccp-crypto-des3.c |  254 ++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-main.c |   10 +
>  drivers/crypto/ccp/ccp-crypto.h      |   25 +++
>  drivers/crypto/ccp/ccp-dev-v3.c      |    1 
>  drivers/crypto/ccp/ccp-dev-v5.c      |   65 ++++++++-
>  drivers/crypto/ccp/ccp-dev.h         |   18 ++
>  drivers/crypto/ccp/ccp-ops.c         |  201 +++++++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-pci.c         |    2 
>  include/linux/ccp.h                  |   57 +++++++-
>  10 files changed, 624 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
> 

... <SNIP> ...

> --- a/drivers/crypto/ccp/ccp-crypto.h
> +++ b/drivers/crypto/ccp/ccp-crypto.h
> @@ -26,6 +26,8 @@
>  #include <crypto/sha.h>
>  #include <crypto/internal/rsa.h>
>  
> +#define	CCP_LOG_LEVEL	KERN_INFO
> +

Not used anywhere that I can tell.

>  #define CCP_CRA_PRIORITY	300
>  
>  struct ccp_crypto_ablkcipher_alg {
> @@ -151,7 +153,26 @@ struct ccp_aes_cmac_exp_ctx {
>  	u8 buf[AES_BLOCK_SIZE];
>  };
>  
> -/* SHA-related defines
> +/***** 3DES related defines *****/
> +struct ccp_des3_ctx {
> +	enum ccp_engine engine;
> +	enum ccp_des3_type type;
> +	enum ccp_des3_mode mode;
> +
> +	struct scatterlist key_sg;
> +	unsigned int key_len;
> +	u8 key[AES_MAX_KEY_SIZE];
> +};
> +
> +struct ccp_des3_req_ctx {
> +	struct scatterlist iv_sg;
> +	u8 iv[AES_BLOCK_SIZE];
> +
> +	struct ccp_cmd cmd;
> +};
> +
> +/*
> + * SHA-related defines
>   * These values must be large enough to accommodate any variant
>   */
>  #define MAX_SHA_CONTEXT_SIZE	SHA512_DIGEST_SIZE
> @@ -236,6 +257,7 @@ struct ccp_ctx {
>  		struct ccp_aes_ctx aes;
>  		struct ccp_rsa_ctx rsa;
>  		struct ccp_sha_ctx sha;
> +		struct ccp_des3_ctx des3;
>  	} u;
>  };
>  
> @@ -251,5 +273,6 @@ int ccp_register_aes_aeads(struct list_head *head);
>  int ccp_register_sha_algs(struct list_head *head);
>  int ccp_register_rsa_algs(void);
>  void ccp_unregister_rsa_algs(void);
> +int ccp_register_des3_algs(struct list_head *head);
>  
>  #endif
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 75a0978..fccca16 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -595,6 +595,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
>  static const struct ccp_actions ccp3_actions = {
>  	.aes = ccp_perform_aes,
>  	.xts_aes = ccp_perform_xts_aes,
> +	.des3 = NULL,
>  	.sha = ccp_perform_sha,
>  	.rsa = ccp_perform_rsa,
>  	.passthru = ccp_perform_passthru,
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index dcae391..85387dc 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -101,6 +101,12 @@ union ccp_function {
>  		u16 type:2;
>  	} aes_xts;
>  	struct {
> +		u16 size:7;
> +		u16 encrypt:1;
> +		u16 mode:5;
> +		u16 type:2;
> +	} des3;
> +	struct {
>  		u16 rsvd1:10;
>  		u16 type:4;
>  		u16 rsvd2:1;
> @@ -132,6 +138,10 @@ union ccp_function {
>  #define	CCP_AES_TYPE(p)		((p)->aes.type)
>  #define	CCP_XTS_SIZE(p)		((p)->aes_xts.size)
>  #define	CCP_XTS_ENCRYPT(p)	((p)->aes_xts.encrypt)
> +#define	CCP_DES3_SIZE(p)	((p)->des3.size)
> +#define	CCP_DES3_ENCRYPT(p)	((p)->des3.encrypt)
> +#define	CCP_DES3_MODE(p)	((p)->des3.mode)
> +#define	CCP_DES3_TYPE(p)	((p)->des3.type)
>  #define	CCP_SHA_TYPE(p)		((p)->sha.type)
>  #define	CCP_RSA_SIZE(p)		((p)->rsa.size)
>  #define	CCP_PT_BYTESWAP(p)	((p)->pt.byteswap)
> @@ -242,13 +252,16 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
>  		/* Wait for the job to complete */
>  		ret = wait_event_interruptible(cmd_q->int_queue,
>  					       cmd_q->int_rcvd);
> -		if (ret || cmd_q->cmd_error) {
> +		if (cmd_q->cmd_error) {
> +			/*
> +			 * Log the error and flush the queue by
> +			 * moving the head pointer
> +			 */

I don't think you wanted to remove the check for ret in the if
statement above.

>  			if (cmd_q->cmd_error)
>  				ccp_log_error(cmd_q->ccp,
>  					      cmd_q->cmd_error);
> -			/* A version 5 device doesn't use Job IDs... */
> -			if (!ret)
> -				ret = -EIO;
> +			iowrite32(tail, cmd_q->reg_head_lo);
> +			ret = -EIO;
>  		}

Hmmm... I think this block needs to be looked at some more.

>  		cmd_q->int_rcvd = 0;
>  	}
> @@ -381,6 +394,47 @@ static int ccp5_perform_sha(struct ccp_op *op)
>  	return ccp5_do_cmd(&desc, op->cmd_q);
>  }
>  
> +static int ccp5_perform_des3(struct ccp_op *op)
> +{
> +	struct ccp5_desc desc;
> +	union ccp_function function;
> +	u32 key_addr = op->sb_key * LSB_ITEM_SIZE;
> +
> +	/* Zero out all the fields of the command desc */
> +	memset(&desc, 0, sizeof(struct ccp5_desc));
> +
> +	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_DES3;
> +
> +	CCP5_CMD_SOC(&desc) = op->soc;
> +	CCP5_CMD_IOC(&desc) = 1;
> +	CCP5_CMD_INIT(&desc) = op->init;
> +	CCP5_CMD_EOM(&desc) = op->eom;
> +	CCP5_CMD_PROT(&desc) = 0;
> +
> +	function.raw = 0;
> +	CCP_DES3_ENCRYPT(&function) = op->u.des3.action;
> +	CCP_DES3_MODE(&function) = op->u.des3.mode;
> +	CCP_DES3_TYPE(&function) = op->u.des3.type;
> +	CCP5_CMD_FUNCTION(&desc) = cpu_to_le32(function.raw);
> +
> +	CCP5_CMD_LEN(&desc) = cpu_to_le32(op->src.u.dma.length);
> +
> +	CCP5_CMD_SRC_LO(&desc) = cpu_to_le32(ccp_addr_lo(&op->src.u.dma));
> +	CCP5_CMD_SRC_HI(&desc) = cpu_to_le32(ccp_addr_hi(&op->src.u.dma));
> +	CCP5_CMD_SRC_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SYSTEM);
> +
> +	CCP5_CMD_DST_LO(&desc) = cpu_to_le32(ccp_addr_lo(&op->dst.u.dma));
> +	CCP5_CMD_DST_HI(&desc) = cpu_to_le32(ccp_addr_hi(&op->dst.u.dma));
> +	CCP5_CMD_DST_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SYSTEM);
> +
> +	CCP5_CMD_KEY_LO(&desc) = cpu_to_le32(lower_32_bits(key_addr));
> +	CCP5_CMD_KEY_HI(&desc) = 0;
> +	CCP5_CMD_KEY_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SB);
> +	CCP5_CMD_LSB_ID(&desc) = cpu_to_le32(op->sb_ctx);
> +
> +	return ccp5_do_cmd(&desc, op->cmd_q);
> +}
> +
>  static int ccp5_perform_rsa(struct ccp_op *op)
>  {
>  	struct ccp5_desc desc;
> @@ -428,6 +482,7 @@ static int ccp5_perform_passthru(struct ccp_op *op)
>  	struct ccp_dma_info *saddr = &op->src.u.dma;
>  	struct ccp_dma_info *daddr = &op->dst.u.dma;
>  
> +

Extra blank line.

>  	memset(&desc, 0, Q_DESC_SIZE);
>  
>  	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_PASSTHRU;
> @@ -722,6 +777,7 @@ static int ccp5_init(struct ccp_device *ccp)
>  
>  		dev_dbg(dev, "queue #%u available\n", i);
>  	}
> +

Not needed for this patch.

>  	if (ccp->cmd_q_count == 0) {
>  		dev_notice(dev, "no command queues available\n");
>  		ret = -EIO;
> @@ -991,6 +1047,7 @@ static const struct ccp_actions ccp5_actions = {
>  	.aes = ccp5_perform_aes,
>  	.xts_aes = ccp5_perform_xts_aes,
>  	.sha = ccp5_perform_sha,
> +	.des3 = ccp5_perform_des3,
>  	.rsa = ccp5_perform_rsa,
>  	.passthru = ccp5_perform_passthru,
>  	.ecc = ccp5_perform_ecc,
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index a2214ac..12a92d5 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -27,6 +27,10 @@
>  #include <linux/irqreturn.h>
>  #include <linux/dmaengine.h>
>  
> +#ifndef CCP_LOG_LEVEL
> +#define	CCP_LOG_LEVEL	KERN_INFO
> +#endif
> +

Not used anywhere that I can tell.

>  #define MAX_CCP_NAME_LEN		16
>  #define MAX_DMAPOOL_NAME_LEN		32
>  
> @@ -190,6 +194,9 @@
>  #define CCP_XTS_AES_KEY_SB_COUNT	1
>  #define CCP_XTS_AES_CTX_SB_COUNT	1
>  
> +#define CCP_DES3_KEY_SB_COUNT		1
> +#define CCP_DES3_CTX_SB_COUNT		1
> +
>  #define CCP_SHA_SB_COUNT		1
>  
>  #define CCP_RSA_MAX_WIDTH		4096
> @@ -475,6 +482,12 @@ struct ccp_xts_aes_op {
>  	enum ccp_xts_aes_unit_size unit_size;
>  };
>  
> +struct ccp_des3_op {
> +	enum ccp_des3_type type;
> +	enum ccp_des3_mode mode;
> +	enum ccp_des3_action action;
> +};
> +
>  struct ccp_sha_op {
>  	enum ccp_sha_type type;
>  	u64 msg_bits;
> @@ -512,6 +525,7 @@ struct ccp_op {
>  	union {
>  		struct ccp_aes_op aes;
>  		struct ccp_xts_aes_op xts;
> +		struct ccp_des3_op des3;
>  		struct ccp_sha_op sha;
>  		struct ccp_rsa_op rsa;
>  		struct ccp_passthru_op passthru;
> @@ -620,13 +634,13 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp);
>  struct ccp_actions {
>  	int (*aes)(struct ccp_op *);
>  	int (*xts_aes)(struct ccp_op *);
> +	int (*des3)(struct ccp_op *);
>  	int (*sha)(struct ccp_op *);
>  	int (*rsa)(struct ccp_op *);
>  	int (*passthru)(struct ccp_op *);
>  	int (*ecc)(struct ccp_op *);
>  	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
> -	void (*sbfree)(struct ccp_cmd_queue *, unsigned int,
> -			       unsigned int);
> +	void (*sbfree)(struct ccp_cmd_queue *, unsigned int, unsigned int);
>  	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
>  	int (*init)(struct ccp_device *);
>  	void (*destroy)(struct ccp_device *);
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index de28867..f9543f7 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -16,6 +16,7 @@
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/des.h>
>  #include <linux/ccp.h>
>  #include <linux/delay.h>
>  
> @@ -882,8 +883,7 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  		return -EINVAL;
>  
>  	if (((aes->mode == CCP_AES_MODE_ECB) ||
> -	     (aes->mode == CCP_AES_MODE_CBC) ||
> -	     (aes->mode == CCP_AES_MODE_CFB)) &&
> +	     (aes->mode == CCP_AES_MODE_CBC)) &&

Why are you removing AES modes?

>  	    (aes->src_len & (AES_BLOCK_SIZE - 1)))
>  		return -EINVAL;
>  
> @@ -1194,6 +1194,200 @@ e_key:
>  	return ret;
>  }
>  
> +static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
> +{
> +	struct ccp_des3_engine *des3 = &cmd->u.des3;
> +
> +	struct ccp_dm_workarea key, ctx;
> +	struct ccp_data src, dst;
> +	struct ccp_op op;
> +	unsigned int dm_offset;
> +	unsigned int len_singlekey;
> +	bool in_place = false;
> +	int ret;
> +
> +	/* Error checks */
> +	if (!cmd_q->ccp->vdata->perform->des3)
> +		return -EINVAL;
> +
> +	if (des3->key_len != DES3_EDE_KEY_SIZE)
> +		return -EINVAL;
> +
> +	if (((des3->mode == CCP_DES3_MODE_ECB) ||
> +		(des3->mode == CCP_DES3_MODE_CBC)) &&
> +		(des3->src_len & (DES3_EDE_BLOCK_SIZE - 1)))

These need to be lined up with the first if condition.

> +		return -EINVAL;
> +
> +	if (!des3->key || !des3->src || !des3->dst)
> +		return -EINVAL;
> +
> +	if (des3->mode != CCP_DES3_MODE_ECB) {
> +		if (des3->iv_len != DES3_EDE_BLOCK_SIZE)
> +			return -EINVAL;
> +
> +		if (!des3->iv)
> +			return -EINVAL;
> +	}
> +
> +	ret = -EIO;

Not needed since it will be immediately overwritten in the operation
below.

> +	/* Zero out all the fields of the command desc */
> +	memset(&op, 0, sizeof(op));
> +
> +	/* Set up the Function field */
> +	op.cmd_q = cmd_q;
> +	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
> +	op.sb_key = cmd_q->sb_key;
> +
> +	op.init = (des3->mode == CCP_DES3_MODE_ECB) ? 0 : 1;
> +	op.u.des3.type = des3->type;
> +	op.u.des3.mode = des3->mode;
> +	op.u.des3.action = des3->action;
> +
> +	/*
> +	 * All supported key sizes fit in a single (32-byte) KSB entry and
> +	 * (like AES) must be in little endian format. Use the 256-bit byte
> +	 * swap passthru option to convert from big endian to little endian.
> +	 */
> +	ret = ccp_init_dm_workarea(&key, cmd_q,
> +				   CCP_DES3_KEY_SB_COUNT * CCP_SB_BYTES,
> +				   DMA_TO_DEVICE);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The contents of the key triplet are in the reverse order of what
> +	 * is required by the engine. Copy the 3 pieces individually to put
> +	 * them where they belong.
> +	 */
> +	dm_offset = CCP_SB_BYTES - des3->key_len; /* Basic offset */
> +
> +	len_singlekey = des3->key_len / 3;
> +	ccp_set_dm_area(&key, dm_offset + 2 * len_singlekey,
> +			des3->key, 0, len_singlekey);
> +	ccp_set_dm_area(&key, dm_offset + len_singlekey,
> +			des3->key, len_singlekey, len_singlekey);
> +	ccp_set_dm_area(&key, dm_offset,
> +			des3->key, 2 * len_singlekey, len_singlekey);
> +
> +	/* Copy the key to the SB */
> +	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
> +			     CCP_PASSTHRU_BYTESWAP_256BIT);
> +	if (ret) {
> +		cmd->engine_error = cmd_q->cmd_error;
> +		goto e_key;
> +	}
> +
> +	/*
> +	 * The DES3 context fits in a single (32-byte) KSB entry and
> +	 * must be in little endian format. Use the 256-bit byte swap
> +	 * passthru option to convert from big endian to little endian.
> +	 */
> +	if (des3->mode != CCP_DES3_MODE_ECB) {
> +		u32 load_mode;
> +
> +		op.sb_ctx = cmd_q->sb_ctx;
> +
> +		ret = ccp_init_dm_workarea(&ctx, cmd_q,
> +					   CCP_DES3_CTX_SB_COUNT * CCP_SB_BYTES,
> +					   DMA_BIDIRECTIONAL);
> +		if (ret)
> +			goto e_key;
> +
> +		/* Load the context into the LSB */
> +		dm_offset = CCP_SB_BYTES - des3->iv_len;
> +		ccp_set_dm_area(&ctx, dm_offset, des3->iv, 0, des3->iv_len);
> +
> +		if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
> +			load_mode = CCP_PASSTHRU_BYTESWAP_NOOP;
> +		else
> +			load_mode = CCP_PASSTHRU_BYTESWAP_256BIT;
> +		ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
> +				     load_mode);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			goto e_ctx;
> +		}
> +	}
> +
> +	/*
> +	 * Prepare the input and output data workareas. For in-place
> +	 * operations we need to set the dma direction to BIDIRECTIONAL
> +	 * and copy the src workarea to the dst workarea.
> +	 */
> +	if (sg_virt(des3->src) == sg_virt(des3->dst))
> +		in_place = true;
> +
> +	ret = ccp_init_data(&src, cmd_q, des3->src, des3->src_len,
> +			DES3_EDE_BLOCK_SIZE,
> +			in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
> +	if (ret)
> +		goto e_ctx;
> +
> +	if (in_place)
> +		dst = src;
> +	else {
> +		ret = ccp_init_data(&dst, cmd_q, des3->dst, des3->src_len,
> +				DES3_EDE_BLOCK_SIZE, DMA_FROM_DEVICE);
> +		if (ret)
> +			goto e_src;
> +	}
> +
> +	/* Send data to the CCP DES3 engine */
> +	while (src.sg_wa.bytes_left) {
> +		ccp_prepare_data(&src, &dst, &op, DES3_EDE_BLOCK_SIZE, true);
> +		if (!src.sg_wa.bytes_left) {
> +			op.eom = 1;
> +
> +			/* Since we don't retrieve the context in ECB mode
> +			 * we have to wait for the operation to complete
> +			 * on the last piece of data
> +			 */
> +			op.soc = 0;
> +		}
> +
> +		ret = cmd_q->ccp->vdata->perform->des3(&op);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			goto e_dst;
> +		}
> +
> +		ccp_process_data(&src, &dst, &op);
> +	}
> +
> +	if (des3->mode != CCP_DES3_MODE_ECB) {
> +		/* Retrieve the context and make BE */
> +		ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
> +				       CCP_PASSTHRU_BYTESWAP_256BIT);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			goto e_dst;
> +		}
> +
> +		/* ...but we only need the last DES3_EDE_BLOCK_SIZE bytes */
> +		if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))

V3 doesn't support des3 and has a perform_des3 of NULL so can never get
here.  Just use an offset of 0 in the ccp_get_dm_area() call.

Thanks,
Tom

> +			dm_offset = CCP_SB_BYTES - des3->iv_len;
> +		else
> +			dm_offset = 0;
> +		ccp_get_dm_area(&ctx, dm_offset, des3->iv, 0,
> +				DES3_EDE_BLOCK_SIZE);
> +	}
> +e_dst:
> +	if (!in_place)
> +		ccp_free_data(&dst, cmd_q);
> +
> +e_src:
> +	ccp_free_data(&src, cmd_q);
> +
> +e_ctx:
> +	if (des3->mode != CCP_DES3_MODE_ECB)
> +		ccp_dm_free(&ctx);
> +
> +e_key:
> +	ccp_dm_free(&key);
> +
> +	return ret;
> +}
> +
>  static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  {
>  	struct ccp_sha_engine *sha = &cmd->u.sha;
> @@ -2190,6 +2384,9 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	case CCP_ENGINE_XTS_AES_128:
>  		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
>  		break;
> +	case CCP_ENGINE_DES3:
> +		ret = ccp_run_des3_cmd(cmd_q, cmd);
> +		break;
>  	case CCP_ENGINE_SHA:
>  		ret = ccp_run_sha_cmd(cmd_q, cmd);
>  		break;
> diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
> index 28a9996..e9bdf6f 100644
> --- a/drivers/crypto/ccp/ccp-pci.c
> +++ b/drivers/crypto/ccp/ccp-pci.c
> @@ -230,9 +230,11 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	dev_set_drvdata(dev, ccp);
>  
> +	/* Instance-specific required setup */
>  	if (ccp->vdata->setup)
>  		ccp->vdata->setup(ccp);
>  
> +	/* Initialize the CCP device */
>  	ret = ccp->vdata->perform->init(ccp);
>  	if (ret)
>  		goto e_iomap;
> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index f90f8ba..e7acc37 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -303,6 +303,60 @@ struct ccp_sha_engine {
>  				 * final sha cmd */
>  };
>  
> +/***** 3DES engine *****/
> +enum ccp_des3_mode {
> +	CCP_DES3_MODE_ECB = 0,
> +	CCP_DES3_MODE_CBC,
> +	CCP_DES3_MODE_CFB,
> +	CCP_DES3_MODE__LAST,
> +};
> +
> +enum ccp_des3_type {
> +	CCP_DES3_TYPE_168 = 1,
> +	CCP_DES3_TYPE__LAST,
> +	};
> +
> +enum ccp_des3_action {
> +	CCP_DES3_ACTION_DECRYPT = 0,
> +	CCP_DES3_ACTION_ENCRYPT,
> +	CCP_DES3_ACTION__LAST,
> +};
> +
> +/**
> + * struct ccp_des3_engine - CCP SHA operation
> + * @type: Type of 3DES operation
> + * @mode: cipher mode
> + * @action: 3DES operation (decrypt/encrypt)
> + * @key: key to be used for this 3DES operation
> + * @key_len: length of key (in bytes)
> + * @iv: IV to be used for this AES operation
> + * @iv_len: length in bytes of iv
> + * @src: input data to be used for this operation
> + * @src_len: length of input data used for this operation (in bytes)
> + * @dst: output data produced by this operation
> + *
> + * Variables required to be set when calling ccp_enqueue_cmd():
> + *   - type, mode, action, key, key_len, src, dst, src_len
> + *   - iv, iv_len for any mode other than ECB
> + *
> + * The iv variable is used as both input and output. On completion of the
> + * 3DES operation the new IV overwrites the old IV.
> + */
> +struct ccp_des3_engine {
> +	enum ccp_des3_type type;
> +	enum ccp_des3_mode mode;
> +	enum ccp_des3_action action;
> +
> +	struct scatterlist *key;
> +	u32 key_len;	    /* In bytes */
> +
> +	struct scatterlist *iv;
> +	u32 iv_len;	     /* In bytes */
> +
> +	struct scatterlist *src, *dst;
> +	u64 src_len;	    /* In bytes */
> +};
> +
>  /**
>   * ccp_rsa_type - mode of RSA operation
>   *
> @@ -583,7 +637,7 @@ struct ccp_ecc_engine {
>  enum ccp_engine {
>  	CCP_ENGINE_AES = 0,
>  	CCP_ENGINE_XTS_AES_128,
> -	CCP_ENGINE_RSVD1,
> +	CCP_ENGINE_DES3,
>  	CCP_ENGINE_SHA,
>  	CCP_ENGINE_RSA,
>  	CCP_ENGINE_PASSTHRU,
> @@ -631,6 +685,7 @@ struct ccp_cmd {
>  	union {
>  		struct ccp_aes_engine aes;
>  		struct ccp_xts_aes_engine xts;
> +		struct ccp_des3_engine des3;
>  		struct ccp_sha_engine sha;
>  		struct ccp_rsa_engine rsa;
>  		struct ccp_passthru_engine passthru;
> 

From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/4] crypto: ccp - Fix base RSA function for version 5
 CCPs
Date: Thu, 22 Jun 2017 09:45:22 -0500
Message-ID: <e7f7dda9-b3d8-8f15-228d-c0e224d26bd9@amd.com>
References: <20170621224655.15132.20473.stgit@taos.amd.com>
 <20170621224746.15132.94790.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0066.outbound.protection.outlook.com ([104.47.34.66]:26560
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750812AbdFVOp1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 10:45:27 -0400
In-Reply-To: <20170621224746.15132.94790.stgit@taos.amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/21/2017 5:47 PM, Gary R Hook wrote:
> Version 5 devices have requirements for buffer lengths, as well as
> parameter format (e.g. bits vs. bytes). Fix the base CCP driver
> code to meet requirements all supported versions.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>   drivers/crypto/ccp/ccp-dev-v5.c |   10 ++--
>   drivers/crypto/ccp/ccp-ops.c    |   95 ++++++++++++++++++++++++---------------
>   2 files changed, 64 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index b10d2d2075cb..632518efd685 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -469,7 +469,7 @@ static int ccp5_perform_rsa(struct ccp_op *op)
>   	CCP5_CMD_PROT(&desc) = 0;
>   
>   	function.raw = 0;
> -	CCP_RSA_SIZE(&function) = op->u.rsa.mod_size >> 3;
> +	CCP_RSA_SIZE(&function) = (op->u.rsa.mod_size + 7) >> 3;
>   	CCP5_CMD_FUNCTION(&desc) = function.raw;
>   
>   	CCP5_CMD_LEN(&desc) = op->u.rsa.input_len;
> @@ -484,10 +484,10 @@ static int ccp5_perform_rsa(struct ccp_op *op)
>   	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
>   	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
>   
> -	/* Exponent is in LSB memory */
> -	CCP5_CMD_KEY_LO(&desc) = op->sb_key * LSB_ITEM_SIZE;
> -	CCP5_CMD_KEY_HI(&desc) = 0;
> -	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
> +	/* Key (Exponent) is in external memory */
> +	CCP5_CMD_KEY_LO(&desc) = ccp_addr_lo(&op->exp.u.dma);
> +	CCP5_CMD_KEY_HI(&desc) = ccp_addr_hi(&op->exp.u.dma);
> +	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
>   
>   	return ccp5_do_cmd(&desc, op->cmd_q);
>   }
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index c0dfdacbdff5..11155e52c52c 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1731,10 +1731,10 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   {
>   	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
> -	struct ccp_dm_workarea exp, src;
> -	struct ccp_data dst;
> +	struct ccp_dm_workarea exp, src, dst;
>   	struct ccp_op op;
>   	unsigned int sb_count, i_len, o_len;
> +	unsigned int key_size_bytes;
>   	int ret;
>   
>   	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
> @@ -1743,31 +1743,41 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
>   		return -EINVAL;
>   
> -	/* The RSA modulus must precede the message being acted upon, so
> -	 * it must be copied to a DMA area where the message and the
> -	 * modulus can be concatenated.  Therefore the input buffer
> -	 * length required is twice the output buffer length (which
> -	 * must be a multiple of 256-bits).
> -	 */
> -	o_len = ((rsa->key_size + 255) / 256) * 32;
> -	i_len = o_len * 2;
> -
> -	sb_count = o_len / CCP_SB_BYTES;
> -
>   	memset(&op, 0, sizeof(op));
>   	op.cmd_q = cmd_q;
> -	op.jobid = ccp_gen_jobid(cmd_q->ccp);
> -	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
> +	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);

This change isn't related to RSA support, should be a separate patch.

>   
> -	if (!op.sb_key)
> -		return -EIO;
> +	/* Compute o_len, i_len in bytes. */
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
> +		/* The RSA modulus must precede the message being acted upon, so
> +		 * it must be copied to a DMA area where the message and the
> +		 * modulus can be concatenated.  Therefore the input buffer
> +		 * length required is twice the output buffer length (which
> +		 * must be a multiple of 256-bits). sb_count is the
> +		 * number of storage block slots required for the modulus
> +		 */
> +		key_size_bytes = (rsa->key_size + 7) >> 3; > +		o_len = ((rsa->key_size + 255) / 256) * CCP_SB_BYTES;

This calculation shouldn't change the "32" to CCP_SB_BYTES.  This is
purely to get the 256-bit alignment.

> +		i_len = key_size_bytes * 2;

This violates the comment above, key_size_bytes is byte aligned vs the
256-bit/8-byte alignment required.  i_len should stay as o_len * 2.
Should key_size_bytes be moved down and set to o_len for this path?

> +
> +		sb_count = o_len / CCP_SB_BYTES;
> +
> +		op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
> +								sb_count);
> +		if (!op.sb_key)
> +			return -EIO;
> +	} else {
> +		/* A version 5 device allows a modulus size that will not fit
> +		 * in the LSB, so the command will transfer it from memory.
> +		 * But more importantly, the buffer sizes must be a multiple
> +		 * of 32 bytes; rounding up may be required.
> +		 */
> +		key_size_bytes = 32 * ((rsa->key_size + 255) / 256);
> +		o_len = key_size_bytes;
> +		i_len = o_len * 2; /* bytes */

Ok, so this is exactly what the previous code was doing... 32 byte (or
256-bit) alignement. So the only thing that is needed for the V3 vs V5
difference is how the key is handled.  The o_len and i_len calculations
can be left as is and then key_size_bytes is no longer needed.

> +		op.sb_key = cmd_q->sb_key;
> +	}
>   
> -	/* The RSA exponent may span multiple (32-byte) SB entries and must
> -	 * be in little endian format. Reverse copy each 32-byte chunk
> -	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
> -	 * and each byte within that chunk and do not perform any byte swap
> -	 * operations on the passthru operation.
> -	 */

This comment (or part of it) should stay. The general concept and action
is still being done in the code below (ccp_init_dm_workarea() and
ccp_reverse_set_dm_area()).  The only difference between V3 and V5 is
that you don't have to move it to an SB for V5.

>   	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
>   	if (ret)
>   		goto e_sb;
> @@ -1775,11 +1785,23 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	ret = ccp_reverse_set_dm_area(&exp, 0, rsa->exp, 0, rsa->exp_len);
>   	if (ret)
>   		goto e_exp;
> -	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
> -			     CCP_PASSTHRU_BYTESWAP_NOOP);
> -	if (ret) {
> -		cmd->engine_error = cmd_q->cmd_error;
> -		goto e_exp;
> +
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {

CCP_VERSION(5, 0) ?

> +		/* The RSA exponent may span multiple (32-byte) KSB entries and
> +		 * must be in little endian format. Reverse copy each 32-byte
> +		 * chunk of the exponent (En chunk to E0 chunk, E(n-1) chunk to
> +		 * E1 chunk) and each byte within that chunk and do not perform
> +		 * any byte swap operations on the passthru operation.
> +		 */

Change this to say the exponent is being copied to an SB

> +		ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
> +				     CCP_PASSTHRU_BYTESWAP_NOOP);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			goto e_exp;
> +		}
> +	} else {

Add a comment here saying the exponent can be DMA'd directly.

> +		op.exp.u.dma.address = exp.dma.address;
> +		op.exp.u.dma.offset = 0;
>   	}
>   
>   	/* Concatenate the modulus and the message. Both the modulus and
> @@ -1793,13 +1815,13 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	ret = ccp_reverse_set_dm_area(&src, 0, rsa->mod, 0, rsa->mod_len);
>   	if (ret)
>   		goto e_src;
> -	ret = ccp_reverse_set_dm_area(&src, o_len, rsa->src, 0, rsa->src_len);
> +	ret = ccp_reverse_set_dm_area(&src, key_size_bytes, rsa->src, 0,
> +				      rsa->src_len);
>   	if (ret)
>   		goto e_src;
>   
>   	/* Prepare the output area for the operation */
> -	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->mod_len,
> -			    o_len, DMA_FROM_DEVICE);
> +	ret = ccp_init_dm_workarea(&dst, cmd_q, o_len, DMA_FROM_DEVICE);
>   	if (ret)
>   		goto e_src;
>   
> @@ -1807,9 +1829,9 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	op.src.u.dma.address = src.dma.address;
>   	op.src.u.dma.offset = 0;
>   	op.src.u.dma.length = i_len;
> -	op.dst.u.dma.address = dst.dm_wa.dma.address;
> +	op.dst.u.dma.address = dst.dma.address;
>   	op.dst.u.dma.offset = 0;
> -	op.dst.u.dma.length = o_len;
> +	op.dst.u.dma.length = key_size_bytes;

So this changes the dst DMA length for a V3 CCP from a 256 bit aligned
length to a byte aligned length.  But based on above comments I think
this will be reverted anyway.

Thanks,
Tom

>   
>   	op.u.rsa.mod_size = rsa->key_size;
>   	op.u.rsa.input_len = i_len;
> @@ -1820,10 +1842,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   		goto e_dst;
>   	}
>   
> -	ccp_reverse_get_dm_area(&dst.dm_wa, 0, rsa->dst, 0, rsa->mod_len);
> +	ccp_reverse_get_dm_area(&dst, 0, rsa->dst, 0, rsa->mod_len);
>   
>   e_dst:
> -	ccp_free_data(&dst, cmd_q);
> +	ccp_dm_free(&dst);
>   
>   e_src:
>   	ccp_dm_free(&src);
> @@ -1832,7 +1854,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	ccp_dm_free(&exp);
>   
>   e_sb:
> -	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
> +		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
>   
>   	return ret;
>   }
> 

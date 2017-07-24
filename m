From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/4] crypto: ccp - Enable XTS-AES-128 support on all
 CCPs
Date: Mon, 24 Jul 2017 08:46:03 -0500
Message-ID: <ad4dae7f-14d2-0ff1-415f-1bad94057974@amd.com>
References: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
 <150066389693.49973.12313958459155135198.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0075.outbound.protection.outlook.com ([104.47.40.75]:32640
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753605AbdGXNrB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 09:47:01 -0400
In-Reply-To: <150066389693.49973.12313958459155135198.stgit@sosxen.amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/21/2017 2:04 PM, Gary R Hook wrote:
> Version 5 CCPs have some new requirements for XTS-AES: the type field
> must be specified, and the key requires 512 bits, with each part
> occupying 256 bits and padded with zeroes.

This appears to be a fix and not a feature. You need to send this as
a separate patch through the fix process and back through to the stable
releases.

> 
> Signed-off-by: Gary R Hook <ghook@amd.com>
> ---
>   drivers/crypto/ccp/ccp-dev-v5.c |    2 ++
>   drivers/crypto/ccp/ccp-dev.h    |    2 ++
>   drivers/crypto/ccp/ccp-ops.c    |   52 ++++++++++++++++++++++++++++++++-------
>   3 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index b3526336d608..0fb4519c5194 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -145,6 +145,7 @@ union ccp_function {
>   #define	CCP_AES_MODE(p)		((p)->aes.mode)
>   #define	CCP_AES_TYPE(p)		((p)->aes.type)
>   #define	CCP_XTS_SIZE(p)		((p)->aes_xts.size)
> +#define	CCP_XTS_TYPE(p)		((p)->aes_xts.type)
>   #define	CCP_XTS_ENCRYPT(p)	((p)->aes_xts.encrypt)
>   #define	CCP_DES3_SIZE(p)	((p)->des3.size)
>   #define	CCP_DES3_ENCRYPT(p)	((p)->des3.encrypt)
> @@ -346,6 +347,7 @@ static int ccp5_perform_xts_aes(struct ccp_op *op)
>   	function.raw = 0;
>   	CCP_XTS_ENCRYPT(&function) = op->u.xts.action;
>   	CCP_XTS_SIZE(&function) = op->u.xts.unit_size;
> +	CCP_XTS_TYPE(&function) = op->u.xts.type;
>   	CCP5_CMD_FUNCTION(&desc) = function.raw;
>   
>   	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 9320931d89da..3d51180199ac 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -194,6 +194,7 @@
>   #define CCP_AES_CTX_SB_COUNT		1
>   
>   #define CCP_XTS_AES_KEY_SB_COUNT	1
> +#define CCP5_XTS_AES_KEY_SB_COUNT	2
>   #define CCP_XTS_AES_CTX_SB_COUNT	1
>   
>   #define CCP_DES3_KEY_SB_COUNT		1
> @@ -497,6 +498,7 @@ struct ccp_aes_op {
>   };
>   
>   struct ccp_xts_aes_op {
> +	enum ccp_aes_type type;
>   	enum ccp_aes_action action;
>   	enum ccp_xts_aes_unit_size unit_size;
>   };
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index e23d138fc1ce..8113355151d2 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1038,6 +1038,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
>   	struct ccp_op op;
>   	unsigned int unit_size, dm_offset;
>   	bool in_place = false;
> +	unsigned int sb_count = 0;

No need to initialize to zero here.

> +	enum ccp_aes_type aestype;
>   	int ret;
>   
>   	switch (xts->unit_size) {
> @@ -1061,9 +1063,12 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
>   		return -EINVAL;
>   	}
>   
> -	if (xts->key_len != AES_KEYSIZE_128)
> +	if (xts->key_len == AES_KEYSIZE_128)
> +		aestype = CCP_AES_TYPE_128;
> +	else
>   		return -EINVAL;
>   
> +

Remove extra blank line.

>   	if (!xts->final && (xts->src_len & (AES_BLOCK_SIZE - 1)))
>   		return -EINVAL;
>   
> @@ -1086,20 +1091,47 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
>   	op.u.xts.action = xts->action;
>   	op.u.xts.unit_size = xts->unit_size;
>   
> -	/* All supported key sizes fit in a single (32-byte) SB entry
> -	 * and must be in little endian format. Use the 256-bit byte
> -	 * swap passthru option to convert from big endian to little
> -	 * endian.
> +	/* A version 3 device only supports 128-bit keys, which fits into a
> +	 * single SB entry. A version 5 device uses a 512-bit vector, so two
> +	 * SB entries.
>   	 */
> +	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
> +		sb_count = CCP_XTS_AES_KEY_SB_COUNT;
> +	else
> +		sb_count = CCP5_XTS_AES_KEY_SB_COUNT;
>   	ret = ccp_init_dm_workarea(&key, cmd_q,
> -				   CCP_XTS_AES_KEY_SB_COUNT * CCP_SB_BYTES,
> +				   sb_count * CCP_SB_BYTES,
>   				   DMA_TO_DEVICE);
>   	if (ret)
>   		return ret;
>   
> -	dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
> -	ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
> -	ccp_set_dm_area(&key, 0, xts->key, dm_offset, xts->key_len);
> +	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0)) {
> +		/* All supported key sizes must be in little endian format.
> +		 * Use the 256-bit byte swap passthru option to convert from
> +		 * big endian to little endian.
> +		 */
> +		dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
> +		ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
> +		ccp_set_dm_area(&key, 0, xts->key, xts->key_len, xts->key_len);
> +	} else {
> +		/* The AES key is at the little end and the tweak key is
> +		 * at the big end. Since the byteswap operation is only
> +		 * 256-bit, load the buffer according to the way things
> +		 * will end up.
> +		 */

The second half of your patch description better describes what you're
doing here... that is, you need two SB entries with the key in one and
the tweak in the other with appropriate padding.

> +		unsigned int pad;
> +
> +		op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
> +								sb_count);
> +		if (!op.sb_key)
> +			return -EIO;

So now you're always allocating SB entries.  Doesn't the initialization
function already pre-allocate space for 2 SB entries for keys? I don't
think you need to do this allocation.

> +
> +		dm_offset = CCP_SB_BYTES;
> +		pad = dm_offset - xts->key_len;
> +		ccp_set_dm_area(&key, pad, xts->key, 0, xts->key_len);
> +		ccp_set_dm_area(&key, dm_offset + pad, xts->key, xts->key_len,
> +				xts->key_len);
> +	}
>   	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
>   			     CCP_PASSTHRU_BYTESWAP_256BIT);
>   	if (ret) {
> @@ -1188,6 +1220,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
>   
>   e_key:
>   	ccp_dm_free(&key);
> +	if (cmd_q->ccp->vdata->version > CCP_VERSION(3, 0))
> +		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);

This can be removed if you end up using the pre-allocated entries.

Thanks,
Tom

>   
>   	return ret;
>   }
> 

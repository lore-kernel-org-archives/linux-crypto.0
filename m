From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [v2 PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Wed, 17 Jun 2015 20:02:30 +0300
Message-ID: <5581A826.7060907@freescale.com>
References: <20150616054551.GA21524@gondor.apana.org.au>
 <E1Z4jpH-0005dy-Et@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <jinyanjiang@gmail.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:12745
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753447AbbFQRFx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 13:05:53 -0400
In-Reply-To: <E1Z4jpH-0005dy-Et@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/16/2015 8:54 AM, Herbert Xu wrote:
> This patch converts the caam GCM implementations to the new AEAD
> interface.  This is compile-tested only.
> 
> Note that all IV generation for GCM algorithms have been removed.
> The reason is that the current generation uses purely random IVs
> which is not appropriate for counter-based algorithms where we
> first and foremost require uniqueness.
> 
> Of course there is no reason why you couldn't implement seqiv or
> seqniv within caam since all they do is xor the sequence number
> with a salt, but since I can't test this on actual hardware I'll
> leave it alone for now.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/caam/caamalg.c | 1430 +++++++++++++++++++++---------------------
>  1 file changed, 741 insertions(+), 689 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index 3c37fe6..f206521 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -65,6 +65,10 @@
>  /* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
>  #define CAAM_MAX_IV_LENGTH		16
>  
> +#define AEAD_DESC_JOB_IO_LEN		(DESC_JOB_IO_LEN + CAAM_CMD_SZ * 2)
> +#define GCM_DESC_JOB_IO_LEN		(AEAD_DESC_JOB_IO_LEN + \
> +					 CAAM_CMD_SZ * 4)
> +
>  /* length of descriptors text */
>  #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
>  #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
> @@ -79,18 +83,16 @@
>  #define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
>  
>  #define DESC_GCM_BASE			(3 * CAAM_CMD_SZ)
> -#define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 23 * CAAM_CMD_SZ)
> -#define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 19 * CAAM_CMD_SZ)
> +#define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 16 * CAAM_CMD_SZ)
> +#define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 12 * CAAM_CMD_SZ)
>  
>  #define DESC_RFC4106_BASE		(3 * CAAM_CMD_SZ)
> -#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 15 * CAAM_CMD_SZ)
> -#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 14 * CAAM_CMD_SZ)
> -#define DESC_RFC4106_GIVENC_LEN		(DESC_RFC4106_BASE + 21 * CAAM_CMD_SZ)
> +#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 10 * CAAM_CMD_SZ)
> +#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 10 * CAAM_CMD_SZ)
>  
>  #define DESC_RFC4543_BASE		(3 * CAAM_CMD_SZ)
> -#define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 25 * CAAM_CMD_SZ)
> -#define DESC_RFC4543_DEC_LEN		(DESC_RFC4543_BASE + 27 * CAAM_CMD_SZ)
> -#define DESC_RFC4543_GIVENC_LEN		(DESC_RFC4543_BASE + 30 * CAAM_CMD_SZ)
> +#define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 11 * CAAM_CMD_SZ)
> +#define DESC_RFC4543_DEC_LEN		(DESC_RFC4543_BASE + 12 * CAAM_CMD_SZ)
>  
>  #define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
>  #define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
> @@ -98,9 +100,7 @@
>  #define DESC_ABLKCIPHER_DEC_LEN		(DESC_ABLKCIPHER_BASE + \
>  					 15 * CAAM_CMD_SZ)
>  
> -#define DESC_MAX_USED_BYTES		(DESC_RFC4543_GIVENC_LEN + \
> -					 CAAM_MAX_KEY_SIZE)
> -#define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
> +#define DESC_MAX_USED_LEN		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)

This is going to increase the size of caam_ctx struct, but I agree
previous approach was error-prone.

>  
>  #ifdef DEBUG
>  /* for print_hex_dumps with line references */
> @@ -273,7 +273,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
>  	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
>  
> -	/* aead_encrypt shared descriptor */
> +	/* old_aead_encrypt shared descriptor */
>  	desc = ctx->sh_desc_enc;
>  
>  	init_sh_desc(desc, HDR_SHARE_SERIAL);
> @@ -362,7 +362,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
>  
>  	desc = ctx->sh_desc_dec;
>  
> -	/* aead_decrypt shared descriptor */
> +	/* old_aead_decrypt shared descriptor */
>  	init_sh_desc(desc, HDR_SHARE_SERIAL);
>  
>  	/* Skip if already shared */
> @@ -496,7 +496,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	    CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
>  
> -	/* aead_encrypt shared descriptor */
> +	/* old_aead_encrypt shared descriptor */
>  	desc = ctx->sh_desc_enc;
>  
>  	/* Note: Context registers are saved. */
> @@ -565,7 +565,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
>  	    CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
>  
> -	/* aead_decrypt shared descriptor */
> +	/* old_aead_decrypt shared descriptor */
>  	desc = ctx->sh_desc_dec;
>  
>  	/* Note: Context registers are saved. */
> @@ -738,7 +738,6 @@ static int aead_setauthsize(struct crypto_aead *authenc,
>  
>  static int gcm_set_sh_desc(struct crypto_aead *aead)
>  {
> -	unsigned int ivsize = crypto_aead_ivsize(aead);
>  	struct caam_ctx *ctx = crypto_aead_ctx(aead);
>  	struct device *jrdev = ctx->jrdev;
>  	bool keys_fit_inline = false;
> @@ -754,7 +753,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  	 * Job Descriptor and Shared Descriptor
>  	 * must fit into the 64-word Descriptor h/w Buffer
>  	 */
> -	if (DESC_GCM_ENC_LEN + DESC_JOB_IO_LEN +
> +	if (DESC_GCM_ENC_LEN + GCM_DESC_JOB_IO_LEN +
>  	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
>  
> @@ -777,34 +776,34 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  	append_operation(desc, ctx->class1_alg_type |
>  			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
>  
> -	/* cryptlen = seqoutlen - authsize */
> -	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
> +	/* if assoclen + cryptlen is ZERO, skip to ICV write */
> +	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
> +	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
> +						 JUMP_COND_MATH_Z);
>  
> -	/* assoclen + cryptlen = seqinlen - ivsize */
> -	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
> +	/* if assoclen is ZERO, skip reading the assoc data */
> +	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
> +	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
> +						 JUMP_COND_MATH_Z);
>  
> -	/* assoclen = (assoclen + cryptlen) - cryptlen */
> -	append_math_sub(desc, REG1, REG2, REG3, CAAM_CMD_SZ);
> +	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
> +
> +	/* skip assoc data */
> +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);

This wasn't previously needed. I assume it's related to your comment:
"This series converts various GCM implementations to the new AEAD
interface.  The main changes [...] both src/dst now contain space at the
head equal to assoclen, but only src has the actual AD."

> +
> +	/* cryptlen = seqinlen - assoclen */
> +	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
>  
>  	/* if cryptlen is ZERO jump to zero-payload commands */
> -	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
>  	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
>  					    JUMP_COND_MATH_Z);
> -	/* read IV */
> -	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
> -			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
> -
> -	/* if assoclen is ZERO, skip reading the assoc data */
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
> -	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
> -					   JUMP_COND_MATH_Z);
>  
>  	/* read assoc data */
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
>  			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
>  	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
>  
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
> +	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
>  
>  	/* write encrypted data */
>  	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
> @@ -814,31 +813,17 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
>  
>  	/* jump the zero-payload commands */
> -	append_jump(desc, JUMP_TEST_ALL | 7);
> +	append_jump(desc, JUMP_TEST_ALL | 2);
>  
>  	/* zero-payload commands */
>  	set_jump_tgt_here(desc, zero_payload_jump_cmd);
>  
> -	/* if assoclen is ZERO, jump to IV reading - is the only input data */
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
> -	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
> -					   JUMP_COND_MATH_Z);
> -	/* read IV */
> -	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
> -			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
> -
>  	/* read assoc data */
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
>  			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);
>  
> -	/* jump to ICV writing */
> -	append_jump(desc, JUMP_TEST_ALL | 2);
> -
> -	/* read IV - is the only input data */
> +	/* There is no input data */
>  	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
> -	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
> -			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 |
> -			     FIFOLD_TYPE_LAST1);
>  
>  	/* write ICV */
>  	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
> @@ -862,7 +847,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  	 * must all fit into the 64-word Descriptor h/w Buffer
>  	 */
>  	keys_fit_inline = false;
> -	if (DESC_GCM_DEC_LEN + DESC_JOB_IO_LEN +
> +	if (DESC_GCM_DEC_LEN + GCM_DESC_JOB_IO_LEN +
>  	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
>  		keys_fit_inline = true;
>  
> @@ -886,33 +871,30 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  	append_operation(desc, ctx->class1_alg_type |
>  			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
>  
> -	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
> -	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
> -				ctx->authsize + ivsize);
> -
> -	/* assoclen = (assoclen + cryptlen) - cryptlen */
> -	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
> -	append_math_sub(desc, REG1, REG3, REG2, CAAM_CMD_SZ);
> +	/* if assoclen is ZERO, skip reading the assoc data */
> +	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
> +	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
> +						 JUMP_COND_MATH_Z);
>  
> -	/* read IV */
> -	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
> -			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
> +	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
>  
> -	/* jump to zero-payload command if cryptlen is zero */
> -	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
> -	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
> -					    JUMP_COND_MATH_Z);
> +	/* skip assoc data */
> +	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
>  
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
> -	/* if asoclen is ZERO, skip reading assoc data */
> -	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
> -					   JUMP_COND_MATH_Z);
>  	/* read assoc data */
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
>  			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
> +
>  	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
>  
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
> +	/* cryptlen = seqoutlen - assoclen */
> +	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
> +
> +	/* jump to zero-payload command if cryptlen is zero */
> +	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
> +					    JUMP_COND_MATH_Z);
> +
> +	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
>  
>  	/* store encrypted data */
>  	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
> @@ -921,21 +903,9 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
>  	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
>  			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
>  
> -	/* jump the zero-payload commands */
> -	append_jump(desc, JUMP_TEST_ALL | 4);
> -
>  	/* zero-payload command */
>  	set_jump_tgt_here(desc, zero_payload_jump_cmd);
>  
> -	/* if assoclen is ZERO, jump to ICV reading */
> -	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
> -	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
> -					   JUMP_COND_MATH_Z);
> -	/* read assoc data */
> -	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
> -			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
> -	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
> -
>  	/* read ICV */
>  	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS1 |
>  			     FIFOLD_TYPE_ICV | FIFOLD_TYPE_LAST1);

[...]

> +static void init_gcm_job(struct aead_request *req,
> +			 struct aead_edesc *edesc,
> +			 bool all_contig, bool encrypt)
> +{
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct caam_ctx *ctx = crypto_aead_ctx(aead);
> +	unsigned int ivsize = crypto_aead_ivsize(aead);
> +	u32 *desc = edesc->hw_desc;
> +	bool generic_gcm = (ivsize == 12);
> +	unsigned int last;
> +
> +	init_aead_job(req, edesc, all_contig, encrypt);
> +
> +	/* BUG This should not be specific to generic GCM. */

AFAICT, for non-generic GCM uses (RFC4106, RFC4543), cryptlen and/or
assoclen are always > 0. That's why the descriptors do not address these
cases.

> +	last = 0;
> +	if (encrypt && generic_gcm && !(req->assoclen + req->cryptlen))
> +		last = FIFOLD_TYPE_LAST1;
> +
> +	/* Read GCM IV */
> +	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
> +			 FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | 12 | last);
> +	/* Append Salt */
> +	if (!generic_gcm)
> +		append_data(desc, ctx->key + ctx->enckeylen, 4);
> +	/* Append IV */
> +	append_data(desc, req->iv, ivsize);
> +	/* End of blank commands */
> +}
> +
> +/*
>   * Fill in aead givencrypt job descriptor
>   */
>  static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
> @@ -2608,9 +2391,10 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
>  /*
>   * allocate and map the aead extended descriptor
>   */
> -static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
> -					   int desc_bytes, bool *all_contig_ptr,
> -					   bool encrypt)
> +static struct aead_edesc *old_aead_edesc_alloc(struct aead_request *req,
> +					       int desc_bytes,
> +					       bool *all_contig_ptr,
> +					       bool encrypt)
>  {
>  	struct crypto_aead *aead = crypto_aead_reqtfm(req);
>  	struct caam_ctx *ctx = crypto_aead_ctx(aead);
> @@ -2661,29 +2445,132 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
> -	      OP_ALG_ALGSEL_AES) &&
> -	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
> -		is_gcm = true;
> +	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
> +	      OP_ALG_ALGSEL_AES) &&
> +	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
> +		is_gcm = true;

Now that GCM is handled separately, is_gcm logic should be removed from
all old_aead_* functions.

> +
> +	/*
> +	 * Check if data are contiguous.
> +	 * GCM expected input sequence: IV, AAD, text
> +	 * All other - expected input sequence: AAD, IV, text
> +	 */
> +	if (is_gcm)
> +		all_contig = (!assoc_nents &&
> +			      iv_dma + ivsize == sg_dma_address(req->assoc) &&
> +			      !src_nents && sg_dma_address(req->assoc) +
> +			      req->assoclen == sg_dma_address(req->src));
> +	else
> +		all_contig = (!assoc_nents && sg_dma_address(req->assoc) +
> +			      req->assoclen == iv_dma && !src_nents &&
> +			      iv_dma + ivsize == sg_dma_address(req->src));
> +	if (!all_contig) {
> +		assoc_nents = assoc_nents ? : 1;
> +		src_nents = src_nents ? : 1;
> +		sec4_sg_len = assoc_nents + 1 + src_nents;
> +	}
> +
> +	sec4_sg_len += dst_nents;
> +
> +	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
> +
> +	/* allocate space for base edesc and hw desc commands, link tables */
> +	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
> +			sec4_sg_bytes, GFP_DMA | flags);
> +	if (!edesc) {
> +		dev_err(jrdev, "could not allocate extended descriptor\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	edesc->assoc_nents = assoc_nents;
> +	edesc->assoc_chained = assoc_chained;
> +	edesc->src_nents = src_nents;
> +	edesc->src_chained = src_chained;
> +	edesc->dst_nents = dst_nents;
> +	edesc->dst_chained = dst_chained;
> +	edesc->iv_dma = iv_dma;
> +	edesc->sec4_sg_bytes = sec4_sg_bytes;
> +	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
> +			 desc_bytes;
> +	*all_contig_ptr = all_contig;
> +
> +	sec4_sg_index = 0;
> +	if (!all_contig) {
> +		if (!is_gcm) {
> +			sg_to_sec4_sg_len(req->assoc, req->assoclen,
> +					  edesc->sec4_sg + sec4_sg_index);
> +			sec4_sg_index += assoc_nents;
> +		}
> +
> +		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
> +				   iv_dma, ivsize, 0);
> +		sec4_sg_index += 1;
> +
> +		if (is_gcm) {
> +			sg_to_sec4_sg_len(req->assoc, req->assoclen,
> +					  edesc->sec4_sg + sec4_sg_index);
> +			sec4_sg_index += assoc_nents;
> +		}
> +
> +		sg_to_sec4_sg_last(req->src,
> +				   src_nents,
> +				   edesc->sec4_sg +
> +				   sec4_sg_index, 0);
> +		sec4_sg_index += src_nents;
> +	}
> +	if (dst_nents) {
> +		sg_to_sec4_sg_last(req->dst, dst_nents,
> +				   edesc->sec4_sg + sec4_sg_index, 0);
> +	}
> +	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
> +					    sec4_sg_bytes, DMA_TO_DEVICE);
> +	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
> +		dev_err(jrdev, "unable to map S/G table\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	return edesc;
> +}
> +
> +/*
> + * allocate and map the aead extended descriptor
> + */
> +static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
> +					   int desc_bytes, bool *all_contig_ptr,
> +					   bool encrypt)
> +{
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct caam_ctx *ctx = crypto_aead_ctx(aead);
> +	struct device *jrdev = ctx->jrdev;
> +	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
> +		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
> +	int src_nents, dst_nents = 0;
> +	struct aead_edesc *edesc;
> +	int sgc;
> +	bool all_contig = true;
> +	bool src_chained = false, dst_chained = false;
> +	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
> +	unsigned int authsize = ctx->authsize;
> +
> +	if (unlikely(req->dst != req->src)) {
> +		src_nents = sg_count(req->src, req->assoclen + req->cryptlen,
> +				     &src_chained);
> +		dst_nents = sg_count(req->dst,
> +				     req->assoclen + req->cryptlen +
> +					(encrypt ? authsize : (-authsize)),
> +				     &dst_chained);
> +	} else {
> +		src_nents = sg_count(req->src,
> +				     req->assoclen + req->cryptlen +
> +					(encrypt ? authsize : 0),
> +				     &src_chained);
> +	}
>  
> -	/*
> -	 * Check if data are contiguous.
> -	 * GCM expected input sequence: IV, AAD, text
> -	 * All other - expected input sequence: AAD, IV, text
> -	 */
> -	if (is_gcm)
> -		all_contig = (!assoc_nents &&
> -			      iv_dma + ivsize == sg_dma_address(req->assoc) &&
> -			      !src_nents && sg_dma_address(req->assoc) +
> -			      req->assoclen == sg_dma_address(req->src));
> -	else
> -		all_contig = (!assoc_nents && sg_dma_address(req->assoc) +
> -			      req->assoclen == iv_dma && !src_nents &&
> -			      iv_dma + ivsize == sg_dma_address(req->src));
> +	/* Check if data are contiguous. */
> +	all_contig = !src_nents;
>  	if (!all_contig) {
> -		assoc_nents = assoc_nents ? : 1;
>  		src_nents = src_nents ? : 1;
> -		sec4_sg_len = assoc_nents + 1 + src_nents;
> +		sec4_sg_len = src_nents;
>  	}
>  
>  	sec4_sg_len += dst_nents;
> @@ -2691,64 +2578,78 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
>  	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
>  
>  	/* allocate space for base edesc and hw desc commands, link tables */
> -	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
> +	edesc = kzalloc(sizeof(struct aead_edesc) + desc_bytes +
>  			sec4_sg_bytes, GFP_DMA | flags);
>  	if (!edesc) {
>  		dev_err(jrdev, "could not allocate extended descriptor\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	edesc->assoc_nents = assoc_nents;
> -	edesc->assoc_chained = assoc_chained;
> +	if (likely(req->src == req->dst)) {
> +		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
> +					 DMA_BIDIRECTIONAL, src_chained);
> +		if (unlikely(!sgc)) {
> +			dev_err(jrdev, "unable to map source\n");
> +			kfree(edesc);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	} else {
> +		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
> +					 DMA_TO_DEVICE, src_chained);
> +		if (unlikely(!sgc)) {
> +			dev_err(jrdev, "unable to map source\n");
> +			kfree(edesc);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +
> +		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
> +					 DMA_FROM_DEVICE, dst_chained);
> +		if (unlikely(!sgc)) {
> +			dev_err(jrdev, "unable to map destination\n");
> +			dma_unmap_sg_chained(jrdev, req->src, src_nents ? : 1,
> +					     DMA_TO_DEVICE, src_chained);
> +			kfree(edesc);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}
> +
>  	edesc->src_nents = src_nents;
>  	edesc->src_chained = src_chained;
>  	edesc->dst_nents = dst_nents;
>  	edesc->dst_chained = dst_chained;
> -	edesc->iv_dma = iv_dma;
> -	edesc->sec4_sg_bytes = sec4_sg_bytes;
>  	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
>  			 desc_bytes;
>  	*all_contig_ptr = all_contig;
>  
>  	sec4_sg_index = 0;
>  	if (!all_contig) {
> -		if (!is_gcm) {
> -			sg_to_sec4_sg_len(req->assoc, req->assoclen,
> -					  edesc->sec4_sg + sec4_sg_index);
> -			sec4_sg_index += assoc_nents;
> -		}
> -
> -		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
> -				   iv_dma, ivsize, 0);
> -		sec4_sg_index += 1;
> -
> -		if (is_gcm) {
> -			sg_to_sec4_sg_len(req->assoc, req->assoclen,
> -					  edesc->sec4_sg + sec4_sg_index);
> -			sec4_sg_index += assoc_nents;
> -		}
> -
> -		sg_to_sec4_sg_last(req->src,
> -				   src_nents,
> -				   edesc->sec4_sg +
> -				   sec4_sg_index, 0);
> +		sg_to_sec4_sg(req->src, src_nents,
> +			      edesc->sec4_sg + sec4_sg_index, 0);

Need to mark end of input S/G, use sg_to_sec4_sg_last() instead.

Thanks,
Horia

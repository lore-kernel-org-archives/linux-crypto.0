From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [RFC PATCH 2/2] arm64: add support for AES using ARMv8 Crypto
 Extensions
Date: Sat, 14 Sep 2013 11:08:13 +0300
Message-ID: <5234196D.9050101@iki.fi>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org> <1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-arm@lists.infradead.org, linux-crypto@vger.kernel.org,
	nico@linaro.org, catalin.marinas@arm.com, steve.capper@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57389 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3INIIR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Sep 2013 04:08:17 -0400
In-Reply-To: <1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13.09.2013 18:08, Ard Biesheuvel wrote:
> This adds ARMv8 Crypto Extensions based implemenations of
> AES in CBC, CTR and XTS mode.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
..snip..
> +static int xts_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> +		       unsigned int key_len)
> +{
> +	struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
> +	u32 *flags = &tfm->crt_flags;
> +	int ret;
> +
> +	ret = crypto_aes_expand_key(&ctx->key1, in_key, key_len/2);
> +	if (!ret)
> +		ret = crypto_aes_expand_key(&ctx->key2, &in_key[key_len/2],
> +					    key_len/2);

Use checkpatch.

> +	if (!ret)
> +		return 0;
> +
> +	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +	return -EINVAL;
> +}
> +
> +static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> +		       struct scatterlist *src, unsigned int nbytes)
> +{
> +	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> +	int err, first, rounds = 6 + ctx->key_length/4;
> +	struct blkcipher_walk walk;
> +	unsigned int blocks;
> +
> +	blkcipher_walk_init(&walk, dst, src, nbytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +
> +	kernel_neon_begin();

Is sleeping allowed within kernel_neon_begin/end block? If not, you need to
clear CRYPTO_TFM_REQ_MAY_SLEEP on desc->flags. Otherwise blkcipher_walk_done
might sleep.

> +	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
> +		aesce_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +				  (u8*)ctx->key_enc, rounds, blocks, walk.iv,
> +				  first);
> +
> +		err = blkcipher_walk_done(desc, &walk, blocks * AES_BLOCK_SIZE);
> +	}
> +	kernel_neon_end();
> +
> +	/* non-integral sizes are not supported in CBC */
> +	if (unlikely(walk.nbytes))
> +		err = -EINVAL;

I think blkcipher_walk_done already does this check by comparing against
alg.cra_blocksize.

> +
> +	return err;
> +}
..snip..
> +
> +static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
> +		       struct scatterlist *src, unsigned int nbytes)
> +{
> +	struct crypto_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> +	int err, first, rounds = 6 + ctx->key_length/4;
> +	struct blkcipher_walk walk;
> +	u8 ctr[AES_BLOCK_SIZE];
> +
> +	blkcipher_walk_init(&walk, dst, src, nbytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +
> +	memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
> +
> +	kernel_neon_begin();
> +	for (first = 1; (nbytes = walk.nbytes); first = 0) {
> +		aesce_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
> +				  (u8*)ctx->key_enc, rounds, nbytes, ctr, first);
> +
> +		err = blkcipher_walk_done(desc, &walk, 0);
> +
> +		/* non-integral block *must* be the last one */
> +		if (unlikely(walk.nbytes && (nbytes & (AES_BLOCK_SIZE-1)))) {
> +			err = -EINVAL;

Other CTR implementations do not have this.. not needed?

> +			break;
> +		}
> +	}
..snip..
> +static struct crypto_alg aesce_cbc_algs[] = { {
> +	.cra_name		= "__cbc-aes-aesce",
> +	.cra_driver_name	= "__driver-cbc-aes-aesce",
> +	.cra_priority		= 0,
> +	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_blocksize		= AES_BLOCK_SIZE,
> +	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
> +	.cra_alignmask		= 0,
> +	.cra_type		= &crypto_blkcipher_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_u = {
> +		.blkcipher = {
> +			.min_keysize	= AES_MIN_KEY_SIZE,
> +			.max_keysize	= AES_MAX_KEY_SIZE,
> +			.ivsize		= AES_BLOCK_SIZE,
> +			.setkey		= crypto_aes_set_key,
> +			.encrypt	= cbc_encrypt,
> +			.decrypt	= cbc_decrypt,
> +		},
> +	},
> +}, {
> +	.cra_name		= "__ctr-aes-aesce",
> +	.cra_driver_name	= "__driver-ctr-aes-aesce",
> +	.cra_priority		= 0,
> +	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_blocksize		= AES_BLOCK_SIZE,

CTR mode is stream cipher, cra_blocksize must be set to 1.

This should have been picked up by in-kernel run-time tests, check
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS (and CONFIG_CRYPTO_TEST/tcrypt
module).

> +	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
> +	.cra_alignmask		= 0,
> +	.cra_type		= &crypto_blkcipher_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_u = {
> +		.blkcipher = {
> +			.min_keysize	= AES_MIN_KEY_SIZE,
> +			.max_keysize	= AES_MAX_KEY_SIZE,
> +			.ivsize		= AES_BLOCK_SIZE,
> +			.setkey		= crypto_aes_set_key,
> +			.encrypt	= ctr_encrypt,
> +			.decrypt	= ctr_encrypt,
> +		},
> +	},
> +}, {
> +	.cra_name		= "__xts-aes-aesce",
> +	.cra_driver_name	= "__driver-xts-aes-aesce",
> +	.cra_priority		= 0,
> +	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
> +	.cra_blocksize		= AES_BLOCK_SIZE,
> +	.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
> +	.cra_alignmask		= 0,
> +	.cra_type		= &crypto_blkcipher_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_u = {
> +		.blkcipher = {
> +			.min_keysize	= 2*AES_MIN_KEY_SIZE,
> +			.max_keysize	= 2*AES_MAX_KEY_SIZE,
> +			.ivsize		= AES_BLOCK_SIZE,
> +			.setkey		= xts_set_key,
> +			.encrypt	= xts_encrypt,
> +			.decrypt	= xts_decrypt,
> +		},
> +	},
> +}, {
> +	.cra_name		= "cbc(aes)",
> +	.cra_driver_name	= "cbc-aes-aesce",
> +	.cra_priority		= 200,
> +	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		= AES_BLOCK_SIZE,
> +	.cra_ctxsize		= sizeof(struct async_helper_ctx),
> +	.cra_alignmask		= 0,
> +	.cra_type		= &crypto_ablkcipher_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_init		= ablk_init,
> +	.cra_exit		= ablk_exit,
> +	.cra_u = {
> +		.ablkcipher = {
> +			.min_keysize	= AES_MIN_KEY_SIZE,
> +			.max_keysize	= AES_MAX_KEY_SIZE,
> +			.ivsize		= AES_BLOCK_SIZE,
> +			.setkey		= ablk_set_key,
> +			.encrypt	= ablk_encrypt,
> +			.decrypt	= ablk_decrypt,
> +		}
> +	}
> +}, {
> +	.cra_name		= "ctr(aes)",
> +	.cra_driver_name	= "ctr-aes-aesce",
> +	.cra_priority		= 200,
> +	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		= AES_BLOCK_SIZE,

cra_blocksize = 1

> +	.cra_ctxsize		= sizeof(struct async_helper_ctx),
> +	.cra_alignmask		= 0,
..snip..
> +ENTRY(aesce_xts_encrypt)
> +	tst		w7, #1				// first call?
> +	beq		.Lencmore
> +
> +	ld1		{v0.16b}, [x6]
> +	load_round_keys	w4, x2
> +	encrypt_block	v3.16b, v0.16b, w4		// first tweak
> +	load_round_keys	w4, x3
> +	ldr		q4, .Lxts_mul_x
> +	b		.Lencfirst
> +.Lencmore:
> +	NEXT_TWEAK	(v3, v4, v8)
> +.Lencfirst:
> +	subs		x5, x5, #16
> +.Lencloop:
> +	ld1		{v1.16b}, [x1], #16
> +	eor		v0.16b, v1.16b, v3.16b
> +	encrypt_block	v2.16b, v0.16b, w4
> +	eor		v2.16b, v2.16b, v3.16b
> +	st1		{v2.16b}, [x0], #16
> +	beq		.Lencout
> +
> +	NEXT_TWEAK	(v3, v4, v8)
> +	subs		x5, x5, #16
> +	bpl		.Lencloop
> +
> +	sub		x0, x0, #16
> +	add		x5, x5, #16
> +	mov		x2, x0
> +.Lencsteal:
> +	ldrb		w6, [x1], #1
> +	ldrb		w7, [x2, #-16]
> +	strb		w6, [x2, #-16]
> +	strb		w7, [x2], #1
> +	subs		x5, x5, #1
> +	bne		.Lencsteal

Cipher text stealing here is dead-code, since alg.cra_blocksize is set
to 16 bytes.

Currently other XTS implementations do not have CTS either so this is
not really needed anyway atm (crypto/xts.c: "sector sizes which are not
a multiple of 16 bytes are, however currently unsupported").

-Jussi

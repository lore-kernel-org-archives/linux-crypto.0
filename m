From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver for CPT
Date: Wed, 11 Jan 2017 12:12:26 +0100
Message-ID: <2395769.pOGQxxvRjM@positron.chronox.de>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com> <1484132211-917-3-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55426 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752794AbdAKLNO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 06:13:14 -0500
In-Reply-To: <1484132211-917-3-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 11. Januar 2017, 10:56:50 CET schrieb George Cherian:

Hi George,

> +int cvm_enc_dec_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
> +		       u32 keylen)
> +{
> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> +	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	if ((keylen == 16) || (keylen == 24) || (keylen == 32)) {
> +		ctx->key_len = keylen;
> +		memcpy(ctx->enc_key, key, keylen);
> +		return 0;
> +	}
> +	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +
> +	return -EINVAL;
> +}

...
> +
> +struct crypto_alg algs[] = { {
> +	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
> +	.cra_blocksize = AES_BLOCK_SIZE,
> +	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
> +	.cra_alignmask = 7,
> +	.cra_priority = 4001,
> +	.cra_name = "xts(aes)",
> +	.cra_driver_name = "cavium-xts-aes",
> +	.cra_type = &crypto_ablkcipher_type,
> +	.cra_u = {
> +		.ablkcipher = {
> +			.ivsize = AES_BLOCK_SIZE,
> +			.min_keysize = AES_MIN_KEY_SIZE,
> +			.max_keysize = AES_MAX_KEY_SIZE,
> +			.setkey = cvm_enc_dec_setkey,

May I ask how the setkey for XTS is intended to work? The XTS keys are double 
in size than "normal" keys.

> +			.encrypt = cvm_aes_encrypt_xts,
> +			.decrypt = cvm_aes_decrypt_xts,
> +		},


Ciao
Stephan

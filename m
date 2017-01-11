From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver
 for CPT
Date: Wed, 11 Jan 2017 16:58:17 +0530
Message-ID: <587616D1.6050503@caviumnetworks.com>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com>
 <1484132211-917-3-git-send-email-george.cherian@cavium.com>
 <2395769.pOGQxxvRjM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2395769.pOGQxxvRjM@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

Thanks for pointing it out!!


On 01/11/2017 04:42 PM, Stephan Müller wrote:
> Am Mittwoch, 11. Januar 2017, 10:56:50 CET schrieb George Cherian:
>
> Hi George,
>
>> +int cvm_enc_dec_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
>> +		       u32 keylen)
>> +{
>> +	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
>> +	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
>> +
>> +	if ((keylen == 16) || (keylen == 24) || (keylen == 32)) {
>> +		ctx->key_len = keylen;
>> +		memcpy(ctx->enc_key, key, keylen);
>> +		return 0;
>> +	}
>> +	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> +
>> +	return -EINVAL;
>> +}
>
I will add a seperate function for xts setkey and make changes as following.
> ...
>> +
>> +struct crypto_alg algs[] = { {
>> +	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize = AES_BLOCK_SIZE,
>> +	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
>> +	.cra_alignmask = 7,
>> +	.cra_priority = 4001,
>> +	.cra_name = "xts(aes)",
>> +	.cra_driver_name = "cavium-xts-aes",
>> +	.cra_type = &crypto_ablkcipher_type,
>> +	.cra_u = {
>> +		.ablkcipher = {
>> +			.ivsize = AES_BLOCK_SIZE,
>> +			.min_keysize = AES_MIN_KEY_SIZE,
>> +			.max_keysize = AES_MAX_KEY_SIZE,
>> +			.setkey = cvm_enc_dec_setkey,
>
> May I ask how the setkey for XTS is intended to work? The XTS keys are double
> in size than "normal" keys.
		.ablkcipher = {
			.ivsize = AES_BLOCK_SIZE,
			.min_keysize = 2 * AES_MIN_KEY_SIZE,
			.max_keysize = 2 * AES_MAX_KEY_SIZE,
			.setkey = cvm_xts_setkey,

Hope this is fine?

>
>> +			.encrypt = cvm_aes_encrypt_xts,
>> +			.decrypt = cvm_aes_decrypt_xts,
>> +		},
>
>
> Ciao
> Stephan
>

Regards,
-George

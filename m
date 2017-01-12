From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver
 for CPT
Date: Thu, 12 Jan 2017 16:40:32 +0530
Message-ID: <58776428.1060308@caviumnetworks.com>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com>
 <2395769.pOGQxxvRjM@positron.chronox.de>
 <587616D1.6050503@caviumnetworks.com>
 <1522639.tMShRcNLPc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: George Cherian <george.cherian@cavium.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522639.tMShRcNLPc@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On 01/11/2017 06:09 PM, Stephan Müller wrote:
> Am Mittwoch, 11. Januar 2017, 16:58:17 CET schrieb George Cherian:
>
> Hi George,
>
>> I will add a seperate function for xts setkey and make changes as following.
>>> ...
>>>
>>>> +
>>>> +struct crypto_alg algs[] = { {
>>>> +	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>>>> +	.cra_blocksize = AES_BLOCK_SIZE,
>>>> +	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
>>>> +	.cra_alignmask = 7,
>>>> +	.cra_priority = 4001,
>>>> +	.cra_name = "xts(aes)",
>>>> +	.cra_driver_name = "cavium-xts-aes",
>>>> +	.cra_type = &crypto_ablkcipher_type,
>>>> +	.cra_u = {
>>>> +		.ablkcipher = {
>>>> +			.ivsize = AES_BLOCK_SIZE,
>>>> +			.min_keysize = AES_MIN_KEY_SIZE,
>>>> +			.max_keysize = AES_MAX_KEY_SIZE,
>>>> +			.setkey = cvm_enc_dec_setkey,
>>>
>>> May I ask how the setkey for XTS is intended to work? The XTS keys are
>>> double in size than "normal" keys.
>>
>> 		.ablkcipher = {
>> 			.ivsize = AES_BLOCK_SIZE,
>> 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
>> 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
>> 			.setkey = cvm_xts_setkey,
>>
>> Hope this is fine?
>>
> Sure, please do not forget to invoke xts_verify_key.

Should I be using xts_check_key or xts_verify_key?

>
> Ciao
> Stephan
>

Regards,
-George

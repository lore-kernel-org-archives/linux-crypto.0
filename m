From: Gary R Hook <ghook@amd.com>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Fri, 20 May 2016 10:50:38 -0500
Message-ID: <573F324E.7000100@amd.com>
References: <20160520041901.GA2645@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0076.outbound.protection.outlook.com ([65.55.169.76]:19363
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750937AbcETPuu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 May 2016 11:50:50 -0400
In-Reply-To: <20160520041901.GA2645@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/19/2016 11:19 PM, Herbert Xu wrote:
> Denis B <begun.denis@gmail.com> wrote:
>> My algs struct now looks like this:
>>
>> static struct crypto_alg pp_crypto_algs[] = {
>>    {
>>       .cra_name = "authenc(hmac(sha256),cbc(aes))",
>>       .cra_driver_name = "pp_crypto_cbc_hmac_sha256",
>>       .cra_priority = 1, /**TODO set to highest values after
>> implementing encrypt decrypt functions */
>>       .cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
>>       .cra_blocksize = AES_BLOCK_SIZE,
>>       .cra_ctxsize = sizeof(struct pp_crypto_aead_ctx),
>>       .cra_type = &crypto_nivaead_type,
>>       .cra_u = {
>>             .aead = {
>>                 .setkey = pp_crypto_aead_setkey,
>>                 .setauthsize = pp_crypto_aead_setauthsize,
>>                 .decrypt = pp_crypto_aead_dec,
>>                 .encrypt = pp_crypto_aead_enc,
>>                 .givencrypt = NULL,
>>                 .givdecrypt = NULL,
>>                 .ivsize = AES_BLOCK_SIZE,
>>                 .maxauthsize = SHA256_DIGEST_SIZE,
>
> You also need to set geniv to "eseqiv".

I just gotta ask. Forgive my ignorance.

Why is (or should) setting geniv (be) required?

crypto_givcipher_default() appears to call crypto_default_geniv() if the 
geniv member
is NULL. That function returns "eseqiv" or "chainiv" (under certain 
conditions). If an
implementation isn't generating its own IVs, shouldn't the default 
happen anyway? Or is
this more a matter of populating the structure with known, intentional 
values?

Thank you for any illumination provided.

Gary

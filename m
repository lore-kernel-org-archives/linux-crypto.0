From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [RFC PATCH 2/2] arm64: add support for AES using ARMv8 Crypto
 Extensions
Date: Sat, 14 Sep 2013 17:11:53 +0300
Message-ID: <52346EA9.3020802@iki.fi>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org> <1379084886-1178-3-git-send-email-ard.biesheuvel@linaro.org> <5234196D.9050101@iki.fi> <CAKv+Gu9fCaaTVyCt-r-ijpqYDo4LTfvzrorzjWWCYMM17QUOQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-arm@lists.infradead.org, linux-crypto@vger.kernel.org,
	Nicolas Pitre <nico@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steve Capper <steve.capper@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59486 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab3INOL5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Sep 2013 10:11:57 -0400
In-Reply-To: <CAKv+Gu9fCaaTVyCt-r-ijpqYDo4LTfvzrorzjWWCYMM17QUOQA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14.09.2013 16:30, Ard Biesheuvel wrote:
> On 14 September 2013 10:08, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
>> On 13.09.2013 18:08, Ard Biesheuvel wrote:
>>> This adds ARMv8 Crypto Extensions based implemenations of
>>> AES in CBC, CTR and XTS mode.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>> ..snip..
>>> +static int xts_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>>> +                    unsigned int key_len)
>>> +{
>>> +     struct crypto_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
>>> +     u32 *flags = &tfm->crt_flags;
>>> +     int ret;
>>> +
>>> +     ret = crypto_aes_expand_key(&ctx->key1, in_key, key_len/2);
>>> +     if (!ret)
>>> +             ret = crypto_aes_expand_key(&ctx->key2, &in_key[key_len/2],
>>> +                                         key_len/2);
>>
>> Use checkpatch.
>>
> 
> Um, I did get a bunch of errors and warnings from checkpatch.pl tbh,
> put not in this particular location. Care to elaborate?
> 

Well, the checkpatch.pl I had stored to brain had become corrupted and kept
saying that you need spaces around all operators. But apparently spaces are
just required for assignment operators.

>>> +}, {
>>> +     .cra_name               = "__ctr-aes-aesce",
>>> +     .cra_driver_name        = "__driver-ctr-aes-aesce",
>>> +     .cra_priority           = 0,
>>> +     .cra_flags              = CRYPTO_ALG_TYPE_BLKCIPHER,
>>> +     .cra_blocksize          = AES_BLOCK_SIZE,
>>
>> CTR mode is stream cipher, cra_blocksize must be set to 1.
>>
>> This should have been picked up by in-kernel run-time tests, check
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS (and CONFIG_CRYPTO_TEST/tcrypt
>> module).
>>
> 
> Well, run-time implies access to hardware :-) As I indicated in the
> cover letter, these bits are only compile tested.

Ok, I read the cover letter too hastily :)

-Jussi

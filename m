From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH v2 1/4] crypto: ecc - add privkey generation support
Date: Mon, 29 May 2017 12:08:38 +0300
Message-ID: <c9c47d0f-d4cb-0326-4c43-979fec11001c@microchip.com>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
 <1495034813-27143-2-git-send-email-tudor.ambarus@microchip.com>
 <8501918.Kgl28GDAYF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <marcel@holtmann.org>,
        <Nicolas.Ferre@microchip.com>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:41245 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdE2JIq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:08:46 -0400
In-Reply-To: <8501918.Kgl28GDAYF@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan,

Thank you for the review. Please see inline.

On 28.05.2017 21:44, Stephan Müller wrote:
> Am Mittwoch, 17. Mai 2017, 17:26:50 CEST schrieb Tudor Ambarus:
> 
> Hi Tudor,
> 
>> Add support for generating ecc private keys.
>>
>> Generation of ecc private keys is helpful in a user-space to kernel
>> ecdh offload because the keys are not revealed to user-space. Private
>> key generation is also helpful to implement forward secrecy.
>>
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>> ---
>>   crypto/ecc.c | 20 ++++++++++++++++++++
>>   crypto/ecc.h | 14 ++++++++++++++
>>   2 files changed, 34 insertions(+)
>>
>> diff --git a/crypto/ecc.c b/crypto/ecc.c
>> index 414c78a..a591907 100644
>> --- a/crypto/ecc.c
>> +++ b/crypto/ecc.c
>> @@ -927,6 +927,26 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned
>> int ndigits, return 0;
>>   }
>>
>> +int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64
>> *privkey) +{
>> +	const struct ecc_curve *curve = ecc_get_curve(curve_id);
> 
> Shouldn't there be a check that a curve is selected? I.e. a check for an error
> should be added?

We already checked the curve_id before generating the key. The function
assumes that curve_id is checked before calling it, like 
ecc_is_key_valid() does.

> 
>> +	u64 priv[ndigits];
> 
> Shouldn't there be a size check of ndigits?

Already checked when setting the secret. But FIPS 186-4, B.4.1
recommends to check the bit length of n. It should be greater or equal 
with 160. I will add this check, thanks.

> 
>> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	get_random_bytes(priv, nbytes);
> 
> Can you please use crypto_get_default_rng / crypto_rng_get_bytes /
> crypto_put_default_rng?

Actually I tried this and I encountered some problems, I'm currently
debugging it.

When using the default rng and the run-time self tests are enabled,
the kernel is in a blocking state. What's worse is that the kernel
blocks before the console has the chance to be enabled and I can't see
anything :).

I suspect that the kernel blocks because the rng does not have enough
entropy. Could you please give me some hints?

>> +
>> +	if (vli_is_zero(priv, ndigits))
>> +		return -EINVAL;
>> +
>> +	/* Make sure the private key is in the range [1, n-1]. */
>> +	if (vli_cmp(curve->n, priv, ndigits) != 1)
>> +		return -EINVAL;
>> +
>> +	ecc_swap_digits(priv, privkey, ndigits);
> 
> Is a byteswap faster than a copy operation by looping through priv/privkey and
> simply assinging the value?

Maybe not, but I am consistent with the rest of the code. Can we change
this in a latter patch, if necessary?

Thanks,
ta

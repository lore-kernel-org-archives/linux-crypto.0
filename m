Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AF628E7
	for <linux-crypto@vger.kernel.org>; Thu, 21 Mar 2024 03:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710992012; cv=none; b=BUGVP3JYIGxZ0H0kePuG5oe/lAeC3UoIVDhYCzcSnb3OelbXnZINr4Sfn9D1PzbnZVk7RofyiEmJro2eo4mVAy6HruvZC3nxgUxtdmMHZzY51ez5ixEJLsk7Lk/VG4yRvpe8Z6YEJiYtm6Ze8cCyXpcrdCttygqeAHcqZil1/pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710992012; c=relaxed/simple;
	bh=2E+CDb9K2ToHHNhbAmCn1j0MqZKwtqtrsIHvm/4U0PQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=G6mzc60fKhqODzMjYljs4DSCCbw+BbV2f8yTk6TGB7+5ll56U8FLIONx05uGb9AIFybvGqXcsLNJecvoZNjUHr4Turg2npabPbLuoDRWp51MpyebRQwDNlsespWTVL3DQZcuCmTBlU07IeF0njVzaDuDqZekMwfFBRSk+rJ/LG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Message-ID: <5785c99a-38d5-47a9-9b32-dcb46aaa2ccb@jvdsn.com>
Date: Wed, 20 Mar 2024 22:33:22 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH] crypto: ecc - update ecc_gen_privkey for FIPS 186-5
Content-Language: en-US
To: Vitaly Chikunov <vt@altlinux.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <20240320051558.62868-1-git@jvdsn.com>
 <20240320074616.ya2vmqsacu5tcslt@altlinux.org>
In-Reply-To: <20240320074616.ya2vmqsacu5tcslt@altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Vitaly,

On 3/20/24 02:46, Vitaly Chikunov wrote:
> Joachim,
>
> On Wed, Mar 20, 2024 at 12:13:38AM -0500, Joachim Vandersmissen wrote:
>> FIPS 186-5 [1] was released approximately 1 year ago. The most
>> interesting change for ecc_gen_privkey is the removal of curves with
>> order < 224 bits. This is minimum is now checked in step 1. It is
>> unlikely that there is still any benefit in generating private keys for
>> curves with n < 224, as those curves provide less than 112 bits of
>> security strength and are therefore unsafe for any modern usage.
>>
>> This patch also updates the documentation for __ecc_is_key_valid and
>> ecc_gen_privkey to clarify which FIPS 186-5 method is being used to
>> generate private keys. Previous documentation mentioned that "extra
>> random bits" was used. However, this did not match the code. Instead,
>> the code currently uses (and always has used) the "rejection sampling"
>> ("testing candidates" in FIPS 186-4) method.
>>
>> [1]: https://doi.org/10.6028/NIST.FIPS.186-5
>>
>> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
>> ---
>>   crypto/ecc.c | 29 +++++++++++++++++------------
>>   1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/crypto/ecc.c b/crypto/ecc.c
>> index f53fb4d6af99..3581027e9f92 100644
>> --- a/crypto/ecc.c
>> +++ b/crypto/ecc.c
>> @@ -1416,6 +1416,12 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
>>   }
>>   EXPORT_SYMBOL(ecc_point_mult_shamir);
>>   
>> +/*
>> + * This function performs checks equivalent to Appendix A.4.2 of FIPS 186-5.
>> + * Whereas A.4.2 results in an integer in the interval [1, n-1], this function
>> + * ensures that the integer is in the range of [2, n-3]. We are slightly
>> + * stricter because of the currently used scalar multiplication algorithm.
>> + */
>>   static int __ecc_is_key_valid(const struct ecc_curve *curve,
>>   			      const u64 *private_key, unsigned int ndigits)
>>   {
>> @@ -1455,16 +1461,11 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
>>   EXPORT_SYMBOL(ecc_is_key_valid);
>>   
>>   /*
>> - * ECC private keys are generated using the method of extra random bits,
>> - * equivalent to that described in FIPS 186-4, Appendix B.4.1.
>> - *
>> - * d = (c mod(n–1)) + 1    where c is a string of random bits, 64 bits longer
>> - *                         than requested
>> - * 0 <= c mod(n-1) <= n-2  and implies that
>> - * 1 <= d <= n-1
> Looks like method of extra random bits was never used.
>
> But I am not sure that reference to FIPS 186-5 is correct since it's
> about DSS while this function is only used for ECDH, which is perhaps
> regulated by NIST SP 800-186 and 800-56A. Still, 3.1.2 of 800-186
> suggests that for 'EC key establishment' listed curves with bit lengths
> from 224 are allowed to be used.

Thanks for your review. To me it seems like ecc_gen_privkey is 
externally accessible, and could therefore be considered a 
general-purpose function. However, you are right that it is currently 
only used in the kernel for ECDH key pair generation, which falls under 
SP 800-56Ar3. Perhaps that would be a more suitable reference, but I did 
not want to make any drastic changes to the documentation.

Moreover, the procedure described in SP 800-56Ar3 (Section 5.6.1.2.2) is 
functionally equivalent to the procedure from FIPS 186-5. This is also 
supported by the fact that NIST's Cryptographic Algorithm Validation 
Program (CAVP) does not have a separate test for EC key pair generation 
from SP 800-56Ar3. Instead, the test for ECDSA key pair generation is 
re-used (see e.g. 
https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/details?validation=36423).

In any case, compliance with FIPS 186-5 or SP 800-56Ar3 would require n 
 >= 224, as you pointed out.

>
> Thanks,
>
>
>> + * ECC private keys are generated using the method of rejection sampling,
>> + * equivalent to that described in FIPS 186-5, Appendix A.2.2.
>>    *
>>    * This method generates a private key uniformly distributed in the range
>> - * [1, n-1].
>> + * [2, n-3].
>>    */
>>   int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
>>   {
>> @@ -1474,12 +1475,15 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
>>   	unsigned int nbits = vli_num_bits(curve->n, ndigits);
>>   	int err;
>>   
>> -	/* Check that N is included in Table 1 of FIPS 186-4, section 6.1.1 */
>> -	if (nbits < 160 || ndigits > ARRAY_SIZE(priv))
>> +	/*
>> +	 * Step 1 & 2: check that N is included in Table 1 of FIPS 186-5,
>> +	 * section 6.1.1.
>> +	 */
>> +	if (nbits < 224 || ndigits > ARRAY_SIZE(priv))
>>   		return -EINVAL;
>>   
>>   	/*
>> -	 * FIPS 186-4 recommends that the private key should be obtained from a
>> +	 * FIPS 186-5 recommends that the private key should be obtained from a
>>   	 * RBG with a security strength equal to or greater than the security
>>   	 * strength associated with N.
>>   	 *
>> @@ -1492,12 +1496,13 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
>>   	if (crypto_get_default_rng())
>>   		return -EFAULT;
>>   
>> +	/* Step 3: obtain N returned_bits from the DRBG. */
>>   	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
>>   	crypto_put_default_rng();
>>   	if (err)
>>   		return err;
>>   
>> -	/* Make sure the private key is in the valid range. */
>> +	/* Step 4: make sure the private key is in the valid range. */
>>   	if (__ecc_is_key_valid(curve, priv, ndigits))
>>   		return -EINVAL;
>>   
>> -- 
>> 2.44.0

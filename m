From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: [PATCH 6/6] Add support for AEAD algos.
Date: Thu, 10 Nov 2016 10:30:36 +0530
Message-ID: <069a211a-1f35-c6bc-7d5e-f0fd59e258a4@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
 <3617075.SV0YkRBZ96@positron.chronox.de>
 <ab295a27-cb83-0ee7-0cf1-03d7c05b20c5@chelsio.com>
 <46208469.tzXHy1sfql@positron.chronox.de>
 <25e12af5-190d-8204-0d5e-bf9a7fd190c9@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, jlulla@chelsio.com,
        atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:12939 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750770AbcKJFAw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2016 00:00:52 -0500
In-Reply-To: <25e12af5-190d-8204-0d5e-bf9a7fd190c9@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 08-11-2016 19:51, Harsh Jain wrote:
>
> On 08-11-2016 18:29, Stephan Mueller wrote:
>> Am Dienstag, 8. November 2016, 17:16:38 CET schrieb Harsh Jain:
>>
>> Hi Harsh,
>>
>>> On 08-11-2016 16:45, Stephan Mueller wrote:
>>>> Am Donnerstag, 27. Oktober 2016, 15:36:08 CET schrieb Harsh Jain:
>>>>
>>>> Hi Harsh,
>>>>
>>>>>>> +static void chcr_verify_tag(struct aead_request *req, u8 *input, int
>>>>>>> *err)
>>>>>>> +{
>>>>>>> +	u8 temp[SHA512_DIGEST_SIZE];
>>>>>>> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>>>>>>> +	int authsize = crypto_aead_authsize(tfm);
>>>>>>> +	struct cpl_fw6_pld *fw6_pld;
>>>>>>> +	int cmp = 0;
>>>>>>> +
>>>>>>> +	fw6_pld = (struct cpl_fw6_pld *)input;
>>>>>>> +	if ((get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) ||
>>>>>>> +	    (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_GCM)) {
>>>>>>> +		cmp = memcmp(&fw6_pld->data[2], (fw6_pld + 1), authsize);
>>>>>>> +	} else {
>>>>>>> +
>>>>>>> +		sg_pcopy_to_buffer(req->src, sg_nents(req->src), temp,
>>>>>>> +				authsize, req->assoclen +
>>>>>>> +				req->cryptlen - authsize);
>>>>>> I am wondering whether the math is correct here in any case. It is
>>>>>> permissible that we have an AAD size of 0 and even a zero-sized
>>>>>> ciphertext. How is such scenario covered here?
>>>>> Here we are trying to copy user supplied tag to local buffer(temp) for
>>>>> decrypt operation only. relative index of tag in src sg list will not
>>>>> change when AAD is zero and in decrypt operation cryptlen > authsize.
>>>> I am just wondering where this is checked. Since all of these
>>>> implementations are directly accessible from unprivileged user space, we
>>>> should be careful.
>>> chcr_verify_tag() will be called when req->verify is set to "VERIFY_SW", 
>>> same will set in decrypt callback function of Algo(like chcr_aead_decrypt)
>>> only. It will ensure calling of chcr_verify_tag() in de-crypt operation
>>> only.
>> I think that limiting to the decryption path may not be enough. What happens 
>> if a caller sets some assoclen, but when invoking the decryption operation it 
>> provides input data that is smaller than the assoclen? The API allows this 
>> scenario.
> If I understand correctly, in this case passed sg list will be smaller. We should return with error -EINVAL at entry point only (like create_gcm_wr), control should not reach to chcr_verify_tag().
I had a look in software implementation for check related to aad len > src sg list.  I doubt same is not handled in software also. See  below
                In "crypto_authenc_encrypt" if assoclen passed to "scatterwalk_ffwd" is greater than src. It may panic with NULL pointer exception.

 I will add  this check in V2 of chcr driver.

>
>> Ciao
>> Stephan

From: Li Kun <hw.likun@huawei.com>
Subject: Re: [PATCH RESEND] crypto: af_alg - add keylen checking to avoid NULL
 ptr passing down
Date: Tue, 19 Dec 2017 09:19:36 +0800
Message-ID: <e096dabe-33d0-57f1-bffd-c37ff9f8baee@huawei.com>
References: <1513604436-43814-1-git-send-email-hw.likun@huawei.com>
 <20171218191233.GA55142@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:12009 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759758AbdLSBTn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 20:19:43 -0500
In-Reply-To: <20171218191233.GA55142@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



在 2017/12/19 3:12, Eric Biggers 写道:
> On Mon, Dec 18, 2017 at 01:40:36PM +0000, Li Kun wrote:
>> alg_setkey do not check the keylen whether it is zero, so the key
>> may be ZERO_SIZE_PTR when keylen is 0, which will pass the
>> copy_from_user's checking and be passed to the lower functions as key.
>>
>> If the lower functions only check the key if it is NULL, ZERO_SIZE_PTR
>> will pass the checking, and will cause null ptr dereference, so it's
>> better to intercept the invalid parameters in the upper functions.
>>
>> This patch is also suitable to fix CVE-2017-15116 for stable trees.
>>
>> Signed-off-by: Li Kun <hw.likun@huawei.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   crypto/af_alg.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
>> index 337cf38..10f22f3 100644
>> --- a/crypto/af_alg.c
>> +++ b/crypto/af_alg.c
>> @@ -210,6 +210,8 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
>>   	u8 *key;
>>   	int err;
>>   
>> +	if (!keylen)
>> +		return -EINVAL;
>>   	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
>>   	if (!key)
>>   		return -ENOMEM;
>> -- 
> If the length is 0 then why is the underlying ->setkey() method dereferencing
> the pointer?  Which algorithm does this happen for?  Checking for NULL makes no
> sense; the length needs to be checked instead.
The drbg_kcapi_reset has wrongly treated the (length == 0) && (data != 
NULL) as an valid
combination of parameters which has been fixed by herbert in
commit 8fded59 (crypto: drbg - Convert to new rng interface).
But i think to avoid such things happening again, maybe we could 
intercept the length 0 error
in the entry of setkey ?


static int drbg_kcapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned 
int slen)
{
     ......
     if (0 < slen) {
         drbg_string_fill(&seed_string, seed, slen);
         return drbg_instantiate(drbg, &seed_string, coreref, pr);
     } else {
         struct drbg_gen *data = (struct drbg_gen *)seed;
         /* allow invocation of API call with NULL, 0 */
         if (!data)
             return drbg_instantiate(drbg, NULL, coreref, pr);
         drbg_set_testdata(drbg, data->test_data);
         /* linked list variable is now local to allow modification */
         drbg_string_fill(&seed_string, data->addtl->buf,
                  data->addtl->len);
         return drbg_instantiate(drbg, &seed_string, coreref, pr);
     }
}
>
> Eric

-- 
Best Regards
Li Kun

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH 2/2] crypto: chcr - Fix error checking
Date: Thu, 13 Apr 2017 16:50:45 +0200
Message-ID: <8c1af6bd-b12f-4bf7-c44a-360ea2359e08@wanadoo.fr>
References: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
 <a0f6ad87c1b9e04304e2ff4b4ddad92e7415f21f.1492085165.git.christophe.jaillet@wanadoo.fr>
 <20170413140415.6yikoizav7xaka43@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170413140415.6yikoizav7xaka43@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Le 13/04/2017 à 16:04, Dan Carpenter a écrit :
> On Thu, Apr 13, 2017 at 02:14:30PM +0200, Christophe JAILLET wrote:
>> If 'chcr_alloc_shash()' a few lines above fails, 'base_hash' can be an
>> error pointer when we 'goto out'.
>> So checking for NULL here is not enough because it is likely that
>> 'chcr_free_shash' will crash if we pass an error pointer.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Another solution, amybe safer, would be to instrument 'chcr_free_shash' or
>> 'crypto_free_shash' to accept an error pointer and return immediatelly in
>> such a case.
>> ---
>>   drivers/crypto/chelsio/chcr_algo.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
>> index f19590ac8775..41750b97f43c 100644
>> --- a/drivers/crypto/chelsio/chcr_algo.c
>> +++ b/drivers/crypto/chelsio/chcr_algo.c
>> @@ -2351,7 +2351,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
>>   	}
>>   out:
>>   	aeadctx->enckey_len = 0;
>> -	if (base_hash)
>> +	if (!IS_ERR_OR_NULL(base_hash))
>>   		chcr_free_shash(base_hash);
> Ah...  Ok.  Fine, but redo the first patch anyway because it shouldn't
> ever be NULL.
>
> regards,
> dan carpenter
Hi Dan,

I will update the first patch as you proposed in order to:
    - teach 'chcr_alloc_shash' not to return NULL
    - initialize 'base_hash' with ERR_PTR(-EINVAL)
    - update the above test to !IS_ERR.
The 2 patches will be merged in only 1.

Thanks for your suggestions.

Best regards,
CJ



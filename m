From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH 5/5] crypto: ahash.c: Require export/import in ahash
Date: Fri, 19 Jan 2018 11:53:26 +0100
Message-ID: <4099d611-ccc6-6097-9d4a-99b2306a26e5@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183441eucas1p2ee3f046a594945299ea7b75ffb13e2ca@eucas1p2.samsung.com>
        <20180118183404.12583-6-k.konieczny@partner.samsung.com>
        <5db6f843-cc51-09f2-f388-8dade440c6bc@denx.de>
        <9246bbcb-6cd0-8bc9-8286-02c44e6d01bc@partner.samsung.com>
        <1ac2ca10-7017-7e44-5651-e53a8a613177@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40896 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754860AbeASKxc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 05:53:32 -0500
In-reply-to: <1ac2ca10-7017-7e44-5651-e53a8a613177@denx.de>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 19.01.2018 11:08, Marek Vasut wrote:
> On 01/19/2018 10:53 AM, Kamil Konieczny wrote:
>> On 18.01.2018 22:31, Marek Vasut wrote:
>>> On 01/18/2018 07:34 PM, Kamil Konieczny wrote:
>>>> Export and import are mandatory in async hash. As drivers were
>>>> rewritten, drop empty wrappers and correct init of ahash transformation.
>>>
>>> Are you moving checks from the core subsystem to drivers ? This looks
>>> really nonsensical and the commit message doesn't explain the rationale
>>> for that at all.
>>
>> I am removing checks from core. Export and import were optional in beginnig
>> of crypto framework, but as time goes on they become mandatory.
> 
> Seems like if the driver doesn't implement those, the core can easily
> detect that and perform the necessary action. Moving the checks out of
> core seems like the wrong thing to do, rather you should enhance the
> checks in core if they're insufficient in my opinion.

I removed all checks. No checks in driver and no checks in crypto framework.

If you would like any check, I think the place to add them is in ahash alg
registraction, in function ahash_prepare_alg add something like:

	if ((alg->init == NULL) ||
	    (alg->digest == NULL) ||
	    (alg->final == NULL) ||
	    (alg->update == NULL) ||
	    (alg->export == NULL) ||
	    (alg->import == NULL))
		return -EINVAL;

The only downsize is this will be usefull in backport (to prevent NULL dereference),
as any new driver will have all those pointers sets.


>>>> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
>>>> ---
>>>>  crypto/ahash.c | 18 ++----------------
>>>>  1 file changed, 2 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/crypto/ahash.c b/crypto/ahash.c
>>>> index 3a35d67de7d9..c3cce508c1d4 100644
>>>> --- a/crypto/ahash.c
>>>> +++ b/crypto/ahash.c
>>>> @@ -434,16 +434,6 @@ static int ahash_def_finup(struct ahash_request *req)
>>>>  	return ahash_def_finup_finish1(req, err);
>>>>  }
>>>>  
>>>> -static int ahash_no_export(struct ahash_request *req, void *out)
>>>> -{
>>>> -	return -ENOSYS;
>>>> -}
>>>> -
>>>> -static int ahash_no_import(struct ahash_request *req, const void *in)
>>>> -{
>>>> -	return -ENOSYS;
>>>> -}
>>>> -
>>>>  static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>>>>  {
>>>>  	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
>>>> @@ -451,8 +441,6 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>>>>  
>>>>  	hash->setkey = ahash_nosetkey;
>>>>  	hash->has_setkey = false;
>>>> -	hash->export = ahash_no_export;
>>>> -	hash->import = ahash_no_import;
>>>>  
>>>>  	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
>>>>  		return crypto_init_shash_ops_async(tfm);
>>>> @@ -462,15 +450,13 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>>>>  	hash->final = alg->final;
>>>>  	hash->finup = alg->finup ?: ahash_def_finup;
>>>>  	hash->digest = alg->digest;
>>>> +	hash->export = alg->export;
>>>> +	hash->import = alg->import;
>>>>  
>>>>  	if (alg->setkey) {
>>>>  		hash->setkey = alg->setkey;
>>>>  		hash->has_setkey = true;
>>>>  	}
>>>> -	if (alg->export)
>>>> -		hash->export = alg->export;
>>>> -	if (alg->import)
>>>> -		hash->import = alg->import;
>>>>  
>>>>  	return 0;
>>>>  }
>>>>
>>>
>>>
>>
> 
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

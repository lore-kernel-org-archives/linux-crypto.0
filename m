From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: [PATCH 2/2] crypto: chcr - Fix error checking
Date: Thu, 13 Apr 2017 20:37:50 +0530
Message-ID: <CAFXBA==dGxLJWG39Vz5Ooj5vhvfs-LDz06bVyoYZZC9hnZ6dnw@mail.gmail.com>
References: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
 <a0f6ad87c1b9e04304e2ff4b4ddad92e7415f21f.1492085165.git.christophe.jaillet@wanadoo.fr>
 <20170413140415.6yikoizav7xaka43@mwanda> <8c1af6bd-b12f-4bf7-c44a-360ea2359e08@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        harsh@chelsio.com, hariprasad@chelsio.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33403 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbdDMPHw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 11:07:52 -0400
In-Reply-To: <8c1af6bd-b12f-4bf7-c44a-360ea2359e08@wanadoo.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 13, 2017 at 8:20 PM, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
> Le 13/04/2017 =C3=A0 16:04, Dan Carpenter a =C3=A9crit :
>>
>> On Thu, Apr 13, 2017 at 02:14:30PM +0200, Christophe JAILLET wrote:
>>>
>>> If 'chcr_alloc_shash()' a few lines above fails, 'base_hash' can be an
>>> error pointer when we 'goto out'.
>>> So checking for NULL here is not enough because it is likely that
>>> 'chcr_free_shash' will crash if we pass an error pointer.
>>>
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>> ---
>>> Another solution, amybe safer, would be to instrument 'chcr_free_shash'
>>> or
>>> 'crypto_free_shash' to accept an error pointer and return immediatelly =
in
>>> such a case.
>>> ---
>>>   drivers/crypto/chelsio/chcr_algo.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/chelsio/chcr_algo.c
>>> b/drivers/crypto/chelsio/chcr_algo.c
>>> index f19590ac8775..41750b97f43c 100644
>>> --- a/drivers/crypto/chelsio/chcr_algo.c
>>> +++ b/drivers/crypto/chelsio/chcr_algo.c
>>> @@ -2351,7 +2351,7 @@ static int chcr_authenc_setkey(struct crypto_aead
>>> *authenc, const u8 *key,
>>>         }
>>>   out:
>>>         aeadctx->enckey_len =3D 0;
>>> -       if (base_hash)
>>> +       if (!IS_ERR_OR_NULL(base_hash))
>>>                 chcr_free_shash(base_hash);
>>
>> Ah...  Ok.  Fine, but redo the first patch anyway because it shouldn't
>> ever be NULL.
>>
>> regards,
>> dan carpenter
>
> Hi Dan,
>
> I will update the first patch as you proposed in order to:
>    - teach 'chcr_alloc_shash' not to return NULL
>    - initialize 'base_hash' with ERR_PTR(-EINVAL)
>    - update the above test to !IS_ERR.
> The 2 patches will be merged in only 1.
>
> Thanks for your suggestions.

Thanks for pointing the error. or You can simply return instead of
goto. Just like that.

     1.3 @@ -2455,7 +2455,8 @@ static int chcr_authenc_setkey(struct cr
     1.4   base_hash  =3D chcr_alloc_shash(max_authsize);
     1.5   if (IS_ERR(base_hash)) {
     1.6   pr_err("chcr : Base driver cannot be loaded\n");
     1.7 - goto out;
     1.8 + aeadctx->enckey_len =3D 0;
     1.9 + return -EINVAL;
    1.10   }
    1.11   {
    1.12   SHASH_DESC_ON_STACK(shash, base_hash);





>
> Best regards,
> CJ
>

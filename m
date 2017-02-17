From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2] dm: switch dm-verity to async hash crypto API
Date: Fri, 17 Feb 2017 16:52:06 +0200
Message-ID: <CAOtvUMfBiLGddm2ZpxP+zDVCmeWVtaHG-VCt7PfoWn9wVLid_A@mail.gmail.com>
References: <1486389482-26992-1-git-send-email-gilad@benyossef.com> <74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37280 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934028AbdBQOwH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 09:52:07 -0500
Received: by mail-it0-f53.google.com with SMTP id x75so17023631itb.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2017 06:52:07 -0800 (PST)
In-Reply-To: <74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Milan,

Thank you for the review and testing.

On Fri, Feb 17, 2017 at 3:00 PM, Milan Broz <gmazyland@gmail.com> wrote:
> On 02/06/2017 02:58 PM, Gilad Ben-Yossef wrote:
>> Use of the synchronous digest API limits dm-verity to using pure
>> CPU based algorithm providers and rules out the use of off CPU
>> algorithm providers which are normally asynchronous by nature,
>> potentially freeing CPU cycles.
>>
>> This can reduce performance per Watt in situations such as during
>> boot time when a lot of concurrent file accesses are made to the
>> protected volume.
>>
>> Move DM_VERITY to the asynchronous hash API.
>
> Did you test that async hash completion path?

Yes, I did - with the Arm TrustZone CryptoCell hardware accelerator.
I did not try with cryptd though.
>
> I just tried to force async crypto by replacing "sha256"
> in mapping table with "cryptd(sha256-generic)" and it kills
> kernel immediately.
> https://mbroz.fedorapeople.org/tmp/verity-fail.png
>
> (I hope this trick should cause to use cryptd and use async processing.
> In previous version the parameter is properly rejected, because unsupported
> by shash api.)
>

Thanks for this trick. I was not aware you can invoke cryptd it like that.

I will recreate the issue and fix it.

>
> Some more comments below.
> ...
>
>> -static int verity_hash_update(struct dm_verity *v, struct shash_desc *desc,
>> -                           const u8 *data, size_t len)
>> +static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
>> +                             const u8 *data, size_t len,
>> +                             struct verity_result *res)
>>  {
>> -     int r = crypto_shash_update(desc, data, len);
>> +     struct scatterlist sg;
>>
>> -     if (unlikely(r < 0))
>> -             DMERR("crypto_shash_update failed: %d", r);
>> +     sg_init_table(&sg, 1);
>> +     sg_set_buf(&sg, data, len);
>
> why not use sg_init_one?

No good reason. I will amend it in the next revision.

>
>> +     ahash_request_set_crypt(req, &sg, NULL, len);
>> +
>> +     return verity_complete_op(res, crypto_ahash_update(req));
>> +}
>
> ...
>
>> -int verity_hash(struct dm_verity *v, struct shash_desc *desc,
>> +int verity_hash(struct dm_verity *v, struct ahash_request *req,
>>               const u8 *data, size_t len, u8 *digest)
>>  {
>>       int r;
>> +     struct verity_result res;
>>
>> -     r = verity_hash_init(v, desc);
>> +     r = verity_hash_init(v, req, &res);
>>       if (unlikely(r < 0))
>> -             return r;
>> +             goto out;
>
> why it is changed to goto? it doesn't simplify anything in this function
>

I generally prefer for a function to have a single return point, if it does
not over complicates things. I find it makes code more readable and easier
to reason about - put debugging log statement for return for example.

>>
>> -     r = verity_hash_update(v, desc, data, len);
>> +     r = verity_hash_update(v, req, data, len, &res);
>>       if (unlikely(r < 0))
>> -             return r;
>> +             goto out;
>> +
>> +     r = verity_hash_final(v, req, digest, &res);
>>
>> -     return verity_hash_final(v, desc, digest);
>> +out:
>> +     return r;
>>  }

I will post a new revision of the patch early next week  .

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

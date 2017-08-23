From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [BUGFIX PATCH] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 12:04:38 +0300
Message-ID: <CAOtvUMeKoEZArSiyF1dtdEiGbCr9dxU1Wf49E3k7vywbPmq=rQ@mail.gmail.com>
References: <1503474071-7049-1-git-send-email-gilad@benyossef.com> <5180851.2L9GoHaKL8@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35837 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753513AbdHWJEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 05:04:39 -0400
Received: by mail-oi0-f47.google.com with SMTP id r200so10585862oie.2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Aug 2017 02:04:39 -0700 (PDT)
In-Reply-To: <5180851.2L9GoHaKL8@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 23, 2017 at 10:47 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 23. August 2017, 09:41:11 CEST schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
>>
>>       if (areq) {
>> +             /*
>> +              * The crypto API expects us to set the req->info to the last
>> +              * ciphertext block. For encrypt, simply copy from the result.
>> +              * For decrypt, we must copy from a saved buffer since this
>> +              * could be an in-place decryption operation and the src is
>> +              * lost by this point.
>> +              */
>> +             if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
>> +                     memcpy(req->info, req_ctx->backup_info, ivsize);
>> +                     kfree(req_ctx->backup_info);
>> +             } else {
>> +                     scatterwalk_map_and_copy(req->info, req->dst,
>> +                                              (req->nbytes - ivsize),
>> +                                              ivsize, 0);
>> +             }
>> +
>>               ablkcipher_request_complete(areq, completion_error);
>>               return 0;
>>       }
>> @@ -858,7 +876,6 @@ static int ssi_ablkcipher_encrypt(struct
>> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
>> ablkcipher_request_ctx(req); unsigned int ivsize =
>> crypto_ablkcipher_ivsize(ablk_tfm);
>>
>> -     req_ctx->backup_info = req->info;
>>       req_ctx->is_giv = false;
>>
>>       return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
>> req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
>> @@ -871,8 +888,18 @@ static int ssi_ablkcipher_decrypt(struct
>> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
>> ablkcipher_request_ctx(req); unsigned int ivsize =
>> crypto_ablkcipher_ivsize(ablk_tfm);
>>
>> -     req_ctx->backup_info = req->info;
>> +     /*
>> +      * Allocate and save the last IV sized bytes of the source, which will
>> +      * be lost in case of in-place decryption and might be needed for CTS.
>> +      */
>> +     req_ctx->backup_info = kmalloc(ivsize, GFP_KERNEL);
>> +     if (!req_ctx->backup_info)
>> +             return -ENOMEM;
>
> Are you sure you do not add a memleak here? You seem to unconditionally
> allocate memory but conditionally free it.

You are right. I've missed freeing the memory on error code paths.
Thank you for catching that.
The code involved is badly need of a re-write but I wanted to get the
obvious bug fixed first.
I will send a revised patch

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

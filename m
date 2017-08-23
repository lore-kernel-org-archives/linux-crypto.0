From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hw_random: timeriomem-rng: Remove 'max < 4' condition check
Date: Wed, 23 Aug 2017 08:32:18 +0530
Message-ID: <CANc+2y5gt_yMJvs9uDzhRSdpD-M6vnsxPOWziodKsy_v_yvv+w@mail.gmail.com>
References: <20170822162224.26801-1-prasannatsmkumar@gmail.com> <CAPLgG==6YgPO9CxRucbqEyfL5hb8m6YWqBfr_DPcBh5v2_=25Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Rick Altherr <raltherr@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34801 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWDCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 23:02:19 -0400
Received: by mail-io0-f194.google.com with SMTP id p141so600687iop.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2017 20:02:19 -0700 (PDT)
In-Reply-To: <CAPLgG==6YgPO9CxRucbqEyfL5hb8m6YWqBfr_DPcBh5v2_=25Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rick,

On 22 August 2017 at 22:23, Rick Altherr <raltherr@google.com> wrote:
> On Tue, Aug 22, 2017 at 9:22 AM, PrasannaKumar Muralidharan
> <prasannatsmkumar@gmail.com> wrote:
>>
>> In read routiene max is always >= 4. The check whether 'max < 4' is not
>> necessary. Remove it.
>
> Missed that in the header.

It was added recently so you could have not missed it.

>
> Acked-By: Rick Altherr <raltherr@google.com>
>
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> ---
>>  drivers/char/hw_random/timeriomem-rng.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
>> index 03ff548..f615684 100644
>> --- a/drivers/char/hw_random/timeriomem-rng.c
>> +++ b/drivers/char/hw_random/timeriomem-rng.c
>> @@ -53,13 +53,6 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
>>         int period_us = ktime_to_us(priv->period);
>>
>>         /*
>> -        * The RNG provides 32-bits per read.  Ensure there is enough space for
>> -        * at minimum one read.
>> -        */
>> -       if (max < sizeof(u32))
>> -               return 0;
>> -
>> -       /*
>>          * There may not have been enough time for new data to be generated
>>          * since the last request.  If the caller doesn't want to wait, let them
>>          * bail out.  Otherwise, wait for the completion.  If the new data has
>> --
>> 2.10.0
>>

Regards,
PrasannaKumar

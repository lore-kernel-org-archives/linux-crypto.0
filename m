From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: core - Allocate memory during module init
Date: Wed, 7 Sep 2016 18:44:32 +0530
Message-ID: <CANc+2y6ywn-9E0Cv5io6=ZWRFW8Q+GTnubFH31p0y1-WQsGbYQ@mail.gmail.com>
References: <1472977778-23996-1-git-send-email-prasannatsmkumar@gmail.com> <20160907125350.GB17176@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: mpm@selenic.com, jslaby@suse.cz, peter@korsgaard.com,
        Lee Jones <lee.jones@linaro.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36272 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757551AbcIGNOe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:14:34 -0400
Received: by mail-yb0-f194.google.com with SMTP id u125so238276ybg.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2016 06:14:33 -0700 (PDT)
In-Reply-To: <20160907125350.GB17176@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> On Sun, Sep 04, 2016 at 01:59:38PM +0530, PrasannaKumar Muralidharan wrote:
>>
>> @@ -573,6 +557,17 @@ EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
>>
>>  static int __init hwrng_modinit(void)
>>  {
>> +     /* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
>> +     rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
>> +     if (!rng_buffer)
>> +             return -ENOMEM;
>> +
>> +     rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
>> +     if (!rng_fillbuf) {
>> +             kfree(rng_buffer);
>> +             return -ENOMEM;
>> +     }
>> +
>>       return register_miscdev();
>
> You're leaking memory if register_miscdev fails.

Ah, yes! I can send a revised patch.
Do you think allocating rng_buffer, rng_fillbuf in module init useful?
If not there is no point in sending a new patch with fix.

Thanks,
PrasannaKumar

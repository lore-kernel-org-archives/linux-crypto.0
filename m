From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in add_early_randomness()
Date: Mon, 17 Oct 2016 10:30:13 -0700
Message-ID: <CALCETrVYuo1yNWyRQBRt3HwM4EJ7c5FAMZdEgnzKCHqMRCryXQ@mail.gmail.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
 <2711337.nAU4qxUyQs@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34888 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938648AbcJQRax (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 13:30:53 -0400
Received: by mail-vk0-f51.google.com with SMTP id q126so132247412vkd.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2016 10:30:53 -0700 (PDT)
In-Reply-To: <2711337.nAU4qxUyQs@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 17, 2016 at 10:17 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 17. Oktober 2016, 10:06:27 CEST schrieb Andy Lutomirski:
>
> Hi Andy,
>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index 9203f2d130c0..340f96e44642 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -84,14 +84,14 @@ static size_t rng_buffer_size(void)
>>
>>  static void add_early_randomness(struct hwrng *rng)
>>  {
>> -     unsigned char bytes[16];
>>       int bytes_read;
>> +     size_t size = min_t(size_t, 16, rng_buffer_size());
>>
>>       mutex_lock(&reading_mutex);
>> -     bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
>> +     bytes_read = rng_get_data(rng, rng_buffer, size, 1);
>>       mutex_unlock(&reading_mutex);
>>       if (bytes_read > 0)
>> -             add_device_randomness(bytes, bytes_read);
>> +             add_device_randomness(rng_buffer, bytes_read);
>
> Shouldn't there be a memset(0) of the rng_buffer at this point to avoid having
> such data lingering in memory?

Sure, but shouldn't that be a separate patch covering the whole hw_crypto core?

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC

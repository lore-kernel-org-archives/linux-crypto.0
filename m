Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E3FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 20:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E00521D81
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 20:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfJDU1R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 16:27:17 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52227 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbfJDU1R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 16:27:17 -0400
X-Originating-IP: 5.252.68.29
Received: from d.localdomain (unknown [5.252.68.29])
        (Authenticated sender: out@gert.gr)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 4D4F31C0005;
        Fri,  4 Oct 2019 20:27:13 +0000 (UTC)
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jelle de Jong <jelledejong@powercraft.nl>
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
 <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
 <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
 <decd3196-8679-7298-7967-25cb231357fb@gert.gr>
 <20191004193758.GA244757@gmail.com>
From:   Gert Robben <t2@gert.gr>
Message-ID: <ac175710-9a26-3a53-9330-af731f4c0dda@gert.gr>
Date:   Fri, 4 Oct 2019 22:27:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004193758.GA244757@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Op 04-10-2019 om 21:37 schreef Eric Biggers:
> On Fri, Oct 04, 2019 at 03:29:33PM +0200, Gert Robben wrote:
>> Op 04-10-2019 om 08:16 schreef Ard Biesheuvel:
>>> On Thu, 3 Oct 2019 at 23:26, Gert Robben <t2@gert.gr> wrote:
>>>> Op 03-10-2019 om 15:39 schreef Ard Biesheuvel:
>>>>> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
>>>>> the generic CBC template wrapper from a blkcipher to a skcipher algo,
>>>>> to get away from the deprecated blkcipher interface. However, as a side
>>>>> effect, drivers that instantiate CBC transforms using the blkcipher as
>>>>> a fallback no longer work, since skciphers can wrap blkciphers but not
>>>>> the other way around. This broke the geode-aes driver.
>>>>>
>>>>> So let's fix it by moving to the sync skcipher interface when allocating
>>>>> the fallback.
>>>>>
>>>>> Cc: Gert Robben <t2@gert.gr>
>>>>> Cc: Jelle de Jong <jelledejong@powercraft.nl>
>>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>>> ---
>>>>> Gert, Jelle,
>>>>>
>>>>> If you can, please try this patch and report back to the list if it solves
>>>>> the Geode issue for you.
>>>>
>>>> Thanks for the patch!
>>>> I tried it on Alix 2C2 / Geode LX800 with Linux 5.4-rc1 (also 5.1-5.3 fwiw).
>>>>
>>>> At least now openssl doesn't give those errors anymore.
>>>> (openssl speed -evp aes-128-cbc -elapsed -engine afalg)
>>>> But looking at the results (<6MB/s), apparently it's not using geode-aes
>>>> (>30MB/s?).
>>>> In dmesg can be seen:
>>>>
>>>> alg: skcipher: ecb-aes-geode encryption test failed (wrong result) on
>>>> test vector 1, cfg="out-of-place"
>>>> alg: skcipher: cbc-aes-geode encryption test failed (wrong result) on
>>>> test vector 2, cfg="out-of-place"
>>>> Geode LX AES 0000:00:01.2: GEODE AES engine enabled.
>>>>
>>>> In /proc/crypto, drivers cbc-aes-geode/ecb-aes-geode are listed with
>>>> "selftest: unknown". Driver "geode-aes" has "selftest: passed".
>>>>
>>>> I'm happy to test other patches.
>>>
>>> Oops, mistake there on my part
>>>
>>> Can you replace the two instances of
>>>
>>> skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);
>>>
>>> with
>>>
>>> skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
>>>
>>> please?
>>
>> Yes, with that change, now it works in 5.4-rc1:
>>
>> # openssl speed -evp aes-128-cbc -elapsed -engine afalg
>> - - - 8< - - -
>> The 'numbers' are in 1000s of bytes per second processed.
>> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
>> bytes  16384 bytes
>> aes-128-cbc        125.63k      499.39k     1858.18k     6377.00k 25753.93k
>> 31167.08k
>>
>> I also quickly tried nginx https, that seems to transfer a file correctly.
>> And a bit faster, but not by this much, I have to look into that further.
>> For now I assume the kernel part seems to be working fine.
>>
>> Thanks, much appreciated!
>> Gert
> 
> 
> Can you check whether it passes the extra self-tests too?  I.e. enable
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

Yes, with that option dmesg says additionally (I did several reboots):

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=24 klen=16"; expected_error=-22, cfg="random: 
inplace use_finup src_divs=[18.14%@alignmask+19, 81.86%@+25] iv_offset=22"

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=148 klen=16"; expected_error=-22, cfg="random: 
inplace use_digest nosimd src_divs=[100.0%@+22] iv_offset=50"

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=168 klen=16"; expected_error=-22, cfg="random: 
use_digest nosimd src_divs=[76.11%@alignmask+18, 13.8%@+4056, 
4.57%@+3984, 5.36%@+506, 0.68%@+3989, 0.17%@+1620, 0.3%@+4025] iv_offset=27"

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=33 klen=16"; expected_error=-22, cfg="random: 
may_sleep use_digest src_divs=[97.79%@+20, 2.21%@+4016] iv_offset=38"

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=202 klen=16"; expected_error=-22, cfg="random: 
inplace use_final nosimd src_divs=[<reimport,nosimd>100.0%@+15] 
iv_offset=44"

alg: skcipher: ecb-aes-geode encryption unexpectedly succeeded on test 
vector "random: len=60 klen=16"; expected_error=-22, cfg="random: 
use_digest src_divs=[83.68%@+1899, 7.27%@alignmask+1670, 5.73%@+11, 
3.32%@+3985]"

Regards, Gert

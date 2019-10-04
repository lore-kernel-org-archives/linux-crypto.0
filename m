Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB36DC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86AF207FF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfJDN3i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:29:38 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35301 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387917AbfJDN3i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:29:38 -0400
X-Originating-IP: 193.36.116.148
Received: from d.localdomain (unknown [193.36.116.148])
        (Authenticated sender: out@gert.gr)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 8CA771BF206;
        Fri,  4 Oct 2019 13:29:34 +0000 (UTC)
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes)
 fallback
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jelle de Jong <jelledejong@powercraft.nl>
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
 <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
 <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
From:   Gert Robben <t2@gert.gr>
Message-ID: <decd3196-8679-7298-7967-25cb231357fb@gert.gr>
Date:   Fri, 4 Oct 2019 15:29:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Op 04-10-2019 om 08:16 schreef Ard Biesheuvel:
> On Thu, 3 Oct 2019 at 23:26, Gert Robben <t2@gert.gr> wrote:
>> Op 03-10-2019 om 15:39 schreef Ard Biesheuvel:
>>> Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
>>> the generic CBC template wrapper from a blkcipher to a skcipher algo,
>>> to get away from the deprecated blkcipher interface. However, as a side
>>> effect, drivers that instantiate CBC transforms using the blkcipher as
>>> a fallback no longer work, since skciphers can wrap blkciphers but not
>>> the other way around. This broke the geode-aes driver.
>>>
>>> So let's fix it by moving to the sync skcipher interface when allocating
>>> the fallback.
>>>
>>> Cc: Gert Robben <t2@gert.gr>
>>> Cc: Jelle de Jong <jelledejong@powercraft.nl>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>> Gert, Jelle,
>>>
>>> If you can, please try this patch and report back to the list if it solves
>>> the Geode issue for you.
>>
>> Thanks for the patch!
>> I tried it on Alix 2C2 / Geode LX800 with Linux 5.4-rc1 (also 5.1-5.3 fwiw).
>>
>> At least now openssl doesn't give those errors anymore.
>> (openssl speed -evp aes-128-cbc -elapsed -engine afalg)
>> But looking at the results (<6MB/s), apparently it's not using geode-aes
>> (>30MB/s?).
>> In dmesg can be seen:
>>
>> alg: skcipher: ecb-aes-geode encryption test failed (wrong result) on
>> test vector 1, cfg="out-of-place"
>> alg: skcipher: cbc-aes-geode encryption test failed (wrong result) on
>> test vector 2, cfg="out-of-place"
>> Geode LX AES 0000:00:01.2: GEODE AES engine enabled.
>>
>> In /proc/crypto, drivers cbc-aes-geode/ecb-aes-geode are listed with
>> "selftest: unknown". Driver "geode-aes" has "selftest: passed".
>>
>> I'm happy to test other patches.
> 
> Oops, mistake there on my part
> 
> Can you replace the two instances of
> 
> skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);
> 
> with
> 
> skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> 
> please?

Yes, with that change, now it works in 5.4-rc1:

# openssl speed -evp aes-128-cbc -elapsed -engine afalg
- - - 8< - - -
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-cbc        125.63k      499.39k     1858.18k     6377.00k 
25753.93k    31167.08k

I also quickly tried nginx https, that seems to transfer a file correctly.
And a bit faster, but not by this much, I have to look into that further.
For now I assume the kernel part seems to be working fine.

Thanks, much appreciated!
Gert

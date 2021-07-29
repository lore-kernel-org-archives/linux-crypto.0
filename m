Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E979BC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jul 2021 10:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1C660560
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jul 2021 10:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhG2KcN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jul 2021 06:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbhG2KcM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jul 2021 06:32:12 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603CC061765
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jul 2021 03:32:08 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id kj19so2382558qvb.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jul 2021 03:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zj4291g6uOrD0xUvEsbbSf9Ldg6TqIVT4PmrCRUC1Ig=;
        b=fcDrWUYN+hcOHoboPhHeZT4zGRcYLLueHREHhfA0vJz7dk6jNfENA5Cn72Kn32I4R7
         UX4rXXwJ9MrM0/VqjpCob1ottBoiJLh0tKeNOkcM57XT1xGA3slHkjrrveettlZlCch4
         Vdh6v0qFwtD91+yD9kIbydTKFQB5VwDhUY7w9OPfTJAesUpYkT5LSEwAAFQUxfyfDFvt
         ZFt3mnrP6kMiiHHaDKo+F5wL/ZoxOhdd6gXBEJ5wzI2eA7aCGuoj8YEXOhOObOUqgaht
         zaexJ6EzQbBLprlwugBViC07htgPfOpf8w43F7lwoyuWnWp0tIKaziWaq7TSCkliyvBb
         1mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zj4291g6uOrD0xUvEsbbSf9Ldg6TqIVT4PmrCRUC1Ig=;
        b=UOqywiyZ1DBH7iTSFfHk5AiHqdStzGtaJ+wXRw0ISReIq/wA19DOR2FfaKUV1oUdJ6
         Aw6id7MYfmdik0zlf1+T0X/oAjPG8JGPpVJWxPwMad9ANxJRgWti1W3VKKVrzL+rMN/U
         R/K9zEdIL4iGIwzpn2XesUfrS4BvF4H3pJjsVzeI0ooibQl/IuizbR3S1C8Cdp452vcR
         h52y4SYRxW83ThzzjeVG93KVKoy9jeOR4koJJkytXttyfFR5qbMzSvzz4r7k6kzSNKiI
         6uRfph0RGEzPGox1eLbedG1seyoiQv+djyg8yYsjt26f5A/FwvXcPBEDEBSxZnvy9fyE
         Jk4Q==
X-Gm-Message-State: AOAM531wZNu8J2AvwampqWnbf87azD3sHF5BrV8M72wJ6wObw3/9xFzz
        0m8QPMR25m1EXKNrzJYzvBlpxV+ufRJWeQ==
X-Google-Smtp-Source: ABdhPJwiPbfSsV8BKnqU+2W7uoczEKHpO3/RYp3/x+bxIEP+56RiOAN/VD/37Is/PsXgyZ7hrxg5jA==
X-Received: by 2002:ad4:5bec:: with SMTP id k12mr4536985qvc.5.1627554727541;
        Thu, 29 Jul 2021 03:32:07 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id o15sm1061935qtp.25.2021.07.29.03.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 03:32:07 -0700 (PDT)
Subject: Re: Extending CRYPTO_ALG_OPTIONAL_KEY for cipher algorithms
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <f04c8f1d-db85-c9e1-1717-4ca98b7c8c35@linaro.org>
 <YPrsScKf/YlKmNfU@gmail.com>
 <CAOtvUMfwbBr44qOCma4RaH_RoC35x00N=O1Ejaxc+5EPGY8rUw@mail.gmail.com>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <42d22781-be50-174d-033a-bac0ed5efffb@linaro.org>
Date:   Thu, 29 Jul 2021 06:32:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMfwbBr44qOCma4RaH_RoC35x00N=O1Ejaxc+5EPGY8rUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/24/21 5:42 AM, Gilad Ben-Yossef wrote:
> On Fri, Jul 23, 2021 at 7:20 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> On Fri, Jul 23, 2021 at 06:13:50AM -0400, Thara Gopinath wrote:
>>> Hi
>>>
>>> I have a requirement where the keys for the crypto cipher algorithms are
>>> already programmed in the h/w pipes/channels and thus the ->encrypt()
>>> and ->decrypt() can be called without set_key being called first.
>>> I see that CRYPTO_ALG_OPTIONAL_KEY has been added to take care of
>>> such requirements for CRC-32. My question is can the usage of this flag
>>> be extended for cipher and other crypto algorithms as well. Can setting of
>>> this flag indicate that the algorithm can be used without calling set_key
>>> first and then the individual drivers can handle cases where
>>> both h/w keys and s/w keys need to be supported.
>>
>> CRYPTO_ALG_OPTIONAL_KEY isn't meant for this use case, but rather for algorithms
>> that have both keyed and unkeyed versions such as BLAKE2b and BLAKE2s, and also
>> for algorithms where the "key" isn't actually a key but rather is an initial
>> value that has a default value, such as CRC-32 and xxHash.
>>
>> It appears that that the case you're asking about is handled by using a
>> different algorithm name, e.g. see the "paes" algorithms in
>> drivers/crypto/ccree/cc_cipher.c.
> 
> Yeap, seems like another use case for "protected keys" like CryptoCell
> and the IBM mainframe.
> I gave a talk about this you might find useful -
> https://www.youtube.com/watch?v=GbcpwUBFGDw
> 
> Feel free to contact me if you have questions.

Thanks Eric and Gilad for the pointers. Gilad, the talk is great. I wish 
I had seen it prior to telling my manager that we will have to "invent" 
something new for this! This should mostly suffice for my use-case. 
Although, I see that all the protected implementations are for aes 
algorithms. Is it fair to say that it can be extended to other cipher 
algorithms and/or hash algorithms if needed ?

> 
> Cheers,
> Gilad
> 

-- 
Warm Regards
Thara (She/Her/Hers)

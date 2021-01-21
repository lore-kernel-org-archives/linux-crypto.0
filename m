Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0740CC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF17420663
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbhAUS0E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbhAUSX6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 13:23:58 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2EC06174A
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2021 10:23:17 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g3so3995714ejb.6
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2021 10:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gfKHhBWnllqV8aYIWdKy3xPP8GjYeDgbWRRf1nj3hU4=;
        b=A7bKNXnlzmjGEhMCNFdKraWE2UinHp3+g53w92NXQw6D4HRmkYR1TamlhYy7hxhfqU
         JAa5o1DJKzhfcw0ySPsijksvbvKWhrNASWU0q5v+177wE+ZYEOhlmKfl/LQY/EKCgens
         3/JBlLwZi20Tfk9nu+ToDUAZ8VGFY0EmUW3Gb/339DVq5QdZu5st2D3NTEIWDo5+ioa6
         PL3iHZogxxP19ZLrXNSGmRbOYCiypwnDrDiFFxYms7bQnEtrZAPBjTw5ntt07AQuKDXx
         VD9aBRrtqPwuvAtSXJxkFe+Hy3cAPyd/pDPAfz0PGoeoKKh5jyPpovy3oNJHizSFi64x
         WK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gfKHhBWnllqV8aYIWdKy3xPP8GjYeDgbWRRf1nj3hU4=;
        b=nVVzqaWZE9hvJqSb6+dllTJrMUDMOquaZslS7BGr2+WosgoB1UOVb6ABZIHUsFuRFA
         VvbkoCCCpN+MUGyTfWSuaxvEots3jL1rBvpR8mV4FL88cuuSSfeA7fGiPW3Oor6cMdqG
         Jag5RuctRBffCUdSMt8QuLm8kmcEt8BIS2nLjA1qNT6YMKeAx5s0rTT6UN8tSxVKPEE5
         ZGZ7dw7xqjRuj8/XuofwHbbkkA3GUA9ps06znoZN+ezm/L0cyurqaZzwSOxqaqJ1PzNg
         fh2bcoVNm3mzSYd6jVjZ8T86M90tArxc2q2Q99HgHk+QGhFv9c9SHl2kWRGkmq2rOUcS
         F1kQ==
X-Gm-Message-State: AOAM530sSqHdCiB7if3l8OSvyRI4jPKXIxI4y8lRirCBtJjedt2IE6Zo
        ke2UZvFSrwL6MGIADVSr0zA=
X-Google-Smtp-Source: ABdhPJxN19zAsqU9K27OZ22QxGfnOp2IjFjqXs8iYJ81v/hx0qvhnT+mheRm1N1MkjTRLuHyKGwotw==
X-Received: by 2002:a17:906:3999:: with SMTP id h25mr538652eje.146.1611253396600;
        Thu, 21 Jan 2021 10:23:16 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id x9sm1144459eje.36.2021.01.21.10.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 10:23:16 -0800 (PST)
Subject: Re: [PATCH 5/5] crypto: remove Salsa20 stream cipher algorithm
To:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, agk@redhat.com,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20210121130733.1649-1-ardb@kernel.org>
 <20210121130733.1649-6-ardb@kernel.org> <YAnCbnnFCQkyBpUA@sol.localdomain>
 <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <2f010ae0-b949-d9b8-c382-e02447b36166@gmail.com>
Date:   Thu, 21 Jan 2021 19:23:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21/01/2021 19:09, Ard Biesheuvel wrote:
> On Thu, 21 Jan 2021 at 19:05, Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> On Thu, Jan 21, 2021 at 02:07:33PM +0100, Ard Biesheuvel wrote:
>>> Salsa20 is not used anywhere in the kernel, is not suitable for disk
>>> encryption, and widely considered to have been superseded by ChaCha20.
>>> So let's remove it.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 +-
>>>  crypto/Kconfig                                           |   12 -
>>>  crypto/Makefile                                          |    1 -
>>>  crypto/salsa20_generic.c                                 |  212 ----
>>>  crypto/tcrypt.c                                          |   11 +-
>>>  crypto/testmgr.c                                         |    6 -
>>>  crypto/testmgr.h                                         | 1162 --------------------
>>>  7 files changed, 3 insertions(+), 1405 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> index 4e6f504474ac..d56112e2e354 100644
>>> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>>> @@ -143,8 +143,8 @@ recalculate
>>>  journal_crypt:algorithm(:key)        (the key is optional)
>>>       Encrypt the journal using given algorithm to make sure that the
>>>       attacker can't read the journal. You can use a block cipher here
>>> -     (such as "cbc(aes)") or a stream cipher (for example "chacha20",
>>> -     "salsa20" or "ctr(aes)").
>>> +     (such as "cbc(aes)") or a stream cipher (for example "chacha20"
>>> +     or "ctr(aes)").
>>
>> You should check with the dm-integrity maintainers how likely it is that people
>> are using salsa20 with dm-integrity.  It's possible that people are using it,
>> especially since the documentation says that dm-integrity can use a stream
>> cipher and specifically gives salsa20 as an example.
>>
> 
> Good point - cc'ed them now.

I would say - just remove it. I do not see any users, we do not even test this combination in userspace testsuite.
It is just an example in doc.

From my POV these stream crypto ciphers should be never used there (but cc to Mikulas, it was his patch :-)

Milan

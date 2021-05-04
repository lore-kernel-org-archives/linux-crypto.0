Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5562BC433ED
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 17:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 254D7610EA
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 17:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhEDSAl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 May 2021 14:00:41 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:53199 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhEDSAj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 May 2021 14:00:39 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d41 with ME
        id 0hzg2500421Fzsu03hzghD; Tue, 04 May 2021 19:59:43 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 04 May 2021 19:59:43 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [RFC PATCH] crypto: arc4: Implement a version optimized for
 memory usage
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <c52bd8972c9763c3fac685d7c6af3c46a23a1477.1619983555.git.christophe.jaillet@wanadoo.fr>
 <YJF8/oaWUqZsWfOb@gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <d523902e-744c-1291-aee8-9be734f2a3ce@wanadoo.fr>
Date:   Tue, 4 May 2021 19:59:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YJF8/oaWUqZsWfOb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le 04/05/2021 à 18:57, Eric Biggers a écrit :
> On Sun, May 02, 2021 at 09:29:46PM +0200, Christophe JAILLET wrote:
>> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>> +#define S_type	u8
>> +#else
>> +#define S_type	u32
>> +#endif
>> +
>>   struct arc4_ctx {
>> -	u32 S[256];
>> +	S_type S[256];
>>   	u32 x, y;
>>   };
> 
> Is it actually useful to keep both versions?  It seems we could just use the u8
> version everywhere.  Note that there aren't actually any unaligned memory
> accesses, so choosing the version conditionally on
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS seems odd.  What are you trying to
> determine by checking that?

Hi, this is a bad interpretation from me.

I thought that S[1] would likely use an odd address and would trigger an 
unaligned access. But as we would read only 1 byte, this is not the case.

Looking at [1], we have : "At this point, it should be clear that 
accessing a single byte (u8 or char) will never cause an unaligned 
access, because all memory addresses are evenly divisible by one."


I wanted to avoid potential performance cost related to using char (i.e 
u8) instead of int (i.e. u32).
On some architecture this could require some shift or masking or 
whatever to "unpack" the values of S.


[1]: 
https://www.kernel.org/doc/html/latest/core-api/unaligned-memory-access.html

CJ

> 
> - Eric
> 


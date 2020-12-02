Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5819C64E7A
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 00:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564EB221FF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 00:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgLBABp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 19:01:45 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35088 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBABp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 19:01:45 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 76F6B13C2B0;
        Tue,  1 Dec 2020 16:01:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 76F6B13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1606867264;
        bh=WTX+Mnb1chP7Q0YoQxvMpvJjUt3fUG1EFWiHaisdiw4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WBmORSOveRa30UoQVvE/1ZHi8VHjMmIQAlGImqBgEJdTlhAC8gMcwfmp62xPOpQZe
         KToEs5qCXORSFSKKn2F3TyhNiLIQWtIWmYdgHmRz49BD3pGgM/0IGFSxvpfE02nRi7
         RRpl9lFK2GG5+AWLseKgx6qPUy1WG1+1+y7kmrd8=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
 <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
 <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
 <20201201233024.GB32382@gondor.apana.org.au>
 <CAMj1kXEfRCNuaz_sX29CQ=JsUF6niYbYceXUjy9cq3=eF77mvg@mail.gmail.com>
 <20201201234812.GA32538@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <e9161d9d-5f8d-46fa-9d4f-c953633f6fb2@candelatech.com>
Date:   Tue, 1 Dec 2020 16:01:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201201234812.GA32538@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/1/20 3:48 PM, Herbert Xu wrote:
> On Wed, Dec 02, 2020 at 12:41:36AM +0100, Ard Biesheuvel wrote:
>>
>> You just explained that TX typically runs in process context, whereas
>> RX is handled in softirq context. So how exactly are these going to
>> end up on the same core?
> 
> When you receive a TCP packet via RX, this should wake up your user-
> space thread on the same CPU as otherwise you'll pay extra cost
> on pulling the data into memory again.
> 
>> Yes, but IPsec will not use the synchronous interface.
> 
> That doesn't matter when the underlying wireless code is using
> the sync interface.  An async user is completely capable of making
> the aesni code-path unavailable to the sync user.
>   
>> Fair enough. But it is unfortunate that we cannot support Ben's use
>> case without a lot of additional work that serves no purpose
>> otherwise.
> 
> To the contrary, I think to fully support Ben's use case you must
> use the async code path.  Otherwise sure you'll see good numbers
> when you do simple benchmarks like netperf, but when you really
> load up the system it just falls apart.

I can generate some very complicated traffic to test this, including bi-directional
traffic, mix of tcp/udp/https, etc.  If numbers will sway your opinion, let me know what
traffic tests will make you happy and I'll do the testing.

I know for sure that in download traffic (which is normal dominant direction for wifi stations),
Ard's patch gives me about 3x increase of throughput.  Without the patch, softirqd is pegged
100% futzing around with enabling and disabling the fpu.

The wifi stack people do not want any extra complexity in their code,
and async processing of this would be a lot of complexity.  So, even if I wanted
to implement it, likely it would never make it upstream anyway.

I also suspect that general users may benefit from this aesni patch since
many older wifi chipsets don't support wpa3 in hardware and wpa3 is the new
hotness in wifi.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

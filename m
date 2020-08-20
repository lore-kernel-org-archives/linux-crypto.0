Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AB7C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 22:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86572087D
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 22:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="FOoFx+gl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHTWJ6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 18:09:58 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:52158 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHTWJ5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 18:09:57 -0400
Received: from [192.168.254.6] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1909513C2B1;
        Thu, 20 Aug 2020 15:09:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1909513C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1597961396;
        bh=uNhc3ajKahL3I7txtRGxA+G34nEuTt1ajzY0QjK5XBA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FOoFx+glIVFX8exTYBlydKzlRLMGDMWxKW2IVZLqwibJqI8SDGbTiP5g0RoyOGLgA
         LrCZjo0tXgcNxbIZNR37H0KpSngl56T/u7eprHTdvZ2KyJWdvQ8rCXN5aYdDQBjWqi
         UGSB+WsL5JFlcJ+k527xGII65jgAZs7zxrDYA5jQ=
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au>
 <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au>
 <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
 <20200820074414.GA21848@gondor.apana.org.au>
 <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
 <20200820075353.GA21901@gondor.apana.org.au>
 <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
 <6bd84823-7dc6-e132-2959-e73d6806d2f1@candelatech.com>
 <20200820201055.GA24119@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <af57bfe4-87cf-1862-356d-970b41678c8e@candelatech.com>
Date:   Thu, 20 Aug 2020 15:09:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820201055.GA24119@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/20/20 1:10 PM, Herbert Xu wrote:
> On Thu, Aug 20, 2020 at 06:54:58AM -0700, Ben Greear wrote:
>>
>> Here's a run on an:  Intel(R) Core(TM) i7-7700T CPU @ 2.90GHz
>>
>>                 testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
>>
>> [  259.397910] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   8442 cycles/operation,    8 cycles/byte
>>
>>                 testing speed of async cmac(aes-generic) (cmac(aes-generic))
>>
>> [  294.171530] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   9022 cycles/operation,    8 cycles/byte
>>
>> On my slow apu2 board with processor: AMD GX-412TC SOC
>>
>>                testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
>>
>> [   51.751810] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  18759 cycles/operation,   18 cycle
>>
>>                testing speed of async cmac(aes-generic) (cmac(aes-generic))
>>
>> [   97.837497] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  31365 cycles/operation,   30 cycle
> 
> So clearly aes-generic is slower than aes-aesni even with saving and
> restoring for each block.  Therefore improving the performance of
> the latter per se does not make sense.

I have always assumed that I need aesni instructions to have any chance at this performing well,
but there are certainly chips out there that don't have aesni, so possibly it is still worth improving
if it is relatively easy to do so.

I am currently using x86-64 CPUs with aesni, and also some AP platforms running QCA ARM chips.
I am not sure if ARM is using aesni or not...it is certainly not that fast, but maybe for other
reasons.

Thanks,
Ben

> 
> Cheers,
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

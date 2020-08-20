Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3557C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 14:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B977C20758
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 14:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="FEf7dABq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHTOK4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 10:10:56 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:59768 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730661AbgHTNzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 09:55:04 -0400
Received: from [192.168.254.6] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id AA44213C2B1;
        Thu, 20 Aug 2020 06:55:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com AA44213C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1597931703;
        bh=UpUhdss+GOxefbpnK4NvvV8dpkICOyivV/oVjFSAPeg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FEf7dABqEn0xbjfUkTolkY6EpUZFSzRdIXrmR64kakE/Nwkgt6y/hX+q1XgsPQbHf
         CrvzkktUSz80V9Hzx38H4+zX+L2wc3SyS+cfaQswmnBMtuHQbEWQUuN6uv7CwqlZDt
         mCPDe/AZGNdwPC0xEwE0typEzcubqfH2+hFwL4Lc=
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <8b248ef3-d4c7-43fd-6ae4-1c3381597579@candelatech.com>
 <CAMj1kXFaQsCw_7x8NKNHfMfEC=NdWCxd7V6S3VnAFdOg+-Letg@mail.gmail.com>
 <20200820070142.GA21343@gondor.apana.org.au>
 <CAMj1kXEdkQUZ_d33N5T5_ELyqRomBKF8Nn+gquo7nrVBMMP-gA@mail.gmail.com>
 <20200820070645.GA21395@gondor.apana.org.au>
 <CAMj1kXE6QDxjNKSpzTrxe+QU0DF9CYp-W7bGe1AyFzYHOJQ41Q@mail.gmail.com>
 <20200820072910.GA21631@gondor.apana.org.au>
 <CAMj1kXFR2SSdE7oi6YKsWG1OvpXpo+584XSiMCSL0V-ysOMc5A@mail.gmail.com>
 <20200820074414.GA21848@gondor.apana.org.au>
 <CAMj1kXHAo8LzKZd9cuwhZzP3ikYr1Bd_zjrnBRDrAU8M=92RWQ@mail.gmail.com>
 <20200820075353.GA21901@gondor.apana.org.au>
 <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <6bd84823-7dc6-e132-2959-e73d6806d2f1@candelatech.com>
Date:   Thu, 20 Aug 2020 06:54:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGjPbscU=vzZwoX7gxuELgTYWk+wR3Z7vKk9RwKdhv1TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/20/20 12:56 AM, Ard Biesheuvel wrote:
> On Thu, 20 Aug 2020 at 09:54, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Thu, Aug 20, 2020 at 09:48:02AM +0200, Ard Biesheuvel wrote:
>>>
>>>> Or are you saying on Ben's machine cbc-aesni would have worse
>>>> performance vs. aes-generic?
>>>>
>>>
>>> Yes, given the pathological overhead of FPU preserve/restore for every
>>> block of 16 bytes processed by the cbcmac wrapper.
>>
>> I'm sceptical.  Do we have numbers showing this? You can get them
>> from tcrypt with my patch:
>>
>>          https://patchwork.kernel.org/patch/11701343/
>>
>> Just do
>>
>>          modprobe tcrypt mode=400 alg='cmac(aes-aesni)' klen=16
>>          modprobe tcrypt mode=400 alg='cmac(aes-generic)' klen=16
>>
>>> cmac() is not really relevant for performance, afaict. Only cbcmac()
>>> is used for bulk data.
>>
>> Sure but it's trivial to extend my cmac patch to support cbcmac.
>>
> 
> 
> Sure.
> 
> Ben, care to have a go at the above on your hardware? It would help us
> get to the bottom of this issue.

Here's a run on an:  Intel(R) Core(TM) i7-7700T CPU @ 2.90GHz

                testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
[  259.397756] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    244 cycles/operation,   15 cycles/byte
[  259.397759] tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   1052 cycles/operation,   16 cycles/byte
[  259.397765] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    641 cycles/operation,   10 cycles/byte
[  259.397768] tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   3909 cycles/operation,   15 cycles/byte
[  259.397786] tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   2602 cycles/operation,   10 cycles/byte
[  259.397797] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   2211 cycles/operation,    8 cycles/byte
[  259.397807] tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  15453 cycles/operation,   15 cycles/byte
[  259.397872] tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   8863 cycles/operation,    8 cycles/byte
[  259.397910] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   8442 cycles/operation,    8 cycles/byte
[  259.397946] tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  43542 cycles/operation,   21 cycles/byte
[  259.398110] tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  17649 cycles/operation,    8 cycles/byte
[  259.398184] tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  21255 cycles/operation,   10 cycles/byte
[  259.398267] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  16322 cycles/operation,    7 cycles/byte
[  259.398335] tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  60301 cycles/operation,   14 cycles/byte
[  259.398585] tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  34413 cycles/operation,    8 cycles/byte
[  259.398728] tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  32894 cycles/operation,    8 cycles/byte
[  259.398865] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  32521 cycles/operation,    7 cycles/byte
[  259.399000] tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 120415 cycles/operation,   14 cycles/byte
[  259.399550] tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  68635 cycles/operation,    8 cycles/byte
[  259.399834] tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  83770 cycles/operation,   10 cycles/byte
[  259.400157] tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  65075 cycles/operation,    7 cycles/byte
[  259.400427] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  65085 cycles/operation,    7 cycles/byte
[  294.171336]
                testing speed of async cmac(aes-generic) (cmac(aes-generic))
[  294.171340] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    275 cycles/operation,   17 cycles/byte
[  294.171343] tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   1191 cycles/operation,   18 cycles/byte
[  294.171350] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    738 cycles/operation,   11 cycles/byte
[  294.171354] tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   4386 cycles/operation,   17 cycles/byte
[  294.171374] tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   2915 cycles/operation,   11 cycles/byte
[  294.171387] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   2464 cycles/operation,    9 cycles/byte
[  294.171398] tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  17558 cycles/operation,   17 cycles/byte
[  294.171472] tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  14022 cycles/operation,   13 cycles/byte
[  294.171530] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   9022 cycles/operation,    8 cycles/byte
[  294.171569] tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  38107 cycles/operation,   18 cycles/byte
[  294.171722] tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  18083 cycles/operation,    8 cycles/byte
[  294.171798] tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  17260 cycles/operation,    8 cycles/byte
[  294.171870] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  17415 cycles/operation,    8 cycles/byte
[  294.171943] tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  66005 cycles/operation,   16 cycles/byte
[  294.172217] tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  36035 cycles/operation,    8 cycles/byte
[  294.172366] tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  42812 cycles/operation,   10 cycles/byte
[  294.172533] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  53415 cycles/operation,   13 cycles/byte
[  294.172745] tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 133326 cycles/operation,   16 cycles/byte
[  294.173297] tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  90271 cycles/operation,   11 cycles/byte
[  294.173646] tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  68703 cycles/operation,    8 cycles/byte
[  294.173931] tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  67951 cycles/operation,    8 cycles/byte
[  294.174213] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  68370 cycles/operation,    8 cycles/byte


On my slow apu2 board with processor: AMD GX-412TC SOC

               testing speed of async cmac(aes-aesni) (cmac(aes-aesni))
[   51.750514] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    600 cycles/operation,   37 cycle
[   51.750532] tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   2063 cycles/operation,   32 cycle
[   51.750582] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   1326 cycles/operation,   20 cycle
[   51.750619] tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  11190 cycles/operation,   43 cycle
[   51.750775] tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   4935 cycles/operation,   19 cycle
[   51.750840] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   8652 cycles/operation,   33 cycle
[   51.750948] tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  43430 cycles/operation,   42 cycle
[   51.751488] tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  23589 cycles/operation,   23 cycle
[   51.751810] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  18759 cycles/operation,   18 cycle
[   51.752027] tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  79699 cycles/operation,   38 cycle
[   51.753035] tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  39900 cycles/operation,   19 cycle
[   51.753559] tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  38390 cycles/operation,   18 cycle
[   51.754057] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  40888 cycles/operation,   19 cycle
[   51.754615] tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 143019 cycles/operation,   34 cycle
[   51.756369] tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  89046 cycles/operation,   21 cycle
[   51.757527] tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  77992 cycles/operation,   19 cycle
[   51.758526] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  76021 cycles/operation,   18 cycle
[   51.759442] tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 312260 cycles/operation,   38 cycle
[   51.763195] tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 176472 cycles/operation,   21 cycle
[   51.765255] tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 169565 cycles/operation,   20 cycle
[   51.767321] tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 164968 cycles/operation,   20 cycle
[   51.769256] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 165096 cycles/operation,   20 cycle

               testing speed of async cmac(aes-generic) (cmac(aes-generic))
[   97.835925] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    665 cycles/operation,   41 cycle
[   97.835945] tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   2430 cycles/operation,   37 cycle
[   97.836016] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   1656 cycles/operation,   25 cycle
[   97.836044] tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   9014 cycles/operation,   35 cycle
[   97.836259] tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):  13444 cycles/operation,   52 cycle
[   97.836399] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   8960 cycles/operation,   35 cycle
[   97.836515] tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  51594 cycles/operation,   50 cycle
[   97.837151] tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  28105 cycles/operation,   27 cycle
[   97.837497] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  31365 cycles/operation,   30 cycle
[   97.837865] tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  86111 cycles/operation,   42 cycle
[   97.838927] tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  60021 cycles/operation,   29 cycle
[   97.839628] tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  56311 cycles/operation,   27 cycle
[   97.840308] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  50877 cycles/operation,   24 cycle
[   97.840943] tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 174028 cycles/operation,   42 cycle
[   97.843205] tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates): 103243 cycles/operation,   25 cycle
[   97.844524] tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  99960 cycles/operation,   24 cycle
[   97.845865] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 121735 cycles/operation,   29 cycle
[   97.847355] tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 387559 cycles/operation,   47 cycle
[   97.851930] tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 223662 cycles/operation,   27 cycle
[   97.854617] tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 226131 cycles/operation,   27 cycle
[   97.857385] tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 203840 cycles/operation,   24 cycle
[   97.859888] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 220232 cycles/operation,   26 cycle

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

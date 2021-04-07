Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0F2C433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 03:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94C08613CC
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 03:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhDGD0h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:26:37 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51542 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233915AbhDGD0h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 23:26:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UUky-cb_1617765985;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UUky-cb_1617765985)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 11:26:25 +0800
Subject: Re: [PATCH] crypto: sm3 - use the more precise type u32 instead of
 unsigned int
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jia Zhang <zhang.jia@linux.alibaba.com>
References: <20210326022128.71727-1-tianjia.zhang@linux.alibaba.com>
 <CAOtvUMfSC02o03c=Q-8d7vy8KS3QmNTBc59An=-m4BmNzt8_GA@mail.gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <5a5028e1-7cb2-701c-ce0f-1bb9f79cb83d@linux.alibaba.com>
Date:   Wed, 7 Apr 2021 11:26:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMfSC02o03c=Q-8d7vy8KS3QmNTBc59An=-m4BmNzt8_GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3/26/21 5:38 PM, Gilad Ben-Yossef wrote:
> Hi,
> 
> Thank you for the patch!
> 
> On Fri, Mar 26, 2021 at 5:21 AM Tianjia Zhang
> <tianjia.zhang@linux.alibaba.com> wrote:
>>
>> In the process of calculating the hash, use the more accurate type
>> 'u32' instead of the original 'unsigned int' to avoid ambiguity.
> 
> I don't think there is any ambiguity here, as both forms are always
> the same size.
> 
> Generally, I tend to use the convention of using 'u32' as denoting
> variables where the size is meaningful - e.g. mathematical operations
> that are defined in the standard on 32 bit buffers,  versus using
> plain 'int' types where it isn't - e.g. loop counters etc.
> 
> Having said that, even under my own definition possibly the w and wt
> arrays in sm3_trandform() should be changed to u32.
> I don't object to changing those if it bugs you :-)
> 
> Cheers,
> Gilad
> 
> 

Thanks for your opinions. This is just to make the form more uniform. 
This is not a mistake. If it is not necessary, just ignore this 
modification.

Best regards,
Tianjia

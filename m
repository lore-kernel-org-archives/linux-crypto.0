Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76280C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A162077C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfHPHx5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 03:53:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4721 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbfHPHx5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 03:53:57 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 094F7156E86026C804D0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 15:53:54 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 16 Aug 2019
 15:53:52 +0800
Subject: Re: crypto: hisilicon - Fix warning on printing %p with dma_addr_t
To:     =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20190815120313.GA29253@gondor.apana.org.au>
 <5D556981.2080309@hisilicon.com> <20190815224207.GA3047@gondor.apana.org.au>
 <CAAUqJDsvG-c=svGzszE8nCXwjGSYUa9BB1Jj0srY+_rX0X-jyw@mail.gmail.com>
 <CAAUqJDuzUPUW=qvhEo6tU==Ycw0aijJM9pQk5W50kw=EgEG3ow@mail.gmail.com>
CC:     <linux-crypto@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D566103.3000701@hisilicon.com>
Date:   Fri, 16 Aug 2019 15:53:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <CAAUqJDuzUPUW=qvhEo6tU==Ycw0aijJM9pQk5W50kw=EgEG3ow@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/16 15:08, Ondrej Mosnáček wrote:
> pi 16. 8. 2019 o 9:02 Ondrej Mosnáček <omosnacek@gmail.com> napísal(a):
>> Hi Herbert,
>>
>> pi 16. 8. 2019 o 1:52 Herbert Xu <herbert@gondor.apana.org.au> napísal(a):
>>> On Thu, Aug 15, 2019 at 10:17:37PM +0800, Zhou Wang wrote:
>>>>
>>>>> -   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%pad\n", queue,
>>>>> -           cmd, dma_addr);
>>>>> +   dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%#lxad\n",
>>>>> +           queue, cmd, (unsigned long)dma_addr);
>>>>
>>>> Thanks. However, to be honest I can't get why we fix it like this.
>>>> Can you give me a clue?
>>>
>>> dma_addr_t is not a pointer.  It's an integer type and therefore
>>> you need to print it out as such.
>>
>> According to Documentation/core-api/printk-formats.rst, %pad is the
>> format specifier intended specifically for dma_addr_t [1], so perhaps
>> the kbuild robot warning was in fact bogus?
>>
>> [1] https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#dma-address-types-dma-addr-t
> 
> Oh, wait, in that section it actually says "Passed by reference.", so
> Zhou is most likely right that the proper fix is to pass a pointer to
> the variable containing the address (I assume this is to make the
> generic GCC's format checking pass even if dma_addr_t is not actually
> a pointer).

Yes, I think you are right, I also mentioned this in v3.

Thanks,
Zhou

> 
>>
>>>
>>> Actually my patch is buggy too, on some architectures it can be
>>> a long long so we need to cast is such.
>>>
>>> Cheers,
>>> --
>>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>>> Home Page: http://gondor.apana.org.au/~herbert/
>>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
> 


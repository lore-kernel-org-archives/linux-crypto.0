Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA08C3DA66
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 03:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjHYDM4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjHYDMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 23:12:24 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E6A1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 20:12:22 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RX4fx1N7gzJrqt;
        Fri, 25 Aug 2023 11:09:13 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 11:12:19 +0800
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
 <20230821102632.GA19294@willie-the-truck>
 <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
 <1373841d-28d4-4dd5-aff5-a6f05d317317@app.fastmail.com>
CC:     Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>
To:     Arnd Bergmann <arnd@arndb.de>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <bff5507e-91a2-26c0-b6fd-09e0bc02ca51@huawei.com>
Date:   Fri, 25 Aug 2023 11:12:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1373841d-28d4-4dd5-aff5-a6f05d317317@app.fastmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.120.153]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/8/22 4:47, Arnd Bergmann wrote:
> On Mon, Aug 21, 2023, at 08:45, Weili Qian wrote:
>> On 2023/8/21 18:26, Will Deacon wrote:
>>> On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:
> 
>> Thanks for the review.
>>
>> Since the HiSilicon accelerator devices are supported only on the ARM64 
>> platform,
>> the following 128bit read and write interfaces are added to the driver, 
>> is this OK?
>>
>> #if defined(CONFIG_ARM64)
>> static void qm_write128(void __iomem *addr, const void *buffer)
>> {
> 
> The naming makes it specific to the driver, which is not
> appropriate for a global definition. Just follow the
> generic naming. I guess you wouldn't have to do both
> the readl/writel and the ioread32/iowrite32 variants, so
> just start with the ioread/iowrite version. That also
> avoids having to come up with a new letter.
> 
> You have the arguments in the wrong order compared to iowrite32(),
> which is very confusing.
> 
> Instead of the pointer to the buffer, I'd suggest passing the
> value by value here, to make it behave like the other ones.
> 
> This does mean it won't build on targets that don't
> define u128, but I think we can handle that in a Kconfig
> symbol.
Ok, I will add generic IO helpers ioread128/iowrite128 for this,
keep it consistent with ioread32/iowrite32, submit patchset later.
And remove them from the driver.

> 
>> unsigned long tmp0 = 0, tmp1 = 0;
> 
> Don't initialize local variable to zero, that is generally
> a bad idea because it hides cases where they are not
> initialized properly.
> 
>> 	asm volatile("ldp %0, %1, %3\n"
>> 		     "stp %0, %1, %2\n"
> 
> This is missing the endian-swap for big-endian kernels.
The input parameter data has been endian-swap.
> 
>> 		     "dmb oshst\n"
> 
> You have the barrier at the wrong end of the helper, it
> needs to before the actual store to have the intended
> effect.
> 
> Also, you should really use the generic __io_bw() helper
> rather than open-coding it.
OK.
> 
>> 		     : "=&r" (tmp0),
>> 		     "=&r" (tmp1),
> 
> The tmp0/tmp1 registers are technically a clobber, not
> an in/out, though ideally these should be turned
> into inputs.
> 
>> 		     "+Q" (*((char __iomem *)addr))
>> 		     : "Q" (*((char *)buffer))
> 
> wrong length
> 
>> 		     : "memory");
>> }
> 
> The memory clobber is usually part of the barrier.
Yeah, the memory can be removed.
> 
>> static void qm_read128(void *buffer, const void __iomem *addr)
>> {
>> 	unsigned long tmp0 = 0, tmp1 = 0;
>>
>> 	asm volatile("ldp %0, %1, %3\n"
>> 		     "stp %0, %1, %2\n"
>> 		     "dmb oshst\n"
>> 		     : "=&r" (tmp0),
>> 		       "=&r" (tmp1),
>> 		       "+Q" (*((char *)buffer))
>> 		     : "Q" (*((char __iomem *)addr))
>> 		     : "memory");
>> }
> 
> Same thing, but you are missing the control dependency
> from __io_ar() here, rather than just open-coding it.
> 
>> #else
>> static void qm_write128(void __iomem *addr, const void *buffer)
>> {
>>
>> }
> 
> This is missing the entire implementation?
If the interface is implemented in the driver, the driver runs only on the ARM64 platform.
Therefore, there is no need to implement.

> 
>       Arnd
> .
> 

Thanks,
Weili

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A085BEE49AA
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 12:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjHUMpi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjHUMph (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 08:45:37 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B5CC2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 05:45:36 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RTsc65m2zz1L9Ng;
        Mon, 21 Aug 2023 20:44:06 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 21 Aug 2023 20:45:33 +0800
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
 <20230821102632.GA19294@willie-the-truck>
CC:     Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
Date:   Mon, 21 Aug 2023 20:45:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20230821102632.GA19294@willie-the-truck>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.120.153]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/8/21 18:26, Will Deacon wrote:
> On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:
>> On Sat, Aug 19, 2023 at 09:33:18AM +0200, Ard Biesheuvel wrote:
>>>
>>> No, that otx2_write128() routine looks buggy, actually, The ! at the
>>> end means writeback, and so the register holding addr will be
>>> modified, which is not reflect in the asm constraints. It also lacks a
>>> barrier.
>>
>> OK.  But at least having a helper called write128 looks a lot
>> cleaner than just having unexplained assembly in the code.
> 
> I guess we want something similar to how writeq() is handled on 32-bit
> architectures (see include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.
> 
> It's then CPU-dependent on whether you get atomicity.
> 
> Will
> .
> 

Thanks for the review.

Since the HiSilicon accelerator devices are supported only on the ARM64 platform,
the following 128bit read and write interfaces are added to the driver, is this OK?

#if defined(CONFIG_ARM64)
static void qm_write128(void __iomem *addr, const void *buffer)
{
	unsigned long tmp0 = 0, tmp1 = 0;

	asm volatile("ldp %0, %1, %3\n"
		     "stp %0, %1, %2\n"
		     "dmb oshst\n"
		     : "=&r" (tmp0),
		     "=&r" (tmp1),
		     "+Q" (*((char __iomem *)addr))
		     : "Q" (*((char *)buffer))
		     : "memory");
}

static void qm_read128(void *buffer, const void __iomem *addr)
{
	unsigned long tmp0 = 0, tmp1 = 0;

	asm volatile("ldp %0, %1, %3\n"
		     "stp %0, %1, %2\n"
		     "dmb oshst\n"
		     : "=&r" (tmp0),
		       "=&r" (tmp1),
		       "+Q" (*((char *)buffer))
		     : "Q" (*((char __iomem *)addr))
		     : "memory");
}

#else
static void qm_write128(void __iomem *addr, const void *buffer)
{

}

static void qm_read128(void *buffer, const void __iomem *addr)
{

}
#endif

Thanks,
Weili

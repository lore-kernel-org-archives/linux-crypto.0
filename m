Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ABBC6FA8F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 03:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjHYDIk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbjHYDIJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 23:08:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C11198E
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 20:08:02 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RX4YP32fQzNmwp;
        Fri, 25 Aug 2023 11:04:25 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 11:08:00 +0800
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Ard Biesheuvel <ardb@kernel.org>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
 <20230821102632.GA19294@willie-the-truck>
 <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
 <CAMj1kXH5YWZ1i0=1MVo0kaxSbQWFF6QyGvLUv_K5mqApASzy5w@mail.gmail.com>
CC:     Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, <linux-crypto@vger.kernel.org>,
        <shenyang39@huawei.com>, <liulongfang@huawei.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <0702ec24-4ca2-817f-0d71-132fb3b67aa0@huawei.com>
Date:   Fri, 25 Aug 2023 11:07:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXH5YWZ1i0=1MVo0kaxSbQWFF6QyGvLUv_K5mqApASzy5w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.120.153]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/8/21 22:36, Ard Biesheuvel wrote:
> On Mon, 21 Aug 2023 at 14:45, Weili Qian <qianweili@huawei.com> wrote:
>>
>>
>>
>> On 2023/8/21 18:26, Will Deacon wrote:
>>> On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:
>>>> On Sat, Aug 19, 2023 at 09:33:18AM +0200, Ard Biesheuvel wrote:
>>>>>
>>>>> No, that otx2_write128() routine looks buggy, actually, The ! at the
>>>>> end means writeback, and so the register holding addr will be
>>>>> modified, which is not reflect in the asm constraints. It also lacks a
>>>>> barrier.
>>>>
>>>> OK.  But at least having a helper called write128 looks a lot
>>>> cleaner than just having unexplained assembly in the code.
>>>
>>> I guess we want something similar to how writeq() is handled on 32-bit
>>> architectures (see include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.
>>>
>>> It's then CPU-dependent on whether you get atomicity.
>>>
>>> Will
>>> .
>>>
>>
>> Thanks for the review.
>>
>> Since the HiSilicon accelerator devices are supported only on the ARM64 platform,
>> the following 128bit read and write interfaces are added to the driver, is this OK?
> 
> No, this does not belong in the driver. As Will is suggesting, we
> should define some generic helpers for this, and provide an arm64
> implementation if the generic one does not result in the correct
> codegen.
> 
Sorry, I misunderstood here.

>>
>> #if defined(CONFIG_ARM64)
>> static void qm_write128(void __iomem *addr, const void *buffer)
>> {
>>         unsigned long tmp0 = 0, tmp1 = 0;
>>
>>         asm volatile("ldp %0, %1, %3\n"
>>                      "stp %0, %1, %2\n"
>>                      "dmb oshst\n"
>>                      : "=&r" (tmp0),
>>                      "=&r" (tmp1),
>>                      "+Q" (*((char __iomem *)addr))
> 
> This constraint describes the first byte of addr, which is sloppy but
> probably works fine.
> 
>>                      : "Q" (*((char *)buffer))
> 
> This constraint describes the first byte of buffer, which might cause
> problems because the asm reads the entire buffer not just the first
> byte.
I don't understand why constraint describes the first byte of buffer,and the compilation result seems to be ok.

 1811     1afc:       a9400a61        ldp     x1, x2, [x19]
 1812     1b00:       a9000801        stp     x1, x2, [x0]
 1813     1b04:       d50332bf        dmb     oshst
Maybe I'm wrong about 'Q', could you explain it or where can I learn more about this?

> 
>>                      : "memory");
>> }
>>
>> static void qm_read128(void *buffer, const void __iomem *addr)
>> {
>>         unsigned long tmp0 = 0, tmp1 = 0;
>>
>>         asm volatile("ldp %0, %1, %3\n"
>>                      "stp %0, %1, %2\n"
>>                      "dmb oshst\n"
> 
> Is this the right barrier for a read?
Should be "dmb oshld\n".
> 
>>                      : "=&r" (tmp0),
>>                        "=&r" (tmp1),
>>                        "+Q" (*((char *)buffer))
>>                      : "Q" (*((char __iomem *)addr))
>>                      : "memory");
>> }
>>
>> #else
>> static void qm_write128(void __iomem *addr, const void *buffer)
>> {
>>
>> }
>>
>> static void qm_read128(void *buffer, const void __iomem *addr)
>> {
>>
>> }
>> #endif
>>
> 
> Have you tried using __uint128_t accesses instead?
> 
> E.g., something like
> 
> static void qm_write128(void __iomem *addr, const void *buffer)
> {
>     volatile __uint128_t *dst = (volatile __uint128_t __force *)addr;
>     const __uint128_t *src __aligned(1) = buffer;
> 
>     WRITE_ONCE(*dst, *src);
>     dma_wmb();
> }
> 
> should produce the right instruction sequence, and works on all
> architectures that have CONFIG_ARCH_SUPPORTS_INT128=y
> 

I tried this, but WRITE_ONCE does not support type __uint128_t.
->WRITE_ONCE
 ->compiletime_assert_rwonce_type
  ->compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),	\
		"Unsupported access size for {READ,WRITE}_ONCE().")

So can we define generic IO helpers based on patchset
https://lore.kernel.org/all/20180124090519.6680-4-ynorov@caviumnetworks.com/
Part of the implementation is as follows：

add writeo() in include/asm-generic/io.h

#ifdef CONFIG_ARCH_SUPPORTS_INT128
#ifndef writeo
#define writeo writeo
static inline void writeo(__uint128_t value, volatile void __iomem *addr)
{
	__io_bw();
	__raw_writeo((__uint128_t __force)__cpu_to_le128(value), addr); //__cpu_to_le128 will implement.
	__io_aw();
}
#endif
#endif /* CONFIG_ARCH_SUPPORTS_INT128 */


#ifdef CONFIG_ARCH_SUPPORTS_INT128
#ifndef iowrite128
#define iowrite128 iowrite128
static inline void iowrite128(__uint128_t value, volatile void __iomem *addr)
{
	writeo(value, addr);
}
#endif
#endif /* CONFIG_ARCH_SUPPORTS_INT128  */

in arch/arm64/include/asm/io.h

#ifdef CONFIG_ARCH_SUPPORTS_INT128
#define __raw_writeo __raw_writeo
static __always_inline void  __raw_writeo(__uint128_t val, volatile void __iomem *addr)
{
	u64 hi, lo;

	lo = (u64)val;
	hi = (u64)(val >> 64);

	asm volatile ("stp %x0, %x1, [%2]\n" :: "rZ"(lo), "rZ"(hi), "r"(addr));
}
#endif /* CONFIG_ARCH_SUPPORTS_INT128 */

And add io{read|write}128bits in include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.
static inline void lo_hi_writeo(__uint128_t val, volatile void __iomem *addr)
{
	writeq(val, addr);
	writeq(val >> 64, addr);
}
#ifndef writeo
#define writeo lo_hi_writeo
#endif

static inline void hi_lo_writeo(__uint128_t val, volatile void __iomem *addr)
{
	writeq(val >> 64, addr);
	writeq(val, addr);
}
#ifndef writeo
#define writeo hi_lo_writeo
#endif

If this is ok, I'm going to implement reado and writeo, then submit the patchset.

Thanks,
Weili

> This needs a big fat comment describing that the MMIO access needs to
> be atomic, but we could consider it as a fallback if we decide not to
> bother with special MMIO accessors, although I suspect we'll be
> needing them more widely at some point anyway.
> .
> 

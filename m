Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC426C83F12
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 12:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbjHaMFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjHaMFg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 08:05:36 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380D9C5
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 05:05:33 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Rc0CF1JmyzLpB7;
        Thu, 31 Aug 2023 20:02:17 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 31 Aug 2023 20:05:30 +0800
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Arnd Bergmann <arnd@arndb.de>
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
 <0702ec24-4ca2-817f-0d71-132fb3b67aa0@huawei.com>
 <12206f61-e98f-4d32-859b-92d7bf5adf26@app.fastmail.com>
CC:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <7517f9df-4cd2-a026-3da0-4ef27304fc04@huawei.com>
Date:   Thu, 31 Aug 2023 20:05:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <12206f61-e98f-4d32-859b-92d7bf5adf26@app.fastmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.120.153]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/8/30 3:37, Arnd Bergmann wrote:
> On Thu, Aug 24, 2023, at 23:07, Weili Qian wrote:
>> On 2023/8/21 22:36, Ard Biesheuvel wrote:
>>> On Mon, 21 Aug 2023 at 14:45, Weili Qian <qianweili@huawei.com> wrote:
> 
>>>>                      : "Q" (*((char *)buffer))
>>>
>>> This constraint describes the first byte of buffer, which might cause
>>> problems because the asm reads the entire buffer not just the first
>>> byte.
>> I don't understand why constraint describes the first byte of 
>> buffer,and the compilation result seems to be ok.
>>
>>  1811     1afc:       a9400a61        ldp     x1, x2, [x19]
>>  1812     1b00:       a9000801        stp     x1, x2, [x0]
>>  1813     1b04:       d50332bf        dmb     oshst
>> Maybe I'm wrong about 'Q', could you explain it or where can I learn 
>> more about this?
> 
> The "Q" is not the problem here, it's the cast to (char *), which
> tells the compiler that only the first byte is used here, and
> allows it to not actually store the rest of the buffer into
> memory.
> 
> It's not a problem on the __iomem pointer side, since gcc never
> accesses those directly, and for the version taking a __u128 literal
> or two __u64 registers it is also ok.

Thanks for your reply, I have got it.

> 
>>>>         unsigned long tmp0 = 0, tmp1 = 0;
>>>>
>>>>         asm volatile("ldp %0, %1, %3\n"
>>>>                      "stp %0, %1, %2\n"
>>>>                      "dmb oshst\n"
>>>
>>> Is this the right barrier for a read?
>> Should be "dmb oshld\n".
> 
> As I said, this needs to be __io_ar(), which might be
> defined in a different way.
> 
>>>
>>> Have you tried using __uint128_t accesses instead?
>>>
>>> E.g., something like
>>>
>>> static void qm_write128(void __iomem *addr, const void *buffer)
>>> {
>>>     volatile __uint128_t *dst = (volatile __uint128_t __force *)addr;
>>>     const __uint128_t *src __aligned(1) = buffer;
>>>
>>>     WRITE_ONCE(*dst, *src);
>>>     dma_wmb();
>>> }
>>>
>>> should produce the right instruction sequence, and works on all
>>> architectures that have CONFIG_ARCH_SUPPORTS_INT128=y
>>>
>>
>> I tried this, but WRITE_ONCE does not support type __uint128_t.
>> ->WRITE_ONCE
>>  ->compiletime_assert_rwonce_type
>>   ->compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),	\
>> 		"Unsupported access size for {READ,WRITE}_ONCE().")
> 
> On top of that, WRITE_ONCE() does not guarantee atomicity, and
> dma_wmb() might not be the correct barrier.
> 
>> So can we define generic IO helpers based on patchset
>> https://lore.kernel.org/all/20180124090519.6680-4-ynorov@caviumnetworks.com/
>> Part of the implementation is as follows：
>>
>> add writeo() in include/asm-generic/io.h
>>
>> #ifdef CONFIG_ARCH_SUPPORTS_INT128
>> #ifndef writeo
>> #define writeo writeo
>> static inline void writeo(__uint128_t value, volatile void __iomem 
>> *addr)
>> {
>> 	__io_bw();
>> 	__raw_writeo((__uint128_t __force)__cpu_to_le128(value), addr); 
>> //__cpu_to_le128 will implement.
>> 	__io_aw();
>> }
>> #endif
>> #endif /* CONFIG_ARCH_SUPPORTS_INT128 */
> 
> Right, this is fairly close to what we need. The 'o' notation
> might be slightly controversial, which is why I suggested
> definining only iowrite128() to avoid having to agree on
> the correct letter for 16-byte stores.

Okay, I'll just define iowrite128() and ioread128().

Thanks,
Weili

> 
>> in arch/arm64/include/asm/io.h
>>
>> #ifdef CONFIG_ARCH_SUPPORTS_INT128
>> #define __raw_writeo __raw_writeo
>> static __always_inline void  __raw_writeo(__uint128_t val, volatile 
>> void __iomem *addr)
>> {
>> 	u64 hi, lo;
>>
>> 	lo = (u64)val;
>> 	hi = (u64)(val >> 64);
>>
>> 	asm volatile ("stp %x0, %x1, [%2]\n" :: "rZ"(lo), "rZ"(hi), "r"(addr));
>> }
>> #endif /* CONFIG_ARCH_SUPPORTS_INT128 */
> 
> This definition looks fine.
> 
>> And add io{read|write}128bits in include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.
>> static inline void lo_hi_writeo(__uint128_t val, volatile void __iomem *addr)
>> {
>> 	writeq(val, addr);
>> 	writeq(val >> 64, addr);
>> }
> 
> This also looks fine. 
> 
>       Arnd
> .
> 

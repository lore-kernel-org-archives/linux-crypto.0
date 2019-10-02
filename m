Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE83C352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E3B121D82
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfJBQrY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 12:47:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3236 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfJBQrX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 12:47:23 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 528A3773250F30F8E166;
        Thu,  3 Oct 2019 00:47:19 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 3 Oct 2019
 00:47:12 +0800
Subject: Re: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
To:     Zhou Wang <wangzhou1@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>
References: <20190919140650.1289963-2-arnd@arndb.de>
 <20190919140917.1290556-1-arnd@arndb.de>
 <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com>
 <CAK8P3a3jCv--VHu9r4ZTnLXXGaCjdJ6royP5LFk_9RCTTRsRBA@mail.gmail.com>
 <CAK8P3a1AgZePpZdYXh2w1BHAJZZbAjZjN8MZyVS4bPo4gVVgPg@mail.gmail.com>
 <531214d6-2caf-2963-0f57-2cd615a18762@huawei.com>
 <5D85FAEC.9060607@hisilicon.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Mao Wenan <maowenan@huawei.com>,
        "Hao Fang" <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9ca33e86-9aa5-9cd0-f57d-1a2ad7d73bc9@huawei.com>
Date:   Wed, 2 Oct 2019 17:47:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <5D85FAEC.9060607@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21/09/2019 11:26, Zhou Wang wrote:
> On 2019/9/20 22:16, John Garry wrote:
>> On 20/09/2019 14:36, Arnd Bergmann wrote:
>>> On Fri, Sep 20, 2019 at 3:26 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>>>
>>>> On Fri, Sep 20, 2019 at 10:34 AM John Garry <john.garry@huawei.com> wrote:
>>>>
>>>>>> +     if (!IS_ENABLED(CONFIG_ARM64)) {
>>>>>> +             memcpy_toio(fun_base, src, 16);
>>>>>> +             wmb();
>>>>>> +             return;
>>>>>> +     }
>>>>>> +
>>>>>>       asm volatile("ldp %0, %1, %3\n"
>>>>>>                    "stp %0, %1, %2\n"
>>>>>>                    "dsb sy\n"
>>>>>>
>>>>>

***

>>>>> As I understand, this operation needs to be done atomically. So - even
>>>>> though your change is just for compile testing - the memcpy_to_io() may
>>>>> not do the same thing on other archs, right?
>>>>>
>>>>> I just wonder if it's right to make that change, or at least warn the
>>>>> imaginary user of possible malfunction for !arm64.
>>>>
>>
>> Hi Arnd,
>>
>>>> It's probably not necessary here. From what I can tell from the documentation,
>>>> this is only safe on ARMv8.4 or higher anyway, earlier ARMv8.x implementations
>>>> don't guarantee that an stp arrives on the bus in one piece either.
>>>>
>>>> Usually, hardware like this has no hard requirement on an atomic store,
>>>> it just needs the individual bits to arrive in a particular order, and then
>>>> triggers the update on the last bit that gets stored. If that is the case here
>>>> as well, it might actually be better to use two writeq_relaxed() and
>>>> a barrier. This would also solve the endianess issue.
>>>
>>> See also https://lkml.org/lkml/2018/1/26/554 for a previous attempt
>>> to introduce 128-bit MMIO accessors, this got rejected since they
>>> are not atomic even on ARMv8.4.
>>
>> So this is proprietary IP integrated with a proprietary ARMv8 implementation,
>> so there could be a tight coupling, the like of which Will mentioned in that thread,
>> but I'm doubtful.
>>
>> I'm looking at the electronically translated documentation on this HW, and it reads
>> "The Mailbox operation performed by the CPU cannot be interleaved", and then tells
>> that software should lock against concurrent accesses or alternatively use a 128-bit
>> access. So it seems that the 128b op used is only to guarantee software is atomic.
>>
>> Wang Zhou can confirm my understanding
>

Just to add a few more details here:

> We have to do a 128bit atomic write here to trigger a mailbox. The reason is
> that one QM hardware entity in one accelerator servers QM mailbox MMIO interfaces in
> related PF and VFs.
>
> A mutex can not lock different processing flows in different functions.

This means that we can have userspace drivers and the kernel driver 
simultaneously accessing these mailboxes.

>
> As Arnd mentioned, v8.4 extends the support for 16 bytes atomic stp to some kinds of
> normal memory, but for device memory, it is still implementation defined. For this
> SoC(Kunpeng920) which has QM/ZIP, if the address is 128bit aligned, stp will be atomic.
> The offset of QM mailbox is 128bit aligned, so it is safe here.

The strange thing (to me) about this hw is that we cannot interleave 
mailbox accesses on different functions - with 2x 64b accesses, for 
example. This is the reason that we require 128b accesses.

The upshot is that we can't switch to generic code unfortunately.

But I am not sure if the change is right, as I mentioned originally, 
above ***.

I'll leave to Arnd's better judgment :)

Thanks,
John

>
> Best,
> Zhou
>
>>
>> If true, I see that we seem to be already guaranteeing mutual exclusion in qm_mb(),
>> in taking a mutex.
>>
>> Thanks,
>> John
>>
>>
>>>
>>>     Arnd
>>>
>>> .
>>>
>>
>>
>>
>> .
>>
>
>
> .
>



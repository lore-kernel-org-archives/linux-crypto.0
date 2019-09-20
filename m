Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C800C4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 14:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C6A7207E0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 14:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfITOQ6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 10:16:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728297AbfITOQ6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 10:16:58 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 32F2C1F437AB7F57F8C5;
        Fri, 20 Sep 2019 22:16:55 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 22:16:48 +0800
Subject: Re: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
To:     Arnd Bergmann <arnd@arndb.de>
References: <20190919140650.1289963-2-arnd@arndb.de>
 <20190919140917.1290556-1-arnd@arndb.de>
 <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com>
 <CAK8P3a3jCv--VHu9r4ZTnLXXGaCjdJ6royP5LFk_9RCTTRsRBA@mail.gmail.com>
 <CAK8P3a1AgZePpZdYXh2w1BHAJZZbAjZjN8MZyVS4bPo4gVVgPg@mail.gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        "Mao Wenan" <maowenan@huawei.com>, Hao Fang <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <531214d6-2caf-2963-0f57-2cd615a18762@huawei.com>
Date:   Fri, 20 Sep 2019 15:16:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1AgZePpZdYXh2w1BHAJZZbAjZjN8MZyVS4bPo4gVVgPg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/09/2019 14:36, Arnd Bergmann wrote:
> On Fri, Sep 20, 2019 at 3:26 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Fri, Sep 20, 2019 at 10:34 AM John Garry <john.garry@huawei.com> wrote:
>>
>>>> +     if (!IS_ENABLED(CONFIG_ARM64)) {
>>>> +             memcpy_toio(fun_base, src, 16);
>>>> +             wmb();
>>>> +             return;
>>>> +     }
>>>> +
>>>>       asm volatile("ldp %0, %1, %3\n"
>>>>                    "stp %0, %1, %2\n"
>>>>                    "dsb sy\n"
>>>>
>>>
>>> As I understand, this operation needs to be done atomically. So - even
>>> though your change is just for compile testing - the memcpy_to_io() may
>>> not do the same thing on other archs, right?
>>>
>>> I just wonder if it's right to make that change, or at least warn the
>>> imaginary user of possible malfunction for !arm64.
>>

Hi Arnd,

>> It's probably not necessary here. From what I can tell from the documentation,
>> this is only safe on ARMv8.4 or higher anyway, earlier ARMv8.x implementations
>> don't guarantee that an stp arrives on the bus in one piece either.
>>
>> Usually, hardware like this has no hard requirement on an atomic store,
>> it just needs the individual bits to arrive in a particular order, and then
>> triggers the update on the last bit that gets stored. If that is the case here
>> as well, it might actually be better to use two writeq_relaxed() and
>> a barrier. This would also solve the endianess issue.
>
> See also https://lkml.org/lkml/2018/1/26/554 for a previous attempt
> to introduce 128-bit MMIO accessors, this got rejected since they
> are not atomic even on ARMv8.4.

So this is proprietary IP integrated with a proprietary ARMv8 
implementation, so there could be a tight coupling, the like of which 
Will mentioned in that thread, but I'm doubtful.

I'm looking at the electronically translated documentation on this HW, 
and it reads "The Mailbox operation performed by the CPU cannot be 
interleaved", and then tells that software should lock against 
concurrent accesses or alternatively use a 128-bit access. So it seems 
that the 128b op used is only to guarantee software is atomic.

Wang Zhou can confirm my understanding.

If true, I see that we seem to be already guaranteeing mutual exclusion 
in qm_mb(), in taking a mutex.

Thanks,
John


>
>     Arnd
>
> .
>



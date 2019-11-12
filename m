Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD81C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 02:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88C5206BB
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 02:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKLCL3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Nov 2019 21:11:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726970AbfKLCL3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Nov 2019 21:11:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A8B48CC83F696B5C030F;
        Tue, 12 Nov 2019 10:11:25 +0800 (CST)
Received: from [127.0.0.1] (10.57.77.109) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 12 Nov 2019
 10:11:11 +0800
Subject: Re: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
References: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
 <20191109021650.GA9739@sol.localdomain>
 <d75fc607-524c-a68a-bafe-28e793bced93@huawei.com>
 <20191111053720.GA18665@sol.localdomain>
 <5f822228-0323-928a-30f9-dea4af210a4c@huawei.com>
 <20191111171816.GA56300@gmail.com>
 <6cecf2de-9aa0-f6ea-0c2d-8e974a1a820b@huawei.com>
 <20191112012843.GA695@sol.localdomain>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <5fd20e25-db51-55c3-406a-dd68a27e93c5@huawei.com>
Date:   Tue, 12 Nov 2019 10:11:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191112012843.GA695@sol.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.77.109]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2019/11/12 9:28, Eric Biggers wrote:
> On Tue, Nov 12, 2019 at 09:04:33AM +0800, Xu Zaibo wrote:
>> On 2019/11/12 1:18, Eric Biggers wrote:
>>> On Mon, Nov 11, 2019 at 08:26:20PM +0800, Xu Zaibo wrote:
>>>> Hi,
>>>>
>>>> On 2019/11/11 13:37, Eric Biggers wrote:
>>>>> On Mon, Nov 11, 2019 at 10:21:39AM +0800, Xu Zaibo wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 2019/11/9 10:16, Eric Biggers wrote:
>>>>>>> On Sat, Nov 09, 2019 at 10:01:52AM +0800, Zaibo Xu wrote:
>>>>>>>> This series adds HiSilicon Security Engine (SEC) version 2 controller
>>>>>>>> driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
>>>>>>>> and SRIOV support of SEC.
>>>>>>>>
>>>>>>>> This patchset rebases on:
>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>>>>>>>>
>>>>>>>> This patchset is based on:
>>>>>>>> https://www.spinics.net/lists/linux-crypto/msg43520.html
>>>>>>>>
>>>>>>>> Changes:
>>>>>>>>      - delete checking return value of debugfs_create_xxx functions.
>>>>>>>>
>>>>>>>> Change log:
>>>>>>>> v2:    - remove checking return value of debugfs_create_xxx functions.
>>>>>>>>
>>>>>>> Does this driver pass all the crypto self-tests, including with
>>>>>>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>>>>>>>
>>>>>> Not including extra testing now, only CONFIG_CRYPTO_TEST is passed.
>>>>>>
>>>>> Can you please ensure that all the extra tests are passing too?  I.e., boot a
>>>>> kernel with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and check dmesg for failures.
>>>>>
>>>> Ok, I will try to do this. BTW, why we need this test? Thanks.
>>>>
>>> It will test the correctness of your driver.
>>>
>> So, it is a basic test not an extra test ? :)
>>
> The options are separate because the "extra tests" include fuzz tests which take
> much longer to run than the regular tests, and some people who enable the
> regular tests wouldn't want them to get 100x slower.  But as someone actually
> developing a crypto driver you're expected to run the extra tests.  They've
> found lots of bugs in other drivers, so please run them and fix any bugs found.
>
Okay. Not sure whether my understanding is right. Should it be a part of 
regular test once
we find a shorter time way to do this "extra tests"?
Yes, I am running it. Thank you very much.

Cheers,
Zaibo

.
>



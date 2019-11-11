Return-Path: <SRS0=rtXS=ZD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94192C43331
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 02:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 703EE2067B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 02:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfKKCVx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:21:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6181 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726734AbfKKCVx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Nov 2019 21:21:53 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ED32A2E6EC77AD9E60C2;
        Mon, 11 Nov 2019 10:21:49 +0800 (CST)
Received: from [127.0.0.1] (10.57.77.109) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 10:21:39 +0800
Subject: Re: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
References: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
 <20191109021650.GA9739@sol.localdomain>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <d75fc607-524c-a68a-bafe-28e793bced93@huawei.com>
Date:   Mon, 11 Nov 2019 10:21:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191109021650.GA9739@sol.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.77.109]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 2019/11/9 10:16, Eric Biggers wrote:
> On Sat, Nov 09, 2019 at 10:01:52AM +0800, Zaibo Xu wrote:
>> This series adds HiSilicon Security Engine (SEC) version 2 controller
>> driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
>> and SRIOV support of SEC.
>>
>> This patchset rebases on:
>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>>
>> This patchset is based on:
>> https://www.spinics.net/lists/linux-crypto/msg43520.html
>>
>> Changes:
>>   - delete checking return value of debugfs_create_xxx functions.
>>
>> Change log:
>> v2:    - remove checking return value of debugfs_create_xxx functions.
>>
> Does this driver pass all the crypto self-tests, including with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>
Not including extra testing now, only CONFIG_CRYPTO_TEST is passed.

Thanks,
Zaibo

.



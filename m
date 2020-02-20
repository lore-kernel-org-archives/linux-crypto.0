Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44DFC11D04
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 12:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8547207FD
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 12:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBTMQT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 07:16:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727921AbgBTMQT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 07:16:19 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 593D3C4BD37B747CE70B;
        Thu, 20 Feb 2020 20:16:10 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 20:16:01 +0800
Subject: Re: [PATCH 4/4] crypto: hisilicon/sec2 - Add pbuffer mode for SEC
 driver
To:     John Garry <john.garry@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
 <1582189495-38051-5-git-send-email-xuzaibo@huawei.com>
 <011d8794-b4ab-a5ad-b765-e6e2c09991aa@huawei.com>
 <69fe2d60-428e-9747-b7c0-d69cf25efc0e@huawei.com>
 <87591c1f-5c6b-64bd-5dc2-900e1481b5ca@huawei.com>
CC:     <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <shenyang39@huawei.com>,
        <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <bac7ec3e-43e6-9061-fbbe-03f4404f1c50@huawei.com>
Date:   Thu, 20 Feb 2020 20:16:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87591c1f-5c6b-64bd-5dc2-900e1481b5ca@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2020/2/20 19:07, John Garry wrote:
> On 20/02/2020 10:10, Xu Zaibo wrote:
>> Hi,
>>
>>
>> On 2020/2/20 17:50, John Garry wrote:
>>> On 20/02/2020 09:04, Zaibo Xu wrote:
>>>> From: liulongfang <liulongfang@huawei.com>
>>>>
>>>> In the scenario of SMMU translation, the SEC performance of short 
>>>> messages
>>>> (<512Bytes) cannot meet our expectations. To avoid this, we reserve 
>>>> the
>>>> plat buffer (PBUF) memory for small packets when creating TFM.
>>>>
>>>
>>> I haven't gone through the code here, but why not use this method 
>>> also for non-translated? What are the pros and cons?
>> Because non-translated has no performance or throughput problems.
>>
>
> OK, so no problem, but I was asking could it be improved, and, if so, 
> what would be the drawbacks?
>
> As for the change to check if the IOMMU is translating, it seems exact 
> same as that for the hi1616 driver...
>
Currently, I find the only drawback is needing more memory :), what's 
your idea?
Yes, the same as SEC V1.

Cheers,
Zaibo

.
>>
>> .
>>>
>>> The commit message is very light on details.
>>>
>>> Thanks
>>> john
>>>
>>> .
>>>
>>
>>
>> .
>
> .
>



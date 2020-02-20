Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D3DC11D05
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 11:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40E32465D
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 11:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgBTLHM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 06:07:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2448 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbgBTLHM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 06:07:12 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A47AF8312BA485B65AE4;
        Thu, 20 Feb 2020 11:07:10 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 20 Feb 2020 11:07:10 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 20 Feb
 2020 11:07:09 +0000
Subject: Re: [PATCH 4/4] crypto: hisilicon/sec2 - Add pbuffer mode for SEC
 driver
To:     Xu Zaibo <xuzaibo@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <shenyang39@huawei.com>,
        <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
 <1582189495-38051-5-git-send-email-xuzaibo@huawei.com>
 <011d8794-b4ab-a5ad-b765-e6e2c09991aa@huawei.com>
 <69fe2d60-428e-9747-b7c0-d69cf25efc0e@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <87591c1f-5c6b-64bd-5dc2-900e1481b5ca@huawei.com>
Date:   Thu, 20 Feb 2020 11:07:08 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <69fe2d60-428e-9747-b7c0-d69cf25efc0e@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/02/2020 10:10, Xu Zaibo wrote:
> Hi,
> 
> 
> On 2020/2/20 17:50, John Garry wrote:
>> On 20/02/2020 09:04, Zaibo Xu wrote:
>>> From: liulongfang <liulongfang@huawei.com>
>>>
>>> In the scenario of SMMU translation, the SEC performance of short 
>>> messages
>>> (<512Bytes) cannot meet our expectations. To avoid this, we reserve the
>>> plat buffer (PBUF) memory for small packets when creating TFM.
>>>
>>
>> I haven't gone through the code here, but why not use this method also 
>> for non-translated? What are the pros and cons?
> Because non-translated has no performance or throughput problems.
> 

OK, so no problem, but I was asking could it be improved, and, if so, 
what would be the drawbacks?

As for the change to check if the IOMMU is translating, it seems exact 
same as that for the hi1616 driver...

> cheers,
> Zaibo
> 
> .
>>
>> The commit message is very light on details.
>>
>> Thanks
>> john
>>
>> .
>>
> 
> 
> .


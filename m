Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02ECC11D04
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 10:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 909D220801
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 10:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgBTKKq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 05:10:46 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbgBTKKp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 05:10:45 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0F5836011A93E368C059;
        Thu, 20 Feb 2020 18:10:43 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 18:10:34 +0800
Subject: Re: [PATCH 4/4] crypto: hisilicon/sec2 - Add pbuffer mode for SEC
 driver
To:     John Garry <john.garry@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1582189495-38051-1-git-send-email-xuzaibo@huawei.com>
 <1582189495-38051-5-git-send-email-xuzaibo@huawei.com>
 <011d8794-b4ab-a5ad-b765-e6e2c09991aa@huawei.com>
CC:     <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <shenyang39@huawei.com>,
        <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <69fe2d60-428e-9747-b7c0-d69cf25efc0e@huawei.com>
Date:   Thu, 20 Feb 2020 18:10:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <011d8794-b4ab-a5ad-b765-e6e2c09991aa@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On 2020/2/20 17:50, John Garry wrote:
> On 20/02/2020 09:04, Zaibo Xu wrote:
>> From: liulongfang <liulongfang@huawei.com>
>>
>> In the scenario of SMMU translation, the SEC performance of short 
>> messages
>> (<512Bytes) cannot meet our expectations. To avoid this, we reserve the
>> plat buffer (PBUF) memory for small packets when creating TFM.
>>
>
> I haven't gone through the code here, but why not use this method also 
> for non-translated? What are the pros and cons?
Because non-translated has no performance or throughput problems.

cheers,
Zaibo

.
>
> The commit message is very light on details.
>
> Thanks
> john
>
> .
>



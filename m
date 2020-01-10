Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA09C33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 10:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC882077C
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 10:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgAJKuC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 05:50:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9151 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727577AbgAJKuB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 05:50:01 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9843F2E82755D1FE9962;
        Fri, 10 Jan 2020 18:49:58 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 10 Jan 2020
 18:49:47 +0800
Subject: Re: [PATCH 1/9] crypto: hisilicon - fix debugfs usage of SEC V2
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1578642598-8584-1-git-send-email-xuzaibo@huawei.com>
 <1578642598-8584-2-git-send-email-xuzaibo@huawei.com>
 <20200110085038.pebelen7a7g2kwwf@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <yekai13@huawei.com>, <liulongfang@huawei.com>,
        <qianweili@huawei.com>, <zhangwei375@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <041742d8-37b0-2234-9130-3af1e2efef85@huawei.com>
Date:   Fri, 10 Jan 2020 18:49:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200110085038.pebelen7a7g2kwwf@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On 2020/1/10 16:50, Herbert Xu wrote:
> On Fri, Jan 10, 2020 at 03:49:50PM +0800, Zaibo Xu wrote:
>> Applied some advices of Marco Elver on atomic usage of Debugfs.
>>
>> Reported-by: Marco Elver <elver@google.com>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
>>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 10 +++++-----
>>   drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
>>   3 files changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
>> index 26754d0..841f4c5 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec.h
>> +++ b/drivers/crypto/hisilicon/sec2/sec.h
>> @@ -40,7 +40,7 @@ struct sec_req {
>>   	int req_id;
>>   
>>   	/* Status of the SEC request */
>> -	int fake_busy;
>> +	bool fake_busy;
> I have already applied Arnd's patch and it's in the crypto tree.
> Please rebase yours on top of his patch.
>
Okay, I will rebase.

Cheers,
Zaibo

.



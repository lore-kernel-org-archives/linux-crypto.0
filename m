Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6DCC433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 12:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 187C361989
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 12:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhC3MKd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:10:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15396 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhC3MJ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 08:09:59 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8pB75xvFznTm9;
        Tue, 30 Mar 2021 20:08:15 +0800 (CST)
Received: from [10.67.101.248] (10.67.101.248) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 20:09:46 +0800
Subject: Re: [PATCH] crypto: hisilicon - check if debugfs opened
To:     Greg KH <gregkh@linuxfoundation.org>
References: <1616833980-11006-1-git-send-email-tanghui20@huawei.com>
 <YGCcQnFHXEMW9Jz/@kroah.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   tanghui20 <tanghui20@huawei.com>
Message-ID: <17d627e8-b89a-bbb8-f5d7-11210b859ac7@huawei.com>
Date:   Tue, 30 Mar 2021 20:09:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YGCcQnFHXEMW9Jz/@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/3/28 23:09, Greg KH wrote:
> On Sat, Mar 27, 2021 at 04:33:00PM +0800, Hui Tang wrote:
>> 'xx_debugfs_init' check if debugfs opened.
>>
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>>  drivers/crypto/hisilicon/hpre/hpre_main.c | 5 ++++-
>>  drivers/crypto/hisilicon/qm.c             | 3 +++
>>  drivers/crypto/hisilicon/sec2/sec_main.c  | 5 ++++-
>>  drivers/crypto/hisilicon/zip/zip_main.c   | 3 +++
>>  4 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> index c7ab06d..f2605c4 100644
>> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
>> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> @@ -779,6 +779,9 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
>>  	struct device *dev = &qm->pdev->dev;
>>  	int ret;
>>
>> +	if (!debugfs_initialized())
>> +		return -ENOENT;
>
> Why?  What does this help with?  Why does the code care if debugfs is
> running or not?
>
When !CONFIG_DEBUG_FS, there is no problem if debugfs is not checked,
but if checking debugfs, a series of stub functions of debugfs can be
skipped and 'xx_debugfs_init' will be return immediately.

Thanks.

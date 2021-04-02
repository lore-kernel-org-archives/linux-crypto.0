Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D499C433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 08:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CA7610E8
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 08:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBIYy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 04:24:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15589 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhDBIYy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 04:24:54 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBY2Y3Rjpz1BFgh;
        Fri,  2 Apr 2021 16:22:45 +0800 (CST)
Received: from [10.67.101.248] (10.67.101.248) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 16:24:43 +0800
Subject: Re: [PATCH] crypto: hisilicon/hpre - delete redundant log
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1616833946-9682-1-git-send-email-tanghui20@huawei.com>
 <20210402071924.GA10482@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <linux-kernel@vger.kernel.org>
From:   tanghui20 <tanghui20@huawei.com>
Message-ID: <b031d20e-e5c6-8bcb-66ae-03d66b0294c6@huawei.com>
Date:   Fri, 2 Apr 2021 16:24:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210402071924.GA10482@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/4/2 15:19, Herbert Xu wrote:
> On Sat, Mar 27, 2021 at 04:32:26PM +0800, Hui Tang wrote:
>> 'hpre_cfg_by_dsm' has checked and printed error path, so it is not
>> necessary at all.
>>
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>>  drivers/crypto/hisilicon/hpre/hpre_main.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> index 8aae921..73ee997 100644
>> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
>> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> @@ -384,10 +384,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
>>
>>  	/* This setting is only needed by Kunpeng 920. */
>>  	if (qm->ver == QM_HW_V2) {
>> -		ret = hpre_cfg_by_dsm(qm);
>> -		if (ret)
>> -			dev_err(dev, "acpi_evaluate_dsm err.\n");
>> -
>> +		hpre_cfg_by_dsm(qm);
>>  		disable_flr_of_bme(qm);
>>  	}
>
> If the return value is non-zero you've just changed what this code
> does from returning non-zero to returning zero.  Are you sure about
> this?

I am sorry, it should return error immediately when return value of 'hpre_cfg_by_dsm' is non-zero,
and I will fix it in the next version.

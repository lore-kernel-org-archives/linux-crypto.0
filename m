Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF096C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 09:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851586198A
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 09:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhC3JY6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 05:24:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14634 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhC3JYg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 05:24:36 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8kVD18MvzmbJD;
        Tue, 30 Mar 2021 17:21:56 +0800 (CST)
Received: from [10.67.103.212] (10.67.103.212) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 17:24:24 +0800
Subject: Re: [PATCH v2 3/5] crypto: hisilicon/sgl - add some dfx logs
To:     Joe Perches <joe@perches.com>, <herbert@gondor.apana.org.au>
References: <1617089946-48078-1-git-send-email-yekai13@huawei.com>
 <1617089946-48078-4-git-send-email-yekai13@huawei.com>
 <c2dcae1a5ea1f6900e061fe1a7dc393dbaf1bdc5.camel@perches.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <a448fecd-96b1-614c-1bbf-1421d1b36e6f@huawei.com>
Date:   Tue, 30 Mar 2021 17:24:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c2dcae1a5ea1f6900e061fe1a7dc393dbaf1bdc5.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

However, I think this log can be used to quickly locate the function or 
module if dma alloc failed.


On 2021/3/30 15:56, Joe Perches wrote:
> On Tue, 2021-03-30 at 15:39 +0800, Kai Ye wrote:
>> Add some dfx logs in some abnormal exit situations.
> []
>> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> []
>> @@ -87,8 +87,10 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
>>   		block[i].sgl = dma_alloc_coherent(dev, block_size,
>>   						  &block[i].sgl_dma,
>>   						  GFP_KERNEL);
>> -		if (!block[i].sgl)
>> +		if (!block[i].sgl) {
>> +			dev_err(dev, "Fail to allocate hw SG buffer!\n");
> This doesn't seem useful as dma_alloc_coherent does a dump_stack
> by default on OOM.
>
>
> .
>


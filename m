Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1FEC64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2707F221EB
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgK3NGn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:06:43 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8534 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgK3NGn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 08:06:43 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cl57f2r5JzhkqD;
        Mon, 30 Nov 2020 21:05:34 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 21:05:55 +0800
Subject: Re: [PATCH] hwrng: exynos - fix reference leak in exynos_trng_probe
To:     Lukasz Stelmach <l.stelmach@samsung.com>
CC:     Krzysztof Kozlowski <krzk@kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20201127094446.121277-1-miaoqinglang@huawei.com>
 <CGME20201127142637eucas1p1746be156c43e789b48b5b78b9b212a33@eucas1p1.samsung.com>
 <dleftjlfemg9kh.fsf%l.stelmach@samsung.com>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <3ed654dd-db10-0975-d125-a3949c9bab90@huawei.com>
Date:   Mon, 30 Nov 2020 21:05:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <dleftjlfemg9kh.fsf%l.stelmach@samsung.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/27 22:26, Lukasz Stelmach 写道:
> It was <2020-11-27 pią 17:44>, when Qinglang Miao wrote:
>> pm_runtime_get_sync will increment pm usage counter even it
>> failed. Forgetting to putting operation will result in a
>> reference leak here.
>>
>> A new function pm_runtime_resume_and_get is introduced in
>> [0] to keep usage counter balanced. So We fix the reference
>> leak by replacing it with new funtion.
>>
>> [0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")
>>
>> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>> ---
>>   drivers/char/hw_random/exynos-trng.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
>> index 8e1fe3f8d..666246bc8 100644
>> --- a/drivers/char/hw_random/exynos-trng.c
>> +++ b/drivers/char/hw_random/exynos-trng.c
>> @@ -132,7 +132,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
>>   		return PTR_ERR(trng->mem);
>>   
>>   	pm_runtime_enable(&pdev->dev);
>> -	ret = pm_runtime_get_sync(&pdev->dev);
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>>   	if (ret < 0) {
>>   		dev_err(&pdev->dev, "Could not get runtime PM.\n");
>>   		goto err_pm_get;
> 
> Thanks. I suppose you may use the new function exynos_trng_resume(),
> remove everything and leave only
> 
> return pm_runtime_resume_and_get(dev);
Hi, Lukasz

I sent a v2 on this one.

But I'm not really sure about what does 'remove everything' mean. for 
example, should I remove exynos_trng_resume in this patch?

Thanks.
> 

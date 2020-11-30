Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44B3C71156
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3AD20825
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 13:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgK3NEd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:04:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8166 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgK3NEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 08:04:33 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cl55608CWz15VmF;
        Mon, 30 Nov 2020 21:03:22 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 21:03:42 +0800
Subject: Re: [PATCH] hwrng: exynos - fix reference leak in exynos_trng_probe
To:     Krzysztof Kozlowski <krzk@kernel.org>
CC:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20201127094446.121277-1-miaoqinglang@huawei.com>
 <20201127094414.GA10679@kozik-lap>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <14ffbcad-9674-443c-dc5f-cf804a686720@huawei.com>
Date:   Mon, 30 Nov 2020 21:03:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20201127094414.GA10679@kozik-lap>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/27 17:44, Krzysztof Kozlowski 写道:
> On Fri, Nov 27, 2020 at 05:44:46PM +0800, Qinglang Miao wrote:
>> pm_runtime_get_sync will increment pm usage counter even it
>> failed. Forgetting to putting operation will result in a
>> reference leak here.
>>
>> A new function pm_runtime_resume_and_get is introduced in
>> [0] to keep usage counter balanced. So We fix the reference
>> leak by replacing it with new funtion.
>>
>> [0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")
> 
> Do not put such dependencies into the commit message - it does not bring
> useful information to the history. Store it under '---' separator.
> 
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
> 
> This cannot be applied. Fix it by replacing err_clock label with this
> one. >
> Best regards,
> Krzysztof
> 
> .
Hi Krzysztof,

I realize that there's a mistake in this patch through your reply.

There's two way to fix this one:
1) replace err_pm_get with err_clock label when pm_runtime_get_sync fails.
2) replace pm_runtime_get_sync with pm_runtime_resume_and_get and remove
redundant label(err_clock).

I take 2) on v2 for it makes codes more clearer in a way.

Thanks.

> 

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD78ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 12:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiIWMaL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 08:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIWM3s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 08:29:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A19D13A3AE
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 05:26:26 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MYrtN1v95zHqRx;
        Fri, 23 Sep 2022 20:24:12 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 20:26:23 +0800
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 20:26:23 +0800
Message-ID: <afde3f5c-32e4-6b89-8d6b-1f4f5a7744c4@huawei.com>
Date:   Fri, 23 Sep 2022 20:26:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH -next] crypto: aspeed - Remove redundant dev_err call
To:     Neal Liu <neal_liu@aspeedtech.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20220923100159.15705-1-shangxiaojing@huawei.com>
 <HK0PR06MB320294D6E2A61F85F4276EE780519@HK0PR06MB3202.apcprd06.prod.outlook.com>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <HK0PR06MB320294D6E2A61F85F4276EE780519@HK0PR06MB3202.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2022/9/23 18:15, Neal Liu wrote:
>> devm_ioremap_resource() prints error message in itself. Remove the dev_err
>> call to avoid redundant error message.
>>
>> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
>> ---
>>   drivers/crypto/aspeed/aspeed-hace.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/crypto/aspeed/aspeed-hace.c
>> b/drivers/crypto/aspeed/aspeed-hace.c
>> index 3f880aafb6a2..e05c32c31842 100644
>> --- a/drivers/crypto/aspeed/aspeed-hace.c
>> +++ b/drivers/crypto/aspeed/aspeed-hace.c
>> @@ -123,10 +123,8 @@ static int aspeed_hace_probe(struct platform_device
>> *pdev)
>>   	platform_set_drvdata(pdev, hace_dev);
>>
>>   	hace_dev->regs = devm_ioremap_resource(&pdev->dev, res);
>> -	if (IS_ERR(hace_dev->regs)) {
>> -		dev_err(&pdev->dev, "Failed to map resources\n");
>> +	if (IS_ERR(hace_dev->regs))
>>   		return PTR_ERR(hace_dev->regs);
>> -	}
>>
>>   	/* Get irq number and register it */
>>   	hace_dev->irq = platform_get_irq(pdev, 0);
>> --
>> 2.17.1
> Similar patch just be proposed few days ago.
> https://patchwork.kernel.org/project/linux-crypto/patch/20220920032118.6440-1-yuehaibing@huawei.com/

sorry, pls ignore mine.


Thanks,

Shang XiaoJing


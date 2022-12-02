Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BD1C4321E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 10:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiLBK7S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBK7R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 05:59:17 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EDFA1A03
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 02:59:16 -0800 (PST)
Received: from dggpemm500002.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNqgC0zldzJqLM;
        Fri,  2 Dec 2022 18:58:31 +0800 (CST)
Received: from [10.174.179.5] (10.174.179.5) by dggpemm500002.china.huawei.com
 (7.185.36.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 2 Dec
 2022 18:59:15 +0800
Subject: Re: [PATCH] hwrng: amd - Fix PCI device refcount leak
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <olivia@selenic.com>, <mpm@selenic.com>, <mb@bu3sch.de>,
        <linux-crypto@vger.kernel.org>, <yangyingliang@huawei.com>
References: <20221123093949.115579-1-wangxiongfeng2@huawei.com>
 <Y4nI0X0u01uiTCV0@gondor.apana.org.au>
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <4f27474d-7fe5-d1cb-0be8-387b0562e629@huawei.com>
Date:   Fri, 2 Dec 2022 18:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <Y4nI0X0u01uiTCV0@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.5]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2022/12/2 17:43, Herbert Xu wrote:
> On Wed, Nov 23, 2022 at 05:39:49PM +0800, Xiongfeng Wang wrote:
>>
>> @@ -201,6 +207,8 @@ static void __exit amd_rng_mod_exit(void)
>>  	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
>>  
>>  	kfree(priv);
>> +
>> +	pci_dev_put(priv->pcidev);
> 
> Oops, this doesn't look right.  Please fix and resubmit.

Ah, Sorry, my mistake! I will send another version with the fix of geode-rng.

Thanks,
Xiongfeng

> 
> Thanks,
> 

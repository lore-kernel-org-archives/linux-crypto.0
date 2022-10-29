Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02D6FA3741
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Oct 2022 01:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJ2BZY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Oct 2022 21:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ2BZY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2022 21:25:24 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79E969ECB;
        Fri, 28 Oct 2022 18:25:21 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MzhRq2Fp3z15MD6;
        Sat, 29 Oct 2022 09:20:23 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 09:25:19 +0800
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 09:25:19 +0800
Subject: Re: [PATCH] crypto/hisilicon: Add null judgment to the callback
 interface
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220930024320.29922-1-liulongfang@huawei.com>
 <YzZZTsIHLSkuufeb@gondor.apana.org.au>
 <717adf23-3080-5041-14ed-6ab5dcaddbf9@huawei.com>
 <Y1tTLAEi7ukUCCmB@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <a1229856-fbe4-9ae7-5789-332ed0af87eb@huawei.com>
Date:   Sat, 29 Oct 2022 09:25:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y1tTLAEi7ukUCCmB@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/10/28 11:57, Herbert Xu wrote:
> On Fri, Sep 30, 2022 at 11:48:02AM +0800, liulongfang wrote:
>>
>> Even if the task is sent in synchronous mode, when using the hardware
>> driver, the hardware still informs the driver software through an
>> interrupt after completing the task, and the workqueue in the driver
>> software will call this callback function.
>>
>> And I found that the device drivers of other manufacturers under the
>> crypto subsystem are also in this asynchronous mode, and this problem
>> is also encountered when using the synchronous mode.
> 
> This still makes no sense to me.
> 
> Who is making an async request with no callback?
> 

The context of the problem may not have been clearly stated in the previous
description.

This is a problem found in one of our real user scenarios:
In this scenario of using an accelerator to perform encryption  services,
it was originally intended to use the CPU to perform encryption services
in synchronous mode (without loading the hardware device driver, and without
registering the asynchronous callback function), but due to a deployment
error, the Hisi hardware device driver was loaded into the system,
this wrong operation causes the encryption service to call the device
driver of the hisi hardware, but the hardware device driver executes the
asynchronous mode, so the callback interface is called after the service
is completed.
This leads to this system calltrace problem.

The purpose of this patch is to ensure that the device does not appear
calltrace in this abnormal situation.

> Cheers,
> 

Thanks,
Longfang.

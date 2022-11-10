Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07B1C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 04:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiKJENR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 23:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiKJEMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 23:12:37 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31F5303FB;
        Wed,  9 Nov 2022 20:11:18 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N77gC4f1Nz15MPv;
        Thu, 10 Nov 2022 12:11:03 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:11:16 +0800
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:11:16 +0800
Subject: Re: [PATCH] crypto/hisilicon: Add null judgment to the callback
 interface
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <YzZZTsIHLSkuufeb@gondor.apana.org.au>
 <717adf23-3080-5041-14ed-6ab5dcaddbf9@huawei.com>
 <Y1tTLAEi7ukUCCmB@gondor.apana.org.au>
 <a1229856-fbe4-9ae7-5789-332ed0af87eb@huawei.com>
 <Y2TWpyynYMyStKRX@gondor.apana.org.au>
 <d914a099-06ef-acfe-f394-f4790a821598@huawei.com>
 <Y2oodE+5us++mbSl@gondor.apana.org.au>
 <df561fbe-12eb-25b0-2173-a7ffb3bfd53a@huawei.com>
 <Y2twbHyQkTMoTz+O@gondor.apana.org.au>
 <32686c5b-04b2-7103-bf2e-113db2315ef4@huawei.com>
 <Y2xt7/6WGN+uthpL@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <40a0e7aa-362a-0de7-76c0-77381c07f254@huawei.com>
Date:   Thu, 10 Nov 2022 12:11:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y2xt7/6WGN+uthpL@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/11/10 11:20, Herbert Xu wrote:
> On Thu, Nov 10, 2022 at 10:03:53AM +0800, liulongfang wrote:
> .
>> This problem occurs in the application code of the encryption usage scenario
>> (unfortunately, these codes are not open to the public and cannot be given to you),
> 
> Are you saying this requires out-of-tree kernel code to trigger?
> 

Yes, this problem is triggered by application layer code,
but it happens on kernel driver code.

> Then you should fix that out-of-tree code.
>
When using crypto's skcipher series interfaces for encryption and decryption
services, User can use synchronous mode(by adjusting some skcipher interfaces,
here is to remove skcipher_request_set_callback()) or asynchronous mode,
but when using synchronous mode and the current asynchronous mode is loaded
it will cause a calltrace.

The current problem is that the interface of skcipher does not restrict users
to call functions in this way for encryption services.

If the current driver doesn't handle this, there is a possibility that some users
deliberately create this kind of problem to cause the kernel to crash.

> Thanks,
> 


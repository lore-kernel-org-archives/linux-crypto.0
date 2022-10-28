Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3031DECAAA1
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Oct 2022 02:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbiJ1C0P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiJ1C0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2022 22:26:10 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A83A7CE0B;
        Thu, 27 Oct 2022 19:26:09 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mz5t81MKFzpWG0;
        Fri, 28 Oct 2022 10:22:40 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 10:26:07 +0800
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 10:26:07 +0800
Subject: Re: [PATCH] crypto/hisilicon: Add null judgment to the callback
 interface
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220930024320.29922-1-liulongfang@huawei.com>
 <YzZZTsIHLSkuufeb@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <076d8f36-fa92-8d47-8b46-6e6e7ec75bf5@huawei.com>
Date:   Fri, 28 Oct 2022 10:26:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YzZZTsIHLSkuufeb@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/9/30 10:49, Herbert Xu wrote:
> On Fri, Sep 30, 2022 at 10:43:20AM +0800, Longfang Liu wrote:
>> The algorithm acceleration function interface provided by the
>> current crypto subsystem is in asynchronous mode, but some users
>> will call it in synchronous mode, thus not providing a callback
>> interface for the "base.complete" of the request.
> 
> Please give more details.  Who is calling the callback functions
> in synchronous mode?
> 
> Thanks,
> 

Hi, Herbert.
Do you consider merging this patch?
Thansk,
Longfang.

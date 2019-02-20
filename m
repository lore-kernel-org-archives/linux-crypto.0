Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D6DC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 06:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12B392147A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 06:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfBTGuN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 01:50:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:4229 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfBTGuN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 01:50:13 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6A27B60C458BA589DD60;
        Wed, 20 Feb 2019 14:50:10 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Wed, 20 Feb 2019
 14:49:59 +0800
Subject: Re: [PATCH v2 2/4] crypto: hisilicon: Add queue management driver for
 HiSilicon QM module
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
 <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
 <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
 <5C53F22A.2020804@hisilicon.com>
 <20190201153931.2k4yopm4akunpedg@gondor.apana.org.au>
 <5C54FFA7.1080702@hisilicon.com>
 <20190220041011.oob4e7jk3fwoqjlg@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Hao Fang <fanghao11@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C6CF899.1020708@hisilicon.com>
Date:   Wed, 20 Feb 2019 14:50:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20190220041011.oob4e7jk3fwoqjlg@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/2/20 12:10, Herbert Xu wrote:
> On Sat, Feb 02, 2019 at 10:25:43AM +0800, Zhou Wang wrote:
>>
>> In fact, I planned to register to acomp later.
>>
>> It also makes sense to use scomp if hardware engine is faster than CPU.
>> So how about registering to scomp firstly, then we register this engine to
>> acomp later?
> 
> Sorry, but the fact that you're doing a busy-wait for completion
> means that scomp is not an appropriate choice.

OK. I will use acomp in next version.

Thanks,
Zhou

> 
> Cheers,
> 


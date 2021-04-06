Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F69C433ED
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 00:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC458613EA
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 00:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhDFAwS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 20:52:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15599 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbhDFAwS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 20:52:18 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDppH5dlHz18H8f;
        Tue,  6 Apr 2021 08:49:59 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.498.0; Tue, 6 Apr 2021
 08:52:00 +0800
Subject: Re: [PATCH] crypto: hisilicon/hpre - rsa key should not be empty
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <linux-kernel@vger.kernel.org>, <shenyang39@huawei.com>
References: <1616739212-7751-1-git-send-email-yumeng18@huawei.com>
 <20210402071225.GA10423@gondor.apana.org.au>
 <7384e015-5514-d6b2-4215-beb1f4701adb@huawei.com>
 <20210402102223.GA24978@gondor.apana.org.au>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <639630ef-f0c3-1ccb-983d-0cb9d2ac2952@huawei.com>
Date:   Tue, 6 Apr 2021 08:51:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210402102223.GA24978@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



ÔÚ 2021/4/2 18:22, Herbert Xu Ð´µÀ:
> On Fri, Apr 02, 2021 at 06:16:16PM +0800, yumeng wrote:
>>
>> I think it is not a real bug, and soft fallback setkey can always catch the
>> error.
>> But our original intention was to make it don't go to 'xxx_set_pub_key'
>> when the key is null, and it can return an error earlier.
>> But maybe it is not good.
> 
> It might make sense to check them twice if you were touching them
> directly, e.g., poking inside the key.  However, it appears that
> your driver simply palms off the key to rsa_helper.c which should
> check the key/keylen too so I think there is no need for this patch
> for now.
> 
> Thanks,
> 

OK, thank you.

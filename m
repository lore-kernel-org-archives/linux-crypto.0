Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854CAC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 14:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F1C20836
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 14:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLJO2e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 09:28:34 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727061AbfLJO2d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 09:28:33 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4BF99FFF1CC1A72F190C;
        Tue, 10 Dec 2019 22:28:31 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Dec 2019
 22:28:24 +0800
Subject: Re: [PATCH] crypto: user - use macro CRYPTO_MSG_INDEX() to instead of
 index calculation
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.or>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
References: <6306e685-51fa-1a04-e9d9-07d4c80b5400@huawei.com>
 <20191210133923.aab65usf4xyqd3wv@gondor.apana.org.au>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Message-ID: <762174ca-5901-bf3d-74fb-38eeecb7c46a@huawei.com>
Date:   Tue, 10 Dec 2019 22:27:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20191210133923.aab65usf4xyqd3wv@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019/12/10 21:39, Herbert Xu wrote:
> On Tue, Dec 10, 2019 at 07:07:36PM +0800, Yunfeng Ye wrote:
>> There are multiple places using CRYPTO_MSG_BASE to calculate the index,
>> so use macro CRYPTO_MSG_INDEX() instead for better readability.
>>
>> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> 
> I don't think your patch makes it any more readable.
> 
ok, thanks, I think use macro instead of the same index calculation
logic is more clear.

> Cheers,
> 


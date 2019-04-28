Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D839C43219
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728332075D
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfD1ISq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 04:18:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbfD1ISp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 04:18:45 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E687BA3A4E4A8FE444F7;
        Sun, 28 Apr 2019 16:18:43 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Sun, 28 Apr 2019
 16:18:39 +0800
Subject: Re: [PATCH -next] crypto: ccree - Make cc_sec_disable static
To:     Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190426164313.32308-1-yuehaibing@huawei.com>
 <CAOtvUMfO1jvU6_Y7=otKQt0t9o_At0QBg7eqwV4SbeD9srbAqg@mail.gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <5802f801-2817-5964-1657-7e1bb70cb4fa@huawei.com>
Date:   Sun, 28 Apr 2019 16:18:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMfO1jvU6_Y7=otKQt0t9o_At0QBg7eqwV4SbeD9srbAqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/4/28 15:56, Gilad Ben-Yossef wrote:
> On Fri, Apr 26, 2019 at 7:43 PM Yue Haibing <yuehaibing@huawei.com> wrote:
>>
>> From: YueHaibing <yuehaibing@huawei.com>
>>
>> Fix sparse warning:
>>
>> drivers/crypto/ccree/cc_driver.c:37:6: warning:
>>  symbol 'cc_sec_disable' was not declared. Should it be static?
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Thank you!
> 
> The kbuit test robot already sent the same fix, which I acked.
> It's hard competing with the bots... :-)

Indeed, I did not find a fix before sending this.

> 
> Gilad
> 
> 
> 
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
> 
> values of β will give rise to dom!
> 
> 


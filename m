Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A5DCA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 07:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83AB12080F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 07:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKAHED (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 03:04:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5677 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727038AbfKAHED (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 03:04:03 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C64F18EF76902144B3F6;
        Fri,  1 Nov 2019 15:04:00 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 15:03:52 +0800
Subject: Re: [PATCH] crypto: hisilicon - fix to return sub-optimal device when
 best device has no qps
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1572058816-185603-1-git-send-email-wangzhou1@hisilicon.com>
 <20191101061316.ks34f6mn6d3hxoxz@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Shukun Tan <tanshukun1@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DBBD8D8.4010104@hisilicon.com>
Date:   Fri, 1 Nov 2019 15:03:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191101061316.ks34f6mn6d3hxoxz@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/11/1 14:13, Herbert Xu wrote:
> On Sat, Oct 26, 2019 at 11:00:16AM +0800, Zhou Wang wrote:
>> Currently find_zip_device() finds zip device which has the min NUMA
>> distance with current CPU.
>>
>> This patch modifies find_zip_device to return sub-optimal device when best
>> device has no qps. This patch sorts all devices by NUMA distance, then
>> finds the best zip device which has free qp.
>>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
>> ---
>>  drivers/crypto/hisilicon/qm.c           | 21 ++++++++++
>>  drivers/crypto/hisilicon/qm.h           |  2 +
>>  drivers/crypto/hisilicon/zip/zip_main.c | 74 ++++++++++++++++++++++++---------
>>  3 files changed, 77 insertions(+), 20 deletions(-)
> 
> Patch applied.  Thanks.

Thanks.

> 


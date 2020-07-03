Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6B0C433E5
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 08:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B738F206A1
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 08:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCIS6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 04:18:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbgGCIS6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 04:18:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C593F446943C005C098
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2020 16:18:57 +0800 (CST)
Received: from [127.0.0.1] (10.67.102.118) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 16:18:54 +0800
Subject: Re: [PATCH 2/5] crypto:hisilicon/sec2 - update busy processing logic
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
 <1593167529-22463-3-git-send-email-liulongfang@huawei.com>
 <20200703041440.GA7858@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <9a1eff92-537b-60e3-c840-206915d69019@huawei.com>
Date:   Fri, 3 Jul 2020 16:18:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200703041440.GA7858@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/7/3 12:14, Herbert Xu Wrote:
> On Fri, Jun 26, 2020 at 06:32:06PM +0800, Longfang Liu wrote:
>> From: Kai Ye <yekai13@huawei.com>
>>
>> As before, if a SEC queue is at the 'fake busy' status,
>> the request with a 'fake busy' flag will be sent into hardware
>> and the sending function returns busy. After the request is
>> finished, SEC driver's call back will identify the 'fake busy' flag,
>> and notifies the user that hardware is not busy now by calling
>> user's call back function.
>>
>> Now, a request sent into busy hardware will be cached in the
>> SEC queue's backlog, return '-EBUSY' to user.
>> After the request being finished, the cached requests will
>> be processed in the call back function. to notify the
>> corresponding user that SEC queue can process more requests.
>>
>> Signed-off-by: Kai Ye <yekai13@huawei.com>
>> Reviewed-by: Longfang Liu <liulongfang@huawei.com>
> Why does this driver not take MAY_BACKLOG into account?
>
> Cheers,

OK, I will apply MAY_BACKLOG in the next version soon.

thanks,

Longfang

.



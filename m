Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1613AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 01:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E989D22B40
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 01:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgHFBeD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 21:34:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725998AbgHFBeD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 21:34:03 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6E60EC939619170D8DC9;
        Thu,  6 Aug 2020 09:34:00 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 6 Aug 2020
 09:33:51 +0800
Subject: Re: [v4 01/10] crypto: hisilicon/qm - fix wrong release after using
 strsep
To:     Markus Elfring <Markus.Elfring@web.de>,
        Sihang Chen <chensihang1@hisilicon.com>,
        <linux-crypto@vger.kernel.org>
References: <96ffa633-dda1-7ad1-72da-5563906c1561@web.de>
 <425f4bdd-cf55-6537-28bf-0377564b531b@huawei.com>
 <5554863d-f0d7-a396-7d13-e187fa9ca6bf@web.de>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <e470a745-c59e-2baa-426d-816ae64d052f@huawei.com>
Date:   Thu, 6 Aug 2020 09:33:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <5554863d-f0d7-a396-7d13-e187fa9ca6bf@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/8/5 14:04, Markus Elfring wrote:
>> Thanks for your review. There is only one error branch need to do
>> something uninit. So I think the jump is not necessary and will
>> affect code reading.:)
>
> How does this concern fit to the Linux coding style?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?id=4da9f3302615f4191814f826054846bf843e24fa#n481
>
> Regards,
> Markus
>
> .
>

Got it, I'll fix this.

Thanks,
Yang


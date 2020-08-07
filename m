Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC4BC433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 08:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F9F420866
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 08:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgHGIGP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 04:06:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgHGIGP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 04:06:15 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BBD7ACE77B6F3EA07809;
        Fri,  7 Aug 2020 16:06:12 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 7 Aug 2020
 16:06:04 +0800
Subject: Re: [v4 01/10] crypto: hisilicon/qm - fix wrong release after using
 strsep
To:     Markus Elfring <Markus.Elfring@web.de>,
        Sihang Chen <chensihang1@hisilicon.com>,
        <linux-crypto@vger.kernel.org>
References: <96ffa633-dda1-7ad1-72da-5563906c1561@web.de>
 <425f4bdd-cf55-6537-28bf-0377564b531b@huawei.com>
 <5554863d-f0d7-a396-7d13-e187fa9ca6bf@web.de>
 <e470a745-c59e-2baa-426d-816ae64d052f@huawei.com>
 <c28f472c-4d7b-0afd-5ad7-3cc322aad404@web.de>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <a22bb80b-5dce-3e62-e805-8406564d3903@huawei.com>
Date:   Fri, 7 Aug 2020 16:06:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c28f472c-4d7b-0afd-5ad7-3cc322aad404@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/8/6 15:23, Markus Elfring wrote:
> Would you become interested to look if any other software components
> would be similarly affected?

Yeah, I'll check the rest and fix if any and send those in  a
clean up patch.

Thanks,
Yang


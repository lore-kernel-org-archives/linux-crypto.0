Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59607C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 03:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E2961A1A
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 03:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhC0DA3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 23:00:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14153 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhC0C77 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 22:59:59 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6k5v4jZkznZQW;
        Sat, 27 Mar 2021 10:57:23 +0800 (CST)
Received: from [127.0.0.1] (10.69.38.207) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 10:59:49 +0800
Subject: Re: [PATCH 4/4] crypto: hisilicon/zip - support new 'sqe' type in
 Kunpeng930
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1616139187-63425-1-git-send-email-shenyang39@huawei.com>
 <1616139187-63425-5-git-send-email-shenyang39@huawei.com>
 <20210326091457.GA1153@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <833da1eb-0277-8466-23dc-15533eafbd8f@huawei.com>
Date:   Sat, 27 Mar 2021 10:59:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210326091457.GA1153@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.38.207]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/3/26 17:14, Herbert Xu wrote:
> On Fri, Mar 19, 2021 at 03:33:07PM +0800, Yang Shen wrote:
>>
>> +const struct hisi_zip_sqe_ops hisi_zip_ops_v2 = {
>> +	.sqe_type		= 0x3,
>> +	.fill_addr		= hisi_zip_fill_addr,
>> +	.fill_buf_size		= hisi_zip_fill_buf_size,
>> +	.fill_buf_type		= hisi_zip_fill_buf_type,
>> +	.fill_req_type		= hisi_zip_fill_req_type,
>> +	.fill_tag		= hisi_zip_fill_tag_v2,
>> +	.fill_sqe_type		= hisi_zip_fill_sqe_type,
>> +	.get_tag		= hisi_zip_get_tag_v2,
>> +	.get_status		= hisi_zip_get_status,
>> +	.get_dstlen		= hisi_zip_get_dstlen,
>> +};
>> +
>
> This triggers a new warning:
>
>   CHECK   ../drivers/crypto/hisilicon/zip/zip_crypto.c
>   ../drivers/crypto/hisilicon/zip/zip_crypto.c:527:31: warning: symbol 'hisi_zip_ops_v1' was not declared. Should it be static?
>   ../drivers/crypto/hisilicon/zip/zip_crypto.c:540:31: warning: symbol 'hisi_zip_ops_v2' was not declared. Should it be static?
>
> Please fix.  Thanks.
>

Sorry， I'll fix this in next version.

Thanks.


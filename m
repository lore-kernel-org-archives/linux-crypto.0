Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB7FC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52651208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGaIsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:48:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728412AbgGaIsI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 04:48:08 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4529A392A2954766FB1E;
        Fri, 31 Jul 2020 16:48:05 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 16:47:56 +0800
Subject: Re: [PATCH 0/4] crypto: hisilicon/zip - misc bugfix
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1595657210-3964-1-git-send-email-shenyang39@huawei.com>
 <20200731082840.GA32511@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <c1f6b18b-5eff-62d9-40f1-dbe8f52bff82@huawei.com>
Date:   Fri, 31 Jul 2020 16:47:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200731082840.GA32511@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/7/31 16:28, Herbert Xu wrote:
> On Sat, Jul 25, 2020 at 02:06:46PM +0800, Yang Shen wrote:
>> This patchset fix some bug:
>> patch 1:clear the debug registers when remove driver
>> patch 2:intercept invalid input when using decompress
>> patch 3:replace the return value '-EBUSY' with '-EAGAIN' when
>>     device is busy
>> patch 4:initialize the 'curr_qm_qp_num' when probe device
>>
>> This patchset depends on:
>> https://patchwork.kernel.org/cover/11684785/
>>
>> Hao Fang (1):
>>   crypto: hisilicon/zip - fix the uncleared debug registers
>>
>> Sihang Chen (1):
>>   crypto: hisilicon/zip - fix the uninitalized 'curr_qm_qp_num'
>>
>> Yang Shen (1):
>>   crypto: hisilicon/zip - fix the return value when device is busy
>>
>> Zhou Wang (1):
>>   crypto: hisilicon/zip - fix zero length input in GZIP decompress
>>
>>  drivers/crypto/hisilicon/zip/zip_crypto.c | 25 +++++++++++++++++++------
>>  drivers/crypto/hisilicon/zip/zip_main.c   | 19 +++++++++++++++++++
>>  2 files changed, 38 insertions(+), 6 deletions(-)
>
> This patch series doesn't apply against cryptodev.
>
> Cheers,
>

Sorry, this patchset depends on
https://patchwork.kernel.org/cover/11684785/
which cover letter is '[PATCH 00/10] crypto: hisilicon/zip - misc clean
up'

Sorry for troubling you again.

Thanks,


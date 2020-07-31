Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AC9C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E2420838
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbgGaIPw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:15:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731522AbgGaIPw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 04:15:52 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C7903F9AA541EADF5447;
        Fri, 31 Jul 2020 16:15:48 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 16:15:42 +0800
Subject: Re: [PATCH v3 08/10] crypto: hisilicon/qm - fix the process of
 register algorithms to crypto
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
 <1595488780-22085-9-git-send-email-shenyang39@huawei.com>
 <20200731075722.GA20350@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <79b37e17-8eb6-b89b-d49f-46a3faf2783a@huawei.com>
Date:   Fri, 31 Jul 2020 16:15:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200731075722.GA20350@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/7/31 15:57, Herbert Xu wrote:
> On Thu, Jul 23, 2020 at 03:19:38PM +0800, Yang Shen wrote:
>> When the devices are removed or not existing, the corresponding algorithms
>> which are registered by 'hisi-zip' driver can't be used.
>>
>> Move 'hisi_zip_register_to_crypto' from 'hisi_zip_init' to
>> 'hisi_zip_probe'. The algorithms will be registered to crypto only when
>> there is device bind on the driver. And when the devices are removed,
>> the algorithms will be unregistered.
>>
>> In the previous process, the function 'xxx_register_to_crypto' need a lock
>> and a static variable to judge if the registration is the first time.
>> Move this action into the function 'hisi_qm_alg_register'. Each device
>> will call 'hisi_qm_alg_register' to add itself to qm list in probe process
>> and registering algs when the qm list is empty.
>>
>> Signed-off-by: Yang Shen <shenyang39@huawei.com>
>> Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
>
> You still haven't resolved the issue of unregistering crypto
> algorithms that may be allocated.
>

Here if the user alloc a tfm of the algorithm the driver registers,
the function 'hisi_qm_wait_task_finish' which be added in patch 10 will
stop to remove the driver until the tfm is freed.

Thanks,

> Cheers,
>


Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E9EC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F813208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 08:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgGaIo4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:44:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9307 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731896AbgGaIo4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 04:44:56 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8170F17E78DA4AA8876E;
        Fri, 31 Jul 2020 16:44:53 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 16:44:42 +0800
Subject: Re: [PATCH v3 08/10] crypto: hisilicon/qm - fix the process of
 register algorithms to crypto
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
 <1595488780-22085-9-git-send-email-shenyang39@huawei.com>
 <20200731075722.GA20350@gondor.apana.org.au>
 <79b37e17-8eb6-b89b-d49f-46a3faf2783a@huawei.com>
 <20200731082030.GA21715@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <b7d715ac-9860-31cf-b0e9-1428d1880e12@huawei.com>
Date:   Fri, 31 Jul 2020 16:44:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200731082030.GA21715@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/7/31 16:20, Herbert Xu wrote:
> On Fri, Jul 31, 2020 at 04:15:41PM +0800, shenyang (M) wrote:
>>
>> Here if the user alloc a tfm of the algorithm the driver registers,
>> the function 'hisi_qm_wait_task_finish' which be added in patch 10 will
>> stop to remove the driver until the tfm is freed.
>
> 1. You don't introduce a bug in patch 8 only to fix it in patch 10.
>    Lay the groundwork first before you rely on it.
>

Sorry, I'll move the patch 10 before patch 8

> 2. You need to explain how the wait fixes the problem of unregistering
>    an algorithm under a live tfm.  Can you even do a wait at all
>    in the face of a PCI unbind? What happens when the device reappears?
>

The function 'hisi_qm_wait_task_finish' will check the device status. If 
it is free, the function will freeze all queues in the device and go on. 
Otherwise, the function will wait until the device is free.

And the function is added in 'pci_driver.remove'. So the operation of
unbind will call it too.

Q:'What happens when the device reappears?'
A:Do you means the scene like bind and unbind? There is a device list
in the driver. The registration or unregistration of algorithms will
only happen when the list is empty. So the function register or
unregister will be called only once.

> Cheers,
>


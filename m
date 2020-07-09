Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816C0C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 11:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABC0207C4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 11:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGILFY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 07:05:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbgGILFX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 07:05:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6B6E94268DA562CD4B4;
        Thu,  9 Jul 2020 19:05:21 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Jul 2020
 19:05:11 +0800
Subject: Re: [Patch v2 8/9] crypto: hisilicon/qm - fix the process of register
 algorithms to crypto
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
 <1593587995-7391-9-git-send-email-shenyang39@huawei.com>
 <20200709053619.GA5637@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <4e79b1ce-2b2a-7db3-dc55-380c2229657a@huawei.com>
Date:   Thu, 9 Jul 2020 19:05:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200709053619.GA5637@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/7/9 13:36, Herbert Xu wrote:
> On Wed, Jul 01, 2020 at 03:19:54PM +0800, Yang Shen wrote:
>> When the devices are removed or not existing, the corresponding algorithms
>> which are registered by 'hisi-zip' driver can't be used.
>>
>> Move 'hisi_zip_register_to_crypto' from 'hisi_zip_init' to
>> 'hisi_zip_probe'. The algorithms will be registered to crypto only when
>> there is device bind on the driver. And when the devices are removed,
>> the algorithms will be unregistered.
>
> You can't just unregister a live algorithm because if someone
> holds a reference count on it then the Crypto API will crash.
>

Yes, this patch just fixes the bug for 'hisi_zip'. As for 'hisi_hpre'
and 'hisi_sec2', this patch doesn't change the logic.
We have noticed the problem you say, and the patch is prepared. We fix
this in 'hisi_qm', and you will see it soon.

> Cheers,
>

Thanks
Yang




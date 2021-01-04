Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D7CC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 08:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470D920784
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 08:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADIP7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 03:15:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10380 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbhADIP7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 03:15:59 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D8T1V73tPz7Q55;
        Mon,  4 Jan 2021 16:14:22 +0800 (CST)
Received: from [10.67.102.118] (10.67.102.118) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 16:15:12 +0800
Subject: Re: [PATCH v2 0/6] crypto: hisilicon - enable new algorithms of SEC
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1607598607-8728-1-git-send-email-liulongfang@huawei.com>
 <20210102210044.GA1514@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <5432190d-0467-1a99-3629-bf8b618b35ef@huawei.com>
Date:   Mon, 4 Jan 2021 16:15:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210102210044.GA1514@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/1/3 5:00, Herbert Xu wrote:
> On Thu, Dec 10, 2020 at 07:10:01PM +0800, Longfang Liu wrote:
>> Add support for new algorithms of SEC accelerator on Kunpeng930,
>> the driver and test case needs to be updated
>>
>> Longfang Liu (5):
>>   crypto: hisilicon/sec - add new type of sqe for Kunpeng930
>>   crypto: hisilicon/sec - add new skcipher mode for SEC
>>   crypto: hisilicon/sec - add new AEAD mode for SEC
> 
> Did you run the fuzz tests on these additions?
> 
> Thanks,
> 
Hi,
Currently, we have not conducted Fuzz testing.
For SEC driver, we only adds support for these new algorithms
with existing interfaces of Crypto. So, do we need to do Fuzz testing on the existing interfaces?

Thanks,
Longfang

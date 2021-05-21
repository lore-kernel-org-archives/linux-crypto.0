Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20364C43460
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2741613B6
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhEUIMH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 04:12:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3611 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbhEUIK2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 04:10:28 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmfK24Z86zQp22;
        Fri, 21 May 2021 16:04:38 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 16:08:10 +0800
Received: from [10.67.101.248] (10.67.101.248) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 16:08:10 +0800
Subject: Re: [PATCH 1/3] crypto: ecdh - fix 'ecdh_init'
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
 <1620801602-49287-2-git-send-email-tanghui20@huawei.com>
 <20210521074553.w6qtqv5nnbdbqycx@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <linux-kernel@vger.kernel.org>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <2a5bcd22-455d-6348-9a72-dc5a7ab49ca6@huawei.com>
Date:   Fri, 21 May 2021 16:08:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210521074553.w6qtqv5nnbdbqycx@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/5/21 15:45, Herbert Xu wrote:
> On Wed, May 12, 2021 at 02:40:00PM +0800, Hui Tang wrote:
>> NIST P192 is not unregistered if failed to register NIST P256,
>> actually it need to unregister the algorithms already registered.
>>
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>>  crypto/ecdh.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> Thanks for catching this.  The variable ecdh_nist_p192_registered
> is bogus.  You should just make it so that if p192 fails to
> register then the init function aborts.  There would then be
> no need to check for the registered state in the exit function.
>

Okay, I will fix it in next version, and 'ecdsa_init' should
do the same thing too?

>

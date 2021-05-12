Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4807FC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 03:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C7C6147D
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 03:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhELD6f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 23:58:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5102 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhELD6e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 23:58:34 -0400
Received: from dggeml711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fg1C546M8zYh2Q;
        Wed, 12 May 2021 11:54:57 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggeml711-chm.china.huawei.com (10.3.17.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 12 May 2021 11:57:25 +0800
Received: from [10.67.101.248] (10.67.101.248) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 12 May 2021 11:57:24 +0800
Subject: Re: [PATCH v2 0/8] crypto: hisilicon/hpre - fix coding style
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <1620790471-16621-1-git-send-email-tanghui20@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <0be7d995-f5c9-5c04-7bbb-75c49d1f260e@huawei.com>
Date:   Wed, 12 May 2021 11:57:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1620790471-16621-1-git-send-email-tanghui20@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sorry, please ignore this patchset,
there is a problem with my email, I will resend.

On 2021/5/12 11:34, Hui Tang wrote:
> This patchset fix coding style, as follows:
>
> Hui Tang (8):
>   crypto: hisilicon/hpre - the macro 'HPRE_ADDR' expands
>   crypto: hisilicon/hpre - init a structure member each line
>   crypto: hisilicon/hpre - replace macro with inline function
>   crypto: hisilicon/hpre - remove the macro of 'HPRE_DEV'
>   crypto: hisilicon/hpre - delete rudundant initialization
>   crypto: hisilicon/hpre - use 'GENMASK' to generate mask value
>   crypto: hisilicon/hpre - delete rudundant macro definition
>   crypto: hisilicon/hpre - add 'default' for switch statement
>
> v1 -> v2: fix build warnings reported by kernel test robot.
>
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c |  67 ++++++------
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 157 +++++++++++++++++-----------
>  2 files changed, 128 insertions(+), 96 deletions(-)
>
> --
> 2.8.1
>
> .
>

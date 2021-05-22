Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58861C04FF3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9C5613AD
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhEVCsU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 22:48:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4577 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhEVCsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 22:48:19 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fn78j6WFXzsSwC;
        Sat, 22 May 2021 10:44:05 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 10:46:54 +0800
Received: from [10.67.101.248] (10.67.101.248) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 10:46:53 +0800
Subject: Re: [PATCH v2 0/4] crypto: ecdh - register NIST P384
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <1621650084-25505-1-git-send-email-tanghui20@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <9c438087-deef-2df5-80e8-62ada0f67e61@huawei.com>
Date:   Sat, 22 May 2021 10:46:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1621650084-25505-1-git-send-email-tanghui20@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sorry, please ignore this patchset, there is a problem with subject format,
I will resend.

On 2021/5/22 10:21, Hui Tang wrote:
> Register NIST P384 tfm and extend the testmgr with NIST P384 test vectors.
>
> Summary of changes:
>
> * crypto/ecdh.c
>   - fix 'ecdh_init' not unregistering NIST P192
>   - add ecdh_nist_p384_init_tfm
>   - register and unregister P384 tfm
>
> * crypto/testmgr.c
>   - add test vector for P384 on vector of tests
>
> * crypto/testmgr.h
>   - add test vector params for P384
>
> ---
> v1 -> v2:
> * Add patch#1:
>   - Fix ecdh-nist-p192's entry in testmgr.
>   - Add a comment for registering ecdh-nist-p192.
> ---
>
> Hui Tang (4):
>   crypto: ecdh: fix ecdh-nist-p192's entry in testmgr
>   crypto: ecdh - fix 'ecdh_init'
>   crypto: ecdh - register NIST P384 tfm
>   crypto: ecdh - add test suite for NIST P384
>
>  crypto/ecdh.c    | 45 +++++++++++++++++++++++++++++++++++++++-
>  crypto/testmgr.c | 10 ++++++---
>  crypto/testmgr.h | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 112 insertions(+), 6 deletions(-)
>
> --
> 2.8.1
>
> .
>

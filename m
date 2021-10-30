Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44055C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Oct 2021 01:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EF660FDA
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Oct 2021 01:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhJ3BIu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 21:08:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26208 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhJ3BIt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 21:08:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hh1Kx18TZz8v0j;
        Sat, 30 Oct 2021 09:04:53 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 09:06:15 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 09:06:15 +0800
Subject: Re: [PATCH v3 0/6] crypto: hisilicon - supports hash algorithm for
 SEC engine
To:     <herbert@gondor.apana.org.au>
References: <20211022091055.15369-1-yekai13@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <f0f54c23-dec3-f3eb-3283-3ef6478efe33@huawei.com>
Date:   Sat, 30 Oct 2021 09:06:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211022091055.15369-1-yekai13@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/10/22 17:10, Kai Ye wrote:
> The driver adds hash algorithms, sm3, md5, sha1,
> sha256, sha512. Add fallback tfm supporting. Modify
> the driver as needed. The fuzzing test has been passed.
>
> changes v1->v2:
> 	1. Modify the process of export and import. Using the ahash_req as
> 	   hash state. By copying the content of structure sec_ahash_req to
> 	   avoid dereferencing random pointers from import path. User can
> 	   export the hash state and then import the hash state, and it
> 	   still work.
> 	2. Add sm3/md5 generic selection
> 	
> changes v2->v3:
> 	1. Modify the process of export and import. Export the block of hash
> 	   state from the mac address, then user can import the existing hash
> 	   state.
>
> Kai Ye (6):
>   crypto: hisilicon/sec - add ping-pong buffer for ahash
>   crypto: hisilicon/sec - add ahash alg features for Kunpeng920
>   crypto: hisilicon/sec - support the larger packets for digest mode
>   crypto: hisilicon/sec - ahash adapt to Kunpeng930 SQE
>   crypto: hisilicon/sec - add fallback tfm supporting for ahash
>   crypto: hisilicon/sec - add sm3/md5 generic selection for ahash
>
>  drivers/crypto/hisilicon/Kconfig           |    2 +
>  drivers/crypto/hisilicon/sec2/sec.h        |   56 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 1345 +++++++++++++++++++-
>  drivers/crypto/hisilicon/sec2/sec_crypto.h |   10 +
>  4 files changed, 1396 insertions(+), 17 deletions(-)
>


Hi Herbert

Could you help to take this patchset?

Thanks

Kai

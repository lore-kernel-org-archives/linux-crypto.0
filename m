Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E50C4361B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179D922E03
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgLPCk1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:40:27 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9206 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLPCk1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 21:40:27 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CwfTD5xKSzkqRT;
        Wed, 16 Dec 2020 10:38:56 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 16 Dec 2020
 10:39:38 +0800
Subject: Re: [PATCH v4 4/5] crypto: hisilicon/hpre - add 'ECDH' algorithm
To:     Stephan Mueller <smueller@chronox.de>
References: <13db294664a6b2e26a892dd544c714d3e385b0cc.camel@chronox.de>
 <3903e2e8-165f-51b5-056c-24b8ce52e842@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <711de58c-4f7c-4643-4b8b-6af98ed1a7bc@huawei.com>
Date:   Wed, 16 Dec 2020 10:39:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <3903e2e8-165f-51b5-056c-24b8ce52e842@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org




> Am Freitag, den 11.12.2020, 14:30 +0800 schrieb Meng Yu:
>> 
>> +/* size in bytes of the n prime */
>> +#define HPRE_ECC_NIST_P128_N_SIZE      16
> 
> Do we truly need P-128? Besides, I do not see that curve being defined in
> contemporary cipher specs.
> 
>> +#define HPRE_ECC_NIST_P192_N_SIZE      24
>> +#define HPRE_ECC_NIST_P224_N_SIZE      28
>> +#define HPRE_ECC_NIST_P256_N_SIZE      32
>> +#define HPRE_ECC_NIST_P320_N_SIZE      40
> 
> Do we truly need P-320? Besides, I do not see that curve being defined in
> contemporary cipher specs.

Yes, in rfc 5903, only P-256, P-384 and P-521 is defined, but in
'rfc5639' and  "SEC 2: Recommended Elliptic Curve Domain Parameters",
other curves like P-128, P-192, P-224, and P-320 curve parameters are
found, and they are used in 'openssl';
How about your idea?

Thanks,


>> +#define HPRE_ECC_NIST_P384_N_SIZE      48
>> +#define HPRE_ECC_NIST_P521_N_SIZE      66
>> +
>> +/* size in bytes */
>> +#define HPRE_ECC_HW256_KSZ_B   32
>> +#define HPRE_ECC_HW384_KSZ_B   48
>> +#define HPRE_ECC_HW576_KSZ_B   72
>> +
>> +#define HPRE_ECDH_MAX_SZ       HPRE_ECC_HW576_KSZ_B]
> 
> Ciao
> Stephan
> 
> .
> 

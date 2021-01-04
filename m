Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA92C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 09:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8404D21D7F
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 09:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbhADJh1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 04:37:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10105 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbhADJh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 04:37:26 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8VqD0vDczMFBN;
        Mon,  4 Jan 2021 17:35:36 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Mon, 4 Jan 2021
 17:36:33 +0800
Subject: Re: [PATCH v5 3/5] crypto: expose elliptic curve parameters as Crypto
 APIs
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <linux-kernel@vger.kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        "Prabhjot Khurana" <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <1608790107-32617-1-git-send-email-yumeng18@huawei.com>
 <1608790107-32617-4-git-send-email-yumeng18@huawei.com>
 <20210102212929.GA1996@gondor.apana.org.au>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <a260ceec-e3ca-8fbd-e80e-f08ddc2029a4@huawei.com>
Date:   Mon, 4 Jan 2021 17:36:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210102212929.GA1996@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



ÔÚ 2021/1/3 5:29, Herbert Xu Ð´µÀ:
> On Thu, Dec 24, 2020 at 02:08:25PM +0800, Meng Yu wrote:
>> Move elliptic curves definition to 'include/crypto/ecc_curve_defs.h',
>> so all can use it,
>>
>> Signed-off-by: Meng Yu <yumeng18@huawei.com>
>> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
>> ---
>>   crypto/ecc.c                    |  1 -
>>   crypto/ecc.h                    | 37 +----------------
>>   crypto/ecc_curve_defs.h         | 57 -------------------------
>>   crypto/ecrdsa_defs.h            |  2 +-
>>   include/crypto/ecc_curve_defs.h | 92 +++++++++++++++++++++++++++++++++++++++++
>>   5 files changed, 95 insertions(+), 94 deletions(-)
>>   delete mode 100644 crypto/ecc_curve_defs.h
>>   create mode 100644 include/crypto/ecc_curve_defs.h
> 
> This conflicts with
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/20201217172101.381772-3-daniele.alessandrelli@linux.intel.com/
> 
> Please discuss with each other on how you would like to proceed.
> 
> Thanks,
> 

hello, Daniele,

In my patch, I move elliptic curves definition to 
'include/crypto/ecc_curve_defs.h',
which include the P-384 curve you need, and you can easily import it to 
your driver.

And if you include 'crypto/ecc_curve_defs.h', 
'drivers/crypto/keembay/ocs-ecc-curve-defs.h'
is not needed.

Could you think about it, to rely on my patchset?

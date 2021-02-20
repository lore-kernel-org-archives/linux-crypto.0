Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83582C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 09:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5213D64ED2
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 09:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhBTJwN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 04:52:13 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13366 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhBTJwN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 04:52:13 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DjNw569vNz7nCJ;
        Sat, 20 Feb 2021 17:49:57 +0800 (CST)
Received: from [10.67.102.118] (10.67.102.118) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Sat, 20 Feb 2021 17:51:22 +0800
Subject: Re: [PATCH 3/3] crypto: hisilicon/sec - fixes shash test error
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <wangzhou1@hisilicon.com>, <xuzaibo@huawei.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ard Biesheuvel" <ardb@kernel.org>
References: <1612519857-30714-1-git-send-email-liulongfang@huawei.com>
 <1612519857-30714-4-git-send-email-liulongfang@huawei.com>
 <20210205114435.GA17031@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <6e5d529d-07df-5db0-d5c0-72e90e13852d@huawei.com>
Date:   Sat, 20 Feb 2021 17:51:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210205114435.GA17031@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/2/5 19:44, Herbert Xu Wrote:
> On Fri, Feb 05, 2021 at 06:10:57PM +0800, Longfang Liu wrote:
>> If this configuration item is not turned on,
>> the allocation of crypto_tfm will fail when
>> the shash algorithm calculates the hash
>> through the software.
>>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  arch/arm64/configs/defconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
>> index 8383016..7cfc9b6 100644
>> --- a/arch/arm64/configs/defconfig
>> +++ b/arch/arm64/configs/defconfig
>> @@ -117,7 +117,7 @@ CONFIG_KVM=y
>>  CONFIG_ARM64_CRYPTO=y
>>  CONFIG_CRYPTO_SHA1_ARM64_CE=y
>>  CONFIG_CRYPTO_SHA2_ARM64_CE=y
>> -CONFIG_CRYPTO_SHA512_ARM64_CE=m
>> +CONFIG_CRYPTO_SHA512_ARM64_CE=y
> 
> If this is truly needed then it should be enabled through Kconfig.
> 
> Cheers,
> 
Hi,
Since patch3 is an unnecessary patch,
can you just remove it and merge patch1 and patch2?
Thanks,
Longfang.

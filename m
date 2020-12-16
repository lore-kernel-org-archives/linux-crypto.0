Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2037C4361B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80AD9230FF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPCpv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:45:51 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9614 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgLPCpv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 21:45:51 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cwfbg4lJyz15cZt;
        Wed, 16 Dec 2020 10:44:31 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 16 Dec 2020
 10:45:00 +0800
Subject: Re: [PATCH v4 5/5] crypto: hisilicon/hpre - add 'CURVE25519'
 algorithm
To:     Stephan Mueller <smueller@chronox.de>
References: <00235d6da9beddd365217aeb8add986c615762bc.camel@chronox.de>
 <e6bf72e0-38cd-a17e-ecae-e6fabdb313eb@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <a687399c-14f9-4d5e-33a7-57c3a1e21de4@huawei.com>
Date:   Wed, 16 Dec 2020 10:45:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <e6bf72e0-38cd-a17e-ecae-e6fabdb313eb@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Am Freitag, den 11.12.2020, 14:30 +0800 schrieb Meng Yu:
>>   
>> +/* curve25519 */
>> +static u64 curve25519_g_x[] = { 0x0000000000000009, 0x0000000000000000,
>> +                               0x0000000000000000, 0x0000000000000000 };
>> +static u64 curve25519_p[] = { 0xffffffffffffffed, 0xffffffffffffffff,
>> +                               0xffffffffffffffff, 0x7fffffffffffffff };
>> +static u64 curve25519_a[] = { 0x000000000001DB41, 0x0000000000000000,
>> +                               0x0000000000000000, 0x0000000000000000 };
>> +static const struct ecc_curve ecc_25519 = {
>> +       .name = "curve25519",
>> +       .g = {
>> +               .x = curve25519_g_x,
>> +               .ndigits = 4,
>> +       },
>> +       .p = curve25519_p,
>> +       .a = curve25519_a,
>> +};
> 
> With this definition, I am not sure whether ecc_is_pubkey_valid_partial would
> work correctly. At least it *seems* that there would be a NULL-pointer
> dereference in vli_add with the undefined .b value. Did you test and can you
> confirm?
> 
> Thanks
> Stephan
> 

'static const struct ecc_curve ecc_25519' is curve25519's parameters,
only used in 'curve25519', not used by 'ECDH';

Thanks,

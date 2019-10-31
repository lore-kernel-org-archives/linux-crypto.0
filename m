Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF70CA9EC3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941922087F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfJaIP4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:15:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726795AbfJaIP4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 04:15:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D7FC56DA03BD7E6E69AD;
        Thu, 31 Oct 2019 16:15:53 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 31 Oct 2019
 16:15:46 +0800
Subject: Re: [PATCH v3] crypto: arm64/aes-neonbs - add return value of
 skcipher_walk_done() in __xts_crypt()
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
References: <aaf0f585-3a06-8af1-e2f1-ab301e560d49@huawei.com>
 <32b39396-d514-524f-a85c-3bc627454ba7@huawei.com>
 <CAKv+Gu8A+kDK0Jtmu6oOO6jhgFkgYQ7=4tw_eMStmYPMkMp6iQ@mail.gmail.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Message-ID: <10ff656f-5cf5-53bb-e654-90d84bdf0730@huawei.com>
Date:   Thu, 31 Oct 2019 16:15:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8A+kDK0Jtmu6oOO6jhgFkgYQ7=4tw_eMStmYPMkMp6iQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019/10/31 16:13, Ard Biesheuvel wrote:
> On Thu, 31 Oct 2019 at 08:02, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
>>
>> A warning is found by the static code analysis tool:
>>   "Identical condition 'err', second condition is always false"
>>
>> Fix this by adding return value of skcipher_walk_done().
>>
>> Fixes: 67cfa5d3b721 ("crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS")
>> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
>> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Please don't send the exact same patch twice, and when you feel the
> need to do so, just ask instead whether your patch was received or
> not.
> 
ok, thanks.

> I'm sure Herbert will pick it up shortly.
> 
>> ---
>> v2 -> v3:
>>  - add "Acked-by:"
>>
>> v1 -> v2:
>>  - update the subject and comment
>>  - add return value of skcipher_walk_done()
>>
>>  arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
>> index ea873b8904c4..e3e27349a9fe 100644
>> --- a/arch/arm64/crypto/aes-neonbs-glue.c
>> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
>> @@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
>>                         goto xts_tail;
>>
>>                 kernel_neon_end();
>> -               skcipher_walk_done(&walk, nbytes);
>> +               err = skcipher_walk_done(&walk, nbytes);
>>         }
>>
>>         if (err || likely(!tail))
>> --
>> 2.7.4.3
>>
>>
> 
> .
> 


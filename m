Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBA4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 07:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4AF2184C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 07:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfJVHPM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 03:15:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbfJVHPM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 03:15:12 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1FA04A12A33EAD9386E7;
        Tue, 22 Oct 2019 15:15:10 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 22 Oct 2019
 15:15:02 +0800
Subject: Re: [PATCH] crypto: arm64/aes-neonbs - remove redundant code in
 __xts_crypt()
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a33932c9-2975-4fcc-ba07-7c54df4eae27@huawei.com>
 <CAKv+Gu-qAy9iLbR97=Kz90+-YLLvz0nmTZtxhByeOXEG3xvaBQ@mail.gmail.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Message-ID: <43706330-cc84-d597-11ad-a3e0afb0b793@huawei.com>
Date:   Tue, 22 Oct 2019 15:14:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-qAy9iLbR97=Kz90+-YLLvz0nmTZtxhByeOXEG3xvaBQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019/10/22 14:52, Ard Biesheuvel wrote:
> On Tue, 22 Oct 2019 at 08:42, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
>>
>> A warning is found by the static code analysis tool:
>>   "Identical condition 'err', second condition is always false"
>>
>> Fix this by removing the redundant condition @err.
>>
>> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> 
> Please don't blindly 'fix' crypto code without reading it carefully
> and without cc'ing the author.
> 
ok, thanks.

> The correct fix is to add the missing assignment of 'err', like so
> 
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c
> b/arch/arm64/crypto/aes-neonbs-glue.c
> index ea873b8904c4..e3e27349a9fe 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_request
> *req, bool encrypt,
>                         goto xts_tail;
> 
>                 kernel_neon_end();
> -               skcipher_walk_done(&walk, nbytes);
> +               err = skcipher_walk_done(&walk, nbytes);
>         }
> 
>         if (err || likely(!tail))
> 
> Does that make the warning go away?
> 
yes, warning has go way.

> 
>> ---
>>  arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
>> index ea873b8904c4..7b342db428b0 100644
>> --- a/arch/arm64/crypto/aes-neonbs-glue.c
>> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
>> @@ -387,7 +387,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
>>                 skcipher_walk_done(&walk, nbytes);
>>         }
>>
>> -       if (err || likely(!tail))
>> +       if (likely(!tail))
>>                 return err;
>>
>>         /* handle ciphertext stealing */
>> --
>> 2.7.4.3
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> .
> 


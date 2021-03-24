Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BD6C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Mar 2021 09:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A9A61A0D
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Mar 2021 09:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhCXJ1f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:27:35 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:65390 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234844AbhCXJ1V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Mar 2021 05:27:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UT9Ta7E_1616578026;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UT9Ta7E_1616578026)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Mar 2021 17:27:07 +0800
Subject: Re: [PATCH] init/Kconfig: Support sign module with SM3 hash algorithm
To:     Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Nick Terrell <terrelln@fb.com>, KP Singh <kpsingh@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, keyrings@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
References: <20210323083528.25678-1-tianjia.zhang@linux.alibaba.com>
 <28d3a339-6210-ffd2-950f-ea5340ac23b7@infradead.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <f01f2b36-4978-1c8d-7b7b-f1f8fd49c6d1@linux.alibaba.com>
Date:   Wed, 24 Mar 2021 17:27:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <28d3a339-6210-ffd2-950f-ea5340ac23b7@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 3/24/21 12:43 AM, Randy Dunlap wrote:
> On 3/23/21 1:35 AM, Tianjia Zhang wrote:
>> The kernel module signature supports the option to use the SM3
>> secure hash (OSCCA GM/T 0004-2012 SM3).
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   Documentation/admin-guide/module-signing.rst | 5 +++--
>>   crypto/asymmetric_keys/pkcs7_parser.c        | 7 +++++++
>>   init/Kconfig                                 | 5 +++++
>>   3 files changed, 15 insertions(+), 2 deletions(-)
>>
> 
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 5f5c776ef192..fed9236078e4 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -2202,6 +2202,10 @@ config MODULE_SIG_SHA512
>>   	bool "Sign modules with SHA-512"
>>   	select CRYPTO_SHA512
>>   
>> +config MODULE_SIG_SM3
>> +	bool "Sign modules with SM3"
>> +	select CRYPTO_SM3
>> +
>>   endchoice
>>   
>>   config MODULE_SIG_HASH
>> @@ -2212,6 +2216,7 @@ config MODULE_SIG_HASH
>>   	default "sha256" if MODULE_SIG_SHA256
>>   	default "sha384" if MODULE_SIG_SHA384
>>   	default "sha512" if MODULE_SIG_SHA512
>> +	default "sm3" if MODULE_SIG_SM3
>>   
>>   config MODULE_COMPRESS
>>   	bool "Compress modules on installation"
>>
> 
> checkpatch tells me:
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #74: FILE: init/Kconfig:2205:
> +config MODULE_SIG_SM3
> 
> 
> so yes, it should have some help text there.
> 
> thanks.
> 

I noticed, but this is just a list of algorithms, this warning can be 
ignored.

Best regards,
Tianjia

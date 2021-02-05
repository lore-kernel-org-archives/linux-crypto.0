Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50695C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 00:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EE3464FB5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 00:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBEAKh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhBEAKf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 19:10:35 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDA7C0613D6
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 16:09:55 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v3so3857479qtw.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 16:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SI5j+iF4abUgLvTfrUu5p8XYf5nU55OwaIfuxVg8Ap0=;
        b=H9ym7IUTalqakgHKC0f0MtYjYUKCC3VtKcANjxlXeqjZ7aiQWyr39E31AuAsXHAgks
         lo80EjeggpY0ZpTNhkLNAvCfZldD1KQ+9A4/6iinHlL1rnlzLql5c4lqTRWiA7h32lIa
         8gfC600dffl+16Mj/FB9cb8rwIF+5fst+oUkCw53F0KHS7knK6G/NeI7n4oxdxH1tBX9
         e8WDJAiJgg1LoXjIj/sCkCc0fOYzC8RHEfz2ol+cgH1We4a/WSnErfkwi0A0QOcfnXoU
         8ujRTjHfe4RBFvHeS/yzl5mh5KES6CHbXmza4UsVWzdOh1mHMwZJ9VUs0zLvKSla4wNh
         RKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SI5j+iF4abUgLvTfrUu5p8XYf5nU55OwaIfuxVg8Ap0=;
        b=aTJJl/H4H4bEx+Vvk0vvKYIW7SPcIYjZa+11mFHG0FDpUrsOuNbEBpGLB8bWUPJM2A
         Cd1+Svb+InSkc7KKxHg+8Ejliq6mvNMHB5MDQSNryD22sNv6OU7n5xN1x6pzfEvN6IBL
         cdODnXKTs9UL8OooSb2Mr/z6nBfF332I63jQgHwmg7MGUfDOTGQ4p2gVFsII0N3ylXjt
         z32YRqQhDzgRLxhAYs8QSHagxzX7ybufBXC7MlGeI04rlsyK23pSKtd4H2DrtHq9H1nH
         rPqCZ3HO3Ojv/EeOzasj3AwtKZUQyf5gi4yVm2Et/zTL4UB+mERMp36usTZOj3Atpsbg
         vhKA==
X-Gm-Message-State: AOAM531JloWpkAI19aQ4UBYqyWmfc0L+f9oeo/uMpg7pmlub64h/6CI5
        03WDqq85zmtxgqCO1Zu+yyjPFA==
X-Google-Smtp-Source: ABdhPJxYtAZhjVVST7Vak3wz59xZUtUViRe7TuK1cZsxuylDhIFq0ONt6NQhA0p8PuqQloxt4VKF5w==
X-Received: by 2002:ac8:7768:: with SMTP id h8mr2048041qtu.331.1612483794726;
        Thu, 04 Feb 2021 16:09:54 -0800 (PST)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id q6sm6959212qkq.34.2021.02.04.16.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 16:09:54 -0800 (PST)
Subject: Re: [PATCH v5 05/11] crypto: qce: skcipher: Return error for zero
 length messages
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
 <20210204214359.1993065-6-thara.gopinath@linaro.org>
 <YBx5yWhKtT2EC2Ce@gmail.com>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <00d759f3-8ea3-1f85-b623-225c372c0a04@linaro.org>
Date:   Thu, 4 Feb 2021 19:09:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YBx5yWhKtT2EC2Ce@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 2/4/21 5:48 PM, Eric Biggers wrote:
> On Thu, Feb 04, 2021 at 04:43:53PM -0500, Thara Gopinath wrote:
>> Crypto engine BAM dma does not support 0 length data. Return unsupported
>> if zero length messages are passed for transformation.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> ---
>>   drivers/crypto/qce/skcipher.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
>> index de1f37ed4ee6..331b3c3a5b59 100644
>> --- a/drivers/crypto/qce/skcipher.c
>> +++ b/drivers/crypto/qce/skcipher.c
>> @@ -8,6 +8,7 @@
>>   #include <linux/interrupt.h>
>>   #include <linux/moduleparam.h>
>>   #include <linux/types.h>
>> +#include <linux/errno.h>
>>   #include <crypto/aes.h>
>>   #include <crypto/internal/des.h>
>>   #include <crypto/internal/skcipher.h>
>> @@ -260,6 +261,10 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
>>   	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
>>   	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
>>   
>> +	/* CE does not handle 0 length messages */
>> +	if (!req->cryptlen)
>> +		return -EOPNOTSUPP;
>> +
> 
> For the algorithms in question, the correct behavior is to return 0.

What do you mean? The driver should return a 0 ?

> 
> Aren't the tests catching that difference?

I was anyways planning on sending an email to the list with these 
queries. But since you asked,  these are my observations with fuzz 
testing which I have been doing quite a bit now (I am also working on 
adding a few qualcomm AEAD algorithms support in mainline).

- if the generic algorithm supports 0 length messages and the 
transformation I am testing does not, the test framework throws an error 
and stops.
- key support mismatch between the generic algorithm vs my algorithm 
/engine also does the same thing.For eg, Qualcomm CE engine does not 
support any three keys being same for triple des algorithms. Where as a 
two key 3des is a valid scenario for generic algorithm(k1=k3). Another 
example is hardware engine not supporting AES192.

How are these scenarios usually handled ? Why not allow the test 
framework to proceed with the testing if the algorithm does not support 
a particular scenario ?

> 
> - Eric
> 
-- 
Warm Regards
Thara

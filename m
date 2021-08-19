Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A378FC4320A
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 02:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8142560EB5
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 02:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhHSCFT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbhHSCFS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 22:05:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575D5C0613CF
        for <linux-crypto@vger.kernel.org>; Wed, 18 Aug 2021 19:04:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c4so3006025plh.7
        for <linux-crypto@vger.kernel.org>; Wed, 18 Aug 2021 19:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BOxUoQivjgFZ1DLgZNdPrhR+Bg8R8i8R1VkSNL8IUig=;
        b=FMDMJuSUoxzv2j2BjBXZdfACsrSN4wx7jPmQuppjrKGGhDIoyhGPzQi4jow3zQApfV
         sExsGeDHmjzzHqimerdbHVXnsvK62jw14eJSjjM8ptwyp53X0Pk/SJIZzx7cZ30J2VIj
         zypkx+SADaWkWjGdTxlPxb5sRGSEQL4Fr+oaUg9EBvCQUM32BlgKOK8g/vEEAb179uZX
         fw1S61dcsgNWV2M1/fj/BdCZudO846By6xhBufZxS5UfSpBXQm4/6ukpnyEeVu6pYOGa
         L648ej+yvZy1lR3FFSqmbBKCjrhv6mVreSn+1RGjI0Aqvy0J2Ubo7rfz7TrbsyDnR+Bu
         SIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BOxUoQivjgFZ1DLgZNdPrhR+Bg8R8i8R1VkSNL8IUig=;
        b=IeNGxD4p9AqWqXteFJwUqZ7MBUK64imkuhz7rSnL7AEL/M4QrpGqg/P/Vesp4ZFHGX
         7tE3M5UDc3FcFR5ML4RpYJdPHN91CMvMqa4pBScphPH8P3K3uCa1eTGKjOpEobvqGNT4
         l1niz8r0QZA4htT6rNbR42asBBwOn+9t/xMY/pvygl6R+5Um+aUOYQk7l5fMwqCr0oDG
         +PDf5WoRaX4wH4cMy8VmCOu+T4TWrMfgWLZzibWvhllddGpMcmdFUPsWeZ/wsbWflUFd
         bxuaqaM5FIBmAK/4BR02Z3Cc5YEr3hlfoQhJTydKg+WY2jIA5+9UargVwXN1A6vaQ22a
         mDVQ==
X-Gm-Message-State: AOAM532E0zkr/yz+T+6A2CwhwD2bL+wGEGHPWn+nMWd9ZHjnX/l0xKQo
        bNqK/0eSDd3BkxlZgizjoJNJyQ==
X-Google-Smtp-Source: ABdhPJynUCx+JXpaZSG119iXqCmKTow+CkUyVO/V/bIlaBAxFzTXpQl8K6D/1St/I9rCpmAqVk2Blw==
X-Received: by 2002:a17:90a:d3d2:: with SMTP id d18mr12526374pjw.102.1629338682812;
        Wed, 18 Aug 2021 19:04:42 -0700 (PDT)
Received: from [10.2.24.177] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id y3sm1285397pgc.67.2021.08.18.19.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 19:04:42 -0700 (PDT)
Subject: Re: Re: PING: [PATCH] crypto: public_key: fix overflow during
 implicit conversion
To:     Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, dhowells@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210810063954.628244-1-pizhenwei@bytedance.com>
 <4dcd4254-030b-4489-d5d3-e320eb2953e7@bytedance.com>
 <74aef8a2f2331358371a87931e632287dad9af59.camel@iki.fi>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <8bf3a04d-f1a7-cd8c-5c5a-ace3de500b2f@bytedance.com>
Date:   Thu, 19 Aug 2021 10:03:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <74aef8a2f2331358371a87931e632287dad9af59.camel@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/18/21 8:33 PM, Jarkko Sakkinen wrote:
> On Wed, 2021-08-18 at 16:33 +0800, zhenwei pi wrote:
>> PING
> 
> Please, do not top-post.
> 
> You are lacking Herbert Xu:
> 
> $ scripts/get_maintainer.pl crypto/asymmetric_keys/public_key.c
> David Howells <dhowells@redhat.com> (maintainer:ASYMMETRIC KEYS)
> Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API)
> "David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
> keyrings@vger.kernel.org (open list:ASYMMETRIC KEYS)
> linux-crypto@vger.kernel.org (open list:CRYPTO API)
> linux-kernel@vger.kernel.org (open list)
> 
>> On 8/10/21 2:39 PM, zhenwei pi wrote:
>>> Hit kernel warning like this, it can be reproduced by verifying 256
>>> bytes datafile by keyctl command.
>>>
>>>    WARNING: CPU: 5 PID: 344556 at crypto/rsa-pkcs1pad.c:540
>>> pkcs1pad_verify+0x160/0x190
>>>    ...
>>>    Call Trace:
>>>     public_key_verify_signature+0x282/0x380
>>>     ? software_key_query+0x12d/0x180
>>>     ? keyctl_pkey_params_get+0xd6/0x130
>>>     asymmetric_key_verify_signature+0x66/0x80
>>>     keyctl_pkey_verify+0xa5/0x100
>>>     do_syscall_64+0x35/0xb0
>>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> '.digest_size(u8) = params->in_len(u32)' leads overflow of an u8
> 
> Where is this statement?
> 

In function "static int asymmetric_key_verify_signature(struct 
kernel_pkey_params *params, const void *in, const void *in2)"

>>> value,
>>> so use u32 instead of u8 of digest. And reorder struct
>>> public_key_signature, it could save 8 bytes on a 64 bit machine.
>                                                       ~~~~~
>                                                       64-bit
>                                                       
> What do you mean by "could"? Does it, or does it
> not?
>                                         					
> 
After reordering struct public_key_signature, sizeof(struct 
public_key_signature) gets smaller than the original version.
	  								
> 									
> 		
> 
>>>
>>> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> 
> Nit: "Firstname Lastname" (first letters capitalized)
> 
>>> ---
>>>    include/crypto/public_key.h | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/crypto/public_key.h
>>> b/include/crypto/public_key.h
>>> index 47accec68cb0..f603325c0c30 100644
>>> --- a/include/crypto/public_key.h
>>> +++ b/include/crypto/public_key.h
>>> @@ -38,9 +38,9 @@ extern void public_key_free(struct public_key
>>> *key);
>>>    struct public_key_signature {
>>>    	struct asymmetric_key_id *auth_ids[2];
>>>    	u8 *s;			/* Signature */
>>> -	u32 s_size;		/* Number of bytes in signature */
>>>    	u8 *digest;
>>> -	u8 digest_size;		/* Number of bytes in digest */
>>> +	u32 s_size;		/* Number of bytes in signature */
>>> +	u32 digest_size;	/* Number of bytes in digest */
>>>    	const char *pkey_algo;
>>>    	const char *hash_algo;
>>>    	const char *encoding;
>>>
> 
> /Jarkko
> 

-- 
zhenwei pi

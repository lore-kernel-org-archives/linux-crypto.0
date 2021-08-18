Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64100C432BE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 08:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D45A6108B
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 08:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhHRIfR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 04:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238533AbhHRIfP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 04:35:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E712C061764
        for <linux-crypto@vger.kernel.org>; Wed, 18 Aug 2021 01:34:41 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t1so1510067pgv.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Aug 2021 01:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZp/mhDkH4ig1ld6XLX33/9sqE9sEjBNvxVZC8FkvXA=;
        b=qSulCpTew7c3zfmlIgOJ7vgVUTMIITlwihKDUEFmvYXA8qfonm85VNj3jOXeLZGWzI
         CUhVmdlunApiovitqV8qQ/ZpQ9e9yyxs4V26XvkPX+LS75mnA1ujSMmj7cSf7c93OETb
         GbrcxiwuGsG6uGCsul/WwzLVZX1rxdUPO17Cxyz+jQvBj6jgyHZI26wPa7HZWJN9fIiG
         j6PzExDVHc4mbyS+1nB1H7kg2l0/8rW2OpYTCJ4Im6prsDIch7WTJz5z8o+yJ5EUzLU5
         xCRRoxjWA19DxuO25vDGV4YFlkGFOad/6jEAp/LlOsnM5QPzToSqRMBB+ploRNzbRf0a
         fXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZp/mhDkH4ig1ld6XLX33/9sqE9sEjBNvxVZC8FkvXA=;
        b=e6zZ9qGGlT/GIAfxXyGVNblJngLdKb31Us0shM8/6v9Hqoi+OtWzeV43xaGi3vkL/V
         XK0GK0zJsFmbNvAbsvetbroNwd0hla4s3b0p6znG2iqW9eNV2eDqGSMsNH9o+yDadzva
         uYhUOzmFWtyV70Ncclk+uj59H8wxQpwHwAjXMp2tqBB3vTIweU+fG1vVa4IlCrybDEjB
         jpUDZlVphbKDd36k1UMGZlYjqtN7PvQrV11aX08509eAeoTZzJOqbJN5XIJENp3HH9/M
         1fZvmyyrhwnnwBlAA0IjCi8Y/ugw+Ss8hPFdxVj6va1qcdC+3MOJahHhbbKfC4dRK0Tu
         ZF0g==
X-Gm-Message-State: AOAM533IlOJb4DKkJ7q/WhUS94ju9nPDwK7+QvuZZVmBVZYEOhjNF2j2
        STmLnaWKt7FPRkhAjnxqOfgEKA==
X-Google-Smtp-Source: ABdhPJzmK5OA5pl1B6yGn90CYWy1+VFcm6lNS0F46W7wZ6uk6zzHyv3HAEWvl1Cjsg/oTKYsP7E0UA==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr7807415pgl.437.1629275680603;
        Wed, 18 Aug 2021 01:34:40 -0700 (PDT)
Received: from [10.2.24.177] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id c12sm4931671pfl.56.2021.08.18.01.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 01:34:40 -0700 (PDT)
Subject: PING: [PATCH] crypto: public_key: fix overflow during implicit
 conversion
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210810063954.628244-1-pizhenwei@bytedance.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <4dcd4254-030b-4489-d5d3-e320eb2953e7@bytedance.com>
Date:   Wed, 18 Aug 2021 16:33:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210810063954.628244-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


PING

On 8/10/21 2:39 PM, zhenwei pi wrote:
> Hit kernel warning like this, it can be reproduced by verifying 256
> bytes datafile by keyctl command.
> 
>   WARNING: CPU: 5 PID: 344556 at crypto/rsa-pkcs1pad.c:540 pkcs1pad_verify+0x160/0x190
>   ...
>   Call Trace:
>    public_key_verify_signature+0x282/0x380
>    ? software_key_query+0x12d/0x180
>    ? keyctl_pkey_params_get+0xd6/0x130
>    asymmetric_key_verify_signature+0x66/0x80
>    keyctl_pkey_verify+0xa5/0x100
>    do_syscall_64+0x35/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> '.digest_size(u8) = params->in_len(u32)' leads overflow of an u8 value,
> so use u32 instead of u8 of digest. And reorder struct
> public_key_signature, it could save 8 bytes on a 64 bit machine.
> 
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>   include/crypto/public_key.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index 47accec68cb0..f603325c0c30 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -38,9 +38,9 @@ extern void public_key_free(struct public_key *key);
>   struct public_key_signature {
>   	struct asymmetric_key_id *auth_ids[2];
>   	u8 *s;			/* Signature */
> -	u32 s_size;		/* Number of bytes in signature */
>   	u8 *digest;
> -	u8 digest_size;		/* Number of bytes in digest */
> +	u32 s_size;		/* Number of bytes in signature */
> +	u32 digest_size;	/* Number of bytes in digest */
>   	const char *pkey_algo;
>   	const char *hash_algo;
>   	const char *encoding;
> 

-- 
zhenwei pi

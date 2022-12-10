Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A74C10F1B
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Dec 2022 09:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLJJbY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Dec 2022 04:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLJJbX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Dec 2022 04:31:23 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C64312AD9
        for <linux-crypto@vger.kernel.org>; Sat, 10 Dec 2022 01:31:22 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id m4so7362651pls.4
        for <linux-crypto@vger.kernel.org>; Sat, 10 Dec 2022 01:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXvMwhg7xLf++iluPyXrMGby6UxGFuL66czKHsIJvxQ=;
        b=DYuM9ywGMrh6WTg8it6H3aigS+nQP950tCj1UHp5Gd0yB+XOBBA/u8MIul7cIhLZhS
         NjoQCkbUUZT7e67H9W4KTIiBsZeyAaia+pnFSAciUBl4/fpU+lifM9KXl07rDtrw/OAV
         KVF/X4gYSc7J4bPXiAc7xkMRslu4bFf2Z8RavGGPYRr96fTFBR77ZIG3oJDtPBjy28qr
         R4J4cod9rY2RHpnxZ8mhrHOPD/5vqa+c6Bm/Ytzi5bWmI3PoqLjrusAnnjdvsf8XNAqO
         jCzp0TzpbtwwQkDuVWbhxAAMZjAcCg2IWQEloByMShCg92bnotVVbWxYoe+u6XicrxWZ
         3fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXvMwhg7xLf++iluPyXrMGby6UxGFuL66czKHsIJvxQ=;
        b=vP0N2HY+DQYHhABNFPv1nUJ9YuSsf5WqqVlANRfVI3YO1B22OlpNbFNpbUaZ2qbUXf
         Exk1k2N5Sec5RVEdd0/xaI7BlR23g5kooJEV24NZLX7cvpdP4v4iYm8IDdXu8CtWAQm4
         DVcvAoOSrJJGsvEEZgmKIDAcB2uCGwRhlIZ81Ho+6OwOriTJexGXXMC95aBUNpHxw7D0
         KYiUBWSWIWZEQmYJ/BxQjPOVWjr0eqFHcqnp/yxibOxYcIMxbCXwXLcG2AZUHq6a5hH1
         pj2luKEomH5kHRaPH2PcY9OlpkdARAJbWFJ+U1VXb+597EDEWRzYMGdYgE8WOf/JIoCd
         Rf5w==
X-Gm-Message-State: ANoB5pl2l/MWdnywjxgf5tPzqer3pmBTQDSl64Qlsg4uqGC152NA+ztm
        z90SKUZj1bksjDZcFYMHOAg=
X-Google-Smtp-Source: AA0mqf5X/DJ7QZW4sl2LtaQFHgR/dnpIPgRLYeInrefrMfCOe+fVU7yT0iOuJZncMiH2jftBuwS4rw==
X-Received: by 2002:a17:902:c3c3:b0:18d:6138:e4f6 with SMTP id j3-20020a170902c3c300b0018d6138e4f6mr3672344plj.29.1670664681584;
        Sat, 10 Dec 2022 01:31:21 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f40:98::16:11a])
        by smtp.gmail.com with ESMTPSA id bi12-20020a170902bf0c00b001782398648dsm572162plb.8.2022.12.10.01.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 01:31:20 -0800 (PST)
Message-ID: <1538e3c7-5b46-7599-d3b8-48d7c40b207e@gmail.com>
Date:   Sat, 10 Dec 2022 18:31:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v7 3/4] crypto: aria: implement aria-avx2
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
References: <20221207135855.459181-1-ap420073@gmail.com>
 <20221207135855.459181-4-ap420073@gmail.com>
 <MW5PR84MB1842C9F4CAC5511B977439DBAB1C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <MW5PR84MB1842C9F4CAC5511B977439DBAB1C9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott,
Thank you so much for the review!

On 12/10/22 04:16, Elliott, Robert (Servers) wrote:
 >
 >
 >> -----Original Message-----
 >> From: Taehee Yoo <ap420073@gmail.com>
 >> Sent: Wednesday, December 7, 2022 7:59 AM
 >> Subject: [PATCH v7 3/4] crypto: aria: implement aria-avx2
 >>
 > ...
 >> diff --git a/arch/x86/crypto/aria-avx.h b/arch/x86/crypto/aria-avx.h
 >> index 01e9a01dc157..b997c4888fb7 100644
 >> --- a/arch/x86/crypto/aria-avx.h
 >> +++ b/arch/x86/crypto/aria-avx.h
 >> @@ -7,10 +7,48 @@
 >>   #define ARIA_AESNI_PARALLEL_BLOCKS 16
 >>   #define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 16)
 >>
 >> +#define ARIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 >> +#define ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 32)
 >
 > I think those _SIZE macros should use the _BLOCKS macros rather
 > than hardcode those numbers:
 >
 > 	#define ARIA_AESNI_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 
ARIA_AESNI_PARALLEL_BLOCKS)
 > 	#define ARIA_AESNI_AVX2_PARALLEL_BLOCK_SIZE  (ARIA_BLOCK_SIZE * 
ARIA_AESNI_AVX2_PARALLEL_BLOCKS)
 >

I agree with it.
I will replace the magic numbers with the _BLOCK macros in the v8 patch.

Thanks a lot!
Taehee Yoo

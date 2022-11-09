Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9BBC4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Nov 2022 13:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKINRJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Nov 2022 08:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKINRF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2022 08:17:05 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5560E25C64
        for <linux-crypto@vger.kernel.org>; Wed,  9 Nov 2022 05:17:05 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso1794564pjg.5
        for <linux-crypto@vger.kernel.org>; Wed, 09 Nov 2022 05:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uM6sitv4Wx3WJxIss+uSEKXq3x9jp0ibwC827sLuE1Q=;
        b=gUwXwzNz68mEq61ULDU1yiKeVMFIQu5DSmexkMW67RNS9I1KqoBpp3S6f2OTuP2xgb
         ocGlfhzYm3SjU8lBY2YAfBvgIKtcXyDoRA2FIwi5bfG/mxwnAKTRTTA6wQMM9hizn7+6
         zdtHaG38gPiucdGfKurQREjlQMpqT7m88PVhdLl56aPH2B2uqWuGcK7Ool2g1L559vzD
         2SQCefxm4mXd7c2WDeYgwHRrc31tYVYHE6CV1fkdVUo8iLLNzu10IktDburDDEbXuAoZ
         AhbwFUn0u7vKXneRLO4TFuiS0/9HZNJ33V0UG+FP62wYSUNGnoXu01bOa4jjnGmme1Hg
         xNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uM6sitv4Wx3WJxIss+uSEKXq3x9jp0ibwC827sLuE1Q=;
        b=ZKMDVvorC+WwRZFdb3hybGY/T1zEEHVT9QAZolq0hEko6nPBfa4r8OFcmFuswj6zHU
         qxR5px5bOmKcxCJPYPSU5OO4HupqhZWTmY0ndUInoL7QqPOCB/rOiV9HG3QL0esT4Arr
         wd88zEPc5fEVpAntvyOZdnyJJSXMGcnA2WHf3qPJFauLG6MCaYH+wHkLbcOYTZIxZHQ+
         GNryfVDTxb0R7lPdPexg4kEUgysN2buIxy16MSFxujPSudAsHaYwH7JS4XvdycWczbFi
         CljppRn6kKw1CZq8yUsZ+LVjlQPAvEuRBw+TDqgXd1Iqzu+FakeSuJrtYmHl8R/ElyKP
         4POg==
X-Gm-Message-State: ACrzQf2g+UIzoOSxpxLFQ5D33HpnFatcvW6ERljZhF2DL//iIo1uDCKV
        vdWJR8gDfHxIquy+o/r55tg=
X-Google-Smtp-Source: AMsMyM57HgYcFOzPvC9Th8hHz4T448nngTbHk4jwandvK/k+pzVsM4iPAkT1c6e/Y8TA2a2VP/4iHg==
X-Received: by 2002:a17:90a:9a8f:b0:212:ea8d:dc34 with SMTP id e15-20020a17090a9a8f00b00212ea8ddc34mr82160774pjp.30.1667999824813;
        Wed, 09 Nov 2022 05:17:04 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f60:98::16:12e])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902d49100b001754cfb5e21sm9103947plg.96.2022.11.09.05.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 05:17:04 -0800 (PST)
Message-ID: <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
Date:   Wed, 9 Nov 2022 22:16:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 1/4] crypto: aria: add keystream array into struct
 aria_ctx
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-2-ap420073@gmail.com>
 <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 11/7/22 17:48, Herbert Xu wrote:
 > On Sun, Nov 06, 2022 at 02:36:24PM +0000, Taehee Yoo wrote:
 >>
 >>   struct aria_ctx {
 >>   	u32 enc_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 >>   	u32 dec_key[ARIA_MAX_RD_KEYS][ARIA_RD_KEY_WORDS];
 >>   	int rounds;
 >>   	int key_length;
 >> +#if defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) ||	\
 >> +	defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64_MODULE)
 >> +	u8 keystream[ARIA_KEYSTREAM_SIZE];
 >> +#endif
 >>   };
 >
 > The tfm ctx is shared between all users of the tfm.  You need
 > something that is private to the request so this needs to be
 > moved into the reqctx.
 >
 > Cheers,

I have encountered kernel panic(stack-out-of-bounds) while using the 
reqctx instead of the tfm.

cryptd is used when simd drivers are used.
cryptd_skcipher_encrypt() internally doesn't allocate a request ctx of a 
child, instead, it uses stack memory with SYNC_SKCIPHER_REQUEST_ON_STACK.
It retains only 384 bytes for child request ctx even if a child set a 
large reqsize value with crypto_skcipher_set_reqsize().
aria-avx2 needs 512 bytes and aria-avx512 needs 1024 bytes.
So, stack-out-of-bounds occurs.

What do you think about using the per-cpu for the keystream array?
SIMD functions are called under fpu context.
So, per-cpu keystream will not be used concurrently, it's safe.
It also can avoid unnecessary allocation for large temporary memory.

I tested the per-cpu for keystream, and it works well.
If you are okay, I would like to submit v4 patch using per-cpu.

Thanks,
Taehee Yoo

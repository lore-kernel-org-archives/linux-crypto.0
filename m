Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27CEC4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 11:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKGLkF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 06:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiKGLkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 06:40:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6478317073
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 03:40:03 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so10030270pjk.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Nov 2022 03:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2w2norf17FHwkqF7uqmpvKvXIkvCoKcqrRCYZXHr4d4=;
        b=O4EfGTzX7ut98ALxy/2jm29ZGFMdN3GIpwvfKU/SUAK7Iw/evSI9Rd56ZuCe6D9RE/
         /wsrGMAodIwmqqMs/HUDmtjtXwizFv5aGexNBgDbFpFlCVlrGt8KiLSzSiguuec/dtzk
         hhYAtXftMWt2fnOfJAIc00yoMqI4roX4k+zto5yRdXnDcp/V3h+J+uyuWUUxO77NIwAG
         ADpqhFg3WIOZWkU4sYnfWYV0D2tcI6JYmH+B+CQPBVb5JS1HMdQVmkFXKC5FSYnHdfhX
         jmntC/fAtLDmYcIDmZ2USDW+5As2ujUhSosa48fn3Nt/AZyzAfImcYA7Q/GKqgWi7EnD
         IyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2w2norf17FHwkqF7uqmpvKvXIkvCoKcqrRCYZXHr4d4=;
        b=SiNEiLc8bURdALJ0L8+3ubAjeMP2rWq/3g3dyns0XuC0raEanhQ0oJE8TyEVOZ3G6n
         OoBS3m7pqANBsfWOZ9DzeKx5wcb/HN93TfD5RxojpCwNaS0tKg2NdH5ikwI0/ydqujXk
         l4dTXneEQg1yOe2tDddq7Z+Sr3pfKLOqW45XqlLeGZKiWYV3emm9PTdj8mRvmJG0ga3m
         FBLYsaXqtgks62U+oCQf/jtx6v/FE2TapzUmzZoRqkVs9lxv4wPgZbgXtsOJepfn9cO2
         GBAOqGIGM6wyuwGfSLcH6KGi6Bn8APRpvjl+8asjrDnfpQHzZ6f/KC3y2Yv7+c4aXmkf
         JJRA==
X-Gm-Message-State: ACrzQf1xIBB4ddjbcadzi2j7UeIHnQpQ0XlAcJI0K0ajUI952QUNdvMq
        K4WhlAdFFw+LIN6CqxHnkGY=
X-Google-Smtp-Source: AMsMyM5ESu95zcXN7NtzS7uyXZbjoK4jjsBqcBVDJ+vEVQuwQ9aYvfWBHMDDezjvCniSWvV9HoTzUg==
X-Received: by 2002:a17:902:7294:b0:187:146c:316f with SMTP id d20-20020a170902729400b00187146c316fmr44440521pll.149.1667821202864;
        Mon, 07 Nov 2022 03:40:02 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f60:98::16:12e])
        by smtp.gmail.com with ESMTPSA id l5-20020a622505000000b0056be1581126sm4442633pfl.143.2022.11.07.03.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 03:40:02 -0800 (PST)
Message-ID: <99dcdd19-6954-d040-455b-c04f158d17c7@gmail.com>
Date:   Mon, 7 Nov 2022 20:39:56 +0900
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
Thank you so much for your review!

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

Sorry, I think I hadn't understood the point of your previous review 
correctly.
I will move keystream into reqctx instead of the tfm.

Thanks a lot!
Taehee Yoo

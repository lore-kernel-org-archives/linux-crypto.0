Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BF1C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 10:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiKRKqG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 05:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241812AbiKRKpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 05:45:45 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530959BA07
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 02:45:19 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id k15so4531120pfg.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 02:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bkRROqYBHfdXHhbIQX0z29ugEbUbH1hutwc3+eDOaA4=;
        b=Fe+KHbsdlUB88GM1O9rdOu3VEVh6cyiH09LhRZN1pEFqXzBiwxeJNEGddoCzfdLgxO
         od5ZW9EKsAXS5vDIx1nBO4FSCMlYsXbvfAcTwMm7HWsKXvnYZIjpP8UHFm4wY6eLEmDJ
         ug4ulN7+tcPZNMLZi2LxHjuwxOllw59dXnwxw4+67NYs7aRNlW5Wm6EElTCDJwCYkPB2
         pjQPZXv9JbCIMUBACsOubHfSLutGBo93xD7LgRqngFClyT7GHH5HOc+I5hXJriTyeoZ/
         9izUW9pYfXIQIcoBjMYAzZBI7Em7QYruixR+77SYskgC0sQ1PAoiZOge6cr804wmbdsP
         PfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkRROqYBHfdXHhbIQX0z29ugEbUbH1hutwc3+eDOaA4=;
        b=QZwipcZBfFA0PwnoieizUK5BsheUQk4K9tkepUigU4m0Veet5hRackEPxqKtjQ0m8S
         MRMjQxZOWeN0k50PnC8RJ+2o3gbz+iJjtfzOdXwcCNkUAuHRynRnbwaxhg3LZ3i250ev
         L6uyk6+2qrYcxEDCNP8apVRCPT5p0EmuXp1rquJdKOVkOmXrCbZJg6WyRgjSKby+z/bP
         qSUyC8h1wLXsXijvajVRZJZg1Ir4Zdrx0eQrjKdd+7xNwcat9/hh4gVc2m3nPf/zNg2d
         vUv02XxGOVVe6CXNyT/KlClwZZuIUihCizkeSRYIuUwchjArczL30x+XKJXE1b5memmZ
         Uhug==
X-Gm-Message-State: ANoB5plwEoli4y4QMdLywazxFXpbXDom2xeSbZ/QDVioG9NowYNfjlf+
        ziq37auBTLfXJLp44h0qsvM=
X-Google-Smtp-Source: AA0mqf4WL/qx3kpl74YRFv5XYYtH7mjP//dyEQJfX0H6xGSotkRgsZgnY26jmfkS7YD9+qjGaITIZg==
X-Received: by 2002:a62:5e41:0:b0:56b:db09:a235 with SMTP id s62-20020a625e41000000b0056bdb09a235mr7199154pfb.20.1668768319277;
        Fri, 18 Nov 2022 02:45:19 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f40:98::16:12e])
        by smtp.gmail.com with ESMTPSA id z24-20020a62d118000000b0056cd54ac8a0sm2773256pfg.197.2022.11.18.02.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 02:45:18 -0800 (PST)
Message-ID: <07f353fd-1f36-2f58-63da-b15d3473ab40@gmail.com>
Date:   Fri, 18 Nov 2022 19:45:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 3/4] crypto: aria: implement aria-avx2
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
References: <20221118072252.10770-1-ap420073@gmail.com>
 <20221118072252.10770-4-ap420073@gmail.com>
 <Y3dK9hHXZSgpVdV1@sol.localdomain>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y3dK9hHXZSgpVdV1@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,
Thank you so much for your review!

On 11/18/22 18:05, Eric Biggers wrote:
 > On Fri, Nov 18, 2022 at 07:22:51AM +0000, Taehee Yoo wrote:
 >> +SYM_FUNC_START(aria_aesni_avx2_encrypt_32way)
 >
 > Please use SYM_TYPED_FUNC_START (and include <linux/cfi_types.h>) for all
 > assembly functions that are called via indirect function calls. 
Otherwise the
 > code will crash when built with CONFIG_CFI_CLANG=y.
 >
 > - Eric

Okay, I will use SYM_TYPED_FUNC_START for avx2 and avx512 in the v6 
patchset.

Thanks a lot!
Taehee Yoo

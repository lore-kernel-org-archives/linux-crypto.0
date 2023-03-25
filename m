Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DF9C6FD1C
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 11:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCYLBw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 07:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCYLBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 07:01:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A13F956
        for <linux-crypto@vger.kernel.org>; Sat, 25 Mar 2023 04:01:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b20so17396132edd.1
        for <linux-crypto@vger.kernel.org>; Sat, 25 Mar 2023 04:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679742109;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zafUbUEAV6rjedbLPFbfMgyY+HDLY0SQ0UIeszhwa4Y=;
        b=luQ+jJETbggWlEZ4mKxSwssRXNVCRBhmGBdRXYfwA8AVwFvxv/0GHEQlxcSYJMCnhK
         lnlzGrQrkBIDr69Ea1z3xGRAq6SKGFTe/kJIpzkeDBfzoOwGd2P5TfM8rNAsZkTxilKw
         Ml3E1+Io9DrIPJ8K5EOhA5NEohODS5gxhgssK1CuUFQxv6NREZYdcpHsnGkD4OlHHF/c
         lTch3pnAcVH1PPQ0WPSnBUZwvdsohMUk7HUFW5zINr25Bd7wxgchnyStHWgBt55HwjmW
         nPzWt37I7CAvsKOsslrq91E8tF0cKPvgak3lzIhjGP+uSyGyqeERnK71ShTfZg3ZwZda
         EBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679742109;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zafUbUEAV6rjedbLPFbfMgyY+HDLY0SQ0UIeszhwa4Y=;
        b=nT8dK1iHnlseJkkg8Z5LPhasRTXjKfx0T/04xXM9Ft6GWeVbmM5fDyBtYR030HvsO8
         /T66lY+4HZJq8GXOe5sLCb+gW4YI963QtYjA2GJnYi5EB3FBdnMTbKO2qr35+QSui+Be
         h3oTkQR2hpGijbmn2FxbZXOKG/rIx4ERe/03qJRRYFifhjIG5hb8E6QgE4TUbbA2Y2PB
         vIFh1nBe/YkQA1l6QqKq8hMud1Rktw4fUYpbCdCzviih2DMDPRGiwBjGHGYk4dyQow4Q
         /awRaPzyVSRgZ0cXd5hve+G8p1Vhag1JEf0Q2O0yi5CNEi73z/Cmablshj2Rs1ol2/Mt
         Y66A==
X-Gm-Message-State: AAQBX9ehERFbtqPPN/1ZLTJIw88Y0OO8s9F5okP6MoR8+B2mj0QwekL1
        h1TnRZ0TCANomJ9ccRwX+B8zkg==
X-Google-Smtp-Source: AKy350bzYt5sqH0jJm2NqtOhFix6zch6UBRqw1JweY5kSlupQfB/ZdKaWtQxICM37T2obD95X71I8Q==
X-Received: by 2002:a17:906:25d5:b0:932:40f4:5c44 with SMTP id n21-20020a17090625d500b0093240f45c44mr5703891ejb.36.1679742108965;
        Sat, 25 Mar 2023 04:01:48 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:d230:b2c7:d55:c9c8? ([2a02:810d:15c0:828:d230:b2c7:d55:c9c8])
        by smtp.gmail.com with ESMTPSA id r5-20020a1709064d0500b00923f05b2931sm11560427eju.118.2023.03.25.04.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 04:01:48 -0700 (PDT)
Message-ID: <03009090-e1e9-a176-c629-dee99993e9ad@linaro.org>
Date:   Sat, 25 Mar 2023 12:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] crypto - img-hash: Depend on OF and silence compile
 test warning
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
References: <20230319144439.31399-1-krzysztof.kozlowski@linaro.org>
 <ZB14gXqnkBzhdm0i@gondor.apana.org.au>
 <2dd13286-c518-66a7-44f4-b6c4f8acd061@linaro.org>
 <ZB6NxI9/llX7oFdg@gondor.apana.org.au>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZB6NxI9/llX7oFdg@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 25/03/2023 06:59, Herbert Xu wrote:
> On Fri, Mar 24, 2023 at 11:51:43AM +0100, Krzysztof Kozlowski wrote:
>>
>>> You should either add a dependency on OF or __maybe_unused.
>>> Adding both makes no sense.
>>
>> Of course it makes, otherwise you have warnings which is also fixed here.
> 
> It won't create a warning if you depend on OF without COMPILE_TEST.

In that case yes, but we want COMPILE_TEST for build coverage.

> 
> Anyway, I think adding __maybe_unused by itself is sufficient.



Best regards,
Krzysztof


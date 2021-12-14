Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B0DC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Dec 2021 18:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhLNSIA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbhLNSHt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Dec 2021 13:07:49 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A28C061401
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 10:07:48 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t9so33839113wrx.7
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 10:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CM0HVogYaJVZzHpRVCw/2RBWy4bVcT+mBNwkxlDdKi8=;
        b=N/eKZPDuHIP6Ojar14h/H2M7TZIjocqFdT3H1lnIgR1BAowh8HDx6JEyd6uUmii9rA
         xjq5NmWo9fxHlhObOQtta1/YTP0XZvIBcvBHthO8/xyGKmSDCamLnLSYgglWT4Yg79Zp
         qE3eOixe7ULiqfnJ5mZENHuqjo8Hq/z6eLAteS+MUnAR1QKAT/F3TmgUc0B42VTDCq9S
         5L4PtS/5xaWj5isxvcmvYoaUq5/9Q0eY1b3h7EE5PbZHvv2eOKn5rAO1AICs7B9VqtJl
         YVaxLKfQa+e03L/MaLWO5o2pok2ZAwsq968tncmX31GuSrkJqzmrDn+A8P8Fn08u/o9n
         1smA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CM0HVogYaJVZzHpRVCw/2RBWy4bVcT+mBNwkxlDdKi8=;
        b=TziUV8kZQXT4os8yfCUwiVT2d7q0yDGpvUCYDv8KzHxoYVMxwW63eZoX90SkFN5Cof
         Bpdef3F82qPv+nvDK9t0f9V+ivvYRjOa5Apm3FcGUCDDbXpgXyCQU1FmVvsvc1tGa76F
         NT7K66+kMD4THN3NsQtRJack5WfZaEjqOFzL2f3lHJaqpypiDQIISZ0Lro/xy+1qfxIe
         8AlGTotHS9EwoocdiUlAl0dMrLO/l8G19b7UAf2wCSx4+8QQbrdeYwH4XSICk8gdOcPD
         CiRV5XXcCFRTsV1pd9gDiQDNmUvh4gGw2zfzRHbCvd5UBESoEJ+6Pkx71yJILhUcSqN3
         obcw==
X-Gm-Message-State: AOAM533j6AxchflwpX9hsoffFcaeKgMQTwbu9IDLQ3YqsXqn+kppXCba
        GoalLLU8TTgwfrEAtNF7n6N9Xg==
X-Google-Smtp-Source: ABdhPJwSGDpM/R/nKjlG6LIdQXpGso1DZTKoGnbLxAFa3z8fqYmW8BC2LuMms+9i3aIvCasHfE8tyA==
X-Received: by 2002:adf:cd85:: with SMTP id q5mr663903wrj.80.1639505267438;
        Tue, 14 Dec 2021 10:07:47 -0800 (PST)
Received: from [192.168.24.132] (pd9fe987f.dip0.t-ipconnect.de. [217.254.152.127])
        by smtp.gmail.com with ESMTPSA id bg34sm3124807wmb.47.2021.12.14.10.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 10:07:47 -0800 (PST)
Subject: Re: [PATCH] crypto: x86/curve25519 - use in/out register constraints
 more precisely
To:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymeric Fromherz <aymeric.fromherz@inria.fr>
References: <20211214160146.1073616-1-Jason@zx2c4.com>
 <CAMj1kXEuzHWKDtOX2nCHABWZKQ2K_QV4eJ3cF9zg4KM-6aOTuw@mail.gmail.com>
From:   Mathias Krause <minipli@grsecurity.net>
Message-ID: <c78ec947-c780-5058-53ff-94437b0599a7@grsecurity.net>
Date:   Tue, 14 Dec 2021 19:07:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXEuzHWKDtOX2nCHABWZKQ2K_QV4eJ3cF9zg4KM-6aOTuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 14.12.21 um 18:23 schrieb Ard Biesheuvel:
> On Tue, 14 Dec 2021 at 17:02, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>
>> Rather than passing all variables as modified, pass ones that are only
>> read into that parameter. This helps with old gcc versions when
>> alternatives are additionally used, and lets gcc's codegen be a little
>> bit more efficient. This also syncs up with the latest Vale/EverCrypt
>> output.
>>
>> Reported-by: Mathias Krause <minipli@grsecurity.net>
>> Cc: Aymeric Fromherz <aymeric.fromherz@inria.fr>
>> Link: https://lore.kernel.org/wireguard/1554725710.1290070.1639240504281.JavaMail.zimbra@inria.fr/
>> Link: https://github.com/project-everest/hacl-star/pull/501
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> Could we separate the whitespace-only changes from the code changes
> please? Otherwise, this is really hard to review.
> 

Applying the patch and using `git show --color-words -w` helped me to
lower the noise ratio to a sensible level.

Mathias

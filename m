Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610F0C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Feb 2022 16:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiBLQCg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:02:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiBLQCf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Feb 2022 11:02:35 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E11B9
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 08:02:31 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D04BC4004A
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644681748;
        bh=l/sqa866xdKsWTgSNCB9rWLOZm4vGLLE7QTLVaTsoZU=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=MmzNqnxdVutX6P/RxFdKqJ58ChjAJ6+R53XtlqgVQT4xDp5tb2KF7BtYwAWsBthrH
         JbU/5IcYHexLSqqC9V3aGWRbDhK02RUxB6XA5ay09uXV4cDuj+orVtnXv661oTg49L
         kzmFY1qpjUV8TGqiIEX/fAfnpFRY+calvC9v0wBBcmvrhFvi4q/MOmLrb0EVIPBdOK
         vQ5MJZ7iRyX7Uwxpy9Z9skJtCDKCBODg026tPrvZK8YTP0G/M7GgwFKOBP/zhTylgv
         OyxMPzkGcEI7rXfeZWIq5e+6kbwzxMw3qOpT6gWg/VjLd9XASD/Gcd/VXYUNFFg+iN
         FoPovc0JBKhQg==
Received: by mail-ed1-f70.google.com with SMTP id dn20-20020a05640222f400b0040f8cdfb542so7248826edb.3
        for <linux-crypto@vger.kernel.org>; Sat, 12 Feb 2022 08:02:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l/sqa866xdKsWTgSNCB9rWLOZm4vGLLE7QTLVaTsoZU=;
        b=hYQ4UlEFGFurvgbi/vv78aLgqEFgLLMgR+DjZR1Qx28w7mrIKBlIqn8INH7F3a97uE
         cY2BcE1msxYESsKkMiZrSSe51FqKXWgaJKITTf6j45V6AdDLdB596N4+2vo9svWKSecF
         FDzo2gCatgQT5uP1sDbs7JVNMqnUWecc4nMNtyl6IJSvjDn3qpZ8p9p8TmYeWlKwgGMS
         29AzyRXoxvhQ2QmyXWTRX6em29HTCBYuOqWWHvbk190dGahlOyligxs3f0naKYOoL4yx
         uugVpNLhVpP60QtohMcvAY/d8x1NH42KNNAfQ+Q5IKpVoyEtyYdcLhEoTwtFe7dO6mus
         viIg==
X-Gm-Message-State: AOAM530YqvjKihkJPFYvuszHftb0D3Fm5Mp7+EJW6zidb9IznSgGLfWy
        NUHzsr+M712Cyf2FX/M5R7Aj7d8o17JBEwFJkeo2Uo39awOxOENaN0zpeIzTpFX/MLXLbUAtc9z
        L0qaYjLpWuq7qKTUT2c5jcPT6ZNCq4kTB455JLH2Cgw==
X-Received: by 2002:a05:6402:50cf:: with SMTP id h15mr7182464edb.102.1644681748426;
        Sat, 12 Feb 2022 08:02:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCqbWilwt1HbUpSsc2cvzvmt39AYbiXm7khxjJiFy20aciawo2HRz4CMjXWjBdjSCj4Q/WLQ==
X-Received: by 2002:a05:6402:50cf:: with SMTP id h15mr7182452edb.102.1644681748216;
        Sat, 12 Feb 2022 08:02:28 -0800 (PST)
Received: from [192.168.0.101] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id b14sm5098399ejb.160.2022.02.12.08.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Feb 2022 08:02:27 -0800 (PST)
Message-ID: <78327112-a979-fdc8-50a6-35738c9017a7@canonical.com>
Date:   Sat, 12 Feb 2022 17:02:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] dt-bindings: crypto: convert rockchip-crypto to yaml
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
References: <20220211115925.3382735-1-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220211115925.3382735-1-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/02/2022 12:59, Corentin Labbe wrote:
> Convert rockchip-crypto to yaml
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Changes since v1:
> - fixed example
> - renamed to a new name
> - fixed some maxItems
> 
> Change since v2:
> - Fixed maintainers section
> 
>  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
>  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
>  2 files changed, 66 insertions(+), 28 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof

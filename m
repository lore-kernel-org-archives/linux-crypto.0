Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C6DC6FD1D
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Mar 2023 07:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjC3Hbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Mar 2023 03:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjC3HbX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2023 03:31:23 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B915F6E93
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2023 00:31:21 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u1so10263301wmn.5
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2023 00:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680161480;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gv8JVciuDxQ0wesT323VY8sddT9TR9dSupeai1kGABw=;
        b=zSozlUjEPWi4/jPhKpPD0C6ryndKS450YaiCkk5K6zfzdIkAgtnLWUJuqip8reAA+G
         m8KkCUhyj8NceK3K4vNBbB3vCjptyYz0hDyaYEQk/BGeBbu9xzDi3teEqOZLy2Os7Gtk
         0DJcwLVFAacIyewhxbY2yA6qQ7BpDyJFnav0KjjJYRDzBOyynQV4MZO8ndEnlquJQtmp
         uqab2pc6lcF0XsEH7nwODf8J2bSQnKOyKpECAkVtxh3eArxE9o9iXaeK1CzBkDLakEzV
         u3dkqQKfLey/rKeaXjTYhziIsNYZ//fq7v7pSZN1tfvFHNbqcgU06PUaSU7olCpsiWfD
         u1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680161480;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gv8JVciuDxQ0wesT323VY8sddT9TR9dSupeai1kGABw=;
        b=F0Z9n5EuyP5tRr2V9g5sHMCcVj1pWshQIKBypIEap1QaH54nCwRbZQhfIaVGyS+bdK
         BIIkoENPdRecWh7rzxcA8i6gozj00WnNCpIaqkzKarUNiT7nU5rrJPMcJWA7KgPDemcI
         aiexKPiKLOgYIsdoFd3yi4FBR+kvUFtcSi3r/oybPTsw9/6TdtV7fIO1c5ZrSlgPDjjf
         5Vf4IvJxnGMAcdxP0q3w7jvZZH7rMOWV+HlE3qRGHKxhgDnvQF10AhvebMBHujdbNdU7
         rhZRh3YyzrCCPF7u9yJa4iQ+64KJ/oTHytO/1GJPXtsqg08JU5BG0NPFCkHeTJkkswKp
         7icw==
X-Gm-Message-State: AO0yUKV3f4QcB1C4W/u5d/tmywFZ1pVBTzA83mVd63w0u+oeJjJnQXum
        9AUiy6gxi4ejdcxJxyC/YVsl+w==
X-Google-Smtp-Source: AK7set/8syKQO2oLKnczLLSt+e88iWzGJM51xpz2K8yppyOXjZwYcbmpU/VbsF2MocQQGOy4acHhtg==
X-Received: by 2002:a1c:7516:0:b0:3ef:3ce6:7c69 with SMTP id o22-20020a1c7516000000b003ef3ce67c69mr16845825wmc.8.1680161480232;
        Thu, 30 Mar 2023 00:31:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:fe8e:8291:fc25:6c8f? ([2a01:e0a:982:cbb0:fe8e:8291:fc25:6c8f])
        by smtp.gmail.com with ESMTPSA id l10-20020a1ced0a000000b003ee1acdb036sm4833807wmh.17.2023.03.30.00.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 00:31:19 -0700 (PDT)
Message-ID: <c63d6fb5-fcc4-3370-7b4b-f46846136d19@linaro.org>
Date:   Thu, 30 Mar 2023 09:31:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH] dt-bindings: rng: Drop unneeded quotes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <20230327170153.4105594-1-robh@kernel.org>
Organization: Linaro Developer Services
In-Reply-To: <20230327170153.4105594-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/03/2023 19:01, Rob Herring wrote:
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml | 4 ++--

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>

>   Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml | 4 ++--
>   Documentation/devicetree/bindings/rng/mtk-rng.yaml           | 4 ++--
>   Documentation/devicetree/bindings/rng/ti,keystone-rng.yaml   | 2 +-
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 

<snip>


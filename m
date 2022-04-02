Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF41AC433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 19:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbiDBT32 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 15:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiDBT31 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 15:29:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5836D3982C
        for <linux-crypto@vger.kernel.org>; Sat,  2 Apr 2022 12:27:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qh7so2320989ejb.11
        for <linux-crypto@vger.kernel.org>; Sat, 02 Apr 2022 12:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=B/ThbT3SvZKv7VBFEIOx/aCT3sIWnDNaa+6uy/zfsM4=;
        b=O+DYIcytzcGH8LsniuGvzc2VJVr6cymGR5ki+yc8dKSyiQa4ST2C04SjHaClrr/Dyd
         rPwx4rn/13xt6+XkEfBruUXf5yS5uchOzmxnzQrGFUOYeu0E2s6TrY6SfCCGq/hNNUxh
         OhW2kTsmvPedmVI5zSAuOSzL2jDrWYBQAWB+A7UVkHopWu11T8frRst1Z5gl5pFWhvXY
         FuD0hflgf/PZy17AgOobHb5lHfF+bAzZOUAqVVSanEgl3sIdfPM3i2kGw6Jad5DefrI0
         Dj3aMKYGslQqlRhZLALva5pqXuLeV29r4qobp7ruxuKfLTm6FB4CfR/GUhSuiqk/edBu
         +hYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B/ThbT3SvZKv7VBFEIOx/aCT3sIWnDNaa+6uy/zfsM4=;
        b=kVrRmmHZqnNZdtnII3VFsoAhTHs3SQxf00xJRzrtcJ2vG2jygCA9fHCct6suWXj8QM
         a4Fogj4eQQRPHfINBr7efl29XZlUlSAaQ5i4lQu98k9c8rdlxhhWkfGZInvDuVz/NRVz
         KY3g2nsta4quU/V8+wdzc0YWZJkZTxpudDPxXRIj1Vp/xlSMWrIA6SHxIfmTXjzPi7mc
         oFAHzDFRM7xfYmd1ENm8f2J2s1t3ZuTT6/DhGTYe1I8V5fOYb9Eljg1ROw5n2GHkiFd0
         gUDK5E2O6NC/I+0hkTnlpvMBIjD3LoFwL5BXfhyk1DnfuhHLl8cGkIqMwU+UAI/uKGke
         KVGg==
X-Gm-Message-State: AOAM530KpgaWMDBCKrrqR1un/xhR2gOYnjxbiENL4Q5JJjVsXw36Yk64
        H83rM1MulVs6410salJvTjCy9g==
X-Google-Smtp-Source: ABdhPJzd9yaY1T32nO+3zxYbCF1eHA+h4DL4En/lqWXtB9SjL9rtunjp4WJcpVorDE8q85caXJ35Ng==
X-Received: by 2002:a17:906:c107:b0:6df:c114:e286 with SMTP id do7-20020a170906c10700b006dfc114e286mr4846182ejc.216.1648927652962;
        Sat, 02 Apr 2022 12:27:32 -0700 (PDT)
Received: from [192.168.0.171] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id qp27-20020a170907207b00b006e66a4e924bsm972077ejb.201.2022.04.02.12.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 12:27:32 -0700 (PDT)
Message-ID: <bdd2e853-d056-2646-f9c7-f58321134d5d@linaro.org>
Date:   Sat, 2 Apr 2022 21:27:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dt-bindings: crypto: sun8i-ce: remove extra line
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        krzk+dt@kernel.org, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
References: <20220324144233.1119495-1-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220324144233.1119495-1-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24/03/2022 15:42, Corentin Labbe wrote:
> yamllint complains about this extra line.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Thanks for the patch. It's ok, but this should be rather done for all
files. Otherwise it's a churn.

I sent a global cleanup.

Best regards,
Krzysztof

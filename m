Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4C2C76195
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 06:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjC1GmM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 02:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1GmK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 02:42:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459D119A6
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 23:42:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so45355695edb.6
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 23:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679985728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=451j44+6MRrjjocPev25db4ORq+gaZ4ABjFTXWHPHzM=;
        b=Qe8/nJ97su7uPLmdIjcVPCheqGdN7PQfAi4CTS73IRaZ0u66bA0GBLRqfvZky48jcR
         DqvGguKXS5TUPzEmjpceIrMqMgqalZ45c3gG0ji4aYvZghRtrkiTDKHmt6Qwyzi6vRVt
         BHVbWc3BARQZM2ciJBh5+7S5w2Yf4/efHb/5Z9qjP87Hh5kiH/5Qz28Pcy661mzeaL2H
         LnH01tuYR8Lp6tcdJiyD+4SSXQveH6YTiZpmhCErptaMJeXmTVTM0LHwpwqjL/alt11G
         d5n2HW5FSRp+0RPS1a2oxGNS4skGS2ObBRIww+Ho96KRn+GOgiViEFtQbmlvmqY6BVkL
         wW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679985728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=451j44+6MRrjjocPev25db4ORq+gaZ4ABjFTXWHPHzM=;
        b=7TLEmFVLWBB+G/TIsqWvUxBwJzjo0YFo/9M/hBL/WAh63EdjEPQNt48xvCG5qWUELy
         mBNWttRxxjwdWgwnuR9Xqn1rT12z9jc4at0yJLxYpcRGsnuhMbhc+H54Rr0xzW6qFLnm
         WwEzWa21x1pAVZIBMHQx2HYbGKdmQDlu7DsuW8DT9KEfLd90OuNGROq9OfmX/jiUVCiC
         qko6zYWPZ4majIXlKSvJ5cJRGZg1PR6YgaKoPMHVG9xk7/TDg5dhJqmgN35VBy9Xj7qY
         tazWn6RumVRWy5j14K/y/zjAYVQsTuUIC2sMsSZOiXEysPNg3JgU2kr4hKSj+5vQ01T6
         3hkA==
X-Gm-Message-State: AAQBX9fpFvW95KlVr1tYfywEfbLOa+2P43GYNZbGdLgA/bKEKCmdj/vU
        iBp+st0/kVbNVN4SbN2WdEcksQ==
X-Google-Smtp-Source: AKy350bPobP7mxNYomM7mTnUP+KR0VKgYBLm04hWoARq4akmXfxUlUHc7yIwq5WmnLYkEcUIdmxlTg==
X-Received: by 2002:aa7:c90d:0:b0:4fd:1ff0:2291 with SMTP id b13-20020aa7c90d000000b004fd1ff02291mr13811380edt.18.1679985727914;
        Mon, 27 Mar 2023 23:42:07 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9e92:dca6:241d:71b6? ([2a02:810d:15c0:828:9e92:dca6:241d:71b6])
        by smtp.gmail.com with ESMTPSA id s30-20020a50ab1e000000b004c5d1a15bd5sm15403339edc.69.2023.03.27.23.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 23:42:07 -0700 (PDT)
Message-ID: <acb67dc8-0186-695b-5986-6f1d91a0108c@linaro.org>
Date:   Tue, 28 Mar 2023 08:42:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] dt-bindings: rng: Drop unneeded quotes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230327170153.4105594-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
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


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


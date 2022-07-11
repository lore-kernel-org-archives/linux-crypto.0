Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAA7C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jul 2022 11:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiGKLaP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiGKL3h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jul 2022 07:29:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FB10A2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 04:11:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a9so8075314lfk.11
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 04:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RnEewUaxRYksbEJpKUrJ+8MTrfw80zwbt+04yRkIeOI=;
        b=Tai63LA9Z7OY2hr8ohiG7R5RP52XjdEe0kZjlHFzSD76t0YVAn4dMjXP97k6L+aXq9
         AKZFoUNDqtPZ6sL40IpHJ0AK0k/1ZhjWznZ8b+cYTfiMB1E+5ogbAs4teyu+pkz5Ktx8
         AWDeMaIhtOnpD6x9/C/HJ0PEqUcalB+xPJsBEFaTMRLHkjO3AGW4pVnjtwTPiTuItQgS
         j+UQoVtiYN+fCe8+CZE7XpmkijLS8tXhOzxXDAnqNsL5FK9MpPc6ACeD6lSUhyDo/7zC
         AQNK1iTdVyPx0cyp6nR0nTsCM3MUGhiJTr4JoRmTM/884OWawV0fHRF9NiKMgeb+k9Jq
         0d6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RnEewUaxRYksbEJpKUrJ+8MTrfw80zwbt+04yRkIeOI=;
        b=UZ6I8MXopIOoZ5haP0wjnUEA/zL1YCe3Pc3y7ndW2U+bNLvxmzmOcsNbLrPGkBsWwQ
         brKb/gC8COk423M4dTJOQfCRCLxZcw2S+CZD1mWrR4k00dV2xyBjsRi1fyutXWXKeDW1
         LS3PY86XY5LRTTliDPxZgYMCfSJaOml9uBmLMBTKrdqSYfjLOHGEl3hTZDSNlSXJDyTP
         b9ia5K/62zhtkC5udsvqvgyzJsrlTXO5piKyJiAI1q5wwrj+a0EDs8XopNk5HByXRmkE
         4YmRb6P4jFPEPryGdcr+kRnbwpk5ZuP+6RuqH0xFrplJk4EjmjuoDpDYn9QB+Y/47KA1
         qfwA==
X-Gm-Message-State: AJIora9FyQ1jUChWf8IJySh3syZfAkFNl57FJPNB5jWN6EHYioLd62gw
        vmko+WA61OG6dxvLHiStdcuSv/AkwAWNnJ9v
X-Google-Smtp-Source: AGRyM1vojcBdnwd/PHuInjbxCSSbuLABYZcGtOcCqkTMMNYAOtMUkfpuEnPNrUgh59axSJw/oAuqVQ==
X-Received: by 2002:a05:6512:b07:b0:489:da1c:901e with SMTP id w7-20020a0565120b0700b00489da1c901emr4161326lfu.528.1657537902852;
        Mon, 11 Jul 2022 04:11:42 -0700 (PDT)
Received: from [10.0.0.8] (fwa5cab-55.bb.online.no. [88.92.171.55])
        by smtp.gmail.com with ESMTPSA id q26-20020ac2515a000000b004797b92f4cdsm1484070lfd.91.2022.07.11.04.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 04:11:42 -0700 (PDT)
Message-ID: <2935fd8e-ceda-fec9-db47-65d3ec142e32@linaro.org>
Date:   Mon, 11 Jul 2022 13:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] dt-bindings: crypto: ti,sa2ul: drop dma-coherent property
Content-Language: en-US
To:     Jayesh Choudhary <j-choudhary@ti.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        j-keerthy@ti.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        vigneshr@ti.com
References: <20220707110756.16169-1-j-choudhary@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220707110756.16169-1-j-choudhary@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/07/2022 13:07, Jayesh Choudhary wrote:
> crypto driver itself is not dma-coherent. It is the dmaengine
> that moves data and the buffers are to be mapped to the
> dmaengine provider. So this property should be dropped.
> 
> Fixes: 2ce9a7299bf6 ('dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation')
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml        | 13 -------------


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof

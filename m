Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BD0C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 15:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbiDMPug (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiDMPuf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 11:50:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCC165838
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:48:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bv19so4823786ejb.6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZUrQrM6enlfgMn/MObow0T//8GW1/W7c2olNoWx1WQk=;
        b=cYfqlHMdFO+1nIfKsAz4h6xPJv2H4bDpx6SKU16eUaPGolydDIUZXiFqJ4uFG9fEUD
         s1JN7QgJc9x8Fpc+CnbHbMZIMTs/EX3jXd84yTJB8toixzJQjfY3p85nNPujj7eJkSqX
         XrZlSeOQ35HWKlgeAeLgV7AllKwssXdC2jakg6tq5XVK0AzKtQYDcbsfryjfx8L23lFw
         /Q2W/520v3rByUE6mufw/9151seYEOyIeY43Y4O2pzCDIOK9xCJwRBdEm/wJTlaRH5Xl
         3S19cbHHB7nfQBbD/iOs0Q0+qb8gInlWh0m5iIQIsGlplV1XiE9kyB7TSucWpNE9EKym
         AqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZUrQrM6enlfgMn/MObow0T//8GW1/W7c2olNoWx1WQk=;
        b=ktyaLfrULI9yiZ1w7TdustnylnQDc2T4JwWZ0UJbw4hB2UAXolEIPlt7S3EKbmkvpE
         cWvLIQrmrLZC0gVjUHK0aYAXKxwQTyJxNKng8cpWQnnr06mhoJjYSiQI/glSSvJlJsA4
         oiyq44BqwGCGMU2J98HqitQxoOzTIo8GbVmcWCzqmcln8ZcN2WNU/Ei8LmZtfGdx9dFF
         ZQrer3splw2Vf/spQ7vhNUAnoFoYzHxsao3czavwKEslpBUEiOhYc/uXWQfh6PUPPReZ
         qZ6Kas5kfb+cKLnEBe5WbZ+PLI7W0WiNf96j5bY3gUlaLOtJ7SclxJ6TG/L/ta1tD6JY
         0reQ==
X-Gm-Message-State: AOAM530bvCOkEB4Ofu/Gbi7q+z4FHEIyniFrdgrnsrTrL5Scxl6qtraf
        WkWPaBtPexI3xdDyNBHQEuggOQ==
X-Google-Smtp-Source: ABdhPJw7BMUh+VGZ5d6fOhsX9G0k6NTnqjs/n3rz6db8TkQALWGGalbmx8ZRBt7Za10zl8HCGtEraQ==
X-Received: by 2002:a17:907:724a:b0:6e8:4f12:b6fd with SMTP id ds10-20020a170907724a00b006e84f12b6fdmr23155552ejc.198.1649864892685;
        Wed, 13 Apr 2022 08:48:12 -0700 (PDT)
Received: from [192.168.0.205] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id r16-20020a056402019000b00418ed60c332sm1246147edv.65.2022.04.13.08.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 08:48:12 -0700 (PDT)
Message-ID: <8c1909da-8877-9bff-deed-c8f39037b3eb@linaro.org>
Date:   Wed, 13 Apr 2022 17:48:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ti,sa2ul: Add a new compatible
 for AM62
Content-Language: en-US
To:     Jayesh Choudhary <j-choudhary@ti.com>, linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
References: <20220412073016.6014-1-j-choudhary@ti.com>
 <20220412073016.6014-2-j-choudhary@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220412073016.6014-2-j-choudhary@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/04/2022 09:30, Jayesh Choudhary wrote:
> Add the AM62 version of sa3ul to the compatible list.
> 
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
>  Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof

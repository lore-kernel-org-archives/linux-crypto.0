Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E33AEB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jun 2023 06:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjFUGoS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jun 2023 02:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjFUGnu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2023 02:43:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4554519A2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:43:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-98802908fedso536526166b.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687329827; x=1689921827;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F0A4OfbxXz0NGj/tr2eOFVX7aKZ0BmIyiRE/0eK0Tsc=;
        b=A1A3VqqATsj9m91b8e6nszvWgrgzHYl5Dtbu9Bmigq/HCZV3BEKgWFbJ4LjLgiiiTO
         0bcN8ZlOv25gLfLK9c6IZ1jMf51Gq1n8Wqej0pwdjSTxQmspiz8jzidC/xD8kKm4Cc3U
         9PxnltFcq9eHMs0ziN35adhftX77fndHtKQWONC/ZSZ2C09cDahX0wikojZ6yS8T2tzC
         VodO25bJKgchu0vy1JNQygqXgwZm0o9WTUcA1Tcfko3Fx96aNfPLILfCr7NBOKH20CbD
         pxGXhWYe5bNmrJ+xOCBbjkGT5yqhHfKepdxKk/hXFP2Df5wP9wHZD4LN3NJDw5aRWXuf
         R4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687329827; x=1689921827;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F0A4OfbxXz0NGj/tr2eOFVX7aKZ0BmIyiRE/0eK0Tsc=;
        b=KWmxXBlEgeT7QO4LEEeu59AJ3BEglV/nhLGLmtMOA21mNYBojgnR1GdHQKKojDtLSu
         HMZ71T+XjUP5z1D4eJl578CbzRne1KEyVhuSCYkusmOiLgd4BjjLA4ZAdNxcT6v0N7qC
         RyBcb0gLz3vbdQXtBRlIkAVjPX1ZannkPMV0HqhBmCcijKhRiCs+LRPGEil3NG+hAXqZ
         pVT2H5H/8n3VmwCf/K7G73PfvfhFf8R3bPhjkHuOwpoVgF/GH/s+4W76bo9PD+Iw00u5
         HbnQelclemQYFX2vCxtFrkfqgPM1Kplvn3Px+ir6aXUKHCjj0KkoEMxWyb7ptIBpWCrx
         oseQ==
X-Gm-Message-State: AC+VfDxUNAmjJc2XKgyhtoXoCLJHIMWP9/hK62lN0nbW4YmYtzBL/E0A
        eJZb3d7l5m4VlTstGacjoLk3NA==
X-Google-Smtp-Source: ACHHUZ5NLJ7rt7MgGuAm518oncvlxewAqw47rJlEY3QWjb+vmV9EdHXHOO4uemy2tyvG7B+vutb7ag==
X-Received: by 2002:a17:907:1c07:b0:94f:956:b3f7 with SMTP id nc7-20020a1709071c0700b0094f0956b3f7mr15282239ejc.2.1687329826802;
        Tue, 20 Jun 2023 23:43:46 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id w17-20020a1709060a1100b0096f6a131b9fsm2536918ejf.23.2023.06.20.23.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 23:43:46 -0700 (PDT)
Message-ID: <f2546eb4-5b4f-3e77-a08c-941a323e7f73@linaro.org>
Date:   Wed, 21 Jun 2023 08:43:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] dt-bindings: crypto: intel,ixp4xx: drop unneeded
 quotes
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230621064242.9038-1-krzysztof.kozlowski@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230621064242.9038-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21/06/2023 08:42, Krzysztof Kozlowski wrote:
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> ---
> 
> Changes in v2:
> 1. Drop more quotes (also amlogic)

I need to update subject, so v3.

Best regards,
Krzysztof


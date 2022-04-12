Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3120CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Apr 2022 12:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353259AbiDLMkk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Apr 2022 08:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355883AbiDLMj2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Apr 2022 08:39:28 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA37F3B3C2
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 05:03:23 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id u15so18214997ejf.11
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 05:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P9Vlzh5r939TZHzBkHT3UQX7MKUcjJtbvYInSipTD1A=;
        b=Zi7n7mxortlyiL0ZebgNg1KMOxCTMkm+i8luXhBBfdbazgaO5ITHkwS2+aR/OMjLc8
         CaOS00+DjZz2LZn4A6KAuLLOLfHXR32t1tyGw/hPWfYGqBVdHoVMVEq5RRTIs2HE2kl7
         qAyt9Q8mHGgtEKNEH5MqnG9wKYqUVBQfsCve4YnKwIhTKaxdhyBHSQuCYQ97AFRD5qbw
         tZvSK2AJ37N5eNTCQQOUQCakyNAwr7S3/M5aWWMIBacW71lYe+Dj6fjQw4CPzXViFufy
         P2aV+QjH4gN+OUKKBUrTgRKTW+S3Nc/VpdIHeMnDuQyzBvrfJTSATpIH7lHLFjysNGF3
         n9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P9Vlzh5r939TZHzBkHT3UQX7MKUcjJtbvYInSipTD1A=;
        b=a6DUCZK56Sf9IyWUVQfERoHDE3GXthPgPpq/e1+AuiVADnngCQMZILBjgMxU38N+3f
         b04MmrBnbqivY7qnuEYE7qs9K1+LqcZjtESbEOKscaKlPWmeVaBxHn2djsZDbxkJwJDo
         kOOVGnvTKiWRb0ABVk/mWlJnZP75rTXuYs/ZQB8WR8D5TU9IPQ0CciZpfKNXUu+kTymc
         YeUrF7Sj6eu4cqdShPkJO6zFybQOI1EoAvMruebDTAbutdknXMU8Fq1rudL6iNhSnnZN
         RZC3xwnvUpwFzD/u6lY9J5b8IhJms59pImDdTrqqpQXnar7EQghK5VNW0IEXGAOEcHA6
         DwVg==
X-Gm-Message-State: AOAM531owbwZYvKg3VJk2/5aYlEELdVEr4Xpv/nQlMeU0E9pvAvSL4yR
        yQBgli/btlES5xPCVN3Xeq1OmQ==
X-Google-Smtp-Source: ABdhPJx6IBrqF+ExbI0R/I+qcJ+Gg7ztEoc2OuK961yTNxuYB01w3+TeUXFoQjHQaCY2aVfG07kRbw==
X-Received: by 2002:a17:907:9482:b0:6da:a24e:e767 with SMTP id dm2-20020a170907948200b006daa24ee767mr34671029ejc.479.1649765002200;
        Tue, 12 Apr 2022 05:03:22 -0700 (PDT)
Received: from [192.168.0.195] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id o5-20020a50c905000000b0041d828d0c58sm2656513edh.53.2022.04.12.05.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 05:03:21 -0700 (PDT)
Message-ID: <aeff85cb-45b2-c7d6-5ce8-edd6776fbfe4@linaro.org>
Date:   Tue, 12 Apr 2022 14:03:20 +0200
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
> diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> index a410d2cedde6..02f47c2e7998 100644
> --- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> @@ -15,6 +15,7 @@ properties:
>        - ti,j721e-sa2ul
>        - ti,am654-sa2ul
>        - ti,am64-sa2ul
> +      - ti,am62-sa3ul
>  

Just to be sure - dma-coherent is not required for this device (see
final "if:" in the bindings)?

Best regards,
Krzysztof

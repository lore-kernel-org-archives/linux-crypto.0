Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315CBC001E0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 11:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbjG1Lwf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbjG1Lwf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 07:52:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F193ABA
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jul 2023 04:52:33 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-98e011f45ffso274667766b.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jul 2023 04:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690545152; x=1691149952;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iiua700OASvsqx+4N6h+76MQoIGha7eYc6GZhNCHoSg=;
        b=zP6ATR3sH7pclpk8xF0g/e7n9NSYW+DyV1gKVzZ2V3cTxBzlPpZRL8DQR/JRF0/lU1
         Niw9y4ADhCkzQqqQINcCHKXTmafHkV6sJcG5i8DdYVyjteUEIUjs4O2Dkv0QBvl3aa7h
         eCGei7kTQ9ri/Ip5bfqT9UWnpBRwZUP900ACSNTD9CoMORZF/GrF/Sn8eUr44L+Ij/xg
         3221NlFXn7HDv/N0CsTp4WrKj/LAWXh2QWfMd7U1dBl0yGHRA6iQAaOA1HyfR6QQRrRz
         +xkFQJK76bUPrQ3k2fRfckKQH44Rf4XGQoeUQ90bubiN+YxiUTQxZNDCrJ4EpBJWs2iv
         vF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690545152; x=1691149952;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iiua700OASvsqx+4N6h+76MQoIGha7eYc6GZhNCHoSg=;
        b=YHAqn174nJG45fCmTjAOlY7ML6LqLLjBXLP1P3fauoP5ISa6ZL+d8iYUXU4BfTnvLm
         9RxBMX4YAU2Ds93QPuIe9NekoBnKnicO615FZUJWC1cQpGpFQBifiVEef/yWOWFGYJ7r
         vpdQ2qtD3MG0YleHwR/8A4tVjEua1en9R1bQK74IlGuN+UQIbWMrkdyagp+MjPUfIBOM
         XL4Qh7tYgknQSvpbklWluSoJ1fDn0Qtn+Q67OGnehFUjbHJonkN7kr0jXXbcMA8aUsIn
         6yr43UVrNcUbyOWUlg2sH9Kw3XCBbEsQOlMxOPPk3epbRVjBlUm0uWJNJgFc6G3BadSA
         QRoA==
X-Gm-Message-State: ABy/qLZAtlnQXAcuA4xHqQm6X7LllBRahtJGjoQtV5aRVLwuU74SZJbX
        Z7z3CdMtwPSei1nkcYbNewQa8w==
X-Google-Smtp-Source: APBJJlHNFxtHHADT5A5mi91qIiLOJkthz65ykm4RsB2Iw1LptVsPGrHt6ovpSdG+WRxjW7mSwhw02g==
X-Received: by 2002:a17:907:781a:b0:993:ea6b:edf6 with SMTP id la26-20020a170907781a00b00993ea6bedf6mr1865674ejc.0.1690545152266;
        Fri, 28 Jul 2023 04:52:32 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.223.104])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709063e4700b0098d15d170a0sm1960002eji.202.2023.07.28.04.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 04:52:31 -0700 (PDT)
Message-ID: <234b1c9e-728b-3c24-a03d-c068a1d75b52@linaro.org>
Date:   Fri, 28 Jul 2023 13:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 22/50] dt-bindings: rng: atmel,at91-trng: add sam9x7
 TRNG
Content-Language: en-US
To:     Varshini Rajendran <varshini.rajendran@microchip.com>,
        olivia@selenic.com, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230728102701.266408-1-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230728102701.266408-1-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/07/2023 12:27, Varshini Rajendran wrote:
> Add compatbile for Microchip sam9x7 TRNG.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


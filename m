Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304F3C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jun 2022 11:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiF2LN6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jun 2022 07:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiF2LN5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jun 2022 07:13:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3902D3B29B
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 04:13:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id cw10so31889747ejb.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 04:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UhmgpOcezzyFajwTFaNzK7CkQEDuKl2reo2f9k791Ls=;
        b=EPawy1i0Li88//He37rCi9is/lItqMERZZbwYPZER6pZyrNX1juDwsn0d9v+DtYeJB
         LtMWBTswmNJ3hGiDDFMzXS1KU6olLcQLOpUJdrsDWRCDEZz2ai44lcCgMcxwhNcqfXBD
         90ebxDEMsWs87RNeelHOwJeNgXOK9+T6kKjAQallgo/4U5JIJgCSv+aaTHjivaYSlJ21
         jtGeq6KYeRslLak4eN/lP0CRGSwmjOUDi03hv3BGQ8+jx1GtZFKYpH+mAlDZUVF5NfSy
         tO55q9QZUUxLAxySfmJCB/L3U07Z/k3fByuK0Q/DHBH9J2Y5+1os8ojHMFa9kLtBNaQs
         ykpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UhmgpOcezzyFajwTFaNzK7CkQEDuKl2reo2f9k791Ls=;
        b=6//HWpgxNC89AU7XFYp/G8dwshETtnRoxRpoT5UJBAvZYJLtePkyYA0kP4HJ0eqvs1
         VNc1rgcwEpjHfY30vHZZV+zJGkIG9YnkJ80KytW6OrJPTaCA6Ij/FY8N50qmyPcGeKXQ
         YPE6D6wx0pnv+b18cH6z1mYAjWHIuqelp/19oMD3nda7xHtkoOgT7rc8pnb6M4OwvzEU
         WcuWjpCGvNxCOiEpdPMAjczeQopJcV/N1nxxz0HTOrLzBAnwQMQ7xYwtfz677VcOs/Kt
         mXPo+5CjRshNetu22mYYqZIZAC4BWRtSck8NQKjiC1egk1ZqPBe5zmE39ko3JplVmLQD
         rMkQ==
X-Gm-Message-State: AJIora/VlvI+c4tb0RobBhcLT/cqMzttqUNXnbKjOSJPPoHR+A4uXjd8
        ZG4aPMAKDkKX2LbHkOsnKeY3zA==
X-Google-Smtp-Source: AGRyM1unLZatMNde2GWDa2eWPWHi6q6KWw4D80BqHxdj1KohpSJH6cPJnOOKCZG5LBUtQr/6jbO1Qg==
X-Received: by 2002:a17:906:284c:b0:727:3773:1a53 with SMTP id s12-20020a170906284c00b0072737731a53mr2710286ejc.765.1656501234848;
        Wed, 29 Jun 2022 04:13:54 -0700 (PDT)
Received: from [192.168.0.184] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ov24-20020a170906fc1800b006f3ef214d9fsm7552947ejb.5.2022.06.29.04.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 04:13:54 -0700 (PDT)
Message-ID: <be1abd3a-5aa7-ec9c-5be7-e3c6bbd08979@linaro.org>
Date:   Wed, 29 Jun 2022 13:13:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 2/5] dt-bindings: clock: Add AST2500/AST2600 HACE reset
 definition
Content-Language: en-US
To:     Neal Liu <neal_liu@aspeedtech.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Dhananjay Phadke <dhphadke@microsoft.com>,
        Johnny Huang <johnny_huang@aspeedtech.com>
Cc:     linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, BMC-SW@aspeedtech.com
References: <20220629094426.1930589-1-neal_liu@aspeedtech.com>
 <20220629094426.1930589-3-neal_liu@aspeedtech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220629094426.1930589-3-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 29/06/2022 11:44, Neal Liu wrote:
> Add HACE reset bit definition for AST2500/AST2600.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> Signed-off-by: Johnny Huang <johnny_huang@aspeedtech.com>
> ---
>  include/dt-bindings/clock/aspeed-clock.h  | 1 +
>  include/dt-bindings/clock/ast2600-clock.h | 1 +
>  2 files changed, 2 insertions(+)


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92743C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jun 2022 05:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiF2F5p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jun 2022 01:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiF2F5p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jun 2022 01:57:45 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5B52982C
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 22:57:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id mf9so30453373ejb.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2022 22:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1WfdVfNcXkp3OxFuJuEQhMM39v5eC68bY2ADm6rLKI0=;
        b=JkUoMSVHOd8FXIU1nP7mHg39NA+HAkmXOBLZHIkIRWjuF2QXpez6vuJMIWGUWFHEby
         5o4bGCiXixkuKlUlu2olkq0QLN2UOIntPX6lG3+7PbXV+avqVfJ253cahNkw20GGXPeA
         MHvSKO3EVsTxg+HQtXEwBaZzsvry24d4BvkcEdAr5jVs9aGqW6Xuvyy663JNPBbkngxL
         ek6xf1/RqwKb2cDwtZy8lrOxsp43tHw2dRO21IpABqGEytjhcHxUraOi/YMWnoRgDrmq
         fIbCX7sv+Ga3+sPyzf/OYbX6uTY+nt3ooO/FRKAj9IUFTzcd83VY9OMyTF/rzwkUp2rw
         iYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1WfdVfNcXkp3OxFuJuEQhMM39v5eC68bY2ADm6rLKI0=;
        b=Wusz6TUAA8t1yY6G7HQD4Z2QrKOcejEAU/IP/3uNXZLVCkv6fAdgvvDkqMRyhqT+Ow
         bWRRGHGidV5QvI1D1Cpd5P4yV24/8NCOneaRrcHLZ5Vjipwz9vW31rphMGUqdJD33R/9
         Mso+WwCUQYaCdU4vsY34Ngvqcvq6GxSXR2sbgysNw8x8klK9dQwbQAWzgi7EiVxwnYJy
         P50QQY2psrS93AqhGWR3Gn4VvkdWWw9uAX++GpX+GRvGab1P38Gg5iYYQNfsAvaeIGPN
         aoGwb8mwnrWtHBObVfc//r8EZCOfY9qBB5LH/6CKSGFAKCi62rgp7Q/BiaLLfPlkNLjP
         xKhA==
X-Gm-Message-State: AJIora/V3Lhfjha2t/ZIlLZdMtzaOnwwwCwnv9/lj3dmKd/nN0ZIcEEV
        zN7r3p+ctg/VSr974gIQ5EOV6A==
X-Google-Smtp-Source: AGRyM1tKY3/ufkVIb0NqXcBrOPVDKBLhqSVvGuyqn+dsBxeoxntoXm1sQv41p5v8Kn71T36sBhLAmA==
X-Received: by 2002:a17:907:7213:b0:726:9f27:8fc8 with SMTP id dr19-20020a170907721300b007269f278fc8mr1551543ejc.523.1656482262769;
        Tue, 28 Jun 2022 22:57:42 -0700 (PDT)
Received: from [192.168.0.181] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7ce14000000b00435d4179bbdsm10892308edv.4.2022.06.28.22.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 22:57:42 -0700 (PDT)
Message-ID: <b70e06e7-81fc-dfc1-f9c5-f83cb4a18293@linaro.org>
Date:   Wed, 29 Jun 2022 07:57:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 2/5] dt-bindings: clock: Add AST2500/AST2600 HACE reset
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
References: <20220629032008.1579899-1-neal_liu@aspeedtech.com>
 <20220629032008.1579899-3-neal_liu@aspeedtech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220629032008.1579899-3-neal_liu@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 29/06/2022 05:20, Neal Liu wrote:
> Add HACE reset bit definition for AST2500/AST2600.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> Signed-off-by: Johnny Huang <johnny_huang@aspeedtech.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  include/dt-bindings/clock/aspeed-clock.h  | 3 ++-
>  include/dt-bindings/clock/ast2600-clock.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/dt-bindings/clock/aspeed-clock.h b/include/dt-bindings/clock/aspeed-clock.h
> index 9ff4f6e4558c..6e040f7c3426 100644
> --- a/include/dt-bindings/clock/aspeed-clock.h
> +++ b/include/dt-bindings/clock/aspeed-clock.h
> @@ -46,11 +46,12 @@
>  #define ASPEED_RESET_MCTP		1
>  #define ASPEED_RESET_ADC		2
>  #define ASPEED_RESET_JTAG_MASTER	3
> -#define ASPEED_RESET_MIC		4
> +#define ASPEED_RESET_HACE		4

I did not ack such change. This is a significant change from previous
version, invalidating my previous ack.

This breaks the ABI, so NAK without proper explanation why ABI break is
accepted.

>  #define ASPEED_RESET_PWM		5
>  #define ASPEED_RESET_PECI		6
>  #define ASPEED_RESET_I2C		7
>  #define ASPEED_RESET_AHB		8
>  #define ASPEED_RESET_CRT1		9
> +#define ASPEED_RESET_MIC		18
>  
>  #endif
> diff --git a/include/dt-bindings/clock/ast2600-clock.h b/include/dt-bindings/clock/ast2600-clock.h
> index 62b9520a00fd..d8b0db2f7a7d 100644
> --- a/include/dt-bindings/clock/ast2600-clock.h
> +++ b/include/dt-bindings/clock/ast2600-clock.h
> @@ -111,6 +111,7 @@
>  #define ASPEED_RESET_PCIE_RC_O		19
>  #define ASPEED_RESET_PCIE_RC_OEN	18
>  #define ASPEED_RESET_PCI_DP		5
> +#define ASPEED_RESET_HACE		4
>  #define ASPEED_RESET_AHB		1
>  #define ASPEED_RESET_SDRAM		0
>  


Best regards,
Krzysztof

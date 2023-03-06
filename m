Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D38CC61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 06:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCFGhN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjCFGhM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 01:37:12 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA30D10258
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 22:37:10 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i34so34052797eda.7
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 22:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678084629;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JLW5n6KP5UHwwR3q6dPX2A4J8itFuFD27FUFLYXk3JY=;
        b=OCIfPvVfZyRM/AXwVe1q78AjMlJKUa/oEAD9HXAM6TJYHwPkOF3A/zo9AE6fHLNONL
         OLmbWkdjdX1wOSwT+2ZVscRXuobWuWfc0SqQ8xnk1x9wQF168NfMTf5WI/A/YxjGKOmN
         9hkaAfX2gTPKi2vAdRRAz/CblMN6dPa1LCS39Xixy0GMg4LH1+a5KJTX5HxVLLMA5mt+
         SG16BafPCXS+ul5JvvQWPeCwOaXKqkvqs2UgqwpJnLaqKtn/9QpYjIQn9ybYX5F9k8Rr
         U3mdfOvLhjFxRidoczOv/hZOVqAuE7y0m3GRtvPAuYVSDMfFDFKPRgogQueHjBBKMgp/
         0UlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678084629;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLW5n6KP5UHwwR3q6dPX2A4J8itFuFD27FUFLYXk3JY=;
        b=lP7k0vEA61HKu3j2n2HRjzOJEe9kx93qVLxx5s4mMmDzGt4YVXXA7nYhJ+M790PkZj
         hQRAFcEwzB3NkUbRvghdBzL4tTiqkUOcRGZjdidufqzRNvrf+tSfV8qzsGQf7zS9I+Jq
         1ZXErQI8I/VUBE6t8U+pTEuWLODYE+VMtFHBTtvr9zAr1fiv6DZQ6eLtxLlt3022sZ3y
         Qrpi23l4QkhcbHBd1VYnWuLnHdooweKkCqIpK5bSU5P2JDmSVNezZqjdLJKAdXChwKTV
         UUXo670tbGBkfq3LCHMjuMGll30xQ/45sBqjLnHb4Ohukw5sQXH8pkRVaAc4bH3m6yLF
         OZ5Q==
X-Gm-Message-State: AO0yUKUlNsakMDuvv+qKkil+AtHdvyoW3nmz1lonZrbzwtcEfY2+pled
        PMJihcVqAOm/giUg/P3R/yKQjw==
X-Google-Smtp-Source: AK7set8t5htOvVKADDTiwNwukgvBhf31HJYw79AM+iFuDzP5ilbXj+ghKbJAhduVa63cIQL9AW5HVQ==
X-Received: by 2002:a17:907:8a10:b0:8f8:7a2b:cc0d with SMTP id sc16-20020a1709078a1000b008f87a2bcc0dmr13786314ejc.47.1678084629171;
        Sun, 05 Mar 2023 22:37:09 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:d85d:5a4b:9830:fcfe? ([2a02:810d:15c0:828:d85d:5a4b:9830:fcfe])
        by smtp.gmail.com with ESMTPSA id 27-20020a170906005b00b008b175c46867sm4102695ejg.116.2023.03.05.22.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 22:37:08 -0800 (PST)
Message-ID: <6abc7d3a-f95d-f6ea-a7b1-795e854b895e@linaro.org>
Date:   Mon, 6 Mar 2023 07:37:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/6] dt-bindings: imx-thermal: add imx6sll and imx6ul
 compatible
Content-Language: en-US
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Cc:     linux-imx@nxp.com, Marek Vasut <marex@denx.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230305225901.7119-1-stefan.wahren@i2se.com>
 <20230305225901.7119-3-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230305225901.7119-3-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/03/2023 23:58, Stefan Wahren wrote:
> Currently the dtbs_check for imx6 generates warnings like this:
> 
> ['fsl,imx6sll-tempmon', 'fsl,imx6sx-tempmon'] is too long
> 
> So add them to the devicetree binding.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  .../devicetree/bindings/thermal/imx-thermal.yaml    | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
> index b22c8b59d5c7..9a20c5d74617 100644
> --- a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
> +++ b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
> @@ -12,10 +12,15 @@ maintainers:
>  
>  properties:
>    compatible:
> -    enum:
> -      - fsl,imx6q-tempmon
> -      - fsl,imx6sx-tempmon
> -      - fsl,imx7d-tempmon
> +    oneOf:
> +      - const: fsl,imx6q-tempmon
> +      - const: fsl,imx6sx-tempmon

Keep the old three compatibles an enum.

> +      - items:
> +          - enum:
> +              - fsl,imx6sll-tempmon
> +              - fsl,imx6ul-tempmon
> +          - const: fsl,imx6sx-tempmon
> +      - const: fsl,imx7d-tempmon
>  
>    interrupts:
>      description: |

Best regards,
Krzysztof


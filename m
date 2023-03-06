Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A7FC6FD19
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 06:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCFGgf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFGge (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 01:36:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B891DBF3
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 22:36:33 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a25so34323354edb.0
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 22:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678084592;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tiatu8BflCMTPWpOTvwGq34iFc0RbmfIKdTTYpadMuw=;
        b=Jx+XD3Dy7pA2r/y34unPO6+Yl+MtMSk4bO8W04pJ2qHGdhjMgXxW+JDIC6Pp8GGl/y
         3dQ7TfVvLMQPR1n7wRdlhfDUUWRSsgzlIVmgrUInMM2wdPqxWUfq6HVD7jmOI9VmftfI
         rHxmSXg+G3f2Ymk9fyKR3prW3Gz9JzeDHS+IYN24dXuFrzkJaYjNirpjnrECx/IBQtdg
         5Ezh9nfeHLHSfp9wpylsM72RXMZnD2n4kXIkv9a1/IYxRHJ49XwviwDWidZRny7Fz2td
         un7xZE+C4nJZ9VSub79qwnAhr6sWZnAcQcqImVZMdl8NQKqr1VlEri0hkGjFLye+YuJU
         ZmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678084592;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tiatu8BflCMTPWpOTvwGq34iFc0RbmfIKdTTYpadMuw=;
        b=5/8+C5a4pPjPlkk53qOQoF6pwhHt3XL+g/kfBpvS7LoSm9WfYyLfFIk3izWbZrc3Bd
         yvEyXu5LHNLkNmbo+e7Liy1bWy9XOXMXCgi/C6l7foicCM7BzHjcbXP6GDERntlSi0Yt
         14y1i8eozMDzc0qZvwfy7eUC8sLOjETX8iCoZyTxzSZD8S+syBvJf1pEiGRjfq/BFNd/
         6Gg696GIzp2rti9MHTkZpxAv/wTSzEvgTWNduyzAxao3gXyj05Gx/CkEHQdt+evbq8gp
         89eZKmY3BXA17od5CpDhd/wHQrvpKH1pHb4DC4Gpq+0kxWyA5nyS0KWRjakDcPve71Ia
         iJ6w==
X-Gm-Message-State: AO0yUKWUBOOt2/W/0i/R+u7TTLqEfis0G0jsbtgcKuumyIj1NgwD/sgu
        c4nznpKY4MhwfpkYvMc3zOwdz9a4UznAuMAuKjw=
X-Google-Smtp-Source: AK7set+KvTLNJOsq+Ksb2yKc17YGC7Pxuj0GWXcvebF/KsJoXRhR1+1O+rn6v8qu56mm0bxIpJXYSA==
X-Received: by 2002:a17:907:d093:b0:8f7:60c8:269c with SMTP id vc19-20020a170907d09300b008f760c8269cmr10974615ejc.29.1678084591704;
        Sun, 05 Mar 2023 22:36:31 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:d85d:5a4b:9830:fcfe? ([2a02:810d:15c0:828:d85d:5a4b:9830:fcfe])
        by smtp.gmail.com with ESMTPSA id q18-20020a170906771200b008cc920469b5sm4191177ejm.18.2023.03.05.22.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 22:36:31 -0800 (PST)
Message-ID: <ee0bdc34-b2bf-b6db-b41c-a9529760a4b0@linaro.org>
Date:   Mon, 6 Mar 2023 07:36:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/6] dt-bindings: crypto: fsl-dcp: add imx6sl and imx6ull
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
 <20230305225901.7119-2-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230305225901.7119-2-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/03/2023 23:58, Stefan Wahren wrote:
> Currently the dtbs_check for imx6 generates warnings like this:
> 
> 'fsl,imx6sl-dcp' is not one of ['fsl,imx23-dcp', 'fsl,imx28-dcp']
> ['fsl,imx6sl-dcp', 'fsl,imx28-dcp'] is too long
> 
> or
> 
> 'fsl,imx6ull-dcp' is not one of ['fsl,imx23-dcp', 'fsl,imx28-dcp']
> ['fsl,imx6ull-dcp', 'fsl,imx28-dcp'] is too long
> 
> So add them to the devicetree binding.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  Documentation/devicetree/bindings/crypto/fsl-dcp.yaml | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
> index 99be01539fcd..1695c4c58dc8 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
> @@ -11,9 +11,14 @@ maintainers:
>  
>  properties:
>    compatible:
> -    enum:
> -      - fsl,imx23-dcp
> -      - fsl,imx28-dcp
> +    oneOf:
> +      - const: fsl,imx23-dcp
> +      - const: fsl,imx28-dcp

Keep these two as enum (so just indent under oneOf).

> +      - items:
> +          - enum:
> +              - fsl,imx6sl-dcp
> +              - fsl,imx6ull-dcp
> +          - const: fsl,imx28-dcp
>  
>    reg:
>      maxItems: 1

Best regards,
Krzysztof


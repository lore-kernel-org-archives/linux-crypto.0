Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8F3C678D4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 09:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCCJzb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCCJza (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 04:55:30 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803636687
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 01:55:26 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s11so7957920edy.8
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 01:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677837325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vcI9TwKeql7BEK1sJIRMqGKUdiKBhH06Xafoh6GvtOY=;
        b=nV3ygc6++KEALlPvrCi/LzP/zqVtODcKrm2ci3aPLG7xZhFB701k2yIDEhfjZcEhE4
         AAhPxw1QOuIa8o3cVU4jU1ajdZd7+9PPVYYH0fTK6WzPz8lWJfDfDgRrcMuAaIaJEoQI
         94+us00zm4xpazZjUaX/Y0Khzztzh2y/fduLKZPC6UW7GX19w451IqC451Ehw2lB/Wtd
         YKG9A+iY5IVJbrvt9r8pUsBd2eGVimX9PgEap/eYWqcoshRD7MlkLmQjg52ERd9lad9U
         A5tk/bN1PJ8TrSB2oZpiUCqN0h/UPbx64HQvV3myN+kSefGrJ2P+cMwB8NUagZ5YlmUe
         OFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677837325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcI9TwKeql7BEK1sJIRMqGKUdiKBhH06Xafoh6GvtOY=;
        b=Ksb0vzoupNn7dkOt5Gei08u12fryYq9j/qhqy+JbVFFeRKywbGIVJCiyLSaTbIl3m5
         MNrtlwQ0hJLJWWYY4Bdpg/iMiQbL5XUViTstMr/ErSZbjOGIpnNErEtaiSKbkljFWeer
         QBMQ84EWg1ck99Qh7Ov6cGVcCPDFEgXPstmgUftwkZbCExBASvQBEfWuTquEMMccshVC
         fFXjcc8t5gikC+4v9rwv4XsSowcVDWk8SY/LluphfQuEt2Juyjvv6xr+hacE0CYfAPas
         JKXC2fsho/NyMXkM+7gFskZxCQtVRVDh/f6D8WuuFTw4PQDsf2n8oVVJFvfD0K1ZKK9F
         S8rA==
X-Gm-Message-State: AO0yUKUijtSdzDqtYADG7WVPz7JDRpe8tKzacQM1yXl1M0nrWOhn9uXI
        vuJCUwbcJZTwOJ0QwxnqSLz7tQ==
X-Google-Smtp-Source: AK7set/ny4L1u0FncdnBsIrArL6/bdtnybsH8zYJlQ/du/6yDCErh0hTkh1Nsd2BHS3zVK4BhOKRpA==
X-Received: by 2002:aa7:d347:0:b0:4ae:e51e:9e3e with SMTP id m7-20020aa7d347000000b004aee51e9e3emr1147431edr.24.1677837325252;
        Fri, 03 Mar 2023 01:55:25 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id l3-20020aa7cac3000000b004af6f37d25bsm932016edt.76.2023.03.03.01.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:55:24 -0800 (PST)
Message-ID: <89cb8fb1-4e0f-4b5e-26ab-702c0fda8760@linaro.org>
Date:   Fri, 3 Mar 2023 10:55:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/9] dt-bindings: crypto: fsl-sec4: support sec5.4/0 and
 i.MX6UL
Content-Language: en-US
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, stefan@agner.ch,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
References: <20230301015702.3388458-1-peng.fan@oss.nxp.com>
 <20230301015702.3388458-4-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230301015702.3388458-4-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/03/2023 02:56, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add i.MX6UL, SEC 5.0 and SEC 5.4 support.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.yaml  | 58 ++++++++++++++++---
>  1 file changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml b/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml
> index 678c8389ef49..1b801ae5ab51 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml
> @@ -45,8 +45,18 @@ maintainers:
>  
>  properties:
>    compatible:
> -    enum:
> -      - fsl,sec-v4.0
> +    oneOf:
> +      - enum:
> +          - fsl,sec-v4.0
> +      - items:
> +          - enum:
> +              - fsl,imx6ul-caam
> +              - fsl,sec-v5.0
> +          - const: fsl,sec-v4.0
> +      - items:
> +          - const: fsl,sec-v5.4
> +          - const: fsl,sec-v5.0

What's the point of having all these versions? Better to use
SoC-compatibles.

> +          - const: fsl,sec-v4.0
>  
>    "#address-cells":
>      const: 1
> @@ -77,6 +87,8 @@ properties:
>  
>    clock-names:
>      oneOf:
> +      - items:
> +          - const: ipg
>        - items:
>            - const: mem
>            - const: aclk
> @@ -85,11 +97,17 @@ properties:
>        - items:
>            - const: aclk
>            - const: ipg
> +      - items:
> +          - const: ipg
> +          - const: aclk
>        - items:
>            - const: ipg
>            - const: aclk
>            - const: mem
>  
> +  dma-coherent:
> +    type: boolean
> +
>    fsl,sec-era:
>      description:
>        Optional. A standard property. Define the 'ERA' of the SEC device.
> @@ -108,8 +126,16 @@ patternProperties:
>  
>      properties:
>        compatible:
> -        enum:
> -          - fsl,sec-v4.0-job-ring
> +        oneOf:
> +          - enum:
> +              - fsl,sec-v4.0-job-ring
> +          - items:
> +              - const: fsl,sec-v5.0-job-ring
> +              - const: fsl,sec-v4.0-job-ring
> +          - items:
> +              - const: fsl,sec-v5.4-job-ring
> +              - const: fsl,sec-v5.0-job-ring
> +              - const: fsl,sec-v4.0-job-ring
>  
>        reg:
>          maxItems: 1
> @@ -148,8 +174,16 @@ patternProperties:
>  
>      properties:
>        compatible:
> -        enum:
> -          - fsl,sec-v4.0-rtic
> +        oneOf:
> +          - enum:
> +              - fsl,sec-v4.0-rtic
> +          - items:
> +              - const: fsl,sec-v5.0-rtic
> +              - const: fsl,sec-v4.0-rtic
> +          - items:
> +              - const: fsl,sec-v5.4-rtic
> +              - const: fsl,sec-v5.0-rtic
> +              - const: fsl,sec-v4.0-rtic

This is also a bit odd... why do you version children?

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640BBC761A6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 05:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjDCFgp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 01:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjDCFgo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 01:36:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463B1198B
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 22:36:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c29so36500246lfv.3
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 22:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680500200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNisbyazzEuiDoc493Vd97NOzyQn4Z3XdTw9SUjbEVs=;
        b=FKMn4FIKmR76VOUgJbP6Az952xGQ89BUZaCITbwcATVHFfCmKI50/fFP0aTiU12xYX
         TlvL3BpFrG1DNVu7tESCh+WqKUXjFtQVDJSQZpiuWs6NxzLY3dtNH/hRfJbe7EjyAJh2
         A2NAKH+2+v0QQgeNbY2miGvOYSQ36I1t5Wx82wtx6DhaHGYnwCZicqCm3tOqRG6Ph7tU
         bFPfzYuiJnZPX1c9piXYoe6dbBWr/NJ3/4mJOnqWKmqxufvLYOpSwTo0lFuuHhXeCjfE
         4xsS0KNngHWT9SNIAx+5CwI4d2onCCkFiVtgJE3HrDO0SSWQxWuqMrpKDN88fcHmwI3U
         /UDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680500200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNisbyazzEuiDoc493Vd97NOzyQn4Z3XdTw9SUjbEVs=;
        b=f6mmIZjHOmk0QPWvhs/mEVtmFc7154efVutD3rjoo6F2UUf3FoFdB9+nj6W2xdNjRN
         WMDldCsacN3raiYWB8h44uHVOp8cQYITrEwRF42NhX75IBj5jIBHTCSwtyBeO3fVRlNH
         RcYEjKX9g2rG428NEoComnskVh9TdbabMLcpml8CwbzEPAdAVgY1Ndpc3Uq8A2hRJk/I
         CnbepO6lq4TgfOlBT0EpTVDBqkBL4G3E5qRvJ+4ezHfkpNvoUGpwtpdsjCoP7bsCCe+g
         htb48w7hUKf/vtZ6dftZFZpDzLvU4pXV7F8TEAi6dW+oVFeYsWBxOnq+hD/h0X/aC+FZ
         ld/A==
X-Gm-Message-State: AAQBX9fAbql9Qjlt6dneVKKvf+qKK1rv634/2sSjLcrpftUsRI4WknUb
        bEMo+tZrqzw4pyN/xJucv5WN6A==
X-Google-Smtp-Source: AKy350bvhQIqIFG6nLBH4pVgxB/u6kZnVKvq8YYr6y6Rrl71vml3LsIIAr3DDcYH6vn+My/tNbY7qQ==
X-Received: by 2002:ac2:5311:0:b0:4d2:c70a:fe0a with SMTP id c17-20020ac25311000000b004d2c70afe0amr2797282lfh.2.1680500200412;
        Sun, 02 Apr 2023 22:36:40 -0700 (PDT)
Received: from [10.8.0.2] (mleia.com. [178.79.152.223])
        by smtp.gmail.com with ESMTPSA id z19-20020ac25df3000000b004eb274b3a43sm1593811lfq.134.2023.04.02.22.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 22:36:39 -0700 (PDT)
Message-ID: <21eaeea4-4f2e-5ce5-c75b-d74ded8e6e4c@linaro.org>
Date:   Mon, 3 Apr 2023 08:36:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v5 05/11] dt-bindings: qcom-qce: Fix compatible
 combinations for SM8150 and IPQ4019 SoCs
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, konrad.dybcio@linaro.org, rfoss@kernel.org,
        neil.armstrong@linaro.org
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
 <20230402100509.1154220-6-bhupesh.sharma@linaro.org>
Content-Language: en-US
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <20230402100509.1154220-6-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/2/23 13:05, Bhupesh Sharma wrote:
> Currently the compatible list available in 'qce' dt-bindings does not
> support SM8150 and IPQ4019 SoCs directly which may lead to potential
> 'dtbs_check' error(s).
> 
> Fix the same.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index e375bd981300..90ddf98a6df9 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -24,6 +24,12 @@ properties:
>           deprecated: true
>           description: Kept only for ABI backward compatibility
>   
> +      - items:
> +          - enum:
> +              - qcom,ipq4019-qce
> +              - qcom,sm8150-qce
> +          - const: qcom,qce
> +
>         - items:
>             - enum:
>                 - qcom,ipq6018-qce

Two commit tags given for v2 are missing.

--
Best wishes,
Vladimir

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B84DC7EE30
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 10:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCCKDZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCCKDY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 05:03:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519C8B46E
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 02:03:19 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x3so7969098edb.10
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 02:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677837798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WGynNVbD7bhkWPwRtuZIYOHNAiw3+RAyPRyR/rq0hI8=;
        b=VjgNgQ+PXlb5wUU5dejz2Qxr4CGfcx/bQdtSCAQdAMhZdnOzBw0J3daRW72B7iJxpZ
         ajjqZmYGkvzf2QBKSq2mnQDMQVLU7N5EagsBph+MHzrcT8iliCj7OxzRobdSc8Mt/RPl
         AoG1Qm/RoBpAaw6JfnYzhbrgSNqY14CQL3FVtEnoeg52uvlxp1rRextD7Sn/lPcAWaNf
         YgPE6em9pkE+NAdNnPWcgmRl08zrVjv9I1SZ7FiJ7ucKhaSiwlPuyLvKmIp94GRi5MRD
         Ts5tzXE8Eyv4r9rz6vwc1FNqa3uZfs77mYTgc3SYNDCEnpFhFYUNuTAvLsOhYufbb+Dg
         EETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677837798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WGynNVbD7bhkWPwRtuZIYOHNAiw3+RAyPRyR/rq0hI8=;
        b=f0FzujBxu1wN7Vk8Ad0zcXjkDAE2VZC9/3HwmYIqRrET+7FA7he9aXUr2DK5ADpcdB
         CQwC+AjejslU3WS4rF+L8o3xyVmpl4VSl/aHJ3gazQRTwKgG7uEN20bOXrK3HDSfOaOe
         caJt3zysgjc4JIQncJmesH1ZYTpCCve0/+AOZyQwWGMnLkD9K5Kv7hMEJipRt/gXbU53
         t3ggQ7OVG/3YvUp7AQLAbEZHEnEjHvXEL6kjBgf/SLvXKY1hubGCaWZG9oPUAxUH6N0U
         4gjWJy/wW+RZO9PoN3dFiOBpwfdup8P5Yo2OtxDvwFbYaLKS2/+YfwV0SVZHn0V00wBe
         O7YA==
X-Gm-Message-State: AO0yUKXdAhe7rLyggvrHlsC1rwKWC0tGu4afgY9Ddh4hL+AYqAPsr5kk
        +05wqC5JGOEm0/bSCuqxMyYV7Q==
X-Google-Smtp-Source: AK7set+f5KN1QCsYanUNAi4iOL3ckk1ezCxnW6vJXk9YRqpogTv4LrmnjTkEvCsDrXYw6ylDPdbgMw==
X-Received: by 2002:a17:906:207:b0:8f3:8bfd:a8e with SMTP id 7-20020a170906020700b008f38bfd0a8emr1029393ejd.26.1677837797763;
        Fri, 03 Mar 2023 02:03:17 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090611c600b008b17eb06282sm770154eja.213.2023.03.03.02.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:03:17 -0800 (PST)
Message-ID: <0b8adbf1-aae2-e773-1c11-5d8de0c54b8a@linaro.org>
Date:   Fri, 3 Mar 2023 11:03:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 8/9] dt-bindings: crypto: fsl-sec4-snvs: add snvs-lpgpr
 support
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
 <20230301015702.3388458-9-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230301015702.3388458-9-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/03/2023 02:57, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add snvs-lpgpr support for fsl-sec4-snvs
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  .../bindings/crypto/fsl-sec4-snvs.yaml        | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml b/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> index 1a4b4975e1d9..688057ec5c97 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> @@ -124,6 +124,25 @@ properties:
>        - compatible
>        - interrupts
>  
> +  snvs-lpgpr:
> +    type: object

Why not ref to that binding? Much less code...

Best regards,
Krzysztof


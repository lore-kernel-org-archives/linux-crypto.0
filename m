Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD90C64EC4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 10:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCCKBf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCCKBe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 05:01:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08548E26
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 02:01:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s11so8018568edy.8
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 02:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677837691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kl9JSJz46sgnG8LrVPxuzl/WiHthp+37Zaca1eh39eY=;
        b=Ng4o5DNIo0TDtYWZ9jgx68zeRBFkRT4AjX/URLlM3a53NWhVQMck5gFu42vFq8Nopm
         C6fBbyQ9kyN2oFMjb1TZFSmIjughb1B5LCe+JIXNXxwEBCEImV2SPJBkOf/gKUi4N4Kn
         KEYd1x0NV7vLENWIs71wYLv+c6KSV6aYyR3ZoTzzpZCrolN+MQh1fw5dg5t+/zBexmDk
         X+2rY2R/jUGpqDJyC+8SxCJkKmUawRZxRxb+GSBHV0p9aK3qv4WHJ28LUlzrw4aKsHjt
         HeNOZE2/Xnb8niBGCSewnswsOUqobJCIM6ZHKCCTRz1UteydnZx14o626RVCNqHkMjR6
         yfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677837691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl9JSJz46sgnG8LrVPxuzl/WiHthp+37Zaca1eh39eY=;
        b=5sncMS1hDIRdQqdg8EIsnUM6TVigyKQtKnqpzedtbBeQmrkAp/GCh2dUd5KIFv5Z1V
         q93XaY3FC8JM+911RkJjQ1WoCdj4wu+OnQrkd2VwPPBwOJaCwYL5ADEI7OCv2rmpqyAn
         XxR/+brHcgjMS2Ym+DGnUyuVYh0saIFv5KckVt4w/pHoDuukDqmd0EYAnbcbkeKrd6Zf
         SqyKz0OrPYQniigafExvQPizbUDE22PA4OwcjTr7xmRYJwTD50WfvlDVR8ijRhvaZu9s
         N8xjsvd7MUQjmdCCk1Gun7ecE3e2me6wOc3SJwfBg7pBbvEAqQ68DxqqIc6Y/zcGLNUS
         +9Ng==
X-Gm-Message-State: AO0yUKURlKxiDxRgiftGZlCCB+Mxn7NsPp1QYKXh/DALBhyH5OTrLWqq
        4TBDcd1sU5xff5tcTjNB5U+ZTQ==
X-Google-Smtp-Source: AK7set//c/zaLFnjyGSB6Ah4I07Td9TiQd97JsFNtrJX8iPphbgDDDkOahdUGlXIFwnN2NjRoMaL6g==
X-Received: by 2002:a17:906:d208:b0:8de:502e:2061 with SMTP id w8-20020a170906d20800b008de502e2061mr942019ejz.3.1677837691831;
        Fri, 03 Mar 2023 02:01:31 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id h10-20020a170906718a00b008c33ebac259sm769846ejk.127.2023.03.03.02.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:01:31 -0800 (PST)
Message-ID: <eff26254-0578-e6ca-f76f-412eb361bf54@linaro.org>
Date:   Fri, 3 Mar 2023 11:01:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6/9] dt-bindings: crypto: fsl-sec4-snvs: add fsl sec 5.x
 compatible
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
 <20230301015702.3388458-7-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230301015702.3388458-7-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/03/2023 02:56, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add fsl sec 5.x compatible, which is used by layerscape SoCs.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml b/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> index 6878ae8127ec..1a4b4975e1d9 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4-snvs.yaml
> @@ -24,6 +24,10 @@ maintainers:
>  properties:
>    compatible:
>      oneOf:
> +      - items:
> +          - const: fsl,sec-v5.4-mon
> +          - const: fsl,sec-v5.0-mon
> +          - const: fsl,sec-v4.0-mon

This is odd... all of these are the same version then? What's the point
of having versionable compatibles if they are compatible?

Best regards,
Krzysztof


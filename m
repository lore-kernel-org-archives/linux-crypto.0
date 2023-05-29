Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145BFC7EE31
	for <linux-crypto@archiver.kernel.org>; Mon, 29 May 2023 06:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjE2GQj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 May 2023 02:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjE2GQh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2023 02:16:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2CFB2
        for <linux-crypto@vger.kernel.org>; Sun, 28 May 2023 23:16:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f6d3f83d0cso30590085e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 28 May 2023 23:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685340967; x=1687932967;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LA0lZXIZyfreSy6UzrDrMm0pLQo6QMWpJJ8ip5ZSwRM=;
        b=fwnJI2MHpqMgPEusIsDf6dCdGxxELVhkY6rqbFk3lB4f3VkRWgTwc3I9XPPoRSqIA/
         +i0QzKhrmmpRP8fjyyir1WVPKrQ98bNCt5TfkxeZuaHjnQ4Q0UH1E2fk0maaS1G/Af/T
         5kmHjNCc6v3dS2RssRi1X2x+yLqBwXQipQpzvOqkkXosU47sMFUEQX4hNMTSWSHQizBI
         lRAQ6Vl+b9fJlYCWbfZIlbeowumqYxk5TKyEtLN33xTzT5vvfPp2inLsnoLcGkUHlitZ
         Wk4QVRfCuOPybeD3s3Q5IWrbRSYkQk+XISzzyii2gYRMKrB5MqeQPS/kBEGsK6qmcS0z
         0AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685340967; x=1687932967;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LA0lZXIZyfreSy6UzrDrMm0pLQo6QMWpJJ8ip5ZSwRM=;
        b=AiWab3kdxOO6NkzF5xVpDDxRFq0px5xxAyqtdCsGJqAfJR11Fpiw9Z25ESEjQMqV3I
         CgkRp5q4IXLl4CFq6CZ64LXD2VWBm3iVhcIeY5RmUv8cTnln8bL8+qdOZWiiQDSMY2rK
         lWnh05Vflcd6EN0V1CXheR6OHWfneRM2K5GHrJulkAGarmc9wqNn8G9WQcMplvyEApAj
         iF2BD2EUnPRDX5KOZQhCj1WAxuR6GAYQmPi0ixCrpDDQGmZuA3dlIYxDjLygg55sA952
         ClVj1YPir3pqagFNAb8Yh8w2pnHp5tdxmVddk3LoOZLAHH0mx4B+gm5Ij4cbJtfC1y+i
         hKzQ==
X-Gm-Message-State: AC+VfDzxZ4q6lUCv0hfvA5af3YSZoP4IB6wjrlkQ5L8ahB4SR6wbTNPi
        YOy/m7h/wIUCQkC+Syhmdt2XcO+qsf9lscqVmJBt+g==
X-Google-Smtp-Source: ACHHUZ4ueNV2gTUYIfOuOR4I8nBjLUyiMggWa2AaJkdjCQz68pX+xZH4y3Da4ZNKMrsDlhdFfcW6KtA7o9jw9fnmtHc=
X-Received: by 2002:a7b:cd99:0:b0:3f6:41f:8e66 with SMTP id
 y25-20020a7bcd99000000b003f6041f8e66mr8079474wmj.5.1685340967640; Sun, 28 May
 2023 23:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org> <20230526192210.3146896-6-bhupesh.sharma@linaro.org>
In-Reply-To: <20230526192210.3146896-6-bhupesh.sharma@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 29 May 2023 11:45:54 +0530
Message-ID: <CAH=2NtwPhspRXD1g390c79+w1CFc19m+RcrzcCEtnGxomumhMQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] dt-bindings: qcom-qce: Fix compatible
 combinations for SM8150 and IPQ4019 SoCs
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, konrad.dybcio@linaro.org,
        vladimir.zapolskiy@linaro.org, rfoss@kernel.org,
        neil.armstrong@linaro.org, djakov@kernel.org, stephan@gerhold.net,
        Rob Herring <robh@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        dmaengine@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Sat, 27 May 2023 at 00:53, Bhupesh Sharma <bhupesh.sharma@linaro.org> wrote:
>
> Currently the compatible list available in 'qce' dt-bindings does not
> support SM8150 and IPQ4019 SoCs directly which may lead to potential
> 'dtbs_check' error(s).
>
> Fix the same.
>
> Fixes: 00f3bc2db351 ("dt-bindings: qcom-qce: Add new SoC compatible strings for Qualcomm QCE IP")
> Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index e375bd981300..90ddf98a6df9 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -24,6 +24,12 @@ properties:
>          deprecated: true
>          description: Kept only for ABI backward compatibility
>
> +      - items:
> +          - enum:
> +              - qcom,ipq4019-qce
> +              - qcom,sm8150-qce
> +          - const: qcom,qce
> +
>        - items:
>            - enum:
>                - qcom,ipq6018-qce
> --
> 2.38.1

Bjorn has applied the dts patches from this series to his tree.
As suggested by him, can you please pick patches [PATCH 5/11] and
[PATCH 6/11] from this series via the 'crypto' tree.

Seems some Cc fields got messed up while sending the patchset, so
Cc'ing the list(s) again.

Thanks,
Bhupesh

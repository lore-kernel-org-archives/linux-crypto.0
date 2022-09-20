Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72CAC54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 15:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiITPKU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiITPKS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 11:10:18 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8278717A8F
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 08:10:16 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id f9so4322596lfr.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=OViHu+PU5jEpPTNCIuO30uizM2q0/rKRcVFoq6MpQm8=;
        b=Mgvo7+TX/PagCkx35EfYZnfTM/X0/MHnFq68QQT8p3Jk3ObhJqaUCACvhkdNJJqbVh
         Ltc2Npmgy1AnwVWCTFGdpLsfdkUT0A4OYyslgLErhbyWsy+p1u+4pHURu0nqrVaNb9OV
         72Qk2hivZMjiF9ExFGZgfQhhoWNNG+Uc/1Flszgk/oasmkw0F7LHcDuJ9ziQR0hp20Uo
         A7Zh4rhp6CEwMH3cqlttkbIeojJvXrgqLP5JrpCuBnhOkDh4VeumfKgRI7og1Rg+Q0yV
         5dK2iUkhugrslmwT9B2zWeU1/HrXcoTfYpxCYwg5Rc9KD/QgzflPFZ6hBiY0ig0hPgAl
         PhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OViHu+PU5jEpPTNCIuO30uizM2q0/rKRcVFoq6MpQm8=;
        b=ASQq69FXVawECV2PY7Zczng0eK/FVL+aA23Mq6bXe95qXdLWEwwXge5g8edAzVoTZv
         HYVWIi65DDMFnZ3XIZpxRtVv3oZ1lZfZST96RI1FbOjx854FHjP0C3dElMjH/thGEhjz
         /Zwh1KDKZtYH30AU++PjztCjhmGocQoiC3mP/1N6jHIfvUXS1UQXyZv+yC7b1HVxFMm1
         OM8DALapJuCdbagPIy+HCEzxr6Ox3AKYqYvZhfVaXou3vIum7cSL0crhNvAZ/4RTlUQe
         1VpCz/PvbRRk8UEiIL+Ic/33PSQ4SmMWygfPdF47O5MWfwjmQIWuwuiPHv9gqwW16xtQ
         5BEw==
X-Gm-Message-State: ACrzQf3u0Upy11shLdiRu3Ku8aP6PJd2lZzrU73WQgwyR4gQIQbl2vBU
        KvCocTL1osYUlRrZYlYK0Jvwjw==
X-Google-Smtp-Source: AMsMyM4glAPExuXIHfUSqwdUwYLj2e3fxyvPVe/CF6+S04oyl9aGtnJL4wIddz/70d4jhJ+atFfuTw==
X-Received: by 2002:a05:6512:10c8:b0:49c:14c5:e081 with SMTP id k8-20020a05651210c800b0049c14c5e081mr8574761lfg.615.1663686614879;
        Tue, 20 Sep 2022 08:10:14 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a16-20020ac25e70000000b004974da17c2bsm18620lfr.0.2022.09.20.08.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:10:14 -0700 (PDT)
Message-ID: <0a6b443c-33b4-5fc7-5a2f-e55f5387999f@linaro.org>
Date:   Tue, 20 Sep 2022 17:10:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v7 4/9] dt-bindings: qcom-qce: Add new SoC compatible
 strings for qcom-qce
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, andersson@kernel.org, bhupesh.linux@gmail.com,
        davem@davemloft.net, Jordan Crouse <jorcrous@amazon.com>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
 <20220920114051.1116441-5-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220920114051.1116441-5-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/09/2022 13:40, Bhupesh Sharma wrote:
> Newer Qualcomm chips support newer versions of the qce crypto IP, so add
> soc specific compatible strings for qcom-qce instead of using crypto
> IP version specific ones.
> 
> Keep the old strings for backward-compatibility, but mark them as
> deprecated.
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Tested-by: Jordan Crouse <jorcrous@amazon.com>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  .../devicetree/bindings/crypto/qcom-qce.yaml         | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index 4e00e7925fed..aa2f676f5382 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -15,7 +15,15 @@ description:
>  
>  properties:
>    compatible:
> -    const: qcom,crypto-v5.1
> +    enum:
> +      - qcom,crypto-v5.1 # Deprecated. Kept only for backward compatibility

No changes since v6.


Best regards,
Krzysztof

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DCAC433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 12:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241795AbiDBMMR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 08:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237949AbiDBMMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 08:12:16 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759414B1FD
        for <linux-crypto@vger.kernel.org>; Sat,  2 Apr 2022 05:10:24 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so7634172wrc.13
        for <linux-crypto@vger.kernel.org>; Sat, 02 Apr 2022 05:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LU4WxTcoo4DIwvyGzKiLAb7OdkkMkGG5Idq3rF5DsZw=;
        b=ef8plMMHl5f+/DwKN6AYys4AGd20iAAP/lJWVnZ+USiqWdotHiVFucoV0Ns8yaIFqp
         78VEj1B5qf0XCKvUiuIOb1isK2b8BMd5PdyVF+Q6KVT6KsBgU7Dy7bjMkICwStIQn5Xy
         xQ8g0EpXq8uKhr3HE/51Sc66nAcs1WnrQWTA9/xgAgJ7bRvtPgzULl4xs/FMnuZMZsuf
         uaLm/FEFF2uKvmNrxfhYVv0VoBAp6LVlw4QWpqPvRXircYkLNeK2ZkKHJMJUg4SNqhKR
         kIYCDV5rTaBduHQHDTrJ7xz97BGs4x/oDXuPsXit13xE6gTbHthiQitk03Xy1DKUDtLc
         wLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LU4WxTcoo4DIwvyGzKiLAb7OdkkMkGG5Idq3rF5DsZw=;
        b=u0t0yUbzRY14ymGqltvzcj1/Bs+joq6cI6lDHPATjC7ADskE+Lfdop2CP7T/tUbMMi
         fykCWxKXknGZ2BGxk6g3etQO65hpKG06L+lV28sMlH7ibcPne1/LszXakCTWQwM+tigW
         Yyt+y2QU1MxokjcSq4hzMhLhl8dCJ+p43jZ2DwQW/ChYyFO5LhaGdxtjdMZO33xD0ua+
         yN8YgGZoQEsSMS4DthA/lZCQ73v1PL6Pb+XFvp2RpuFxbPr5bEJCZgFRAmPVZ+Zc3hRt
         EN3mh1ECOXuCIzXo7qwJzvBQ4fwd+VVbRhHxntj+gpdC5FJDCBxza+IQtWxqMBwm/Llt
         WiCw==
X-Gm-Message-State: AOAM531fejjX+ZZKYlGlEuWgTAsq/UBvGjb/B7EVMtPNI5/gUqKst9sL
        ZYr8uswljkmlotODVt6xAUaH8w==
X-Google-Smtp-Source: ABdhPJxiuq9UlKATWx/wJwEiZRHVK/pago1Lfs023MNtO94iCjNNQ67WIi2xbjW7sWPvyKpFfHrMMA==
X-Received: by 2002:a05:6000:1789:b0:206:2d1:6f35 with SMTP id e9-20020a056000178900b0020602d16f35mr2227545wrg.613.1648901423075;
        Sat, 02 Apr 2022 05:10:23 -0700 (PDT)
Received: from [192.168.0.171] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm7713966wrp.108.2022.04.02.05.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 05:10:22 -0700 (PDT)
Message-ID: <3969db0e-50e8-e042-4696-97f56bd38999@linaro.org>
Date:   Sat, 2 Apr 2022 14:10:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 27/33] dt-bindings: crypto: convert rockchip-crypto to
 yaml
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, heiko@sntech.de,
        herbert@gondor.apana.org.au, krzk+dt@kernel.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-28-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401201804.2867154-28-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/04/2022 22:17, Corentin Labbe wrote:
> Convert rockchip-crypto to yaml

s/yaml/YAML/
and a full stop.

Looks good but please mention in commit msg that the names for clocks
and resets will be provided in next patch. Otherwise it looks like
incomplete conversion.

> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../crypto/rockchip,rk3288-crypto.yaml        | 59 +++++++++++++++++++
>  .../bindings/crypto/rockchip-crypto.txt       | 28 ---------
>  2 files changed, 59 insertions(+), 28 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> new file mode 100644
> index 000000000000..66db671118c3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> @@ -0,0 +1,59 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip Electronics And Security Accelerator

Remove "And". It looks like company name is the name of the hardware.

Best regards,
Krzysztof

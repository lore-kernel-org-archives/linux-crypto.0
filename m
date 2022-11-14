Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23383C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 08:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiKNIdV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Nov 2022 03:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiKNIdQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2022 03:33:16 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573E61BEBE
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:33:07 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id z24so12190007ljn.4
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4bDIlpTMPNGhynOcw3dA0OXLyN02s1nEchOu0DS5J4=;
        b=cKL+VMp7JYBOJDsXi2zWFzzuvxIRq6KN5BeLldK5pSjqmW+Mr0ZuLxe8CbMfF9qRx0
         4S+if7cpuxuEqV+HI4E+f08PEoqQ6JoQvpWpwtX+Gy4u9AyW9aZBE5W1L/rPv8ZyIHrp
         YcV6ap7JFGezi8Pcl53a6xQPj9FZ121WA1n+yus4daq+Qy+xcfaPLmLSrrWcepi/pxBD
         5I+re7wsa7djS6AF9ykaIyiaVn6EDJ4dW4hyOaYh0UbwlPpE6e8Lz5zMNHi/TL6qVkAQ
         yejXtcjFwp3NQWPa9Itcom21obdQKC7T0UVYSwUnrSwyJoFtitHt+COSA1cCVY6EXdmb
         o+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4bDIlpTMPNGhynOcw3dA0OXLyN02s1nEchOu0DS5J4=;
        b=0VaWBaJ2KFi/gC/e5JVwwKRBZPg2CBmtlu2ppb3q7OuN7UQJzNztyFppM7bCOgkrF6
         V/34FFH/9gL7mIcVbLDAUGpFvu6sCqu5NFpjDvjK538Bi9S3PPv6Icv24mP2ANs6lKVM
         jHdx7RbYHRXwF4GRnTdlFgFdi24mmmIEEPoaeCIYO2qITLBvAabhcFochmp3Fas6ti8O
         CZzy5GKJUllKZkMpQc/FgJ9kK4Ai6KgYuay6neq9caYu0F7IU9aJtv+RKYZckOzGVhTO
         pKQ4MRLvGB/Pin/j5IsYz1dQbOlqv11rmAVnjZMMLVuMh9+n+qy/CIt+M2bdD0vtGAtv
         p9ig==
X-Gm-Message-State: ANoB5pntpJzBi69MqTB3hzwP9wqrL9kyTuCLoerBqlukHN4VADV278/m
        iUX+CEX9rIou4YZAl0bfyL0K8A==
X-Google-Smtp-Source: AA0mqf4ngqj7E8JmFa45kHUi8W4+1dhE6cLcGtbN0dmhmpoukxzKn/FMfzXF2XA/hYFyX4MSqsl0JQ==
X-Received: by 2002:a2e:9ec8:0:b0:26e:9936:6153 with SMTP id h8-20020a2e9ec8000000b0026e99366153mr3847754ljk.278.1668414785727;
        Mon, 14 Nov 2022 00:33:05 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f31-20020a0565123b1f00b004b3b7557893sm1726968lfv.259.2022.11.14.00.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 00:33:05 -0800 (PST)
Message-ID: <e59bd325-0982-3a20-ed09-d75747c7e659@linaro.org>
Date:   Mon, 14 Nov 2022 09:33:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v1 1/3] dt-bindings: RNG: Add Rockchip RNG bindings
Content-Language: en-US
To:     Aurelien Jarno <aurelien@aurel32.net>,
        Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Lin Jinhan <troy.lin@rock-chips.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/Rockchip SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC support" 
        <linux-rockchip@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20221112141059.3802506-1-aurelien@aurel32.net>
 <20221112141059.3802506-2-aurelien@aurel32.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221112141059.3802506-2-aurelien@aurel32.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/11/2022 15:10, Aurelien Jarno wrote:
> Add the RNG bindings for the RK3568 SoC from Rockchip
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  .../devicetree/bindings/rng/rockchip-rng.yaml | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/rockchip-rng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/rockchip-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip-rng.yaml
> new file mode 100644
> index 000000000000..87d80e8ff7f2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/rockchip-rng.yaml

Filename matching compatible, so "rockchip,rk3568-rng.yaml"

> @@ -0,0 +1,62 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/rockchip,rk-rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip TRNG bindings

Drop "bindings"

> +
> +description:
> +  This driver interface with the True Random Number Generator present in some

Drop "This driver interface" and make it a proper sentence. Bindings are
not about drivers.


> +  Rockchip SoCs.
> +
> +maintainers:
> +  - Aurelien Jarno <aurelien@aurel32.net>
> +
> +properties:
> +  compatible:
> +    oneOf:

It's not a oneOf. Drop.

> +      - const: rockchip,rk3568-rng
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 2

Drop minItems.

> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: clk
> +      - const: hclk

You need to explain what are these in clocks. Also you need better
names. A clock name "clk" is useless.

> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    items:
> +      - const: reset

Drop reset-names entirely, not useful.

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names

Best regards,
Krzysztof


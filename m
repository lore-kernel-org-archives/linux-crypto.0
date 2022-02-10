Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8CAC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 16:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244134AbiBJQTy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:19:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbiBJQTx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 11:19:53 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A98397
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:19:54 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7E4813F324
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644509992;
        bh=tT0V+KU2BeoLWRdV7eFcuAjZlhzvXhhK5c/htTBUt/Y=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=wRTJUVtOzIwMDB+YKU0ajito4wwvbRayF32E44RdAQJJleYn6Jg4+AL+QNk1aSb1e
         gmZdvkfhrULU620Wiaz+yNuE/PeMXiTudhaOHcENgtRT584vla7X3ys00b/RjJNiwA
         aTc4YXF9V4M9IwHRcfIt8gj91XZVqG48ACNh1zGbkJE9DTts4sm9KeWHJMJh4RXSAk
         Gv2x1bQMMXe3VmSe1Myaoop7PHmrmMqMIhXtqnEH8d3UQ2W9shOUbhyKM8YUXuai92
         rQtcKwjGXUTLil/Onao6nI6CfTm9PJZs0W+DOAklTSuBFJ4gSny+5lks8Dz7zpABGE
         OyGYeaLYTntog==
Received: by mail-ej1-f70.google.com with SMTP id z26-20020a1709067e5a00b006cbe0628826so2970960ejr.10
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 08:19:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tT0V+KU2BeoLWRdV7eFcuAjZlhzvXhhK5c/htTBUt/Y=;
        b=VWmf2O7lzNzoqutqZMVT8xrtW7b3OMRcLWrgd40+0TqC9htuiXNU4ZzQ+Lf99dTpgn
         kbg/Kl6u+MC4shfy7rk3SHzJmveEt4wONlTcm3ucsBxIenob8IR4hh7fb++iyFwhOa7l
         mUp7NviZLx8tvpkXkjQLFtBPIUU65tg6E8OSpgwuwx1cE2YM1I9mEC5eulsEk29Ec910
         LYjmlEwAeDoGtnayYCd60FQHzBuA8tl7mjZAgQAw9CQaL0qC5erMFc1cVerG3KTIVFxf
         hUgDHcD1TFA96XK1AruGE9A6NitOM4QvORyFuQ7/NjFUBs6vr4nMt1srqDpGZ1anYmuA
         o9pw==
X-Gm-Message-State: AOAM532YEtoJhTmzqTX3Np5ieloS7mWtUIkMf0FKR326BkmF9pA8OqEN
        5G6GjDhB0XC833lCVI8ZoJronDuUI6xuF0bRz+gqF2RPaHiw4Q/0HxKgjKF2zfXgagSun4HQUz+
        XQkkyohSIagIaH1QzGc2fb8AwMlv1f4Q33TUaYgTDyw==
X-Received: by 2002:a50:fc13:: with SMTP id i19mr8938751edr.232.1644509992152;
        Thu, 10 Feb 2022 08:19:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyo8YzrREsbeeglYGU1jriGlI0EGZwvP8ev+ebkKY9LgD4Hb/DEgHvBEZAWx22aJjpMpTx2yg==
X-Received: by 2002:a50:fc13:: with SMTP id i19mr8938724edr.232.1644509991996;
        Thu, 10 Feb 2022 08:19:51 -0800 (PST)
Received: from [192.168.0.99] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id x6sm9820678edv.109.2022.02.10.08.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:19:51 -0800 (PST)
Message-ID: <7acb44da-5833-f638-9348-0cbcc21cfc13@canonical.com>
Date:   Thu, 10 Feb 2022 17:19:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] dt-bindings: crypto: convert rockchip-crypto to yaml
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>
References: <20220210161403.2966196-1-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220210161403.2966196-1-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/02/2022 17:14, Corentin Labbe wrote:
> Convert rockchip-crypto to yaml
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Change since v1:
> - fixed example
> - renamed to a new name
> - fixed some maxItems
> 
>  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
>  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
>  2 files changed, 66 insertions(+), 28 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> new file mode 100644
> index 000000000000..44f415597e32
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> @@ -0,0 +1,66 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip Electronics And Security Accelerator
> +
> +maintainers:
> +  - Corentin Labbe <clabbe@baylibre.com>

You removed Heiko. It's fine for me, just is it expected?

Look good to me.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof

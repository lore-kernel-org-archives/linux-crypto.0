Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EA1C76196
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Apr 2023 05:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjDKFro (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Apr 2023 01:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjDKFrU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2023 01:47:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E930F9
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 22:46:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f26so11328580ejb.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 22:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681192014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/pS0YHLfeqUXxXueVr3xrpqfYzfFGCjkGT7qYBY7SpQ=;
        b=GVral6enKQmYqWeI17NidZmmODtmBgPO48BHtpOhGVXebFO7gIcRgTB485y+xw7YrY
         zV8iPV3ZQRCorR2soGJtBXTEe5Wx3tuUVt37a5SE5AO3UZd5FIrCOX3qtp8AHyAtFN9o
         4aJVXZGGpEjSjOO4xAU8Is13FOekSNuuZcCr7ynfyza0ftmnT5ZESjFl1kFEvVG5/f4t
         YX0unimqbu8SUs0t1t5jj98lWXmrO1PjR3yBCEUJtqfVQ57Q3/v7n3y2GMnM93I9+uCb
         SSjuU7UN0prH7hd2Jz7jof+tbCMrSqJWqdcROJQp2IDunLcEpZQcH6sSvqvdl4bjzQYG
         4RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681192014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/pS0YHLfeqUXxXueVr3xrpqfYzfFGCjkGT7qYBY7SpQ=;
        b=dTW2GwsDHgNZ9p/Ovk9b7e03iWY8aZGez+gr7YIWOjUcLQx+0QhyLoOJCYxwWfi4tv
         b3Cb8VnEUsIYy/ca9ZloQJsRpW6CSvTMKYRPyLr3uD/AQ8LJBdG98cbwi6Jx85Ja+L48
         F88rUxdLD11JGsAlgizFgThAu86oyqxovtxLwBPEIpsQo4/rwzzpyGGYylIh7wkv+U9O
         aDoihIt0MX1X2/KnwGlGRAYSh+bQoiXWa3FqtlZGYMqPEGvj5VY4R5x6FgrZovGV1qvn
         fVvPgei3bAencuDAt8janzv9j8d9SfJPZBB6gaQKRKAqX26iL46oGFs3W14M5vglODof
         xfkQ==
X-Gm-Message-State: AAQBX9fHhl6AJtgoD331PQ6OnZQHyUM41rKZbW8ce9NmU+JIFnebc+ZU
        9oSQ8QlybMjr0KNgMYFvpvtm7A==
X-Google-Smtp-Source: AKy350a47ut/AkoSQIwjbjtHVtAuQPe8zGjAcqV7+PVPlBYc8n00LUtmFdTEEoQ6FmCGLG+TbipydQ==
X-Received: by 2002:a17:907:a44:b0:947:d3d0:ae1c with SMTP id be4-20020a1709070a4400b00947d3d0ae1cmr12030744ejc.0.1681192014573;
        Mon, 10 Apr 2023 22:46:54 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:dad2:72b7:3626:af61? ([2a02:810d:15c0:828:dad2:72b7:3626:af61])
        by smtp.gmail.com with ESMTPSA id xj11-20020a170906db0b00b0092be625d981sm5756333ejb.91.2023.04.10.22.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 22:46:54 -0700 (PDT)
Message-ID: <a0a64ba0-cbd0-1e43-320e-a9036da60613@linaro.org>
Date:   Tue, 11 Apr 2023 07:46:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH V2 1/6] dt-bindings: serial: fsl-imx-uart: add missing
 properties
Content-Language: en-US
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
References: <20230410205803.45853-1-stefan.wahren@i2se.com>
 <20230410205803.45853-2-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230410205803.45853-2-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/04/2023 22:57, Stefan Wahren wrote:
> Currently the dtbs_check for imx generates warnings like this:
> 
> serial@7000c000: Unevaluated properties are not allowed
> ('clock-names', 'clocks', 'dma-names', 'dmas' were unexpected)
> 
> So add the missing properties to the devicetree binding.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


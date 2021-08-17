Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295C4C432BE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A7A86103A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 21:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhHQVNh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:13:37 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:39534 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbhHQVNh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 17:13:37 -0400
Received: by mail-ot1-f52.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so105295otf.6;
        Tue, 17 Aug 2021 14:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iD6/Uk+6Fgtm+L34Bm4BSVW/la1AEprAZo1sZD8rrKQ=;
        b=RxjnnSLbnKAoV+wrVNuyyM6Afi/x4XHxDVHS7PRUKtQnvL6n3FLDssAYP2PlQLKl23
         Ak3eCY0MIT5co3cMQMXEgMmaCUduFLRlp5gyyET58LjySisclWMk8BvilvtimHjoKl+u
         VbYjP/xcB4p++OQ1dxhlphf9QbeGtxwEXe6shojzaoIz8sJy6MmmBgYbFQDuZotPNjiv
         gQZrHeQ1URUSK2yinIUxkPwmtrkzuI+ZxmxXCXHWB1XS5mlGbsNo8S9N+qLkRONgnS+r
         a7zU+2Cdy5v4ue4I0bNeMsgH8C52gUk5qgMgUfgcdEQjgIFoLJ5WsaPRpQrXJgadWQuq
         qmRQ==
X-Gm-Message-State: AOAM530GjvzAi9wb66T7CbOFHgJWW7aQ5H2dGJ2BazFYBdrg1229wZfu
        ZXe/70gCHiL3O48AQmyoag==
X-Google-Smtp-Source: ABdhPJyciNF5YrkMWNtEJeH7yBdP3fwNjtiB7XkiZ+DDcyxiVdgD/fsEdS/cQc8M4dcI21sJL6A0Ww==
X-Received: by 2002:a05:6830:418b:: with SMTP id r11mr4087842otu.204.1629234783053;
        Tue, 17 Aug 2021 14:13:03 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 67sm609455ota.70.2021.08.17.14.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 14:13:02 -0700 (PDT)
Received: (nullmailer pid 849168 invoked by uid 1000);
        Tue, 17 Aug 2021 21:13:01 -0000
Date:   Tue, 17 Aug 2021 16:13:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: irqchip: convert Samsung Exynos IRQ
 combiner to dtschema
Message-ID: <YRwmXWUzF2AbEhcQ@robh.at.kernel.org>
References: <20210811084306.28740-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811084306.28740-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 11 Aug 2021 10:43:05 +0200, Krzysztof Kozlowski wrote:
> Convert Samsung Exynos SoC Interrupt Combiner Controller bindings to DT
> schema format using json-schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../samsung,exynos4210-combiner.txt           | 50 ----------
>  .../samsung,exynos4210-combiner.yaml          | 96 +++++++++++++++++++
>  2 files changed, 96 insertions(+), 50 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/interrupt-controller/samsung,exynos4210-combiner.txt
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/samsung,exynos4210-combiner.yaml
> 

Applied, thanks!

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B20FC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 20:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbiDBUN2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 16:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiDBUN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 16:13:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9C310F6FE
        for <linux-crypto@vger.kernel.org>; Sat,  2 Apr 2022 13:11:34 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso3350533wmn.1
        for <linux-crypto@vger.kernel.org>; Sat, 02 Apr 2022 13:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rK/lRSYk0qbxwtkUDAG4yOb3rw3v6oUTvUr8udIrHE8=;
        b=vY8hkEVh0+ifaT2+wLmFTky/Nk6iUZJPbjkSgKIFZGr+Akbqb8GBBgaf+DB33BWZA1
         NGa26e7vdb4mmht90cL1L3J5Ct2lQWk5DSiRWKcQ7Za/+ZQ9ijIj4PGNaY5U2AfQ3FDt
         Jtqze+nO3WDUoR/AxWx7Ftu8ZWzwo5ECxSE0W2eLDS1oTxK+iY4mxVNemVfTIzCAZ6Oi
         v73dBH4BN24PdN/yt6Umu/8Hm7HGltvVTENsjRDtwkHIKX663ofPUhpHMEdCoggJFvJE
         6bK6gAAii3XAjqvxGW0gqiB7L6ImqbRdBDA+5nT7oW4aHznVgQNIgIAU5GUmD4oKSSS/
         ZnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rK/lRSYk0qbxwtkUDAG4yOb3rw3v6oUTvUr8udIrHE8=;
        b=PT5t12AON5kSUEj9+FTBnIJBEHRmO6ea5U3x42G26tGwCxghoPY0eqfpcAoOfN7Y3/
         YUWLSQ1CkvM7/QQLbsIZ1I8M1dc5hRqhOfqNpaTrMnLqx9N+oKNoTl/VNqAoERlnOGvz
         lYAfs3+poMVHu/NZq4HStreOS4oetkvPH8jYReYgsUenannbArd+YNxVnJ1+rm7K4HEV
         z4us8DLyV2HToLR8GqJCsUhVjrCiFmd+HSubkL4cHCnvnMrWwkDnw6A88w2oFunuPEkX
         ygpb77m0+bdzOSAx8yswXVZF2sCPXUJ8iIY56xJZ8lLA6HWnV3lyWXlTqICrnm9RXw8X
         oHwQ==
X-Gm-Message-State: AOAM530ZuN9p61ei1FPu9MIngQI3a0imXbIQIcLI3y637ihO7cun6Sfo
        B/VTegczszLepgUkti3v+Yog0g==
X-Google-Smtp-Source: ABdhPJyUjvxCYYY4p/glROv5L6dVxic7FGGuUAZ5dktxpN3G3iTBNLImeY1GuI7xa+JbsFyOeg6p0Q==
X-Received: by 2002:a05:600c:3d12:b0:38c:a561:f622 with SMTP id bh18-20020a05600c3d1200b0038ca561f622mr13451791wmb.139.1648930293152;
        Sat, 02 Apr 2022 13:11:33 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id n14-20020a7bcbce000000b0038c7776a300sm18769828wmi.0.2022.04.02.13.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 13:11:32 -0700 (PDT)
Date:   Sat, 2 Apr 2022 22:11:30 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 27/33] dt-bindings: crypto: convert rockchip-crypto to
 yaml
Message-ID: <Ykit8n8etuZWGsfY@Red>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-28-clabbe@baylibre.com>
 <3969db0e-50e8-e042-4696-97f56bd38999@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3969db0e-50e8-e042-4696-97f56bd38999@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sat, Apr 02, 2022 at 02:10:21PM +0200, Krzysztof Kozlowski a écrit :
> On 01/04/2022 22:17, Corentin Labbe wrote:
> > Convert rockchip-crypto to yaml
> 
> s/yaml/YAML/
> and a full stop.
> 
> Looks good but please mention in commit msg that the names for clocks
> and resets will be provided in next patch. Otherwise it looks like
> incomplete conversion.

Hello

I forgot clock-names in this patch, i will fix that (and other comments) in v5.

Thanks

> 
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 59 +++++++++++++++++++
> >  .../bindings/crypto/rockchip-crypto.txt       | 28 ---------
> >  2 files changed, 59 insertions(+), 28 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > new file mode 100644
> > index 000000000000..66db671118c3
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > @@ -0,0 +1,59 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Rockchip Electronics And Security Accelerator
> 
> Remove "And". It looks like company name is the name of the hardware.
> 
> Best regards,
> Krzysztof

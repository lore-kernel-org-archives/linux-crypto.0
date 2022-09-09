Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4223AECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 08:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiIII6B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 04:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiIII50 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 04:57:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CBFA1D0F
        for <linux-crypto@vger.kernel.org>; Fri,  9 Sep 2022 01:57:06 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c11so1570062wrp.11
        for <linux-crypto@vger.kernel.org>; Fri, 09 Sep 2022 01:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=rHPt+Pbc0bwJycb8g2JrUPaT739qQsbXoj9p9DUlASE=;
        b=o8/U+pWZQB+BK2sQxVVXYhAtmR4twA2BIVHdD3qEUSTRXfTJet6ivAh/aa0kvfqXEP
         en7ejU3nOu4bQP6vZpt50O7hMAYuCNjbSyl+Fa89NpV4Uy7Esi4TN4YFK/rH3VWPAH7P
         9Ei7dmjS3X1tO9Pz5sxHqw8caG2m5uY4X2GGynE9KsZFWpqSIUVZMXz+V8FBPPp8iE/b
         jKXvos0xjGCtBk/9THaZM1g5m8Dz6skfbkxP1TdHKCHd5Lru3SgjUnu7sqZXzGV6Eb1h
         VfleTZ5RUJB6ZF7/NKUdrty0fGbKxEfl4I/63IWGo7vRairVqhSMFZFiuWfawbo9FaJr
         atlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rHPt+Pbc0bwJycb8g2JrUPaT739qQsbXoj9p9DUlASE=;
        b=STXCW9JCp1m7wmvZGxHXabfsxBCCYt8KF2VXTaXO3gloT3G7MYMGB9wjD7niv87lAF
         6jRlxB9DMO08z2A51+Th7VKrZm6SM2zbXNTttYYmh46fmVX/uhRPLkA3nk3qvTbOcD6d
         Cgux2TX6tn/0VcDDgUXbzEAAGPEiGRGjj5WNiYdJuXDRpTWWzhPUuJsBMpkEHXjw+ZKf
         4su7+aDyi3wENItg6T4d9hOTlZ3KpUShvjlOSNmlmWJ7M1JPpAU98TaGsmHYcz+gfXVm
         SDdyjFa+Yl/QF6juvMJJFWcSL/DdTrZciiZy8XeLPBu1ZzQAeDJM4nSbIPkazu6xiCIE
         Jngg==
X-Gm-Message-State: ACgBeo0HXcxlYsk/aEAZIbeHgO8Rzk0qe3B0obEu0mSPhI/KixAzlCX9
        FhHFS1N7ZCwFMB5zm2xwUrxZ+Q==
X-Google-Smtp-Source: AA6agR6zK39Nn38XEAPq9Ou9Er2T2ugG1x2dP6ckDfLlUnVh5tdCyv2sC6o38IAapwEnt34CuzxuKA==
X-Received: by 2002:adf:e904:0:b0:228:e0d5:2c55 with SMTP id f4-20020adfe904000000b00228e0d52c55mr7254035wrm.714.1662713824642;
        Fri, 09 Sep 2022 01:57:04 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id f25-20020a1c6a19000000b003a5ffec0b91sm1166157wmc.30.2022.09.09.01.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 01:57:04 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:57:01 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Rob Herring <robh@kernel.org>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH v9 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Message-ID: <Yxr/3RjQs9x2KqL7@Red>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
 <20220901125710.3733083-26-clabbe@baylibre.com>
 <20220907203853.GA288174-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220907203853.GA288174-robh@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, Sep 07, 2022 at 03:38:53PM -0500, Rob Herring a écrit :
> On Thu, Sep 01, 2022 at 12:57:02PM +0000, Corentin Labbe wrote:
> > The latest addition to the rockchip crypto driver need to update the
> > driver bindings.
> 
> This sounds like you changed the driver, so change the binding. That 
> would be an ABI break. But it looks like you are adding support for new 
> h/w, so say that. Bindings aren't about a driver.
> 

Hello

Ok, I will change the commit log.

> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 79 +++++++++++++++++--
> >  1 file changed, 71 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > index 8a219d439d02..b7870a4cbdbe 100644
> > --- a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > @@ -13,6 +13,8 @@ properties:
> >    compatible:
> >      enum:
> >        - rockchip,rk3288-crypto
> > +      - rockchip,rk3328-crypto
> > +      - rockchip,rk3399-crypto
> >  
> >    reg:
> >      maxItems: 1
> > @@ -21,21 +23,82 @@ properties:
> >      maxItems: 1
> >  
> >    clocks:
> > +    minItems: 3
> >      maxItems: 4
> >  
> >    clock-names:
> > -    items:
> > -      - const: aclk
> > -      - const: hclk
> > -      - const: sclk
> > -      - const: apb_pclk
> > +    minItems: 3
> > +    maxItems: 4
> >  
> >    resets:
> > -    maxItems: 1
> > +    minItems: 1
> > +    maxItems: 3
> >  
> >    reset-names:
> > -    items:
> > -      - const: crypto-rst
> > +    minItems: 1
> > +    maxItems: 3
> > +
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: rockchip,rk3288-crypto
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 4
> > +        clock-names:
> > +          items:
> > +            - const: aclk
> > +            - const: hclk
> > +            - const: sclk
> > +            - const: apb_pclk
> > +        resets:
> > +          maxItems: 1
> > +        reset-names:
> > +          items:
> > +            - const: crypto-rst
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: rockchip,rk3328-crypto
> > +    then:
> > +      properties:
> > +        clocks:
> > +          maxItems: 3
> > +        clock-names:
> > +          items:
> > +            - const: hclk_master
> > +            - const: hclk_slave
> > +            - const: sclk
> 
> Do we really need new names? Was 'aclk' not the bus master clock?

I follow name convention from dt-bindings/clock/rk3328-cru.h

> 
> If the clocks and resets aren't the same, then maybe these 2 new chips 
> should be their own binding.

I dont understand what you mean ?
You mean having a rk3288-crypto.yaml and a rk3328-crypto.yaml (which will be related to the same driver) ?

> > +        resets:
> > +          maxItems: 1
> > +        reset-names:
> > +          items:
> > +            - const: crypto-rst
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: rockchip,rk3399-crypto
> > +    then:
> > +      properties:
> > +        clocks:
> > +          maxItems: 3
> > +        clock-names:
> > +          items:
> > +            - const: hclk_master
> > +            - const: hclk_slave
> > +            - const: sclk
> > +        resets:
> > +          minItems: 3
> > +        reset-names:
> > +          items:
> > +            - const: rst_master
> > +            - const: rst_slave
> 
> 'rst_' is redundant, drop.
> 

I will fix it

Thanks for the review

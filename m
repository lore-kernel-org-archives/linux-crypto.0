Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9D3C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Mar 2022 10:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiCRKVY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Mar 2022 06:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiCRKVX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Mar 2022 06:21:23 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF121EDA1B
        for <linux-crypto@vger.kernel.org>; Fri, 18 Mar 2022 03:20:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso4554895wmz.4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Mar 2022 03:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YYBm1RX0czLMaWTTQInKeCgdVYhgkLcZ7jFkas/Rfhs=;
        b=AUl19gddWU+TGkn91rwswKtkRuunsoS1xg6IvUppECEb8oSzjSfXJv2d87cqXYs3Yy
         95nkaF7kHo7GBGVTNaBNkuO6Rp5JM8YHyT8tVX8NcbKasWURoUqgjvOhVr+6gsjwxf67
         6VqySP3QaYydQWitA3XNyI6fTecEOPfuXE2b/2PqMFm9CN17Tvi8nhCUC2lm71oY1H+o
         2GWqd42sqZxKapISXzA8vBpYH53HlV8UMGJz1fKwf0WuqukOHYuMyfohAKbTkm1O00uV
         wU2oONr93WQy0UguF3b7ebHHu3pc+OUgVdXyQBp284tjYnM5VG8acVPte/GGuH+vp6P+
         tK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YYBm1RX0czLMaWTTQInKeCgdVYhgkLcZ7jFkas/Rfhs=;
        b=xUMxTOK1kkQvjLboNCP+GovC2+fe0FNkcLh5Z1kUmMlGNqsLHPJ64DvvpRF4xI2xex
         0IXzQxKGermouYEPo9gE80UnqY90uJNShax0b0XPTYHEZagIDUwPtKKQwANG7WXIjhHS
         jWkx9xP8YMMU9wQsGTqPjmqkc+MSG8fY2ECpacfl7/thCTW7gwGTnwreTbUQojjRQwAV
         jOrqB67z1WtEQPtn/9AgfRNpRGPpn9EoKMzjCnQO1DaTcSGXKtnxlWnxWCA/jZ3dd54P
         7Op61Goc/xDhUWaGEpW5bLT9UAuIG137a0jT2K8PACzUJYOQn/D4613VxroDRTsCaV3A
         oKkg==
X-Gm-Message-State: AOAM531GXVPhdyGJxN0/y7xqghhyIxDsfGhxI9ndB6NYdaOeGUkRuxTE
        0sPuJMpJZQKrL1WndGwNbF92wA==
X-Google-Smtp-Source: ABdhPJykd7CP6qm5/RS39Zs+vu5rb4PuIDjEBZiEVPnAb1oCr3QXbjSKOIF+Kzx93wjR66zRLBNlTA==
X-Received: by 2002:a7b:c7c3:0:b0:389:cbf1:fadf with SMTP id z3-20020a7bc7c3000000b00389cbf1fadfmr15021009wmk.147.1647598802494;
        Fri, 18 Mar 2022 03:20:02 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id f10-20020adffcca000000b00203e6a34d3esm5889436wrs.99.2022.03.18.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 03:20:01 -0700 (PDT)
Date:   Fri, 18 Mar 2022 11:20:00 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     heiko@sntech.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        robh+dt@kernel.org, krzysztof.kozlowski@canonical.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Subject: Re: [PATCH v3] dt-bindings: crypto: convert rockchip-crypto to yaml
Message-ID: <YjRc0Cf8m/kpcwAQ@Red>
References: <20220211115925.3382735-1-clabbe@baylibre.com>
 <f078ac6f-5605-7b86-5734-cbbf7dc52c71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f078ac6f-5605-7b86-5734-cbbf7dc52c71@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Feb 15, 2022 at 03:07:56PM +0100, Johan Jonker a écrit :
> Hi Heiko,
> 
> On 2/11/22 12:59, Corentin Labbe wrote:
> > Convert rockchip-crypto to yaml
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > Changes since v1:
> > - fixed example
> > - renamed to a new name
> > - fixed some maxItems
> > 
> > Change since v2:
> > - Fixed maintainers section
> > 
> >  .../crypto/rockchip,rk3288-crypto.yaml        | 66 +++++++++++++++++++
> >  .../bindings/crypto/rockchip-crypto.txt       | 28 --------
> >  2 files changed, 66 insertions(+), 28 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> 
> rockchip,crypto.yaml
> 
> >  delete mode 100644 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > new file mode 100644
> > index 000000000000..2e1e9fa711c4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> > @@ -0,0 +1,66 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/rockchip,rk3288-crypto.yaml#
> 
> rockchip,crypto.yaml
> 
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Rockchip Electronics And Security Accelerator
> > +
> > +maintainers:
> > +  - Heiko Stuebner <heiko@sntech.de>
> > +
> > +properties:
> > +  compatible:
> 
>     oneOf:
>       - const: rockchip,rk3288-crypto
>       - items:
>           - enum:
>               - rockchip,rk3228-crypto
>               - rockchip,rk3328-crypto
>               - rockchip,rk3368-crypto
>               - rockchip,rk3399-crypto
>           - const: rockchip,rk3288-crypto
> 
> rk3288 was the first in line that had support, so we use that as fall
> back string.
> 
> > +    const: rockchip,rk3288-crypto
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    items:
> > +      - description: clock data
> > +      - description: clock data
> > +      - description: clock crypto accelerator
> 
> > +      - description: clock dma
> 
> remove ???
> 
> > +
> > +  clock-names:
> > +    items:
> > +      - const: aclk
> > +      - const: hclk
> > +      - const: sclk
> 
> > +      - const: apb_pclk
> 
> remove ???
> 
> Similar to the rk3568 pclk_xpcs discussion ACLK_DMAC1 belongs to the
> dmac_bus_s node and should have been enabled by the DMA driver I think.
> Could you advise if this is correct or should we remove parsing/enabling
> ACLK_DMAC1 in rk3288_crypto.c in order to it easier
> porting/adding/syncing nodes for other SoC types?
> 
> Johan
> 

Hello

I came back on this as I got access to a rk3288-miqi, and crypto does not work at all.
This is due to ACLK_DMAC1 not being enabled.

While not touching it work on rk3399 and rk3328, rk3288 seems to need it.

Probably the DMA controller goes to sleep under PM.

Any idea on how to create a dependency so dma controller does not sleep ?

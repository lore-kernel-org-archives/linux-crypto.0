Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933F1C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 22:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BFC61355
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 22:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhESWFp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 18:05:45 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:37387 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhESWFp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 18:05:45 -0400
Received: by mail-ot1-f51.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so13125083otp.4;
        Wed, 19 May 2021 15:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Qxjx7gPKuv7WGl/fdRuh5TjzSYI1WNwx1W5A71DrYw=;
        b=LF66X4cfA6qJf6mkXYQ4yxn/q0MiaIFHpOmLDRxVHBz7UhP2H9RGHQrA2HbzURBw8X
         9cRlcplZ0ljdbxmJdLDF1C0WJ8XjSD1EiV10zAJcDTR6jtT1EknwIznrSeh3TgkoUDox
         KB/BQtgPtM+iygGlw5MknOKWwWMKNVGHOSE/o3PouJsLBPNLYsCqSsjmVrcFocJWFJXN
         jF4UHgmV+xd2MdvhBBYvFEQytCg6A1IRkqnsL8QHmxtydjbwuIurHEgQcmy0HdvsM46+
         BP6fncTTwzHe0DS/N3ycWEW7aTbOidXWrJH+ERh1pIBOFhCcDlFswU/CHSq1AuuSNCz0
         9h7w==
X-Gm-Message-State: AOAM530Q12xz+GdsYeG4RUiGmzdnngKltjBM/ihuqnw8MbMC2Fbuj+mr
        qzhD9k70NqRAfe4kQfWvPg==
X-Google-Smtp-Source: ABdhPJxNQG8BfqDgptett9J/WmF6f63g6IaewjwZ5C5UO1H0AxgNr1cBxWbDBUOwYk8H8qTcx7FSGg==
X-Received: by 2002:a9d:57cd:: with SMTP id q13mr1384580oti.23.1621461863492;
        Wed, 19 May 2021 15:04:23 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x31sm228279ota.24.2021.05.19.15.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 15:04:22 -0700 (PDT)
Received: (nullmailer pid 3741422 invoked by uid 1000);
        Wed, 19 May 2021 22:04:21 -0000
Date:   Wed, 19 May 2021 17:04:21 -0500
From:   Rob Herring <robh@kernel.org>
To:     Fabien Parent <fparent@baylibre.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, mkorpershoek@baylibre.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: rng: mediatek: convert to yaml schema
Message-ID: <20210519220421.GA3738290@robh.at.kernel.org>
References: <20210518112250.2146819-1-fparent@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518112250.2146819-1-fparent@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 01:22:49PM +0200, Fabien Parent wrote:
> Convert the RNG binding for MediaTek to use YAML schema.
> 
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
>  .../devicetree/bindings/rng/mtk-rng.txt       | 22 --------
>  .../devicetree/bindings/rng/mtk-rng.yaml      | 53 +++++++++++++++++++
>  2 files changed, 53 insertions(+), 22 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> deleted file mode 100644
> index dfdcb5cd2ea8..000000000000
> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -Device-Tree bindings for Mediatek random number generator
> -found in MediaTek SoC family
> -
> -Required properties:
> -- compatible	    : Should be
> -			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
> -			"mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
> -			"mediatek,mt7623-rng" : for MT7623
> -			"mediatek,mt8516-rng", "mediatek,mt7623-rng" : for MT8516
> -- clocks	    : list of clock specifiers, corresponding to
> -		      entries in clock-names property;
> -- clock-names	    : Should contain "rng" entries;
> -- reg 		    : Specifies base physical address and size of the registers
> -
> -Example:
> -
> -rng: rng@1020f000 {
> -	compatible = "mediatek,mt7623-rng";
> -	reg = <0 0x1020f000 0 0x1000>;
> -	clocks = <&infracfg CLK_INFRA_TRNG>;
> -	clock-names = "rng";
> -};
> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.yaml b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> new file mode 100644
> index 000000000000..d9731f0ae47d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.yaml
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/rng/mtk-rng.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: MediaTek Random number generator
> +
> +maintainers:
> +  - Sean Wang <sean.wang@mediatek.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - mediatek,mt7623-rng
> +      - items:
> +          - const: mediatek,mt7622-rng
> +          - const: mediatek,mt7623-rng
> +      - items:
> +          - const: mediatek,mt7629-rng
> +          - const: mediatek,mt7623-rng
> +      - items:
> +          - const: mediatek,mt8516-rng
> +          - const: mediatek,mt7623-rng

The last 3 can be:

- items:
    - enum:
        - mediatek,mt7622-rng
        - mediatek,mt7629-rng
        - mediatek,mt8516-rng
    - const: mediatek,mt7623-rng

> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: rng
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/mt2701-clk.h>
> +    rng: rng@1020f000 {
> +            compatible = "mediatek,mt7623-rng";
> +            reg = <0x1020f000 0x1000>;
> +            clocks = <&infracfg CLK_INFRA_TRNG>;
> +            clock-names = "rng";
> +    };
> -- 
> 2.31.1
> 

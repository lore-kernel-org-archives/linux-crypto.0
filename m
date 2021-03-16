Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2579AC433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 22:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8A1464F8A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 22:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCPWGW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Mar 2021 18:06:22 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:34833 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhCPWGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Mar 2021 18:06:02 -0400
Received: by mail-il1-f180.google.com with SMTP id h18so14194031ils.2;
        Tue, 16 Mar 2021 15:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+25j3LtI83/Mlwrw+Su7Sg0G8Kk4KU5YFjDf73z7Tc=;
        b=Sn7PgJaeMZd7MTUi9JeSg0KIOTkhE1yzzFCXrb2MTqxWEzr54CuCTEwTSqKtahkNpH
         tlv6pdvFXcUKjKsp3sfX6AyACYnYpAaLuWw9NzVguTzY9LN6tX+smRmO6eA7Uq6f7Iqb
         9Od5S0jgh+IJmAuNLpCo12ejZQRia0BwcyrdOCwJWskbHaee2q0V51XWxMJiZ92yNJXI
         eEBN0VpJP1yFFBGJImYRzmXwO271UzTtgkHi4W17/L1JRLK1mPQfOTyUTTK66XsLzzRu
         kXc12ayftq++3GiVfsPhvZtf5pjVKSmxnu30Kf/H2xtueugnTzgObEo3ZOEER2DT4lAU
         +MWQ==
X-Gm-Message-State: AOAM532yxHmGamJGzR/FVpt0dgQauyaMPIj34gvF0SIs3Ai4yknLkPDJ
        gNJ6nfBYhPcXmhZyixdrGw==
X-Google-Smtp-Source: ABdhPJw8gqo3WwzUPjdGontwxsD24GlSGV/KjNJ/XjEoHTx6WbbUHwUt3bW0rpGvbcl6dFfqE/09tA==
X-Received: by 2002:a92:c24a:: with SMTP id k10mr5330643ilo.284.1615932362354;
        Tue, 16 Mar 2021 15:06:02 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id a5sm10125189ilk.14.2021.03.16.15.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 15:06:01 -0700 (PDT)
Received: (nullmailer pid 3762495 invoked by uid 1000);
        Tue, 16 Mar 2021 22:05:58 -0000
Date:   Tue, 16 Mar 2021 16:05:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kishon Vijay Abraham <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>
Subject: Re: [PATCH v1 1/3] dt-bindings: crypto: ti,sa2ul: Add new compatible
 for AM64
Message-ID: <20210316220558.GA3754419@robh.at.kernel.org>
References: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
 <20210308202005.243228-2-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308202005.243228-2-vaibhavgupta40@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 09, 2021 at 01:50:03AM +0530, Vaibhav Gupta wrote:
> From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Add the AM64 version of sa2ul to the compatible list.
> 
> [v_gupta@ti.com: Conditional dma-coherent requirement, clocks]
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 40 +++++++++++++++----
>  1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> index 1d48ac712b23..6eb9acd564c2 100644
> --- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> @@ -14,6 +14,7 @@ properties:
>      enum:
>        - ti,j721e-sa2ul
>        - ti,am654-sa2ul
> +      - ti,am64-sa2ul
>  
>    reg:
>      maxItems: 1
> @@ -45,19 +46,44 @@ properties:
>      description:
>        Address translation for the possible RNG child node for SA2UL
>  
> +  clocks:
> +    items:
> +      - description: Clock used by PKA
> +      - description: Main Input Clock
> +      - description: Clock used by rng
> +
> +  clock-names:
> +    items:
> +      - const: pka_in_clk
> +      - const: x1_clk
> +      - const: x2_clk
> +
>  patternProperties:
>    "^rng@[a-f0-9]+$":
>      type: object
>      description:
>        Child RNG node for SA2UL
>  
> -required:
> -  - compatible
> -  - reg
> -  - power-domains
> -  - dmas
> -  - dma-names
> -  - dma-coherent
> +if:
> +  properties:
> +    compatible:
> +      const: ti,am64-sa2ul
> +then:
> +  required:
> +    - compatible
> +    - reg
> +    - power-domains
> +    - dmas
> +    - dma-names
> +
> +else:
> +  required:
> +    - compatible
> +    - reg
> +    - power-domains
> +    - dmas
> +    - dma-names
> +    - dma-coherent

The only difference is 'dma-coherent'. You can simplify the if/then to 
just that.

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4495FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 04:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D5664E12
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 04:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCQEUU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 00:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhCQET7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 00:19:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6CFC06174A;
        Tue, 16 Mar 2021 21:19:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e2so143655pld.9;
        Tue, 16 Mar 2021 21:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=noDJG0O0IWEUpmFsatAS1NpPqP7TLehQO6ORX+ZK5tM=;
        b=oBwzozzmcjkKAvkdms978WNvR1tQsctTxIP7gml9zFve7PpQjIAb1sRL8CAn8CWRzV
         St98yTgzgcST5WgxdZSRgvmjCXnFZsjrYRkGoPCRHN6vAAFKuTbiaOCT20rYmstMCK86
         xZ3ZfBJA7m2a3pOsiFmFgpeGWcmY2geOD9u/V6Ulvl8iNQRCETP7kotgSww2nouvuNC8
         IQwRyRfAtnhHTB6+PTmPazcPkxEoM8IsXEXQM8+td2u1TptFNUK20mcKJDnAI+ruWubg
         rbKcJjoLFs68Vrp743SuF253exwbAuIh5raIAC1pZZ3SzEoqo1wQrx2Rh+J0eKmXSyXF
         bVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=noDJG0O0IWEUpmFsatAS1NpPqP7TLehQO6ORX+ZK5tM=;
        b=nKKUtkL1xkaXcjsfYmZHO8Ym5UgY/SSuGlq1SZ9jWu5l/w/3YyBR79ltA1FTNi6nry
         rToN2+MazbrGFKq0HRsuwFuXULAO/+9yuCPBG/wSKUU2+GSLasfy78Dy4S4HUEFfwSl/
         btetPT2nbJ60P0ZZXdP2HCJTB6f68RQwoM+isIFBjQAD8zT+Tde+to32m0DKzUg9GquA
         W+uzqGZXTbYRVlQBvmau5lSd74cH010peWAE1faEHKPywZFdFRN9eAcLuJjuhHAK+o3+
         iGLdIbgYUmPX2CYPEr0hPbSXEdU503sUxK+DksTG87ho5FdfMz5DrWsSK8tCYYSWymHv
         nm+Q==
X-Gm-Message-State: AOAM531jZ929xUw9VFCQCGsSEJXj0bj/pPjaiD5JglSW0hu1tV3QOIg+
        iv0nlG8hqYHn2twYFJV2o/k=
X-Google-Smtp-Source: ABdhPJwa3SHLOa4Wkp8GeGZGva9TAEJOLKujkktaI8Jk+f83RKA50I65StFDtJsgveRzR7Y3NVSe3Q==
X-Received: by 2002:a17:902:a406:b029:e6:78c4:71c8 with SMTP id p6-20020a170902a406b02900e678c471c8mr2637410plq.17.1615954799008;
        Tue, 16 Mar 2021 21:19:59 -0700 (PDT)
Received: from gmail.com ([223.179.156.119])
        by smtp.gmail.com with ESMTPSA id o18sm844046pji.10.2021.03.16.21.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 21:19:58 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:46:32 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Rob Herring <robh@kernel.org>
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
Message-ID: <YFGCoMk7Kemrwizc@gmail.com>
References: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
 <20210308202005.243228-2-vaibhavgupta40@gmail.com>
 <20210316220558.GA3754419@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210316220558.GA3754419@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 16, 2021 at 04:05:58PM -0600, Rob Herring wrote:
> On Tue, Mar 09, 2021 at 01:50:03AM +0530, Vaibhav Gupta wrote:
> > From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > 
> > Add the AM64 version of sa2ul to the compatible list.
> > 
> > [v_gupta@ti.com: Conditional dma-coherent requirement, clocks]
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
> > ---
> >  .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 40 +++++++++++++++----
> >  1 file changed, 33 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> > index 1d48ac712b23..6eb9acd564c2 100644
> > --- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> > @@ -14,6 +14,7 @@ properties:
> >      enum:
> >        - ti,j721e-sa2ul
> >        - ti,am654-sa2ul
> > +      - ti,am64-sa2ul
> >  
> >    reg:
> >      maxItems: 1
> > @@ -45,19 +46,44 @@ properties:
> >      description:
> >        Address translation for the possible RNG child node for SA2UL
> >  
> > +  clocks:
> > +    items:
> > +      - description: Clock used by PKA
> > +      - description: Main Input Clock
> > +      - description: Clock used by rng
> > +
> > +  clock-names:
> > +    items:
> > +      - const: pka_in_clk
> > +      - const: x1_clk
> > +      - const: x2_clk
> > +
> >  patternProperties:
> >    "^rng@[a-f0-9]+$":
> >      type: object
> >      description:
> >        Child RNG node for SA2UL
> >  
> > -required:
> > -  - compatible
> > -  - reg
> > -  - power-domains
> > -  - dmas
> > -  - dma-names
> > -  - dma-coherent
> > +if:
> > +  properties:
> > +    compatible:
> > +      const: ti,am64-sa2ul
> > +then:
> > +  required:
> > +    - compatible
> > +    - reg
> > +    - power-domains
> > +    - dmas
> > +    - dma-names
> > +
> > +else:
> > +  required:
> > +    - compatible
> > +    - reg
> > +    - power-domains
> > +    - dmas
> > +    - dma-names
> > +    - dma-coherent
> 
> The only difference is 'dma-coherent'. You can simplify the if/then to 
> just that.
Hello Rob,

I agree with your point. But with that case we will have to modify/append the
'required' list. Something like:

	if !(properties.compatible == 'ti,am64-sa2ul')
		required += dma-coherent

I even tried to use anchors but that didn't help. I didn't find it even in
examples. Any hint how to achieve that?

Thanks,
Vaibhav

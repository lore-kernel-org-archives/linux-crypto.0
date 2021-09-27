Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCE9C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 18:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA0B60FC0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhI0Sjx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:39:53 -0400
Received: from mail-oo1-f41.google.com ([209.85.161.41]:35557 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbhI0Sjw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 14:39:52 -0400
Received: by mail-oo1-f41.google.com with SMTP id v17-20020a4ae051000000b002b5a56e3da3so1867787oos.2;
        Mon, 27 Sep 2021 11:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bzE3NFQakBtNDfzrxu6kIodjRxQ5ysRHLsV7DCjs9zk=;
        b=KMV0Hj9JMSiCvlPI+NTTRcnosJVcay0KFiml7pNG1lPdCaaFR+x05Y6H9baK8JjT+r
         1CtxRavTm3lDh7nHdGLk6QVSnBdxCI2k7OYcAiU9nSE3HbgH85vwWiNeRw9adeEBVEFn
         NWZfZvrcXkoO/fwN3iPYq0csWfnBCYbFbzfnPBO+bBSlkVbuzMZXkhbdkHMKxTRIAr5T
         vpip0Ns7g+6tpN0q20jg81cVsoDP/qArX7ucjSNqKP2GTSz7CzxBlRbCO10V2HrKJAxZ
         wa3H5EAgkVfRgKFEAdd4RhQ3c9cLUrvdnpu6QpqdtTc7cBlric9ovF0680+QsuKJ6x7D
         jzUg==
X-Gm-Message-State: AOAM533/8IZPoAEECUWA4hno5iCvDxx0eaoTMogs+1XRikhHOcKukVNE
        sCkEfV6WwDIGjYmFoEMlvc6ygbNJdw==
X-Google-Smtp-Source: ABdhPJxvwVQpqQm1RaOFMgo+Y51ooncOgu46oOLE54vosi342Afm1UxnSbqBuXtY1g89Z5wISLkBfA==
X-Received: by 2002:a4a:bd8a:: with SMTP id k10mr1147640oop.41.1632767894213;
        Mon, 27 Sep 2021 11:38:14 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id f17sm4430383ook.9.2021.09.27.11.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:38:13 -0700 (PDT)
Received: (nullmailer pid 3612549 invoked by uid 1000);
        Mon, 27 Sep 2021 18:38:12 -0000
Date:   Mon, 27 Sep 2021 13:38:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jayesh Choudhary <j-choudhary@ti.com>
Cc:     linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-crypto@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: rng: convert OMAP and Inside-Secure
 HWRNG to yaml schema
Message-ID: <YVIPlJ6jlpnDOEUF@robh.at.kernel.org>
References: <20210922085203.2547-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922085203.2547-1-j-choudhary@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 22 Sep 2021 14:22:03 +0530, Jayesh Choudhary wrote:
> Converts the RNG bindings for OMAP SoCs and Inside-Secure
> HWRNG modules to YAML schema.
> 
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
> Changelog:
> v2:
> - modified the license-identifier
> - modified 'clock-names' property
> 
>  .../devicetree/bindings/rng/omap_rng.txt      | 38 --------
>  .../devicetree/bindings/rng/omap_rng.yaml     | 93 +++++++++++++++++++
>  2 files changed, 93 insertions(+), 38 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/omap_rng.yaml
> 

Applied, thanks!

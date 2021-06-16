Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092E4C48BE8
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 15:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14D3611CE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 15:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhFPPIe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 11:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbhFPPIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 11:08:32 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706C3C061574
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 08:06:25 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f84so3565661ybg.0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WnfyWeDtfp9wJ03e/Pygdz8GkYlJkHUmw4KuNZkZtsI=;
        b=p3V/tsAvBKNW1/fLQw1cxjbLxmkzY+NCFM6sFUd5MYQR/I99nfYHtTeZ6GX29HX2fP
         7B98Hz0iPFw7ln3a7oZUSV0D7wBHs3Nx8bP1yD75PLFbtaitHUMldchawAE3t6u9Gr4D
         +thcqYz5DsdBNhUKylMKadu7gU+x9Y8f2HR9pkqCG44mo9Eiw3E0Ef0UBgaALPUnEwZM
         OMSgYp3yI11h4BO8U2bJwEZbzXXy3AGA4tyIzRoWlJw5Et2h2p95BbZaXl2/0i99CK6D
         VK4iEQKVOgzlpWTXxuWr4K4Kh5NwNdhEEHtoPFEUOX+aMGa4KVLNyO/kl/oNBYMPHM53
         BQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WnfyWeDtfp9wJ03e/Pygdz8GkYlJkHUmw4KuNZkZtsI=;
        b=oXikfcVNYZG085hbjdblfJZCqVno+1bnFPYKo34g6EEr0JHX0ySA/TA/qtRil5F8or
         Zb59qE26/M7uCMT1iFMfQ2/vNwTOBZTAYZe4M4kVyG1yp/xJSLTMRT7l6qpcM0C53C89
         0OGwKI+RoX3F9vCOvrdi8YEplm0LJ0JMJnZSi1XIi0PYzly555BE8Z0bV/B0FwZ9rdKt
         4a2s753kRK1ZiFIbFYwg5q13VWkW2uOsSKyZ8zRclnP00G30Nay1mmql+yg7TJlwTGO2
         5AxQf5HcnBrl7vWOg+sY2dgVvVL/X7OgACIR3jpAlIZsMCZJFySMrEEc/X7pHYyMlUeK
         SxXQ==
X-Gm-Message-State: AOAM530h3T8McdbV8J2h78bmtMyg5Cfk2k3eBJwpXYHRccgL83iuyEac
        1E7MvJ25SsmJNvjg4ZTIju8VvxoQXBP0Iqsq811VBlxYpaM=
X-Google-Smtp-Source: ABdhPJxsvfFKJlCl0Fv1Q0JQBOSrY9fTTPwXdoG5i6bwF+xZjcAotFA7K4MfWyuapR5FEhTmK4mSmAAff0KtXHI/vxk=
X-Received: by 2002:a25:8088:: with SMTP id n8mr196816ybk.375.1623855984676;
 Wed, 16 Jun 2021 08:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <b4e3ac1e393dd3ec9d6086e3d216bf9d0fdfc0e8.1623835679.git.geert+renesas@glider.be>
In-Reply-To: <b4e3ac1e393dd3ec9d6086e3d216bf9d0fdfc0e8.1623835679.git.geert+renesas@glider.be>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 16 Jun 2021 18:06:13 +0300
Message-ID: <CAOtvUMcJzide=sinBSMGocKhyErECE3e0H-KGDX9RhXHeVhK4w@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: crypto: ccree: Convert to json-schema
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 16, 2021 at 12:29 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> Convert the Arm TrustZone CryptoCell cryptographic engine Device Tree
> binding documentation to json-schema.
>
> Document missing properties.
> Update the example to match reality.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Use "SPDX-License-Identifier: GPL-2.0", as requested by Gilad.

Acked-by: Gilad Ben Yossef <gilad@benyossef.com>



> ---
>  .../bindings/crypto/arm,cryptocell.yaml       | 53 +++++++++++++++++++
>  .../bindings/crypto/arm-cryptocell.txt        | 25 ---------
>  2 files changed, 53 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/arm,cryptoce=
ll.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/arm-cryptoce=
ll.txt
>
> diff --git a/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml=
 b/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml
> new file mode 100644
> index 0000000000000000..b8331863ee754988
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/arm,cryptocell.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Arm TrustZone CryptoCell cryptographic engine
> +
> +maintainers:
> +  - Gilad Ben-Yossef <gilad@benyossef.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - arm,cryptocell-713-ree
> +      - arm,cryptocell-703-ree
> +      - arm,cryptocell-712-ree
> +      - arm,cryptocell-710-ree
> +      - arm,cryptocell-630p-ree
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  dma-coherent: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    arm_cc712: crypto@80000000 {
> +            compatible =3D "arm,cryptocell-712-ree";
> +            reg =3D <0x80000000 0x10000>;
> +            interrupts =3D <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +    };
> diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt =
b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> deleted file mode 100644
> index 6130e6eb4af89135..0000000000000000
> --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -Arm TrustZone CryptoCell cryptographic engine
> -
> -Required properties:
> -- compatible: Should be one of -
> -   "arm,cryptocell-713-ree"
> -   "arm,cryptocell-703-ree"
> -   "arm,cryptocell-712-ree"
> -   "arm,cryptocell-710-ree"
> -   "arm,cryptocell-630p-ree"
> -- reg: Base physical address of the engine and length of memory mapped r=
egion.
> -- interrupts: Interrupt number for the device.
> -
> -Optional properties:
> -- clocks: Reference to the crypto engine clock.
> -- dma-coherent: Present if dma operations are coherent.
> -
> -Examples:
> -
> -       arm_cc712: crypto@80000000 {
> -               compatible =3D "arm,cryptocell-712-ree";
> -               interrupt-parent =3D <&intc>;
> -               interrupts =3D < 0 30 4 >;
> -               reg =3D < 0x80000000 0x10000 >;
> -
> -       };
> --
> 2.25.1
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

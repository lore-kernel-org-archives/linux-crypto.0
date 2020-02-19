Return-Path: <SRS0=xEWH=4H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C770BC5ACC4
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 22:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D7D524656
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 22:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582150008;
	bh=EBrYs+yq3Y3IgDkDMpRFMtEXCjYHbxS6mXBDsELyYe0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0QOz3/+KRO+U/VssIP+2ip/A9Y4WYnQ5sht3zdTVp7Nb4bmRCILCDKULxsKMMJa0v
	 J9bezQIU5GGTRqu/wWjYEUkZHayzjXigub+9VUKhwwsuvSWpy5orja6MPMc+beI3cc
	 +sZejxJT3IaikRamSTXh+E6ueSwDJ5sncnJEs2wA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgBSWGs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Feb 2020 17:06:48 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39991 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSWGs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:48 -0500
Received: by mail-ot1-f67.google.com with SMTP id i6so1722296otr.7;
        Wed, 19 Feb 2020 14:06:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nX8xqwF3vuVz6SMuQkjOYa0QQbZHhMZp1SMRDtGWins=;
        b=ZvSU1+Az2K0yb/QUM2TLLYc660LhCLj9uCqfwnmOP6862jjfu7RO06BqVQusJwouUA
         inGJ6JE7oYcCaoI8kSine2m5wgKbyFeHUT6qlMuSHiY4Nj8Qtvm5vLGziHgsUR480X3m
         /eOzSVU5szMocfIN8vQ7GA//7B/8/mbrRzF/VI6EaRqsTdl0PE3mnNND62OGS0+IrVhG
         O72qr4UGTM/egoolcMm4dJuPt8phIc2yPF8U8eR4Hp+ECugRpX2X86Y5MSE+8CaGCQp8
         +TrOlKON1z3ZLq9QB2kpXfNgP4/FzYfZ0XqmH/zkYevrP/9o5sF5g2eaq3++LfFGSpan
         pixw==
X-Gm-Message-State: APjAAAWC1dIG59hysRTOb8BU3SU0Xx28ruTWo8cVspD7u9PytxuImgOi
        hovEKnOO5sOqBWE7y1xM38OmhJaIKg==
X-Google-Smtp-Source: APXvYqyzDpAsYbjMChkiOsp8vQqnGzBRtPAhURMvfp0Uf1xlLNMzHvlqRbrPr1aAJf+7mljlZu6F6g==
X-Received: by 2002:a9d:6548:: with SMTP id q8mr19241216otl.356.1582150005300;
        Wed, 19 Feb 2020 14:06:45 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z10sm406828oih.1.2020.02.19.14.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 14:06:44 -0800 (PST)
Received: (nullmailer pid 21809 invoked by uid 1000);
        Wed, 19 Feb 2020 22:06:43 -0000
Date:   Wed, 19 Feb 2020 16:06:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?N=EDcolas_F=2E_R=2E_A=2E?= Prado 
        <nfraprado@protonmail.com>
Cc:     devicetree@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: Convert BCM2835 to DT schema
Message-ID: <20200219220643.GA14392@bogus>
References: <20200207231347.2908737-1-nfraprado@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200207231347.2908737-1-nfraprado@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 07, 2020 at 11:14:12PM +0000, Nícolas F. R. A. Prado wrote:
> Convert BCM2835/6368 Random number generator bindings to DT schema.
> 
> Signed-off-by: Nícolas F. R. A. Prado <nfraprado@protonmail.com>
> ---
> 
> Hi,
> wasn't really clear to me who to add as maintainer for this dt-binding.
> The three names added here as maintainers were based on the get_maintainer
> script and on previous commits on this file.
> Please tell me whether these are the right maintainers for this file or not.

Whoever knows the h/w ideally, not who is going to apply patches.

> 
> This patch was tested with:
> make ARCH=arm DT_SCHEMA_FILES=Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml dt_binding_check

You also need to make sure without DT_SCHEMA_FILES set everything is 
fine. That tests the example against all schemas.

> make ARCH=arm DT_SCHEMA_FILES=Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml dtbs_check
> 
> Thanks,
> Nícolas
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.txt  | 40 ------------
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml | 61 +++++++++++++++++++
>  2 files changed, 61 insertions(+), 40 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
> deleted file mode 100644
> index aaac7975f61c..000000000000
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -BCM2835/6368 Random number generator
> -
> -Required properties:
> -
> -- compatible : should be one of
> -	"brcm,bcm2835-rng"
> -	"brcm,bcm-nsp-rng"
> -	"brcm,bcm5301x-rng" or
> -	"brcm,bcm6368-rng"
> -- reg : Specifies base physical address and size of the registers.
> -
> -Optional properties:
> -
> -- clocks : phandle to clock-controller plus clock-specifier pair
> -- clock-names : "ipsec" as a clock name
> -
> -Optional properties:
> -
> -- interrupts: specify the interrupt for the RNG block
> -
> -Example:
> -
> -rng {
> -	compatible = "brcm,bcm2835-rng";
> -	reg = <0x7e104000 0x10>;
> -	interrupts = <2 29>;
> -};
> -
> -rng@18033000 {
> -	compatible = "brcm,bcm-nsp-rng";
> -	reg = <0x18033000 0x14>;
> -};
> -
> -random: rng@10004180 {
> -	compatible = "brcm,bcm6368-rng";
> -	reg = <0x10004180 0x14>;
> -
> -	clocks = <&periph_clk 18>;
> -	clock-names = "ipsec";
> -};
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> new file mode 100644
> index 000000000000..b1621031721e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/brcm,bcm2835.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: BCM2835/6368 Random number generator
> +
> +maintainers:
> +  - Stefan Wahren <stefan.wahren@i2se.com>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Herbert Xu <herbert@gondor.apana.org.au>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - brcm,bcm2835-rng
> +      - brcm,bcm-nsp-rng
> +      - brcm,bcm5301x-rng
> +      - brcm,bcm6368-rng
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    description: phandle to clock-controller plus clock-specifier pair

No need to redefine a common property.

> +    maxItems: 1
> +
> +  clock-names:
> +    const: ipsec
> +
> +  interrupts:
> +    description: specify the interrupt for the RNG block

Same here.

> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    rng {
> +        compatible = "brcm,bcm2835-rng";
> +        reg = <0x7e104000 0x10>;
> +        interrupts = <2 29>;
> +    };
> +
> +  - |
> +    rng@18033000 {
> +        compatible = "brcm,bcm-nsp-rng";
> +        reg = <0x18033000 0x14>;
> +    };
> +
> +  - |
> +    random: rng@10004180 {

Drop the label.

> +        compatible = "brcm,bcm6368-rng";
> +        reg = <0x10004180 0x14>;
> +
> +        clocks = <&periph_clk 18>;
> +        clock-names = "ipsec";
> +    };
> -- 
> 2.25.0
> 
> 

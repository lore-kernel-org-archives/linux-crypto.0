Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7DAC352A3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 20:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85DA21775
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 20:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581022033;
	bh=IKtvLJH3POdpqJGJPZGuuIFX0JHRAm8o5gtj6atoK6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vc2klsaspwGoAIaiuvovyD8m2kG35H+SmsFPNeErCI+rgVmP3aOPFcJDXElCdyVaE
	 8v2JVRh6cnxAbFsWoQtJAwCnap6g3xyX5XlgEVSq1rycY1joySBdFqXe0ku/ffcYxs
	 ol3gwO2Ixx0FTzvs3efCTLTu1l8VuNK/7jB1ONJU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgBFUpq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 15:45:46 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36737 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgBFUpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 15:45:45 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so43447plm.3;
        Thu, 06 Feb 2020 12:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CCWnD6/En746LfUHwkqymcGUcnPpptz2DSpQ1Ez5SOo=;
        b=JbMds/ho9nUpnm8cXEfGvud8BFeLZ9ipAnA4JLFKDUF4BYe3CIWXQOM5gR3m7gzeEA
         1A+pTXVsEPit3pKuf5RnI5UvsfGEsEbcptcYSaKMsNvMcEs7dcEdc4aVdlQmLHrlXU5C
         ueP24f3fTKcZQ0juWY+huACagivPU6mR7mL0bjvDiUnyUy6ZOmu4mkTU7UyT5cCQ5SDh
         rcmQHKvmdqlhtYfxsB+MCOgmqVa6+wRmMm5aWAu3IPxTytIIqjmhbQK9V0j4LM9kL2D0
         C+Gr0wiwyYJek2DPl5GT89WYFxI7Uo15f8OZ9cjSCfkzB1dBkVA06/5DYVv58ZAQTkka
         85qA==
X-Gm-Message-State: APjAAAViT93hNv9dMvBQzcmoLGdPiJogoExPCcAs3nPQhue4p1COiFk/
        Qbjflp+s1dfXaTma6XGtfA==
X-Google-Smtp-Source: APXvYqwe1ExZhSMFyKB8on4CDR61XtJcPmp+HJxgSNnoGXk7d9N9LdjNbUm6Le3nrUv0jQvz1qW0Pw==
X-Received: by 2002:a17:90a:bf0c:: with SMTP id c12mr6380858pjs.112.1581021944891;
        Thu, 06 Feb 2020 12:45:44 -0800 (PST)
Received: from rob-hp-laptop (63-158-47-182.dia.static.qwest.net. [63.158.47.182])
        by smtp.gmail.com with ESMTPSA id c6sm279450pgk.78.2020.02.06.12.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:45:44 -0800 (PST)
Received: (nullmailer pid 25171 invoked by uid 1000);
        Thu, 06 Feb 2020 18:56:51 -0000
Date:   Thu, 6 Feb 2020 18:56:51 +0000
From:   Rob Herring <robh@kernel.org>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Message-ID: <20200206185651.GA14044@bogus>
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com>
 <1580650021-8578-2-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580650021-8578-2-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 02, 2020 at 03:26:59PM +0200, Hadar Gat wrote:
> The Arm CryptoCell is a hardware security engine. This patch adds DT
> bindings for its TRNG (True Random Number Generator) engine.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  .../devicetree/bindings/rng/arm-cctrng.yaml        | 51 ++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/arm-cctrng.yaml b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> new file mode 100644
> index 0000000..fe9422e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> @@ -0,0 +1,51 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license new bindings:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/arm-cctrng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Arm ZrustZone CryptoCell TRNG engine
> +
> +maintainers:
> +  - Hadar Gat <hadar.gat@arm.com>
> +
> +description: |+
> +  Arm ZrustZone CryptoCell TRNG (True Random Number Generator) engine.
> +
> +properties:
> +  compatible:
> +    description: Should be "arm,cryptocell-7x3-trng"

Drop. That's what the schema says.

> +    const: arm,cryptocell-7x3-trng

Is 'x' a wildcard? We don't do wildcards unless you have other ways to 
get the specific version.

> +
> +  interrupts:
> +    description: Interrupt number for the device.

Drop. That's all 'interrupts'.

> +    maxItems: 1
> +
> +  reg:
> +    description: Base physical address of the engine and length of memory
> +                 mapped region.

Drop.

> +    maxItems: 1
> +
> +  rosc-ratio:
> +    description: Sampling ratio values from calibration for 4 ring oscillators.
> +    maxItems: 1

Is this an array?

Needs a vendor prefix, a type ref and any constraints you can come up 
with.
 
> +
> +  clocks:
> +    description: Reference to the crypto engine clock.

How many clocks?

> +
> +required:
> +  - compatible
> +  - interrupts
> +  - reg
> +  - rosc-ratio
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    arm_cctrng: arm_cctrng@60000000 {

rng@...

> +        compatible = "arm,cryptocell-7x3-trng";
> +        interrupts = <0 29 4>;
> +        reg = <0x60000000 0x10000>;
> +        rosc-ratio = <5000 1000 500 0>;
> +    };
> -- 
> 2.7.4
> 

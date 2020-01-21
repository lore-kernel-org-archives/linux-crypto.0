Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4388C32771
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 01:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964A524125
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 01:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="IUMcFpRQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAUBx2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 20:53:28 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33940 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAUBx2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 20:53:28 -0500
Received: by mail-qk1-f195.google.com with SMTP id d10so804726qke.1;
        Mon, 20 Jan 2020 17:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLwWB53t6sz09f9B1uK0zwEN9SxdL7h+I/vAqzXh1rs=;
        b=IUMcFpRQ8vz/Oz098DsJ/MlfrAlkASfp0SYSePY2V0VNezU4rSDADZWDuogLY83ITE
         6qOiftcsBHTGequV+QapUdKtSjbKt+Lu/mUFk4ZyU+XNjiuz67a5JUmyh7cgP3cDXB4u
         h3CtmwJqCqQUK9zrwgIefdFvbNJZ8pnnLyo0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLwWB53t6sz09f9B1uK0zwEN9SxdL7h+I/vAqzXh1rs=;
        b=RFVwYGJeImdSbgdeNHWPVDCP5OayzcCwJ35wPeUFJCEJfr6srXiJDKnSqXXvbcAwVE
         A1Ayxnca7ojSDDmd8mS01uWYIJcCi+Tx+sjgN3mcRZ0l1jCfBNcBlFS93ccAIr3EO40Y
         L69F9o/1p+2eZoniGI51w1dBewdLzHyvS31stD9J9tcf/Xnasvuro4v6MmfRZ/E0az2d
         Ygtyeg2so8fp8cCVFeduOXXcovEHiwjxsSnkh8GOK7kv5QbBC5zQ9KU1qdjQEa461cRB
         fOEnKGSWpl8FtNS+gGAugVWJKUklihxP+q7UDw4qaBf4uK7fqLaawCKssJ2V9JFPKnhR
         sUCQ==
X-Gm-Message-State: APjAAAXNbyniISMoW3E248uLxl3SyOmr97DcoN6Pitg6BuF1/mhoT5RF
        7qtUx54zr7A1uA1nSYQVbhNER0tXYvrRZ/+8AwE=
X-Google-Smtp-Source: APXvYqwu+C+7GEOmDwQMJ1OCXr0L1MJ1vO3XA/YvvHsO/1Pr4qqlLpiL2FeuSh8Rtqj95aStJGWL/5FEIAlw9Nv83x8=
X-Received: by 2002:a37:a43:: with SMTP id 64mr36517qkk.292.1579571606933;
 Mon, 20 Jan 2020 17:53:26 -0800 (PST)
MIME-Version: 1.0
References: <20200120150113.2565-1-linux@neuralgames.com>
In-Reply-To: <20200120150113.2565-1-linux@neuralgames.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 21 Jan 2020 01:53:15 +0000
Message-ID: <CACPK8XfuVN3Q=npEoOP-amQS0-wemxcx6LKaHHZEsBAHzq1wzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] hwrng: Add support for ASPEED RNG
To:     Oscar A Perez <linux@neuralgames.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Mon, 20 Jan 2020 at 15:12, Oscar A Perez <linux@neuralgames.com> wrote:
>
> This minimal driver adds support for the Hardware Random Number Generator
> that comes with the AST2400/AST2500/AST2600 SOCs from AspeedTech.
>
> The HRNG on these SOCs uses Ring Oscillators working together to generate
> a stream of random bits that can be read by the platform via a 32bit data
> register.

Thanks for the patch.

We've been using the timeriomem-rng driver for the past few years on
aspeed hardware. You can see how that's set up by looking at
arch/arm/boot/dts/aspeed-g{4,5,6}.dtsi

I suggest we continue to use the generic driver.

Cheers,

Joel



>
> Signed-off-by: Oscar A Perez <linux@neuralgames.com>
> ---
>  .../devicetree/bindings/rng/aspeed-rng.yaml   | 90 +++++++++++++++++++
>  1 file changed, 90 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/aspeed-rng.yaml
>
> diff --git a/Documentation/devicetree/bindings/rng/aspeed-rng.yaml b/Documentation/devicetree/bindings/rng/aspeed-rng.yaml
> new file mode 100644
> index 000000000000..06070ebe1c33
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/aspeed-rng.yaml
> @@ -0,0 +1,90 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/rng/aspeed-rng.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +
> +title: Bindings for Aspeed Hardware Random Number Generator
> +
> +
> +maintainers:
> +  - Oscar A Perez <linux@neuralgames.com>
> +
> +
> +description: |
> +  The HRNG on the AST2400/AST2500/AST2600 SOCs from AspeedTech  uses four Ring
> +  Oscillators working together to generate a stream of random bits that can be
> +  read by the platform via a 32bit data register every one microsecond.
> +  All the platform has to do is to provide to the driver the 'quality' entropy
> +  value, the  'mode' in which the combining  ROs will generate the  stream  of
> +  random bits and, the 'period' value that is used as a wait-time between reads
> +  from the 32bit data register.
> +
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - aspeed,ast2400-rng
> +              - aspeed,ast2500-rng
> +              - aspeed,ast2600-rng
> +
> +
> +  reg:
> +    description:
> +      Base address and length of the register set of this block.
> +      Currently 'reg' must be eight bytes wide and 32-bit aligned.
> +
> +    maxItems: 1
> +
> +
> +  period:
> +    description:
> +      Wait time in microseconds to be used between reads.
> +      The RNG on these Aspeed SOCs generates 32bit of random data
> +      every one microsecond. Choose between 1 and n microseconds.
> +
> +    maxItems: 1
> +
> +
> +  mode:
> +    description:
> +      One of the eight modes in which the four internal ROs (Ring
> +      Oscillators)  are combined to generate a stream  of random
> +      bits. The default mode is seven which is the default method
> +      of combining RO random bits on these Aspeed SOCs.
> +
> +    maxItems: 1
> +
> +
> +  quality:
> +    description:
> +      Estimated number of bits of entropy per 1024 bits read from
> +      the RNG.  Note that the default quality is zero which stops
> +      this HRNG from automatically filling the kernel's entropy
> +      pool with data.
> +
> +    maxItems: 1
> +
> +
> +required:
> +  - compatible
> +  - reg
> +  - period
> +  - quality
> +
> +
> +examples:
> +  - |
> +    rng: hwrng@1e6e2074 {
> +         compatible = "aspeed,ast2500-rng";
> +         reg = <0x1e6e2074 0x8>;
> +         period = <4>;
> +         quality = <128>;
> +         mode = <0x7>;
> +    };
> +
> +
> +...
> --
> 2.17.1
>

Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_DBL_ABUSE_MALW,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E93C33CAC
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7562420721
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580725924;
	bh=+tclQKs/WNr0VvFV0+aZqL7hnHWDrlqlyWS1+r/kyTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wJl8iHyQpatzNN5J/ug30OZL6+SJGp0iKW6/qwkR9MdEp6IfU3w+obqAwJYnbo+U7
	 hLsic4Y8JTso8uz/x9BFNaJoNNcBTgtLb/cGagbp3396PavkaRH8CYa94tRDHObokK
	 c7cvLrXmkRlnPZ3RAySIPhgEePbognxHRt/uhmz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBCKcE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 05:32:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43192 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgBCKcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 05:32:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id z9so5054607wrs.10;
        Mon, 03 Feb 2020 02:32:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NFuh06mCbIFHLnWl/yp4KwHBKhZRCL1Lbf1jiW0JM98=;
        b=ZuVjPYv/+rlib8L06dwZsEkxJknUcLobQfL9w8OvPwoYQvAcpY3sq/6eJKpt7smvBa
         Ckxro4jxKtPq3kIkzpbgrYv8cFv+lS4yKYBz4fRNnWW3hO2W+zlZiJwd888ts4o4iqV9
         5nQI0gdpHO1pXhRUMVgFJzTbTEkrXY9VloIk6kIf5+DQzy7TZ/FGFt0NJlan2PabCZcm
         l4DZdM6mVC95LZA4KLXykvzlb9saWsmx8fkrQelLmeI2z2FKzRgorb2eqR3Rs6GHGO86
         xSLyBU/8ZXw0fK25p6yj1WRYLMQSKMd91s8QuhyGDYHzipMvG3+aMqleiXsEVmA/IpMR
         d/TA==
X-Gm-Message-State: APjAAAUa4py3qVsaNm9Upu+aF1CIYMYs3TeWrvc/TttRwWWpsQcenBH8
        V669DWt5yYvhAGqsrYd39A==
X-Google-Smtp-Source: APXvYqyQJyScAUAfc7hRV/ni9Ov1rrCOL/vQpSraOmoLvu0hd1vpN6CEC4XJZDRuzYtupTLkxa0YGQ==
X-Received: by 2002:a5d:6445:: with SMTP id d5mr14473037wrw.244.1580725921100;
        Mon, 03 Feb 2020 02:32:01 -0800 (PST)
Received: from rob-hp-laptop ([212.187.182.163])
        by smtp.gmail.com with ESMTPSA id t131sm23233901wmb.13.2020.02.03.02.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 02:32:00 -0800 (PST)
Received: (nullmailer pid 31847 invoked by uid 1000);
        Mon, 03 Feb 2020 10:31:58 -0000
Date:   Mon, 3 Feb 2020 10:31:58 +0000
From:   Rob Herring <robh@kernel.org>
To:     Oscar A Perez <linux@neuralgames.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: Add support for ASPEED RNG
Message-ID: <20200203103158.GA9276@bogus>
References: <20200120150113.2565-1-linux@neuralgames.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120150113.2565-1-linux@neuralgames.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 20, 2020 at 03:01:08PM +0000, Oscar A Perez wrote:
> This minimal driver adds support for the Hardware Random Number Generator
> that comes with the AST2400/AST2500/AST2600 SOCs from AspeedTech.

This patch is not a driver. 'dt-bindings: rng: ...' for the subject. 
(Plus, 2 patches with the same subject is never a good idea.)

> 
> The HRNG on these SOCs uses Ring Oscillators working together to generate
> a stream of random bits that can be read by the platform via a 32bit data
> register.
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

Dual license new bindings:

(GPL-2.0-only OR BSD-2-Clause)

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

Just:

compatible:
  enum: ...

> +
> +
> +  reg:
> +    description:
> +      Base address and length of the register set of this block.

Drop. That's *every* 'reg' property.

> +      Currently 'reg' must be eight bytes wide and 32-bit aligned.

Currently? Is that going to change? Are things going to break if the DT 
has a bigger size?

> +
> +    maxItems: 1
> +
> +
> +  period:

Needs a vendor prefix and unit suffix.

> +    description:
> +      Wait time in microseconds to be used between reads.
> +      The RNG on these Aspeed SOCs generates 32bit of random data
> +      every one microsecond. Choose between 1 and n microseconds.

Why would you pick something more than 1?

> +
> +    maxItems: 1
> +
> +
> +  mode:

Needs a vendor prefix and a type reference.

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

Needs a vendor prefix and a type reference.

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

rng@...

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
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

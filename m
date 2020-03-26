Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA374C43331
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 19:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984CF20719
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 19:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585251669;
	bh=Ess4P7rTXsdNg1EcCIx+Mxp+xHNnRi779J8+YVPtKj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vWCjjJmNxjJ/T8YNDGKnB/0Rkdah5FHi3fe/1GmovpPWGnDYaVl6FqYtfko4eo5oj
	 5emvn8fjqVvWdj/AbSbm3KqolOgCe+dryn0nwyaauf7IQCvN7a+2WdFWv9Cr0P0Hqh
	 bP77w9dAyoY6NtsKvOmdh11eyCAG8RR3jQt93Qd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgCZTlJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 15:41:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34820 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTlI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 15:41:08 -0400
Received: by mail-io1-f68.google.com with SMTP id o3so1806148ioh.2;
        Thu, 26 Mar 2020 12:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Z5GoQwOlXq34jMbrNfddtNsm4YbfUIB3Klcgi2n0p8=;
        b=Zaa5swK5BdP+vNYvnOClHhS8yoFBYx8uJQ1uH/dQdCLYouS7dm1mkZ+pYE5sv7FmrX
         8YdYDCKUOTuf+q0cJH7abTPaMCdg0UMTAj1/5YgQfaNhIFVaMCDv6L5mX547JvjDnfkq
         IY65viHf+SpLVETQWVMdDHHdYs3JlYa7oZWIuCBVO+R1ZQkBDSb/tQykrm+mVxj6HO+Z
         uY9SyBYbZGuScWtzJ1G6LwWjWvPyPBVgm+a/Ui+MIwcsKDmXZcoBiLxDzjgo7CmWgU26
         MtHEQ74RmA5QU2rHAlkeUdJPOL99kIjNnCrGPS+d15UdcMMywVIQmG4sHBLT2YgL+Oj/
         Tzvw==
X-Gm-Message-State: ANhLgQ3uQRBN4OhlmgdSwqaLACzlnG2GX+Sccbt+cGzjDvTo1WlvmrUp
        co4GWSewtG/IeTNL0+1dKw==
X-Google-Smtp-Source: ADFU+vtj8JYvbn4eVg+I4HxwGh9ItJrI3wS4cOSL0jWkNvzGNgqbXajFrLmp6mGnIiVyKBZuytot6A==
X-Received: by 2002:a02:40c9:: with SMTP id n192mr7472911jaa.91.1585251666531;
        Thu, 26 Mar 2020 12:41:06 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id j84sm1106640ili.65.2020.03.26.12.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 12:41:05 -0700 (PDT)
Received: (nullmailer pid 12454 invoked by uid 1000);
        Thu, 26 Mar 2020 19:41:04 -0000
Date:   Thu, 26 Mar 2020 13:41:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH v6 1/3] dt-bindings: add device tree binding for Arm
 CryptoCell trng engine
Message-ID: <20200326194104.GA4118@bogus>
References: <1585114871-6912-1-git-send-email-hadar.gat@arm.com>
 <1585114871-6912-2-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585114871-6912-2-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 25, 2020 at 07:41:09AM +0200, Hadar Gat wrote:
> The Arm CryptoCell is a hardware security engine. This patch adds DT
> bindings for its TRNG (True Random Number Generator) engine.
> 
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  .../devicetree/bindings/rng/arm-cctrng.yaml        | 55 ++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/arm-cctrng.yaml b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> new file mode 100644
> index 0000000..7f70e4b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/arm-cctrng.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/arm-cctrng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Arm TrustZone CryptoCell TRNG engine
> +
> +maintainers:
> +  - Hadar Gat <hadar.gat@arm.com>
> +
> +description: |+
> +  Arm TrustZone CryptoCell TRNG (True Random Number Generator) engine.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - arm,cryptocell-713-trng
> +      - arm,cryptocell-703-trng
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  reg:
> +    maxItems: 1
> +
> +  arm,rosc-ratio:
> +    description:
> +      Arm TrustZone CryptoCell TRNG engine has 4 ring oscillators.
> +      Sampling ratio values for these 4 ring oscillators. (from calibration)
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/uint32-array
> +      - items:
> +          minItems: 4
> +          maxItems: 4

Aren't there some constraints on the values?

If not, then just this is enough:

- maxItems: 4

> +
> +  clocks:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - interrupts
> +  - reg
> +  - arm,rosc-ratio
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    arm_cctrng: rng@60000000 {
> +        compatible = "arm,cryptocell-713-trng";
> +        interrupts = <0 29 4>;
> +        reg = <0x60000000 0x10000>;
> +        arm,rosc-ratio = <5000 1000 500 0>;
> +    };
> -- 
> 2.7.4
> 

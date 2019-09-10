Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB11C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 10:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36B52168B
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 10:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aEbCPCQi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733083AbfIJKZK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 06:25:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33816 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfIJKZJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 06:25:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so9278183wrx.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 03:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vEAz+Y7APZfz1l8Dh96l5dI6vRULTuCJ/MZX/t986yo=;
        b=aEbCPCQi0wcPkmxmCDIuGnHOPhylUfSgnlSVwIZ6W2w5o7qQhdLkBb5lz7h87Kf4+0
         uh8Z0WnKWZYkh593TZ9xl2Y+bhFfehBF2Qa4IN6vOJypJN+F2gKkJKTTp3UmT9m3ZW58
         SGIQcXSQjx5L5RAfIBBtFOkIfOXgQkQzD+xiLjRO7Zii80i8bCMpGPnz1kL9f5lkpZOe
         7F6xVFBVBmZqKsnAALHkc8z6Db7ua5cAOQe3bll5o5Yjad1JMTg1DF9GVB8+3MpiLbCu
         yXBh/wYj4RZ6I5CtCoswqeNKEDdlJ16163CLEfR5vxdM7PW53MDiHKWGehXR/a2dbZe5
         lWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vEAz+Y7APZfz1l8Dh96l5dI6vRULTuCJ/MZX/t986yo=;
        b=od5cO2FOayR2bCT+m2igAJGzfz7ePZ4y66A16e0M4Xsu04AOSLLJYiXYjI6vIOt7+k
         F+iUrLMH2Vv5ydR7P9wreIEzig/pInB2/93HfMbMl404mejlrRn2R9Stpuk6elV/n1MS
         gcbbn0BcHCdukm5PjZcHQpZemcO5EynyqPZIOYOaOfIucMiZKXrbYr/CMu76UZ6nbcbA
         i8zgkreyfgYXO3IyaHjFlODB25jzqxPHU2pGVbw0eeyOyfHitzUqiR5ahgmTtIsy5nH1
         c6BDD9pPg/EjFBMW1xH8plneZCsnJvIEx9PC8p75URFs7NcY4ERAAcBoLShxc2KV3oWp
         egEg==
X-Gm-Message-State: APjAAAUcKGy6+ojm1ct1UTxwm8LnMm+V7hkn65v57P5xEfqsuRW+ro5F
        UKm+H1oUA6tL6IU71uureapFVA==
X-Google-Smtp-Source: APXvYqwcFh+5AHaeQ32JwyB8p5MAuUpAL0phC2yYPGlCXsZIhaa4ZKBqf85xJnZPvtb1eRPGpd2mqA==
X-Received: by 2002:a5d:500f:: with SMTP id e15mr10799631wrt.300.1568111108330;
        Tue, 10 Sep 2019 03:25:08 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id a144sm4235807wme.13.2019.09.10.03.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:25:07 -0700 (PDT)
Date:   Tue, 10 Sep 2019 11:25:05 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 1/2] dt-binding: hwrng: add NPCM RNG documentation
Message-ID: <20190910102505.vgyomi575ldrk2lq@holly.lan>
References: <20190909123840.154745-1-tmaimon77@gmail.com>
 <20190909123840.154745-2-tmaimon77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909123840.154745-2-tmaimon77@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 09, 2019 at 03:38:39PM +0300, Tomer Maimon wrote:
> Added device tree binding documentation for Nuvoton BMC
> NPCM Random Number Generator (RNG).
> 
> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> ---
>  .../bindings/rng/nuvoton,npcm-rng.txt           | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> new file mode 100644
> index 000000000000..a697b4425fb3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> @@ -0,0 +1,17 @@
> +NPCM SoC Random Number Generator
> +
> +Required properties:
> +- compatible  : "nuvoton,npcm750-rng" for the NPCM7XX BMC.
> +- reg         : Specifies physical base address and size of the registers.
> +
> +Optional property:
> +- quality : estimated number of bits of true entropy per 1024 bits
> +			read from the rng.
> +			If this property is not defined, it defaults to 1000.

There are pending unreplied review comments about this property (my own
as it happens):
https://patchwork.kernel.org/patch/11119371/


Daniel.

> +
> +Example:
> +
> +rng: rng@f000b000 {
> +	compatible = "nuvoton,npcm750-rng";
> +	reg = <0xf000b000 0x8>;
> +};
> -- 
> 2.18.0
> 

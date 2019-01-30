Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A97FC282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 16:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1B22086C
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548867080;
	bh=z4tr+Z9X6lbRF7ck4r/CaRmyfu9Hsxc+iXRtSr4ta/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YusAZeF9gMtbhpuHTLtdgoPimeYz3SfYQxNR0gJY0Zwnr1QX+pFYiurudIVAp7tU9
	 PcHODFG6gTdFjp3HpMn8Dz2yz8nDFRcQ20MuivdmCPDFZtK31xR3Lx9yIxFY0kLxnq
	 WBrbHRST+QIB6fID3FvBf/sM5GaD+wydOTti+OBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbfA3QvT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:51:19 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41376 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbfA3QvT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 11:51:19 -0500
Received: by mail-oi1-f194.google.com with SMTP id j21so165179oii.8;
        Wed, 30 Jan 2019 08:51:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JxCXJ7F8RmSL19GAOBres6E4ajxMj6g+BItf9PLzU9I=;
        b=MDC1rkSf/NsAIUiD3lCmaKYrHl5+3l+9TH76O6eHfrWa/FIbSLpocrHna59KMMTWOK
         xEyoB9akc7rsQFWrc6+yJomYgjtzMFvwJ/N0OPGDbSPdzST/FdgMc3zKM1mlhc6OCcAs
         bLJ+pqQt1e37Uqav+0xN9XFS0g1EzpMx4HP+LbPHa94OWgxj3JZ5ZW6EPw6l+8AJbmff
         csGNOhp3WO3azKQXuCIUyQQJwhAbXsKSttRwyh8YS6yuqIDW/8wiTgdG5UbQS+yftbnZ
         w5DGAyEPwNFUj3X5EUYiEEubgQD5wUdgRTfqWZXqdShvz0qCK0f86gA0Ni9/kxbvPiTG
         WxYw==
X-Gm-Message-State: AHQUAuaTcZFquU38a7Pox0d75T/E6ZUrFiz36zuVgYCjY4R4bV1GtRmi
        0NC29yCurC4wH/rXq1TF3O3caRw=
X-Google-Smtp-Source: ALg8bN4muYebABJbUfd1pNxttJV2OsaNaJoGUZ3/jZVpF7GjSIdNsF+IGmu5tz3bD12IFvYuEf+JjQ==
X-Received: by 2002:aca:4e92:: with SMTP id c140mr12524157oib.97.1548867076763;
        Wed, 30 Jan 2019 08:51:16 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s66sm893351oia.55.2019.01.30.08.51.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 08:51:16 -0800 (PST)
Date:   Wed, 30 Jan 2019 10:51:15 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
Message-ID: <20190130165115.GA8926@bogus>
References: <20190124154521.13589-1-k.konieczny@partner.samsung.com>
 <CGME20190124154539eucas1p16fb97dd0cab2c18d82113c511cd8a1ca@eucas1p1.samsung.com>
 <20190124154521.13589-3-k.konieczny@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124154521.13589-3-k.konieczny@partner.samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 04:45:20PM +0100, Kamil Konieczny wrote:
> Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
> SubSystem) IP.
> 
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  .../devicetree/bindings/crypto/samsung-sss.txt     | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> index 7a5ca56683cc..d9af679d38ab 100644
> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -1,4 +1,4 @@
> -Samsung SoC SSS (Security SubSystem) module
> +Samsung SoC SSS (Security SubSystem) and SlimSSS module
>  
>  The SSS module in S5PV210 SoC supports the following:
>  -- Feeder (FeedCtrl)
> @@ -15,6 +15,12 @@ supports the following also:
>  -- True Random Number Generator (TRNG)
>  -- Secure Key Manager
>  
> +Exynos5433 has both SSS and SlimSSS module.

That's not really relevant to the binding.

What do the SSS and SlimSSS share? Only that both have a single reg and 
interrupt based on the binding? This should probably be just 2 
documents. If not now, it will have to be when converted to a DT schema.

> +SlimSSS in Exynos5433 supports:
> +-- Feeder (FeedCtrl)
> +-- Advanced Encryption Standard (AES)
> +-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
> +
>  Required properties:
>  
>  - compatible : Should contain entries for this and backward compatible
> @@ -22,11 +28,13 @@ Required properties:
>    - "samsung,s5pv210-secss" for S5PV210 SoC.
>    - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
>  		Exynos5260 and Exynos5420 SoCs.
> +  - "samsung,exynos5433-slim-sss" for Exynos5433 SoCs.
>  - reg : Offset and length of the register set for the module
>  - interrupts : interrupt specifiers of SSS module interrupts (one feed
>  		control interrupt).
>  
>  - clocks : list of clock phandle and specifier pairs for all clocks  listed in
>  		clock-names property.
> -- clock-names : list of device clock input names; should contain one entry
> -		"secss".
> +- clock-names : list of device clock input names; should contain "pclk" and
> +		"aclk" for slim-sss in Exynos5433, and one entry "secss" for
> +		other compatibles.
> -- 
> 2.20.0
> 

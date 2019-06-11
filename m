Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF22CC31E46
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 22:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A132177E
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 22:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560293638;
	bh=stWnUbe+jaQuFau1PLVdqeZY8iwqhXyOVPXi0CRMm60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=J163L224J/irPse/D33LLvpJpQLGVAw7bXU8Uk1FrxAY8cvkZAxuULBC3SrymMX6C
	 WPlPjZnpzSKyv9Y0T/BJeqMOl2UNZjA044R15ZOA1Pf7c6JLoexftpng3JtqaVmxxE
	 deHSULnAQQLRGXsulL+fG4t6pBixs8pFVIKsGMfg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407412AbfFKWx5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 18:53:57 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53852 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404048AbfFKWx5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 18:53:57 -0400
Received: by mail-it1-f195.google.com with SMTP id m187so7742084ite.3;
        Tue, 11 Jun 2019 15:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iQPRF6XFm/QWEVO1CPfMz0EhoIEuoqt7VcGHt4YVR3s=;
        b=bwzgGflXOQe5eP6WP6bnPoG5hVuqBAMFGVhnt6pOL42IxfwkdGrkJ2yelJHaSdxH4y
         2HwasSizEfRa+XO3MMNcRLehBfehIuAOJEtOiN9yNeY44ivlEJPZ1+GwSuegddB7W4DG
         uVxChXqaTKJS2PimQ3q+lCOnBlYEOM42U/F8/MVwBXT4TKR+iJ0WjObF4Lwvo/5wjmVA
         8LTtSQk8ZXuFhbh45kH37/uvr0rvtcfy7BLCn58JHvMtQKg8AWUEyb+ry3S/JbLnIfuZ
         I1QoU4w+kZcm4qiH1EjfshwroZxHbsV70PZAishX0Dwuhj4F9QNxXNHYOG/dEamKmK8t
         sWqQ==
X-Gm-Message-State: APjAAAUPzzgSNKXjKq5GBz+1YYQqe/mIi0F0x6YYzLjpsjXNiKiw8XkG
        etHQzX9Ag/nWai+eDyPpLQ==
X-Google-Smtp-Source: APXvYqzoe7kqFMLzrRy1dkQxZdck05wcc6WXp2uGdqhH5bgqiTrtunhGBZNVP2Qc9VtW1KcUeh7Ffg==
X-Received: by 2002:a24:61d7:: with SMTP id s206mr19458252itc.133.1560293636578;
        Tue, 11 Jun 2019 15:53:56 -0700 (PDT)
Received: from localhost (ip-174-149-252-64.englco.spcsdns.net. [174.149.252.64])
        by smtp.gmail.com with ESMTPSA id f4sm5155254iok.56.2019.06.11.15.53.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 15:53:55 -0700 (PDT)
Date:   Tue, 11 Jun 2019 16:53:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsd_upstream@mediatek.com, Crystal Guo <Crystal.Guo@mediatek.com>
Subject: Re: [PATCH v3 2/3] dt-bindings: rng: update bindings for MediaTek
 ARMv8 SoCs
Message-ID: <20190611225351.GA17332@bogus>
References: <1560162984-26104-1-git-send-email-neal.liu@mediatek.com>
 <1560162984-26104-3-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560162984-26104-3-git-send-email-neal.liu@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 10, 2019 at 06:36:23PM +0800, Neal Liu wrote:
> Document the binding used by the MediaTek ARMv8 SoCs random
> number generator with TrustZone enabled.
> 
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  Documentation/devicetree/bindings/rng/mtk-rng.txt |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> index 2bc89f1..fb3dd59 100644
> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> @@ -3,9 +3,13 @@ found in MediaTek SoC family
>  
>  Required properties:
>  - compatible	    : Should be
> -			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
> -			"mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
> -			"mediatek,mt7623-rng" : for MT7623
> +			"mediatek,mt7622-rng", "mediatek,mt7623-rng" for MT7622
> +			"mediatek,mt7629-rng", "mediatek,mt7623-rng" for MT7629
> +			"mediatek,mt7623-rng" for MT7623
> +			"mediatek,mtk-sec-rng" for MediaTek ARMv8 SoCs with
> +			security RNG

Is there any commonality with the prior h/w? If not, make this a 
separate binding doc.

> +
> +Optional properties:
>  - clocks	    : list of clock specifiers, corresponding to
>  		      entries in clock-names property;
>  - clock-names	    : Should contain "rng" entries;
> @@ -19,3 +23,8 @@ rng: rng@1020f000 {
>  	clocks = <&infracfg CLK_INFRA_TRNG>;
>  	clock-names = "rng";
>  };
> +
> +/* secure RNG */
> +hwrng: hwrng {
> +	compatible = "mediatek,mtk-sec-rng";

How does one access this? Seems like this should be part of a node for 
firmware? What about other functions?

> +};
> -- 
> 1.7.9.5
> 

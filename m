Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD414C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EC9B262CB
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559257029;
	bh=iWlHwQIQWXgJxw5M7bJPq4MrgLHO4zyeNxvUKrcQDJs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hgtZLv4Pu+av2iXHc+8IdjnKuNt4dSguSiyaTtSVRhF1BRnp80irz7aBA0byktMnQ
	 yTFMysOoxAblSi78Iat/3Ji2PuiqpXKFYBWmphgGxHkJvyTa9m+ss/uU50Xsl9CCS5
	 gQ+zuc5rk/YcsDSn9P2TCoD31jNRe5fj8K59a/nc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfE3W5J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 18:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3W5I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 18:57:08 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E78262D1;
        Thu, 30 May 2019 22:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559257027;
        bh=iWlHwQIQWXgJxw5M7bJPq4MrgLHO4zyeNxvUKrcQDJs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eDQuxbkGjkCAjxTDwhjOqsUUKwS5T+l9GzaPR7RBxLxTl+iBKmcTUMdrT+fiJdW+/
         kKRS+2KsvqgM5EqpG8kq54+6i7djmBKARo6z3QPbMHFi7wxOubOmP56RGfYFMvk9za
         7Gd+MU8CdRzFhTJyrd436HeCx2cUeKXtLt7sUdxc=
Received: by mail-wr1-f49.google.com with SMTP id h1so5237366wro.4;
        Thu, 30 May 2019 15:57:06 -0700 (PDT)
X-Gm-Message-State: APjAAAWWRiMwClP1MkrImTklWxojrmHlSVaZO0IDG43CX/t5AqAEr4wa
        C80WGISLN1I0hPIOU1T8qFxQi89FKFR4IzBqhVE=
X-Google-Smtp-Source: APXvYqzB/imXLBAYcgV5SPngjuVw5E3+3UKU9f5J+X1Zzb2GO4Nj5erqdYaBmQU52zkdl0I+DX6YMxUcnUkt7x5fGUA=
X-Received: by 2002:adf:afd5:: with SMTP id y21mr4064469wrd.12.1559257025604;
 Thu, 30 May 2019 15:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com> <1558946326-13630-3-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1558946326-13630-3-git-send-email-neal.liu@mediatek.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Thu, 30 May 2019 15:56:55 -0700
X-Gmail-Original-Message-ID: <CAGp9LzrQegBb9Oe-=jfkwOrsYY=eN3BSF=DWnu+aSBAhQ5bexA@mail.gmail.com>
Message-ID: <CAGp9LzrQegBb9Oe-=jfkwOrsYY=eN3BSF=DWnu+aSBAhQ5bexA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] dt-bindings: rng: update bindings for MediaTek
 ARMv8 SoCs
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, wsd_upstream@mediatek.com,
        Crystal Guo <Crystal.Guo@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Neal

On Mon, May 27, 2019 at 1:39 AM Neal Liu <neal.liu@mediatek.com> wrote:
>
> Document the binding used by the MediaTek ARMv8 SoCs random
> number generator with TrustZone enabled.
>
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  Documentation/devicetree/bindings/rng/mtk-rng.txt |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> index 2bc89f1..1fb9b1d 100644
> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> @@ -3,9 +3,12 @@ found in MediaTek SoC family
>
>  Required properties:
>  - compatible       : Should be
> -                       "mediatek,mt7622-rng",  "mediatek,mt7623-rng" : for MT7622
> -                       "mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
> -                       "mediatek,mt7623-rng" : for MT7623
> +                       "mediatek,mt7622-rng", "mediatek,mt7623-rng" for MT7622
> +                       "mediatek,mt7629-rng", "mediatek,mt7623-rng" for MT7629
> +                       "mediatek,mt7623-rng" for MT7623

No make any change for those lines not belong to the series

> +                       "mediatek,mtk-sec-rng" for MediaTek ARMv8 SoCs

I thought "mediatek,mtk-sec-rng" is only for those MediaTek ARMv8 SoCs
with security RNG

> +
> +Optional properties:
>  - clocks           : list of clock specifiers, corresponding to
>                       entries in clock-names property;
>  - clock-names      : Should contain "rng" entries;
> @@ -19,3 +22,7 @@ rng: rng@1020f000 {
>         clocks = <&infracfg CLK_INFRA_TRNG>;
>         clock-names = "rng";
>  };

For those MediaTek ARMv8 SoCs with security RNG

> +
> +hwrng: hwrng {
> +       compatible = "mediatek,mtk-sec-rng";
> +};
> --
> 1.7.9.5
>

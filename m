Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD1BC433E7
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 11:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60604207BC
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 11:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mu+mJXCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIAK52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 06:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgIAK50 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 06:57:26 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B1C061244;
        Tue,  1 Sep 2020 03:57:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b79so698904wmb.4;
        Tue, 01 Sep 2020 03:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qv+hrnb2xjD7g2xlHs9VRxTYEef/MpVBAkk7Wae12HI=;
        b=mu+mJXCUgEHYzQ+AFoW3Gg4lYPpS4akRS7goCqjfdIKp9raZbie4Nmrn0RuuaScL/e
         jemoLvra7j6h57dg1fgOFWXgDn8egNhyO8fiUAthllj3NuikyA7VT/JJl/gO2qkJfIUM
         uPoQTEvptvFx97Hd01omR+u25wP8rYi47TP+fpDmzWDgC9YjEbu7hjryzXMxzNVg4Av8
         hbZAvwN7yp6zc0WslAo64D+ZBJqGl68qwOytmxlBCMnPv31kSu0QAGiVWqxBG8oQpEBD
         j/9xDyVszlgn//azc8cHtVt4Rkl1QSEz1bXWU4F/JIIrgNQ736yV+qjZfczF20eZgr8j
         PoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qv+hrnb2xjD7g2xlHs9VRxTYEef/MpVBAkk7Wae12HI=;
        b=AIokNeJToo5LY3AeUbUUDQ21ghqkJZFSoxL06XkuaQnxNuQruLehH0ArWI2ecFwYUF
         f5IfU0MUAya6o4Gj3Gi0F4ZijdYuhioL6AW2QV6oheEw8nSThO6f6Hlj/nPDW6axF7To
         g22vTHzHaWFoTqlLuDO5mIvUBQCO7K3wyiUJ5B1PIag6epk6TnTfejeW3pTOzSjbfQqM
         eMCfKigNjSgkCUsMrJeTf7U479AgRJM4za8ZoQjtxoSP+2jQhT6tikMTjkRVl2KjA99p
         LNjIjqmfZ/7g5uO/RAjyjm+e4aB/7ehj6v1VdW7jWLxJf/7XX4+pvwFKAInf0diS0ZUg
         Xjuw==
X-Gm-Message-State: AOAM530UHhf96Rmf+MBP5tLBHsDTJrQxt995p2WfZ//DfQpVBjDQPuhB
        jewYdKZH7xR1LjFSIB1H9nQ=
X-Google-Smtp-Source: ABdhPJxf1HCw5Tu8IqyBGh3pF6XKP/k09RVwN+hWe/n7E3woOGkKY0if2RchLQp4XKTyzk6Ghuv0YA==
X-Received: by 2002:a7b:cd09:: with SMTP id f9mr1144870wmj.184.1598957842588;
        Tue, 01 Sep 2020 03:57:22 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id s5sm1650905wrm.33.2020.09.01.03.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 03:57:21 -0700 (PDT)
Date:   Tue, 1 Sep 2020 12:57:19 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for V3s
Message-ID: <20200901105719.GA2639@Red>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-2-m.cerveny@computer.org>
 <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 01, 2020 at 11:32:49AM +0200, Maxime Ripard wrote:
> On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
> > Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> > directly in BE. So add new compatible.
> > 
> > Tested-by: Martin Cerveny <m.cerveny@computer.org>
> 
> The Tested-by tag is for the other developpers. You're very much
> expected to have tested your patch before contributing it.
> 
> > Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> > ---
> >  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > index fc823572b..180efd13a 100644
> > --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > @@ -25,6 +25,7 @@ properties:
> >            - const: allwinner,sun4i-a10-crypto
> >        - items:
> >            - const: allwinner,sun8i-a33-crypto
> > +      - const: allwinner,sun8i-v3s-crypto
> 
> If it's compatible with the A33, why do we need to introduce a new compatible?
> 
> >  
> >    reg:
> >      maxItems: 1
> > @@ -59,7 +60,9 @@ if:
> >    properties:
> >      compatible:
> >        contains:
> > -        const: allwinner,sun6i-a31-crypto
> > +        oneOf:
> > +          - const: allwinner,sun6i-a31-crypto
> > +          - const: allwinner,sun8i-v3s-crypto
> 
> I guess the A33 compatible should be on that list as well?

This is the list of "need reset".
So we cannot use allwinner,sun8i-a33-crypto
Probably this explanation should be in the commit message.

Regards

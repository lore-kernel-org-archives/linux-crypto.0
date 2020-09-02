Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0816BC433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 06:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6940207EA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 06:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5JnQjcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgIBG2a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBG22 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 02:28:28 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5F7C061244;
        Tue,  1 Sep 2020 23:28:28 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a65so3212860wme.5;
        Tue, 01 Sep 2020 23:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SBzOvJB/yYCoEo/r9GhASG+JavodAZ6L/gZnLI3x0KI=;
        b=Z5JnQjcXzHs+Z00jerccBtpE0ThplOgsdiZ1LvBuzfP/Ufhc8Xcv4L8PP6cc/ottSh
         5wzkKyLoOIuytmMGjyfaVTAsxuVdUfSXLrc/Z9UDAsPA2bIvoHYDyg3+E9X/nTaGkx5p
         GA4kxFbavEBTBF2Gp/0UxMA1ljbmmqN/TBOcaby6UY0hp+bFolQcqstSayAAv48A//6A
         neN4d2xhdOK8w3Otl/n9HGDA4Ajc6DOi9q1yeZ8sFrSmKC7Uy6e/aiMMEu8cc1w31zxa
         CKhT2eqW7qCtr168/V9trSYXPY42Mr5i99JNH0q5UgtR1PWwA9U51BRKB4iHr1lnrlnh
         O5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SBzOvJB/yYCoEo/r9GhASG+JavodAZ6L/gZnLI3x0KI=;
        b=LoLyzAbskY7h9O/GlCCil0kVWO1ca+JFqrfkD4H4VZOAFrTf2/f0Cxd0wpc0h3+dnj
         9MJP8Gl4uynbBRjSfbWSPgPhdmuO0vSWGSlG+IljPlwA361kwxuRgDaDY22DrYRH98lv
         Osd9HN7b06IEpTCplM+RDGeU5hECajioD/+ezrp/55LdJxDLgxl8QwbdaYUp0nIOanRr
         LasEbsFufhkVQN/neTNq1E2F7cK3DAPwcez01VtRvJDYAGFxyD1pQ/ErYkr6h+aiFZR8
         ZUJ0htjJKPSaOjB+dOnrmKTN98egqTLOuJQzjKnv3EMnhmbUuQ+cXgZeoPV62MJlfZVY
         9AZQ==
X-Gm-Message-State: AOAM532zSUIPuKQf0UovYY3OPmAEjyLybRboMkObfkgtisHRnAt9XoF3
        IxckFXwy7HPDP0SWd2W5XXnBmVtZBQg=
X-Google-Smtp-Source: ABdhPJzhjKiHrhhALnmXS3UwJ8+rCfsYcWKwhMzV1GH28wyAmXLezB6r1R54QDs8fL/pOG0qRuam0A==
X-Received: by 2002:a05:600c:2cc1:: with SMTP id l1mr5029705wmc.78.1599028107192;
        Tue, 01 Sep 2020 23:28:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id v3sm4789527wmh.6.2020.09.01.23.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 23:28:26 -0700 (PDT)
Date:   Wed, 2 Sep 2020 08:28:24 +0200
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
Message-ID: <20200902062824.GA17544@Red>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-2-m.cerveny@computer.org>
 <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
 <20200901105719.GA2639@Red>
 <20200901114015.qivovvjqvmhkicdl@gilmour.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901114015.qivovvjqvmhkicdl@gilmour.lan>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 01, 2020 at 01:40:15PM +0200, Maxime Ripard wrote:
> On Tue, Sep 01, 2020 at 12:57:19PM +0200, Corentin Labbe wrote:
> > On Tue, Sep 01, 2020 at 11:32:49AM +0200, Maxime Ripard wrote:
> > > On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
> > > > Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> > > > directly in BE. So add new compatible.
> > > > 
> > > > Tested-by: Martin Cerveny <m.cerveny@computer.org>
> > > 
> > > The Tested-by tag is for the other developpers. You're very much
> > > expected to have tested your patch before contributing it.
> > > 
> > > > Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> > > > ---
> > > >  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > index fc823572b..180efd13a 100644
> > > > --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > @@ -25,6 +25,7 @@ properties:
> > > >            - const: allwinner,sun4i-a10-crypto
> > > >        - items:
> > > >            - const: allwinner,sun8i-a33-crypto
> > > > +      - const: allwinner,sun8i-v3s-crypto
> > > 
> > > If it's compatible with the A33, why do we need to introduce a new compatible?
> > > 
> > > >  
> > > >    reg:
> > > >      maxItems: 1
> > > > @@ -59,7 +60,9 @@ if:
> > > >    properties:
> > > >      compatible:
> > > >        contains:
> > > > -        const: allwinner,sun6i-a31-crypto
> > > > +        oneOf:
> > > > +          - const: allwinner,sun6i-a31-crypto
> > > > +          - const: allwinner,sun8i-v3s-crypto
> > > 
> > > I guess the A33 compatible should be on that list as well?
> > 
> > This is the list of "need reset".
> > So we cannot use allwinner,sun8i-a33-crypto
> > Probably this explanation should be in the commit message.
> 
> But the A33 has a reset in the DTSI
> 


Oh right so I need to send a fix for that and Martin Cerveny could simply use the "allwinner,sun8i-a33-crypto" (and so keep only patch #1(DTS))

Regards

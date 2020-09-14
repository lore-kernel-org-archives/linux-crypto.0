Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8186C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 18:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D8821974
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600107890;
	bh=WMr9UQQ01DS8lVgLoeCuxsRb832PdiCe+uQkEbs3/0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qCyWldhcK+zaWEE0jqYGUGgM2wItEZx0lSPlJ4airYyNG3G96AvVnVc9Hcp9Q81Ch
	 YgOANVrEnf8CwTdZo7Mx1yzV/ekWWQUwxzKr3u3MwJn7zr1PjNGxByxw2wSqv9mRrK
	 rE3qb++7UfzvFr1Au4e2A4UGyY7CvghQJ75AWMUI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgINSYt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:24:49 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41377 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINSYq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 14:24:46 -0400
Received: by mail-io1-f66.google.com with SMTP id z13so1141424iom.8;
        Mon, 14 Sep 2020 11:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GTUBoBpz5Ene+9FeiAkhMRnwIfpjlrzqa2JaW342n2A=;
        b=lFV1HprGhdkEU7/AWjMal4mA0IvkQo64BlmHkt5OEFX+nsHGrWI/5ndv96r0H8TbYr
         ZjLqdRWn7ecoJn3ByoDAVxAPADq5mQXYIZEXAQf069lhO64AbXc9LkOkVtYFZev3dKf5
         H90Q05TZ4meGsSvxlxrwQvbuBhSvZyrV2oXUs+wYSkKtm2sl/mX8AIAVWeIKAWZVqlCX
         OBK4z8ISyE8RYbF+ZCsFzOEHj2Lh3X1ciNyEVZqQDx1gNRFqtgS+06c/DLHabLfzo2Ra
         5WUdMfCJlZb5xZdPJKRrxKYciUMXxMNdFRd8h5AwqtLp/LBt8EORk9vUkJfzxyG3Y3pB
         pJOw==
X-Gm-Message-State: AOAM5312KyqMWHibynkuEOjs2+YVg2U5O7j1UWYRvXWC1j/3TYzT8EDQ
        GjJKTj9cW5BGYu1Azsar9g==
X-Google-Smtp-Source: ABdhPJziOCMgtflSFn5rQIYl+kkPb236Vytu9jLXj8iJmknvM5j2xSqWu7dgZX0I/hG4PmzyudThfw==
X-Received: by 2002:a6b:b386:: with SMTP id c128mr12051803iof.157.1600107884742;
        Mon, 14 Sep 2020 11:24:44 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id w70sm7447830ilk.87.2020.09.14.11.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 11:24:43 -0700 (PDT)
Received: (nullmailer pid 4185625 invoked by uid 1000);
        Mon, 14 Sep 2020 18:24:42 -0000
Date:   Mon, 14 Sep 2020 12:24:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Martin Cerveny <M.Cerveny@computer.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for V3s
Message-ID: <20200914182442.GA4180717@bogus>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-2-m.cerveny@computer.org>
 <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
 <20200901105719.GA2639@Red>
 <20200901114015.qivovvjqvmhkicdl@gilmour.lan>
 <20200902062824.GA17544@Red>
 <alpine.GSO.2.00.2009051749080.3102@dmz.c-home.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.GSO.2.00.2009051749080.3102@dmz.c-home.cz>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 05, 2020 at 05:51:48PM +0200, Martin Cerveny wrote:
> 
> On Wed, 2 Sep 2020, Corentin Labbe wrote:
> > On Tue, Sep 01, 2020 at 01:40:15PM +0200, Maxime Ripard wrote:
> > > On Tue, Sep 01, 2020 at 12:57:19PM +0200, Corentin Labbe wrote:
> > > > On Tue, Sep 01, 2020 at 11:32:49AM +0200, Maxime Ripard wrote:
> > > > > On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
> > > > > > Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> > > > > > directly in BE. So add new compatible.
> > > > > > 
> > > > > > Tested-by: Martin Cerveny <m.cerveny@computer.org>
> > > > > 
> > > > > The Tested-by tag is for the other developpers. You're very much
> > > > > expected to have tested your patch before contributing it.
> > > > > 
> > > > > > Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> > > > > > ---
> > > > > >  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 ++++-
> > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > > > index fc823572b..180efd13a 100644
> > > > > > --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > > > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> > > > > > @@ -25,6 +25,7 @@ properties:
> > > > > >            - const: allwinner,sun4i-a10-crypto
> > > > > >        - items:
> > > > > >            - const: allwinner,sun8i-a33-crypto
> > > > > > +      - const: allwinner,sun8i-v3s-crypto
> > > > > 
> > > > > If it's compatible with the A33, why do we need to introduce a new compatible?
> > > > > 
> > > > > > 
> > > > > >    reg:
> > > > > >      maxItems: 1
> > > > > > @@ -59,7 +60,9 @@ if:
> > > > > >    properties:
> > > > > >      compatible:
> > > > > >        contains:
> > > > > > -        const: allwinner,sun6i-a31-crypto
> > > > > > +        oneOf:
> > > > > > +          - const: allwinner,sun6i-a31-crypto
> > > > > > +          - const: allwinner,sun8i-v3s-crypto
> > > > > 
> > > > > I guess the A33 compatible should be on that list as well?
> > > > 
> > > > This is the list of "need reset".
> > > > So we cannot use allwinner,sun8i-a33-crypto
> > > > Probably this explanation should be in the commit message.
> > > 
> > > But the A33 has a reset in the DTSI
> > > 
> > 
> > 
> > Oh right so I need to send a fix for that and Martin Cerveny could simply use the "allwinner,sun8i-a33-crypto" (and so keep only patch #1(DTS))
> > 
> > Regards
> > 
> 
> What is "right" solution for DTSI ?
> - compatible = "allwinner,sun8i-a33-crypto";
> OR
> - compatible = "allwinner,sun8i-v3s-crypto", "allwinner,sun8i-a33-crypto";
> (but unimplemented "allwinner,sun8i-v3s-crypto")

Generally, this one in case you have differences like bugs or features.

Rob

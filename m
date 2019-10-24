Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB68CA9EBB
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 18:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D27021929
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571943589;
	bh=a+uIvZuoQVHuTrFvBOzthw/TKu6zM/j2cbpgzHnS7NU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Szmi9LA3vvznBuC5hSdjhLgfpjf0jWiBGUBoj7e5uyiscW6LruKR+k7xkNfdJRq+B
	 TLr3YiZJb3lvM6vmIScvRq5FSkGXr3BpXk+GtGIS4+ypMbMX0wXlyyAyNbNi7Z0okh
	 DV62DgXbHZ/OxAOb5oA3J1O0HVwu5dOIZZl/cvuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394158AbfJXS7s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 14:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390034AbfJXS7r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 14:59:47 -0400
Received: from localhost (unknown [109.190.253.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6C42166E;
        Thu, 24 Oct 2019 18:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571943587;
        bh=a+uIvZuoQVHuTrFvBOzthw/TKu6zM/j2cbpgzHnS7NU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WcOVK2MoQPmQQSsCISXcIBuI7zyFW7PCPi3sEWyZrvsujyJU9KqXd8Lz9FuUcEycP
         LovoXS6q0NzSjx0T9bwgKdiO0D2IdOC+9eCmPibS/8rcntyqRQWHweq3RvmcIYOhW0
         RouTokS1q8E5knnKBp9KdlV/2jWAkeeZMIoYyjos=
Date:   Thu, 24 Oct 2019 20:24:05 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/4] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ss Security System
Message-ID: <20191024182405.a4x5vc4hxwsev2hp@hendrix>
References: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
 <20191023201016.26195-3-clabbe.montjoie@gmail.com>
 <20191024065005.hdypdl2dgqsrry5i@gilmour>
 <20191024093118.GA15113@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024093118.GA15113@Red>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 24, 2019 at 11:31:18AM +0200, Corentin Labbe wrote:
> On Thu, Oct 24, 2019 at 08:50:05AM +0200, Maxime Ripard wrote:
> > Hi,
> >
> > On Wed, Oct 23, 2019 at 10:10:14PM +0200, Corentin Labbe wrote:
> > > This patch adds documentation for Device-Tree bindings of the
> > > Security System cryptographic offloader driver.
> > >
> > > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > ---
> > >  .../bindings/crypto/allwinner,sun8i-ss.yaml   | 64 +++++++++++++++++++
> > >  1 file changed, 64 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> > > new file mode 100644
> > > index 000000000000..99b7736975bc
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> > > @@ -0,0 +1,64 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ss.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Allwinner Security System v2 driver
> > > +
> > > +maintainers:
> > > +  - Corentin Labbe <corentin.labbe@gmail.com>
> > > +
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - allwinner,sun8i-a83t-crypto
> > > +      - allwinner,sun9i-a80-crypto
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> > > +
> > > +  clocks:
> > > +    items:
> > > +      - description: Bus clock
> > > +      - description: Module clock
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: bus
> > > +      - const: mod
> > > +
> > > +  resets:
> > > +    maxItems: 1
> >
> > The A83t at least has a reset line, so please make a condition to have
> > it required.
> >
>
> Hello
>
> The A80 have one also, so I need to set minItems: 1
> But setting both minItems: 1 and maxItems:1 lead to a check failure:
>
> properties:resets: {'minItems': 1, 'maxItems': 1} is not valid under
> any of the given schemas
>
> How to do that ?

IIRC the meta-schema prevent having both because the tooling will
insert it for you.

It doesn't really matter at this level though. maxItems alone will
make sure that there's a single element, and the schemas in the tools
will make sure that the type for resets is correct.

What you'd need here though would be to add resets to the list of
required properties, otherwise it will only be checked against if the
property is there.

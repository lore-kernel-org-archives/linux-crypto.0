Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E666FECDE20
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 09:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFF68214D8
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 09:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568281062;
	bh=fD3WpoO3f2gpFrlgdn1Y9gFuBeXCWGXp86lvU0zRboY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Hd64sV9yUtSTouScNVFKVhTnF53qxvjHlD/+sUJYODeCcqcGE9dsLsFqzjPMj+bN2
	 m+PYC2/AsO+eHT1b7UbAQ5w7La4teZhzs6UdApBA2ZvJeADw/ux+CmG1Xo2J+mmBv2
	 naOIXME4XzfSnd0c7SYfCdtmplG96Hlk/5Mv77os=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfILJhl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 05:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730428AbfILJhl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 05:37:41 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C6F20856;
        Thu, 12 Sep 2019 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568281060;
        bh=fD3WpoO3f2gpFrlgdn1Y9gFuBeXCWGXp86lvU0zRboY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QgoNqVGoelY7/KRxtPZ4wl+sSzMRe4QJCt4H63JAQebqweondhx6qL64s6Xsy6Tmu
         +j4nFO0vVp14mcwLqWG+dOZDGU2Zp0ySO9zqdkGjGw2KcEs+EFIG3ow3AuJRqDKgsc
         05C6Oxk+8Q0fhf7OQJZCvjgDKFDioUuhY8J+3aMg=
Date:   Thu, 12 Sep 2019 11:37:37 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
Message-ID: <20190912093737.s6iu63sdncij2qib@localhost.localdomain>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com>
 <20190907040116.lib532o2eqt4qnvv@flea>
 <20190911183158.GA8264@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7d2ddx4b3xu2lr3y"
Content-Disposition: inline
In-Reply-To: <20190911183158.GA8264@Red>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--7d2ddx4b3xu2lr3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Corentin,

On Wed, Sep 11, 2019 at 08:31:58PM +0200, Corentin Labbe wrote:
> On Sat, Sep 07, 2019 at 07:01:16AM +0300, Maxime Ripard wrote:
> > On Fri, Sep 06, 2019 at 08:45:45PM +0200, Corentin Labbe wrote:
> > > This patch adds documentation for Device-Tree bindings for the
> > > Crypto Engine cryptographic accelerator driver.
> > >
> > > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > ---
> > >  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 84 +++++++++++++++++=
++
> > >  1 file changed, 84 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinne=
r,sun8i-ce.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i=
-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> [...]
> > > +else:
> > > +  clocks:
> > > +    items:
> > > +      - description: Bus clock
> > > +      - description: Module clock
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: ahb
> > > +      - const: mod
> > > +
> > > +  resets:
> > > +    maxItems: 1
> > > +
> > > +  reset-names:
> > > +    const: ahb
> >=20
> > This prevents the usage of the additionalProperties property, which
> > you should really use.
> >=20
> > What you can do instead is moving the clocks and clock-names
> > description under properties, with a minItems of 2 and a maxItems of
> > 3. Then you can restrict the length of that property to either 2 or 3
> > depending on the case here.
> >=20
>=20
> Hello
>=20
> I fail to do this.
> I do the following (keeped only clock stuff)
> properties:
>=20
>   clocks:
>     items:
>       - description: Bus clock
>       - description: Module clock
>       - description: MBus clock

Add minItems: 2  and maxItems: 3 at the same level than items

>=20
>   clock-names:
>     items:
>       - const: ahb
>       - const: mod
>       - const: mbus

And here as well

Something I missed earlier though was that we've tried to unify as
much as possible the ahb / apb / axi clocks around the bus name, it
would be great if you could do it.

>=20
> if:
>   properties:
>     compatible:
>       items:
>         const: allwinner,sun50i-h6-crypto
> then:
>   properties:
>       clocks:
>         minItems: 3
>         maxItems: 3
>       clock-names:
>         minItems: 3
>         maxItems: 3

You don't need to duplicate the min and maxItems here

Maxime

--7d2ddx4b3xu2lr3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXXoR4QAKCRDj7w1vZxhR
xd/rAQDRrO6PXFXddEGmbg33Hyw8TjZtRKONBAAN5nSryJdLjQD+O0kVALWGEe1h
DMUgNDC+mm3ZrNDIOzQMdWgSgsA4aA0=
=g4h8
-----END PGP SIGNATURE-----

--7d2ddx4b3xu2lr3y--

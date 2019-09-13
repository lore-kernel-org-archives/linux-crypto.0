Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E09C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 12:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A79F208C0
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 12:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568376688;
	bh=/yuo8LkwG/vK/Jb+QiIu8OrXJNZtg/fik8C0+OyD7Hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=H1zYEJPgnRMzZoaAgeBbFQghy3vy8Yy1HWZ14Ov+rTXoqwxLRxqcj0ONas8IwQnN5
	 wozeJTjuXA99/n7cgIySK2GgWlZDiITywelbJuQZ676r8OxCyjM672HLKIy8edp8C3
	 FWQwM+gerThyrw2VBvXmTMzjnbrL6341v+c+nXNs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfIMML1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 08:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfIMML1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 08:11:27 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492572084F;
        Fri, 13 Sep 2019 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568376686;
        bh=/yuo8LkwG/vK/Jb+QiIu8OrXJNZtg/fik8C0+OyD7Hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sUuajaYi7mGVPkYopS1AqkdFgGHainGr/gFIVTgTFj4NMzKmhzsepPa+usLvieQUN
         dMuKx/90Qo2hO8vo88PimuVso31oG8ACymDRc1FiPDfcFb+uyCy3gJc/Br0IrC5YRH
         N/jCU2YES2jDkCLv5dUBl3+wC5+8TahER8kXag7s=
Date:   Fri, 13 Sep 2019 14:11:24 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
Message-ID: <20190913121124.clfi46vcnrxhzmwh@localhost.localdomain>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com>
 <20190907040116.lib532o2eqt4qnvv@flea>
 <20190911183158.GA8264@Red>
 <20190912093737.s6iu63sdncij2qib@localhost.localdomain>
 <CAGb2v678WGQm5PNy8GhOTpz+fYeLP3k0dnR0F00yyZpSRcA4yA@mail.gmail.com>
 <20190912203301.is4ubixhk64dl5t7@localhost.localdomain>
 <CAGb2v646YkM93BAo=hrpL+tgDU-JJ49-uMCMGECUbouoJrpg=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mxfblhwyykii33ch"
Content-Disposition: inline
In-Reply-To: <CAGb2v646YkM93BAo=hrpL+tgDU-JJ49-uMCMGECUbouoJrpg=w@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--mxfblhwyykii33ch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2019 at 09:37:17PM +0100, Chen-Yu Tsai wrote:
> On Thu, Sep 12, 2019 at 9:33 PM Maxime Ripard <mripard@kernel.org> wrote:
> > On Thu, Sep 12, 2019 at 09:26:27PM +0100, Chen-Yu Tsai wrote:
> > > > >
> > > > >   clock-names:
> > > > >     items:
> > > > >       - const: ahb
> > > > >       - const: mod
> > > > >       - const: mbus
> > > >
> > > > And here as well
> > > >
> > > > Something I missed earlier though was that we've tried to unify as
> > > > much as possible the ahb / apb / axi clocks around the bus name, it
> > > > would be great if you could do it.
> > >
> > > I think we also want to standardize "mbus" as "dram"?
> >
> > Do we? The only user so far seems to be sun9i-de, while mbus has more
> > users. I don't really care though, both mbus and dram are pretty
> > generic to me. What makes you prefer dram over mbus?
>=20
> Argh... it's actually "ram" we use the most. Both "dram" and "mbus"
> have only one instance each.

Let's use ram then :)

Maxime

--mxfblhwyykii33ch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXXuHbAAKCRDj7w1vZxhR
xazRAP9q4WVrPnh+fZ02hS/8DFlnUg4ZEiOZEKaupnYTZODnDgEA3aUQ5mkgXMdG
FzX2x3Ap9qkbqSmmGBRWN/QtgReLcg0=
=KM0B
-----END PGP SIGNATURE-----

--mxfblhwyykii33ch--

Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52131C433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 11:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A291206FA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 11:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="FaF/YWwk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="umchNfya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIALot (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:44:49 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59123 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgIALl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 07:41:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A5635E85;
        Tue,  1 Sep 2020 07:40:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 01 Sep 2020 07:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9azO1dZNqCpcvjOzPEkevlaB/dN
        EkdBBbt08o9p7OMQ=; b=FaF/YWwkEtJgACjyc2uHponLFGWFEGR3ROixkHhvnb6
        Xssz8kcZxNs5cGu7UuvuY0s8NI0eAiPcwHb8XRZOuQ7i+TbS0Um7LeMq3hSPg6E1
        TVSl26AnyIjWe/7rc4VJLb+Y2ApN7lgqaK+UStkyBpRYht5fsHdgZjqjZ2Qyvwlf
        SYP2Zf27I1T5I/d41Zp7aDuRLqpUJ3+9VsWKKI93W+8XtpLmO6LCWQKudxxzATCW
        OC1yiMT5AdbY3/piMfT/7XNLQPEPLr/uA7BI2Tc3OLlLrUd/EjYFRj99HcbuLNlO
        TwNfHyhX9x48Cu5kFpy8xKthjWwFMEgFxq8efBQD4Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9azO1d
        ZNqCpcvjOzPEkevlaB/dNEkdBBbt08o9p7OMQ=; b=umchNfyaf/QvFjAE9hF9XK
        2P5nENuThzppKBSmtEaBKLazC/MrALvwJtUBjMWuSVqVAKnt5whSuzLVqopP8CiU
        bamRAkyhv8sLpdk4kZX4rNUY/8M4b/vqSkHoi8hS9sTquhb1zez9tTX0+nrfDcI6
        J2GNLYI0UeDjs34c3Uk+nT7ugNUfpRRj+/s2rWBHprMVNcgtwbssNVEeFWEt4a0V
        TPbaox9nZQ+cRQ/bcw41Bqdqa0JTGZs2188Bi0EMBqKtF+BkynHYs3cJqwldTS78
        yle2qCrcUDpqlsO22pq8VnF+WtGr2Qe0QJ+o6snsREEcTBh2UvPZmOYd0FE0U6Ww
        ==
X-ME-Sender: <xms:ITNOXxeRzxPtwPqC_EbQgd_R8AlVqXzC9GmK7cqbLvBpZYL34VE3iw>
    <xme:ITNOX_OM5eZH9kemW44j1p9_XPVWITxmrJVR4g3bFrickZr_1gLTwy5_oJFFNR3Zg
    jTo9n4pcDaK6iNdPRY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefjedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:ITNOX6itwy3K-fwLF2qSs9nVGKU0SGt8MYX8UPLMNnsVHc4-HD__og>
    <xmx:ITNOX69MGVYxkZyI_NnbWslaIU-mbmQkedMDUoKLB5Aqact_4aVxPw>
    <xmx:ITNOX9ukQhMvJzXxhr_k4F-pjfB2KjoFmt1k4C5OIuyCl0SR9qeG-A>
    <xmx:IzNOX-856FswgbWULPhNp89561mwgvcITuqV2hnDYquClKT9D2AvXg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4631328005D;
        Tue,  1 Sep 2020 07:40:17 -0400 (EDT)
Date:   Tue, 1 Sep 2020 13:40:15 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for V3s
Message-ID: <20200901114015.qivovvjqvmhkicdl@gilmour.lan>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-2-m.cerveny@computer.org>
 <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
 <20200901105719.GA2639@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d4zgxzgmrbrrtklg"
Content-Disposition: inline
In-Reply-To: <20200901105719.GA2639@Red>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--d4zgxzgmrbrrtklg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 01, 2020 at 12:57:19PM +0200, Corentin Labbe wrote:
> On Tue, Sep 01, 2020 at 11:32:49AM +0200, Maxime Ripard wrote:
> > On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
> > > Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> > > directly in BE. So add new compatible.
> > >=20
> > > Tested-by: Martin Cerveny <m.cerveny@computer.org>
> >=20
> > The Tested-by tag is for the other developpers. You're very much
> > expected to have tested your patch before contributing it.
> >=20
> > > Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> > > ---
> > >  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 +++=
+-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i=
-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i=
-a10-crypto.yaml
> > > index fc823572b..180efd13a 100644
> > > --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-cr=
ypto.yaml
> > > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-cr=
ypto.yaml
> > > @@ -25,6 +25,7 @@ properties:
> > >            - const: allwinner,sun4i-a10-crypto
> > >        - items:
> > >            - const: allwinner,sun8i-a33-crypto
> > > +      - const: allwinner,sun8i-v3s-crypto
> >=20
> > If it's compatible with the A33, why do we need to introduce a new comp=
atible?
> >=20
> > > =20
> > >    reg:
> > >      maxItems: 1
> > > @@ -59,7 +60,9 @@ if:
> > >    properties:
> > >      compatible:
> > >        contains:
> > > -        const: allwinner,sun6i-a31-crypto
> > > +        oneOf:
> > > +          - const: allwinner,sun6i-a31-crypto
> > > +          - const: allwinner,sun8i-v3s-crypto
> >=20
> > I guess the A33 compatible should be on that list as well?
>=20
> This is the list of "need reset".
> So we cannot use allwinner,sun8i-a33-crypto
> Probably this explanation should be in the commit message.

But the A33 has a reset in the DTSI

Maxime

--d4zgxzgmrbrrtklg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX04zHwAKCRDj7w1vZxhR
xXtfAQCBNwO0KHktfVHdqJ1A31xqeae+JkhAoO14ISBQKDyKbgEAhtvQBryHrXgM
Ts2NqtdzP/w7zF4ZtCJvTt3J9AKJmAo=
=cE+X
-----END PGP SIGNATURE-----

--d4zgxzgmrbrrtklg--

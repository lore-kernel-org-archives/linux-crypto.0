Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB82C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D53C222506
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 13:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="Qdf+s0c6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FiTS/f3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfKTNpU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:45:20 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56787 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728864AbfKTNpU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 08:45:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2D8A26D7E;
        Wed, 20 Nov 2019 08:45:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 20 Nov 2019 08:45:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=HBx0ATlKQS6ihzQSYv4eFhcuYSS
        PpHvcXAzdap35ALg=; b=Qdf+s0c6K29kIsyee9j5q260GaF4jDcAo0GQQ6gkp4Q
        yUVBdzDtMj53LVevwTruYcbrmy/gmHSjoxamS2Tp5821kOl5cic7yYbsyjwAK8jY
        oixZ+bF0I2GjgirWKoxyWk5ukBbn5wwqXT76jY9p5WLVxfieohaTEkKObHtGzVXa
        qUHsBUUencFEmB/hEUn8bwnot0SYhl9ls76VBZ04fWtsW+uy+3l5Jj8H643jOY3k
        U6W7+XTHQEMgXtZyI9tawjOEZWQpJZsBrKGTSuNRgLwcukIAUfERGawLyCNZF67Z
        89kmJa7rVF7fkUFPhS+sD2Nz6WgolyBZg3321NYFkMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HBx0AT
        lKQS6ihzQSYv4eFhcuYSSPpHvcXAzdap35ALg=; b=FiTS/f3biHcEjumFoNSr83
        cEkQDdPPF5gXfS6x7bDYXhxjC7Iel8YcpAsQiFuZHX2grHpDBrJSmvWeckJ25Ub1
        SFsawfjNc42FpLlWF1Jfyl+RUXqY4ns9T3sy4GjkI6pQLXsKX7tGPlJgzOULQQIK
        7lTSD+3mNDVXGlGYofVfcVPhZvsHgrTtZvcMVCEQzaeURJeFsbRQIqiXBNWJXB+W
        RBf0VpGkO77+Uf7KkIbX4fwWw+w/o69LvjVe5KuYjd/WfqBu507qKRwAR0gOzw1j
        cUSfTnhur60lSUOfQwZ1VgB7eQ2oe8MPC6EpOCwVZZGlbjc/vyW2bimnBX7zz1Nw
        ==
X-ME-Sender: <xms:bEPVXax4TLeYfctjJJuDqvOblirexd-crZZuxDZ7ItSGmgXPu-KDxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehtddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehgtd
    erredtredvnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegt
    vghrnhhordhtvggthheqnecukfhppeeltddrkeelrdeikedrjeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghhnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:bEPVXZA11E6gv42UuV4XONXEtEWft7RrWUoPPhlSmIt-yJ1RqyGezw>
    <xmx:bEPVXZPJlgwz6Bj3TaiAVKDmSq9_s6_mggHS53shxelXTzOjzkYORg>
    <xmx:bEPVXYCW0B-zSjPGJdAMrMBphmir5ONEYd7SKR_bqR5Kflkshb7orQ>
    <xmx:bkPVXZUt6NOpAuSIaklt96euI_I_Inap8YbJ34VwIg6sqbHJP5kt-A>
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82DF080059;
        Wed, 20 Nov 2019 08:45:16 -0500 (EST)
Date:   Wed, 20 Nov 2019 14:45:14 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Maxime Ripard <mripard@kernel.org>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mark.rutland@arm.com,
        robh+dt@kernel.org, wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/3] ARM: dts: sun8i: a33: add the new SecuritySystem
 compatible
Message-ID: <20191120134514.GA4345@gilmour.lan>
References: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
 <20191114144812.22747-3-clabbe.montjoie@gmail.com>
 <20191118111143.GF4345@gilmour.lan>
 <20191119073924.GA32060@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RbXZOS5Wid+xb0VD"
Content-Disposition: inline
In-Reply-To: <20191119073924.GA32060@Red>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--RbXZOS5Wid+xb0VD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Nov 19, 2019 at 08:39:24AM +0100, Corentin Labbe wrote:
> On Mon, Nov 18, 2019 at 12:11:43PM +0100, Maxime Ripard wrote:
> > Hi,
> >
> > On Thu, Nov 14, 2019 at 03:48:11PM +0100, Corentin Labbe wrote:
> > > Add the new A33 SecuritySystem compatible to the crypto node.
> > >
> > > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > ---
> > >  arch/arm/boot/dts/sun8i-a33.dtsi | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
> > > index 1532a0e59af4..5680fa1de102 100644
> > > --- a/arch/arm/boot/dts/sun8i-a33.dtsi
> > > +++ b/arch/arm/boot/dts/sun8i-a33.dtsi
> > > @@ -215,7 +215,8 @@
> > >  		};
> > >
> > >  		crypto: crypto-engine@1c15000 {
> > > -			compatible = "allwinner,sun4i-a10-crypto";
> > > +			compatible = "allwinner,sun8i-a33-crypto",
> > > +				     "allwinner,sun4i-a10-crypto";
> >
> > If some algorithms aren't working properly, we can't really fall back
> > to it, we should just use the a33 compatible.
>
> Since crypto selftest detect the problem, the fallback could be used
> and SS will just be in degraded mode (no sha1).
>
> But since nobody reported this problem since 4 years (when SS was
> added in a33 dts), the absence of sha1 is clearly not an issue.

It's not really the point though. There's a bug, it's something that
was overlooked and it's unfortunate. The bug is still there though,
and the only option to fix it properly is to simply fix, not claim
that it's somewhat ok to keep it around since no one really uses it
anyway.

Maxime

--RbXZOS5Wid+xb0VD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXdVDagAKCRDj7w1vZxhR
xTr+AP9nKc+hE3dn5vXfY2IR4cUybDQj7CLHiRPioS1Ywc9IhAD+LubNk4yjxFc4
TLXqQL0OKbRm9agqiHxjDu4XR85jMgQ=
=Xjtr
-----END PGP SIGNATURE-----

--RbXZOS5Wid+xb0VD--

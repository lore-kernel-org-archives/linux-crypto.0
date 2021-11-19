Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22566C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 08:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A51961AF0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 08:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhKSIcX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 03:32:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33963 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhKSIcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 03:32:23 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 76BAE5C0103;
        Fri, 19 Nov 2021 03:29:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 Nov 2021 03:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=LW/p0wyoCcIJog59YYQV//3Akj0
        rWF+oNpGoc/GozLo=; b=gIispYTY6e+7QaxE5wpdCJnEYr/NIkLBOjnK1D/0p0U
        mUWvYkXRXnOsj/dG2e5vbJ5t4z3xSRKC6ac4unew1aBioOAtcOJQlun6/Wh30ls6
        a9Y66DR6y8IJ/z5C2WYPMmztF7SmQgCtOnB1ks8w//BG3JXQE6qEskJh2TJy+/UP
        5Z86fWuiHUirauZUQZC0qASsOi8xtg6215eoD20mEIfWJmtfAScv5VTp7EQ10RcW
        etp22l5UMs6f22giprSZZh/YQ/bDDPyzIXCE+DFOx1SAvixX1RzPk7rlrF7tkNeW
        rnEFLZbYU50IKWIxZ+U4KKZ1Wewoihd+qE+dVGiBm3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LW/p0w
        yoCcIJog59YYQV//3Akj0rWF+oNpGoc/GozLo=; b=hwI+NaioJIwamB4b5IZrCi
        XRId1VIy9G7gP3O6C43GC+Q2dVW+0JRzI/Pij/LWogvDqjb7uxgDFIU3K6SSU7ND
        qcjuorXbc7hoxPVFSZrFWnjG5d8wx0Lg1yosG2ztmU9AQoaCD3cE2GNsp/sGlbys
        Gv9Xq/AD4SWdJqUy/cUQ+f2cBc+ZKzj4JIA7J1UO17rfMpt0l17ipFPSJh915rx6
        M049RDPUuhIZTXhrQNInhwB7LWHBQUwJsnqqn1n2HStGpfWCN0RGNMiFkSm0U0ou
        qO+ghkKC846MA5WdbIv+FXyOtH7ov/oCgY39YTWrOCf+Jhum87Nb/tP3m65pgBBQ
        ==
X-ME-Sender: <xms:YGCXYRcT8UvME9qz4tK6yFVQy3PtDhnggv1pxEDG1DtQ6Z0WiMi44A>
    <xme:YGCXYfPm9b8CO1EylbabEBj5uTX4IsYdnpMT7oOPwNSwD6C265TCfyhxKhRvaadPa
    b7S5NNR0kk2Nc3cap8>
X-ME-Received: <xmr:YGCXYaj_lUIZIFF99s1vm_PMvpCM_aWSJgAoPROfrDUC4d93hALSWltaKSIeXaq8umkZwLUriM8JX7dDKBKAQ8hgrKFYKp5vJf2cgJ-E4JU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeejgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:YGCXYa82UsGR1WsrywHQucvPPwIT6DT6zY3sKuME4tgtyy56KVKVyg>
    <xmx:YGCXYdtGupRHGCTYWfTaMwINBJrq3fO-JhaCrAFTQlYIJmnbkHR6SQ>
    <xmx:YGCXYZGJw2uhm5nAIVQIxH9mqBF6xazB8Ed36ZZn1pzUkm0T-4ZcVw>
    <xmx:YWCXYTAi5COVehX8pG2sv6FyJdRdzS25DoGpC935sP4mu7t30r3EQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 03:29:20 -0500 (EST)
Date:   Fri, 19 Nov 2021 09:29:19 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 1/2] dt-bindings: crypto: sun8i-ce: Add compatible for D1
Message-ID: <20211119082919.k4r7ln4jfseqblcr@gilmour>
References: <20211119051026.13049-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lmxak3wlnqlumgug"
Content-Disposition: inline
In-Reply-To: <20211119051026.13049-1-samuel@sholland.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--lmxak3wlnqlumgug
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 18, 2021 at 11:10:24PM -0600, Samuel Holland wrote:
> D1 has a crypto engine similar to the one in other Allwinner SoCs.
> Like H6, it has a separate MBUS clock gate.
>=20
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Acked-by: Maxime Ripard <maxime@cerno.tech>

Maxime

--lmxak3wlnqlumgug
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYZdgXgAKCRDj7w1vZxhR
xaDTAP9Y0zp+1nrtorIbXYFgevtVz8+kCmHvzv6r4091HP92twEAyCcQwpl3NTQe
Rb74BF/TcPGlUR07Tyzg2LurLRFpRgw=
=GvEZ
-----END PGP SIGNATURE-----

--lmxak3wlnqlumgug--

Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF45C43461
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4AF2166E
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgIHGTz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:19:55 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:43109 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbgIHGTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 02:19:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 6499ED4F;
        Tue,  8 Sep 2020 02:19:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 02:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=RKjI56eZSahdFm53T7bERiNLEbu
        yYy0L/X4uwcFh7jk=; b=OvG9Ae91XZWN3uw8Gl9Xum5VPW6AS9aEBshnAsfDPaN
        S91nGTV8kh8vh1r+XPGDV0ow8UKe3r+GOMp5lkPHX7chotZGgSNxHzYvRfr7HNkf
        9UCPNGnaNtRxpQtZoxRFi3qUV/S3RiqmTtt2TAuLNj4lvPqfu4NpFksU8DRjBNWa
        BRx540p1qCk5zuIYWkysY/cEHHTLdrUPVipv8ts5TizsiNp7UpAdKXWSbrJYPE76
        sJ2Ep0MQFh0g0JeV44iJxT+Yq+SIGRQbrVzwKFO5xyaH/bZtYj8CnS+yCNQ7VNSu
        1U1aZwzjt1F6zBgdLIzKy05f+eNLD1XiHDNIHnRLdMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RKjI56
        eZSahdFm53T7bERiNLEbuyYy0L/X4uwcFh7jk=; b=cSzeUprQy+r0i0SgVf2MSa
        R/WC9NKhrpbyaQXYe/vegaKjR+1rcb+pZJWpHYMWQD7JCot0Gydr+w6sXEtPBX+W
        5I/Or5qbf/r0+VGe123XKTWjA6wfsp+7eu4DVLnjG4RD5cfK8n2ANADePMvu7ADU
        2UDu/VKYNkXCHPBF+f9VpvGEMzeU7mgyN18tSASinAzDyWr+fDypYVcFtniF76/P
        CdOSddcYIuXILRL50kOA4yswyLLb3Rr5cTn4uI1wpQS7d9D1zB9ENvwNcPhB2N2+
        b59zM4AyC5OO/jhQ08jSJJGUaDRciKH2hIX8u73dv8JKR0IAbaDlRSlFqsWNta3w
        ==
X-ME-Sender: <xms:hyJXX5-L_bLEJ2FzkSRgkHNdN4XHHE3LhHa9qJ3sxmD_zgEBdJfpig>
    <xme:hyJXX9to7-GbCQ6fYmHnBjaQaJRT_3E3VacNIJS6L-v4UnJ8dnZ7fbVCopMCBza95
    RBXd3VAXDDiVWB7-Kk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehgtd
    erredttddvnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegt
    vghrnhhordhtvggthheqnecuggftrfgrthhtvghrnhepleekgeehhfdutdeljefgleejff
    ehfffgieejhffgueefhfdtveetgeehieehgedunecukfhppeeltddrkeelrdeikedrjeei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrgi
    himhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:hyJXX3C_aNYMP6tRrDrB9czOhhzBh6G3PHXDWqkWIE7EDvmBpOyAJA>
    <xmx:hyJXX9eOu0b3M8offeMhwoSi4c8AYSSxyFG53Xx5OXiOUwpxemAQ_w>
    <xmx:hyJXX-O_qPycTGaQNAZM47gn0siYczrUuOB2m-7w67Ui9TRIb6zKbA>
    <xmx:iSJXX_hjhjgU5zWBx1jKAzv1HDjupEZ1H3Vsoujjz8V1xs7kPKHtWmJKCBU>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BF0D306467E;
        Tue,  8 Sep 2020 02:19:51 -0400 (EDT)
Date:   Tue, 8 Sep 2020 08:19:49 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        m.cerveny@computer.org
Subject: Re: [PATCH v3] dt-bindings: crypto: Specify that
 allwinner,sun8i-a33-crypto needs reset
Message-ID: <20200908061949.ff7swgzv72lb6jd3@gilmour.lan>
References: <20200907175437.4464-1-clabbe.montjoie@gmail.com>
 <20200908061556.btaokh5ftxng7t7m@gilmour.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iryd3p6ixtmpj24g"
Content-Disposition: inline
In-Reply-To: <20200908061556.btaokh5ftxng7t7m@gilmour.lan>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--iryd3p6ixtmpj24g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2020 at 08:15:56AM +0200, Maxime Ripard wrote:
> On Mon, Sep 07, 2020 at 07:54:37PM +0200, Corentin Labbe wrote:
> > When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs r=
eset.
> > Furthermore, there are no need to use items to list only one compatible
> > in compatible list.
> >=20
> > Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 S=
S")
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
>=20
> Acked-by: Maxime Ripard <mripard@kernel.org>

Nevermind, I assumed that there would be crypto patches, but there's
none so I ended up taking it through our tree.

Maxime

--iryd3p6ixtmpj24g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX1cihQAKCRDj7w1vZxhR
xV/qAP0RW0nf8TN7d3InSANBznts6z4swYydWx6GmDghI3vQ6AD/aqoQ+2nfKpnH
+w2kVaJlNV6BQHjSekjVrwkkcRHEvAU=
=r4P3
-----END PGP SIGNATURE-----

--iryd3p6ixtmpj24g--

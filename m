Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59164C43461
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87512166E
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgIHGQF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:16:05 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:45671 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728775AbgIHGQE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 02:16:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id C7B1CC63;
        Tue,  8 Sep 2020 02:16:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 02:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=zJiWzEaieWUTkjd149kfcmDNEkV
        tYQAGVUYM1KagiNw=; b=HRNaf0nqivK37YCvZIDh7RO8nzWh2/fDKBlD54LoaCB
        0WuDvtZ+DlCtyd39yIGtuTYNwfdaba7UwxDdzJ+BptmBdUVpDH2/adAd2/RRqjOT
        /GQlq2LhQ1KYWmf4epZ2f8UnVTUr+p43QHtLocXelJNBAXW2pidygl9UDqWcEXsX
        zgO9kPmiY7rJoQaMRAYDwRdtqGlB9yBJMp+bJ9/fbsKcJB9a8iRVYSMHFcNkA5sn
        bFyELdF8Mf239H5Xr/ART8E5NliiWGlrgNwWx9EtTthjsHuBsr2SycccMzOnqkFF
        p/QXpI2L57GKQ12/2zA9AiaMoxCaBrnlplSvQjkptSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zJiWzE
        aieWUTkjd149kfcmDNEkVtYQAGVUYM1KagiNw=; b=IlLCEqn+XhMyg6/XVGNmhN
        LWk8MDd3GbNW1g/z9oIm0n8ew3PLMLnK78kvhx6ob6HIZjHn6J+UfyWag3ojzAq4
        vqpRfG0gapKJMYDY5/96h5pjBY2SyLR7LYxn2fgDEakQb9kNxHH8T7aLlLVDhm75
        7tBXP0Aes6TvM9chVc71v3tzQ3U20L4ygbBZdrpWZut7F/KR/J0yZjhZjBOmR00k
        vuY6fTlUVjaHkd6F8D0q/qm8O5BqZACSMfb/VkyLojwPJJorGAaO3WRQXfCOKdS8
        XaA6GlHykoAMpptk5k6upyGKl5ZbQ+t4KrWowRhm7OmE63sdIyuqzf/JVK0rRjcA
        ==
X-ME-Sender: <xms:niFXX_fz-lQYJtSWpVWcbIHXwYaPW-2fr_EmFiqS2A_gn_xIBDOUUw>
    <xme:niFXX1PmswcgkPM5yObjWO9xiVfVJ1Ps6QtLQpo3g2dqi_TxJi3LQ7U_VbSg4H13O
    PpXceE2A2xtIqM2Q8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehuddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehgtd
    erredttddvnecuhfhrohhmpeforgigihhmvgcutfhiphgrrhguuceomhgrgihimhgvsegt
    vghrnhhordhtvggthheqnecuggftrfgrthhtvghrnhepleekgeehhfdutdeljefgleejff
    ehfffgieejhffgueefhfdtveetgeehieehgedunecukfhppeeltddrkeelrdeikedrjeei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrgi
    himhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:niFXX4j7ay4JwOVgMg4twDLEL9eckDyP0h33oIx1LfwTUCo_qknNzw>
    <xmx:niFXXw-1Od6uGH8RcfgSCqIcnfnV2wzn97HSBDVb71cTwPRBml7pTQ>
    <xmx:niFXX7tVVZ81ZuRyhDJyVBQ2ruZ7O6YFvqFIVByKAHETEmP8hxHXaQ>
    <xmx:oCFXXxDWsNJ2_iVkJXv-LE6RR1Pn5GIvWILQNV1o_WVlkMMVK0Rz7-btApk>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 498C53280059;
        Tue,  8 Sep 2020 02:15:58 -0400 (EDT)
Date:   Tue, 8 Sep 2020 08:15:56 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        m.cerveny@computer.org
Subject: Re: [PATCH v3] dt-bindings: crypto: Specify that
 allwinner,sun8i-a33-crypto needs reset
Message-ID: <20200908061556.btaokh5ftxng7t7m@gilmour.lan>
References: <20200907175437.4464-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="apfc6x6gq7uthf7s"
Content-Disposition: inline
In-Reply-To: <20200907175437.4464-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--apfc6x6gq7uthf7s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 07, 2020 at 07:54:37PM +0200, Corentin Labbe wrote:
> When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs res=
et.
> Furthermore, there are no need to use items to list only one compatible
> in compatible list.
>=20
> Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 SS")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime

--apfc6x6gq7uthf7s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX1chnAAKCRDj7w1vZxhR
xfUvAQD8xxLoH6fbnPJmX6BVcYssd2Qs2CpluJZqLpfeHJCOCAEA5LM0Mwzzrnhe
e8swy3maWAsWSzz/kE7LwoDYMGUApAM=
=z7iT
-----END PGP SIGNATURE-----

--apfc6x6gq7uthf7s--

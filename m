Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5495DC433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 09:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29841205CB
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 09:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="X+18kR/d";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rRijvwHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIAJc6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:32:58 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49071 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIAJc4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 05:32:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C4BA659D;
        Tue,  1 Sep 2020 05:32:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 01 Sep 2020 05:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=yIMO5rI2UI9aNW11XZSdXqbn1PQ
        yhmBmZc0nKtxCGM8=; b=X+18kR/dcIcBZlSEKNZXOhlDi6oOIpZCYa/PTp89lmL
        3Sv/TeqqeIqazxg2SKt5L+lfDxSy1AJqwZv8TcPBBBo54xavcK6SGp9btwrWBEqT
        ft4/+FpJ/1KMaRPb0XmjkRvi5Ro+Urd1QsHFSAywSIrPiZP/MqO5EONRCsaO4Tf/
        MHVEAyxcE5lJpT22Z3Xcnj57kHuAdFiVpgu5dCZg+h5pabBVUEcgr8pdvAbRsC8p
        aAx5YWbT0HZAyMJkDE7ANuDB9KOgGlx3LMJXpYJkCvJaLpj2rz96nQok0UbZUanQ
        WY60O4HwzKEOq3EhqfDSfQNsaAe4Sv6kFRO4EwVA5YA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yIMO5r
        I2UI9aNW11XZSdXqbn1PQyhmBmZc0nKtxCGM8=; b=rRijvwHG7QMBE4mEd+P+wt
        /0C1D5h47o1xdCddxPgYcBm5LbgXJT0mq/qkEoRvA6HlnUm7KmRFvMW+Mw5L+Dip
        iZFtCFKFqW/9XI6ydJ4azqYYw8IfYYY1ljXj3o3Jb7/T5bMClRKJlFTxmtu7isGH
        hFDJrt5P+TDmCEsBHaCxyQ+1Ixk6+cr/k5Y8QmNk/tDVLwf0smpRblOEjO3GbJwJ
        7Z3S450xVbiESk60nl1u7iIgfMIfd1VXfN/fTF36gnu86sye4c/6V8potpw2GcPn
        71Re7XB6A/0jgXv6P0LO236LhERlRvdiGcgBoZlmMxFPIbs0BGdF7xslU0T5jFqA
        ==
X-ME-Sender: <xms:RBVOX2ac15VheW_otOioHv7wRO6gfzaQiD0DFJO1_-Du53ZMyA_8eg>
    <xme:RBVOX5ZXT21KpxqdG5NGrBuG3B4zE1hCuonIR64npDTZKuOR7-TGhy-VSKgqjZnu5
    rC4LatSNpmpu2LiLD4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefjedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:RBVOXw9nIZ2dK33-qTY2qPLabpT_d-N1DJi9wVsfM9n9IEbWvfkSWA>
    <xmx:RBVOX4rHhzIuONgF4_EPiGdzMWD2eTorFOPfnFjJat7vZAJcC-LNyg>
    <xmx:RBVOXxq2kVzR3R5hqm_iuUShSdhHaNfxfBu3uhuBAPx1-ACTrFHuLg>
    <xmx:RhVOX1LzNUK-ynqTU9D6E9_IhRaZ0unxXqrWL8ybjYYdamPAhEBrpg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B5D1328005A;
        Tue,  1 Sep 2020 05:32:52 -0400 (EDT)
Date:   Tue, 1 Sep 2020 11:32:49 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Martin Cerveny <m.cerveny@computer.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: add new compatible for V3s
Message-ID: <20200901093249.orwyc5sr3z2y43fz@gilmour.lan>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-2-m.cerveny@computer.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ywkqrhvkhmefty2q"
Content-Disposition: inline
In-Reply-To: <20200831073101.3608-2-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--ywkqrhvkhmefty2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2020 at 09:30:59AM +0200, Martin Cerveny wrote:
> Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> directly in BE. So add new compatible.
>=20
> Tested-by: Martin Cerveny <m.cerveny@computer.org>

The Tested-by tag is for the other developpers. You're very much
expected to have tested your patch before contributing it.

> Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> ---
>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml          | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml
> index fc823572b..180efd13a 100644
> --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto=
=2Eyaml
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto=
=2Eyaml
> @@ -25,6 +25,7 @@ properties:
>            - const: allwinner,sun4i-a10-crypto
>        - items:
>            - const: allwinner,sun8i-a33-crypto
> +      - const: allwinner,sun8i-v3s-crypto

If it's compatible with the A33, why do we need to introduce a new compatib=
le?

> =20
>    reg:
>      maxItems: 1
> @@ -59,7 +60,9 @@ if:
>    properties:
>      compatible:
>        contains:
> -        const: allwinner,sun6i-a31-crypto
> +        oneOf:
> +          - const: allwinner,sun6i-a31-crypto
> +          - const: allwinner,sun8i-v3s-crypto

I guess the A33 compatible should be on that list as well?

Maxime

--ywkqrhvkhmefty2q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX04VNwAKCRDj7w1vZxhR
xUoPAP0aRVMtT5aReBzaR1rKfHMozA+BGin5xSE3NDdtc42+KgEAsOJOAuG0uraq
QzryFy0SRC8lrKJdLsGgk3G1Xt6Uxgg=
=YS/W
-----END PGP SIGNATURE-----

--ywkqrhvkhmefty2q--

Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34271C433E2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F7E2084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 09:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="MRCq8nQv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="da5TGH2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgIDJWB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:22:01 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34395 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729712AbgIDJV7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 05:21:59 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2020 05:21:58 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CC571580383;
        Fri,  4 Sep 2020 05:15:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 04 Sep 2020 05:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=rPHib73BNe2yJpxQ7N76hqf1+YQ
        0PpnAHpyX+PBHPHo=; b=MRCq8nQvllk1NZEUvEqqyoTKwToKn+YZxRLmHaKeMkk
        iyv3nm+Es3nSXJmUhrA+jBX+cLKG4VvZM0oe1yulLdqucwfXiAXoBALd8a2Gj/Nm
        A3urSgadFqxMSnSJaEzezV2MwZZ0TY3KmkdYeVO7v4X/OmTADaNPxFikGW20MQZu
        9agrkBJUna5KkhNlZAO51hAhfwZmZk5iN8uA8/XDxlm+3CHsffhQnhLCerk/mBWu
        ZAKdxnKaEH54BGRX+iKZ4U3oMEYH35PXhBudtHiH0LJUEjxGyIyEZc/MytI7YvLP
        ZgXqXakNciFyqNRqcRmDPzJ8EjfzuAucCc5b22kqAPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rPHib7
        3BNe2yJpxQ7N76hqf1+YQ0PpnAHpyX+PBHPHo=; b=da5TGH2kc8dVL5zmavPo+1
        yLu/nJQp1JXkmnTWB1yQOpI80gt9qoMJ7XpXCxKY6fBW6n5QRWecZ7Gh1Bo/Z8n4
        HnYcqDnGZk02o5/2lAOLOde3bm3FHsFccc/Z9z44qIs1Ck80m5V8vUBpobgGjIA/
        mZju82dsrYkz61Q3MxCmqvBQOH5TIMHsNGS9r7F+toscAnNj1Iu0XK2HslEKAY2P
        Wbz/rkkU4WOhorB9kJ7ZweoiBJZ4S0MyhatRvaDfXmy5hFzcA3JWLO2ZxMftZaot
        rm3hE/NvY6lydJWuGgh1DaF4N8iOfFI501q7qrQbK8n2lWmSUsjshxkxKkEBeDTQ
        ==
X-ME-Sender: <xms:qgVSX5uGJu4UeKguzMZCO8CCRBDNU7IfXAaXGF_U3SiRirCSPqoE4g>
    <xme:qgVSXyeuMMxL8sD-rrqgsl5KzvEvnq5-aVUPjLooVAEONZmqrWYR4BSKjz_rTNAzs
    bUX-CvMqXUddF0QWVc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesghdtre
    ertddtvdenucfhrhhomhepofgrgihimhgvucftihhprghrugcuoehmrgigihhmvgestggv
    rhhnohdrthgvtghhqeenucggtffrrghtthgvrhhnpeelkeeghefhuddtleejgfeljeffhe
    ffgfeijefhgfeufefhtdevteegheeiheegudenucfkphepledtrdekledrieekrdejieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:qgVSX8yIhQLFJEx5N92PNqZlRNxk4nskH6OPfGQqWr0ixrLobVSGQQ>
    <xmx:qgVSXwPztVTPGbjCOioW2gsk8auO5lz1Haje_4Os8Ikf_V3Me9q-MQ>
    <xmx:qgVSX5_u1GZxe1EM7TmMdBmM3duz6SuZ-cbeFdgOIYYMfMkTW1VUoA>
    <xmx:rAVSX4baiUipkmSAjeUd2zBLs4_T2TObQYwnTXCM7i2pX-egAi9v8Q>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2528C3060060;
        Fri,  4 Sep 2020 05:15:22 -0400 (EDT)
Date:   Fri, 4 Sep 2020 11:15:20 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, robh@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, m.cerveny@computer.org
Subject: Re: [PATCH v2] dt-bindings: crypto: Specify that
 allwinner,sun8i-a33-crypto needs reset
Message-ID: <20200904091520.cwrovnbb2squze5h@gilmour.lan>
References: <20200903145445.31779-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ywcvreqcqed5i46k"
Content-Disposition: inline
In-Reply-To: <20200903145445.31779-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--ywcvreqcqed5i46k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2020 at 04:54:45PM +0200, Corentin Labbe wrote:
> When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs res=
et.
> Furthermore, there are no need to use items to list only one compatible
> in compatible list.
>=20
> Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 SS")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
> Change since v1:
> - use an enum for adding allwinner,sun8i-a33-crypto to "reset list"
>=20
>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml        | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml
> index fc823572bcff..279f4a2e1dd7 100644
> --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto=
=2Eyaml
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto=
=2Eyaml
> @@ -23,8 +23,7 @@ properties:
>        - items:
>            - const: allwinner,sun7i-a20-crypto
>            - const: allwinner,sun4i-a10-crypto
> -      - items:
> -          - const: allwinner,sun8i-a33-crypto
> +      - const: allwinner,sun8i-a33-crypto
> =20
>    reg:
>      maxItems: 1
> @@ -59,7 +58,9 @@ if:
>    properties:
>      compatible:
>        contains:
> -        const: allwinner,sun6i-a31-crypto
> +        enum:
> +          - const: allwinner,sun6i-a31-crypto
> +          - const: allwinner,sun8i-a33-crypto

That's not the proper syntax for an enum, this would be

> +        enum:
> +          - allwinner,sun6i-a31-crypto
> +          - allwinner,sun8i-a33-crypto

Maxime

--ywcvreqcqed5i46k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX1IFqAAKCRDj7w1vZxhR
xb4YAP9AndsjE//mBZmHVJjQxFxeoOtzDPG51bM/OUpqPddYmwD/fVvGjW3eKS5y
J1RNMIZV2ualGb2JEL41KdNHYyCyfAk=
=36HK
-----END PGP SIGNATURE-----

--ywcvreqcqed5i46k--

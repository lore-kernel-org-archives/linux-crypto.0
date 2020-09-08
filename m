Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA70C433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF9021897
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 06:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgIHGUP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:20:15 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44301 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbgIHGUO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 02:20:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id DEF1ED60;
        Tue,  8 Sep 2020 02:20:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 02:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cA+1FFkzRN/i815ushS2Yuoq14C
        CTHDuKJOCWTVbj6g=; b=OLhvtTqz7N/y+06PZChc7Om8Yeqr6zXeenyhdVKBVj3
        u38WNrGXfdtrid9HSnA2dobRf8cbw2xNm4s3sivfRfo1q/GVIih+joDWgvI3P6mj
        3Dy1po5/Mhdvd9MMvJdNaiz9DhYzoKmfwAJMnEIzPkLG/BvxR7r37plOgM5Lve/d
        1CFfXRtxxR27hSHLScf7DXLAqTSvRhpPfmO++Hn1JO55JnUQP8K73FJwbx9D/N34
        9LA8pou+kRt9vc6pCAVK4xq3Zi4Tj9eAj7kVBtt/7eDRI7SaY7djoxQOxQN7n6F3
        H2EEBhZOmDzOFHZZP1yqT3MQFK7VHt0YQPVXNLzX2sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cA+1FF
        kzRN/i815ushS2Yuoq14CCTHDuKJOCWTVbj6g=; b=igXWE9laB1QOzhOZHUpbU9
        x4hovbxY+ke58l4usd/5kxkMDMzTzYMDN+G+pH7daPHlkhUcHlzrqyj9Ah67Q0Yg
        uqhEL5pquXohfTl/Ab5K9lcEAsnHXT8nPKI7oZG7QpFr/HVhSLcvYKuGmQ8aH375
        /M+dUzW4DBfaXE/ubxPxz9TdP211fe4ICsJw6H85i5/DjvZIAxJmap3vD/vtF5PK
        iWFK51L/PPda7cWRM3JDY84SBGqRnvzrTHXdOLycAxRrYRxKeqzSxm0k4+I5SYxI
        ggxB0CGZ8clDUPCpy5Fk9f0Q9hgdpDlGvxRKbhK0fnMAfA60eTTYtA3fYiiCsNbw
        ==
X-ME-Sender: <xms:nCJXX6qVYNJwycDIDgnMbRbwoyB2rZyOZ9i9anMh_AogTdCS6R8tVA>
    <xme:nCJXX4qRRAYyV9-CBzZ2sLhEHQuu3eJFWS-1ePfywZLy1ZX2uynGlz94rRIPm4y0H
    s7Rl-b8PuqlYmEgBYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheei
    heegudenucfkphepledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:nCJXX_NLjBTGU8VBMDcLMrnUHs1BQkVVR79WdMe28TIMu--Ecp_FhA>
    <xmx:nCJXX54U4M6OYn3p0p6Xj6rjefSma5rgEotF9KFouvk3d36jD0XnzQ>
    <xmx:nCJXX55_2qm965HsROD-BuHtWPzqDi6H4fqBxhBnEUkLPTvM61ht9g>
    <xmx:nCJXX3TDy7UrTez7lK9aI1QC6LgvlaF709_bwmbR3QDIKZnrq7y5fw>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BC30328005D;
        Tue,  8 Sep 2020 02:20:12 -0400 (EDT)
Date:   Tue, 8 Sep 2020 08:20:11 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Martin Cerveny <m.cerveny@computer.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 0/2] ARM: dts: sun8i: v3s: Enable crypto engine
Message-ID: <20200908062011.srcgzg6q4t6up4na@gilmour.lan>
References: <20200907162458.23730-1-m.cerveny@computer.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="snpgtitq7enspzex"
Content-Disposition: inline
In-Reply-To: <20200907162458.23730-1-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--snpgtitq7enspzex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 07, 2020 at 06:24:56PM +0200, Martin Cerveny wrote:
> Add support for crypto engine (sun4i-ss) for Allwinner V3s.
> Functionality like A33 so add only compatible and enable
> in device tree.
>=20
> Regards.

Applied, thanks
Maxime

--snpgtitq7enspzex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX1cimwAKCRDj7w1vZxhR
xR+EAP41cPkvcWKRNEhE+APLq613AP29gYkthszjAn4FjVddMgEAxbtS3EOJF7/I
MP+hzIEbCVi6XA1iQuBNAihkYJHpAws=
=OS+M
-----END PGP SIGNATURE-----

--snpgtitq7enspzex--

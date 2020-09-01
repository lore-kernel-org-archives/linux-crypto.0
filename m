Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E63FC433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 09:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AA3205CB
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 09:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="bXqlA4Z9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Uv3BaHiM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgIAJd4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:33:56 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38467 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgIAJdz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 05:33:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8C4F86B6;
        Tue,  1 Sep 2020 05:33:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 01 Sep 2020 05:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Qy4b3a/hLwELlQ2WPf1CFiGP2Qo
        vg9KIAFeu1mPDSvY=; b=bXqlA4Z9klRetsp0xQ+5HE3UnzcTecZnfqfMwuNbxQW
        nKN27FxeDoUeQvmGYxNt1m4rWTV8q0lGmPw1n08fnCy++RZfdJL1Naon43Ke0fcr
        huEXpYAnsNLO7hobdXA6JL9B/Mpz0Jkt6wDsBP2HF9933c79Sv5HOUQJmNOzHk8i
        as4jb0HSsxAgb3+lLaDLanWh6gVmVSC56wmJFNI8mbYAzAXpMEr3yzUbSn6QzC/N
        5f5anOuvNl6CxdKvSYfh0ZM4PXGv48lJgcfb8UxUGdL676OzFo9ggZALM9/HbPZi
        Df0ome1i0HeSaMT8ub/IMGdezVrrjAehJl61IO9aCpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Qy4b3a
        /hLwELlQ2WPf1CFiGP2Qovg9KIAFeu1mPDSvY=; b=Uv3BaHiMJilb1E4oxUzS6B
        cWP2Vk4F8XQLCH0Csxuj6zjYoauCzDDWZI3eTuk4uAdxKlYQN1c2DYPT90pVY8/l
        5NaxKU8JXaG1dkM/gB0gB00tButTTEih7iAPByQjzx7tLLW3Ne/0z5ILgGlqPeai
        JXg0el3BE9wX70b3s34UMWepXKZ42awgNe9T/Wt/tC/T2UYz4Qe5oWUwBNSYhNTZ
        aaIt9zHCHH49lZtyQ5H/aakXZQtC2qVTHeJcBBe6pQsnqZ6EfTN9xWn8R/PhUAG4
        iISkG8gPux3BSVWUhjzrGJ945T+KJtcwkCM/sACwK9WwRjs50dz3Xi/CWF4TW/YQ
        ==
X-ME-Sender: <xms:gBVOX8GlwPPYStN1Nc7gNuuKCUxCVQhJy2yyKP3YqnBzenRJIv8zdw>
    <xme:gBVOX1UV1FEQT_-L_HRnoQXWFuGBPoZ1fqxwDXwj48qfLiOUfi-Aiw84j_bUeUoNI
    nfq3wq2x_s4gOuN5bM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefjedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:gBVOX2LLM7pj61Qht8MsBO8PlnZHWumqoUU6kjlpnkOBeik-_OLHYg>
    <xmx:gBVOX-EQA5AXpTMe2tpgecHq7j-AFk8Uq7JKGPNUAODoytHG-Gb37g>
    <xmx:gBVOXyUaKPxIuNG3gT7Mm3jB1X63KbLPBFwSjhoggtpXU2UwHxIQww>
    <xmx:ghVOX9Ge8evUprixSAcEG5QSfWvmg8LuleapqSpiP-1fopuBpjQqwg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 773523060067;
        Tue,  1 Sep 2020 05:33:52 -0400 (EDT)
Date:   Tue, 1 Sep 2020 11:33:51 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Martin Cerveny <m.cerveny@computer.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: dts: sun8i: v3s: Enable crypto engine
Message-ID: <20200901093351.hvhllu56trn2jzbq@gilmour.lan>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-3-m.cerveny@computer.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3n7a522liw5fr4d4"
Content-Disposition: inline
In-Reply-To: <20200831073101.3608-3-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--3n7a522liw5fr4d4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2020 at 09:31:00AM +0200, Martin Cerveny wrote:
> V3s contains crypto engine that is compatible with "sun4i-ss".
>=20
> Tested-by: Martin Cerveny <m.cerveny@computer.org>
> Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> ---
>  arch/arm/boot/dts/sun8i-v3s.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-v3s.dtsi b/arch/arm/boot/dts/sun8i-v=
3s.dtsi
> index e5312869c..4fec84c40 100644
> --- a/arch/arm/boot/dts/sun8i-v3s.dtsi
> +++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
> @@ -234,6 +234,16 @@
>  			#size-cells =3D <0>;
>  		};
> =20
> +		crypto: crypto@1c15000 {

Do you really need a label here?

Maxime

--3n7a522liw5fr4d4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX04VfwAKCRDj7w1vZxhR
xU5rAP9EZzoPtiehJZAM5q3RHCY7jB2ixyZnn96TaezyRsNLKAD+Kh56vYnRtYRW
haFBNIyLoNukqd38YOGVkPIWEEmQJg0=
=NvL5
-----END PGP SIGNATURE-----

--3n7a522liw5fr4d4--

Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED27C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D9C2083B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cerno.tech header.i=@cerno.tech header.b="Yx44iNqe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SMritBNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgIBO5w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:57:52 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:47037 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726933AbgIBN4U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 09:56:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id B29D1E92;
        Wed,  2 Sep 2020 09:24:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 02 Sep 2020 09:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=S1KV3nI64hhT/mKCf1wfItxnVYO
        BuX2wNhthrjSZo+s=; b=Yx44iNqenHJ2AzlLxKapbjobi4SWwDo0jvM7+dSERrR
        JXonAEumDUROGJ53H0VGYIVLmsYmurcaTQEoU/Az6TpvpbCtdpOg7MwPCEBXTGae
        yfIVSFlCFQAPJ7og14tmWqm34R3RkGA9gnll0zAahWVZuQXn7bwa++19NpTXhOIb
        rNWZKQoz5xlc16X435hs34zdUpL8k/JeBmqLiqC4S6oj4fsdKyF9aOOK5WtVQyc5
        TZLTDf48SuEO95jsmUjnMgb4PJG6qMbGnwPA/FBTvrsqdR9tOk4eJUZevK44GWnA
        gFb6O9iFP+OLlz95mxIeTr8Vpoel8cZHzpvhgtn58bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=S1KV3n
        I64hhT/mKCf1wfItxnVYOBuX2wNhthrjSZo+s=; b=SMritBNmBee+ty0P4Vhzmo
        vTpXHT0HkcLN8F+sNBgPW377vu+LJ0wnoJ7TJR8pfEqSm8GneIWm3qqXnRjrasv2
        IWCqeVtqigVOIDE2FMI281N71wMVan3pKuOU97e8m6LPET0Fc7RPiNCO4FdoR1Rx
        mRAt41870d5P0r1qzHoq53ukhQYSx8QLT8Ik3mAvo/M36sTm1uAODRQ6xdwY+R//
        dLrs9mRtQ1kWzDj7K1u6AmNX5UQQYxWVu1MdqmNr0z6cKlCJRpMoOqfwDA1agkI7
        YpbeIG1RhaGdkLGobj2663x0rifWF2T/MVEh1AcN1TE9EltnbB6w8QZYfFrsVhGQ
        ==
X-ME-Sender: <xms:FJ1PX1O4T2jAdVdl0dY1CPCz4s7Wz3xrdeQhKNgtx7-53rkyF8Ok2g>
    <xme:FJ1PX38pBjib1A3Yt_yKkPpOqRseEyqY9nWuvjfqhYFUtX0KKC7YptBTHjx8jPPpm
    FFJh1Z21BtQ-GQyoWU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefledgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesghdtre
    ertddtvdenucfhrhhomhepofgrgihimhgvucftihhprghrugcuoehmrgigihhmvgestggv
    rhhnohdrthgvtghhqeenucggtffrrghtthgvrhhnpeelkeeghefhuddtleejgfeljeffhe
    ffgfeijefhgfeufefhtdevteegheeiheegudenucfkphepledtrdekledrieekrdejieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:FJ1PX0QdXL5HHA7gAZCBIDRGeUKub0ELcTOF_Ms1embGqORBFFuSww>
    <xmx:FJ1PXxv6Fgd_54pfhl3xcuxAcsVukTxdHeSyFZD3xEtc0XRNomZ2cQ>
    <xmx:FJ1PX9eDpOAu1C8yGT7Am2bLaGjq5QGBf_CTgJW6pxIBkYfd5pXE2g>
    <xmx:GJ1PX57XGox0HtNz24ymlFX37h_Rx419G43Fy2k20OlEGQFCL7ZJS0A6554>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34A673280063;
        Wed,  2 Sep 2020 09:24:36 -0400 (EDT)
Date:   Wed, 2 Sep 2020 15:24:34 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, robh@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, m.cerveny@computer.org
Subject: Re: [PATCH] dt-bindings: crypto: Specify that
 allwinner,sun8i-a33-crypto needs reset
Message-ID: <20200902132434.qpevlbyx5wgq4daj@gilmour.lan>
References: <20200902091716.22650-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lesihmyf7bejvih5"
Content-Disposition: inline
In-Reply-To: <20200902091716.22650-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--lesihmyf7bejvih5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 02, 2020 at 11:17:16AM +0200, Corentin Labbe wrote:
> When adding allwinner,sun8i-a33-crypto, I forgot to add that it needs res=
et.
> Furthermore, there are no need to use items to list only one compatible
> in compatible list.
>=20
> Fixes: f81547ba7a98 ("dt-bindings: crypto: add new compatible for A33 SS")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml        | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10=
-crypto.yaml
> index fc823572bcff..1075f0e75368 100644
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
> +        oneOf:
> +          - const: allwinner,sun6i-a31-crypto
> +          - const: allwinner,sun8i-a33-crypto

Even though it works, an enum would be best here

Maxime

--lesihmyf7bejvih5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX0+dEgAKCRDj7w1vZxhR
xU0kAQCaTwLCXsqCEwANF758p9F7IT1H11DgVKytNwdpoVbCNAEA27d6vz1r1Ke6
6V2UM0Ao1xcmpQ3fTSAvvAv2VQJagwg=
=30nP
-----END PGP SIGNATURE-----

--lesihmyf7bejvih5--

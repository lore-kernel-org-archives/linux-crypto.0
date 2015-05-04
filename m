From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] hw_random: bcm63xx-rng: Fix driver compilation
Date: Mon, 4 May 2015 17:57:56 +0800
Message-ID: <20150504095756.GB30092@gondor.apana.org.au>
References: <1430491041-24480-1-git-send-email-noltari@gmail.com>
 <1430561322-26309-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dmitry.torokhov@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, jogo@openwrt.org,
	f.fainelli@gmail.com, cernekee@gmail.com
To: =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51151 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbEDJ6B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 05:58:01 -0400
Content-Disposition: inline
In-Reply-To: <1430561322-26309-1-git-send-email-noltari@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 02, 2015 at 12:08:42PM +0200, =C1lvaro Fern=E1ndez Rojas wr=
ote:
> - s/clk_didsable_unprepare/clk_disable_unprepare
> - s/prov/priv
> - s/error/ret (bcm63xx_rng_probe)
>=20
> Fixes: 6229c16060fe ("hwrng: bcm63xx - make use of devm_hwrng_registe=
r")
> Signed-off-by: =C1lvaro Fern=E1ndez Rojas <noltari@gmail.com>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

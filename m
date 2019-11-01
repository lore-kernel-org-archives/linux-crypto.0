Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE1ECA9ECF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 09:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF5C217F9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 09:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572600850;
	bh=0jCij/Fv8ugOCVAh4PqFfAXdu/PxgN5AcduaY+7TskQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yy6fkMR8TjJf12+8Kuc+AGdMuWCgSH3HxtR7FKexzge2PTyR6y+PHCVoKrPk6eRmz
	 sINw3xTEZbR5GEoVxJAjRsjaEtOlG6+zNMorFgmDk1mT9gfLna9TAgUGo9OKtrAMm/
	 uHbzXCBnBkV3qf6BWIfXNrUs5AVvIhtGy+qNB2qY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfKAJeJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 05:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfKAJeJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 05:34:09 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF46321734;
        Fri,  1 Nov 2019 09:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572600848;
        bh=0jCij/Fv8ugOCVAh4PqFfAXdu/PxgN5AcduaY+7TskQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r20eSui4efPABmYo7hpS0vYVKlcPj8rC24asoji9XM5GANsx40FkR/8T+L4QEfS+c
         ySou75re54nj88ZPjkzC5BKc0ECclHEmHcEdLWXOPQDeTNeNHdWNgC86bZmua5pwxJ
         tCGk8Y9PWOTFmXYWYqjI017VLS81unr9CPgr6FHs=
Date:   Fri, 1 Nov 2019 09:58:57 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>, davem@davemloft.net,
        mark.rutland@arm.com, p.zabel@pengutronix.de, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 0/4] crypto: add sun8i-ss driver for Allwinner
 Security System
Message-ID: <20191101085857.bukatiog3zxugjng@hendrix>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
 <20191101061154.abwwbcqzm6lg7uvi@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="phjdavwqd433by7q"
Content-Disposition: inline
In-Reply-To: <20191101061154.abwwbcqzm6lg7uvi@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--phjdavwqd433by7q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2019 at 02:11:54PM +0800, Herbert Xu wrote:
> On Fri, Oct 25, 2019 at 08:51:24PM +0200, Corentin Labbe wrote:
> > Hello
> >
> > This patch serie adds support for the second version of Allwinner Security System.
> > The first generation of the Security System is already handled by the sun4i-ss driver.
> > Due to major change, the first driver cannot handle the second one.
> > This new Security System is present on A80 and A83T SoCs.
> >
> > For the moment, the driver support only DES3/AES in ECB/CBC mode.
> > Patchs for CTR/CTS, RSA and RNGs will came later.
> >
> > This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
> > and tested on:
> > sun8i-a83t-bananapi-m3
> > sun9i-a80-cubieboard4
> >
> > This serie is based on top of the "crypto: add sun8i-ce driver for
> > Allwinner crypto engine" serie.
> >
> > Regards
> >
> > Changes since v2:
> > - Made the reset mandatory
> > - Removed reset-names
> >
> > Changes since v1:
> > - fixed uninitialized err in sun8i_ss_allocate_chanlist
> > - Added missing commit description on DT Documentation patch
> >
> > Corentin Labbe (4):
> >   crypto: Add Allwinner sun8i-ss cryptographic offloader
> >   dt-bindings: crypto: Add DT bindings documentation for sun8i-ss
> >     Security System
> >   ARM: dts: sun8i: a83t: Add Security System node
> >   ARM: dts: sun9i: a80: Add Security System node
> >
> >  .../bindings/crypto/allwinner,sun8i-ss.yaml   |  61 ++
> >  arch/arm/boot/dts/sun8i-a83t.dtsi             |   9 +
> >  arch/arm/boot/dts/sun9i-a80.dtsi              |   9 +
> >  drivers/crypto/allwinner/Kconfig              |  28 +
> >  drivers/crypto/allwinner/Makefile             |   1 +
> >  drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
> >  .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 438 ++++++++++++
> >  .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 642 ++++++++++++++++++
> >  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  | 218 ++++++
> >  9 files changed, 1408 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> >  create mode 100644 drivers/crypto/allwinner/sun8i-ss/Makefile
> >  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> >  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> >  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
>
> Patches 1,2 applied.  Thanks.

Applied 3 and 4, thanks!
Maxime

--phjdavwqd433by7q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXbvz0QAKCRDj7w1vZxhR
xVjTAQCdeiXvBM+rscw9plENTZiXAjVbmkADgjas85s2VUzpVQEA04vUS0idMiY/
RxN28qg8bHvQsTZGYtLIbTxPsSpgCQI=
=vYi/
-----END PGP SIGNATURE-----

--phjdavwqd433by7q--

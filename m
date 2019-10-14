Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8702EC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 10:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F98820873
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 10:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571050036;
	bh=vpT/FdAQ44SBsZqxdUofQB31bkhK8wj8sizQkj6Rfqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qYt2kJMeUqCIhYw70HM3KsM9UvcxCnLVqk/JIgAr57YmOB2T2ftbEd5Fb9gDTQ6GM
	 umIz0rIKxUPI1sU7qATfuw+H3Dudx5eLQEhZzsZTR89B3CsRMbdUlnnG2IIZsP+Dot
	 sYJfobUt3cxCDvCMXcvEuBRzF+5a3gIyC3zQ32hY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfJNKrM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 06:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731441AbfJNKrM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 06:47:12 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B63207FF;
        Mon, 14 Oct 2019 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571050031;
        bh=vpT/FdAQ44SBsZqxdUofQB31bkhK8wj8sizQkj6Rfqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0VN86+4Hapr2bz8SmKNW0OAHIY5s6XTT+UUe+ks4FaZJU8axqfv6lRn4n2yxnJjN
         bQxyixquGe2nnkcmufn+A+wO7T++zcOQaj0v01N1kW1XAfCoNz/6RDCmT2E2wAY3yX
         KAkSdaQeLsqLdUEQknpou+rGkikvp6Ew36LzuQHs=
Date:   Mon, 14 Oct 2019 12:47:08 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 00/11] crypto: add sun8i-ce driver for Allwinner
 crypto engine
Message-ID: <20191014104708.cur6zbabmozhwu5o@gilmour>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jcraal7cz45esj3i"
Content-Disposition: inline
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--jcraal7cz45esj3i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sat, Oct 12, 2019 at 08:48:41PM +0200, Corentin Labbe wrote:
> Hello
>
> This patch serie adds support for the Allwinner crypto engine.
> The Crypto Engine is the third generation of Allwinner cryptogaphic offloader.
> The first generation is the Security System already handled by the
> sun4i-ss driver.
> The second is named also Security System and is present on A80 and A83T
> SoCs, originaly this driver supported it also, but supporting both IP bringing
> too much complexity and another driver (sun8i-ss) will came for it.
>
> For the moment, the driver support only DES3/AES in ECB/CBC mode.
> Patchs for CTR/CTS/XTS, RSA and RNGs will came later.
>
> This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
> and tested on:
> sun50i-a64-bananapi-m64
> sun50i-a64-pine64-plus
> sun50i-h5-libretech-all-h3-cc
> sun50i-h6-pine-h64
> sun8i-h2-plus-libretech-all-h3-cc
> sun8i-h2-plus-orangepi-r1
> sun8i-h2-plus-orangepi-zero
> sun8i-h3-libretech-all-h3-cc
> sun8i-h3-orangepi-pc
> sun8i-r40-bananapi-m2-ultra

for the drivers/crypto part
Acked-by: Maxime Ripard <mripard@kernel.org>

I'll merge the dt and defconfig bits when Herbert will be ok with the
changes.

Maxime

--jcraal7cz45esj3i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXaRSLAAKCRDj7w1vZxhR
xbAiAQCXNw9TZ+NI9M/ffhLEMVuGBoKDSMxJpeuryNZeejUpbAEAotBuhlogZFYt
6gcqR7k6JoRm4LKGytJt02QqNsKkQAI=
=JdiC
-----END PGP SIGNATURE-----

--jcraal7cz45esj3i--

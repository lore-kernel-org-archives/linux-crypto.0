Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04A6CCA47B
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jul 2022 13:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiGBNKq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jul 2022 09:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGBNKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jul 2022 09:10:46 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769BD9FFD;
        Sat,  2 Jul 2022 06:10:40 -0700 (PDT)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id CB176E0004;
        Sat,  2 Jul 2022 13:10:32 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v7 00/33] crypto: rockchip: permit to pass self-tests
Date:   Sat, 02 Jul 2022 15:10:22 +0200
Message-ID: <5836825.lOV4Wx5bFT@bagend>
Organization: Connecting Knowledge
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4750321.31r3eYUQgx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--nextPart4750321.31r3eYUQgx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Sat, 02 Jul 2022 15:10:22 +0200
Message-ID: <5836825.lOV4Wx5bFT@bagend>
Organization: Connecting Knowledge
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0

On Sunday, 8 May 2022 20:59:24 CEST Corentin Labbe wrote:
> The rockchip crypto driver is broken and do not pass self-tests.
> This serie's goal is to permit to become usable and pass self-tests.
> 
> This whole serie is tested on a rk3328-rock64, rk3288-miqi and
> rk3399-khadas-edge-v with selftests (with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)

https://salsa.debian.org/kernel-team/linux/-/merge_requests/493 is where I 
integrated this patch set with the Debian kernel and tested that successfully 
on my Pine64 Rock64.
IOW: Tested-by Diederik de Haas <didi.debian@cknow.org>

AFAIK, this patch set has also been tested on rk3399-rockpro64 by sigmaris.
--nextPart4750321.31r3eYUQgx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCYsBDvgAKCRDXblvOeH7b
blpaAP9kFZ/boaOXl0bbOZEIBmCFypk1uuBcJuyFoKwO5UqmFQD+IfGRbHcHhnvC
lA2OKhtfIjfHBONu1gwLt9f2XbMMBQk=
=PeHT
-----END PGP SIGNATURE-----

--nextPart4750321.31r3eYUQgx--




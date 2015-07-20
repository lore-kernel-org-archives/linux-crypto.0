From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: caam - fix ERA property reading
Date: Mon, 20 Jul 2015 16:10:25 +0800
Message-ID: <20150720081025.GA12908@gondor.apana.org.au>
References: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51709 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbbGTIKa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 04:10:30 -0400
Content-Disposition: inline
In-Reply-To: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 17, 2015 at 04:54:51PM +0300, Horia Geant=C4=83 wrote:
> From: Alex Porosanu <alexandru.porosanu@freescale.com>
>=20
> In order to ensure that the ERA property is properly read from DT
> on all platforms, of_property_read* function needs to be used.
>=20
> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

All applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

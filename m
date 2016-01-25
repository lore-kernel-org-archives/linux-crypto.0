From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: caam - enable LARGE_BURST for enhancing DMA
 transactions size
Date: Mon, 25 Jan 2016 22:48:12 +0800
Message-ID: <20160125144812.GF8840@gondor.apana.org.au>
References: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
 <1452611650-15803-3-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alex Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54680 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbcAYOsP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:48:15 -0500
Content-Disposition: inline
In-Reply-To: <1452611650-15803-3-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 05:14:10PM +0200, Horia Geant=C4=83 wrote:
> Increasing CAAM DMA engine transaction size either
> -reduces the number of required transactions or
> -adds the ability to transfer more data with same transaction count
>=20
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

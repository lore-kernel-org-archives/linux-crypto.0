From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - fix ahash algorithms registration
Date: Mon, 25 Apr 2016 19:22:27 +0800
Message-ID: <20160425112227.GB10114@gondor.apana.org.au>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461255895-13150-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40813 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbcDYLWf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 07:22:35 -0400
Content-Disposition: inline
In-Reply-To: <1461255895-13150-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 21, 2016 at 07:24:55PM +0300, Horia Geant=C4=83 wrote:
> Provide hardware state import/export functionality, as mandated by
> commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
>=20
> Cc: <stable@vger.kernel.org> # 4.3+
> Reported-by: Jonas Eymann <J.Eymann@gmx.net>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>

Applied to cryptodev.  As with other statesize fixes, I'd like
this to go into the next merge window.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

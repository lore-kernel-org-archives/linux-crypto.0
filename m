From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: talitos - fix conversion to new AEAD
 interface
Date: Wed, 20 Apr 2016 17:58:38 +0800
Message-ID: <20160420095838.GB3003@gondor.apana.org.au>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52267 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786AbcDTJ6n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 05:58:43 -0400
Content-Disposition: inline
In-Reply-To: <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 19, 2016 at 08:33:46PM +0300, Horia Geant=C4=83 wrote:
> Jonas Eymann reports a crash and some failures of AED algorithms
> with kernel 4.4.6, all easily reproducible with tcrypt.
>=20
> These have to do with the onversion to the new AEAD interface:
> aeb4c132f33d crypto: talitos - Convert to new AEAD interface
>=20
> Problems occur for 4.3+ kernels, sending patches to -stable.
>=20
> (*) Proper fix for hash algorithms registration failures
> (implementation of import/export functionality) will be added separat=
ely.

Both applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix ERA retrieval function
Date: Sun, 9 Feb 2014 17:22:49 +0800
Message-ID: <20140209092249.GH19429@gondor.apana.org.au>
References: <1391675239-11289-1-git-send-email-alexandru.porosanu@freescale.com>
 <52F358C8.2020105@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Porosanu <alexandru.porosanu@freescale.com>,
	linux-crypto@vger.kernel.org, vakul@freescale.com,
	ruchika.gupta@freescale.com
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35024 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaBIJWu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:22:50 -0500
Content-Disposition: inline
In-Reply-To: <52F358C8.2020105@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 06, 2014 at 11:41:28AM +0200, Horia Geant=C4=83 wrote:
> On 2/6/2014 10:27 AM, Alex Porosanu wrote:
> >SEC ERA has to be retrieved by reading the "fsl,sec-era" property
> >from the device tree. This property is updated/filled in by
> >u-boot.
> >
> >Change-Id: Ie1620354a0cf2cac5cd2c72bd5f2449f55858378
>=20
> Change-Id should be dropped.
>=20
> >Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> >---
> >  drivers/crypto/caam/ctrl.c | 36 ++++++++++------------------------=
--
> >  drivers/crypto/caam/ctrl.h |  2 +-
> >  2 files changed, 11 insertions(+), 27 deletions(-)
>=20
> Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

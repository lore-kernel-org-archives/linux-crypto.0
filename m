From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Thu, 23 Jul 2015 09:53:03 +0800
Message-ID: <20150723015303.GA9777@gondor.apana.org.au>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
 <20150722013241.GA31240@gondor.apana.org.au>
 <55AF19D0.5040700@intel.com>
 <55AF855A.9000202@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	Tudor =?utf-8?B?QW1ixINydciZ?= <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35211 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbGWBxP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 21:53:15 -0400
Content-Disposition: inline
In-Reply-To: <55AF855A.9000202@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 02:58:18PM +0300, Horia Geant=C4=83 wrote:
>=20
> OTOH, caam has SG support for all PK operations, including rsa-encryp=
t,
> rsa-decrypt primitives.
> We are working at upstreaming - aligning our internal caam-pkc with
> akcipher.

OK.  Then we should tweak our interface to allow SGs.  Tadeusz?

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

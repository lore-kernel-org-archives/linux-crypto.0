From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - fix rfc4106 encap shared descriptor
Date: Fri, 31 Jul 2015 15:20:35 +0800
Message-ID: <20150731072035.GA25479@gondor.apana.org.au>
References: <55BA435C.1000803@freescale.com>
 <1438283478-32198-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42920 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbGaHUj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 03:20:39 -0400
Content-Disposition: inline
In-Reply-To: <1438283478-32198-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 10:11:18PM +0300, Horia Geant=C4=83 wrote:
> The encap shared descriptor was changed to use the new IV convention.
> In the process some commands were shifted, making the output length
> zero, caam effectively writing garbage in dst.
>=20
> While here, update the decap descriptor to execute the "write" comman=
ds
> before the "read"s (as it previously was).
> This makes sure the input fifo is drained before becoming full.
>=20
> Fixes: 46218750d523 ("crypto: caam - Use new IV convention")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>

Patch applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

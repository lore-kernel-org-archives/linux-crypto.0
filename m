From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 22:03:18 +0800
Message-ID: <20150730140318.GA17848@gondor.apana.org.au>
References: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
 <20150730134618.GA17539@gondor.apana.org.au>
 <55BA2DA5.8000807@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44563 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbG3ODV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 10:03:21 -0400
Content-Disposition: inline
In-Reply-To: <55BA2DA5.8000807@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 04:59:01PM +0300, Horia Geant=C4=83 wrote:
>
> Indeed, there is:
> A-005473 - Using SEQ FIFO LOAD SKIP and SEQ FIFO STORE SKIP
> simultaneously will cause the DECO to hang.
>=20
> However, the skip commands are not consecutive, there's a math comman=
d
> between them (both for encap and decap descriptors).

Cool, I didn't know that inserting a math command could also
work around the hang.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

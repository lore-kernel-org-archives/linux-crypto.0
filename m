From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix writing to JQCR_MS when using service
 interface
Date: Mon, 24 Aug 2015 22:17:49 +0800
Message-ID: <20150824141749.GC31146@gondor.apana.org.au>
References: <1440172400-3333-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51171 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbbHXOSE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 10:18:04 -0400
Content-Disposition: inline
In-Reply-To: <1440172400-3333-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 21, 2015 at 06:53:20PM +0300, Horia Geant=C4=83 wrote:
> Most significant part of JQCR (Job Queue Control Register) contains
> bits that control endianness: ILE - Immediate Little Endian,
> DWS - Double Word Swap.
> The bits are automatically set by the Job Queue Controller HW.
>=20
> Unfortunately these bits are cleared in SW when submitting descriptor=
s
> via the register-based service interface.
> >From LS1021A:
> JQCR_MS =3D 08080100 - before writing: ILE | DWS | SRC (JR0)
> JQCR_MS =3D 30000100 - after writing: WHL | FOUR | SRC (JR0)
>=20
> This would cause problems on little endian caam for descriptors
> containing immediata data or double-word pointers.
> Currently there is no problem since the only descriptors ran through
> this interface are the ones that (un)instantiate RNG.
>=20
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

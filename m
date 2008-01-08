From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Tue, 8 Jan 2008 17:33:24 +1100
Message-ID: <20080108063324.GA21721@gondor.apana.org.au>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4594 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115AbYAHGd2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:33:28 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2008 at 03:40:58PM +0200, Ilpo J=E4rvinen wrote:
> Bloat-o-meter shows rather high readings for cast6...
>=20
> crypto/cast6.c:
>   cast6_setkey  | -1310
>   cast6_encrypt | -4567
>   cast6_decrypt | -4561
>  3 functions changed, 10438 bytes removed, diff: -10438
>=20
> crypto/cast6.c:
>   W    | +659
>   Q    | +308
>   QBAR | +316
>  3 functions changed, 1283 bytes added, diff: +1283
>=20
> crypto/cast6.o:
>  6 functions changed, 1283 bytes added, 10438 bytes removed, diff: -9=
155
>=20
> Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Patch applied.  Thanks a lot!
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

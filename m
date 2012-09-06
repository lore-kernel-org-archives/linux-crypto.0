From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Revert "[CRYPTO] cast6: inline bloat--"
Date: Thu, 6 Sep 2012 13:22:33 -0700
Message-ID: <20120906202233.GI24269@gondor.apana.org.au>
References: <20120828134928.7602.26086.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:34077 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759534Ab2IFUWg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:22:36 -0400
Content-Disposition: inline
In-Reply-To: <20120828134928.7602.26086.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 28, 2012 at 04:49:28PM +0300, Jussi Kivilinna wrote:
> This reverts commit e6ccc727f30a02670f6a00df6d548942bc988f43.
>=20
> Above commit caused performance regression for CAST6. Reverting gives
> following increase in tcrypt speed tests (revert-vs-old ratios).
>=20
> AMD Phenom II X6 1055T, x86-64:
>=20
> size    ecb             cbc             ctr             lrw          =
   xts
>         enc     dec     enc     dec     enc     dec     enc     dec  =
   enc     dec
> 16b     1.15x   1.17x   1.16x   1.17x   1.16x   1.16x   1.14x   1.19x=
   1.05x   1.07x
> 64b     1.19x   1.23x   1.20x   1.22x   1.19x   1.19x   1.16x   1.24x=
   1.12x   1.12x
> 256b    1.21x   1.24x   1.22x   1.24x   1.20x   1.20x   1.17x   1.21x=
   1.16x   1.14x
> 1kb     1.21x   1.25x   1.22x   1.24x   1.21x   1.21x   1.18x   1.22x=
   1.17x   1.15x
> 8kb     1.21x   1.25x   1.22x   1.24x   1.21x   1.21x   1.18x   1.22x=
   1.18x   1.15x
>=20
> Cc: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

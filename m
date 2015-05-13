From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch -next] crypto: talitos - fix size calculation in
 talitos_edesc_alloc()
Date: Wed, 13 May 2015 11:15:20 +0800
Message-ID: <20150513031520.GA24980@gondor.apana.org.au>
References: <20150511101009.GA12395@mwanda>
 <5550B010.60008@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35034 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbbEMDPa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 23:15:30 -0400
Content-Disposition: inline
In-Reply-To: <5550B010.60008@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 03:35:12PM +0200, leroy christophe wrote:
>=20
>=20
> Le 11/05/2015 12:10, Dan Carpenter a =E9crit :
> >The + operation has higher precedence than ?: so we need parentheses
> >here.  Otherwise we may end up allocating a max of only one "cryptle=
n"
> >instead of two.
> >
> >Fixes: 6f65f6ac5fb3 ('crypto: talitos - implement scatter/gather cop=
y for SEC1')
> >Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

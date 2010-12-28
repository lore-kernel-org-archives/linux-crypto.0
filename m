From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: unmet direct dependencies  (CRYPTO && EXPERIMENTAL)
Date: Tue, 28 Dec 2010 15:43:32 +0100
Message-ID: <201012281543.32577.toralf.foerster@gmx.de>
References: <20101228115826.GA27538@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49220 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753242Ab0L1Ong convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Dec 2010 09:43:36 -0500
In-Reply-To: <20101228115826.GA27538@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert Xu wrote at 12:58:26
> Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
> > a "make randconfig 1>/dev/null" gave today :
> >=20
> > warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRY=
PTO &&
> > EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL whi=
ch
> > has unmet direct dependencies (CRYPTO && EXPERIMENTAL)
> >=20
> > for the current git kernel sources.
> > Is this an already known issue ?
>=20
> Does this patch help?

Althought I did not have the original .config, I'm pretty sure this pat=
ch=20
helps b/c after I applied it, the issue wasn't any longer observed even=
 doing=20
*a lot* of "make randconfig"..

> commit 8ad225e8e4f530f500c12ec77fd5a51caf6a2f66
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Dec 28 22:56:26 2010 +1100
>=20
>     crypto: gf128mul - Remove experimental tag
>=20
>     This feature no longer needs the experimental tag.
>=20
>     Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 96b0e55..4b7cb0e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -110,7 +110,6 @@ config CRYPTO_MANAGER_DISABLE_TESTS
>=20
>  config CRYPTO_GF128MUL
>  	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
>  	help
>  	  Efficient table driven implementation of multiplications in the
>  	  field GF(2^128).  This is needed by some cypher modes. This
>=20
> Thanks,


--=20
MfG/Kind regards
Toralf F=F6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

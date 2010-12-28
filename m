From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: unmet direct dependencies  (CRYPTO && EXPERIMENTAL)
Date: Tue, 28 Dec 2010 22:58:26 +1100
Message-ID: <20101228115826.GA27538@gondor.apana.org.au>
References: <201012271313.31686.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40303 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0L1L6a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Dec 2010 06:58:30 -0500
Content-Disposition: inline
In-Reply-To: <201012271313.31686.toralf.foerster@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
>=20
> a "make randconfig 1>/dev/null" gave today :
>=20
> warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPT=
O && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects=20
> CRYPTO_GF128MUL which has unmet direct dependencies (CRYPTO && EXPERI=
MENTAL)
>=20
> for the current git kernel sources.
> Is this an already known issue ?

Does this patch help?

commit 8ad225e8e4f530f500c12ec77fd5a51caf6a2f66
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Dec 28 22:56:26 2010 +1100

    crypto: gf128mul - Remove experimental tag
   =20
    This feature no longer needs the experimental tag.
   =20
    Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 96b0e55..4b7cb0e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -110,7 +110,6 @@ config CRYPTO_MANAGER_DISABLE_TESTS
=20
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	help
 	  Efficient table driven implementation of multiplications in the
 	  field GF(2^128).  This is needed by some cypher modes. This

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

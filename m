From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Tue, 3 Feb 2009 12:48:06 +1100
Message-ID: <20090203014806.GA32506@gondor.apana.org.au>
References: <20090118225517.GA30510@gondor.apana.org.au> <20090128035615.GA13051@gondor.apana.org.au> <1233577246.18006.1.camel@localhost> <1233597667.1536.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Martin Schwidefksy <schwidefsky@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37133 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753187AbZBCBsP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Feb 2009 20:48:15 -0500
Content-Disposition: inline
In-Reply-To: <1233597667.1536.10.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 02, 2009 at 06:01:07PM +0000, Jan Glauber wrote:
>
> The patch is not yet in cryptodev, so I applied it on top of cryptode=
v.
> Compiling it gives me the following error:
>=20
>  CC [M]  arch/s390/crypto/sha256_s390.o
> arch/s390/crypto/sha_common.c: In function =E2=80=98s390_sha_update=E2=
=80=99:
> arch/s390/crypto/sha_common.c:23: error: implicit declaration of func=
tion =E2=80=98crypto_shash_blocksize=E2=80=99
> make[1]: *** [arch/s390/crypto/sha_common.o] Error 1

Thanks for testing! It turns out that this was the first in-tree
user for crypto_shash_blocksize so I'll need to add it.

crypto: shash - Add crypto_shash_blocksize

This function is needed by algorithms that don't know their own
block size, e.g., in s390 where the code is common between multiple
versions of SHA.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index cd16d6e..b71c86b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -231,6 +231,11 @@ static inline unsigned int crypto_shash_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_shash_tfm(tfm));
 }
=20
+static inline unsigned int crypto_shash_blocksize(struct crypto_shash =
*tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_shash_tfm(tfm));
+}
+
 static inline struct shash_alg *__crypto_shash_alg(struct crypto_alg *=
alg)
 {
 	return container_of(alg, struct shash_alg, base);

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

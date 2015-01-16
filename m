From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: seqiv - Ensure that IV size is at least 8 bytes
Date: Fri, 16 Jan 2015 19:51:20 +1100
Message-ID: <20150116085120.GA9863@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35374 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbbAPIvX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2015 03:51:23 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since seqiv is designed for IPsec we need to be able to accomodate
the whole IPsec sequence number in order to ensure the uniqueness
of the IV.

This patch forbids any algorithm with an IV size of less than 8
from using it.  This should have no impact on existing users since
they all have an IV size of 8.

Reported-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 9daa854c..b7bb9a2 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -267,6 +267,12 @@ static struct crypto_instance *seqiv_ablkcipher_al=
loc(struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto out;
=20
+	if (inst->alg.cra_ablkcipher.ivsize < sizeof(u64)) {
+		skcipher_geniv_free(inst);
+		inst =3D ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	inst->alg.cra_ablkcipher.givencrypt =3D seqiv_givencrypt_first;
=20
 	inst->alg.cra_init =3D seqiv_init;
@@ -287,6 +293,12 @@ static struct crypto_instance *seqiv_aead_alloc(st=
ruct rtattr **tb)
 	if (IS_ERR(inst))
 		goto out;
=20
+	if (inst->alg.cra_aead.ivsize < sizeof(u64)) {
+		aead_geniv_free(inst);
+		inst =3D ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	inst->alg.cra_aead.givencrypt =3D seqiv_aead_givencrypt_first;
=20
 	inst->alg.cra_init =3D seqiv_aead_init;
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

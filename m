From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH crypto -v6 1/2] AES-NI: Add support to access underlying
	blkcipher under cryptd ablkcipher
Date: Fri, 16 Jan 2009 15:41:06 +0800
Message-ID: <1232091666.13948.52.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i1xFNzNRdz5//NAtqR0B"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19581 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZAPHlJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2009 02:41:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-i1xFNzNRdz5//NAtqR0B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
specified algorithm name. The new allocated one is guaranteed to be
cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
cryptd_ablkcipher_child().


v5:

- Move declaration to crypto/cryptd.h

- Fix allocation error processing in cryptd_alloc_ablkcipher()

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c         |   35 +++++++++++++++++++++++++++++++++++
 include/crypto/cryptd.h |   27 +++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -12,6 +12,7 @@
=20
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/cryptd.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -537,6 +538,40 @@ static struct crypto_template cryptd_tmp
 	.module =3D THIS_MODULE,
 };
=20
+struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_ablkcipher *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >=3D CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D THIS_MODULE) {
+		crypto_free_ablkcipher(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return __cryptd_ablkcipher_cast(tfm);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
+
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher =
*tfm)
+{
+	struct cryptd_blkcipher_ctx *ctx =3D crypto_ablkcipher_ctx(&tfm->base);
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_ablkcipher_child);
+
+void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
+{
+	crypto_free_ablkcipher(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
+
 static inline int cryptd_create_thread(struct cryptd_state *state,
 				       int (*fn)(void *data), const char *name)
 {
--- /dev/null
+++ b/include/crypto/cryptd.h
@@ -0,0 +1,27 @@
+/*
+ * Software async crypto daemon
+ */
+
+#ifndef _CRYPTO_CRYPT_H
+#define _CRYPTO_CRYPT_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+
+struct cryptd_ablkcipher {
+	struct crypto_ablkcipher base;
+};
+
+static inline struct cryptd_ablkcipher *__cryptd_ablkcipher_cast(
+	struct crypto_ablkcipher *tfm)
+{
+	return (struct cryptd_ablkcipher *)tfm;
+}
+
+/* alg_name should be algorithm to be cryptd-ed */
+struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask);
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher =
*tfm);
+void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
+
+#endif


--=-i1xFNzNRdz5//NAtqR0B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklwOg8ACgkQKhFGF+eHlpiMHQCgnUc42sm/spV+ay09ccje5EDR
9bcAoI81QPAXpqLDyjhS0CeXy/o5rdfQ
=kUBh
-----END PGP SIGNATURE-----

--=-i1xFNzNRdz5//NAtqR0B--


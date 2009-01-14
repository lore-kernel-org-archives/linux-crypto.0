From: Huang Ying <ying.huang@intel.com>
Subject: [RFC PATCH crypto -v3 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Date: Wed, 14 Jan 2009 15:44:06 +0800
Message-ID: <1231919046.5937.159.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U6X1Ug46Ppbs8JSpwwN9"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZANHoI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 02:44:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-U6X1Ug46Ppbs8JSpwwN9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
specified algorithm name. The new allocated one is guaranteed to be
cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
cryptd_ablkcipher_child().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c         |   19 +++++++++++++++++++
 include/crypto/algapi.h |    5 +++++
 2 files changed, 24 insertions(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -537,6 +537,25 @@ static struct crypto_template cryptd_tmp
 	.module =3D THIS_MODULE,
 };
=20
+struct crypto_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >=3D CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	return crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
+
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct crypto_ablkcipher =
*tfm)
+{
+	struct cryptd_blkcipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_ablkcipher_child);
+
 static inline int cryptd_create_thread(struct cryptd_state *state,
 				       int (*fn)(void *data), const char *name)
 {
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -145,6 +145,11 @@ int blkcipher_walk_virt_block(struct blk
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
=20
+/* alg_name should be algorithm to be cryptd-ed */
+struct crypto_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask);
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct crypto_ablkcipher =
*tfm);
+
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
 	unsigned long addr =3D (unsigned long)crypto_tfm_ctx(tfm);


--=-U6X1Ug46Ppbs8JSpwwN9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkltl8MACgkQKhFGF+eHlpg+wACgowtavfGpphtSzwTWpMXKg/5d
5nIAoJhgilhiu4uFl3MkYWl4OspA5m/b
=5aIb
-----END PGP SIGNATURE-----

--=-U6X1Ug46Ppbs8JSpwwN9--


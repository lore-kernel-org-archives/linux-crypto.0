From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH crypto -v4 1/2] AES-NI: Add support to access underlying
	blkcipher under cryptd ablkcipher
Date: Thu, 15 Jan 2009 16:28:33 +0800
Message-ID: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NFsqTVtTOo3iHRL2zHfp"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58402 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbZAOI2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 03:28:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-NFsqTVtTOo3iHRL2zHfp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
specified algorithm name. The new allocated one is guaranteed to be
cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
cryptd_ablkcipher_child().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c         |   30 ++++++++++++++++++++++++++++++
 include/crypto/algapi.h |   16 ++++++++++++++++
 2 files changed, 46 insertions(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -537,6 +537,36 @@ static struct crypto_template cryptd_tmp
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
+	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D
+	       THIS_MODULE);
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
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -94,6 +94,10 @@ struct blkcipher_walk {
 	unsigned int blocksize;
 };
=20
+struct cryptd_ablkcipher {
+	struct crypto_ablkcipher base;
+};
+
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
@@ -145,6 +149,18 @@ int blkcipher_walk_virt_block(struct blk
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
=20
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
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
 	unsigned long addr =3D (unsigned long)crypto_tfm_ctx(tfm);


--=-NFsqTVtTOo3iHRL2zHfp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklu860ACgkQKhFGF+eHlphHvwCffdN2xpP/qRzW/MaPEOpWmSFT
glgAmwcA1x5G9deCQ/cacGD+X/wHS6Ps
=xfBZ
-----END PGP SIGNATURE-----

--=-NFsqTVtTOo3iHRL2zHfp--


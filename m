From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 5/8] crypto: api - Export pcomp through comp
Date: Wed, 17 Dec 2008 17:36:40 +0100
Message-ID: <20081217164036.722849831@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65209 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751946AbYLQQmD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Content-Disposition: inline; filename=crypto-add-pcomp-comp-compat.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Allow "pcomp" algorithms to be used through the old "comp" interface, b=
y
implementing one-shot (de)compression on top of the partial (de)compres=
sion
interface.

As the old "comp" interface doesn't support the configuration of
(de)compression parameters by the user, each algorithm must provide a s=
et of
default parameters through pcompress_alg.coa_default_params.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/api.c           |    6 ++
 crypto/internal.h      |    1=20
 crypto/pcompress.c     |  106 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
 include/linux/crypto.h |    9 ++--
 4 files changed, 118 insertions(+), 4 deletions(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -288,7 +288,11 @@ static int crypto_init_ops(struct crypto
 		return crypto_init_compress_ops(tfm);
 =09
 	case CRYPTO_ALG_TYPE_PCOMPRESS:
-		return crypto_init_pcompress_ops(tfm);
+		if ((type & CRYPTO_ALG_TYPE_MASK) =3D=3D
+		    CRYPTO_ALG_TYPE_COMPRESS)
+			return crypto_init_pcompress_ops_compat(tfm);
+		else
+			return crypto_init_pcompress_ops(tfm);
=20
 	default:
 		break;
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -101,6 +101,7 @@ int crypto_init_digest_ops_async(struct=20
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
 int crypto_init_compress_ops(struct crypto_tfm *tfm);
 int crypto_init_pcompress_ops(struct crypto_tfm *tfm);
+int crypto_init_pcompress_ops_compat(struct crypto_tfm *tfm);
=20
 void crypto_exit_digest_ops(struct crypto_tfm *tfm);
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -79,3 +79,109 @@ int crypto_init_pcompress_ops(struct cry
 void crypto_exit_pcompress_ops(struct crypto_tfm *tfm)
 {
 }
+
+
+static int crypto_init_compat(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg =3D tfm->__crt_alg;
+	int error;
+
+	error =3D alg->cra_init(tfm);
+	if (error)
+		return error;
+
+	error =3D crypto_compress_setup(tfm,
+				      alg->cra_pcompress.coa_default_params);
+	if (error)
+		pr_debug("crypto_compress_setup failed %d\n", error);
+
+	return error;
+}
+
+static int crypto_compress_compat(struct crypto_tfm *tfm, const u8 *sr=
c,
+				  unsigned int slen, u8 *dst,
+				  unsigned int *dlen)
+{
+	struct comp_request req;
+	int error;
+
+	pr_debug("src =3D %p, slen =3D %u, dst =3D %p, dlen =3D %u\n", src, s=
len, dst,
+		 *dlen);
+
+	req.next_in =3D src;
+	req.avail_in =3D slen;
+	req.next_out =3D dst;
+	req.avail_out =3D *dlen;
+
+	error =3D crypto_compress_init(tfm, &req);
+	if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		pr_debug("crypto_compress_init failed %d\n", error);
+		return error;
+	}
+
+	error =3D crypto_compress_update(tfm, &req);
+	if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		pr_debug("crypto_compress_update failed %d\n", error);
+		return error;
+	}
+
+	error =3D crypto_compress_final(tfm, &req);
+	if (error) {
+		pr_debug("crypto_compress_final failed %d\n", error);
+		return error;
+	}
+
+	*dlen -=3D req.avail_out;
+
+	return 0;
+}
+
+static int crypto_decompress_compat(struct crypto_tfm *tfm, const u8 *=
src,
+				    unsigned int slen, u8 *dst,
+				    unsigned int *dlen)
+{
+	struct comp_request req;
+	int error;
+
+	pr_debug("src =3D %p, slen =3D %u, dst =3D %p, dlen =3D %u\n", src, s=
len, dst,
+		 *dlen);
+
+	req.next_in =3D src;
+	req.avail_in =3D slen;
+	req.next_out =3D dst;
+	req.avail_out =3D *dlen;
+
+	error =3D crypto_decompress_init(tfm, &req);
+	if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		pr_debug("crypto_decompress_init failed %d\n", error);
+		return error;
+	}
+
+	error =3D crypto_decompress_update(tfm, &req);
+	if (error && (error !=3D -EAGAIN || req.avail_in)) {
+		pr_debug("crypto_decompress_update failed %d\n", error);
+		return error;
+	}
+
+	error =3D crypto_decompress_final(tfm, &req);
+	if (error) {
+		pr_debug("crypto_decompress_final failed %d\n", error);
+		return error;
+	}
+
+	*dlen -=3D req.avail_out;
+
+	return 0;
+}
+
+int crypto_init_pcompress_ops_compat(struct crypto_tfm *tfm)
+{
+	struct compress_tfm *ops =3D &tfm->crt_compress;
+
+	tfm->init =3D crypto_init_compat;
+
+	ops->cot_compress =3D crypto_compress_compat;
+	ops->cot_decompress =3D crypto_decompress_compat;
+
+	return 0;
+}
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -30,7 +30,6 @@
  */
 #define CRYPTO_ALG_TYPE_MASK		0x0000000f
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
-#define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
@@ -40,11 +39,13 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_COMPRESS	0x0000000e
 #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
=20
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_COMPRESS_MASK	0x0000000e
=20
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
@@ -324,6 +325,8 @@ struct pcompress_alg {
 				     struct comp_request *req);
 	int (*coa_decompress_final)(struct crypto_tfm *tfm,
 				    struct comp_request *req);
+	/* for backwards-compatibility with compress_alg only */
+	const void *coa_default_params;
 };
=20
 struct rng_alg {
@@ -1344,7 +1347,7 @@ static inline struct crypto_comp *crypto
 {
 	type &=3D ~CRYPTO_ALG_TYPE_MASK;
 	type |=3D CRYPTO_ALG_TYPE_COMPRESS;
-	mask |=3D CRYPTO_ALG_TYPE_MASK;
+	mask |=3D CRYPTO_ALG_TYPE_COMPRESS_MASK;
=20
 	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
 }
@@ -1363,7 +1366,7 @@ static inline int crypto_has_comp(const=20
 {
 	type &=3D ~CRYPTO_ALG_TYPE_MASK;
 	type |=3D CRYPTO_ALG_TYPE_COMPRESS;
-	mask |=3D CRYPTO_ALG_TYPE_MASK;
+	mask |=3D CRYPTO_ALG_TYPE_COMPRESS_MASK;
=20
 	return crypto_has_alg(alg_name, type, mask);
 }

--=20
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 3/8] crypto: testmgr - Add support for the pcomp interface
Date: Wed, 17 Dec 2008 17:36:38 +0100
Message-ID: <20081217164036.598702037@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65190 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751493AbYLQQmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:00 -0500
Content-Disposition: inline; filename=crypto-add-pcomp-test.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |  166 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
 crypto/testmgr.h |    7 ++
 2 files changed, 173 insertions(+)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -72,6 +72,13 @@ struct comp_test_suite {
 	} comp, decomp;
 };
=20
+struct pcomp_test_suite {
+	struct {
+		struct pcomp_testvec *vecs;
+		unsigned int count;
+	} comp, decomp;
+};
+
 struct hash_test_suite {
 	struct hash_testvec *vecs;
 	unsigned int count;
@@ -86,6 +93,7 @@ struct alg_test_desc {
 		struct aead_test_suite aead;
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
+		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
 	} suite;
 };
@@ -898,6 +906,142 @@ out:
 	return ret;
 }
=20
+static int test_pcomp(struct crypto_pcomp *tfm,
+		      struct pcomp_testvec *ctemplate,
+		      struct pcomp_testvec *dtemplate, int ctcount,
+		      int dtcount)
+{
+	const char *algo =3D crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm)=
);
+	unsigned int i;
+	char result[COMP_BUF_SIZE];
+	int error;
+
+	for (i =3D 0; i < ctcount; i++) {
+		struct comp_request req;
+
+		error =3D crypto_pcomp_setup(tfm, ctemplate[i].params);
+		if (error) {
+			pr_err("alg: pcomp: compression setup failed on test "
+			       "%d for %s: error=3D%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in =3D ctemplate[i].input;
+		req.avail_in =3D ctemplate[i].inlen / 2;
+		req.next_out =3D result;
+		req.avail_out =3D ctemplate[i].outlen / 2;
+
+		error =3D crypto_pcomp_compress_init(tfm, &req);
+		if (error && (error !=3D -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression init failed on test "
+			       "%d for %s: error=3D%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in +=3D (ctemplate[i].inlen + 1) / 2;
+
+		error =3D crypto_pcomp_compress_update(tfm, &req);
+		if (error && (error !=3D -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression update failed on test "
+			       "%d for %s: error=3D%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out +=3D COMP_BUF_SIZE - ctemplate[i].outlen / 2;
+
+		error =3D crypto_pcomp_compress_final(tfm, &req);
+		if (error) {
+			pr_err("alg: pcomp: compression final failed on test "
+			       "%d for %s: error=3D%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out !=3D ctemplate[i].outlen) {
+			pr_err("alg: comp: Compression test %d failed for %s: "
+			       "output len =3D %d (expected %d)\n", i + 1, algo,
+			       COMP_BUF_SIZE - req.avail_out,
+			       ctemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
+			pr_err("alg: pcomp: Compression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, ctemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	for (i =3D 0; i < dtcount; i++) {
+		struct comp_request req;
+
+		error =3D crypto_pcomp_setup(tfm, dtemplate[i].params);
+		if (error) {
+			pr_err("alg: pcomp: decompression setup failed on "
+			       "test %d for %s: error=3D%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in =3D dtemplate[i].input;
+		req.avail_in =3D dtemplate[i].inlen / 2;
+		req.next_out =3D result;
+		req.avail_out =3D dtemplate[i].outlen / 2;
+
+		error =3D crypto_pcomp_decompress_init(tfm, &req);
+		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression init failed on test "
+			       "%d for %s: error=3D%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in +=3D (dtemplate[i].inlen + 1) / 2;
+
+		error =3D crypto_pcomp_decompress_update(tfm, &req);
+		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression update failed on "
+			       "test %d for %s: error=3D%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out +=3D COMP_BUF_SIZE - dtemplate[i].outlen / 2;
+
+		error =3D crypto_pcomp_decompress_final(tfm, &req);
+		if (error  && (error !=3D -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression final failed on "
+			       "test %d for %s: error=3D%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out !=3D dtemplate[i].outlen) {
+			pr_err("alg: comp: Decompression test %d failed for "
+			       "%s: output len =3D %d (expected %d)\n", i + 1,
+			       algo, COMP_BUF_SIZE - req.avail_out,
+			       dtemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
+			pr_err("alg: pcomp: Decompression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, dtemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int alg_test_aead(const struct alg_test_desc *desc, const char =
*driver,
 			 u32 type, u32 mask)
 {
@@ -1007,6 +1151,28 @@ static int alg_test_comp(const struct al
 	return err;
 }
=20
+static int alg_test_pcomp(const struct alg_test_desc *desc, const char=
 *driver,
+			  u32 type, u32 mask)
+{
+	struct crypto_pcomp *tfm;
+	int err;
+
+	tfm =3D crypto_alloc_pcomp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: pcomp: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	err =3D test_pcomp(tfm, desc->suite.pcomp.comp.vecs,
+			 desc->suite.pcomp.decomp.vecs,
+			 desc->suite.pcomp.comp.count,
+			 desc->suite.pcomp.decomp.count);
+
+	crypto_free_pcomp(tfm);
+	return err;
+}
+
 static int alg_test_hash(const struct alg_test_desc *desc, const char =
*driver,
 			 u32 type, u32 mask)
 {
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8347,6 +8347,13 @@ struct comp_testvec {
 	char output[COMP_BUF_SIZE];
 };
=20
+struct pcomp_testvec {
+	const void *params;
+	int inlen, outlen;
+	char input[COMP_BUF_SIZE];
+	char output[COMP_BUF_SIZE];
+};
+
 /*
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=3D-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.

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

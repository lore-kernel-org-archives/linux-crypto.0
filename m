From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
Date: Wed, 17 Dec 2008 17:36:37 +0100
Message-ID: <20081217164036.539681327@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65186 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395AbYLQQmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:00 -0500
Content-Disposition: inline; filename=crypto-add-pcomp.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

The current "comp" crypto interface supports one-shot (de)compression o=
nly,
i.e. the whole data buffer to be (de)compressed must be passed at once,=
 and
the whole (de)compressed data buffer will be received at once.
In several use-cases (e.g. compressed file systems that store files in =
big
compressed blocks), this workflow is not suitable.
=46urthermore, the "comp" type doesn't provide for the configuration of
(de)compression parameters, and always allocates workspace memory for b=
oth
compression and decompression, which may waste memory.

To solve this, add a "pcomp" partial (de)compression interface that pro=
vides
the following operations:
  - crypto_pcomp_compress_{init,update,final}() for compression,
  - crypto_pcomp_decompress_{init,update,final}() for decompression,
  - crypto_pcomp_setup(), to configure (de)compression parameters (incl=
=2E
    allocating workspace memory).

The (de)compression methods take a struct comp_request, which was mimic=
ked
after the z_stream object in zlib, and contains buffer pointer and leng=
th
pairs for input and output.

The setup method takes an opaque parameter pointer, whose meaning depen=
ds on
the actual (name of the) (de)compression algorithm.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/Makefile        |    2=20
 crypto/api.c           |   11 +++
 crypto/internal.h      |    7 ++
 crypto/pcompress.c     |   81 +++++++++++++++++++++++++++
 crypto/proc.c          |    3 +
 include/linux/crypto.h |  147 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
 6 files changed, 250 insertions(+), 1 deletion(-)

--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,7 +3,7 @@
 #
=20
 obj-$(CONFIG_CRYPTO) +=3D crypto.o
-crypto-objs :=3D api.o cipher.o digest.o compress.o
+crypto-objs :=3D api.o cipher.o digest.o compress.o pcompress.o
=20
 obj-$(CONFIG_CRYPTO_FIPS) +=3D fips.o
=20
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -287,6 +287,9 @@ static int crypto_init_ops(struct crypto
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		return crypto_init_compress_ops(tfm);
 =09
+	case CRYPTO_ALG_TYPE_PCOMPRESS:
+		return crypto_init_pcompress_ops(tfm);
+
 	default:
 		break;
 	}
@@ -318,6 +321,10 @@ static void crypto_exit_ops(struct crypt
 		crypto_exit_compress_ops(tfm);
 		break;
 =09
+	case CRYPTO_ALG_TYPE_PCOMPRESS:
+		crypto_exit_pcompress_ops(tfm);
+		break;
+
 	default:
 		BUG();
 	=09
@@ -348,6 +355,10 @@ static unsigned int crypto_ctxsize(struc
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		len +=3D crypto_compress_ctxsize(alg);
 		break;
+
+	case CRYPTO_ALG_TYPE_PCOMPRESS:
+		len +=3D crypto_pcompress_ctxsize(alg);
+		break;
 	}
=20
 	return len;
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -87,6 +87,11 @@ static inline unsigned int crypto_compre
 	return alg->cra_ctxsize;
 }
=20
+static inline unsigned int crypto_pcompress_ctxsize(struct crypto_alg =
*alg)
+{
+	return alg->cra_ctxsize;
+}
+
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg);
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 m=
ask);
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u=
32 mask);
@@ -95,10 +100,12 @@ int crypto_init_digest_ops(struct crypto
 int crypto_init_digest_ops_async(struct crypto_tfm *tfm);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
 int crypto_init_compress_ops(struct crypto_tfm *tfm);
+int crypto_init_pcompress_ops(struct crypto_tfm *tfm);
=20
 void crypto_exit_digest_ops(struct crypto_tfm *tfm);
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
 void crypto_exit_compress_ops(struct crypto_tfm *tfm);
+void crypto_exit_pcompress_ops(struct crypto_tfm *tfm);
=20
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, =
u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
--- /dev/null
+++ b/crypto/pcompress.c
@@ -0,0 +1,81 @@
+/*
+ * Cryptographic API.
+ *
+ * Partial compression operations.
+ *
+ * Copyright 2008 Sony Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by t=
he Free
+ * Software Foundation; either version 2 of the License, or (at your o=
ption)
+ * any later version.
+ *
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include "internal.h"
+
+static int crypto_compress_setup(struct crypto_tfm *tfm, const void *p=
arams)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_setup(tfm, params);
+}
+
+static int crypto_compress_init(struct crypto_tfm *tfm,
+				struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_compress_init(tfm, req);
+}
+
+static int crypto_compress_update(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_compress_update(tfm, req);
+}
+
+static int crypto_compress_final(struct crypto_tfm *tfm,
+				 struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_compress_final(tfm, req);
+}
+
+static int crypto_decompress_init(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_decompress_init(tfm, req);
+}
+
+static int crypto_decompress_update(struct crypto_tfm *tfm,
+				    struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_decompress_update(tfm, req);
+}
+
+static int crypto_decompress_final(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	return tfm->__crt_alg->cra_pcompress.coa_decompress_final(tfm, req);
+}
+
+int crypto_init_pcompress_ops(struct crypto_tfm *tfm)
+{
+	struct pcompress_tfm *ops =3D &tfm->crt_pcompress;
+
+	ops->cot_setup =3D crypto_compress_setup;
+	ops->cot_compress_init =3D crypto_compress_init;
+	ops->cot_compress_update =3D crypto_compress_update;
+	ops->cot_compress_final =3D crypto_compress_final;
+	ops->cot_decompress_init =3D crypto_decompress_init;
+	ops->cot_decompress_update =3D crypto_decompress_update;
+	ops->cot_decompress_final =3D crypto_decompress_final;
+
+	return 0;
+}
+
+void crypto_exit_pcompress_ops(struct crypto_tfm *tfm)
+{
+}
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -125,6 +125,9 @@ static int c_show(struct seq_file *m, vo
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		seq_printf(m, "type         : compression\n");
 		break;
+	case CRYPTO_ALG_TYPE_PCOMPRESS:
+		seq_printf(m, "type         : partial compression\n");
+		break;
 	default:
 		seq_printf(m, "type         : unknown\n");
 		break;
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -40,6 +40,7 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
=20
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
@@ -181,6 +182,13 @@ struct aead_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
=20
+struct comp_request {
+	const void *next_in;		/* next input byte */
+	void *next_out;			/* next output byte */
+	unsigned int avail_in;		/* bytes available at next_in */
+	unsigned int avail_out;		/* bytes available at next_out */
+};
+
 struct blkcipher_desc {
 	struct crypto_blkcipher *tfm;
 	void *info;
@@ -302,6 +310,22 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
=20
+struct pcompress_alg {
+	int (*coa_setup)(struct crypto_tfm *tfm, const void *params);
+	int (*coa_compress_init)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*coa_compress_update)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*coa_compress_final)(struct crypto_tfm *tfm,
+				  struct comp_request *req);
+	int (*coa_decompress_init)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*coa_decompress_update)(struct crypto_tfm *tfm,
+				     struct comp_request *req);
+	int (*coa_decompress_final)(struct crypto_tfm *tfm,
+				    struct comp_request *req);
+};
+
 struct rng_alg {
 	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
 			       unsigned int dlen);
@@ -319,6 +343,7 @@ struct rng_alg {
 #define cra_hash	cra_u.hash
 #define cra_ahash	cra_u.ahash
 #define cra_compress	cra_u.compress
+#define cra_pcompress	cra_u.pcompress
 #define cra_rng		cra_u.rng
=20
 struct crypto_alg {
@@ -347,6 +372,7 @@ struct crypto_alg {
 		struct hash_alg hash;
 		struct ahash_alg ahash;
 		struct compress_alg compress;
+		struct pcompress_alg pcompress;
 		struct rng_alg rng;
 	} cra_u;
=20
@@ -453,6 +479,22 @@ struct compress_tfm {
 	                      u8 *dst, unsigned int *dlen);
 };
=20
+struct pcompress_tfm {
+	int (*cot_setup)(struct crypto_tfm *tfm, const void *params);
+	int (*cot_compress_init)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*cot_compress_update)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*cot_compress_final)(struct crypto_tfm *tfm,
+				 struct comp_request *req);
+	int (*cot_decompress_init)(struct crypto_tfm *tfm,
+				   struct comp_request *req);
+	int (*cot_decompress_update)(struct crypto_tfm *tfm,
+				     struct comp_request *req);
+	int (*cot_decompress_final)(struct crypto_tfm *tfm,
+				    struct comp_request *req);
+};
+
 struct rng_tfm {
 	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
 			      unsigned int dlen);
@@ -466,6 +508,7 @@ struct rng_tfm {
 #define crt_hash	crt_u.hash
 #define crt_ahash	crt_u.ahash
 #define crt_compress	crt_u.compress
+#define crt_pcompress	crt_u.pcompress
 #define crt_rng		crt_u.rng
=20
 struct crypto_tfm {
@@ -480,6 +523,7 @@ struct crypto_tfm {
 		struct hash_tfm hash;
 		struct ahash_tfm ahash;
 		struct compress_tfm compress;
+		struct pcompress_tfm pcompress;
 		struct rng_tfm rng;
 	} crt_u;
=20
@@ -510,6 +554,10 @@ struct crypto_comp {
 	struct crypto_tfm base;
 };
=20
+struct crypto_pcomp {
+	struct crypto_tfm base;
+};
+
 struct crypto_hash {
 	struct crypto_tfm base;
 };
@@ -1345,5 +1393,104 @@ static inline int crypto_comp_decompress
 						    src, slen, dst, dlen);
 }
=20
+static inline struct crypto_pcomp *__crypto_pcomp_cast(struct crypto_t=
fm *tfm)
+{
+	return (struct crypto_pcomp *)tfm;
+}
+
+static inline struct crypto_pcomp *crypto_pcomp_cast(struct crypto_tfm=
 *tfm)
+{
+	BUG_ON((crypto_tfm_alg_type(tfm) ^ CRYPTO_ALG_TYPE_PCOMPRESS) &
+	       CRYPTO_ALG_TYPE_MASK);
+	return __crypto_pcomp_cast(tfm);
+}
+
+static inline struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_=
name,
+						      u32 type, u32 mask)
+{
+	type &=3D ~CRYPTO_ALG_TYPE_MASK;
+	type |=3D CRYPTO_ALG_TYPE_PCOMPRESS;
+	mask |=3D CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_pcomp_cast(crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_pcomp_tfm(struct crypto_pcomp =
*tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_pcomp(struct crypto_pcomp *tfm)
+{
+	crypto_free_tfm(crypto_pcomp_tfm(tfm));
+}
+
+static inline int crypto_has_pcomp(const char *alg_name, u32 type, u32=
 mask)
+{
+	type &=3D ~CRYPTO_ALG_TYPE_MASK;
+	type |=3D CRYPTO_ALG_TYPE_PCOMPRESS;
+	mask |=3D CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
+static inline const char *crypto_pcomp_name(struct crypto_pcomp *tfm)
+{
+	return crypto_tfm_alg_name(crypto_pcomp_tfm(tfm));
+}
+
+static inline struct pcompress_tfm *crypto_pcomp_crt(struct crypto_pco=
mp *tfm)
+{
+	return &crypto_pcomp_tfm(tfm)->crt_pcompress;
+}
+
+static inline int crypto_pcomp_setup(struct crypto_pcomp *tfm,
+				     const void *params)
+{
+	return crypto_pcomp_crt(tfm)->cot_setup(crypto_pcomp_tfm(tfm), params=
);
+}
+
+static inline int crypto_pcomp_compress_init(struct crypto_pcomp *tfm,
+					     struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->cot_compress_init(crypto_pcomp_tfm(tfm)=
,
+							req);
+}
+
+static inline int crypto_pcomp_compress_update(struct crypto_pcomp *tf=
m,
+					       struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->cot_compress_update(crypto_pcomp_tfm(tf=
m),
+							  req);
+}
+
+static inline int crypto_pcomp_compress_final(struct crypto_pcomp *tfm=
,
+					      struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->cot_compress_final(crypto_pcomp_tfm(tfm=
),
+							 req);
+}
+
+static inline int crypto_pcomp_decompress_init(struct crypto_pcomp *tf=
m,
+					       struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->cot_decompress_init(crypto_pcomp_tfm(tf=
m),
+							  req);
+}
+
+static inline int crypto_pcomp_decompress_update(struct crypto_pcomp *=
tfm,
+						 struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->
+		cot_decompress_update(crypto_pcomp_tfm(tfm), req);
+}
+
+static inline int crypto_pcomp_decompress_final(struct crypto_pcomp *t=
fm,
+						struct comp_request *req)
+{
+	return crypto_pcomp_crt(tfm)->
+		cot_decompress_final(crypto_pcomp_tfm(tfm), req);
+}
+
 #endif	/* _LINUX_CRYPTO_H */
=20

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

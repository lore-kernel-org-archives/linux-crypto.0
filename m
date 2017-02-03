From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH v2 1/6] crypto: ecc: separate out ecc and ecdh
Date: Fri, 3 Feb 2017 16:42:50 +0530
Message-ID: <1486120375-13070-2-git-send-email-nkumbhar@nvidia.com>
References: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17668 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752002AbdBCLNC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 06:13:02 -0500
In-Reply-To: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add ECC operations i.e. vli and ecc point ops as a separate
module under CRYPTO_ECC kconfig. This allows other ECC
algorithms like ECDSA & ECIES to reuse these ops even when ECDH
is disabled with CRYPTO_ECDH kconfig.

With these changes, ECDH specific functions are consolidated
as ECDH helper routines and ECC curves are moved to ECC specific
files.

Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 crypto/Kconfig          |    7 +++
 crypto/Makefile         |    5 +-
 crypto/ecc.c            |  133 ++++++++++++++--------------------------------
 crypto/ecc.h            |   47 ++---------------
 crypto/ecc_curve_defs.h |   51 ++++--------------
 crypto/ecc_ecdh.h       |   54 +++++++++++++++++++
 crypto/ecdh.c           |    4 +-
 crypto/ecdh_helper.c    |   94 +++++++++++++++++++++++++++++++++
 include/crypto/ecc.h    |   24 +++++++++
 include/crypto/ecdh.h   |   10 +---
 10 files changed, 244 insertions(+), 185 deletions(-)
 create mode 100644 crypto/ecc_ecdh.h
 create mode 100644 include/crypto/ecc.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 160f08e721cc..e240075d6f46 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -127,9 +127,16 @@ config CRYPTO_DH
 	help
 	  Generic implementation of the Diffie-Hellman algorithm.
 
+config CRYPTO_ECC
+	tristate "ECC functions"
+	help
+	  Implementation of ECC functions
+
+
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
 	select CRYTPO_KPP
+	select CRYPTO_ECC
 	help
 	  Generic implementation of the ECDH algorithm
 
diff --git a/crypto/Makefile b/crypto/Makefile
index b8f0e3eb0791..827740a47a37 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -33,8 +33,9 @@ obj-$(CONFIG_CRYPTO_KPP2) += kpp.o
 dh_generic-y := dh.o
 dh_generic-y += dh_helper.o
 obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
-ecdh_generic-y := ecc.o
-ecdh_generic-y += ecdh.o
+
+obj-$(CONFIG_CRYPTO_ECC) += ecc.o
+ecdh_generic-y := ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 414c78a9c214..a8c10e725138 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2013, Kenneth MacKay
  * All rights reserved.
+ * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are
@@ -28,16 +29,54 @@
 #include <linux/slab.h>
 #include <linux/swab.h>
 #include <linux/fips.h>
-#include <crypto/ecdh.h>
 
 #include "ecc.h"
-#include "ecc_curve_defs.h"
 
 typedef struct {
 	u64 m_low;
 	u64 m_high;
 } uint128_t;
 
+/* NIST P-192 */
+static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
+				0x188DA80EB03090F6ull };
+static u64 nist_p192_g_y[] = { 0x73F977A11E794811ull, 0x631011ED6B24CDD5ull,
+				0x07192B95FFC8DA78ull };
+static u64 nist_p192_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFEull,
+				0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p192_n[] = { 0x146BC9B1B4D22831ull, 0xFFFFFFFF99DEF836ull,
+				0xFFFFFFFFFFFFFFFFull };
+static struct ecc_curve nist_p192 = {
+	.name = "nist_192",
+	.g = {
+		.x = nist_p192_g_x,
+		.y = nist_p192_g_y,
+		.ndigits = 3,
+	},
+	.p = nist_p192_p,
+	.n = nist_p192_n
+};
+
+/* NIST P-256 */
+static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
+				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
+static u64 nist_p256_g_y[] = { 0xCBB6406837BF51F5ull, 0x2BCE33576B315ECEull,
+				0x8EE7EB4A7C0F9E16ull, 0x4FE342E2FE1A7F9Bull };
+static u64 nist_p256_p[] = { 0xFFFFFFFFFFFFFFFFull, 0x00000000FFFFFFFFull,
+				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
+static u64 nist_p256_n[] = { 0xF3B9CAC2FC632551ull, 0xBCE6FAADA7179E84ull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFF00000000ull };
+static struct ecc_curve nist_p256 = {
+	.name = "nist_256",
+	.g = {
+		.x = nist_p256_g_x,
+		.y = nist_p256_g_y,
+		.ndigits = 4,
+	},
+	.p = nist_p256_p,
+	.n = nist_p256_n
+};
+
 static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 {
 	switch (curve_id) {
@@ -926,93 +965,3 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 
 	return 0;
 }
-
-int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, unsigned int private_key_len,
-		      u8 *public_key, unsigned int public_key_len)
-{
-	int ret = 0;
-	struct ecc_point *pk;
-	u64 priv[ndigits];
-	unsigned int nbytes;
-	const struct ecc_curve *curve = ecc_get_curve(curve_id);
-
-	if (!private_key || !curve) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
-
-	pk = ecc_alloc_point(ndigits);
-	if (!pk) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ecc_point_mult(pk, &curve->g, priv, NULL, curve->p, ndigits);
-	if (ecc_point_is_zero(pk)) {
-		ret = -EAGAIN;
-		goto err_free_point;
-	}
-
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-	ecc_swap_digits(pk->x, (u64 *)public_key, ndigits);
-	ecc_swap_digits(pk->y, (u64 *)&public_key[nbytes], ndigits);
-
-err_free_point:
-	ecc_free_point(pk);
-out:
-	return ret;
-}
-
-int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len)
-{
-	int ret = 0;
-	struct ecc_point *product, *pk;
-	u64 priv[ndigits];
-	u64 rand_z[ndigits];
-	unsigned int nbytes;
-	const struct ecc_curve *curve = ecc_get_curve(curve_id);
-
-	if (!private_key || !public_key || !curve) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-
-	get_random_bytes(rand_z, nbytes);
-
-	pk = ecc_alloc_point(ndigits);
-	if (!pk) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	product = ecc_alloc_point(ndigits);
-	if (!product) {
-		ret = -ENOMEM;
-		goto err_alloc_product;
-	}
-
-	ecc_swap_digits((const u64 *)public_key, pk->x, ndigits);
-	ecc_swap_digits((const u64 *)&public_key[nbytes], pk->y, ndigits);
-	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
-
-	ecc_point_mult(product, pk, priv, rand_z, curve->p, ndigits);
-
-	ecc_swap_digits(product->x, (u64 *)secret, ndigits);
-
-	if (ecc_point_is_zero(product))
-		ret = -EFAULT;
-
-	ecc_free_point(product);
-err_alloc_product:
-	ecc_free_point(pk);
-out:
-	return ret;
-}
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 663d598c7406..40f930d54c29 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2013, Kenneth MacKay
  * All rights reserved.
+ * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are
@@ -26,12 +27,12 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
-#define ECC_MAX_DIGITS	4 /* 256 */
+#include <crypto/ecc.h>
 
-#define ECC_DIGITS_TO_BYTES_SHIFT 3
+#include "ecc_curve_defs.h"
 
 /**
- * ecc_is_key_valid() - Validate a given ECDH private key
+ * ecc_is_key_valid() - Validate a given ECC private key
  *
  * @curve_id:		id representing the curve to use
  * @ndigits:		curve number of digits
@@ -42,42 +43,4 @@
  */
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 		     const u8 *private_key, unsigned int private_key_len);
-
-/**
- * ecdh_make_pub_key() - Compute an ECC public key
- *
- * @curve_id:		id representing the curve to use
- * @private_key:	pregenerated private key for the given curve
- * @private_key_len:	length of private_key
- * @public_key:		buffer for storing the public key generated
- * @public_key_len:	length of the public_key buffer
- *
- * Returns 0 if the public key was generated successfully, a negative value
- * if an error occurred.
- */
-int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, unsigned int private_key_len,
-		      u8 *public_key, unsigned int public_key_len);
-
-/**
- * crypto_ecdh_shared_secret() - Compute a shared secret
- *
- * @curve_id:		id representing the curve to use
- * @private_key:	private key of part A
- * @private_key_len:	length of private_key
- * @public_key:		public key of counterpart B
- * @public_key_len:	length of public_key
- * @secret:		buffer for storing the calculated shared secret
- * @secret_len:		length of the secret buffer
- *
- * Note: It is recommended that you hash the result of crypto_ecdh_shared_secret
- * before using it for symmetric encryption or HMAC.
- *
- * Returns 0 if the shared secret was generated successfully, a negative value
- * if an error occurred.
- */
-int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len);
-#endif
+#endif /* _CRYPTO_ECC_H */
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 03ae5f714028..baacf32bca16 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -1,3 +1,12 @@
+/*
+ * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
 #ifndef _CRYTO_ECC_CURVE_DEFS_H
 #define _CRYTO_ECC_CURVE_DEFS_H
 
@@ -14,44 +23,4 @@ struct ecc_curve {
 	u64 *n;
 };
 
-/* NIST P-192 */
-static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
-				0x188DA80EB03090F6ull };
-static u64 nist_p192_g_y[] = { 0x73F977A11E794811ull, 0x631011ED6B24CDD5ull,
-				0x07192B95FFC8DA78ull };
-static u64 nist_p192_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFEull,
-				0xFFFFFFFFFFFFFFFFull };
-static u64 nist_p192_n[] = { 0x146BC9B1B4D22831ull, 0xFFFFFFFF99DEF836ull,
-				0xFFFFFFFFFFFFFFFFull };
-static struct ecc_curve nist_p192 = {
-	.name = "nist_192",
-	.g = {
-		.x = nist_p192_g_x,
-		.y = nist_p192_g_y,
-		.ndigits = 3,
-	},
-	.p = nist_p192_p,
-	.n = nist_p192_n
-};
-
-/* NIST P-256 */
-static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
-				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
-static u64 nist_p256_g_y[] = { 0xCBB6406837BF51F5ull, 0x2BCE33576B315ECEull,
-				0x8EE7EB4A7C0F9E16ull, 0x4FE342E2FE1A7F9Bull };
-static u64 nist_p256_p[] = { 0xFFFFFFFFFFFFFFFFull, 0x00000000FFFFFFFFull,
-				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
-static u64 nist_p256_n[] = { 0xF3B9CAC2FC632551ull, 0xBCE6FAADA7179E84ull,
-				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFF00000000ull };
-static struct ecc_curve nist_p256 = {
-	.name = "nist_256",
-	.g = {
-		.x = nist_p256_g_x,
-		.y = nist_p256_g_y,
-		.ndigits = 4,
-	},
-	.p = nist_p256_p,
-	.n = nist_p256_n
-};
-
-#endif
+#endif /* _CRYTO_ECC_CURVE_DEFS_H */
diff --git a/crypto/ecc_ecdh.h b/crypto/ecc_ecdh.h
new file mode 100644
index 000000000000..f77b1fe094c9
--- /dev/null
+++ b/crypto/ecc_ecdh.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2013, Kenneth MacKay. All rights reserved.
+ * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef _CRYPTO_ECC_ECDH_H
+#define _CRYPTO_ECC_ECDH_H
+
+#include "ecc.h"
+
+/**
+ * ecdh_make_pub_key() - Compute an ECC public key
+ *
+ * @curve_id:		id representing the curve to use
+ * @private_key:	pregenerated private key for the given curve
+ * @private_key_len:	length of private_key
+ * @public_key:		buffer for storing the public key generated
+ * @public_key_len:	length of the public_key buffer
+ *
+ * Returns 0 if the public key was generated successfully, a negative value
+ * if an error occurred.
+ */
+int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
+		      const u8 *private_key, unsigned int private_key_len,
+		      u8 *public_key, unsigned int public_key_len);
+
+/**
+ * crypto_ecdh_shared_secret() - Compute a shared secret
+ *
+ * @curve_id:		id representing the curve to use
+ * @private_key:	private key of part A
+ * @private_key_len:	length of private_key
+ * @public_key:		public key of counterpart B
+ * @public_key_len:	length of public_key
+ * @secret:		buffer for storing the calculated shared secret
+ * @secret_len:		length of the secret buffer
+ *
+ * Note: It is recommended that you hash the result of crypto_ecdh_shared_secret
+ * before using it for symmetric encryption or HMAC.
+ *
+ * Returns 0 if the shared secret was generated successfully, a negative value
+ * if an error occurred.
+ */
+int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
+		       const u8 *private_key, unsigned int private_key_len,
+		       const u8 *public_key, unsigned int public_key_len,
+		       u8 *secret, unsigned int secret_len);
+
+#endif /* _CRYPTO_ECC_ECDH_H */
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 3de289806d67..2b83ff3a4b9a 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -2,6 +2,7 @@
  *
  * Copyright (c) 2016, Intel Corporation
  * Authors: Salvator Benedetto <salvatore.benedetto@intel.com>
+ * Copyright (c) 2017, NVIDIA Corporation.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public Licence
@@ -14,7 +15,8 @@
 #include <crypto/kpp.h>
 #include <crypto/ecdh.h>
 #include <linux/scatterlist.h>
-#include "ecc.h"
+
+#include "ecc_ecdh.h"
 
 struct ecdh_ctx {
 	unsigned int curve_id;
diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index 3cd8a2414e60..b3857f3bfcee 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2016, Intel Corporation
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
+ * Copyright (c) 2017, NVIDIA Corporation.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public Licence
@@ -11,9 +12,12 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/random.h>
 #include <crypto/ecdh.h>
 #include <crypto/kpp.h>
 
+#include "ecc_ecdh.h"
+
 #define ECDH_KPP_SECRET_MIN_SIZE (sizeof(struct kpp_secret) + 2 * sizeof(short))
 
 static inline u8 *ecdh_pack_data(void *dst, const void *src, size_t sz)
@@ -28,6 +32,96 @@
 	return src + sz;
 }
 
+int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
+		      const u8 *private_key, unsigned int private_key_len,
+		      u8 *public_key, unsigned int public_key_len)
+{
+	int ret = 0;
+	struct ecc_point *pk;
+	u64 priv[ndigits];
+	unsigned int nbytes;
+	const struct ecc_curve *curve = ecc_get_curve(curve_id);
+
+	if (!private_key || !curve) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
+
+	pk = ecc_alloc_point(ndigits);
+	if (!pk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ecc_point_mult(pk, &curve->g, priv, NULL, curve->p, ndigits);
+	if (ecc_point_is_zero(pk)) {
+		ret = -EAGAIN;
+		goto err_free_point;
+	}
+
+	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	ecc_swap_digits(pk->x, (u64 *)public_key, ndigits);
+	ecc_swap_digits(pk->y, (u64 *)&public_key[nbytes], ndigits);
+
+err_free_point:
+	ecc_free_point(pk);
+out:
+	return ret;
+}
+
+int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
+		       const u8 *private_key, unsigned int private_key_len,
+		       const u8 *public_key, unsigned int public_key_len,
+		       u8 *secret, unsigned int secret_len)
+{
+	int ret = 0;
+	struct ecc_point *product, *pk;
+	u64 priv[ndigits];
+	u64 rand_z[ndigits];
+	unsigned int nbytes;
+	const struct ecc_curve *curve = ecc_get_curve(curve_id);
+
+	if (!private_key || !public_key || !curve) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+
+	get_random_bytes(rand_z, nbytes);
+
+	pk = ecc_alloc_point(ndigits);
+	if (!pk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	product = ecc_alloc_point(ndigits);
+	if (!product) {
+		ret = -ENOMEM;
+		goto err_alloc_product;
+	}
+
+	ecc_swap_digits((const u64 *)public_key, pk->x, ndigits);
+	ecc_swap_digits((const u64 *)&public_key[nbytes], pk->y, ndigits);
+	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
+
+	ecc_point_mult(product, pk, priv, rand_z, curve->p, ndigits);
+
+	ecc_swap_digits(product->x, (u64 *)secret, ndigits);
+
+	if (ecc_point_is_zero(product))
+		ret = -EFAULT;
+
+	ecc_free_point(product);
+err_alloc_product:
+	ecc_free_point(pk);
+out:
+	return ret;
+}
+
 int crypto_ecdh_key_len(const struct ecdh *params)
 {
 	return ECDH_KPP_SECRET_MIN_SIZE + params->key_size;
diff --git a/include/crypto/ecc.h b/include/crypto/ecc.h
new file mode 100644
index 000000000000..27957f805fd6
--- /dev/null
+++ b/include/crypto/ecc.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_ECC_
+#define _CRYPTO_ECC_
+
+/* Curves IDs */
+#define ECC_CURVE_NIST_P192	0x0001
+#define ECC_CURVE_NIST_P256	0x0002
+
+#define ECC_MAX_DIGITS	4 /* 256 */
+
+#define ECC_DIGITS_TO_BYTES_SHIFT 3
+
+#define ECC_MAX_DIGIT_BYTES (ECC_MAX_DIGITS << ECC_DIGITS_TO_BYTES_SHIFT)
+
+#endif /* _CRYPTO_ECC_ */
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 03a64f62ba7a..c8556305acad 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2016, Intel Corporation
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
+ * Copyright (c) 2017, NVIDIA Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -13,24 +14,19 @@
 #ifndef _CRYPTO_ECDH_
 #define _CRYPTO_ECDH_
 
+#include <crypto/ecc.h>
+
 /**
  * DOC: ECDH Helper Functions
  *
  * To use ECDH with the KPP cipher API, the following data structure and
  * functions should be used.
  *
- * The ECC curves known to the ECDH implementation are specified in this
- * header file.
- *
  * To use ECDH with KPP, the following functions should be used to operate on
  * an ECDH private key. The packet private key that can be set with
  * the KPP API function call of crypto_kpp_set_secret.
  */
 
-/* Curves IDs */
-#define ECC_CURVE_NIST_P192	0x0001
-#define ECC_CURVE_NIST_P256	0x0002
-
 /**
  * struct ecdh - define an ECDH private key
  *
-- 
1.7.6.3

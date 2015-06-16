From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v6 2/3] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 01:02:05 -0700
Message-ID: <20150616080205.447.58498.stgit@tstruk-mobl1>
References: <20150616080153.447.83834.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	tadeusz.struk@intel.com, steved@redhat.com, qat-linux@intel.com,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbbFPICj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 04:02:39 -0400
In-Reply-To: <20150616080153.447.83834.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a new rsa generic SW implementation.
This implements only cryptographic primitives.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig                |    7 +
 crypto/Makefile               |    8 +
 crypto/rsa.c                  |  313 +++++++++++++++++++++++++++++++++++++++++
 crypto/rsa_helper.c           |  124 ++++++++++++++++
 crypto/rsakey.asn1            |    5 +
 include/crypto/internal/rsa.h |   28 ++++
 6 files changed, 485 insertions(+)
 create mode 100644 crypto/rsa.c
 create mode 100644 crypto/rsa_helper.c
 create mode 100644 crypto/rsakey.asn1
 create mode 100644 include/crypto/internal/rsa.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 264dadb..52467cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,6 +102,13 @@ config CRYPTO_AKCIPHER
 	help
 	  Crypto API interface for public key algorithms.
 
+config CRYPTO_RSA
+	tristate "RSA algorithm"
+	select AKCIPHER
+	select MPILIB
+	help
+	  Generic implementation of the RSA public key algorithm.
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
diff --git a/crypto/Makefile b/crypto/Makefile
index 6f2940a..c6217ea 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -30,6 +30,14 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER) += akcipher.o
 
+$(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
+clean-files += rsakey-asn1.c rsakey-asn1.h
+
+rsa_generic-y := rsakey-asn1.o
+rsa_generic-y += rsa.o
+rsa_generic-y += rsa_helper.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
+
 cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
diff --git a/crypto/rsa.c b/crypto/rsa.c
new file mode 100644
index 0000000..33bb7f0
--- /dev/null
+++ b/crypto/rsa.c
@@ -0,0 +1,313 @@
+/* RSA asymmetric public-key algorithm [RFC3447]
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <crypto/internal/rsa.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+
+/*
+ * RSAEP function [RFC3447 sec 5.1.1]
+ * c = m^e mod n;
+ */
+static int _rsa_enc(const struct rsa_key *key, MPI c, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
+		return -EINVAL;
+
+	/* (2) c = m^e mod n */
+	return mpi_powm(c, m, key->e, key->n);
+}
+
+/*
+ * RSADP function [RFC3447 sec 5.1.2]
+ * m = c^d mod n;
+ */
+static int _rsa_dec(const struct rsa_key *key, MPI m, MPI c)
+{
+	/* (1) Validate 0 <= c < n */
+	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->n) >= 0)
+		return -EINVAL;
+
+	/* (2) m = c^d mod n */
+	return mpi_powm(m, c, key->d, key->n);
+}
+
+/*
+ * RSASP1 function [RFC3447 sec 5.2.1]
+ * s = m^d mod n
+ */
+static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
+		return -EINVAL;
+
+	/* (2) s = m^d mod n */
+	return mpi_powm(s, m, key->d, key->n);
+}
+
+/*
+ * RSAVP1 function [RFC3447 sec 5.2.2]
+ * m = s^e mod n;
+ */
+static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
+{
+	/* (1) Validate 0 <= s < n */
+	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->n) >= 0)
+		return -EINVAL;
+
+	/* (2) m = s^e mod n */
+	return mpi_powm(m, s, key->e, key->n);
+}
+
+static struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
+{
+	return akcipher_tfm_ctx(tfm);
+}
+
+static int rsa_enc(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct rsa_key *pkey = rsa_get_key(tfm);
+	MPI m, c = mpi_alloc(0);
+	int ret = 0;
+	int sign;
+
+	if (!c)
+		return -ENOMEM;
+
+	if (!pkey->n || !pkey->e || !req->dst_len)
+		return -EINVAL;
+
+	if (*req->dst_len < mpi_get_size(pkey->n)) {
+		*req->dst_len = mpi_get_size(pkey->n);
+		return -EINVAL;
+	}
+
+	m = mpi_read_raw_data(req->src, req->src_len);
+	if (!m) {
+		ret = -ENOMEM;
+		goto err_free_c;
+	}
+
+	ret = _rsa_enc(pkey, c, m);
+	if (ret)
+		goto err_free_m;
+
+	ret = mpi_read_buffer(c, req->dst, *req->dst_len, req->dst_len, &sign);
+	if (ret)
+		goto err_free_m;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_m;
+	}
+
+err_free_m:
+	mpi_free(m);
+err_free_c:
+	mpi_free(c);
+	return ret;
+}
+
+static int rsa_dec(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct rsa_key *pkey = rsa_get_key(tfm);
+	MPI c, m = mpi_alloc(0);
+	int ret = 0;
+	int sign;
+
+	if (!m)
+		return -ENOMEM;
+
+	if (!pkey->n || !pkey->d || !req->dst_len)
+		return -EINVAL;
+
+	if (*req->dst_len < mpi_get_size(pkey->n)) {
+		*req->dst_len = mpi_get_size(pkey->n);
+		return -EINVAL;
+	}
+
+	c = mpi_read_raw_data(req->src, req->src_len);
+	if (!c) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
+
+	ret = _rsa_dec(pkey, m, c);
+	if (ret)
+		goto err_free_c;
+
+	ret = mpi_read_buffer(m, req->dst, *req->dst_len, req->dst_len, &sign);
+	if (ret)
+		goto err_free_c;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_c;
+	}
+
+err_free_c:
+	mpi_free(c);
+err_free_m:
+	mpi_free(m);
+	return ret;
+}
+
+static int rsa_sign(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct rsa_key *pkey  = rsa_get_key(tfm);
+	MPI m, s = mpi_alloc(0);
+	int ret = 0;
+	int sign;
+
+	if (!s)
+		return -ENOMEM;
+
+	if (!pkey->n || !pkey->d || !req->dst_len)
+		return -EINVAL;
+
+	if (*req->dst_len < mpi_get_size(pkey->n)) {
+		*req->dst_len = mpi_get_size(pkey->n);
+		return -EINVAL;
+	}
+
+	m = mpi_read_raw_data(req->src, req->src_len);
+	if (!m) {
+		ret = -ENOMEM;
+		goto err_free_s;
+	}
+
+	ret = _rsa_sign(pkey, s, m);
+	if (ret)
+		goto err_free_m;
+
+	ret = mpi_read_buffer(s, req->dst, *req->dst_len, req->dst_len, &sign);
+	if (ret)
+		goto err_free_m;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_m;
+	}
+
+
+err_free_m:
+	mpi_free(m);
+err_free_s:
+	mpi_free(s);
+	return ret;
+}
+
+static int rsa_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct rsa_key *pkey = rsa_get_key(tfm);
+	MPI s, m = mpi_alloc(0);
+	int ret = 0;
+	int sign;
+
+	if (!m)
+		return -ENOMEM;
+
+	if (!pkey->n || !pkey->e || !req->dst_len)
+		return -EINVAL;
+
+	if (*req->dst_len < mpi_get_size(pkey->n)) {
+		*req->dst_len = mpi_get_size(pkey->n);
+		return -EINVAL;
+	}
+
+	s = mpi_read_raw_data(req->src, req->src_len);
+	if (!s) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
+
+	ret = _rsa_verify(pkey, m, s);
+	if (ret)
+		goto err_free_s;
+
+	ret = mpi_read_buffer(m, req->dst, *req->dst_len, req->dst_len, &sign);
+	if (ret)
+		goto err_free_s;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_s;
+	}
+
+err_free_s:
+	mpi_free(s);
+err_free_m:
+	mpi_free(m);
+	return ret;
+}
+
+static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
+		      unsigned int keylen)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+
+	return rsa_parse_key(pkey, key, keylen);
+}
+
+static int rsa_init_tfm(struct crypto_tfm *_tfm)
+{
+	return 0;
+}
+
+static void rsa_exit_tfm(struct crypto_tfm *_tfm)
+{
+	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(_tfm);
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+
+	rsa_free_key(pkey);
+}
+
+static struct akcipher_alg rsa = {
+	.encrypt = rsa_enc,
+	.decrypt = rsa_dec,
+	.sign = rsa_sign,
+	.verify = rsa_verify,
+	.setkey = rsa_setkey,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-generic",
+		.cra_priority = 100,
+		.cra_ctxsize = 0,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct rsa_key),
+		.cra_init = rsa_init_tfm,
+		.cra_exit = rsa_exit_tfm,
+	},
+};
+
+static int rsa_init(void)
+{
+	return crypto_register_akcipher(&rsa);
+}
+
+static void rsa_exit(void)
+{
+	crypto_unregister_akcipher(&rsa);
+}
+
+module_init(rsa_init);
+module_exit(rsa_exit);
+MODULE_ALIAS_CRYPTO("rsa");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RSA generic algorithm");
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
new file mode 100644
index 0000000..103dd2e
--- /dev/null
+++ b/crypto/rsa_helper.c
@@ -0,0 +1,124 @@
+/*
+ * RSA key extract helper
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <linux/fips.h>
+#include <crypto/internal/rsa.h>
+#include "rsakey-asn1.h"
+
+int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
+	      const void *value, size_t vlen)
+{
+	struct rsa_key *key = context;
+
+	key->n = mpi_read_raw_data(value, vlen);
+
+	if (!key->n)
+		return -ENOMEM;
+
+	/* In FIPS mode only allow key size 2K & 3K */
+	if (fips_enabled && (mpi_get_size(key->n) != 256 ||
+			     mpi_get_size(key->n) != 384)) {
+		pr_err("RSA: key size not allowed in FIPS mode\n");
+		mpi_free(key->n);
+		key->n = NULL;
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
+	      const void *value, size_t vlen)
+{
+	struct rsa_key *key = context;
+
+	key->e = mpi_read_raw_data(value, vlen);
+
+	if (!key->e)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
+	      const void *value, size_t vlen)
+{
+	struct rsa_key *key = context;
+
+	key->d = mpi_read_raw_data(value, vlen);
+
+	if (!key->d)
+		return -ENOMEM;
+
+	/* In FIPS mode only allow key size 2K & 3K */
+	if (fips_enabled && (mpi_get_size(key->d) != 256 ||
+			     mpi_get_size(key->d) != 384)) {
+		pr_err("RSA: key size not allowed in FIPS mode\n");
+		mpi_free(key->d);
+		key->d = NULL;
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void free_mpis(struct rsa_key *key)
+{
+	if (key->n)
+		mpi_free(key->n);
+
+	if (key->e)
+		mpi_free(key->e);
+
+	if (key->d)
+		mpi_free(key->d);
+
+	key->n = NULL;
+	key->e = NULL;
+	key->d = NULL;
+}
+
+/**
+ * rsa_free_key() - frees rsa key allocated by rsa_parse_key()
+ *
+ * @rsa_key:	struct rsa_key key representation
+ */
+void rsa_free_key(struct rsa_key *key)
+{
+	free_mpis(key);
+}
+EXPORT_SYMBOL_GPL(rsa_free_key);
+
+/**
+ * rsa_parse_key() - extracts an rsa key from BER encoded buffer
+ *		     and stores it in the provided struct rsa_key
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in BER format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
+		  unsigned int key_len)
+{
+	int ret;
+
+	free_mpis(rsa_key);
+	ret = asn1_ber_decoder(&rsakey_decoder, rsa_key, key, key_len);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+error:
+	free_mpis(rsa_key);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rsa_parse_key);
diff --git a/crypto/rsakey.asn1 b/crypto/rsakey.asn1
new file mode 100644
index 0000000..3c7b5df
--- /dev/null
+++ b/crypto/rsakey.asn1
@@ -0,0 +1,5 @@
+RsaKey ::= SEQUENCE {
+	n INTEGER ({ rsa_get_n }),
+	e INTEGER ({ rsa_get_e }),
+	d INTEGER ({ rsa_get_d })
+}
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
new file mode 100644
index 0000000..018f373
--- /dev/null
+++ b/include/crypto/internal/rsa.h
@@ -0,0 +1,28 @@
+/*
+ * RSA internal helpers
+ *
+ * Copyright (c) 2015, Intel Corporation
+ * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _RSA_HELPER_
+#define _RSA_HELPER_
+#include <linux/mpi.h>
+#include <crypto/akcipher.h>
+
+struct rsa_key {
+	MPI n;
+	MPI e;
+	MPI d;
+};
+
+int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
+		  unsigned int key_len);
+
+void rsa_free_key(struct rsa_key *rsa_key);
+#endif

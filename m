From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v4 3/4] crypto: rsa: add a new rsa generic implementation
Date: Thu, 11 Jun 2015 12:05:49 -0700
Message-ID: <20150611190549.31826.66102.stgit@tstruk-mobl1>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17112 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbFKTFt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 15:05:49 -0400
In-Reply-To: <20150611190533.31826.13956.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a new rsa generic SW implementation.
This implements only cryptographic primitives.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig  |    7 +
 crypto/Makefile |    1 
 crypto/rsa.c    |  289 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 297 insertions(+)
 create mode 100644 crypto/rsa.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index d119b38..4d1bff3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -97,6 +97,13 @@ config CRYPTO_AKCIPHER
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
index 6f2940a..7ba05f0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER) += akcipher.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa.o
 
 cryptomgr-y := algboss.o testmgr.o
 
diff --git a/crypto/rsa.c b/crypto/rsa.c
new file mode 100644
index 0000000..8efef17
--- /dev/null
+++ b/crypto/rsa.c
@@ -0,0 +1,289 @@
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
+#include <linux/scatterlist.h>
+#include <crypto/public_key.h>
+#include <crypto/akcipher.h>
+
+/*
+ * RSAEP function [RFC3447 sec 5.1.1]
+ * c = m^e mod n;
+ */
+static int _rsa_enc(const struct public_key *key, MPI c, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->rsa.n) >= 0)
+		return -EINVAL;
+
+	/* (2) c = m^e mod n */
+	return mpi_powm(c, m, key->rsa.e, key->rsa.n);
+}
+
+/*
+ * RSADP function [RFC3447 sec 5.1.2]
+ * m = c^d mod n;
+ */
+static int _rsa_dec(const struct public_key *key, MPI m, MPI c)
+{
+	/* (1) Validate 0 <= c < n */
+	if (mpi_cmp_ui(c, 0) < 0 || mpi_cmp(c, key->rsa.n) >= 0)
+		return -EINVAL;
+
+	/* (2) m = c^d mod n */
+	return mpi_powm(m, c, key->rsa.d, key->rsa.n);
+}
+
+/*
+ * RSASP1 function [RFC3447 sec 5.2.1]
+ * s = m^d mod n
+ */
+static int _rsa_sign(const struct public_key *key, MPI s, MPI m)
+{
+	/* (1) Validate 0 <= m < n */
+	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->rsa.n) >= 0)
+		return -EINVAL;
+
+	/* (2) s = m^d mod n */
+	return mpi_powm(s, m, key->rsa.d, key->rsa.n);
+}
+
+/*
+ * RSAVP1 function [RFC3447 sec 5.2.2]
+ * m = s^e mod n;
+ */
+static int _rsa_verify(const struct public_key *key, MPI m, MPI s)
+{
+	/* (1) Validate 0 <= s < n */
+	if (mpi_cmp_ui(s, 0) < 0 || mpi_cmp(s, key->rsa.n) >= 0)
+		return -EINVAL;
+
+	/* (2) m = s^e mod n */
+	return mpi_powm(m, s, key->rsa.e, key->rsa.n);
+}
+
+static int rsa_enc(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = akcipher_request_get_tfm(req);
+	const struct public_key *pkey = crypto_akcipher_getkey(tfm);
+	MPI m, c = mpi_alloc(0);
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!c)
+		return -ENOMEM;
+
+	if (!pkey->rsa.e || req->dst_len < mpi_get_size(pkey->rsa.n))
+		return -EINVAL;
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
+	ret = mpi_read_buffer(c, req->dst, req->dst_len, &len, &sign);
+	if (ret)
+		goto err_free_m;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_m;
+	}
+
+	if (req->result_len)
+		*req->result_len = len;
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
+	const struct public_key *pkey = crypto_akcipher_getkey(tfm);
+	MPI c, m = mpi_alloc(0);
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!m)
+		return -ENOMEM;
+
+	if (!pkey->rsa.d || req->dst_len < mpi_get_size(pkey->rsa.n))
+		return -EINVAL;
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
+	ret = mpi_read_buffer(m, req->dst, req->dst_len, &len, &sign);
+	if (ret)
+		goto err_free_c;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_c;
+	}
+
+	if (req->result_len)
+		*req->result_len = len;
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
+	const struct public_key *pkey = crypto_akcipher_getkey(tfm);
+	MPI m, s = mpi_alloc(0);
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!s)
+		return -ENOMEM;
+
+	if (!pkey->rsa.d || req->dst_len < mpi_get_size(pkey->rsa.n))
+		return -EINVAL;
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
+	ret = mpi_read_buffer(s, req->dst, req->dst_len, &len, &sign);
+	if (ret)
+		goto err_free_m;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_m;
+	}
+
+	if (req->result_len)
+		*req->result_len = len;
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
+	const struct public_key *pkey = crypto_akcipher_getkey(tfm);
+	MPI s, m = mpi_alloc(0);
+	unsigned int len;
+	int ret = 0;
+	int sign;
+
+	if (!m)
+		return -ENOMEM;
+
+	if (!pkey->rsa.e || req->dst_len < mpi_get_size(pkey->rsa.n))
+		return -EINVAL;
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
+	ret = mpi_read_buffer(m, req->dst, req->dst_len, &len, &sign);
+	if (ret)
+		goto err_free_s;
+
+	if (sign < 0) {
+		ret = -EBADMSG;
+		goto err_free_s;
+	}
+
+	if (req->result_len)
+		*req->result_len = len;
+
+err_free_s:
+	mpi_free(s);
+err_free_m:
+	mpi_free(m);
+	return ret;
+}
+
+static int rsa_maxsize(struct crypto_akcipher *tfm)
+{
+	const struct public_key *pkey = crypto_akcipher_getkey(tfm);
+
+	if (pkey && pkey->rsa.n)
+		return mpi_get_size(pkey->rsa.n);
+
+	return -EINVAL;
+}
+
+static struct akcipher_alg rsa = {
+	.encrypt = rsa_enc,
+	.decrypt = rsa_dec,
+	.sign = rsa_sign,
+	.verify = rsa_verify,
+	.maxsize = rsa_maxsize,
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "rsa-generic",
+		.cra_priority = 100,
+		.cra_ctxsize = 0,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
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

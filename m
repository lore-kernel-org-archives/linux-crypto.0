From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 6/8] crypto: rsa - update accoring to akcipher API changes
Date: Wed, 09 Sep 2015 09:15:32 -0700
Message-ID: <20150909161532.2828.990.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbbIIQRU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:20 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rsa updates to reflect the API changes.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Makefile               |   12 ++-
 crypto/rsa.c                  |  188 ++++++++++++++++++++++++++++++++++-------
 crypto/rsa_helper.c           |   42 ++++++++-
 crypto/rsakey.asn1            |    5 -
 crypto/rsaprivkey.asn1        |   11 ++
 crypto/rsapubkey.asn1         |    4 +
 include/crypto/internal/rsa.h |    7 +-
 7 files changed, 220 insertions(+), 49 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivkey.asn1
 create mode 100644 crypto/rsapubkey.asn1

diff --git a/crypto/Makefile b/crypto/Makefile
index 65e91da..d897e0b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -31,8 +31,16 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
-$(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
-clean-files += rsakey-asn1.c rsakey-asn1.h
+$(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
+$(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
+clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
+clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
+
+rsa_generic-y := rsapubkey-asn1.o
+rsa_generic-y += rsaprivkey-asn1.o
+rsa_generic-y += rsa.o
+rsa_generic-y += rsa_helper.o
+obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
 cryptomgr-y := algboss.o testmgr.o
 
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 93feae2..f5b956c 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -13,6 +13,7 @@
 #include <crypto/internal/rsa.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
+#include <crypto/scatterwalk.h>
 
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
@@ -80,34 +81,57 @@ static int rsa_enc(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, c = mpi_alloc(0);
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!c)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->e)) {
+	if (unlikely(!pkey->n || !pkey->e || !src_len)) {
 		ret = -EINVAL;
 		goto err_free_c;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
+	if (dst_len < mpi_get_size(pkey->n)) {
+		req->out_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_c;
 	}
 
-	m = mpi_read_raw_data(req->src, req->src_len);
-	if (!m) {
-		ret = -ENOMEM;
-		goto err_free_c;
+	ret = -ENOMEM;
+	if (sg_is_last(req->src)) {
+		m = mpi_read_raw_data(sg_virt(req->src), src_len);
+	} else {
+		void *ptr = kmalloc(src_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_c;
+
+		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
+		m = mpi_read_raw_data(ptr, src_len);
+		kfree(ptr);
 	}
+	if (!m)
+		goto err_free_c;
 
 	ret = _rsa_enc(pkey, c, m);
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_read_buffer(c, req->dst, req->dst_len, &req->dst_len, &sign);
+	if (sg_is_last(req->dst)) {
+		ret = mpi_read_buffer(c, sg_virt(req->dst), dst_len,
+				      &req->out_len, &sign);
+	} else {
+		void *ptr = kmalloc(dst_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_m;
+
+		ret = mpi_read_buffer(c, ptr, dst_len, &req->out_len, &sign);
+		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
+		kfree(ptr);
+	}
 	if (ret)
 		goto err_free_m;
 
@@ -128,34 +152,57 @@ static int rsa_dec(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI c, m = mpi_alloc(0);
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!m)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->d)) {
+	if (unlikely(!pkey->n || !pkey->d || !src_len)) {
 		ret = -EINVAL;
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
+	if (dst_len < mpi_get_size(pkey->n)) {
+		req->out_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_m;
 	}
 
-	c = mpi_read_raw_data(req->src, req->src_len);
-	if (!c) {
-		ret = -ENOMEM;
-		goto err_free_m;
+	ret = -ENOMEM;
+	if (sg_is_last(req->src)) {
+		c = mpi_read_raw_data(sg_virt(req->src), src_len);
+	} else {
+		void *ptr = kmalloc(src_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_m;
+
+		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
+		c = mpi_read_raw_data(ptr, src_len);
+		kfree(ptr);
 	}
+	if (!c)
+		goto err_free_m;
 
 	ret = _rsa_dec(pkey, m, c);
 	if (ret)
 		goto err_free_c;
 
-	ret = mpi_read_buffer(m, req->dst, req->dst_len, &req->dst_len, &sign);
+	if (sg_is_last(req->dst)) {
+		ret = mpi_read_buffer(m, sg_virt(req->dst), dst_len,
+				      &req->out_len, &sign);
+	} else {
+		void *ptr = kmalloc(dst_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_c;
+
+		ret = mpi_read_buffer(m, ptr, dst_len, &req->out_len, &sign);
+		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
+		kfree(ptr);
+	}
 	if (ret)
 		goto err_free_c;
 
@@ -176,34 +223,58 @@ static int rsa_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, s = mpi_alloc(0);
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!s)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->d)) {
+	if (unlikely(!pkey->n || !pkey->d || !src_len)) {
 		ret = -EINVAL;
 		goto err_free_s;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
+	if (dst_len < mpi_get_size(pkey->n)) {
+		req->out_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_s;
 	}
 
-	m = mpi_read_raw_data(req->src, req->src_len);
-	if (!m) {
-		ret = -ENOMEM;
-		goto err_free_s;
+	ret = -ENOMEM;
+	if (sg_is_last(req->src)) {
+		m = mpi_read_raw_data(sg_virt(req->src), src_len);
+	} else {
+		void *ptr = kmalloc(src_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_s;
+
+		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
+		m = mpi_read_raw_data(ptr, src_len);
+		kfree(ptr);
+
 	}
+	if (!m)
+		goto err_free_s;
 
 	ret = _rsa_sign(pkey, s, m);
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_read_buffer(s, req->dst, req->dst_len, &req->dst_len, &sign);
+	if (sg_is_last(req->dst)) {
+		ret = mpi_read_buffer(s, sg_virt(req->dst), dst_len,
+				      &req->out_len, &sign);
+	} else {
+		void *ptr = kmalloc(dst_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_m;
+
+		ret = mpi_read_buffer(s, ptr, dst_len, &req->out_len, &sign);
+		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
+		kfree(ptr);
+	}
 	if (ret)
 		goto err_free_m;
 
@@ -224,24 +295,37 @@ static int rsa_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI s, m = mpi_alloc(0);
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!m)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->e)) {
+	if (unlikely(!pkey->n || !pkey->e || !src_len)) {
 		ret = -EINVAL;
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
-		req->dst_len = mpi_get_size(pkey->n);
+	if (dst_len < mpi_get_size(pkey->n)) {
+		req->out_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_m;
 	}
 
-	s = mpi_read_raw_data(req->src, req->src_len);
+	ret = -ENOMEM;
+	if (sg_is_last(req->src)) {
+		s = mpi_read_raw_data(sg_virt(req->src), src_len);
+	} else {
+		void *ptr = kmalloc(src_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_m;
+
+		scatterwalk_map_and_copy(ptr, req->src, 0, src_len, 0);
+		s = mpi_read_raw_data(ptr, src_len);
+		kfree(ptr);
+	}
 	if (!s) {
 		ret = -ENOMEM;
 		goto err_free_m;
@@ -251,7 +335,19 @@ static int rsa_verify(struct akcipher_request *req)
 	if (ret)
 		goto err_free_s;
 
-	ret = mpi_read_buffer(m, req->dst, req->dst_len, &req->dst_len, &sign);
+	if (sg_is_last(req->dst)) {
+		ret = mpi_read_buffer(m, sg_virt(req->dst), dst_len,
+				      &req->out_len, &sign);
+	} else {
+		void *ptr = kmalloc(dst_len, GFP_KERNEL);
+
+		if (!ptr)
+			goto err_free_s;
+
+		ret = mpi_read_buffer(m, ptr, dst_len, &req->out_len, &sign);
+		scatterwalk_map_and_copy(ptr, req->dst, 0, dst_len, 1);
+		kfree(ptr);
+	}
 	if (ret)
 		goto err_free_s;
 
@@ -282,13 +378,30 @@ static int rsa_check_key_length(unsigned int len)
 	return -EINVAL;
 }
 
-static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
-		      unsigned int keylen)
+static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+			   unsigned int keylen)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	int ret;
+
+	ret = rsa_parse_pub_key(pkey, key, keylen);
+	if (ret)
+		return ret;
+
+	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
+		rsa_free_key(pkey);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+			    unsigned int keylen)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
 	int ret;
 
-	ret = rsa_parse_key(pkey, key, keylen);
+	ret = rsa_parse_priv_key(pkey, key, keylen);
 	if (ret)
 		return ret;
 
@@ -299,6 +412,13 @@ static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 	return ret;
 }
 
+static int rsa_get_len(struct crypto_akcipher *tfm)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+
+	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+}
+
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
@@ -311,7 +431,9 @@ static struct akcipher_alg rsa = {
 	.decrypt = rsa_dec,
 	.sign = rsa_sign,
 	.verify = rsa_verify,
-	.setkey = rsa_setkey,
+	.set_priv_key = rsa_set_priv_key,
+	.set_pub_key = rsa_set_pub_key,
+	.get_len = rsa_get_len,
 	.exit = rsa_exit_tfm,
 	.base = {
 		.cra_name = "rsa",
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 8d96ce9..d226f48 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -15,7 +15,8 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <crypto/internal/rsa.h>
-#include "rsakey-asn1.h"
+#include "rsapubkey-asn1.h"
+#include "rsaprivkey-asn1.h"
 
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
@@ -94,8 +95,8 @@ void rsa_free_key(struct rsa_key *key)
 EXPORT_SYMBOL_GPL(rsa_free_key);
 
 /**
- * rsa_parse_key() - extracts an rsa key from BER encoded buffer
- *		     and stores it in the provided struct rsa_key
+ * rsa_parse_pub_key() - extracts an rsa public key from BER encoded buffer
+ *			 and stores it in the provided struct rsa_key
  *
  * @rsa_key:	struct rsa_key key representation
  * @key:	key in BER format
@@ -103,13 +104,13 @@ EXPORT_SYMBOL_GPL(rsa_free_key);
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
-		  unsigned int key_len)
+int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+		      unsigned int key_len)
 {
 	int ret;
 
 	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsakey_decoder, rsa_key, key, key_len);
+	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
 	if (ret < 0)
 		goto error;
 
@@ -118,4 +119,31 @@ error:
 	free_mpis(rsa_key);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(rsa_parse_key);
+EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
+
+/**
+ * rsa_parse_pub_key() - extracts an rsa private key from BER encoded buffer
+ *			 and stores it in the provided struct rsa_key
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in BER format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+		       unsigned int key_len)
+{
+	int ret;
+
+	free_mpis(rsa_key);
+	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+error:
+	free_mpis(rsa_key);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
diff --git a/crypto/rsakey.asn1 b/crypto/rsakey.asn1
deleted file mode 100644
index 3c7b5df..0000000
--- a/crypto/rsakey.asn1
+++ /dev/null
@@ -1,5 +0,0 @@
-RsaKey ::= SEQUENCE {
-	n INTEGER ({ rsa_get_n }),
-	e INTEGER ({ rsa_get_e }),
-	d INTEGER ({ rsa_get_d })
-}
diff --git a/crypto/rsaprivkey.asn1 b/crypto/rsaprivkey.asn1
new file mode 100644
index 0000000..731aea5
--- /dev/null
+++ b/crypto/rsaprivkey.asn1
@@ -0,0 +1,11 @@
+RsaPrivKey ::= SEQUENCE {
+	version		INTEGER,
+	n		INTEGER ({ rsa_get_n }),
+	e		INTEGER ({ rsa_get_e }),
+	d		INTEGER ({ rsa_get_d }),
+	prime1		INTEGER,
+	prime2		INTEGER,
+	exponent1	INTEGER,
+	exponent2	INTEGER,
+	coefficient	INTEGER
+}
diff --git a/crypto/rsapubkey.asn1 b/crypto/rsapubkey.asn1
new file mode 100644
index 0000000..725498e
--- /dev/null
+++ b/crypto/rsapubkey.asn1
@@ -0,0 +1,4 @@
+RsaPubKey ::= SEQUENCE {
+	n INTEGER ({ rsa_get_n }),
+	e INTEGER ({ rsa_get_e })
+}
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index a8c8636..f997e2d 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -20,8 +20,11 @@ struct rsa_key {
 	MPI d;
 };
 
-int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
-		  unsigned int key_len);
+int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+		      unsigned int key_len);
+
+int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+		       unsigned int key_len);
 
 void rsa_free_key(struct rsa_key *rsa_key);
 #endif

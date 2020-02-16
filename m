Return-Path: <SRS0=RXXs=4E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE27C2BA83
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8A9D206E2
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgBPJFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Feb 2020 04:05:25 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46873 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbgBPJFZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Feb 2020 04:05:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tq4ZmUp_1581843592;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tq4ZmUp_1581843592)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 16 Feb 2020 16:59:53 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, pvanleeuwen@rambus.com, zohar@linux.ibm.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm
Date:   Sun, 16 Feb 2020 16:59:24 +0800
Message-Id: <20200216085928.108838-4-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
References: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This new module implement the SM2 public key algorithm. It was
published by State Encryption Management Bureau, China.
List of specifications for SM2 elliptic curve public key cryptography:

* GM/T 0003.1-2012
* GM/T 0003.2-2012
* GM/T 0003.3-2012
* GM/T 0003.4-2012
* GM/T 0003.5-2012

IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
scctc: http://www.gmbz.org.cn/main/bzlb.html

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/Kconfig           |   17 +
 crypto/Makefile          |    8 +
 crypto/sm2.c             | 1145 ++++++++++++++++++++++++++++++++++++++
 crypto/sm2signature.asn1 |    4 +
 include/crypto/sm2.h     |   25 +
 5 files changed, 1199 insertions(+)
 create mode 100644 crypto/sm2.c
 create mode 100644 crypto/sm2signature.asn1
 create mode 100644 include/crypto/sm2.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5575d48473bd..4a58673c85dd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -264,6 +264,23 @@ config CRYPTO_ECRDSA
 	  standard algorithms (called GOST algorithms). Only signature verification
 	  is implemented.
 
+config CRYPTO_SM2
+	tristate "SM2 algorithm"
+	select CRYPTO_SM3
+	select CRYPTO_AKCIPHER
+	select CRYPTO_MANAGER
+	select MPILIB
+	select ASN1
+	help
+	  Generic implementation of the SM2 public key algorithm. It was
+	  published by State Encryption Management Bureau, China.
+	  as specified by OSCCA GM/T 0003.1-2012 -- 0003.5-2012.
+
+	  References:
+	  https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
+	  http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
+	  http://www.gmbz.org.cn/main/bzlb.html
+
 config CRYPTO_CURVE25519
 	tristate "Curve25519 algorithm"
 	select CRYPTO_KPP
diff --git a/crypto/Makefile b/crypto/Makefile
index 4ca12b6044f7..b279483fba50 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -42,6 +42,14 @@ rsa_generic-y += rsa_helper.o
 rsa_generic-y += rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
+$(obj)/sm2signature.asn1.o: $(obj)/sm2signature.asn1.c $(obj)/sm2signature.asn1.h
+$(obj)/sm2.o: $(obj)/sm2signature.asn1.h
+
+sm2_generic-y += sm2signature.asn1.o
+sm2_generic-y += sm2.o
+
+obj-$(CONFIG_CRYPTO_SM2) += sm2_generic.o
+
 crypto_acompress-y := acompress.o
 crypto_acompress-y += scompress.o
 obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
diff --git a/crypto/sm2.c b/crypto/sm2.c
new file mode 100644
index 000000000000..0410975554d1
--- /dev/null
+++ b/crypto/sm2.c
@@ -0,0 +1,1145 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SM2 asymmetric public-key algorithm
+ * as specified by OSCCA GM/T 0003.1-2012 -- 0003.5-2012 SM2 and
+ * described at https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
+ *
+ * Copyright (c) 2020, Alibaba Group.
+ * Authors: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+#include <linux/module.h>
+#include <linux/mpi.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <crypto/hash.h>
+#include <crypto/sm3_base.h>
+#include <crypto/rng.h>
+#include <crypto/sm2.h>
+#include "sm2signature.asn1.h"
+
+#define MPI_NBYTES(m)   ((mpi_get_nbits(m) + 7) / 8)
+
+struct ecc_domain_parms {
+	const char *desc;           /* Description of the curve.  */
+	unsigned int nbits;         /* Number of bits.  */
+	unsigned int fips:1; /* True if this is a FIPS140-2 approved curve */
+
+	/* The model describing this curve.  This is mainly used to select
+	 * the group equation.
+	 */
+	enum gcry_mpi_ec_models model;
+
+	/* The actual ECC dialect used.  This is used for curve specific
+	 * optimizations and to select encodings etc.
+	 */
+	enum ecc_dialects dialect;
+
+	const char *p;              /* The prime defining the field.  */
+	const char *a, *b;          /* The coefficients.  For Twisted Edwards
+				     * Curves b is used for d.  For Montgomery
+				     * Curves (a,b) has ((A-2)/4,B^-1).
+				     */
+	const char *n;              /* The order of the base point.  */
+	const char *g_x, *g_y;      /* Base point.  */
+	unsigned int h;             /* Cofactor.  */
+};
+
+static const struct ecc_domain_parms sm2_ecp = {
+	.desc = "sm2p256v1",
+	.nbits = 256,
+	.fips = 0,
+	.model = MPI_EC_WEIERSTRASS,
+	.dialect = ECC_DIALECT_STANDARD,
+	.p   = "0xfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff",
+	.a   = "0xfffffffeffffffffffffffffffffffffffffffff00000000fffffffffffffffc",
+	.b   = "0x28e9fa9e9d9f5e344d5a9e4bcf6509a7f39789f515ab8f92ddbcbd414d940e93",
+	.n   = "0xfffffffeffffffffffffffffffffffff7203df6b21c6052b53bbf40939d54123",
+	.g_x = "0x32c4ae2c1f1981195f9904466a39c9948fe30bbff2660be1715a4589334c74c7",
+	.g_y = "0xbc3736a2f4f6779c59bdcee36b692153d0a9877cc62a474002df32e52139f0a0",
+	.h = 1
+};
+
+static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
+{
+	const struct ecc_domain_parms *ecp = &sm2_ecp;
+	MPI p, a, b;
+	MPI x, y;
+	int rc = -EINVAL;
+
+	p = mpi_scanval(ecp->p);
+	a = mpi_scanval(ecp->a);
+	b = mpi_scanval(ecp->b);
+	if (!p || !a || !b)
+		goto free_p;
+
+	x = mpi_scanval(ecp->g_x);
+	y = mpi_scanval(ecp->g_y);
+	if (!x || !y)
+		goto free;
+
+	/* mpi_ec_setup_elliptic_curve */
+	ec->G = mpi_point_new(0);
+	if (!ec->G)
+		goto free;
+
+	mpi_set(ec->G->x, x);
+	mpi_set(ec->G->y, y);
+	mpi_set_ui(ec->G->z, 1);
+
+	ec->n = mpi_scanval(ecp->n);
+	if (!ec->n) {
+		mpi_point_release(ec->G);
+		goto free;
+	}
+
+	ec->h = ecp->h;
+	ec->name = ecp->desc;
+	mpi_ec_init(ec, ecp->model, ecp->dialect, 0, p, a, b);
+
+	rc = 0;
+
+free:
+	mpi_free(x);
+	mpi_free(y);
+free_p:
+	mpi_free(p);
+	mpi_free(a);
+	mpi_free(b);
+
+	return rc;
+}
+
+static void sm2_ec_ctx_deinit(struct mpi_ec_ctx *ec)
+{
+	mpi_free(ec->n);
+	mpi_point_release(ec->G);
+
+	mpi_ec_deinit(ec);
+
+	memset(ec, 0, sizeof(*ec));
+}
+
+static int sm2_ec_ctx_reset(struct mpi_ec_ctx *ec)
+{
+	sm2_ec_ctx_deinit(ec);
+	return sm2_ec_ctx_init(ec);
+}
+
+static unsigned char *sm2_ecc_ec2os(MPI x, MPI y, MPI p, unsigned int *plen)
+{
+	int rc;
+	int pbytes = (mpi_get_nbits(p)+7)/8;
+	size_t n;
+	unsigned char *buf, *ptr;
+
+	buf = kmalloc(1 + 2*pbytes, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+	*buf = 04; /* Uncompressed point. */
+	ptr = buf+1;
+	rc = mpi_print(GCRYMPI_FMT_USG, ptr, pbytes, &n, x);
+	if (rc) {
+		kfree(buf);
+		return NULL;
+	}
+	if (n < pbytes) {
+		memmove(ptr+(pbytes-n), ptr, n);
+		memset(ptr, 0, (pbytes-n));
+	}
+	ptr += pbytes;
+	rc = mpi_print(GCRYMPI_FMT_USG, ptr, pbytes, &n, y);
+	if (rc) {
+		kfree(buf);
+		return NULL;
+	}
+	if (n < pbytes) {
+		memmove(ptr+(pbytes-n), ptr, n);
+		memset(ptr, 0, (pbytes-n));
+	}
+
+	if (plen)
+		*plen = 1 + 2 * pbytes;
+	return buf;
+}
+
+/* Convert POINT into affine coordinates using the context CTX and
+ * return a newly allocated MPI.  If the conversion is not possible
+ * NULL is returned.  This function won't print an error message.
+ */
+static unsigned char *
+sm2_mpi_ec_ec2os(MPI_POINT point, struct mpi_ec_ctx *ec, unsigned int *plen)
+{
+	MPI g_x, g_y;
+	unsigned char *result;
+
+	g_x = mpi_new(0);
+	g_y = mpi_new(0);
+	if (mpi_ec_get_affine(g_x, g_y, point, ec))
+		result = NULL;
+	else
+		result = sm2_ecc_ec2os(g_x, g_y, ec->p, plen);
+	mpi_free(g_x);
+	mpi_free(g_y);
+
+	return result;
+}
+
+/* RESULT must have been initialized and is set on success to the
+ * point given by VALUE.
+ */
+static int sm2_ecc_os2ec(MPI_POINT result, MPI value)
+{
+	int rc;
+	size_t n;
+	const unsigned char *buf;
+	unsigned char *buf_memory;
+	MPI x, y;
+
+	n = (mpi_get_nbits(value)+7)/8;
+	buf_memory = kmalloc(n, GFP_KERNEL);
+	rc = mpi_print(GCRYMPI_FMT_USG, buf_memory, n, &n, value);
+	if (rc) {
+		kfree(buf_memory);
+		return rc;
+	}
+	buf = buf_memory;
+
+	if (n < 1) {
+		kfree(buf_memory);
+		return -EINVAL;
+	}
+	if (*buf != 4) {
+		kfree(buf_memory);
+		return -EINVAL; /* No support for point compression.  */
+	}
+	if (((n-1)%2)) {
+		kfree(buf_memory);
+		return -EINVAL;
+	}
+	n = (n-1)/2;
+	x = mpi_read_raw_data(buf + 1, n);
+	if (!x) {
+		kfree(buf_memory);
+		return -ENOMEM;
+	}
+	y = mpi_read_raw_data(buf + 1 + n, n);
+	kfree(buf_memory);
+	if (!y) {
+		mpi_free(x);
+		return -ENOMEM;
+	}
+
+	mpi_normalize(x);
+	mpi_normalize(y);
+
+	mpi_set(result->x, x);
+	mpi_set(result->y, y);
+	mpi_set_ui(result->z, 1);
+
+	mpi_free(x);
+	mpi_free(y);
+
+	return 0;
+}
+
+/*
+ * Generate a random secret exponent K less than Q.
+ */
+static MPI sm2_gen_k(MPI q)
+{
+	MPI k = NULL;
+	unsigned int nbits = mpi_get_nbits(q);
+	unsigned int nbytes = (nbits+7)/8;
+	char rndbuf[128];
+	int use_rng = 1;
+
+	if (nbytes > sizeof(rndbuf))
+		return NULL;
+	if (crypto_get_default_rng())
+		use_rng = 0;
+
+	for (;;) {
+
+		if (k) {
+			mpi_free(k);
+			k = NULL;
+		}
+
+		if (use_rng) {
+			if (crypto_rng_get_bytes(crypto_default_rng,
+					rndbuf, nbytes))
+				goto ret;
+		} else {
+			get_random_bytes(rndbuf, nbytes);
+		}
+
+		k = mpi_read_raw_data(rndbuf, nbytes);
+		if (!k)
+			goto ret;
+
+		/* Make sure we have the requested number of bits.  This code
+		 * looks a bit funny but it is easy to understand if you
+		 * consider that mpi_set_highbit clears all higher bits.  We
+		 * don't have a clear_highbit, thus we first set the high bit
+		 * and then clear it again.
+		 */
+		if (mpi_test_bit(k, nbits-1))
+			mpi_set_highbit(k, nbits-1);
+		else {
+			mpi_set_highbit(k, nbits-1);
+			mpi_clear_bit(k, nbits-1);
+		}
+
+		if (!(mpi_cmp(k, q) < 0))    /* check: k < q */
+			continue;
+		if (!(mpi_cmp_ui(k, 0) > 0)) /* check: k > 0 */
+			continue;
+
+		break;	/* okay */
+	}
+ret:
+	if (use_rng)
+		crypto_put_default_rng();
+	return k;
+}
+
+static MPI sm2_cipher_encode(MPI c1, MPI c3, MPI c2)
+{
+	unsigned int n;
+	unsigned char *buf, *p;
+	unsigned int nwritten;
+	int rc;
+	MPI result = NULL;
+
+	n = mpi_get_size(c1) + mpi_get_size(c3) + mpi_get_size(c2);
+
+	buf = kmalloc(n, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	p = buf;
+	rc = mpi_read_buffer(c1, p, mpi_get_size(c1), &nwritten, NULL);
+	if (rc)
+		goto err;
+	p += nwritten;
+	rc = mpi_read_buffer(c3, p, mpi_get_size(c3), &nwritten, NULL);
+	if (rc)
+		goto err;
+	p += nwritten;
+	rc = mpi_read_buffer(c2, p, mpi_get_size(c2), &nwritten, NULL);
+	if (rc)
+		goto err;
+
+	result = mpi_read_raw_data(buf, p + nwritten - buf);
+
+err:
+	kfree(buf);
+	return result;
+}
+
+static int sm2_cipher_decode(MPI c, MPI *c1, MPI *c3, MPI *c2)
+{
+	unsigned char *buf, *p;
+	unsigned int n;
+
+	buf = mpi_get_buffer(c, &n, NULL);
+	if (!buf)
+		return -ENOMEM;
+	if (n < 65 + SM3_DIGEST_SIZE)
+		return -EINVAL;
+
+	p = buf;
+	/* '0x04' + 2 * 256 bits */
+	*c1 = mpi_read_raw_data(p, 65);
+	p += 65;
+	*c3 = mpi_read_raw_data(p, SM3_DIGEST_SIZE);
+	p += SM3_DIGEST_SIZE;
+	*c2 = mpi_read_raw_data(p, buf + n - p);
+
+	kfree(buf);
+
+	if (!*c1 || !*c3 || !*c2) {
+		mpi_free(*c1);
+		mpi_free(*c3);
+		mpi_free(*c2);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static MPI sm2_signature_encode(MPI hash, MPI r, MPI s)
+{
+	unsigned char *buf;
+	unsigned int nwritten;
+	unsigned int n;
+	int rc;
+	MPI result = NULL;
+
+	/* both r and s are 256 bits */
+	n = SM3_DIGEST_SIZE + 32 * 2;
+	buf = kzalloc(n, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	rc = mpi_read_buffer(hash, buf, SM3_DIGEST_SIZE, &nwritten, NULL);
+	if (rc)
+		goto err;
+	rc = mpi_read_buffer(r, buf + SM3_DIGEST_SIZE, 32, &nwritten, NULL);
+	if (rc)
+		goto err;
+	rc = mpi_read_buffer(s, buf + SM3_DIGEST_SIZE + 32,
+			32, &nwritten, NULL);
+	if (rc)
+		goto err;
+
+	result = mpi_read_raw_data(buf, n);
+
+err:
+	kfree(buf);
+	return result;
+}
+
+struct sm2_signature_ctx {
+	MPI sig_r;
+	MPI sig_s;
+};
+
+int sm2_get_signature_r(void *context, size_t hdrlen, unsigned char tag,
+				const void *value, size_t vlen)
+{
+	struct sm2_signature_ctx *sig = context;
+
+	if (!value || !vlen)
+		return -EINVAL;
+
+	sig->sig_r = mpi_read_raw_data(value, vlen);
+	if (!sig->sig_r)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int sm2_get_signature_s(void *context, size_t hdrlen, unsigned char tag,
+				const void *value, size_t vlen)
+{
+	struct sm2_signature_ctx *sig = context;
+
+	if (!value || !vlen)
+		return -EINVAL;
+
+	sig->sig_s = mpi_read_raw_data(value, vlen);
+	if (!sig->sig_s)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int sm2_z_digest_update(struct shash_desc *desc,
+			MPI m, unsigned int pbytes)
+{
+	static const unsigned char zero[32];
+	unsigned char *in;
+	unsigned int inlen;
+
+	in = mpi_get_buffer(m, &inlen, NULL);
+	if (!in)
+		return -EINVAL;
+
+	if (inlen < pbytes) {
+		/* padding with zero */
+		crypto_sm3_update(desc, zero, pbytes - inlen);
+		crypto_sm3_update(desc, in, inlen);
+	} else if (inlen > pbytes) {
+		/* skip the starting zero */
+		crypto_sm3_update(desc, in + inlen - pbytes, pbytes);
+	} else {
+		crypto_sm3_update(desc, in, inlen);
+	}
+
+	kfree(in);
+	return 0;
+}
+
+static int sm2_z_digest_update_point(struct shash_desc *desc,
+			MPI_POINT point, struct mpi_ec_ctx *ec, unsigned int pbytes)
+{
+	MPI x, y;
+	int ret = -EINVAL;
+
+	x = mpi_new(0);
+	y = mpi_new(0);
+
+	if (!mpi_ec_get_affine(x, y, point, ec) &&
+		!sm2_z_digest_update(desc, x, pbytes) &&
+		!sm2_z_digest_update(desc, y, pbytes))
+		ret = 0;
+
+	mpi_free(x);
+	mpi_free(y);
+	return ret;
+}
+
+int sm2_compute_z_digest(struct crypto_akcipher *tfm,
+			const unsigned char *id, size_t id_len,
+			unsigned char dgst[SM3_DIGEST_SIZE])
+{
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	uint16_t bits_len;
+	unsigned char entl[2];
+	SHASH_DESC_ON_STACK(desc, NULL);
+	unsigned int pbytes;
+
+	if (id_len > (USHRT_MAX / 8) || !ec->Q)
+		return -EINVAL;
+
+	bits_len = (uint16_t)(id_len * 8);
+	entl[0] = bits_len >> 8;
+	entl[1] = bits_len & 0xff;
+
+	pbytes = MPI_NBYTES(ec->p);
+
+	/* ZA = H256(ENTLA | IDA | a | b | xG | yG | xA | yA) */
+	sm3_base_init(desc);
+	crypto_sm3_update(desc, entl, 2);
+	crypto_sm3_update(desc, id, id_len);
+
+	if (sm2_z_digest_update(desc, ec->a, pbytes) ||
+		sm2_z_digest_update(desc, ec->b, pbytes) ||
+		sm2_z_digest_update_point(desc, ec->G, ec, pbytes) ||
+		sm2_z_digest_update_point(desc, ec->Q, ec, pbytes))
+		return -EINVAL;
+
+	crypto_sm3_finup(desc, NULL, 0, dgst);
+	return 0;
+}
+EXPORT_SYMBOL(sm2_compute_z_digest);
+
+/* Key derivation function from X9.63/SECG */
+static void kdf_x9_63(const void *in, size_t inlen, void *out, size_t outlen)
+{
+	int mdlen = SM3_DIGEST_SIZE;
+	u32 counter = 1;
+	u32 counter_be;
+	unsigned char dgst[SM3_DIGEST_SIZE];
+	unsigned char *pout = out;
+	size_t rlen = outlen;
+	size_t len;
+	SHASH_DESC_ON_STACK(desc, NULL);
+
+	while (rlen > 0) {
+		counter_be = cpu_to_be32(counter);
+		counter++;
+
+		sm3_base_init(desc);
+		crypto_sm3_update(desc, in, inlen);
+		crypto_sm3_finup(desc, (const u8 *)&counter_be,
+				sizeof(counter_be), dgst);
+
+		len = mdlen < rlen ? mdlen : rlen;  /* min(mdlen, rlen) */
+		memcpy(pout, dgst, len);
+		rlen -= len;
+		pout += len;
+	}
+}
+
+static int _sm2_enc(struct mpi_ec_ctx *ec, MPI m, MPI *c1, MPI *c3, MPI *c2)
+{
+	int rc;
+	MPI k = NULL;
+	MPI x2, y2;
+	struct gcry_mpi_point kG, kP;
+	unsigned char *in = NULL;
+	unsigned int inlen;
+	unsigned int len;
+	unsigned char *x1y1 = NULL;
+	unsigned char *x2y2 = NULL;
+	unsigned char *cipher = NULL;
+	int i;
+
+	mpi_point_init(&kG);
+	mpi_point_init(&kP);
+	x2 = mpi_new(0);
+	y2 = mpi_new(0);
+
+	rc = -ENOMEM;
+	in = mpi_get_buffer(m, &inlen, NULL);
+	if (!in)
+		goto leave;
+
+	cipher = kmalloc(inlen, GFP_KERNEL);
+	if (!cipher)
+		goto leave;
+
+	/* rand k in [1, n-1] */
+	k = sm2_gen_k(ec->n);
+	if (k == NULL)
+		goto leave;
+
+	/* [k]G = (x1, y1) */
+	mpi_ec_mul_point(&kG, k, ec->G, ec);
+	x1y1 = sm2_mpi_ec_ec2os(&kG, ec, &len);
+	if (x1y1 == NULL)
+		goto leave;
+	*c1 = mpi_read_raw_data(x1y1, len);
+	if (*c1 == NULL)
+		goto leave;
+
+	/* [k]P = (x2, y2) */
+	rc = -EINVAL;
+	mpi_ec_mul_point(&kP, k, ec->Q, ec);
+	if (mpi_ec_get_affine(x2, y2, &kP, ec))
+		goto leave;
+
+	/* t = KDF(x2 || y2, klen) */
+	rc = -ENOMEM;
+	x2y2 = sm2_ecc_ec2os(x2, y2, ec->p, &len);
+	if (x2y2 == NULL)
+		goto leave;
+
+	/* skip the prefix '0x04' */
+	kdf_x9_63(x2y2 + 1, len - 1, cipher, inlen);
+
+	/* cipher = t xor in */
+	for (i = 0; i < inlen; i++)
+		cipher[i] ^= in[i];
+
+	*c2 = mpi_read_raw_data(cipher, inlen);
+	if (*c2 == NULL) {
+		rc = -ENOMEM;
+		goto leave;
+	}
+
+	/* hash(x2 || IN || y2) */
+	do {
+		SHASH_DESC_ON_STACK(desc, NULL);
+		unsigned char dgst[SM3_DIGEST_SIZE];
+
+		sm3_base_init(desc);
+		crypto_sm3_update(desc, x2y2 + 1, MPI_NBYTES(x2));
+		crypto_sm3_update(desc, in, inlen);
+		crypto_sm3_finup(desc, x2y2 + 1 + MPI_NBYTES(x2),
+				MPI_NBYTES(y2), dgst);
+
+		*c3 = mpi_read_raw_data(dgst, sizeof(dgst));
+		if (*c3 == NULL) {
+			rc = -ENOMEM;
+			goto leave;
+		}
+	} while (0);
+
+	rc = 0;
+
+leave:
+	if (rc) {
+		if (*c1)
+			mpi_free(*c1);
+		if (*c2)
+			mpi_free(*c2);
+		if (*c3)
+			mpi_free(*c3);
+		*c1 = NULL;
+		*c2 = NULL;
+		*c3 = NULL;
+	}
+
+	kfree(x2y2);
+	kfree(x1y1);
+	mpi_free(k);
+
+	kfree(cipher);
+	kfree(in);
+
+	mpi_point_free_parts(&kG);
+	mpi_point_free_parts(&kP);
+	mpi_free(x2);
+	mpi_free(y2);
+
+	return rc;
+}
+
+static int _sm2_dec(struct mpi_ec_ctx *ec, MPI c1, MPI c3, MPI c2, MPI *m)
+{
+	int rc;
+	MPI x2, y2;
+	struct gcry_mpi_point point_c1;
+	struct gcry_mpi_point kP;
+	unsigned char *x2y2 = NULL;
+	unsigned char *in = NULL;
+	unsigned int inlen;
+	unsigned char *plain = NULL;
+	unsigned int len;
+	unsigned char *hash = NULL;
+	int i;
+
+	mpi_point_init(&point_c1);
+	mpi_point_init(&kP);
+	x2 = mpi_new(0);
+	y2 = mpi_new(0);
+
+	rc = -ENOMEM;
+	in = mpi_get_buffer(c2, &inlen, NULL);
+	if (!in)
+		goto leave;
+
+	plain = kmalloc(inlen, GFP_KERNEL);
+	if (!plain)
+		goto leave;
+
+	rc = sm2_ecc_os2ec(&point_c1, c1);
+	if (rc)
+		goto leave;
+
+	rc = -EINVAL;
+	if (!mpi_ec_curve_point(&point_c1, ec))
+		goto leave;
+
+	/* [d]C1 = (x2, y2), C1 = [k]G */
+	mpi_ec_mul_point(&kP, ec->d, &point_c1, ec);
+	if (mpi_ec_get_affine(x2, y2, &kP, ec))
+		goto leave;
+
+	/* t = KDF(x2 || y2, inlen) */
+	x2y2 = sm2_ecc_ec2os(x2, y2, ec->p, &len);
+	/* skip the prefix '0x04' */
+	kdf_x9_63(x2y2 + 1, len - 1, plain, inlen);
+
+	/* plain = C2 xor t */
+	for (i = 0; i < inlen; i++)
+		plain[i] ^= in[i];
+
+	/* Hash(x2 || IN || y2) == C3 */
+	do {
+		SHASH_DESC_ON_STACK(desc, NULL);
+		unsigned char dgst[SM3_DIGEST_SIZE];
+
+		sm3_base_init(desc);
+		crypto_sm3_update(desc, x2y2 + 1, MPI_NBYTES(x2));
+		crypto_sm3_update(desc, plain, inlen);
+		crypto_sm3_finup(desc, x2y2 + 1 + MPI_NBYTES(x2),
+				MPI_NBYTES(y2), dgst);
+
+		rc = -EINVAL;
+		hash = mpi_get_buffer(c3, &len, NULL);
+		if (len != sizeof(dgst) || memcmp(dgst, hash, len) != 0)
+			goto leave;
+	} while (0);
+
+	rc = -ENOMEM;
+	*m = mpi_read_raw_data(plain, inlen);
+	if (*m == NULL)
+		goto leave;
+
+	rc = 0;
+
+leave:
+	kfree(hash);
+	kfree(x2y2);
+	if (plain) {
+		memset(plain, 0, inlen);
+		kfree(plain);
+	}
+	kfree(in);
+
+	mpi_point_free_parts(&point_c1);
+	mpi_point_free_parts(&kP);
+	mpi_free(x2);
+	mpi_free(y2);
+
+	return rc;
+}
+
+static int _sm2_sign(struct mpi_ec_ctx *ec, MPI hash, MPI *r, MPI *s)
+{
+	int rc = -EINVAL;
+	struct gcry_mpi_point kG;
+	MPI sig_r = NULL;
+	MPI sig_s = NULL;
+	MPI tmp = NULL;
+	MPI k = NULL;
+	MPI rk = NULL;
+	MPI x1 = NULL;
+
+	mpi_point_init(&kG);
+	x1 = mpi_new(0);
+	sig_r = mpi_new(0);
+	sig_s = mpi_new(0);
+	rk = mpi_new(0);
+	tmp = mpi_new(0);
+
+	for (;;) {
+		/* rand k in [1, n-1] */
+		k = sm2_gen_k(ec->n);
+		if (k == NULL)
+			goto leave;
+
+		/* [k]G = (x1, y1) */
+		mpi_ec_mul_point(&kG, k, ec->G, ec);
+		if (mpi_ec_get_affine(x1, NULL, &kG, ec))
+			goto leave;
+
+		/* r = (e + x1) % n */
+		mpi_addm(sig_r, hash, x1, ec->n);
+
+		/* r != 0 && r + k != n */
+		if (mpi_cmp_ui(sig_r, 0) == 0)
+			continue;
+		mpi_add(rk, sig_r, k);
+		if (mpi_cmp(rk, ec->n) == 0)
+			continue;
+
+		/* s = ((d + 1)^-1 * (k - rd)) % n */
+		mpi_addm(sig_s, ec->d, mpi_const(MPI_C_ONE), ec->n);
+		mpi_invm(sig_s, sig_s, ec->n);
+		mpi_mulm(tmp, sig_r, ec->d, ec->n);
+		mpi_subm(tmp, k, tmp, ec->n);
+		mpi_mulm(sig_s, sig_s, tmp, ec->n);
+
+		break;
+	}
+
+	*r = sig_r;
+	*s = sig_s;
+	rc = 0;
+
+leave:
+	if (rc) {
+		mpi_free(sig_r);
+		mpi_free(sig_s);
+	}
+	mpi_point_free_parts(&kG);
+	mpi_free(x1);
+	mpi_free(k);
+	mpi_free(rk);
+	mpi_free(tmp);
+
+	return rc;
+}
+
+static int _sm2_verify(struct mpi_ec_ctx *ec, MPI hash, MPI sig_r, MPI sig_s)
+{
+	int rc = -EINVAL;
+	struct gcry_mpi_point sG, tP;
+	MPI t = NULL;
+	MPI x1 = NULL, y1 = NULL;
+
+	mpi_point_init(&sG);
+	mpi_point_init(&tP);
+	x1 = mpi_new(0);
+	y1 = mpi_new(0);
+	t = mpi_new(0);
+
+	/* r, s in [1, n-1] */
+	if (mpi_cmp_ui(sig_r, 1) < 0 || mpi_cmp(sig_r, ec->n) > 0 ||
+		mpi_cmp_ui(sig_s, 1) < 0 || mpi_cmp(sig_s, ec->n) > 0) {
+		goto leave;
+	}
+
+	/* t = (r + s) % n, t == 0 */
+	mpi_addm(t, sig_r, sig_s, ec->n);
+	if (mpi_cmp_ui(t, 0) == 0)
+		goto leave;
+
+	/* sG + tP = (x1, y1) */
+	rc = -EBADMSG;
+	mpi_ec_mul_point(&sG, sig_s, ec->G, ec);
+	mpi_ec_mul_point(&tP, t, ec->Q, ec);
+	mpi_ec_add_points(&sG, &sG, &tP, ec);
+	if (mpi_ec_get_affine(x1, y1, &sG, ec))
+		goto leave;
+
+	/* R = (e + x1) % n */
+	mpi_addm(t, hash, x1, ec->n);
+
+	/* check R == r */
+	rc = -EKEYREJECTED;
+	if (mpi_cmp(t, sig_r))
+		goto leave;
+
+	rc = 0;
+
+leave:
+	mpi_point_free_parts(&sG);
+	mpi_point_free_parts(&tP);
+	mpi_free(x1);
+	mpi_free(y1);
+	mpi_free(t);
+
+	return rc;
+}
+
+static int sm2_enc(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	MPI m, c;
+	MPI c1 = NULL, c3 = NULL, c2 = NULL;
+	int ret = 0;
+	int sign;
+
+	if (unlikely(!ec->Q))
+		return -EINVAL;
+
+	m = mpi_read_raw_from_sgl(req->src, req->src_len);
+	if (!m)
+		return -ENOMEM;
+
+	ret = _sm2_enc(ec, m, &c1, &c3, &c2);
+	if (ret)
+		goto err_free_m;
+
+	ret = -EFAULT;
+	c = sm2_cipher_encode(c1, c3, c2);
+	if (!c)
+		goto err_free_c;
+
+	ret = mpi_write_to_sgl(c, req->dst, req->dst_len, &sign);
+	if (ret)
+		goto err_free_cipher;
+
+	if (sign < 0)
+		ret = -EBADMSG;
+
+err_free_cipher:
+	mpi_free(c);
+err_free_c:
+	mpi_free(c1);
+	mpi_free(c3);
+	mpi_free(c2);
+err_free_m:
+	mpi_free(m);
+	return ret;
+}
+
+static int sm2_dec(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	MPI m, c;
+	MPI c1 = NULL, c3 = NULL, c2 = NULL;
+	int ret = 0;
+	int sign;
+
+	if (unlikely(!ec->d))
+		return -EINVAL;
+
+	c = mpi_read_raw_from_sgl(req->src, req->src_len);
+	if (!c)
+		return -ENOMEM;
+
+	ret = sm2_cipher_decode(c, &c1, &c3, &c2);
+	if (ret)
+		goto err_free_cipher;
+
+	ret = _sm2_dec(ec, c1, c3, c2, &m);
+	if (ret)
+		goto err_free_c;
+
+	ret = mpi_write_to_sgl(m, req->dst, req->dst_len, &sign);
+	if (ret)
+		goto err_free_m;
+
+	if (sign < 0)
+		ret = -EBADMSG;
+
+err_free_m:
+	mpi_free(m);
+err_free_c:
+	mpi_free(c1);
+	mpi_free(c3);
+	mpi_free(c2);
+err_free_cipher:
+	mpi_free(c);
+	return ret;
+}
+
+static int sm2_sign(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	MPI hash, c;
+	MPI r = NULL, s = NULL;
+	int ret = 0;
+	int sign;
+
+	if (unlikely(!ec->d))
+		return -EINVAL;
+
+	hash = mpi_read_raw_from_sgl(req->src, req->src_len);
+	if (!hash)
+		return -ENOMEM;
+
+	ret = _sm2_sign(ec, hash, &r, &s);
+	if (ret)
+		goto err_free_hash;
+
+	ret = -EFAULT;
+	c = sm2_signature_encode(hash, r, s);
+	if (!c)
+		goto err_free_r;
+
+	ret = mpi_write_to_sgl(c, req->dst, req->dst_len, &sign);
+	if (ret)
+		goto err_free_c;
+
+	if (sign < 0)
+		ret = -EBADMSG;
+
+err_free_c:
+	mpi_free(c);
+err_free_r:
+	mpi_free(r);
+	mpi_free(s);
+err_free_hash:
+	mpi_free(hash);
+	return ret;
+}
+
+static int sm2_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	unsigned char *buffer;
+	struct sm2_signature_ctx sig;
+	MPI hash;
+	int ret;
+
+	if (unlikely(!ec->Q))
+		return -EINVAL;
+
+	buffer = kmalloc(req->src_len + req->dst_len, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	sg_pcopy_to_buffer(req->src,
+			sg_nents_for_len(req->src, req->src_len + req->dst_len),
+			buffer, req->src_len + req->dst_len, 0);
+
+	sig.sig_r = NULL;
+	sig.sig_s = NULL;
+	ret = asn1_ber_decoder(&sm2signature_decoder, &sig, buffer, req->src_len);
+	if (ret)
+		goto error;
+
+	ret = -ENOMEM;
+	hash = mpi_read_raw_data(buffer + req->src_len, req->dst_len);
+	if (!hash)
+		goto error;
+
+	ret = _sm2_verify(ec, hash, sig.sig_r, sig.sig_s);
+
+	mpi_free(hash);
+error:
+	mpi_free(sig.sig_r);
+	mpi_free(sig.sig_s);
+	kfree(buffer);
+	return ret;
+}
+
+static int sm2_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+						unsigned int keylen)
+{
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	MPI a;
+	int rc;
+
+	rc = sm2_ec_ctx_reset(ec);
+	if (rc)
+		return rc;
+
+	ec->Q = mpi_point_new(0);
+	if (!ec->Q)
+		return -ENOMEM;
+
+	/* include the uncompressed flag '0x04' */
+	rc = -ENOMEM;
+	a = mpi_read_raw_data(key, keylen);
+	if (!a)
+		goto error;
+
+	mpi_normalize(a);
+	rc = sm2_ecc_os2ec(ec->Q, a);
+	mpi_free(a);
+	if (rc)
+		goto error;
+
+	return 0;
+
+error:
+	mpi_point_release(ec->Q);
+	ec->Q = NULL;
+	return rc;
+}
+
+static int sm2_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+						unsigned int keylen)
+{
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+	int rc;
+
+	rc = sm2_ec_ctx_reset(ec);
+	if (rc)
+		return rc;
+
+	ec->d = mpi_read_raw_data(key, keylen);
+	if (!ec->d)
+		return -ENOMEM;
+
+	/* compute pubkey if it not exist */
+	if (!ec->Q) {
+		ec->Q = mpi_point_new(0);
+		if (!ec->Q)
+			return -ENOMEM;
+		mpi_ec_mul_point(ec->Q, ec->d, ec->G, ec);
+	}
+
+	return 0;
+}
+
+static unsigned int sm2_max_size(struct crypto_akcipher *tfm)
+{
+	/* Unlimited max size */
+	return PAGE_SIZE;
+}
+
+static void sm2_exit_tfm(struct crypto_akcipher *tfm)
+{
+	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
+
+	mpi_ec_deinit(ec);
+}
+
+static struct akcipher_alg sm2 = {
+	.encrypt = sm2_enc,
+	.decrypt = sm2_dec,
+	.sign = sm2_sign,
+	.verify = sm2_verify,
+	.set_priv_key = sm2_set_priv_key,
+	.set_pub_key = sm2_set_pub_key,
+	.max_size = sm2_max_size,
+	.exit = sm2_exit_tfm,
+	.base = {
+		.cra_name = "sm2",
+		.cra_driver_name = "sm2-generic",
+		.cra_priority = 100,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct mpi_ec_ctx),
+	},
+};
+
+static int sm2_init(void)
+{
+	return crypto_register_akcipher(&sm2);
+}
+
+static void sm2_exit(void)
+{
+	crypto_unregister_akcipher(&sm2);
+}
+
+subsys_initcall(sm2_init);
+module_exit(sm2_exit);
+
+MODULE_ALIAS_CRYPTO("sm2");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SM2 generic algorithm");
diff --git a/crypto/sm2signature.asn1 b/crypto/sm2signature.asn1
new file mode 100644
index 000000000000..ab8c0b754d21
--- /dev/null
+++ b/crypto/sm2signature.asn1
@@ -0,0 +1,4 @@
+Sm2Signature ::= SEQUENCE {
+	sig_r	INTEGER ({ sm2_get_signature_r }),
+	sig_s	INTEGER ({ sm2_get_signature_s })
+}
diff --git a/include/crypto/sm2.h b/include/crypto/sm2.h
new file mode 100644
index 000000000000..af452556dcd4
--- /dev/null
+++ b/include/crypto/sm2.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * sm2.h - SM2 asymmetric public-key algorithm
+ * as specified by OSCCA GM/T 0003.1-2012 -- 0003.5-2012 SM2 and
+ * described at https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
+ *
+ * Copyright (c) 2020, Alibaba Group.
+ * Written by Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+#ifndef _CRYPTO_SM2_H
+#define _CRYPTO_SM2_H
+
+#include <crypto/sm3.h>
+#include <crypto/akcipher.h>
+
+/* The default user id as specified in GM/T 0009-2012 */
+#define SM2_DEFAULT_USERID "1234567812345678"
+#define SM2_DEFAULT_USERID_LEN 16
+
+extern int sm2_compute_z_digest(struct crypto_akcipher *tfm,
+			const unsigned char *id, size_t id_len,
+			unsigned char dgst[SM3_DIGEST_SIZE]);
+
+#endif /* _CRYPTO_SM2_H */
-- 
2.17.1


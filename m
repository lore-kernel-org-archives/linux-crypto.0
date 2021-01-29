Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6379DC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9F464E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhA2V1a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbhA2V1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 16:27:19 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD33DC0613D6
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:38 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 19so10211863qkh.3
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PbpAVMxLXOUnyRcmPHfMFHESAeL4Z3hLTQ92fdHFQqk=;
        b=rsE9JKIi+Ga6yA8hR36U55d/z1RzozbkpAvh6pS/d6v/AvAYixNA/VrslJQ1KMdcHN
         ETnPoqPBAO1XINkDnj3dCHow1kbt9otggxLGiLWYLPNU/pP/nkXcWgTi8wEPzW1x+eMp
         sLdSlGuiBa0M5xDU5vnncSHWFIytiAYezLe3GAmrB9v2MCAbn1lujzYMceerrQvhM4Nx
         5tds7tfbP2hemhM8fTKWpTVwx/GzprEnlf5v6T0cQeC+hfbNWpu1o2HIUaV+oI67TNgD
         oLLJn2RyTJ0x5+kgV3Wpx7ZjkddIIRC6q6TYsFGf7zsQxqLNN01croY3ljm/q/vcIC43
         D2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PbpAVMxLXOUnyRcmPHfMFHESAeL4Z3hLTQ92fdHFQqk=;
        b=nbTpwMmrnPoAV6DoNw4yyl2Zre7bio+W/pNHkr6MMPsMBEHaF1y+sSc5V/KfvoysnZ
         uQ4unzuMcal3mC1uNd8xeT1z3jkI8+96EPlwleqnlk6YIKhlrHwagArMh9Dgq7pgzCd8
         NLQiPH+WGEwOvpFRJxX8EAtc3vj1QDI33lrKCPiipubabj10lQQK1+vEDvefFY4znFl2
         JIrGqi/1uZVECGUJy1X2adDKWFt2D2ib49n8rGHpnN3oBdoik9slpR2TRJdh3ib8ViO6
         EbaTdIGnw30h6yFbopWC6TBLGclM+0X/CVhz3BWfPPTgrxbKP02sYlSoRjHb31cowkvA
         Dz4w==
X-Gm-Message-State: AOAM533y1JvlZb/6S/bxgvkJ4MOmJeElKQUeuH7iSK4VP7+rVDCSuWm9
        aY7V0Cbfb2PoM0KH2hN0lX1hZ7WvvQ0C42F2
X-Google-Smtp-Source: ABdhPJwe/kwOkymmxWvKq3I+ofo7uISWP9cloAkOSf3gUFj9Choy5ylDJbMBnwAUydMf3SzrLW3wjw==
X-Received: by 2002:a37:64c2:: with SMTP id y185mr6150370qkb.55.1611955597365;
        Fri, 29 Jan 2021 13:26:37 -0800 (PST)
Received: from warrior-desktop.domains. ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id b194sm6763995qkc.102.2021.01.29.13.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:26:36 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH v2 4/4] ecdsa: implements ecdsa signature verification
Date:   Fri, 29 Jan 2021 18:25:35 -0300
Message-Id: <20210129212535.2257493-5-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

* Documentation/admin-guide/module-signing.rst
  - Documents how to generate certificate and signature for (ECDSA).

* crypto/Kconfig
  - ECDSA added into kernel Public-key cryptography section.

* crypto/Makefile
   - add ECDSA objects and asn1 params to compile.

* crypto/ecdsa.c
  - Elliptical Curve DSA verify implementation

* crypto/ecdsa_params.asn1
  - Elliptical Curve DSA verify definitions

* crypto/ecdsa_signature.asn1
  - Elliptical Curve DSA asn.1 parameters

* crypto/testmgr.c
  - test_akcipher_one - modified to reflect the real code call for nist code;
  - alg_test_descs - added ecdsa vector for test;

* crypto/testmgr.h
  - ecdsa_tv_template - added to test ecdsa implementation;
---
 Documentation/admin-guide/module-signing.rst |  10 +
 crypto/Kconfig                               |  12 +
 crypto/Makefile                              |   7 +
 crypto/ecdsa.c                               | 509 +++++++++++++++++++
 crypto/ecdsa_params.asn1                     |   1 +
 crypto/ecdsa_signature.asn1                  |   6 +
 crypto/testmgr.c                             |  17 +-
 crypto/testmgr.h                             |  78 +++
 8 files changed, 638 insertions(+), 2 deletions(-)
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsa_params.asn1
 create mode 100644 crypto/ecdsa_signature.asn1

diff --git a/Documentation/admin-guide/module-signing.rst b/Documentation/admin-guide/module-signing.rst
index 7d7c7c8a545c..00ee487de84d 100644
--- a/Documentation/admin-guide/module-signing.rst
+++ b/Documentation/admin-guide/module-signing.rst
@@ -174,6 +174,16 @@ The full pathname for the resulting kernel_key.pem file can then be specified
 in the ``CONFIG_MODULE_SIG_KEY`` option, and the certificate and key therein will
 be used instead of an autogenerated keypair.
 
+It is also possible use the key private/public files using the ecdsa
+alghorithm that is more fast than rsa. For this, configure ``CONFIG_CRYPTO_ECDSA``
+and for generate key and certificate use the openssl commands.
+
+	openssl ecparam -gnenkey <prime256v1|secp384r1|secp521r1> \
+    	-name -noout -out kernel_key.pem
+	openssl req -new -key kernel_key.pem -x509 -nodes -days 36500 -out kernel_key.x509
+
+To sign with ecdsa use the same way or manually using scripts/sign-file.
+
 
 =========================
 Public keys in the kernel
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9779c7f7531f..79bec162d9dd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -224,6 +224,18 @@ config CRYPTO_RSA
 	help
 	  Generic implementation of the RSA public key algorithm.
 
+config CRYPTO_ECDSA
+    tristate "ECDSA algorithm"
+    select CRYPTO_AKCIPHER
+    select CRYPTO_MANAGER
+    select MPILIB
+    select ASN1
+    help
+      Generic implementation of the ECDSA eliptical curve public key algorithm.
+	  FIPS 186-3, Digital Signature Standard using Mathematical routines for
+	  the NIST prime elliptic curves April 05, 2010. Compatible with openssl
+	  command line tools.
+
 config CRYPTO_DH
 	tristate "Diffie-Hellman algorithm"
 	select CRYPTO_KPP
diff --git a/crypto/Makefile b/crypto/Makefile
index cf23affb1678..0e0b33106c82 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -176,6 +176,13 @@ ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
 
+$(obj)/ecdsa_signature.asn1.o: $(obj)/ecdsa_signature.asn1.c $(obj)/ecdsa_signature.asn1.h
+$(obj)/ecdsa_params.asn1.o: $(obj)/ecdsa_params.asn1.c $(obj)/ecdsa_params.asn1.h
+clean-files += ecdsa_signature.asn1.c ecdsa_signature.asn1.h
+clean-files += ecdsa_params.asn1.c ecdsa_params.asn1.h
+ecdsa_generic-y := ecdsa_signature.asn1.o ecdsa_params.asn1.o ecdsa.o
+obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
+
 $(obj)/ecrdsa_params.asn1.o: $(obj)/ecrdsa_params.asn1.c $(obj)/ecrdsa_params.asn1.h
 $(obj)/ecrdsa_pub_key.asn1.o: $(obj)/ecrdsa_pub_key.asn1.c $(obj)/ecrdsa_pub_key.asn1.h
 $(obj)/ecrdsa.o: $(obj)/ecrdsa_params.asn1.h $(obj)/ecrdsa_pub_key.asn1.h
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
new file mode 100644
index 000000000000..f33258c21db2
--- /dev/null
+++ b/crypto/ecdsa.c
@@ -0,0 +1,509 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Elliptic Curve Digital Signature Algorithm for Cryptographic API
+ *
+ * Copyright (c) 2019 Saulo Alessandre <saulo.alessandre@gmail.com>
+ *
+ * References:
+ * Mathematical routines for the NIST prime elliptic curves April 05, 2010
+ * Technical Guideline TR-03111 - Elliptic Curve Cryptography
+ * FIPS 186-3, Digital Signature Standard
+ *
+ * this code is strongly embased on the ecrdsa code, written by
+ *  Vitaly Chikunov <vt@altlinux.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include "crypto/public_key.h"
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/oid_registry.h>
+#include <asm/unaligned.h>
+#include "ecc.h"
+#include "ecc_curve_defs.h"
+#include "ecdsa_signature.asn1.h"
+#include "ecdsa_params.asn1.h"
+
+#define MAX_DIGEST_SIZE		64
+
+#define ECDSA_MAX_BITS     521
+#define ECDSA_MAX_SIG_SIZE 140
+#define ECDSA_MAX_DIGITS   9
+
+struct ecdsa_ctx {
+	enum OID algo_oid;	/* overall public key oid */
+	enum OID curve_oid;	/* parameter */
+	enum OID digest_oid;	/* parameter */
+	const struct ecc_curve *curve;	/* curve from oid */
+	unsigned int digest_len;	/* parameter (bytes) */
+	const char *digest;	/* digest name from oid */
+	unsigned int key_len;	/* @key length (bytes) */
+	const char *key;	/* raw public key */
+	struct ecc_point pub_key;
+	u64 _pubp[2][ECDSA_MAX_DIGITS];	/* point storage for @pub_key */
+};
+
+struct ecdsa_sig_ctx {
+	u64 r[ECDSA_MAX_DIGITS];
+	u64 s[ECDSA_MAX_DIGITS];
+	int sig_size;
+	u8 ndigits;
+};
+
+static int check_digest_len(int len)
+{
+	switch (len) {
+	case 32:
+	case 48:
+	case 64:
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+static inline void ecc_swap_digits(const u64 *in, u64 *out,
+				   unsigned int ndigits)
+{
+	const __be64 *src = (__force __be64 *) in;
+	int i;
+
+	for (i = 0; i < ndigits; i++)
+		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
+}
+
+static int ecdsa_parse_sig_rs(struct ecdsa_sig_ctx *ctx, u64 *rs,
+			      size_t hdrlen, unsigned char tag,
+			      const void *value, size_t vlen)
+{
+	u8 ndigits;
+	// skip byte 0 if exists
+	const void *idx = value;
+
+	if (*(u8 *) idx == 0x0) {
+		idx++;
+		vlen--;
+	}
+	ndigits = vlen / 8;
+	if (ndigits == ctx->ndigits)
+		ecc_swap_digits((const u64 *)idx, rs, ndigits);
+	else {
+		u8 nvalue[ECDSA_MAX_SIG_SIZE];
+		const u8 start = (ctx->ndigits * 8) - vlen;
+
+		memset(nvalue, 0, start);
+		memcpy(nvalue + start, idx, vlen);
+		ecc_swap_digits((const u64 *)nvalue, rs, ctx->ndigits);
+		vlen = ctx->ndigits * 8;
+	}
+	ctx->sig_size += vlen;
+	return 0;
+}
+
+int ecdsa_parse_sig_r(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_sig_ctx *ctx = context;
+
+	return ecdsa_parse_sig_rs(ctx, ctx->r, hdrlen, tag, value, vlen);
+}
+
+int ecdsa_parse_sig_s(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_sig_ctx *ctx = context;
+
+	return ecdsa_parse_sig_rs(ctx, ctx->s, hdrlen, tag, value, vlen);
+}
+
+#define ASN_TAG_SIZE	5
+
+static int ecdsa_verify(struct akcipher_request *req, enum OID oid)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct ecdsa_sig_ctx ctx_sig;
+	u8 sig[ECDSA_MAX_SIG_SIZE];
+	u8 digest[MAX_DIGEST_SIZE];
+	u16 ndigits = ctx->pub_key.ndigits;
+	u16 min_digits;
+	u64 _r[ECDSA_MAX_DIGITS];	/* ecc_point x */
+	u64 _s[ECDSA_MAX_DIGITS];	/* ecc_point y and temp s^{-1} */
+	u64 e[ECDSA_MAX_DIGITS];	/* h \mod q */
+	u64 v[ECDSA_MAX_DIGITS];	/* s^{-1}e \mod q */
+	u64 u[ECDSA_MAX_DIGITS];	/* s^{-1}r \mod q */
+	struct ecc_point cc = ECC_POINT_INIT(_r, _s, ndigits);	/* reuse r, s */
+	struct scatterlist *sgl_s, *sgl_d;
+	int err;
+	int i;
+
+	if (lookup_oid_digest_info(oid, &ctx->digest, &ctx->digest_len,
+				   &ctx->digest_oid))
+		return -ENOPKG;
+
+	min_digits =
+	    (ndigits < ctx->digest_len / 8) ? ndigits : ctx->digest_len / 8;
+
+	if (!ctx->curve || !ctx->digest || !req->src || !ctx->pub_key.x)
+		return -EBADMSG;
+	if (check_digest_len(req->dst_len)) {
+		pr_err("%s: invalid source digest size %d\n",
+				__func__, req->dst_len);
+		return -EBADMSG;
+	}
+	if (check_digest_len(ctx->digest_len)) {
+		pr_err("%s: invalid context digest size %d\n",
+				__func__, ctx->digest_len);
+		return -EBADMSG;
+	}
+
+	sgl_s = req->src;
+	sgl_d = (((void *)req->src) + sizeof(struct scatterlist));
+
+	if (ctx->pub_key.ndigits != ctx->curve->g.ndigits ||
+	    WARN_ON(sgl_s->length > sizeof(sig)) ||
+	    WARN_ON(sgl_d->length > sizeof(digest))) {
+		pr_err("%s: invalid curve size g(%d) pub(%d)\n",
+				__func__,
+		       ctx->curve->g.ndigits, ctx->pub_key.ndigits);
+		return -EBADMSG;
+	}
+	sg_copy_to_buffer(sgl_s, sg_nents_for_len(sgl_s, sgl_s->length),
+			  sig, sizeof(sig));
+	sg_copy_to_buffer(sgl_d, sg_nents_for_len(sgl_d, sgl_d->length),
+			  digest, sizeof(digest));
+
+	ctx_sig.sig_size = 0;
+	ctx_sig.ndigits = ndigits;
+	err =
+	    asn1_ber_decoder(&ecdsa_signature_decoder, &ctx_sig, sig,
+			     sgl_s->length);
+	if (err < 0)
+		return err;
+
+	/* Step 1: verify that 0 < r < q, 0 < s < q */
+	if (vli_is_zero(ctx_sig.r, ndigits) ||
+	    vli_cmp(ctx_sig.r, ctx->curve->n, ndigits) == 1 ||
+	    vli_is_zero(ctx_sig.s, ndigits) ||
+	    vli_cmp(ctx_sig.s, ctx->curve->n, ndigits) == 1)
+		return -EKEYREJECTED;
+
+	/* need truncate digest */
+	for (i = min_digits; i < ndigits; i++)
+		e[i] = 0;
+	/* Step 2: calculate hash (h) of the message (passed as input) */
+	/* Step 3: calculate e = h \mod q */
+	vli_from_be64(e, digest, min_digits);
+	if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+		vli_sub(e, e, ctx->curve->n, ndigits);
+	if (vli_is_zero(e, ndigits))
+		e[0] = 1;
+
+	/* Step 4: calculate _s = s^{-1} \mod q */
+	vli_mod_inv(_s, ctx_sig.s, ctx->curve->n, ndigits);
+	/* Step 5: calculate u = s^{-1} * e \mod q */
+	vli_mod_mult_slow(u, _s, e, ctx->curve->n, ndigits);
+	/* Step 6: calculate v = s^{-1} * r \mod q */
+	vli_mod_mult_slow(v, _s, ctx_sig.r, ctx->curve->n, ndigits);
+	/* Step 7: calculate cc = (x0, y0) = uG + vP */
+	ecc_point_mult_shamir(&cc, u, &ctx->curve->g, v, &ctx->pub_key,
+			      ctx->curve);
+	/* v = x0 mod q */
+	vli_mod_slow(v, cc.x, ctx->curve->n, ndigits);
+
+	/* Step 9: if X0 == r signature is valid */
+	if (vli_cmp(v, ctx_sig.r, ndigits) == 0)
+		return 0;
+
+	return -EKEYREJECTED;
+}
+
+static int ecdsa_verify_256(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha256);
+}
+
+static int ecdsa_verify_384(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha384);
+}
+
+static int ecdsa_verify_512(struct akcipher_request *req)
+{
+	return ecdsa_verify(req, OID_id_ecdsa_with_sha512);
+}
+
+static const struct ecc_curve *get_curve_by_oid(enum OID oid)
+{
+	switch (oid) {
+	case OID_id_secp192r1:
+		return &nist_p192;
+	case OID_id_secp256r1:
+		return &nist_p256;
+	case OID_id_secp384r1:
+		return &nist_p384;
+	case OID_id_secp521r1:
+		return &nist_p521;
+	default:
+		return NULL;
+	}
+}
+
+int ecdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+
+	ctx->curve_oid = look_up_OID(value, vlen);
+	if (!ctx->curve_oid)
+		return -EINVAL;
+	ctx->curve = get_curve_by_oid(ctx->curve_oid);
+
+	return 0;
+}
+
+/* Optional. If present should match expected digest algo OID. */
+int ecdsa_param_digest(void *context, size_t hdrlen, unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+	int digest_oid = look_up_OID(value, vlen);
+
+	if (digest_oid != ctx->digest_oid)
+		return -EINVAL;
+
+	return 0;
+}
+
+int ecdsa_parse_pub_key(void *context, size_t hdrlen, unsigned char tag,
+			const void *value, size_t vlen)
+{
+	struct ecdsa_ctx *ctx = context;
+
+	ctx->key = value;
+	ctx->key_len = vlen;
+	return 0;
+}
+
+static u8 *pkey_unpack_u32(u32 *dst, void *src)
+{
+	memcpy(dst, src, sizeof(*dst));
+	return src + sizeof(*dst);
+}
+
+static inline void copy4be8(u64 *out, const u8 *in, u32 size)
+{
+	int i;
+	u8 *dst = (u8 *) out;
+
+	*out = 0;
+	for (i = 0; i < size; i++) {
+		*dst = in[size - i - 1];
+		dst++;
+	}
+}
+
+static void convert4be(u64 *out, const u8 *in, u32 size)
+{
+	int i;
+
+	while (*in == 0 && size > 0) {
+		in++;
+		size--;
+	}
+	in = in + size;
+	/* convert from BE */
+	for (i = 0; i < size; i += 8) {
+		const u32 count = size - i;
+		const u32 limit = count >= 8 ? 8 : count;
+		const u8 *part = in - limit;
+
+		if (limit == 8)
+			*out = get_unaligned_be64(part);
+		else
+			copy4be8(out, part, limit);
+		out++;
+		in -= limit;
+	}
+}
+
+/* Parse BER encoded subjectPublicKey. */
+static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+			     unsigned int keylen)
+{
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	unsigned int ndigits;
+	u32 algo, paramlen;
+	u8 *params;
+	int err;
+	const u8 nist_type = *(u8 *) key;
+	u8 half_pub;
+
+	/* Key parameters is in the key after keylen. */
+	params = (u8 *) key + keylen;
+	params = pkey_unpack_u32(&algo, params);
+	params = pkey_unpack_u32(&paramlen, params);
+
+	ctx->algo_oid = algo;
+
+	/* Parse SubjectPublicKeyInfo.AlgorithmIdentifier.parameters. */
+	err = asn1_ber_decoder(&ecdsa_params_decoder, ctx, params, paramlen);
+	if (err < 0)
+		return err;
+	ctx->key = key;
+	ctx->key_len = keylen;
+	if (!ctx->curve)
+		return -ENOPKG;
+
+	/*
+	 * Accepts only uncompressed it's not accepted
+	 */
+	if (nist_type != NIST_UNPACKED_KEY_ID)
+		return -ENOPKG;
+	/* Skip nist type octet */
+	ctx->key++;
+	ctx->key_len--;
+	if (ctx->key_len != NISTP256_PACKED_KEY_SIZE
+	    && ctx->key_len != NISTP384_PACKED_KEY_SIZE
+	    && ctx->key_len != NISTP521_PACKED_KEY_SIZE)
+		return -ENOPKG;
+	ndigits = ctx->key_len / sizeof(u64) / 2;
+	if (ndigits * 2 * sizeof(u64) < ctx->key_len)
+		ndigits++;
+	half_pub = ctx->key_len / 2;
+	/*
+	 * Sizes of key_len and curve should match each other.
+	 */
+	if (ctx->curve->g.ndigits != ndigits)
+		return -ENOPKG;
+	ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
+	/*
+	 * X509 stores key.x and key.y as BE
+	 */
+	if (ndigits != 9) {
+		vli_from_be64(ctx->pub_key.x, ctx->key, ndigits);
+		vli_from_be64(ctx->pub_key.y, ctx->key + half_pub, ndigits);
+	} else {
+		convert4be(ctx->pub_key.x, ctx->key, half_pub);
+		convert4be(ctx->pub_key.y, ctx->key + half_pub, half_pub);
+	}
+	err = ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key);
+	if (err)
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+static unsigned int ecdsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct ecdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	/*
+	 * Verify doesn't need any output, so it's just informational
+	 * for keyctl to determine the key bit size.
+	 */
+	return ctx->pub_key.ndigits * sizeof(u64);
+}
+
+static void ecdsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+}
+
+//static const struct s_ecdsa_template {
+//    const char  *name;
+//    enum OID    oid;
+//    size_t      size;
+//    int (*ecdsa_verify)(struct akcipher_request *req);
+//} ecdsa_templates[] = {
+//    {"ecdsa(sha256)", OID_id_ecdsa_with_sha256, ecdsa_verify},
+//    {"ecdsa(sha384)", OID_id_ecdsa_with_sha384, ecdsa_verify},
+//    {"ecdsa(sha512)", OID_id_ecdsa_with_sha512, ecdsa_verify},
+//    NULL
+//};
+
+static struct akcipher_alg ecdsa_alg256 = {
+	.verify = ecdsa_verify_256,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha256)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static struct akcipher_alg ecdsa_alg384 = {
+	.verify = ecdsa_verify_384,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha384)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static struct akcipher_alg ecdsa_alg512 = {
+	.verify = ecdsa_verify_512,
+	.set_pub_key = ecdsa_set_pub_key,
+	.max_size = ecdsa_max_size,
+	.exit = ecdsa_exit_tfm,
+	.base = {
+		 .cra_name = "ecdsa(sha512)",
+		 .cra_driver_name = "ecdsa-generic",
+		 .cra_priority = 100,
+		 .cra_module = THIS_MODULE,
+		 .cra_ctxsize = sizeof(struct ecdsa_ctx),
+		 },
+};
+
+static int __init ecdsa_mod_init(void)
+{
+	int result;
+
+	result = crypto_register_akcipher(&ecdsa_alg256);
+	if (result)
+		goto out256;
+	result = crypto_register_akcipher(&ecdsa_alg384);
+	if (result)
+		goto out384;
+	result = crypto_register_akcipher(&ecdsa_alg512);
+	if (result)
+		goto out512;
+	return 0;
+
+out512:
+	crypto_unregister_akcipher(&ecdsa_alg384);
+out384:
+	crypto_unregister_akcipher(&ecdsa_alg256);
+out256:
+	return result;
+}
+
+static void __exit ecdsa_mod_fini(void)
+{
+	crypto_unregister_akcipher(&ecdsa_alg256);
+	crypto_unregister_akcipher(&ecdsa_alg384);
+	crypto_unregister_akcipher(&ecdsa_alg512);
+}
+
+subsys_initcall(ecdsa_mod_init);
+module_exit(ecdsa_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Saulo Alessandre <saulo.alessandre@gmail.com>");
+MODULE_DESCRIPTION("EC-DSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecdsa-generic");
diff --git a/crypto/ecdsa_params.asn1 b/crypto/ecdsa_params.asn1
new file mode 100644
index 000000000000..f683aec27bd4
--- /dev/null
+++ b/crypto/ecdsa_params.asn1
@@ -0,0 +1 @@
+EcdsaCurve ::=  OBJECT IDENTIFIER ({ ecdsa_param_curve })
diff --git a/crypto/ecdsa_signature.asn1 b/crypto/ecdsa_signature.asn1
new file mode 100644
index 000000000000..378e73913865
--- /dev/null
+++ b/crypto/ecdsa_signature.asn1
@@ -0,0 +1,6 @@
+EcdsaSignature ::= SEQUENCE {
+    signatureR  INTEGER ({ ecdsa_parse_sig_r }),
+    signatureS  INTEGER ({ ecdsa_parse_sig_s })
+}
+
+EcdsaPubKey ::= BIT STRING ({ ecdsa_parse_pub_key })
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1a4103b1b202..3e8a6cf084de 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3992,8 +3992,15 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	memcpy(xbuf[0], m, m_size);
 
 	sg_init_table(src_tab, 3);
-	sg_set_buf(&src_tab[0], xbuf[0], 8);
-	sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
+	if (vecs->algo == OID_id_ecdsa_with_sha256 ||
+		vecs->algo == OID_id_ecdsa_with_sha384 ||
+		vecs->algo == OID_id_ecdsa_with_sha512) {
+		sg_set_buf(&src_tab[0], xbuf[0], m_size);
+		sg_set_buf(&src_tab[1], xbuf[1], c_size);
+	} else {
+		sg_set_buf(&src_tab[0], xbuf[0], 8);
+		sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
+	}
 	if (vecs->siggen_sigver_test) {
 		if (WARN_ON(c_size > PAGE_SIZE))
 			goto free_all;
@@ -4916,6 +4923,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.kpp = __VECS(ecdh_tv_template)
 		}
+	}, {
+		.alg = "ecdsa",
+		.test = alg_test_akcipher,
+		.suite = {
+			.akcipher = __VECS(ecdsa_tv_template)
+		}
 	}, {
 		.alg = "ecrdsa",
 		.test = alg_test_akcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 99aca08263d2..ad31d8deb3d7 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -566,6 +566,84 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 	}
 };
 
+/*
+ * EC-DSA test vectors
+ */
+static const struct akcipher_testvec ecdsa_tv_template[] = {
+	{
+	.key =
+	"\x04\x9c\x9e\x45\xe5\x61\xf4\x3d\xf8\x8f\xea\xdf\xce\x9a\xd5\x2a"
+	"\x9e\x7e\x8a\x0a\xef\xff\xad\x9c\x2e\x87\x8e\xa0\xa9\x40\x0a\x3d"
+	"\x7f\x01\x85\x8d\xd6\x36\xcf\x84\x56\x59\xb8\xd8\x3d\x20\x78\xe7"
+	"\xaf\x35\xa8\xeb\x89\x37\x0e\x52\xa7\x71\x81\x2f\x64\xbb\x1d\x6c"
+	"\x04",
+	.key_len = 65,
+	/*
+	 * m is SHA256 hash of following message:
+	 * "\x49\x41\xbe\x0a\x0c\xc9\xf6\x35\x51\xe4\x27\x56\x13\x71\x4b\xd0"
+	 * "\x36\x92\x84\x89\x1b\xf8\x56\x4a\x72\x61\x14\x69\x4f\x5e\x98\xa5"
+	 * "\x80\x5a\x37\x51\x1f\xd8\xf5\xb5\x63\xfc\xf4\xb1\xbb\x4d\x33\xa3"
+	 * "\x1e\xb9\x75\x8b\x9c\xda\x7e\x6d\x3a\x77\x85\xf7\xfc\x4e\xe7\x64"
+	 * "\x43\x10\x19\xa0\x59\xae\xe0\xad\x4b\xd3\xc4\x45\xf7\xb1\xc2\xc1"
+	 * "\x65\x01\x41\x39\x5b\x45\x47\xed\x2b\x51\xed\xe3\xd0\x09\x10\xd2"
+	 * "\x39\x6c\x4a\x3f\xe5\xd2\x20\xe6\xb0\x71\x7d\x5b\xed\x26\x60\xf1"
+	 * "\xb4\x73\xd1\xdb\x7d\xc4\x19\x91\xee\xf6\x32\x76\xf2\x19\x7d\xb7"
+	 */
+	.m =
+	"\x3e\xc8\xa1\x26\x20\x54\x44\x52\x48\x0d\xe5\x66\xf3\xb3\xf5\x04"
+	"\xbe\x10\xa8\x48\x94\x22\x2d\xdd\xba\x7a\xb4\x76\x8d\x79\x98\x89",
+	.m_size = 32,
+	.params = /* ecdsaWithSHA512 */
+	//"\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x04",
+	"\x06\x08\x2A\x86\x48\xCE\x3D\x03\x01\x07",
+	.param_len = 10,
+	.c =
+	"\x30\x44\x02\x20\x2b\xf7\x53\x42\xc2\x80\x52\xca\x9f\x54\x5e\x52"
+	"\xe2\x46\xa4\x83\xf4\x00\x59\x1e\x88\xd4\x7a\x88\x96\xb7\xee\xc7"
+	"\xbf\x2c\x1e\xd0\x02\x20\x46\x58\x95\x5f\x39\x75\x35\xaa\x73\x7d"
+	"\xe3\x87\x18\xad\x6d\x60\xd0\xc3\xb7\x21\x10\xeb\x77\x7b\x5a\xd4"
+	"\x52\x05\xc0\xfe\xa8\x46",
+	.c_size = 70,
+	.algo = OID_id_ecdsa_with_sha256,
+	.public_key_vec = true,
+	.siggen_sigver_test = true,
+	},
+	{
+	.key =
+	"\x04\xee\x89\x69\x41\xa0\x10\xfe\x56\xbc\x50\x37\x6d\xa1\xfe"
+	"\x89\xa6\x34\xaf\x0a\x97\x7c\x7a\x5c\x13\x5f\xea\x5f\x36\x07"
+	"\x82\xd4\x4b\x09\x97\xd4\xf9\x91\xb9\x0e\x06\xd4\x3d\xd3\x87"
+	"\xc3\x1b\x00\x93\xc8\x0f\x8a\x45\xa9\xb7\x3d\xa0\xbf\xe3\xb3"
+	"\x0f\x9a\xf0\xbd\x70\x62\x16\x40\xc3\x83\x56\x25\xc3\x0f\x85"
+	"\xa2\xd3\x88\x89\xbd\x5b\x92\x27\x3f\x95\x77\xd0\xc1\x49\x07"
+	"\xe2\xa5\xd7\xb2\x5b\xba\xea",
+	.key_len = 97,
+	/*
+	 * m is SHA256 hash of same previous message:
+	 * "\x49\x41\xbe\x0a ...                         \xf2\x19\x7d\xb7"
+	 */
+	.m =
+	"\x3e\xc8\xa1\x26\x20\x54\x44\x52\x48\x0d\xe5\x66\xf3\xb3\xf5\x04"
+	"\xbe\x10\xa8\x48\x94\x22\x2d\xdd\xba\x7a\xb4\x76\x8d\x79\x98\x89",
+	.m_size = 32,
+	.params = /* ecdsaWithSHA512 */
+	"\x06\x05\x2B\x81\x04\x00\x22",
+	.param_len = 7,
+	.c =
+	"\x30\x64\x02\x30\x4f\xd3\xe8\x98\xcb\x6b\x82\x4b\x41\x2d\x3b\x85"
+	"\xde\x07\x19\xc4\x64\x2b\xd9\x80\x00\x50\xa8\x79\x48\x07\x75\xb6"
+	"\x56\x66\xb9\x89\x0b\xab\x89\x18\x4c\xe9\x21\x38\x4e\xe0\x70\x9d"
+	"\x80\x76\x8a\x2b\x02\x30\x5f\x01\xc5\x0b\x6e\x72\x42\x2e\x79\xee"
+	"\x42\x15\xe0\x16\xf5\x38\x90\x49\x44\x7f\xca\x29\xdf\x0d\xce\x5b"
+	"\xeb\x7f\xef\x2a\x51\xef\x52\x6e\x14\xa6\x25\xe5\xfb\x7b\x66\xea"
+	"\x07\x3f\x4c\x17\xd0\xfc",
+	.c_size = 102,
+	.algo = OID_id_ecdsa_with_sha256,
+	.public_key_vec = true,
+	.siggen_sigver_test = true,
+	},
+};
+
 /*
  * EC-RDSA test vectors are generated by gost-engine.
  */
-- 
2.25.1


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614FDC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4538F60ED4
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhJLCVM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhJLCU6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 22:20:58 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B55C06174E;
        Mon, 11 Oct 2021 19:18:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so12436702pga.3;
        Mon, 11 Oct 2021 19:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ul/I1Cv/qN9k0aQ3SH414rvxumAgT59Tf+3CEqrv/IY=;
        b=i77TBbwxwPnOGSNrcs80xWIrwdMFPdDLTzTW5yfKIJA5U0usqxKuSsJZ6PpXKdTOlp
         jwmOYA0/0YoUHAgZbIU+6K0Jen04/fZ9vGRwaXAWBopF4zdfdAwq5dn/N7nU+vjDjBiZ
         J1OXppwBkpwWl+AlNy32McgvggDrhNUrtipmvya//+7k6aQ58IhGUR8Z2PFtdHE0hCyc
         Wemyd5uruuI+/ErVuujRtDV2v/3XfNTuP3mJgOoR0tiXDwOlvAxKkeyWMhLEdm5R2uNK
         fW3OikX2eKZCUQpE5diF3SrVIVgBlEry/syxtZZUIG/ayw0xdQHVdxfLP3eKGFlpiUj2
         L6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ul/I1Cv/qN9k0aQ3SH414rvxumAgT59Tf+3CEqrv/IY=;
        b=om45zr2rqvVn86GsssXhdBpWs68F8VSotd16HZCu4UZV/xndi6DcFDf5Xbv+nxX/L4
         X4478iQwsVQOfjv676/sRYu4lEFTjRlBuHq0caa+73mJvwZaU+v4ExqjRqFYkI0ZJle3
         kENaM/Zu2sslzFHGken5ewNDS1GPBpPOlr7tS/zVoFLPCJi3UP7LiuHqIeUzEI5wk7Bh
         jn7UfJEO82fZrRAkOxzdvpHnLhVdkmSHB4ZI10s6fh5I9RJVOLcRadUbFG606o8jblQN
         S/OE1L5QXCiPBQo1vWeKLixDh8bo3dtjsB3754vEUa8kjxpy+fgwEKCTeceHuyUbY3VO
         6B1Q==
X-Gm-Message-State: AOAM530ZsnriDakRuBxEbaNHQu0F3MK2RfWAc6vvbBW8S2AkmeB+iEyh
        jZIgO1+pdzE6k9i/5ns+j2G5HE0oO/g=
X-Google-Smtp-Source: ABdhPJyLI3/axtFXiTR2m75z6yB7PUTh4+4opgurke7DpnaogrTE/7Hf74FnMwLItfq/nCwrMIpIsQ==
X-Received: by 2002:a63:3483:: with SMTP id b125mr6051691pga.79.1634005135850;
        Mon, 11 Oct 2021 19:18:55 -0700 (PDT)
Received: from localhost.localdomain ([162.14.23.249])
        by smtp.gmail.com with ESMTPSA id l207sm8963835pfd.199.2021.10.11.19.18.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:18:55 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] crypto: move common code in sm2 to ec_mpi.c and ec_mpi.h
Date:   Tue, 12 Oct 2021 10:17:54 +0800
Message-Id: <1634005076-17534-4-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
References: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

Some structs and functions in sm2 are common codes, and could be
used by the following eddsa patch. So move them to common files:
ec_mpi.c and ec_mpi.h.

Signed-off-by: Hongbo Li <herberthbli@tencent.com>
---
 crypto/Kconfig  |  4 +++
 crypto/Makefile |  1 +
 crypto/ec_mpi.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 crypto/ec_mpi.h | 37 ++++++++++++++++++++++
 crypto/sm2.c    | 98 ++-------------------------------------------------------
 5 files changed, 127 insertions(+), 95 deletions(-)
 create mode 100644 crypto/ec_mpi.c
 create mode 100644 crypto/ec_mpi.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 285f826..f684513 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -265,6 +265,9 @@ config CRYPTO_ECRDSA
 	  standard algorithms (called GOST algorithms). Only signature verification
 	  is implemented.
 
+config CRYPTO_EC_MPI
+	tristate
+
 config CRYPTO_SM2
 	tristate "SM2 algorithm"
 	select CRYPTO_SM3
@@ -272,6 +275,7 @@ config CRYPTO_SM2
 	select CRYPTO_MANAGER
 	select MPILIB
 	select ASN1
+	select CRYPTO_EC_MPI
 	help
 	  Generic implementation of the SM2 public key algorithm. It was
 	  published by State Encryption Management Bureau, China.
diff --git a/crypto/Makefile b/crypto/Makefile
index c633f15..837aa1d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -176,6 +176,7 @@ obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
+obj-$(CONFIG_CRYPTO_EC_MPI) += ec_mpi.o
 
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
diff --git a/crypto/ec_mpi.c b/crypto/ec_mpi.c
new file mode 100644
index 0000000..a537e6f
--- /dev/null
+++ b/crypto/ec_mpi.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * EC MPI common functions.
+ *
+ * Copyright (c) 2020, Alibaba Group.
+ * Authors: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+#include <linux/module.h>
+#include <linux/mpi.h>
+#include "ec_mpi.h"
+
+int ec_mpi_ctx_init(struct mpi_ec_ctx *ec, const struct ecc_domain_parms *ecp)
+{
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
+	rc = -ENOMEM;
+
+	ec->Q = mpi_point_new(0);
+	if (!ec->Q)
+		goto free;
+
+	/* mpi_ec_setup_elliptic_curve */
+	ec->G = mpi_point_new(0);
+	if (!ec->G) {
+		mpi_point_release(ec->Q);
+		goto free;
+	}
+
+	mpi_set(ec->G->x, x);
+	mpi_set(ec->G->y, y);
+	mpi_set_ui(ec->G->z, 1);
+
+	rc = -EINVAL;
+	ec->n = mpi_scanval(ecp->n);
+	if (!ec->n) {
+		mpi_point_release(ec->Q);
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
+EXPORT_SYMBOL(ec_mpi_ctx_init);
+
+void ec_mpi_ctx_deinit(struct mpi_ec_ctx *ec)
+{
+	mpi_ec_deinit(ec);
+
+	memset(ec, 0, sizeof(*ec));
+}
+EXPORT_SYMBOL(ec_mpi_ctx_deinit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tianjia Zhang <tianjia.zhang@linux.alibaba.com>");
diff --git a/crypto/ec_mpi.h b/crypto/ec_mpi.h
new file mode 100644
index 0000000..e1f6d3aa
--- /dev/null
+++ b/crypto/ec_mpi.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * EC MPI common structs.
+ *
+ * Copyright (c) 2020, Alibaba Group.
+ * Authors: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+#include <linux/mpi.h>
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
+int ec_mpi_ctx_init(struct mpi_ec_ctx *ec, const struct ecc_domain_parms *ecp);
+void ec_mpi_ctx_deinit(struct mpi_ec_ctx *ec);
diff --git a/crypto/sm2.c b/crypto/sm2.c
index db8a4a2..ea1676b 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -9,42 +9,17 @@
  */
 
 #include <linux/module.h>
-#include <linux/mpi.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
 #include <crypto/hash.h>
 #include <crypto/sm3_base.h>
 #include <crypto/rng.h>
 #include <crypto/sm2.h>
+#include "ec_mpi.h"
 #include "sm2signature.asn1.h"
 
 #define MPI_NBYTES(m)   ((mpi_get_nbits(m) + 7) / 8)
 
-struct ecc_domain_parms {
-	const char *desc;           /* Description of the curve.  */
-	unsigned int nbits;         /* Number of bits.  */
-	unsigned int fips:1; /* True if this is a FIPS140-2 approved curve */
-
-	/* The model describing this curve.  This is mainly used to select
-	 * the group equation.
-	 */
-	enum gcry_mpi_ec_models model;
-
-	/* The actual ECC dialect used.  This is used for curve specific
-	 * optimizations and to select encodings etc.
-	 */
-	enum ecc_dialects dialect;
-
-	const char *p;              /* The prime defining the field.  */
-	const char *a, *b;          /* The coefficients.  For Twisted Edwards
-				     * Curves b is used for d.  For Montgomery
-				     * Curves (a,b) has ((A-2)/4,B^-1).
-				     */
-	const char *n;              /* The order of the base point.  */
-	const char *g_x, *g_y;      /* Base point.  */
-	unsigned int h;             /* Cofactor.  */
-};
-
 static const struct ecc_domain_parms sm2_ecp = {
 	.desc = "sm2p256v1",
 	.nbits = 256,
@@ -60,73 +35,6 @@ struct ecc_domain_parms {
 	.h = 1
 };
 
-static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
-{
-	const struct ecc_domain_parms *ecp = &sm2_ecp;
-	MPI p, a, b;
-	MPI x, y;
-	int rc = -EINVAL;
-
-	p = mpi_scanval(ecp->p);
-	a = mpi_scanval(ecp->a);
-	b = mpi_scanval(ecp->b);
-	if (!p || !a || !b)
-		goto free_p;
-
-	x = mpi_scanval(ecp->g_x);
-	y = mpi_scanval(ecp->g_y);
-	if (!x || !y)
-		goto free;
-
-	rc = -ENOMEM;
-
-	ec->Q = mpi_point_new(0);
-	if (!ec->Q)
-		goto free;
-
-	/* mpi_ec_setup_elliptic_curve */
-	ec->G = mpi_point_new(0);
-	if (!ec->G) {
-		mpi_point_release(ec->Q);
-		goto free;
-	}
-
-	mpi_set(ec->G->x, x);
-	mpi_set(ec->G->y, y);
-	mpi_set_ui(ec->G->z, 1);
-
-	rc = -EINVAL;
-	ec->n = mpi_scanval(ecp->n);
-	if (!ec->n) {
-		mpi_point_release(ec->Q);
-		mpi_point_release(ec->G);
-		goto free;
-	}
-
-	ec->h = ecp->h;
-	ec->name = ecp->desc;
-	mpi_ec_init(ec, ecp->model, ecp->dialect, 0, p, a, b);
-
-	rc = 0;
-
-free:
-	mpi_free(x);
-	mpi_free(y);
-free_p:
-	mpi_free(p);
-	mpi_free(a);
-	mpi_free(b);
-
-	return rc;
-}
-
-static void sm2_ec_ctx_deinit(struct mpi_ec_ctx *ec)
-{
-	mpi_ec_deinit(ec);
-
-	memset(ec, 0, sizeof(*ec));
-}
-
 /* RESULT must have been initialized and is set on success to the
  * point given by VALUE.
  */
@@ -416,14 +324,14 @@ static int sm2_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
 
-	return sm2_ec_ctx_init(ec);
+	return ec_mpi_ctx_init(ec, &sm2_ecp);
 }
 
 static void sm2_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct mpi_ec_ctx *ec = akcipher_tfm_ctx(tfm);
 
-	sm2_ec_ctx_deinit(ec);
+	ec_mpi_ctx_deinit(ec);
 }
 
 static struct akcipher_alg sm2 = {
-- 
1.8.3.1


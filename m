Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7B9C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE8D22482
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="bPD14wkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgGTRMh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:12:37 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:9714 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729706AbgGTRMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 13:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595265155;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=5FxSgX+j6PW/y15KfJnFHhRa+DbvAUFEG2W3eFq4B80=;
        b=bPD14wkrG216UR102JwyZCuUsHhm3oGJw045cIKY8sLVwmTYf/EMLgnGcgGPMsFhoC
        GhbRyAlXv0qhovvw6eR3lNX3dwHyJ7hasesbD1N/YxRFQUWNctW0EWpCN6eSpfPA7woz
        G3QJJrxPT05QgdJxSV55ql38wn+EBNRrN3bCJzjHrYGkyLy5n6mx/K4nlEBg+EwChcox
        kpQLK+kt+A/39A7UHt/I1NS2o9zmVYPn2wTX7EHqsNA+DDW/HYoFrL9/kIEkyNHkfecu
        eIwI2snymh7C3hwUN/oIXKP+XRZTw4Xls14yvPPioDbmBcU9yC4ru8t8+GGHOKBzVLRy
        KoTA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHiDh"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6KH9pULJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 20 Jul 2020 19:09:51 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v3 5/5] crypto: ECDH SP800-56A rev 3 local public key validation
Date:   Mon, 20 Jul 2020 19:09:23 +0200
Message-ID: <2112806.iZASKD2KPV@positron.chronox.de>
In-Reply-To: <2544426.mvXUDI8C0e@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de> <2544426.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After the generation of a local public key, SP800-56A rev 3 section
5.6.2.1.3 mandates a validation of that key with a full validation
compliant to section 5.6.2.3.3.

Only if the full validation passes, the key is allowed to be used.

The patch adds the full key validation compliant to 5.6.2.3.3 and
performs the required check on the generated public key.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ecc.c | 31 ++++++++++++++++++++++++++++++-
 crypto/ecc.h | 14 ++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 52e2d49262f2..7308487e7c55 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1404,7 +1404,9 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 	}
 
 	ecc_point_mult(pk, &curve->g, priv, NULL, curve, ndigits);
-	if (ecc_point_is_zero(pk)) {
+
+	/* SP800-56A rev 3 5.6.2.1.3 key check */
+	if (ecc_is_pubkey_valid_full(curve, pk)) {
 		ret = -EAGAIN;
 		goto err_free_point;
 	}
@@ -1452,6 +1454,33 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 }
 EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
 
+/* SP800-56A section 5.6.2.3.3 full verification */
+int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
+			     struct ecc_point *pk)
+{
+	struct ecc_point *nQ;
+
+	/* Checks 1 through 3 */
+	int ret = ecc_is_pubkey_valid_partial(curve, pk);
+
+	if (ret)
+		return ret;
+
+	/* Check 4: Verify that nQ is the zero point. */
+	nQ = ecc_alloc_point(pk->ndigits);
+	if (!nQ)
+		return -ENOMEM;
+
+	ecc_point_mult(nQ, pk, curve->n, NULL, curve, pk->ndigits);
+	if (!ecc_point_is_zero(nQ))
+		ret = -EINVAL;
+
+	ecc_free_point(nQ);
+
+	return ret;
+}
+EXPORT_SYMBOL(ecc_is_pubkey_valid_full);
+
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
 			      u64 *secret)
diff --git a/crypto/ecc.h b/crypto/ecc.h
index ab0eb70b9c09..d4e546b9ad79 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -147,6 +147,20 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 				struct ecc_point *pk);
 
+/**
+ * ecc_is_pubkey_valid_full() - Full public key validation
+ *
+ * @curve:		elliptic curve domain parameters
+ * @pk:			public key as a point
+ *
+ * Valdiate public key according to SP800-56A section 5.6.2.3.3 ECC Full
+ * Public-Key Validation Routine.
+ *
+ * Return: 0 if validation is successful, -EINVAL if validation is failed.
+ */
+int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
+			     struct ecc_point *pk);
+
 /**
  * vli_is_zero() - Determine is vli is zero
  *
-- 
2.26.2





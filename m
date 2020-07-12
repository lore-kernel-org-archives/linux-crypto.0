Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2756C4346E
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE21D206B6
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Xc65V+mr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgGLQn2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 12:43:28 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:10761 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbgGLQn1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 12:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594572205;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=5FxSgX+j6PW/y15KfJnFHhRa+DbvAUFEG2W3eFq4B80=;
        b=Xc65V+mrJpCx1qrpz8+i5KkZdN19OmnY7wRdjF7w/gvD/7xAiYRCZQBm+PThIebxka
        kQxORzqffXwHHTe9cFrQfQsQgyRVY+WnDPruBih3yM2GAfhkUa1DSapUVhqbxRJgUmKy
        5E1ErLBPuQOEZn/Vx43+R0ilLpi++ZlLBvoOzZ5FEERmylnHR1MPEHIlJBp+w5uHb9Kr
        mGXjSowlb5bUff7dFzaHOCDzX8YpuNb6na6ji/sxtEFO/VHQGVUmiJNPEEUkfO1tUy/4
        g1OdT6zzhmRhmhyPASyZd4C4+4CN5EshiW6KAcLYz/Fkmb2ugN0eyI+FrqeYE+dbSwTh
        gNzw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6CGgJieD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 12 Jul 2020 18:42:19 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key validation
Date:   Sun, 12 Jul 2020 18:42:14 +0200
Message-ID: <3168469.44csPzL39Z@positron.chronox.de>
In-Reply-To: <5722559.lOV4Wx5bFT@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
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





Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954A5C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FBCF27739
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540777;
	bh=pjSNR5X41mpDszanLzLqqmQy0W//PwYWGRKDzC9PV7k=;
	h=From:To:Subject:Date:List-ID:From;
	b=r2J6KCl3BCD6MR2hwgSoIcTSNWdgx7YdOj821aqUP6OhmRRjUECDOT8xINKKk7huM
	 Ujb3lab2geEH6isgnJmGfhafJkvoGCq9kbBMrNFi9IME42L3UcWrbiCP5Bql4JciWA
	 /HlbKQV+WV6gEoBxnbo+C9c+7tn4/z7JoXNWHh7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfFCFqR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFqQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:46:16 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91DEE27739
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540775;
        bh=pjSNR5X41mpDszanLzLqqmQy0W//PwYWGRKDzC9PV7k=;
        h=From:To:Subject:Date:From;
        b=mzdI9UvsOPWEUVKk9a4g2vEBAiac4lX6/oo7V0XVZSD/jL/gvSMAGaufs9lUwu20g
         MzY/KJY40qUo3IvAFXQgK8nRwC1chCi8Bo1vQOBJZmBt/TWced1VyMZjKV4FFXgBEd
         E+nSL8PAtmB0CJuEcpsXCQAYuECXVTA80/96N92Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: skcipher - make chunksize and walksize accessors internal
Date:   Sun,  2 Jun 2019 22:46:11 -0700
Message-Id: <20190603054611.6257-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The 'chunksize' and 'walksize' properties of skcipher algorithms are
implementation details that users of the skcipher API should not be
looking at.  So move their accessor functions from <crypto/skcipher.h>
to <crypto/internal/skcipher.h>.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/skcipher.h | 60 ++++++++++++++++++++++++++++++
 include/crypto/skcipher.h          | 60 ------------------------------
 2 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 9de6032209cb1..abb1096495c2f 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -205,6 +205,66 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
 	return alg->max_keysize;
 }
 
+static inline unsigned int crypto_skcipher_alg_chunksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->chunksize;
+}
+
+static inline unsigned int crypto_skcipher_alg_walksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->walksize;
+}
+
+/**
+ * crypto_skcipher_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CTR.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_skcipher_chunksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
+}
+
+/**
+ * crypto_skcipher_walksize() - obtain walk size
+ * @tfm: cipher handle
+ *
+ * In some cases, algorithms can only perform optimally when operating on
+ * multiple blocks in parallel. This is reflected by the walksize, which
+ * must be a multiple of the chunksize (or equal if the concern does not
+ * apply)
+ *
+ * Return: walk size in bytes
+ */
+static inline unsigned int crypto_skcipher_walksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
+}
+
 /* Helpers for simple block cipher modes of operation */
 struct skcipher_ctx_simple {
 	struct crypto_cipher *cipher;	/* underlying block cipher */
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 98547d1f18c53..694397fb0faab 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -293,66 +293,6 @@ static inline unsigned int crypto_sync_skcipher_ivsize(
 	return crypto_skcipher_ivsize(&tfm->base);
 }
 
-static inline unsigned int crypto_skcipher_alg_chunksize(
-	struct skcipher_alg *alg)
-{
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
-	if (alg->base.cra_ablkcipher.encrypt)
-		return alg->base.cra_blocksize;
-
-	return alg->chunksize;
-}
-
-static inline unsigned int crypto_skcipher_alg_walksize(
-	struct skcipher_alg *alg)
-{
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
-	if (alg->base.cra_ablkcipher.encrypt)
-		return alg->base.cra_blocksize;
-
-	return alg->walksize;
-}
-
-/**
- * crypto_skcipher_chunksize() - obtain chunk size
- * @tfm: cipher handle
- *
- * The block size is set to one for ciphers such as CTR.  However,
- * you still need to provide incremental updates in multiples of
- * the underlying block size as the IV does not have sub-block
- * granularity.  This is known in this API as the chunk size.
- *
- * Return: chunk size in bytes
- */
-static inline unsigned int crypto_skcipher_chunksize(
-	struct crypto_skcipher *tfm)
-{
-	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
-}
-
-/**
- * crypto_skcipher_walksize() - obtain walk size
- * @tfm: cipher handle
- *
- * In some cases, algorithms can only perform optimally when operating on
- * multiple blocks in parallel. This is reflected by the walksize, which
- * must be a multiple of the chunksize (or equal if the concern does not
- * apply)
- *
- * Return: walk size in bytes
- */
-static inline unsigned int crypto_skcipher_walksize(
-	struct crypto_skcipher *tfm)
-{
-	return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
-}
-
 /**
  * crypto_skcipher_blocksize() - obtain block size of cipher
  * @tfm: cipher handle
-- 
2.21.0


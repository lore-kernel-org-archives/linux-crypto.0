Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4FEC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7CA20792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgG1HSm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54726 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgG1HSm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsl-0006Ho-Gf; Tue, 28 Jul 2020 17:18:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:39 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:39 +1000
Subject: [v3 PATCH 1/31] crypto: skcipher - Add final chunk size field for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto skcipher algorithms in general allow chaining to break
large operations into smaller ones based on multiples of the chunk
size.  However, some algorithms don't support chaining while others
(such as cts) only support chaining for the leading blocks.

This patch adds the necessary API support for these algorithms.  In
particular, a new request flag CRYPTO_TFM_REQ_MORE is added to allow
chaining for algorithms such as cts that cannot otherwise be chained.

A new algorithm attribute final_chunksize has also been added to
indicate how many blocks at the end of a request that cannot be
chained and therefore must be withheld if chaining is attempted.

This attribute can also be used to indicate that no chaining is
allowed.  Its value should be set to -1 in that case.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/skcipher.h |   24 ++++++++++++++++++++++++
 include/linux/crypto.h    |    1 +
 2 files changed, 25 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 5663f71198b37..fb90c3e1c26ba 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -97,6 +97,9 @@ struct crypto_sync_skcipher {
  * @walksize: Equal to the chunk size except in cases where the algorithm is
  * 	      considerably more efficient if it can operate on multiple chunks
  * 	      in parallel. Should be a multiple of chunksize.
+ * @final_chunksize: Number of bytes that must be processed together
+ *		     at the end.  If set to -1 then chaining is not
+ *		     possible.
  * @base: Definition of a generic crypto algorithm.
  *
  * All fields except @ivsize are mandatory and must be filled.
@@ -114,6 +117,7 @@ struct skcipher_alg {
 	unsigned int ivsize;
 	unsigned int chunksize;
 	unsigned int walksize;
+	int final_chunksize;
 
 	struct crypto_alg base;
 };
@@ -279,6 +283,11 @@ static inline unsigned int crypto_skcipher_alg_chunksize(
 	return alg->chunksize;
 }
 
+static inline int crypto_skcipher_alg_final_chunksize(struct skcipher_alg *alg)
+{
+	return alg->final_chunksize;
+}
+
 /**
  * crypto_skcipher_chunksize() - obtain chunk size
  * @tfm: cipher handle
@@ -296,6 +305,21 @@ static inline unsigned int crypto_skcipher_chunksize(
 	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
 }
 
+/**
+ * crypto_skcipher_final_chunksize() - obtain number of final bytes
+ * @tfm: cipher handle
+ *
+ * For algorithms such as CTS the final chunks cannot be chained.
+ * This returns the number of final bytes that must be withheld
+ * when chaining.
+ *
+ * Return: number of final bytes
+ */
+static inline int crypto_skcipher_final_chunksize(struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_final_chunksize(crypto_skcipher_alg(tfm));
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ef90e07c9635c..2e624a1d4f832 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -141,6 +141,7 @@
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_MORE		0x00000800
 
 /*
  * Miscellaneous stuff.

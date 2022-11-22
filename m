Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C19C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiKVKDv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiKVKDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:03:46 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E922D2E6A8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:03:37 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxQ7r-00H43z-96; Tue, 22 Nov 2022 18:03:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 18:03:35 +0800
Date:   Tue, 22 Nov 2022 18:03:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: akcipher - Move reqsize into tfm
Message-ID: <Y3yed+w9F3Nmr9pi@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize cannot be determined in case of fallbacks.
Therefore it must be stored in the tfm and not the alg object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 5764b46bd1ec..734c213918bd 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -43,9 +43,12 @@ struct akcipher_request {
  * struct crypto_akcipher - user-instantiated objects which encapsulate
  * algorithms and core processing logic
  *
+ * @reqsize:	Request context size required by algorithm implementation
  * @base:	Common crypto API algorithm data structure
  */
 struct crypto_akcipher {
+	unsigned int reqsize;
+
 	struct crypto_tfm base;
 };
 
@@ -86,7 +89,6 @@ struct crypto_akcipher {
  *		counterpart to @init, used to remove various changes set in
  *		@init.
  *
- * @reqsize:	Request context size required by algorithm implementation
  * @base:	Common crypto API algorithm data structure
  */
 struct akcipher_alg {
@@ -102,7 +104,6 @@ struct akcipher_alg {
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
 
-	unsigned int reqsize;
 	struct crypto_alg base;
 };
 
@@ -155,7 +156,7 @@ static inline struct akcipher_alg *crypto_akcipher_alg(
 
 static inline unsigned int crypto_akcipher_reqsize(struct crypto_akcipher *tfm)
 {
-	return crypto_akcipher_alg(tfm)->reqsize;
+	return tfm->reqsize;
 }
 
 static inline void akcipher_request_set_tfm(struct akcipher_request *req,
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 8d3220c9ab77..1474a2d890fc 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -36,7 +36,7 @@ static inline void *akcipher_request_ctx(struct akcipher_request *req)
 static inline void akcipher_set_reqsize(struct crypto_akcipher *akcipher,
 					unsigned int reqsize)
 {
-	crypto_akcipher_alg(akcipher)->reqsize = reqsize;
+	akcipher->reqsize = reqsize;
 }
 
 static inline void *akcipher_tfm_ctx(struct crypto_akcipher *tfm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

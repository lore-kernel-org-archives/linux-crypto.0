Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2E3C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiKVKJV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKVKJU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:09:20 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747A013D15
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:09:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxQDM-00H4Im-Pq; Tue, 22 Nov 2022 18:09:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 18:09:16 +0800
Date:   Tue, 22 Nov 2022 18:09:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: kpp - Move reqsize into tfm
Message-ID: <Y3yfzP28tjLlT2rl@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize cannot be determined in case of fallbacks.
Therefore it must be stored in the tfm and not the alg object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/internal/kpp.h b/include/crypto/internal/kpp.h
index 31ff3c1986ef..167662407e36 100644
--- a/include/crypto/internal/kpp.h
+++ b/include/crypto/internal/kpp.h
@@ -53,7 +53,7 @@ static inline void *kpp_request_ctx(struct kpp_request *req)
 static inline void kpp_set_reqsize(struct crypto_kpp *kpp,
 				   unsigned int reqsize)
 {
-	crypto_kpp_alg(kpp)->reqsize = reqsize;
+	kpp->reqsize = reqsize;
 }
 
 static inline void *kpp_tfm_ctx(struct crypto_kpp *tfm)
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 24d01e9877c1..33ff32878802 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -37,9 +37,13 @@ struct kpp_request {
  * struct crypto_kpp - user-instantiated object which encapsulate
  * algorithms and core processing logic
  *
+ * @reqsize:		Request context size required by algorithm
+ *			implementation
  * @base:	Common crypto API algorithm data structure
  */
 struct crypto_kpp {
+	unsigned int reqsize;
+
 	struct crypto_tfm base;
 };
 
@@ -64,8 +68,6 @@ struct crypto_kpp {
  *			put in place here.
  * @exit:		Undo everything @init did.
  *
- * @reqsize:		Request context size required by algorithm
- *			implementation
  * @base:		Common crypto API algorithm data structure
  */
 struct kpp_alg {
@@ -79,7 +81,6 @@ struct kpp_alg {
 	int (*init)(struct crypto_kpp *tfm);
 	void (*exit)(struct crypto_kpp *tfm);
 
-	unsigned int reqsize;
 	struct crypto_alg base;
 };
 
@@ -128,7 +129,7 @@ static inline struct kpp_alg *crypto_kpp_alg(struct crypto_kpp *tfm)
 
 static inline unsigned int crypto_kpp_reqsize(struct crypto_kpp *tfm)
 {
-	return crypto_kpp_alg(tfm)->reqsize;
+	return tfm->reqsize;
 }
 
 static inline void kpp_request_set_tfm(struct kpp_request *req,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

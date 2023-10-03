Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26835E776F4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjJCDpL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjJCDo5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:44:57 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDB8DA
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:44:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnWL2-002wUd-BJ; Tue, 03 Oct 2023 11:44:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:44:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/16] crypto: skcipher - Remove obsolete skcipher_alg helpers
Date:   Tue,  3 Oct 2023 11:43:33 +0800
Message-Id: <20231003034333.1441826-17-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
References: <20231003034333.1441826-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As skcipher spawn users can no longer assume the spawn is of type
struct skcipher_alg, these helpers are no longer used.  Remove them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/skcipher.h | 42 ------------------------------
 include/crypto/skcipher.h          | 25 +-----------------
 2 files changed, 1 insertion(+), 66 deletions(-)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index c767b5cfbd9c..7ae42afdcf3e 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -148,12 +148,6 @@ static inline void crypto_drop_lskcipher(struct crypto_lskcipher_spawn *spawn)
 	crypto_drop_spawn(&spawn->base);
 }
 
-static inline struct skcipher_alg *crypto_skcipher_spawn_alg(
-	struct crypto_skcipher_spawn *spawn)
-{
-	return container_of(spawn->base.alg, struct skcipher_alg, base);
-}
-
 static inline struct lskcipher_alg *crypto_lskcipher_spawn_alg(
 	struct crypto_lskcipher_spawn *spawn)
 {
@@ -166,12 +160,6 @@ static inline struct skcipher_alg_common *crypto_spawn_skcipher_alg_common(
 	return container_of(spawn->base.alg, struct skcipher_alg_common, base);
 }
 
-static inline struct skcipher_alg *crypto_spawn_skcipher_alg(
-	struct crypto_skcipher_spawn *spawn)
-{
-	return crypto_skcipher_spawn_alg(spawn);
-}
-
 static inline struct lskcipher_alg *crypto_spawn_lskcipher_alg(
 	struct crypto_lskcipher_spawn *spawn)
 {
@@ -269,36 +257,6 @@ static inline u32 skcipher_request_flags(struct skcipher_request *req)
 	return req->base.flags;
 }
 
-static inline unsigned int crypto_skcipher_alg_min_keysize(
-	struct skcipher_alg *alg)
-{
-	return alg->min_keysize;
-}
-
-static inline unsigned int crypto_skcipher_alg_max_keysize(
-	struct skcipher_alg *alg)
-{
-	return alg->max_keysize;
-}
-
-static inline unsigned int crypto_skcipher_alg_walksize(
-	struct skcipher_alg *alg)
-{
-	return alg->walksize;
-}
-
-static inline unsigned int crypto_lskcipher_alg_min_keysize(
-	struct lskcipher_alg *alg)
-{
-	return alg->co.min_keysize;
-}
-
-static inline unsigned int crypto_lskcipher_alg_max_keysize(
-	struct lskcipher_alg *alg)
-{
-	return alg->co.max_keysize;
-}
-
 /* Helpers for simple block cipher modes of operation */
 struct skcipher_ctx_simple {
 	struct crypto_cipher *cipher;	/* underlying block cipher */
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index a648ef5ce897..ea18af48346b 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -395,17 +395,6 @@ static inline struct lskcipher_alg *crypto_lskcipher_alg(
 			    struct lskcipher_alg, co.base);
 }
 
-static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
-{
-	return alg->ivsize;
-}
-
-static inline unsigned int crypto_lskcipher_alg_ivsize(
-	struct lskcipher_alg *alg)
-{
-	return alg->co.ivsize;
-}
-
 /**
  * crypto_skcipher_ivsize() - obtain IV size
  * @tfm: cipher handle
@@ -473,18 +462,6 @@ static inline unsigned int crypto_lskcipher_blocksize(
 	return crypto_tfm_alg_blocksize(crypto_lskcipher_tfm(tfm));
 }
 
-static inline unsigned int crypto_skcipher_alg_chunksize(
-	struct skcipher_alg *alg)
-{
-	return alg->chunksize;
-}
-
-static inline unsigned int crypto_lskcipher_alg_chunksize(
-	struct lskcipher_alg *alg)
-{
-	return alg->co.chunksize;
-}
-
 /**
  * crypto_skcipher_chunksize() - obtain chunk size
  * @tfm: cipher handle
@@ -516,7 +493,7 @@ static inline unsigned int crypto_skcipher_chunksize(
 static inline unsigned int crypto_lskcipher_chunksize(
 	struct crypto_lskcipher *tfm)
 {
-	return crypto_lskcipher_alg_chunksize(crypto_lskcipher_alg(tfm));
+	return crypto_lskcipher_alg(tfm)->co.chunksize;
 }
 
 static inline unsigned int crypto_sync_skcipher_blocksize(
-- 
2.39.2


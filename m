Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB85AC433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 00:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D4A20678
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 00:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHKAkZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 20:40:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:53567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbgHKAkY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 20:40:24 -0400
IronPort-SDR: bCryrOqqNguwmfVNYdxiVsTX4/nyphbZtqECNGwWFUt4Zs3BuB7jLZ0Qjx6fCrXAp/q/Q2xyQv
 jya+0J1q93iQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="133702733"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="133702733"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:40:24 -0700
IronPort-SDR: W//wyktk4GLZiPNyBfPhqV+3vfIepaosoAeVfjVwE914B1DnjYF1Rybq5iQ/mMxIVzMr443EzJ
 fNOCKj/l08bA==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="317544595"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:40:23 -0700
From:   ira.weiny@intel.com
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: Remove unused async iterators
Date:   Mon, 10 Aug 2020 17:40:15 -0700
Message-Id: <20200811004015.2800392-3-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20200811004015.2800392-1-ira.weiny@intel.com>
References: <20200811004015.2800392-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Revert "crypto: hash - Add real ahash walk interface"
This reverts commit 75ecb231ff45b54afa9f4ec9137965c3c00868f4.

The callers of the functions in this commit were removed in ab8085c130ed

Remove these unused calls.

Fixes: ab8085c130ed ("crypto: x86 - remove SHA multibuffer routines and mcryptd")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 crypto/ahash.c                 | 41 ++++------------------------------
 include/crypto/internal/hash.h | 13 -----------
 2 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 68a0f0cb75c4..9c23b606949e 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -10,7 +10,6 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
-#include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -46,10 +45,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
-	if (walk->flags & CRYPTO_ALG_ASYNC)
-		walk->data = kmap(walk->pg);
-	else
-		walk->data = kmap_atomic(walk->pg);
+	walk->data = kmap_atomic(walk->pg);
 	walk->data += offset;
 
 	if (offset & alignmask) {
@@ -99,16 +95,8 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		}
 	}
 
-	if (walk->flags & CRYPTO_ALG_ASYNC)
-		kunmap(walk->pg);
-	else {
-		kunmap_atomic(walk->data);
-		/*
-		 * The may sleep test only makes sense for sync users.
-		 * Async users don't need to sleep here anyway.
-		 */
-		crypto_yield(walk->flags);
-	}
+	kunmap_atomic(walk->data);
+	crypto_yield(walk->flags);
 
 	if (err)
 		return err;
@@ -140,33 +128,12 @@ int crypto_hash_walk_first(struct ahash_request *req,
 
 	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
 	walk->sg = req->src;
-	walk->flags = req->base.flags & CRYPTO_TFM_REQ_MASK;
+	walk->flags = req->base.flags;
 
 	return hash_walk_new_entry(walk);
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
-int crypto_ahash_walk_first(struct ahash_request *req,
-			    struct crypto_hash_walk *walk)
-{
-	walk->total = req->nbytes;
-
-	if (!walk->total) {
-		walk->entrylen = 0;
-		return 0;
-	}
-
-	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
-	walk->sg = req->src;
-	walk->flags = req->base.flags & CRYPTO_TFM_REQ_MASK;
-	walk->flags |= CRYPTO_ALG_ASYNC;
-
-	BUILD_BUG_ON(CRYPTO_TFM_REQ_MASK & CRYPTO_ALG_ASYNC);
-
-	return hash_walk_new_entry(walk);
-}
-EXPORT_SYMBOL_GPL(crypto_ahash_walk_first);
-
 static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 				unsigned int keylen)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 89f6f46ab2b8..6d3ad5ac4d28 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -62,25 +62,12 @@ struct crypto_shash_spawn {
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
-int crypto_ahash_walk_first(struct ahash_request *req,
-			   struct crypto_hash_walk *walk);
-
-static inline int crypto_ahash_walk_done(struct crypto_hash_walk *walk,
-					 int err)
-{
-	return crypto_hash_walk_done(walk, err);
-}
 
 static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
 {
 	return !(walk->entrylen | walk->total);
 }
 
-static inline int crypto_ahash_walk_last(struct crypto_hash_walk *walk)
-{
-	return crypto_hash_walk_last(walk);
-}
-
 int crypto_register_ahash(struct ahash_alg *alg);
 void crypto_unregister_ahash(struct ahash_alg *alg);
 int crypto_register_ahashes(struct ahash_alg *algs, int count);
-- 
2.28.0.rc0.12.gb6a658bd00c9


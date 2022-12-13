Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FF8C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Dec 2022 16:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiLMQNd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbiLMQN1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2022 11:13:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3319EBF2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 08:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDBB1B81247
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 16:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA96C433F2;
        Tue, 13 Dec 2022 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670948003;
        bh=LB2o25Gv1H50XcT5hv69n+KG18hOzYLcGrLdxv3EZlo=;
        h=From:To:Cc:Subject:Date:From;
        b=B2ayt8Qbjk1vY/k3IMUapveqW3Fjmrm4rpt3dunhQdnazrGXP5Ju/0oqa52bhf8G2
         kVS/TDkBEwpzu6nHdR7pXSy/1uLhRwh6R1hQUtHzkBgT/3Dzxo5+SloPNFU8GwD6Dd
         XfaizRC74CRDDh9VNIHgMlxss9GDfF6Upg7VH2HCmh+IFa3wS3E+Kgslx1y3MQ0Fay
         xSJ/nDs1MmBLLmwOmE6hqLch4GT+41xKnq4t87zoQiqxsY43GFcDuXGDQLEqSMrxXt
         UVHmUUuIBOkV/oVcRuiXoPOzbPzA3s33mIVBeRmR0SKKGdMHVt+cX+GJR5UszyJl07
         B/v5a8T6CImhg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: [RFC PATCH] crypto: use kmap_local() not kmap_atomic()
Date:   Tue, 13 Dec 2022 17:13:10 +0100
Message-Id: <20221213161310.2205802-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3334; i=ardb@kernel.org; h=from:subject; bh=LB2o25Gv1H50XcT5hv69n+KG18hOzYLcGrLdxv3EZlo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjmKSV/PWAyRlNtIsgqLrTqbR1ID8sdWbhSVo0HA/d aCb1ttKJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5iklQAKCRDDTyI5ktmPJKEwC/ 4tV8wxnfZh0HUPrKYOtjJ/q/jn/WVk3st+fCr9+bzuia9em+zhQPfZbKCqXE3Yn3r76mUU5yFcUnp3 NEBcegEEMSvntgXzyOdK7Qpzx7BSQrG976A5NBEUS/M3b1uqzKX1pcQcaohXUxESxkxy0lWeER5hNz jT/pExfV++BMGTipfCEKNDPzl1YpugJgBSaz67ivrkAtdG4AoEwU6JTsTtiG/jaRlhAN+tW6kREjBl DuaPFSQ5pLG3US8wRacpj7c1Sx8MmXJRxn2CkCjJXEEwR+peYakUMoaAs0CcoalckhSCr2OjRyqO6V qIpuf1fqqwvA1S+rDOq0FPyhSDCGZv7B2pWWzKSN9IqOI/+GZc+ANIC/4Le33msyCQizMQwynQJzYA Vaz+YsSBWXyrHwmQ3c6dkdrJiEPIQnBAsAkza2gOairCZy9y2ud2J3cvE4h4l13XPEBI98/J1Y3G4c guC+iaP6s0eVcGyD2cFhEkgsEy5inaTlav7ovQzuFpY+4=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kmap_atomic() is used to create short-lived mappings of pages that may
not be accessible via the kernel direct map. This is only needed on
32-bit architectures that implement CONFIG_HIGHMEM, but it can be used
on 64-bit other architectures too, where the returned mapping is simply
the kernel direct address of the page.

However, kmap_atomic() does not support migration on CONFIG_HIGHMEM
configurations, due to the use of per-CPU kmap slots, and so it disables
preemption on all architectures, not just the 32-bit ones. This implies
that all scatterwalk based crypto routines essentially execute with
preemption disabled all the time, which is less than ideal.

So let's switch scatterwalk_map/_unmap and the shash/ahash routines to
kmap_local() instead, which serves a similar purpose, but without the
resulting impact on preemption on architectures that have no need for
CONFIG_HIGHMEM.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/ahash.c               | 4 ++--
 crypto/shash.c               | 4 ++--
 include/crypto/scatterwalk.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index c2ca631a111fc7fd..4b089f1b770f2a60 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -45,7 +45,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
-	walk->data = kmap_atomic(walk->pg);
+	walk->data = kmap_local_page(walk->pg);
 	walk->data += offset;
 
 	if (offset & alignmask) {
@@ -95,7 +95,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		}
 	}
 
-	kunmap_atomic(walk->data);
+	kunmap_local(walk->data);
 	crypto_yield(walk->flags);
 
 	if (err)
diff --git a/crypto/shash.c b/crypto/shash.c
index 4c88e63b3350fc7f..0c7f91b1917e3691 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -330,10 +330,10 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
 		void *data;
 
-		data = kmap_atomic(sg_page(sg));
+		data = kmap_local_page(sg_page(sg));
 		err = crypto_shash_digest(desc, data + offset, nbytes,
 					  req->result);
-		kunmap_atomic(data);
+		kunmap_local(data);
 	} else
 		err = crypto_shash_init(desc) ?:
 		      shash_ahash_finup(req, desc);
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index ccdb05f68a75c3a2..9cdf31c756eeacba 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -53,7 +53,7 @@ static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 
 static inline void scatterwalk_unmap(void *vaddr)
 {
-	kunmap_atomic(vaddr);
+	kunmap_local(vaddr);
 }
 
 static inline void scatterwalk_start(struct scatter_walk *walk,
@@ -65,7 +65,7 @@ static inline void scatterwalk_start(struct scatter_walk *walk,
 
 static inline void *scatterwalk_map(struct scatter_walk *walk)
 {
-	return kmap_atomic(scatterwalk_page(walk)) +
+	return kmap_local_page(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
 
-- 
2.35.1


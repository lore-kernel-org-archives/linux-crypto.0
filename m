Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAD13F42F
	for <linux-crypto@vger.kernel.org>; Fri, 27 Dec 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735339722; cv=none; b=q/jYrA9XY2cWuqEjk957rK8na0nuMFLcU9snb95ZpJQ287T3IU+QzfEKuNC93J7xaDa/jsvtMy8FLb6MQmTAdTcSXakmhZKln6+DdFFNm735ClHo5E8aSG7om75dVv7QibYYy64G6DqpdJPZj/j0uKWC/Ytl1G8x1j34TIYw2Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735339722; c=relaxed/simple;
	bh=S7hYr2H5qYU64l1Vw36WVOz1rPSk96swssO6uSUB1C8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Qm0Zd92jbwDF6NzQc4JuDxGpK1OzWyfOLBZ2Od8cTFwUW6MCQCSMdQirs61D5XYm9cqSqgX9Gn/4ZpKmrJAcMhUvvAL/7buYWKb8rSL1VyJgX8SdB+aTRurB8wojMF/WbCi6EvFu6q6aT2e1Ftd7yHY0I4fP7L2Q8oThWRpO/P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEuarqWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEuarqWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ED4C4CED0
	for <linux-crypto@vger.kernel.org>; Fri, 27 Dec 2024 22:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735339722;
	bh=S7hYr2H5qYU64l1Vw36WVOz1rPSk96swssO6uSUB1C8=;
	h=From:To:Subject:Date:From;
	b=cEuarqWWP2uHpaqPpaB7im1VUClLL4gic0IOLscs8Wc8TO7Nxw4hCR6Sacubt4AtV
	 EMM0NDTFNpVUzGoGzJa/e7d404O6c1AFynO+vWG1wCltGS1rJUv/fkbxWqUYe2Qsbg
	 RiJbljZWM0pKKNcB/YXcL5SXYucWvJHImqQ3nELFdjphHaLlLsPit0+q43KTTA+UPt
	 UbTYp2WZo0JgzmomQsL42MVO/7xjkwD7UpN8bLbeeb5Go5h1uYItGUEjCoKYhpvE59
	 gOSkJNXwvUMKJSj4+nOKUxd1+3PO25EGnnnJpZ32FWSYpMa9RBWROovjTXOj2PgqlF
	 5YCPAhOdgZ3Tg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ahash - make hash walk functions private to ahash.c
Date: Fri, 27 Dec 2024 14:48:29 -0800
Message-ID: <20241227224829.179554-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Due to the removal of the Niagara2 SPU driver, crypto_hash_walk_first(),
crypto_hash_walk_done(), crypto_hash_walk_last(), and struct
crypto_hash_walk are now only used in crypto/ahash.c.  Therefore, make
them all private to crypto/ahash.c.  I.e. un-export the two functions
that were exported, make the functions static, and move the struct
definition to the .c file.  As part of this, move the functions to
earlier in the file to avoid needing to add forward declarations.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 158 ++++++++++++++++++---------------
 include/crypto/internal/hash.h |  23 -----
 2 files changed, 87 insertions(+), 94 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index bcd9de009a91..b08b89ec26ec 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -25,10 +25,97 @@
 
 #include "hash.h"
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
+struct crypto_hash_walk {
+	char *data;
+
+	unsigned int offset;
+	unsigned int flags;
+
+	struct page *pg;
+	unsigned int entrylen;
+
+	unsigned int total;
+	struct scatterlist *sg;
+};
+
+static int hash_walk_next(struct crypto_hash_walk *walk)
+{
+	unsigned int offset = walk->offset;
+	unsigned int nbytes = min(walk->entrylen,
+				  ((unsigned int)(PAGE_SIZE)) - offset);
+
+	walk->data = kmap_local_page(walk->pg);
+	walk->data += offset;
+	walk->entrylen -= nbytes;
+	return nbytes;
+}
+
+static int hash_walk_new_entry(struct crypto_hash_walk *walk)
+{
+	struct scatterlist *sg;
+
+	sg = walk->sg;
+	walk->offset = sg->offset;
+	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+	walk->offset = offset_in_page(walk->offset);
+	walk->entrylen = sg->length;
+
+	if (walk->entrylen > walk->total)
+		walk->entrylen = walk->total;
+	walk->total -= walk->entrylen;
+
+	return hash_walk_next(walk);
+}
+
+static int crypto_hash_walk_first(struct ahash_request *req,
+				  struct crypto_hash_walk *walk)
+{
+	walk->total = req->nbytes;
+
+	if (!walk->total) {
+		walk->entrylen = 0;
+		return 0;
+	}
+
+	walk->sg = req->src;
+	walk->flags = req->base.flags;
+
+	return hash_walk_new_entry(walk);
+}
+
+static int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
+{
+	walk->data -= walk->offset;
+
+	kunmap_local(walk->data);
+	crypto_yield(walk->flags);
+
+	if (err)
+		return err;
+
+	if (walk->entrylen) {
+		walk->offset = 0;
+		walk->pg++;
+		return hash_walk_next(walk);
+	}
+
+	if (!walk->total)
+		return 0;
+
+	walk->sg = sg_next(walk->sg);
+
+	return hash_walk_new_entry(walk);
+}
+
+static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
+{
+	return !(walk->entrylen | walk->total);
+}
+
 /*
  * For an ahash tfm that is using an shash algorithm (instead of an ahash
  * algorithm), this returns the underlying shash tfm.
  */
 static inline struct crypto_shash *ahash_to_shash(struct crypto_ahash *tfm)
@@ -135,81 +222,10 @@ static int crypto_init_ahash_using_shash(struct crypto_tfm *tfm)
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
 }
 
-static int hash_walk_next(struct crypto_hash_walk *walk)
-{
-	unsigned int offset = walk->offset;
-	unsigned int nbytes = min(walk->entrylen,
-				  ((unsigned int)(PAGE_SIZE)) - offset);
-
-	walk->data = kmap_local_page(walk->pg);
-	walk->data += offset;
-	walk->entrylen -= nbytes;
-	return nbytes;
-}
-
-static int hash_walk_new_entry(struct crypto_hash_walk *walk)
-{
-	struct scatterlist *sg;
-
-	sg = walk->sg;
-	walk->offset = sg->offset;
-	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
-	walk->offset = offset_in_page(walk->offset);
-	walk->entrylen = sg->length;
-
-	if (walk->entrylen > walk->total)
-		walk->entrylen = walk->total;
-	walk->total -= walk->entrylen;
-
-	return hash_walk_next(walk);
-}
-
-int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
-{
-	walk->data -= walk->offset;
-
-	kunmap_local(walk->data);
-	crypto_yield(walk->flags);
-
-	if (err)
-		return err;
-
-	if (walk->entrylen) {
-		walk->offset = 0;
-		walk->pg++;
-		return hash_walk_next(walk);
-	}
-
-	if (!walk->total)
-		return 0;
-
-	walk->sg = sg_next(walk->sg);
-
-	return hash_walk_new_entry(walk);
-}
-EXPORT_SYMBOL_GPL(crypto_hash_walk_done);
-
-int crypto_hash_walk_first(struct ahash_request *req,
-			   struct crypto_hash_walk *walk)
-{
-	walk->total = req->nbytes;
-
-	if (!walk->total) {
-		walk->entrylen = 0;
-		return 0;
-	}
-
-	walk->sg = req->src;
-	walk->flags = req->base.flags;
-
-	return hash_walk_new_entry(walk);
-}
-EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
-
 static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 			  unsigned int keylen)
 {
 	return -ENOSYS;
 }
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 58967593b6b4..84da3424decc 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -10,24 +10,10 @@
 
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
 struct ahash_request;
-struct scatterlist;
-
-struct crypto_hash_walk {
-	char *data;
-
-	unsigned int offset;
-	unsigned int flags;
-
-	struct page *pg;
-	unsigned int entrylen;
-
-	unsigned int total;
-	struct scatterlist *sg;
-};
 
 struct ahash_instance {
 	void (*free)(struct ahash_instance *inst);
 	union {
 		struct {
@@ -55,19 +41,10 @@ struct crypto_ahash_spawn {
 
 struct crypto_shash_spawn {
 	struct crypto_spawn base;
 };
 
-int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
-int crypto_hash_walk_first(struct ahash_request *req,
-			   struct crypto_hash_walk *walk);
-
-static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
-{
-	return !(walk->entrylen | walk->total);
-}
-
 int crypto_register_ahash(struct ahash_alg *alg);
 void crypto_unregister_ahash(struct ahash_alg *alg);
 int crypto_register_ahashes(struct ahash_alg *algs, int count);
 void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,

base-commit: 7b6092ee7a4ce2d03dc65b87537889e8e1e0ab95
-- 
2.47.1


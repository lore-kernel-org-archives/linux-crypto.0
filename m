Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6613510A1F
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675259; cv=none; b=LPDpBuvy0DhvQ+iRdfRKtIFZZWLZexSrvWQIfwBxAhQwMLGMAsDLphMqlaTsBGL3W3pOg8nRsZSuu46FI3+Y/9hwbBi23vmlEVfhjgAWP5NZcC7OOPKylrG06oflAVb5daPgp6A/HQ7QpF5BO/TE6FWej93NRE3l/BZGYhgq6uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675259; c=relaxed/simple;
	bh=3n7dW+Dn06EC4hrLV6q4tdY3D7DDC32kKDRs/inG9Dc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=NiilKUWE6OhNv1VIpNMY5Xf1UaXUqmhCNIKwQLZo5ZfxM+fPZ9p8tqKA9wZvF/SoLvpeMbRji9Gjc9LS2pxLPQ9PC7VOu3CI7KrkU8kzez2uLsZjp/6aFPMecnPl61LdFPEh6K2FaRf//fF8gZaYbTvzwrkQvkIXrdcoAvcl69M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z8OREJTD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z8OREJTD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AfJ3SA/bRPE6cedgO69rzRNOIPPNNWgDTd0omE6JgLc=; b=Z8OREJTDYVUfKTZNaS9n5vQkyz
	GCbtht/dIVEDcoOoHla0MGNzDET4NKthaT77gOnTrLbukhIQjgB8gj2NBsU7lERg72wWZBzA1Fu/A
	w/Zya0eJBzWNBNVhAMnCL4q73t2Yu1oRMtVXjAZDYRgcJ6ClBjTun/vpkgADIcVyJ08pk2YW1O9PB
	mGo7/s3/RWFuMzVmGMgcSRMgRCzql3ED/Eo1uzX4xuzrZydmfHizv15qS/MJfmOmvIrBasSMnUb51
	+DVsErh3GSwT2drO6z/qrCm97lxwzJ9YxNi9w+qwtTBPjys/KfYBLH+zJiUZHmxC81Rc5oyN1slKm
	YBREdUvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnM-000ga9-2r;
	Sun, 16 Feb 2025 11:07:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:33 +0800
Date: Sun, 16 Feb 2025 11:07:33 +0800
Message-Id: <513768f4907245e15e5f12bb20bd50762c3cc25b.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 10/11] fsverity: Use sync hash instead of shash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the sync hash interface instead of shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 fs/verity/fsverity_private.h |  2 +-
 fs/verity/hash_algs.c        | 41 +++++++++++++++++++-----------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index b3506f56e180..aecc221daf8b 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -20,7 +20,7 @@
 
 /* A hash algorithm supported by fs-verity */
 struct fsverity_hash_alg {
-	struct crypto_shash *tfm; /* hash tfm, allocated on demand */
+	struct crypto_sync_hash *tfm; /* hash tfm, allocated on demand */
 	const char *name;	  /* crypto API name, e.g. sha256 */
 	unsigned int digest_size; /* digest size in bytes, e.g. 32 for SHA-256 */
 	unsigned int block_size;  /* block size in bytes, e.g. 64 for SHA-256 */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 6b08b1d9a7d7..e088bcfe5ed1 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -43,7 +43,7 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 						      unsigned int num)
 {
 	struct fsverity_hash_alg *alg;
-	struct crypto_shash *tfm;
+	struct crypto_sync_hash *tfm;
 	int err;
 
 	if (num >= ARRAY_SIZE(fsverity_hash_algs) ||
@@ -62,7 +62,7 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 	if (alg->tfm != NULL)
 		goto out_unlock;
 
-	tfm = crypto_alloc_shash(alg->name, 0, 0);
+	tfm = crypto_alloc_sync_hash(alg->name, 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			fsverity_warn(inode,
@@ -79,20 +79,20 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 	}
 
 	err = -EINVAL;
-	if (WARN_ON_ONCE(alg->digest_size != crypto_shash_digestsize(tfm)))
+	if (WARN_ON_ONCE(alg->digest_size != crypto_sync_hash_digestsize(tfm)))
 		goto err_free_tfm;
-	if (WARN_ON_ONCE(alg->block_size != crypto_shash_blocksize(tfm)))
+	if (WARN_ON_ONCE(alg->block_size != crypto_sync_hash_blocksize(tfm)))
 		goto err_free_tfm;
 
 	pr_info("%s using implementation \"%s\"\n",
-		alg->name, crypto_shash_driver_name(tfm));
+		alg->name, crypto_sync_hash_driver_name(tfm));
 
 	/* pairs with smp_load_acquire() above */
 	smp_store_release(&alg->tfm, tfm);
 	goto out_unlock;
 
 err_free_tfm:
-	crypto_free_shash(tfm);
+	crypto_free_sync_hash(tfm);
 	alg = ERR_PTR(err);
 out_unlock:
 	mutex_unlock(&fsverity_hash_alg_init_mutex);
@@ -112,17 +112,15 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 				      const u8 *salt, size_t salt_size)
 {
 	u8 *hashstate = NULL;
-	SHASH_DESC_ON_STACK(desc, alg->tfm);
+	SYNC_HASH_REQUEST_ON_STACK(req, alg->tfm);
 	u8 *padded_salt = NULL;
 	size_t padded_salt_size;
 	int err;
 
-	desc->tfm = alg->tfm;
-
 	if (salt_size == 0)
 		return NULL;
 
-	hashstate = kmalloc(crypto_shash_statesize(alg->tfm), GFP_KERNEL);
+	hashstate = kmalloc(crypto_sync_hash_statesize(alg->tfm), GFP_KERNEL);
 	if (!hashstate)
 		return ERR_PTR(-ENOMEM);
 
@@ -140,15 +138,19 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 		goto err_free;
 	}
 	memcpy(padded_salt, salt, salt_size);
-	err = crypto_shash_init(desc);
+
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+
+	err = crypto_ahash_init(req);
 	if (err)
 		goto err_free;
 
-	err = crypto_shash_update(desc, padded_salt, padded_salt_size);
+	ahash_request_set_virt(req, padded_salt, NULL, padded_salt_size);
+	err = crypto_ahash_update(req);
 	if (err)
 		goto err_free;
 
-	err = crypto_shash_export(desc, hashstate);
+	err = crypto_ahash_export(req, hashstate);
 	if (err)
 		goto err_free;
 out:
@@ -176,21 +178,22 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 int fsverity_hash_block(const struct merkle_tree_params *params,
 			const struct inode *inode, const void *data, u8 *out)
 {
-	SHASH_DESC_ON_STACK(desc, params->hash_alg->tfm);
+	SYNC_HASH_REQUEST_ON_STACK(req, params->hash_alg->tfm);
 	int err;
 
-	desc->tfm = params->hash_alg->tfm;
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_virt(req, data, out, params->block_size);
 
 	if (params->hashstate) {
-		err = crypto_shash_import(desc, params->hashstate);
+		err = crypto_ahash_import(req, params->hashstate);
 		if (err) {
 			fsverity_err(inode,
 				     "Error %d importing hash state", err);
 			return err;
 		}
-		err = crypto_shash_finup(desc, data, params->block_size, out);
+		err = crypto_ahash_finup(req);
 	} else {
-		err = crypto_shash_digest(desc, data, params->block_size, out);
+		err = crypto_ahash_digest(req);
 	}
 	if (err)
 		fsverity_err(inode, "Error %d computing block hash", err);
@@ -209,7 +212,7 @@ int fsverity_hash_block(const struct merkle_tree_params *params,
 int fsverity_hash_buffer(const struct fsverity_hash_alg *alg,
 			 const void *data, size_t size, u8 *out)
 {
-	return crypto_shash_tfm_digest(alg->tfm, data, size, out);
+	return crypto_sync_hash_digest(alg->tfm, data, size, out);
 }
 
 void __init fsverity_check_hash_algs(void)
-- 
2.39.5


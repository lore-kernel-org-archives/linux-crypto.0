Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D816E1CBE8C
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105696; cv=none; b=fGXduVaSG7Kt0fPPX1xvoCDKh2/aTEMUKsduog2n52EAOOcFz1G7vJF+DElud4wAnJRwXpq3BH9tOQE5Q0AOzGP7UaUEVf3t+3rwbWkmrh5pHMuFOg2vQytvpZaEt/6VBYl2SGh9Z4UMVWdle15LE2tpwNkIvBoQD3q/L33JwNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105696; c=relaxed/simple;
	bh=VsaYFM7nf9+iC1YnzN8b1pGbhUrUR9GOM+Yzo4COmtY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/1+k03XHDbmpsprl+pQ+KKzfaSW5bUvd80jbFU0n4cICZ8BPX8G5oodNXZuW9JltlgXlfoiro4+IJG1Ye1q+136+I7W5UeuMhpCemXGJnMTDlK/z+fSx+JXHNoeNZ7W15r+dGfokRYAl2BfCMyjIvveBDJBr9FtpPU47bz/QcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gf+wqBjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gf+wqBjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC336C4CED2
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105696;
	bh=VsaYFM7nf9+iC1YnzN8b1pGbhUrUR9GOM+Yzo4COmtY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Gf+wqBjnv2rDJEA1iOjsA7wmtIg9Zp5XgmALYLp/FTZZ0tKofGVg6Q6F7u9kQ8/y+
	 epqHYNRrecAXU/k76hPJYGrUg8rfxN2uT43dBabiMcCuABRXk8+DBYpmE9MOkpUVSn
	 JF79vw7tNQ3mbMZ4En/NNHohpc0Pu3qtxcgLl63597upZCFwJKLNe3Zxd6kZ65ZTHl
	 1V2X/MICpoWkErDijwthbhv26ACL6jaE55CGc9yB1f+EGjvZwNsmUUcHAD52GtCZxj
	 NxDODHJZntYDuPBvQmquBVMa0VNAeMINjXK4KVsCIAL1x3uF2tsuuB74h+/VQURRAp
	 bX6odk58BXw4Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 6/8] crypto: skcipher - clean up initialization of skcipher_walk::flags
Date: Sun,  5 Jan 2025 11:34:14 -0800
Message-ID: <20250105193416.36537-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250105193416.36537-1-ebiggers@kernel.org>
References: <20250105193416.36537-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

- Initialize SKCIPHER_WALK_SLEEP in a consistent way, and check for
  atomic=true at the same time as CRYPTO_TFM_REQ_MAY_SLEEP.  Technically
  atomic=true only needs to apply after the first step, but it is very
  rarely used.  We should optimize for the common case.  So, check
  'atomic' alongside CRYPTO_TFM_REQ_MAY_SLEEP.  This is more efficient.

- Initialize flags other than SKCIPHER_WALK_SLEEP to 0 rather than
  preserving them.  No caller actually initializes the flags, which
  makes it impossible to use their original values for anything.
  Indeed, that does not happen and all meaningful flags get overridden
  anyway.  It may have been thought that just clearing one flag would be
  faster than clearing all flags, but that's not the case as the former
  is a read-write operation whereas the latter is just a write.

- Move the explicit clearing of SKCIPHER_WALK_SLOW, SKCIPHER_WALK_COPY,
  and SKCIPHER_WALK_DIFF into skcipher_walk_done(), since it is now
  only needed on non-first steps.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 17f4bc79ca8b..e54d1ad46566 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -146,10 +146,12 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 	scatterwalk_done(&walk->out, 1, total);
 
 	if (total) {
 		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
 			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
+		walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
+				 SKCIPHER_WALK_DIFF);
 		return skcipher_walk_next(walk);
 	}
 
 finish:
 	/* Short-circuit for the common/fast path. */
@@ -233,13 +235,10 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 static int skcipher_walk_next(struct skcipher_walk *walk)
 {
 	unsigned int bsize;
 	unsigned int n;
 
-	walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
-			 SKCIPHER_WALK_DIFF);
-
 	n = walk->total;
 	bsize = min(walk->stride, max(n, walk->blocksize));
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
@@ -309,55 +308,53 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req, bool atomic)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	int err = 0;
 
 	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
+		walk->flags = SKCIPHER_WALK_SLEEP;
+	else
+		walk->flags = 0;
 
 	if (unlikely(!walk->total))
-		goto out;
+		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	walk->flags &= ~SKCIPHER_WALK_SLEEP;
-	walk->flags |= req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-		       SKCIPHER_WALK_SLEEP : 0;
-
 	walk->blocksize = crypto_skcipher_blocksize(tfm);
 	walk->ivsize = crypto_skcipher_ivsize(tfm);
 	walk->alignmask = crypto_skcipher_alignmask(tfm);
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
 
-	err = skcipher_walk_first(walk);
-out:
-	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
-
-	return err;
+	return skcipher_walk_first(walk);
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
 static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 				     struct aead_request *req, bool atomic)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	int err;
 
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
+		walk->flags = SKCIPHER_WALK_SLEEP;
+	else
+		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
@@ -367,26 +364,16 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
 
 	scatterwalk_done(&walk->in, 0, walk->total);
 	scatterwalk_done(&walk->out, 0, walk->total);
 
-	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
-		walk->flags |= SKCIPHER_WALK_SLEEP;
-	else
-		walk->flags &= ~SKCIPHER_WALK_SLEEP;
-
 	walk->blocksize = crypto_aead_blocksize(tfm);
 	walk->stride = crypto_aead_chunksize(tfm);
 	walk->ivsize = crypto_aead_ivsize(tfm);
 	walk->alignmask = crypto_aead_alignmask(tfm);
 
-	err = skcipher_walk_first(walk);
-
-	if (atomic)
-		walk->flags &= ~SKCIPHER_WALK_SLEEP;
-
-	return err;
+	return skcipher_walk_first(walk);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic)
 {
-- 
2.47.1


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB125948E;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=KXju8bVI88dJlm7Z/R/vso5mMSs9ouQ3bViYfvtCRO29kD4QgN26eefl0nnCFwidbvbEy0W9O5x+h2cECNqBsQGLQPJylZQ84bPPA6n0vb5AvbQxKTruB1JoebSemX4O2l6X7upWu+RD7q60TTDQk7ihvytHzC2P/VKVRByXTZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=5+ZF0ImlbQo//JHYBtR4hUhu8cd/k3zSglYQL5MyI1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8objp7o1ZEbd95siolE0Lvl3TcdnOu08oINwSrlU9ARNvYogBJbs1ZCPDLs+v+vIgoLufaYTO3nk2sSscmURYjIYg1WdBg8pTbfqbtQTWLtm0UCRrHrYmaHnMv3FLBXUrqvKaHTj3ClhS4q/55vFFWAZgD3vObjnNX7qds87wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CajwGQWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CajwGQWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51452C4CED7;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517759;
	bh=5+ZF0ImlbQo//JHYBtR4hUhu8cd/k3zSglYQL5MyI1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CajwGQWsxx05ZrJZe2LCuWC1feYaE6hpCpmCosLC9+nd9cABcywaDkOtw+FfJFDKs
	 EDUrpQO5btCgpYAo8cUbvLnpnqDK4JqDQgJ7hY3GDsMPTk5vxUihNLbrBCdyWDnwL4
	 KO+BY2iZg0D47vV+bSog6PydDkilzlIgdam8Y5vXE89LEAWTVTX60CYCVa6pxl78n9
	 eE/XkAI0rC8035n/rPCyKI+QP5mvI0p3H/O/TAWH2+4MXZ7itSFE863g2FHGVGjQVR
	 xwQ4wzHr9WHwMfsG52Wbfm7b/HkqYS+aazwxFrXj4uI6STp5hPNRqxRZeLwtO6e4df
	 HBEmF/JgoUpKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/29] crypto: skcipher - document skcipher_walk_done() and rename some vars
Date: Sun, 29 Dec 2024 16:13:50 -0800
Message-ID: <20241230001418.74739-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

skcipher_walk_done() has an unusual calling convention, and some of its
local variables have unclear names.  Document it and rename variables to
make it a bit clearer what is going on.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c                  | 50 ++++++++++++++++++++----------
 include/crypto/internal/skcipher.h |  2 +-
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index d5fe0eca3826..8749c44f98a2 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -87,21 +87,39 @@ static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
 	addr = skcipher_get_spot(addr, bsize);
 	scatterwalk_copychunks(addr, &walk->out, bsize, 1);
 	return 0;
 }
 
-int skcipher_walk_done(struct skcipher_walk *walk, int err)
+/**
+ * skcipher_walk_done() - finish one step of a skcipher_walk
+ * @walk: the skcipher_walk
+ * @res: number of bytes *not* processed (>= 0) from walk->nbytes,
+ *	 or a -errno value to terminate the walk due to an error
+ *
+ * This function cleans up after one step of walking through the source and
+ * destination scatterlists, and advances to the next step if applicable.
+ * walk->nbytes is set to the number of bytes available in the next step,
+ * walk->total is set to the new total number of bytes remaining, and
+ * walk->{src,dst}.virt.addr is set to the next pair of data pointers.  If there
+ * is no more data, or if an error occurred (i.e. -errno return), then
+ * walk->nbytes and walk->total are set to 0 and all resources owned by the
+ * skcipher_walk are freed.
+ *
+ * Return: 0 or a -errno value.  If @res was a -errno value then it will be
+ *	   returned, but other errors may occur too.
+ */
+int skcipher_walk_done(struct skcipher_walk *walk, int res)
 {
-	unsigned int n = walk->nbytes;
-	unsigned int nbytes = 0;
+	unsigned int n = walk->nbytes; /* num bytes processed this step */
+	unsigned int total = 0; /* new total remaining */
 
 	if (!n)
 		goto finish;
 
-	if (likely(err >= 0)) {
-		n -= err;
-		nbytes = walk->total - n;
+	if (likely(res >= 0)) {
+		n -= res; /* subtract num bytes *not* processed */
+		total = walk->total - n;
 	}
 
 	if (likely(!(walk->flags & (SKCIPHER_WALK_SLOW |
 				    SKCIPHER_WALK_COPY |
 				    SKCIPHER_WALK_DIFF)))) {
@@ -113,35 +131,35 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 	} else if (walk->flags & SKCIPHER_WALK_COPY) {
 		skcipher_map_dst(walk);
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (err > 0) {
+		if (res > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
 			 * the message wasn't evenly divisible into blocks but
 			 * the algorithm requires it.
 			 */
-			err = -EINVAL;
-			nbytes = 0;
+			res = -EINVAL;
+			total = 0;
 		} else
 			n = skcipher_done_slow(walk, n);
 	}
 
-	if (err > 0)
-		err = 0;
+	if (res > 0)
+		res = 0;
 
-	walk->total = nbytes;
+	walk->total = total;
 	walk->nbytes = 0;
 
 	scatterwalk_advance(&walk->in, n);
 	scatterwalk_advance(&walk->out, n);
-	scatterwalk_done(&walk->in, 0, nbytes);
-	scatterwalk_done(&walk->out, 1, nbytes);
+	scatterwalk_done(&walk->in, 0, total);
+	scatterwalk_done(&walk->out, 1, total);
 
-	if (nbytes) {
+	if (total) {
 		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
 			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
 		return skcipher_walk_next(walk);
 	}
 
@@ -156,11 +174,11 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 		kfree(walk->buffer);
 	if (walk->page)
 		free_page((unsigned long)walk->page);
 
 out:
-	return err;
+	return res;
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_done);
 
 static int skcipher_next_slow(struct skcipher_walk *walk, unsigned int bsize)
 {
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 08d1e8c63afc..4f49621d3eb6 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -194,11 +194,11 @@ void crypto_unregister_lskcipher(struct lskcipher_alg *alg);
 int crypto_register_lskciphers(struct lskcipher_alg *algs, int count);
 void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count);
 int lskcipher_register_instance(struct crypto_template *tmpl,
 				struct lskcipher_instance *inst);
 
-int skcipher_walk_done(struct skcipher_walk *walk, int err);
+int skcipher_walk_done(struct skcipher_walk *walk, int res);
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req,
 		       bool atomic);
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
-- 
2.47.1


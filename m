Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0B224CE
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815798; cv=none; b=my7Cx3w2cNyRUWSNQGp/NJKd493EhQyRvPmAMIf5co4aJ60aNRS5nkv5k3BxQyaNzzjyLlEo/WtDBSbZMeztEdtIdAKVjNVt7cKGQfc4OhXvqdkKxvRs7PLnJ+zN8Lhf7jdWzQcF62mVncb4XZ2Wknkra04Gdz3nyDJbPj1fg/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815798; c=relaxed/simple;
	bh=WsnxyouPW+s449ND9/I1WypZsASuz1TM2jcmYDU21sg=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=nM+WIIxmHWgu+xgqutNpvgLS2sX7hgQ9Rd3xKsyYkNPqk1AjhJk72Ugv3B886Qb69E4/ytIvH37WmpOhBrJdenG57qeNHiNRqjm/hTzU2ZfEaUHiYlWYyzJ/sKOOFekRSqeYWQcSCsBv7zUSGnQg/NNScrhJg0QLIw/PU9vDu7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZotu-00D1pI-30; Tue, 13 Feb 2024 17:16:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:40 +0800
Message-Id: <39cd9244cd3e4aba23653464c95f94da5b2dc3ec.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 2 Dec 2023 12:55:02 +0800
Subject: [PATCH 01/15] crypto: skcipher - Add tailsize attribute
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch adds a new tailsize attribute to skcipher and lskcipher
algorithms.  This will be used by algorithms such as CTS which may
need to withhold a number of blocks until the end has been reached.

When issuing a NOTFINAL request, the user must ensure that at least
tailsize bytes will be supplied later on a final request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/lskcipher.c                 |  1 +
 crypto/skcipher.c                  | 16 ++++++++++++++-
 include/crypto/internal/skcipher.h |  1 +
 include/crypto/skcipher.h          | 33 ++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 0b6dd8aa21f2..2a602911f4fc 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -300,6 +300,7 @@ static void __maybe_unused crypto_lskcipher_show(
 	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
 	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
 	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
+	seq_printf(m, "tailsize     : %u\n", skcipher->co.tailsize);
 }
 
 static int __maybe_unused crypto_lskcipher_report(
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index bc70e159d27d..600ec5735ce0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -368,10 +368,21 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 			 SKCIPHER_WALK_DIFF);
 
 	n = walk->total;
-	bsize = min(walk->stride, max(n, walk->blocksize));
+
+	bsize = max(n, walk->blocksize);
+	if (n > walk->tailsize)
+		bsize = min(walk->stride, bsize);
+
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
+	/* Retain tail if necessary. */
+	if (walk->tailsize < walk->total && walk->total - n < walk->tailsize) {
+		/* Process at least one block. */
+		n = min(n, bsize);
+		n = max(n, walk->total - walk->tailsize);
+	}
+
 	if (unlikely(n < bsize)) {
 		if (unlikely(walk->total < walk->blocksize))
 			return skcipher_walk_done(walk, -EINVAL);
@@ -487,6 +498,7 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 	walk->blocksize = crypto_skcipher_blocksize(tfm);
 	walk->ivsize = crypto_skcipher_ivsize(tfm);
 	walk->alignmask = crypto_skcipher_alignmask(tfm);
+	walk->tailsize = crypto_skcipher_tailsize(tfm);
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
@@ -824,6 +836,7 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "chunksize    : %u\n", skcipher->chunksize);
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
 	seq_printf(m, "statesize    : %u\n", skcipher->statesize);
+	seq_printf(m, "tailsize     : %u\n", skcipher->tailsize);
 }
 
 static int __maybe_unused crypto_skcipher_report(
@@ -939,6 +952,7 @@ int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
+	    alg->tailsize > PAGE_SIZE / 8 ||
 	    alg->statesize > PAGE_SIZE / 2 ||
 	    (alg->ivsize + alg->statesize) > PAGE_SIZE / 2)
 		return -EINVAL;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 7ae42afdcf3e..1e35e7719b22 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -86,6 +86,7 @@ struct skcipher_walk {
 	int flags;
 	unsigned int blocksize;
 	unsigned int stride;
+	unsigned int tailsize;
 	unsigned int alignmask;
 };
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index c8857d7bdb37..6223d81fed76 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -103,6 +103,8 @@ struct crypto_istat_cipher {
  * @chunksize: Equal to the block size except for stream ciphers such as
  *	       CTR where it is set to the underlying block size.
  * @statesize: Size of the internal state for the algorithm.
+ * @tailsize: Minimum number of bytes to withhold until the end of operation.
+ *	      Used by algorithms such as CTS to support chaining.
  * @stat: Statistics for cipher algorithm
  * @base: Definition of a generic crypto algorithm.
  */
@@ -112,6 +114,7 @@ struct crypto_istat_cipher {
 	unsigned int ivsize;		\
 	unsigned int chunksize;		\
 	unsigned int statesize;		\
+	unsigned int tailsize;		\
 					\
 	SKCIPHER_ALG_COMMON_STAT	\
 					\
@@ -543,6 +546,36 @@ static inline unsigned int crypto_lskcipher_statesize(
 	return crypto_lskcipher_alg(tfm)->co.statesize;
 }
 
+/**
+ * crypto_skcipher_tailsize() - obtain tail size
+ * @tfm: cipher handle
+ *
+ * Some algorithms need to withhold a number of blocks until the end.
+ * The tail size specifies how many bytes to withhold.
+ *
+ * Return: tail size in bytes
+ */
+static inline unsigned int crypto_skcipher_tailsize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_common(tfm)->tailsize;
+}
+
+/**
+ * crypto_lskcipher_tailsize() - obtain tail size
+ * @tfm: cipher handle
+ *
+ * Some algorithms need to withhold a number of blocks until the end.
+ * The tail size specifies how many bytes to withhold.
+ *
+ * Return: tail size in bytes
+ */
+static inline unsigned int crypto_lskcipher_tailsize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg(tfm)->co.tailsize;
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


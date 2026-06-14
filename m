Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B432E63C
	for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781450849; cv=none; b=Svd8aG5112BajpIWvEHNwaf6RPLzac2z8KwXzzmHRCHP18PMSwjmUfny1on8g/vOsv81klHKA+XtTU2hfLulHUiZBftJyvDlvlKTqiRoyVWFhdqeP3WkpLvH73wES28O9hGJVCo0RzQyodcnqwKVVpZFcYIHJzjbt3MnX0cyrb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781450849; c=relaxed/simple;
	bh=2kNkUgAdLJGKlXgq8oY9CHVL3t2dpNtXWG2IT1ZC6lc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EhVyMQgMTo30a0sR/wR3hIgsM+FfSwCp4F0F6RjQ8OyaddZ2AZzlFAdqm1xpNCNjyz/nMMxr70zBPMo2/9ANSl3uqpbINMSEX+HisG9geDSbFvyocBBsu59M8D8C8qgJX7+RtHS5KbyweRt3DqXqzDplmE4L0/f4dl2q2IyXX6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nkOd8rKE; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nkOd8rKE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781450845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eDCFtAvpueOIK9+mnyHt/B8LMjjjILaDNCbh2gVjU8Y=;
	b=nkOd8rKEIYIYcbpcac8X47XAi+crhIfm87m3OcSZoAgOnjCaPbUTERSfl6gLCo+yRXO3JC
	PRjTqzDgqw1R3GNrmd62VbL5l121K9kCB0j89g0yMFuwV0q0imWzespm0iE6wUkSe1kFe+
	0a4h7GPtb338dywM1VTaIRzgwvBhLUY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - drop unused scatterlist traversal in qce_ahash_update
Date: Sun, 14 Jun 2026 17:26:07 +0200
Message-ID: <20260614152605.701754-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2258; i=thorsten.blum@linux.dev; h=from:subject; bh=2kNkUgAdLJGKlXgq8oY9CHVL3t2dpNtXWG2IT1ZC6lc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl6J3gZ35XscGM6GWyf819ddrP2TyvDj73pzH8FHv0TO NvIsySio5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACYycS/D/5AzoYXax+UZE9RP zmFhfRh2ZdPu/b9fybyTmbVTqYZpfRvDPyMeRYYui/kSh4xcF657f4jrtktU4Y3zi9cm6a7rXpK uzAoA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit df12ef60c87b ("crypto: qce/sha - Do not modify scatterlist passed
along with request") removed the only use of sg_last, rendering the
scatterlist traversal useless. Remove it and its local variables.

Also remove the redundant hash_later check, inline the source offset,
and assign the number of complete blocks directly to req->nbytes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/sha.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 1b37121cbcdc..13a1174d2175 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -187,10 +187,8 @@ static int qce_ahash_update(struct ahash_request *req)
 	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
 	struct qce_device *qce = tmpl->qce;
-	struct scatterlist *sg_last, *sg;
-	unsigned int total, len;
+	unsigned int total;
 	unsigned int hash_later;
-	unsigned int nbytes;
 	unsigned int blocksize;
 
 	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
@@ -238,28 +236,8 @@ static int qce_ahash_update(struct ahash_request *req)
 	if (!hash_later)
 		hash_later = blocksize;
 
-	if (hash_later) {
-		unsigned int src_offset = req->nbytes - hash_later;
-		scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
-					 hash_later, 0);
-	}
-
-	/* here nbytes is multiple of blocksize */
-	nbytes = total - hash_later;
-
-	len = rctx->buflen;
-	sg = sg_last = req->src;
-
-	while (len < nbytes && sg) {
-		if (len + sg_dma_len(sg) > nbytes)
-			break;
-		len += sg_dma_len(sg);
-		sg_last = sg;
-		sg = sg_next(sg);
-	}
-
-	if (!sg_last)
-		return -EINVAL;
+	scatterwalk_map_and_copy(rctx->buf, req->src, req->nbytes - hash_later,
+				 hash_later, 0);
 
 	if (rctx->buflen) {
 		sg_init_table(rctx->sg, 2);
@@ -268,7 +246,8 @@ static int qce_ahash_update(struct ahash_request *req)
 		req->src = rctx->sg;
 	}
 
-	req->nbytes = nbytes;
+	/* hash only complete blocks */
+	req->nbytes = total - hash_later;
 	rctx->buflen = hash_later;
 
 	return qce->async_req_enqueue(tmpl->qce, &req->base);

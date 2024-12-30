Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F71C6BE;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=h8EPMTux2OhWAfkjIR3ug0S/7SxIOwKVadQ8MJqre90Tk8VmDDu5UKz7KkYkuxB1M8+UgmZ103DySWT6yU0vf74RxHBDIWKGZ26Q7Q2/grBBj5F19b3B2G0+3viUkaASKL5wQDXLxsMjaDyh+6Zbd1Ci55UX1mC4aKdCo98pRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRXEYUNT59oAN9wwc/sjiYBXjnNHtnceRsVAbpATaET/j2hGGleDFPhesz/PiHOuDQhScCPRGpQBvJp0I64jp+MPev46cJB33xWEfLSnTw02SR5pu+1qPEHD6NlJaqF8Eejiw2ByMksglh09ll0s9zx7uZ8oiK0NbRAYsvFQayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZNsQSLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZNsQSLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C8C4AF09;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517760;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZNsQSLBEhtVtXsdQNpvzY+pSL2sa2YCHygrnL583zTqrCQ6hNp7S7db+DOeNoTGW
	 QE+9H4IHjMVIFjsTUO0xTHpUU8ycs8XKQQiW36cnClsoOVNw4YMYmJUN3LHwAcGzjO
	 NpwpWVxnRZzoe5H4JE1rZ2gjMjeGVGdl0oaZde8R/nfvfHip+clVSK7Hcjkbtfiy6H
	 eaY25PT/Li0So3MOPPII+/V5RbTVoGEadBXOM5tsjSsKXI/eclSk7EItGGSW0PK9Al
	 NgZszWkFaMu4ecH7gmTJfJlkWvGRmsof5OkG/8hsRCThwkQsG47WIV9/9w/xKCNg1H
	 uwaMg10ij62cA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/29] crypto: skcipher - fold skcipher_walk_skcipher() into skcipher_walk_virt()
Date: Sun, 29 Dec 2024 16:13:54 -0800
Message-ID: <20241230001418.74739-6-ebiggers@kernel.org>
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

Fold skcipher_walk_skcipher() into skcipher_walk_virt() which is its
only remaining caller.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 98606def1bf9..17f4bc79ca8b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -304,23 +304,26 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 	walk->page = NULL;
 
 	return skcipher_walk_next(walk);
 }
 
-static int skcipher_walk_skcipher(struct skcipher_walk *walk,
-				  struct skcipher_request *req)
+int skcipher_walk_virt(struct skcipher_walk *walk,
+		       struct skcipher_request *req, bool atomic)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	int err = 0;
+
+	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 
 	if (unlikely(!walk->total))
-		return 0;
+		goto out;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
 	walk->flags &= ~SKCIPHER_WALK_SLEEP;
@@ -334,22 +337,12 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
 
-	return skcipher_walk_first(walk);
-}
-
-int skcipher_walk_virt(struct skcipher_walk *walk,
-		       struct skcipher_request *req, bool atomic)
-{
-	int err;
-
-	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
-
-	err = skcipher_walk_skcipher(walk, req);
-
+	err = skcipher_walk_first(walk);
+out:
 	walk->flags &= atomic ? ~SKCIPHER_WALK_SLEEP : ~0;
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
-- 
2.47.1


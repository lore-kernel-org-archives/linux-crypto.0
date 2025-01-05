Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B811BDA9B
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105696; cv=none; b=kvEGVHu8pc7gGAhSOdpaf3Ycwmp1te0aLkM6eJNWhY4266V1HstT5/c6X+xaGM1QxFGsOl4eMp3OFGdWvFLAgf1B1Nm6yoNvoQPKNqYH7GSSMCDPlgJRRkZ6MjgvHajm8TxrvtPhmYXcNS8S+nmFu8H/DJxyFrNGn+XFjc0TMaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105696; c=relaxed/simple;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zhn4PXVjM/Vjw4yy55Sp/0TzV1OxyFCNrBMiopr+sEHer2zr5gmtiW/k9f0yUMKe1PyXuBm6Q5DHYCb5uJLcur9XHfbU3z9aU6z17Pv5WBMa4JnnN+2ZjC6dUchAAJbaj6rIO70q2LIKi+SWi3Vamappl5EDYcjwbj0N68UB/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSgxh+32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSgxh+32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C588C4CED0
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105696;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BSgxh+323AK3OHoKZ8nbEWyciGj10VrBQanD8kP2jzJC2meQT3eqVIa5FXWTYwiXz
	 4ywUAkAyDc8gECUhSRfsWXZ8v0HlnL/eBigX1QpG0YOJwktKkgfu1EdYjJ3+nB0WgR
	 kjLxcEV8/IfCge2snfI1bQLrGVcaDfO83cRVzAC7YTBjhkdKaKaRAYJc79XdBLhqjO
	 p5JmCaaSTWn6Mz0GZvQNBFCj5kWlits4Eh1zS18tGbiMVltKc5v9fLoDcEr9nvocOr
	 so5pw8+IAOrbrEQT7JNYoR2tc67KLJFalTjVFMO/y4U0zQrktrKTXEyRMSiVBNtcnZ
	 3AwYAaoT0Yrkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 5/8] crypto: skcipher - fold skcipher_walk_skcipher() into skcipher_walk_virt()
Date: Sun,  5 Jan 2025 11:34:13 -0800
Message-ID: <20250105193416.36537-6-ebiggers@kernel.org>
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


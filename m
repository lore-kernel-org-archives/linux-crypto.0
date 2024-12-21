Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67D1F0E3E
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772292; cv=none; b=flr+4ZYoAMdX0wbRUnIFp3agVBQI5M0c8cu81eXVO7ZMGV8xzUmAnYTWjM73xnt3QWnRTxy3/H0KrynTnKQhZr7KlrbEkv/3/2nO6Za+baObnTinRvF53862uPYuHcxYDZyJh8lX1iEnhjANOKpvyZtCzpGlLlFQ5dyaek+ur+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772292; c=relaxed/simple;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crbycpq647uuqrA121LANiWhkv2uYs9jS6fWMuUlBYZPoox8502EaSr57zxn0X2QgHvOomd0RdwlmKC9iG7iNvv/VFsuQhFPkm3RJ2OXxiLG3h53YMeBIo7Oh8yJc0O/3RzGw+uKXVsnZxJ6ot64fGsB9IbqP0IDJxvd6Q8AZGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTtZvul3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTtZvul3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8AAC4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772291;
	bh=+GPayxh5RqGj7KlYP7lL3+3fPmB0J8TTLnx1xFmFjIM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jTtZvul3Qlt0h61Zmfs+ow+izgbhCTIGst5d3V/r2b1ANc8fwX1Z8mJhjn6Q7cyzn
	 MOQivlGVLIrDv6Vl8VnpIbuMFHwKkhH7sevKQlCKaTMTD3iPShO7xm5wzCqpAcDYbS
	 BeG2Ihvwe1Jzs60gvdiPXjcfSwgx+cmioIfVlE4aB276DyQyNNLzpOIadoq7XhHSQJ
	 NgJJwkiRbdnwoufm4B4qggg7Sex9TpgCKc7kPazilch+Mm3Epay5pG9HflAlewUr1v
	 +NvyWF6f4wsr5N6ynnb/PDxb6Rji7p9MiYo4GHJSTL4Ayfg5kShtZtm2791XC7QvTo
	 QHKLz+g3kyQyg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 05/29] crypto: skcipher - fold skcipher_walk_skcipher() into skcipher_walk_virt()
Date: Sat, 21 Dec 2024 01:10:32 -0800
Message-ID: <20241221091056.282098-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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


Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F36522FF2B
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747917696; cv=none; b=TD7kYWKKvAi92pcFm+8aYJJB5lBnw9Ak+g0Y3/o8XN8BNY4jwvta8mNVKbq/8Uu6zfv9+EAcOtYIRxRByFuO0S2da/GV60rDJdJxoxK4iYSuEGWPLl1+0LniTrjr1/9lXTNXiduCMtDnHl/BxsnlHHRHCxtkdkVwiJyxzfHcy5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747917696; c=relaxed/simple;
	bh=m9W/fTACyFo5tFJZEelL5+X2Rycy63PRQSQu6+yH0O4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kzF5rM0iAw6hPGZHq4UxpMw2Ylx4OhZl8CLVooRYgl7afGrrrI1pRIZTzBaMC1wm8C94zw1L421uYYNiiu4/bAkWJtq+Ufh/Q0wEmo0iheQNppFHPCLLf0sheZ4FzmT7rC6Y8dlOmtoHg2weBnJlT7cSmJznUqyuTTAXLeQ2SzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B8EpbUi6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B8EpbUi6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JCOa9TsWKorgl8hARvwPGx64juDx8SI7JWO7xDpfig4=; b=B8EpbUi60VzPiEFX3dyAn87RW6
	04laQxSU0zzuMOHmsJZ48teXfH3UNFfhNzfA+lVdNaP9uo64P7gpOug8pCK3UbSXrCTkdApCy5xVW
	LD24XZHGPfe7WTf/qlATsnjTIYzJthQmVUn7iZvjTp2q/lWJ6ZRZoEInucxVimwgx/HSd98jJ+ua3
	UfARm7P6l2b4NJnxNAqfy1xOuAjMFWQ5f8IkGAIz4xdOpO9s9KwzY8h3/ReQHyJmCOZ18GAk6e0ha
	swIMVqHT6Sr3IYYGYHhK06t98ZXTV/O0EsSQb9F3B0ToB50vcdFwA9/uOd7wU3Yux6CmaklRrt7il
	sXW2eyYw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI5Em-0085RW-1h;
	Thu, 22 May 2025 20:41:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 20:41:28 +0800
Date: Thu, 22 May 2025 20:41:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] crypto: marvell/cesa - Fix engine load inaccuracy
Message-ID: <aC8beMPbYr8XwFMC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If an error occurs during queueing the engine load will never be
decremented.  Fix this by moving the engine load adjustment into
the cleanup function.

Fixes: bf8f91e71192 ("crypto: marvell - Add load balancing between engines")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/marvell/cesa/cipher.c | 4 +++-
 drivers/crypto/marvell/cesa/hash.c   | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 48c5c8ea8c43..3fe0fd9226cf 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -75,9 +75,12 @@ mv_cesa_skcipher_dma_cleanup(struct skcipher_request *req)
 static inline void mv_cesa_skcipher_cleanup(struct skcipher_request *req)
 {
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_engine *engine = creq->base.engine;
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
 		mv_cesa_skcipher_dma_cleanup(req);
+
+	atomic_sub(req->cryptlen, &engine->load);
 }
 
 static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
@@ -212,7 +215,6 @@ mv_cesa_skcipher_complete(struct crypto_async_request *req)
 	struct mv_cesa_engine *engine = creq->base.engine;
 	unsigned int ivsize;
 
-	atomic_sub(skreq->cryptlen, &engine->load);
 	ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(skreq));
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 8b4a3f291926..5103d36cdfdb 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -110,9 +110,12 @@ static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
 static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_engine *engine = creq->base.engine;
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
 		mv_cesa_ahash_dma_cleanup(req);
+
+	atomic_sub(req->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
@@ -392,8 +395,6 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 			}
 		}
 	}
-
-	atomic_sub(ahashreq->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

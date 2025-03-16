Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CD019D881
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742118636; cv=none; b=dpfWW7gTDXRWc2gUDHJX9vdakL3JlxFYkdQ1OY/FPNNBHpDt/Jq0U6kJyR4UX6WcEHn24dBs9khDtcv5PxR1MYphYaNPQ82WPA7IdVfHGpzU4Jkm3jAJLWgOkq047yMcY5IvbEKbYm07v3c1dpkkzExMmikz4h94RgRVYpslqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742118636; c=relaxed/simple;
	bh=6xCFkV7v7sDy8YUiT2EWSjEfzqjXC6WDZphaNmhfwgQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=ZWLa1vydbLmqKvmgKRqnUR/T2RNlCt8cMQ43T3Tgvhzpwq9L4Aa8hOlONQ3AIaHgipUkL3IieJHGQaE7Hpx/+wBEsINkDDc6J02FI+MzOk7oTr5kPASMr2ajaZ82lqbOLb6p5ezhgSqQrme1S+1ZaXXTTrjiLY8vmYljBxC0rWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MSWUKWV0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MSWUKWV0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YiYbKlEevS2bTqkd6sOGvvxgDc6qLT8lAFTR6aIdSiI=; b=MSWUKWV0jCDzBPVnn0SbylydZ8
	SRl8jP54EfSi5D85akgpvNCf6FeH94BfsHxy0y71LWI7M7fBotZen+KJ+o2cWfs/h3zTocv7cVy1O
	y8Y+jDQssL8UBHG3QF033/5mzSO8Y6hsehXHyV3bqi5nVG5ZKeBl2Sm8O+P1Dm0Hrnoc8kUWqf9pF
	OTfDKxaSqH0inCjNC2Dv994+6eMPoQOEg+RXsAwczhHN3sikGNPSmoYc53UfZJN1xuOa/jnSaSyvT
	un8ad0ZQkmf3aDB/sVWyyDQThxvAS64p3tvsLLmiEMj4u/hWAd5MbvURXeNNFO/ky7TZwmY2IO4Db
	qhYWprpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttkdU-0071My-1G;
	Sun, 16 Mar 2025 17:50:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 17:50:24 +0800
Date: Sun, 16 Mar 2025 17:50:24 +0800
Message-Id: <256244bca7aff91e33804eac225e7c8e83d737a5.1742118507.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742118507.git.herbert@gondor.apana.org.au>
References: <cover.1742118507.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: api - Call crypto_alg_put in
 crypto_unregister_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Instead of calling cra_destroy by hand, call it through
crypto_alg_put so that the correct unwinding functions are called
through crypto_destroy_alg.

Fixes: 3d6979bf3bd5 ("crypto: api - Add cra_type->destroy hook")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e7a9a2ada2cf..ea9ed9580aa8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -464,8 +464,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
 		return;
 
-	if (alg->cra_destroy)
-		alg->cra_destroy(alg);
+	crypto_alg_put(alg);
 
 	crypto_remove_final(&list);
 }
-- 
2.39.5


Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E388C265CDD
	for <linux-crypto@vger.kernel.org>; Tue,  8 Apr 2025 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111437; cv=none; b=L6KhLDrg389X98FiQspGFajjexB+CKkGLwE4LKCDVtOScbeCuC0Ax5wMCm/G5Dao7mYOwLgRGs6tsnFJjsVwZrBtQiZWKJKMXLpUM8LOEIf/eG28+pul7S98Q+yNtYgywjP0G1wpgmRfiMgeDwFVF41vgRJ8uIp6nLSrTi8WcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111437; c=relaxed/simple;
	bh=f+Wuv/IwJUOYYGcMReN8qC3U1oqN3II4e7Hi+wV2rsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c126KEhIGsUYrh7OWo579uc6mZSOpchtK7bFO2QYWS5PD/ZcYMZvk48dJ1N+qY58la6jYB7PUs0qEyVCwSINaf4vNNrLQ3uDvCiIcugxTqenIEVHYiRKXhgM9jiOrZItP2rQt3yesyzE6UEjMowLlKgXKNeWNK+cAXcWrE5WRvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OQ1TN8Y7; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OQ1TN8Y7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744111423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3O7NNoX7C+wG3R/LFiqLgebTwHeyNEVO4BPSbjqxGi8=;
	b=OQ1TN8Y7fM3J6VZgBPcx6xjdY9yBurmU2lwzLpnbzhahXrMExiV5ZDwv7AVdfmcVl+1cxe
	bftQgOIjDuou+HaWjkNNYrXLnY5rSuanwa6KA1BExRke46pltoitsGkB/FB0hUB6WT3qbK
	UQCYCqD0cVQSx6u7Y6mDr7L8yVzc7fA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: essiv - Remove unnecessary strscpy() size argument
Date: Tue,  8 Apr 2025 13:22:59 +0200
Message-ID: <20250408112300.804656-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the destination buffer has a fixed length, strscpy() automatically
determines its size using sizeof() when the argument is omitted. This
makes the explicit size argument unnecessary - remove it.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/essiv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 1c00c3324058..9d6e72a2d2ae 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -549,8 +549,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	}
 
 	/* record the driver name so we can instantiate this exact algo later */
-	strscpy(ictx->shash_driver_name, hash_alg->base.cra_driver_name,
-		CRYPTO_MAX_ALG_NAME);
+	strscpy(ictx->shash_driver_name, hash_alg->base.cra_driver_name);
 
 	/* Instance fields */
 

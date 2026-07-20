Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9A13DE420
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784590061; cv=none; b=E9WoWgdV8smjRWaVljbjJOlX1lV7qQjwvU2oophTW/P7j+Mdp2JxEfPpQ78ciAzHvRA2T5ggV15ic9Dm+D5IFnTSJVktXxcbsCfih+K3x2NiRDwJ9N2T6ZyxhWfNHhUo1Ad+DKhXRLCXaQX3zAvQR1ZYvQ9/v8sRhaU4/4AzBAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784590061; c=relaxed/simple;
	bh=w5qJ5xKc6F0gLLloe/++ujKHZqOxbmoF7geFsTeso6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TaH1uDtBJhPQzoX6yqxsbEMXu1t5HE6mrZ+aanAtECoZt7npqrfTXCKSDYYhyPSq7pWMArl6uuPDNHnvA+dWVU6fA1qfsGGgrQAKYWmG+c5DyFfAR0h2fHdWhiMEhemkSbf0WOHbXBWuBD1GKj+8qH9cPq78hsS2S4cO/N5uBm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K17dJ8nB; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K17dJ8nB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784590057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/D51zmWb6cwAgaiE11RzcSwgENxkyqBDcdSlFWIeU94=;
	b=K17dJ8nB3ah54CiIfibUy0pK0AhsUdKb3JN7MUs4Sq/KVlmxep0vrfkMPrDjM6OxEPF1N6
	rM8sGM+1T+g+86tkyKrbwF/Gj5He8eMm6ebqIkA8EY3Xjvk8V00YALMwPqvUncrCQYvvR5
	3wFaTBO5i8iBqjh3WxqzHOLMItz7b8s=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - drop redundant variable in qce_skcipher_done
Date: Tue, 21 Jul 2026 01:27:17 +0200
Message-ID: <20260720232716.118402-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1299; i=thorsten.blum@linux.dev; h=from:subject; bh=w5qJ5xKc6F0gLLloe/++ujKHZqOxbmoF7geFsTeso6c=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlx667cneErX/Zuu/TDG1pvfwl7bMi4/kt068nnqWFla gkJPVxrO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAik5czMry81ytYzLz2/rU1 /5+836lisei0YuBh3lPsVyIVVPRS7u1g+Gf4UkSrmPe0zWzLorxVQR/mJMRwV0ycbx7wVM5Gbuf 8bmYA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove the local ret variable and return the result directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/skcipher.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index ffb334eb5b34..7e67d33fb48e 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -261,7 +261,6 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
 	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	int keylen;
-	int ret;
 
 	rctx->flags = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
@@ -299,9 +298,8 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 					      req->base.data);
 		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
 					   req->dst, req->cryptlen, req->iv);
-		ret = encrypt ? crypto_skcipher_encrypt(&rctx->fallback_req) :
-				crypto_skcipher_decrypt(&rctx->fallback_req);
-		return ret;
+		return encrypt ? crypto_skcipher_encrypt(&rctx->fallback_req) :
+				 crypto_skcipher_decrypt(&rctx->fallback_req);
 	}
 
 	return tmpl->qce->async_req_enqueue(tmpl->qce, &req->base);

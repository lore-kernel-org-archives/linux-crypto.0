Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B543A41D126
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493578; cv=none; b=rhhTFH8JpelIifl3CCgbWe3b6uBT7Oc8x8Ai+J6IpzNWeod9rLX3AUgkNd6PkPZe8W4oUAzyUgs83r7MDqfjXwiHI9bc3Q2kEaAahqrL28PD3uNfTXYxlLviQtufrfSxMEni3eAVa+rt55R7aaKlZ/UxATTNNV3bzWDyA82GHdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493578; c=relaxed/simple;
	bh=+RYwuPcztUJWVrWzRKyKcjvE8ZQUWgOz3uNH/CURof8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cznk5y3YZu0vHNGRt+5gKn6mKBsMT4QSNuRuUw3DXLFWYdGSa+bfZ0TV3ka3KJbZcB9YIb+iQKL6RPp/LQQC385THiVnDDPPCy9nomHSlUbqFT9o6p24kcTl9HuliyOS0u7QP7fnmnfwG2UKFO4UbPqd0EjSRw2ackIWKpzcPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vtC/c6cD; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vtC/c6cD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785493557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAWsiG9ahmxfNLiJBusvCQNaZdlCKs2PF/u6uSgvkJU=;
	b=vtC/c6cDKCtqHwYweALQuSJY0++vspZoiZxBrLN3G6w5F1jc9X3hUmS45KxrdJBTEuwlF6
	Xmuy2UlntgtT/I27cwmFa9tWQMiwzdK83/Im3oAszOBXFeImYBB0yn4Uactd8+kinUIoKi
	xg/qQnXft1lUiVze3XWdAb4Ctrrs7Mk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: qce - simplify qce_handle_request
Date: Fri, 31 Jul 2026 12:25:33 +0200
Message-ID: <20260731102532.742739-4-thorsten.blum@linux.dev>
In-Reply-To: <20260731102532.742739-3-thorsten.blum@linux.dev>
References: <20260731102532.742739-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=thorsten.blum@linux.dev; h=from:subject; bh=+RYwuPcztUJWVrWzRKyKcjvE8ZQUWgOz3uNH/CURof8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFk5FUpzHGauP9ceoOmld3nNDeF9Ew/UudZU7dz+eOvGh pieVWGWHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCR0CsM/70+y3hHqajt+Xg/ 5XVVxufva9sOHctpSX9WGfB03dXbVrMY/hl5hhr8qvF/Xrfn85agsANONgufd1WvZ/MOSpNO+3r UmgkA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Simplify the for loop's control flow and return the results directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index a848fd58a354..dc05f2b9d52e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -68,19 +68,17 @@ static int devm_qce_register_algs(struct qce_device *qce)
 
 static int qce_handle_request(struct crypto_async_request *async_req)
 {
-	int ret = -EINVAL, i;
+	int i;
 	const struct qce_algo_ops *ops;
 	u32 type = crypto_tfm_alg_type(async_req->tfm);
 
 	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
 		ops = qce_ops[i];
-		if (type != ops->type)
-			continue;
-		ret = ops->async_req_handle(async_req);
-		break;
+		if (type == ops->type)
+			return ops->async_req_handle(async_req);
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int qce_handle_queue(struct qce_device *qce,

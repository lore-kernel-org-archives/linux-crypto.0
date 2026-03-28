Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D625481B1
	for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2026 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774693282; cv=none; b=PXBJJsqXZQUbFgtZFS0vvAu/K/Nz9/962qoCvEGh332sjTuV/U9jmMjGN6d5ybevyYSAQ1Cr5i9ttZf/aEkBbh5yBgaRG2Gs3uUJx1/NBNqazHufNreDf+/w1doXm8D4cFo/5KiFjIHAFQigtnkmevj1Hb2r79DV1Zu7g9GcxQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774693282; c=relaxed/simple;
	bh=1bEosAyb2G9SF9aRuGiDLdH4mtrnH521LUc3mc+rdug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WUzjc+m5rHSjmcqf8i8nBHqJtgujVh8BZ7pmownIInXw7jz7qabOfLF6HavtOFg9QzL6/fchVppz5zjUmzwD7WhHwzTniCCgenogikSuirizFzOqQ13/U+jWRX9VkdnW2zCYii7V+v2OL1RzDXObypEDdjiTlF+ZWd37p77WXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WXRb3Ije; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WXRb3Ije"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774693279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WGJAK26HkOS6wvEvnaQqKmokeY/1/kxDcxhWPLIW6bs=;
	b=WXRb3IjeXF3q8f3+PWcywC01gi4SRQ646/ttmazDHnPVlaqH45MQcXAsuJFyWzk+1fBl+P
	D9HThbmTVNeXXWiiv+HVeWOesgrud6tPV1kFBqCElEsPmBdL70IN7yrWnQZGfQQ+ewu1j9
	gVdMy9xi2jslvXr7yQyIPkeMxhOklHc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: img-hash - use list_first_entry_or_null to simplify digest
Date: Sat, 28 Mar 2026 11:20:44 +0100
Message-ID: <20260328102043.85271-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1635; i=thorsten.blum@linux.dev; h=from:subject; bh=1bEosAyb2G9SF9aRuGiDLdH4mtrnH521LUc3mc+rdug=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnHV1cLaJ79orfCxspnhzrTrJzFtbMz1OQfTJc9YrPIK LX206uTHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRW6wMv9mPFzpX8HPyTrx7 7/ydVWmCLDPcFd7E++7Z+9bn+0ePiQ8Y/hcUP/8wQdbg6J+L2xz3LLlbajjn1P0w/iOHW/KqTmu WC3ICAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use list_first_entry_or_null() to simplify img_hash_digest() and remove
the now-unused local 'struct img_hash_dev *' variables. Use 'ctx->hdev'
when calling img_hash_handle_queue() instead of 'tctx->hdev'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/img-hash.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 7195c37dd102..f2d00b1d6b24 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -629,24 +629,15 @@ static int img_hash_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct img_hash_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
-	struct img_hash_dev *hdev = NULL;
-	struct img_hash_dev *tmp;
 	int err;
 
 	spin_lock(&img_hash.lock);
-	if (!tctx->hdev) {
-		list_for_each_entry(tmp, &img_hash.dev_list, list) {
-			hdev = tmp;
-			break;
-		}
-		tctx->hdev = hdev;
-
-	} else {
-		hdev = tctx->hdev;
-	}
-
+	if (!tctx->hdev)
+		tctx->hdev = list_first_entry_or_null(&img_hash.dev_list,
+						      struct img_hash_dev, list);
+	ctx->hdev = tctx->hdev;
 	spin_unlock(&img_hash.lock);
-	ctx->hdev = hdev;
+
 	ctx->flags = 0;
 	ctx->digsize = crypto_ahash_digestsize(tfm);
 
@@ -675,7 +666,7 @@ static int img_hash_digest(struct ahash_request *req)
 	ctx->sgfirst = req->src;
 	ctx->nents = sg_nents(ctx->sg);
 
-	err = img_hash_handle_queue(tctx->hdev, req);
+	err = img_hash_handle_queue(ctx->hdev, req);
 
 	return err;
 }

Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA71D6DC5;
	Wed, 19 Feb 2025 11:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739963611; cv=none; b=O4j+L5pU5rtTiqTaduDY2dAJQK7ACqLlRE4Qvd8aCRHQ1cIW32DW4d6nNo5NBP1NM3TA85iRvApVvlvA23/x2yccJf1tf9zXs2dvlpFS+bOGf8BlWimTLR1jCDTsdZDxjVabXyqF58Z0yoN2zJ/gBOCJvB+MV521lA54j2o9j3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739963611; c=relaxed/simple;
	bh=mlCF+3bzZOAa8f3gAfZzRMJclFUXFMrrk4oBZGG7YHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qkAPg6S05qLCKfoWH71uoN48hPECmKi+2xdDOLCSMlp3jYCRT7+ehDBKGo5SnmqiaN/ZwZJFn04VC3Tz8NFgy1hcLXbtIgPoFaaV/w4/uiWN5hITFHm99/j2NyGxfFSSJ4ZVUZQ2GWUo5puj4OVbNTz/0sjMBPgrluituFnT+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QeM4Fcg/; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QeM4Fcg/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739963606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Brim4R+j1jrxpbFoMdiijr4HsKQ5qnKt7XsTd8hfjR4=;
	b=QeM4Fcg/by7mp4kHFyP5H0V6yq29ZO+igAYVxIOoy6HGJPMN/JgJ5kxDrhnhzZ5BUr/KKx
	W7zlWk6GRTVw3+biryCrIZ+4BewA5MBGKP8l0IryPYb0pJWbiavXnuovEgRKaJUxgZT8gZ
	OHmIR86aih48DwtAdNmTQK0U+qKlen8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] crypto: bcm - set memory to zero only once
Date: Wed, 19 Feb 2025 12:12:53 +0100
Message-ID: <20250219111254.2654-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use kmalloc_array() instead of kcalloc() because sg_init_table() already
sets the memory to zero. This avoids zeroing the memory twice.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/bcm/cipher.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 9e6798efbfb7..d4da2b5b595f 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -140,8 +140,8 @@ spu_skcipher_rx_sg_create(struct brcm_message *mssg,
 	struct iproc_ctx_s *ctx = rctx->ctx;
 	u32 datalen;		/* Number of bytes of response data expected */
 
-	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.dst = kmalloc_array(rx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (!mssg->spu.dst)
 		return -ENOMEM;
 
@@ -204,8 +204,8 @@ spu_skcipher_tx_sg_create(struct brcm_message *mssg,
 	u32 datalen;		/* Number of bytes of response data expected */
 	u32 stat_len;
 
-	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.src = kmalloc_array(tx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (unlikely(!mssg->spu.src))
 		return -ENOMEM;
 
@@ -531,8 +531,8 @@ spu_ahash_rx_sg_create(struct brcm_message *mssg,
 	struct scatterlist *sg;	/* used to build sgs in mbox message */
 	struct iproc_ctx_s *ctx = rctx->ctx;
 
-	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.dst = kmalloc_array(rx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (!mssg->spu.dst)
 		return -ENOMEM;
 
@@ -586,8 +586,8 @@ spu_ahash_tx_sg_create(struct brcm_message *mssg,
 	u32 datalen;		/* Number of bytes of response data expected */
 	u32 stat_len;
 
-	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.src = kmalloc_array(tx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (!mssg->spu.src)
 		return -ENOMEM;
 
@@ -1076,8 +1076,8 @@ static int spu_aead_rx_sg_create(struct brcm_message *mssg,
 		/* have to catch gcm pad in separate buffer */
 		rx_frag_num++;
 
-	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.dst = kmalloc_array(rx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (!mssg->spu.dst)
 		return -ENOMEM;
 
@@ -1178,8 +1178,8 @@ static int spu_aead_tx_sg_create(struct brcm_message *mssg,
 	u32 assoc_offset = 0;
 	u32 stat_len;
 
-	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
-				rctx->gfp);
+	mssg->spu.src = kmalloc_array(tx_frag_num, sizeof(struct scatterlist),
+				      rctx->gfp);
 	if (!mssg->spu.src)
 		return -ENOMEM;
 
-- 
2.48.1


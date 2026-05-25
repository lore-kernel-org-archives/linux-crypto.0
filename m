Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D933DD513
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779701394; cv=none; b=he5y0SP3x0P9Vdy7fJuCtxYT6kYahhGiOB4UheB+rQSy/7Eogy4MAAorjYyrh950oMwNEqjiEVZll6TRRCOM273g6Bj8T5EuubY8tWdAJKFydV3NXwJHFOhGyY1GM+blBNax6nQTswUfkT7i29VbfXoIxQ1sW8zPjTkFqhjNPbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779701394; c=relaxed/simple;
	bh=SEl/cCMi3V88T8oWrb1dqIYukSYT2552y/KDghxa6vs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gqT4LptwZiO5DertrRsEVWHlMmTVtbpKtS7Rr9sm1yTkl886SlFBIJUBGZsOu/3t1DqHU4UShmNpW9B6OTgC4ob1Pw6Z3YYubu64ryV8MKX/mOnWKjc/FgSI5fZUSJSRanE8J580xgdXfJiUPOQRL5OrSo3hI5x+K7UBnnEashA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hq9jdm3/; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hq9jdm3/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779701381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JBpTnc6Vg1sT2IJHGJXZ56PItXX8oc35dSxpvsG5u9w=;
	b=Hq9jdm3/aj/81csrO6lBPgm49lR7+GttRiZj2coI7HJ18Kb8i1vcG9DmjHlxSEDAnRgYWy
	F2iRPFCiJCEKnp1KQn8mp+a8aOTsdbu9TvYG5p6Am5wrnqAYRuNsYkryFHqKTxCcuGlMbi
	2bXc/tQVbTKwuHOJ+YfoA9i3B9wG+VA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-tdes - use min3 to simplify sg_copy and crypt_start
Date: Mon, 25 May 2026 11:29:27 +0200
Message-ID: <20260525092927.818586-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1249; i=thorsten.blum@linux.dev; h=from:subject; bh=SEl/cCMi3V88T8oWrb1dqIYukSYT2552y/KDghxa6vs=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkiYuWqAqqlv9oj3eQXnbRuZShblu91X+mIw1+7y62xK 959FXXoKGVhEONikBVTZHkw68cM39Kayk0mETth5rAygQxh4OIUgIksMGb4Z8RTOnffp8jUS4pv n+2of7IkuDHdbOZ2Ho4b8ltnrvx9O4yR4ZbNhq1Lz+hfumI13W3Fl13Jpyz2zp6i8GS7n4T1Jfv TBUwA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace multiple min() and min_t() calls with min3() to simplify the
code. Using min3() instead of min_t() in atmel_tdes_crypt_start() is
safe since the values are all unsigned and compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-tdes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 643e507f9c02..834c6d3e1b06 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -143,8 +143,7 @@ static int atmel_tdes_sg_copy(struct scatterlist **sg, size_t *offset,
 	size_t count, off = 0;
 
 	while (buflen && total) {
-		count = min((*sg)->length - *offset, total);
-		count = min(count, buflen);
+		count = min3((*sg)->length - *offset, total, buflen);
 
 		if (!count)
 			return off;
@@ -469,8 +468,8 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 
 
 	if (fast)  {
-		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
-		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
+		count = min3(sg_dma_len(dd->in_sg), sg_dma_len(dd->out_sg),
+			     dd->total);
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {

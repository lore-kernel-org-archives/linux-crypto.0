Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862435DA69
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350269; cv=none; b=lKTfVaGaNotvrDh2kv5pz7BFNJ6yl7yUWuW7uYKnO2DQ04YB2AdrnXA8tofGJgNmwGF0Q3LLH3Htbg6ZIDvv+JCILb5RkzH2j/cHacYasmfPFGipSQNuD78nJmOz7WBu/nrP/YRA6N50kbMoObhXqAfl9tszdO/LrNO1gmlViKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350269; c=relaxed/simple;
	bh=jaN5zpYZLFMe2vpwb1ZAOmwVYIY0XjcWc/CpoBvBlD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rUEYrIB23emjPMMRbMU08UYZN9Osi0J31EIrU2IWBvFWZuSyDXKv0SbLCNImYErY60NXXRvh6QiK4fpGeLNE3TB0K+THtQAnZP5q/C1IfXbSMv+1PuWaJNCx4wPg8HDLPh6p2LgVt9M5Ux1ZJ1W4EaS1Uufl45avjwREDvsawLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sdQE8Eoa; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sdQE8Eoa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783350264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WLGW09LnZSqYVDwzaVkwBn6CEBapAxlFThv6OXq+CBw=;
	b=sdQE8Eoa5wacO+0yAruFzmI8tmzkx9scFMszeEm7a6R1mp7Wi3KMj4Ovn5mcA3U0tPWGa/
	7eRpYeCpkUstJdt77qOmytnC0mrtXyiK62XYWNgBUOBqW/60RlGrk2JX+8phYjUJhVDmma
	of93cnt1JfeFmrSihH5twGv66Oclems=
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
Subject: [PATCH 1/4] crypto: atmel-tdes - simplify fast path in crypt_start
Date: Mon,  6 Jul 2026 17:04:05 +0200
Message-ID: <20260706150404.382209-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1597; i=thorsten.blum@linux.dev; h=from:subject; bh=jaN5zpYZLFMe2vpwb1ZAOmwVYIY0XjcWc/CpoBvBlD8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFneh5+sO2mmss1f6IQ969ru8Ju2qSp3N309xMW2xqXm/ cFdXWG7O0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAidhsY/vtMEov9/erqsWTj EgnhtlmRqyobfT34Fq2crroque7mHE2Gf6afV+874qi8mnFF664r4Q4L/F888Zo4b4VG9LHQH/u k1vEDAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fold all fast path conditions into a single boolean expression and drop
any redundant checks.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-tdes.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index d380f6741a2c..d9cc4f657481 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -451,25 +451,19 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 
 static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 {
-	int err, fast = 0, in, out;
+	bool fast;
+	int err;
 	size_t count;
 	dma_addr_t addr_in, addr_out;
 
-	if ((!dd->in_offset) && (!dd->out_offset)) {
-		/* check for alignment */
-		in = IS_ALIGNED((u32)dd->in_sg->offset, sizeof(u32)) &&
-			IS_ALIGNED(dd->in_sg->length, dd->ctx->block_size);
-		out = IS_ALIGNED((u32)dd->out_sg->offset, sizeof(u32)) &&
-			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
-		fast = in && out;
-
-		if (dd->in_sg->length != dd->out_sg->length)
-			fast = 0;
-	}
-
+	fast = !dd->in_offset && !dd->out_offset &&
+		dd->in_sg->length == dd->out_sg->length &&
+		IS_ALIGNED(dd->in_sg->offset, sizeof(u32)) &&
+		IS_ALIGNED(dd->out_sg->offset, sizeof(u32)) &&
+		IS_ALIGNED(dd->in_sg->length, dd->ctx->block_size);
 
-	if (fast)  {
-		count = min_t(size_t, dd->total, dd->in_sg->length);
+	if (fast) {
+		count = min(dd->total, dd->in_sg->length);
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {

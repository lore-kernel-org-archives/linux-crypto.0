Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CD93822B5
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350272; cv=none; b=Rv9tFbRynlbHQFnK+vl37X7rMilMJf5Z1ek7wO/th67jI5rsrW2OLQ7lHttNeGu6mzyt67dNGNNO6/d5Y0EFFbUc6kZyR8h0ToFHqID2PkoiNeWVhGjGFCHYw3M2iIGK93DLnDwfPrAUP0A/28W4c2JOrYG0COHw+DhzBsVFVeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350272; c=relaxed/simple;
	bh=aRTU0Pz0l2SI7rKA3ZcbUXQZTrEpcGwDLfpgewgeVik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhuJainYk2Z8ECaDt7Us9BpdAz17Vp6fNjnYRA7TJK8ohD7C2NW0rDR7M5snklCJPB0wzBT8I4XR/8y8s0sS0LZQuCkJLyF82YWxsXAOunMreqnjlJSJ34lSJMJ03AzIGN9jnkaEYP7NoiTpdU2Z/u4kkyiCQGkdaa04VQpFzIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dJ60a06S; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dJ60a06S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783350268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k8aPrpA9qH3mYBu4qEShT9xwHObH4PLttv2y/ISyUVc=;
	b=dJ60a06SWG3sF6UKFPGkozhxbifOBNCec5lE7M2Y7jxpDCmAINFagn/n7Ssa+wVSSWdvmU
	qenL0ElrwKw8qrgNe92RazVp9Pe2rSfTC2LHq7GchBHZtkbUnVAXobtZKS/MIEedgqKtjY
	YjVw5KmfR/wUHpgl3v0qr9+AD+l7/Pk=
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
Subject: [PATCH 3/4] crypto: atmel-tdes - drop redundant return variable in crypt_pdc_stop
Date: Mon,  6 Jul 2026 17:04:07 +0200
Message-ID: <20260706150404.382209-7-thorsten.blum@linux.dev>
In-Reply-To: <20260706150404.382209-5-thorsten.blum@linux.dev>
References: <20260706150404.382209-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; i=thorsten.blum@linux.dev; h=from:subject; bh=aRTU0Pz0l2SI7rKA3ZcbUXQZTrEpcGwDLfpgewgeVik=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFneh58+rNiwc2+v44v7++8lTD5qJfv9n58C8w67NWd+x Ks8u5ac2FHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATqZ7HyPBq0omGQsupYlsk lFi/VpyfWWGsGdN2bm3hiX+vzxZ7n5Bh+Kd/88ee0zHpf2ba3Jq52fawvMul2gDnBcfWuF49yjQ j7TIvAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In atmel_tdes_crypt_pdc_stop(), remove the redundant return variable and
return the error directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-tdes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 32f0acae46e3..00a0b9694a26 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -285,7 +285,6 @@ static int atmel_tdes_write_ctrl(struct atmel_tdes_dev *dd)
 
 static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
 {
-	int err = 0;
 	size_t count;
 
 	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
@@ -297,16 +296,15 @@ static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
 		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
 					dd->dma_size, DMA_FROM_DEVICE);
 
-		/* copy data */
 		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 		if (count != dd->dma_size) {
-			err = -EINVAL;
 			dev_dbg(dd->dev, "not all data converted: %zu\n", count);
+			return -EINVAL;
 		}
 	}
 
-	return err;
+	return 0;
 }
 
 static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)

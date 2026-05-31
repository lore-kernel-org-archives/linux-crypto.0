Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78331A9FA0
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 20:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780260171; cv=none; b=iHL+VrHT2syQr+lfmsH+7CFw4ENDYl8H+7T+YbpcvHhtmGYUSdW5U0VkHd0n2ATNAcGomx7KyCdyPUAvZLGlh7t73Ip+qoFxdx4SDcKFXwxcPyouH3efHLz35KQYvldAiAAHZHSuCul3OetTxQJ4e6PpzhDkcWpN4eJscqCEABg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780260171; c=relaxed/simple;
	bh=K9rdvMtrnZVho4l72+9X4eVyV5teUZKLUUzsbCLc2Os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eeRNLgVCgJs+PIaX/VdpASPxBjrsB1RMjVMj8SWD9SrkL4DhnCaXqggcxIB8ar/e+n2GwGbvSYNmJ2tj6wj5UC43whFhMZSiaKdq5NN4hwaFEjd8Zvf3rG36RkbuAj+kOaUz6yljXCH/kJ0RK7Ruurj/qmxAlosL7BowP88ne2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rtRbvVNt; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rtRbvVNt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780260167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IBZfgEBkACCVPCY7cmNFU2XJMM4Oc8OiZa4+OutXhL4=;
	b=rtRbvVNt/FVTtFQI8eay7CtAJiC+YH8+qMSrnGE5bJsNcddDC+kHU/ZtB+2BlHiFt1OhPa
	D86IaCSZ4+acAqIFkgfp1FlCwLFQM5AW4AjMdfVtHyGDkwK2Mo0M+AVTTOzs0MYnrVw8EF
	sdwZ7kkPjRdOsgZN25qhy7ZJPiQTWLM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Royer <nicolas@eukrea.com>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Sun, 31 May 2026 22:41:17 +0200
Message-ID: <20260531204115.689052-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=thorsten.blum@linux.dev; h=from:subject; bh=K9rdvMtrnZVho4l72+9X4eVyV5teUZKLUUzsbCLc2Os=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkyc14zLOBhNjCuaTd/pfVb4pHF3gns6/kMd7At6zi+b ZPuHJ57HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJrAhXJwCMJG2Iob/BR/25Lx+13xjwXmn BQlPbz2dW7NcJj9/V3tMpI5wjbvOS4Z/asytH2LqD0e5LTKMs4vaF3Wj4r/r1Tk7U/LYT+z5NyO MHwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Using sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, atmel_tdes_crypt_start() uses it before mapping
to compare input/output lengths and to compute the transfer count.

Use the original scatterlist lengths before DMA mapping to avoid reading
stale or uninitialized DMA lengths when CONFIG_NEED_SG_DMA_LENGTH=y.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-tdes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 643e507f9c02..0d62b24e9fc7 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -463,14 +463,14 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
 		fast = in && out;
 
-		if (sg_dma_len(dd->in_sg) != sg_dma_len(dd->out_sg))
+		if (dd->in_sg->length != dd->out_sg->length)
 			fast = 0;
 	}
 
 
 	if (fast)  {
-		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
-		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
+		count = min_t(size_t, dd->total, dd->in_sg->length);
+		count = min_t(size_t, count, dd->out_sg->length);
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {

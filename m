Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCA3C0617
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174260; cv=none; b=rRaAlVsZ44HWLWAFX4ClTtI1mG4mmpet2s9eTatcGc3oQoojzS7xEWwYSGFssOGw5y9xvZ5Z1KKWUyt8iaj96NWd0fbY3t/UG85weYC1domdO2AhtQpgq6PJWxSNcP6qmuGF+/82LwWdAZDVkcbIfOFVhiXQDNOJhz53AnFdzCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174260; c=relaxed/simple;
	bh=PoU866BV1nxWHRqy1pEpQ1dAssx7wsivtGO6ug6vq4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ttzeXzs67W0SbZG6VNntzj98Mg4K26NRai+r7Bh4ae5NyxPF+Ug6TAL4jdmvRGtDWUKOhA5XhLiDpRvzDziKmnsy8344WzklhVjTzkV8Y36Lgo7jT3wg2PIRMtGhF2sQRXlD5qA06NJBeCgWEntJQBy6327p3jI1Ri8gBPGjm84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vcGNjb83; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vcGNjb83"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781174256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lK7aLsQ2vNUC+sXFqJ54lH3wydevJb7dJsdehGeIZEU=;
	b=vcGNjb83OZRkvsvEjhdO3LYqqECTqMwfwPCNW/Q2Eu/Gl+S7nDf5tjGFwgpy4WaCr08fQ7
	tfyLzBuu5xZNXEi7ViodOHO1mMO/tnWgMEo6kc8rhGrz46YOGlv02xkhm0inJtnOIsYVRh
	fR6Ijg7efwr6kqA33vW9SVMNkTZFV+o=
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
Subject: [PATCH v2] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Thu, 11 Jun 2026 12:36:35 +0200
Message-ID: <20260611103633.458381-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1744; i=thorsten.blum@linux.dev; h=from:subject; bh=PoU866BV1nxWHRqy1pEpQ1dAssx7wsivtGO6ug6vq4E=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFla/Rsv3EzsPK6hbzoz1dlOUOKt/hGBavmFSrX8Svdzu p7tmxrXUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABOR6WNkmFbyfNavxZNdta9J uB6+Wz7//PsGP1/1zV2vFdZtmrj9aw/D/9qVaY6mwatklz81K/fO2mvqm/7B4r7x2ZA1a+12fe/ fzA8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Using sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, atmel_tdes_crypt_start() uses it before mapping
to compare input/output lengths and to compute the transfer count.

Use the original scatterlist lengths before DMA mapping to avoid reading
stale or uninitialized DMA lengths when CONFIG_NEED_SG_DMA_LENGTH=y.

Drop the output scatterlist length in the fast path since it is equal to
->in_sg->length and does not change the transfer count.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Drop ->out_sg->length in the fast path (Herbert)
- v1: https://lore.kernel.org/lkml/20260531204115.689052-3-thorsten.blum@linux.dev/
---
 drivers/crypto/atmel-tdes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 643e507f9c02..d380f6741a2c 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -463,14 +463,13 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
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
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {

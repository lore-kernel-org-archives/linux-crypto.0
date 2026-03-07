Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3072D274641
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 15:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772897523; cv=none; b=ZVV8FAfQEfutBSwjMHaeuL+ycQ2q635ocTKqLZ1pVnG6ACUvJmcjMtGTfV7ps2V+1DZaaIuPB9rWgYbdr8poMjMKMGIqu6ROaMl9kDMZYHsAPlABt/oudJmKX+YulV+bknC9f2TSgm18M6CKuwA+gmivsave8f9knez2/+GyZcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772897523; c=relaxed/simple;
	bh=12uNODLktx6BEfkMaGGtrq9ZKRAKF85Ng0piF3rogU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mrajeeiFsD3iCI9XNDUaKsYa2VHemFbsb2CoBQV0V3zZ6b39WUjDXXUeEMJLk6/eWAwd9GmWYaOZdJg81uDiEXO+TRxM+nRaYgzKlIFMPA0OMltkVkCy/U91SSMWkBywLjYymnEGcdznvFU0M93TbcZWNZaZ3O42nmkzNfbgaD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uVARBis+; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uVARBis+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772897510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WCkjlMOHTdO7UOxucKf2A+R16ZfIHUwM/0MaXiSsIN4=;
	b=uVARBis+gT927/YxV8BaJDN81E2SICI9F76QBhCWq94eRk8hxiuEuD1McgUcyCOczUm5TE
	IHSNJyLVMkvSf++yawmVaBO5XYZyv+DarnbjyVhWWOWzc4J4CGF0kj8mYyybQ81UMsn9OL
	C6ILaD6SCar5i72ubQHBkIJ/x1ELH20=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Nicolas Royer <nicolas@eukrea.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-tdes - fix DMA sync direction
Date: Sat,  7 Mar 2026 16:31:10 +0100
Message-ID: <20260307153109.321147-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1847; i=thorsten.blum@linux.dev; h=from:subject; bh=12uNODLktx6BEfkMaGGtrq9ZKRAKF85Ng0piF3rogU0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJlrXPZ+vaQmmt7/c0Na2mPHlOvzvgWs+rpIIjLpd3FW3 ysLlSKzjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZhISyIjQ7O8+/O89zbth+e1 Hpp0cKvQ8+LaGUsjfuo83rbUa+75Z9cY/spOYlrM439627n1igGyTz98On/91hqRKcHFUje77pz mC2cAAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Before DMA output is consumed by the CPU, ->dma_addr_out must be synced
with dma_sync_single_for_cpu() instead of dma_sync_single_for_device().
Using the wrong direction can return stale cache data on non-coherent
platforms.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-tdes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 278c0df3c92f..643e507f9c02 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -294,8 +294,8 @@ static int atmel_tdes_crypt_pdc_stop(struct atmel_tdes_dev *dd)
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 	} else {
-		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-					   dd->dma_size, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+					dd->dma_size, DMA_FROM_DEVICE);
 
 		/* copy data */
 		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
@@ -619,8 +619,8 @@ static int atmel_tdes_crypt_dma_stop(struct atmel_tdes_dev *dd)
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+						dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
 			count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


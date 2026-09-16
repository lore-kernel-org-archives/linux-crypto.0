Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B587B4BA1CB;
	Wed, 16 Sep 2026 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579100; cv=none; b=rTA5nm6q4hqiU7SkCKZ0YwCbZD7VMZsIp9aCil/whjshb4mccVgU40QBxslcFXSWAniW+cFdy9wiMOkycV6o1sPP+HJbJEhP7sNXzzj72hiK0zzj51nbUZiCcNgqt7QJ49y5CxX6XXq4FAbkm3IKn84aJfC/Xoabs4kQS5lTrKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579100; c=relaxed/simple;
	bh=DaBVA3N71vqKpGjHJAcjR2l/h6S2sDfGJ/Uj6I9QoeM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKYNcNlfwCeYpdmwLYVZPGg1LNrHCR3tr+UuGWZInLZS4ardQllmgllndw0M3N3kQCW7zUHOLp+hQWdULeA4X3G9UnwTKLR3WymuzenOjBv0/3W8oK0uspAR1UVxUaJVDbNlb0DxFPQcClbQyoCkJnW3+LOjmbbvZ2UlADp25Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TImKmxgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TImKmxgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C701F000FF;
	Wed, 16 Sep 2026 17:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789579099;
	bh=rrxZXW0JV2dcAfSA/va77c8vfQZoNVpDQV381429spE=;
	h=From:To:Cc:Subject:Date;
	b=TImKmxgxeqTplqpkackbdVNFITpWZKLKh/DNeGShhOy6QYYe7Zy9eUFcKXcSCQqs4
	 mxgwxItHRnlXDjnASa31x/X28o+arPDfl2I59etmVicFnylFpYvghavr1ug53WaQY6
	 NVjV/BwaBCWajQ8rVHPFnIogpD/Mds6pq1B1MvTK/qWAUSnuXauo3bDi2eETcBVVKH
	 t+1cBNYP+cfvpMuEMilM9rpicCByvQv+ZDTiRf+u9tRcOIgspxcQ0I28AM3nFSTHAe
	 ibZo1urlOz55O6RkYPXkA8Y+Rm+hG5fBSfB7lO7/0BRiFtxcqBiXvfY7OYsaBN7NLV
	 Pg0LgAq9AMopw==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-tdes - consolidate transfer setup
Date: Wed, 16 Sep 2026 19:17:01 +0200
Message-ID: <20260916171659.129009-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3344; i=blum@kernel.org; h=from:subject; bh=DaBVA3N71vqKpGjHJAcjR2l/h6S2sDfGJ/Uj6I9QoeM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmrznM/ldI4OuXMCrX0taa7eRLy4/PKppovveNWtuTWh IXFVafzO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi9yMY/nD8uf37150LrwLV zv/9uyFWKzSQtXLL2dMrXDVFGEqu3elmZHjnqy2doXtCOPd1w3PeapV2Fs3SVxWMD/cVdUc+OPW jlB0A
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma() store the transfer
length in dd->dma_size and synchronize the bounce buffers before a slow
transfer.

Move the shared code to atmel_tdes_crypt_start() and use dd->dma_size in
atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma() instead of passing the
length separately.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 40 ++++++++++++-------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 53150f9b169b..f084fda42423 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -349,20 +349,9 @@ static void atmel_tdes_buff_cleanup(struct atmel_tdes_dev *dd)
 
 static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 				dma_addr_t dma_addr_in,
-				dma_addr_t dma_addr_out, int length)
+				dma_addr_t dma_addr_out)
 {
-	int len32;
-
-	dd->dma_size = length;
-
-	if (!(dd->flags & TDES_FLAGS_FAST)) {
-		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
-					   DMA_TO_DEVICE);
-		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
-					   DMA_FROM_DEVICE);
-	}
-
-	len32 = DIV_ROUND_UP(length, sizeof(u32));
+	u32 len32 = DIV_ROUND_UP(dd->dma_size, sizeof(u32));
 
 	atmel_tdes_write(dd, TDES_PTCR, TDES_PTCR_TXTDIS|TDES_PTCR_RXTDIS);
 	atmel_tdes_write(dd, TDES_TPR, dma_addr_in);
@@ -381,21 +370,12 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 
 static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 				dma_addr_t dma_addr_in,
-				dma_addr_t dma_addr_out, int length)
+				dma_addr_t dma_addr_out)
 {
 	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
 	enum dma_slave_buswidth addr_width;
 
-	dd->dma_size = length;
-
-	if (!(dd->flags & TDES_FLAGS_FAST)) {
-		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
-					   DMA_TO_DEVICE);
-		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
-					   DMA_FROM_DEVICE);
-	}
-
 	addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	dd->dma_lch_in.dma_conf.dst_addr_width = addr_width;
@@ -408,11 +388,11 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 
 	sg_init_table(&sg[0], 1);
 	sg_dma_address(&sg[0]) = dma_addr_in;
-	sg_dma_len(&sg[0]) = length;
+	sg_dma_len(&sg[0]) = dd->dma_size;
 
 	sg_init_table(&sg[1], 1);
 	sg_dma_address(&sg[1]) = dma_addr_out;
-	sg_dma_len(&sg[1]) = length;
+	sg_dma_len(&sg[1]) = dd->dma_size;
 
 	in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, &sg[0],
 				1, DMA_MEM_TO_DEV,
@@ -486,11 +466,17 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 	}
 
 	dd->total -= count;
+	dd->dma_size = count;
+
+	if (!fast) {
+		dma_sync_single_for_device(dd->dev, addr_in, dd->dma_size, DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, addr_out, dd->dma_size, DMA_FROM_DEVICE);
+	}
 
 	if (dd->caps.has_dma)
-		err = atmel_tdes_crypt_dma(dd, addr_in, addr_out, count);
+		err = atmel_tdes_crypt_dma(dd, addr_in, addr_out);
 	else
-		err = atmel_tdes_crypt_pdc(dd, addr_in, addr_out, count);
+		err = atmel_tdes_crypt_pdc(dd, addr_in, addr_out);
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);

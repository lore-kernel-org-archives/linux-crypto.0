Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8053C3F75;
	Sun, 11 Oct 2026 13:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724570; cv=none; b=o0Yyb4hRPHM9AKgualAfROgnQ7U2+8l74lxQEL9bNE4VSowFl+K/bHQasI91YPfe0ugq2BvXTLvwGrFdd9gZwcKEC+kkBoTpwjkclIopPNgYTYATKNHoRcrekkJRQj5ZaGrw0+SjOr9dU2ATsegnXiPX9SqO0eg4wHiVrwA0Mv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724570; c=relaxed/simple;
	bh=LYA+J9EZ6m00iu05nhNXfVsJujNa0NBCAOl4b0E9LRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oY1iPLBcFdqXGL5uI6A+Fr8N7lzGVlHgJfIsbKyXWROzTsoyPKBb6eiMpXZ2eX6y0rzQwGowC7cjuxTwJbaWvTS6OP9dkzf1T/8z+TK7780PaWyqN2U5IB1czfuYn79o36EUIKlflW3jjB4XymUcUSL0L+ssa4Py18Zp6SWjGmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUStyhho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUStyhho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C19C1F0089B;
	Sun, 11 Oct 2026 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791724568;
	bh=41iFOT4c+Si/tmuMIJ//dDysW1MpGxzWZ9qlBe4vW7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUStyhhoyvjQKu1xPpKjXN65RTARXvQK4Xl96Y/fNaspzRkRJ4T0I1VklLZHwazvJ
	 qxgxwIgUXfPgSkGmXEccoGFQOcYb/lBLnWM+eCqwzu2euTJgvcg9fusMXuF/VrkutY
	 32CGCm2xmJII0LXsgJOEsmxBti5DCnaFy+Fk3sT/TY21bOHcRN04KiMSB55JysUBpM
	 he9fLrOWg+AhyNqROY0glyb5ZJCpIQGfTom//w+qYApLLczgmS3Nh465PCErJlLlLK
	 pRe8LsszvtgZ715dmgva0A7C/OPzc9qiHlmtJx8yRP+g1p5cjBCQCWzKHAOrJK6hiL
	 0Mp1XEziKmEaw==
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
Subject: [PATCH 3/3] crypto: atmel-tdes - consolidate error paths in atmel_tdes_dma_init()
Date: Sun, 11 Oct 2026 15:15:58 +0200
Message-ID: <20261011131556.272382-6-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011131556.272382-4-blum@kernel.org>
References: <20261011131556.272382-4-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1337; i=blum@kernel.org; h=from:subject; bh=LYA+J9EZ6m00iu05nhNXfVsJujNa0NBCAOl4b0E9LRI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmne3jV98lV3dqdGXW3fn9zgPUmITXZyDm/S3bGxj32v puxcO7JjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAbiICsN/R01mVeHMtOlZU/ln FV9YtOvaK/X+vOL3hwuOM/iLWFu/ZfjvIFPPKrWH03Da5twY4cLtUvumPpl8xL7/xiHBKNO+mUV MAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Release the DMA channel directly and consolidate the error paths.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index f92dc2fff50c..6b561b333ac6 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -633,7 +633,7 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd)
 	dd->dma_lch_in.chan = dma_request_chan(dd->dev, "tx");
 	if (IS_ERR(dd->dma_lch_in.chan)) {
 		ret = PTR_ERR(dd->dma_lch_in.chan);
-		goto err_dma_in;
+		goto err_dma;
 	}
 
 	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
@@ -649,7 +649,8 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd)
 	dd->dma_lch_out.chan = dma_request_chan(dd->dev, "rx");
 	if (IS_ERR(dd->dma_lch_out.chan)) {
 		ret = PTR_ERR(dd->dma_lch_out.chan);
-		goto err_dma_out;
+		dma_release_channel(dd->dma_lch_in.chan);
+		goto err_dma;
 	}
 
 	dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
@@ -664,9 +665,7 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd)
 
 	return 0;
 
-err_dma_out:
-	dma_release_channel(dd->dma_lch_in.chan);
-err_dma_in:
+err_dma:
 	dev_err(dd->dev, "no DMA channel available\n");
 	return ret;
 }

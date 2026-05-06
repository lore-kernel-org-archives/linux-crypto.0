Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AAB34AB01
	for <linux-crypto@vger.kernel.org>; Wed,  6 May 2026 09:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778059044; cv=none; b=cB7JFW7or35qZpHWYYjATM1FWzMGQH1+pp3Aw1fLE0fIVhHOq3VIuVkjt2TOZPoG4t71L3TyUO8E2AMSDMYuz7NOC/BVPwM+au+t38v+V77hahK1G3CNQ+XKnB4Acjo5en9f8c6/UMrUcpj0b66Rko2vJJfM5gRDtSqmMLmpdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778059044; c=relaxed/simple;
	bh=fi7B4GSOEiQjVRnOnKrVgetUYmI8RV2e8N8/j0+02Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kCeiIAf+kPkhUI8wzn+yIxbvLGcdYKZUxYRmLnaHeLYlFPNlzSGb9k7nwZduhF6RPXI7ang3V0n854X8lZ08z4bZwFsGsEumXOF4VpTfCiLJlID57MZYV9tSIbARja1ncGvcfnFJfck4yj1BisBN01t3j40MwOjeFn8NIi2y2rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d+V5l0y8; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d+V5l0y8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778059040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1w+vA6mvdDcEcYX3o5dX6wqW3oh+fwWNkwsRLunPACo=;
	b=d+V5l0y8BxClIq4gH+3Fq/pTxC5RjPQLC4FejmL4QixZcvn1qR2AOFYCtUPvhXEGCAGneI
	DPd9SqArk8AMl3UIezV5H/PJH674k4GtGdbGdarpRho11xHBf/i31mfTctpzawJZe6qQ5s
	p5uke+mai5yth/SdT3E+3zkIgTVS0r0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: artpec6 - refactor crypto_setup_out_descr for readability
Date: Wed,  6 May 2026 11:16:28 +0200
Message-ID: <20260506091627.177426-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1451; i=thorsten.blum@linux.dev; h=from:subject; bh=fi7B4GSOEiQjVRnOnKrVgetUYmI8RV2e8N8/j0+02Uo=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJm/2V4X+wcz8O66qWq38cwGv/Mi74zXlvMEmsSnKL89x uAodWdiRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEyEjY+RYeU3t002u+2bZas+ CfTMzXa7KmUVo/Xk6G3R+Auxdy93FzD84b7mvZLF28OS3bu5IJDJyaf/TJWTkuCCfNfkQuapCfp 8AA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace if-else with an early return to reduce code nesting, and move
the variable declarations to the top of the function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/axis/artpec6_crypto.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index b04d6379244a..75e1eac15138 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -706,22 +706,19 @@ artpec6_crypto_setup_out_descr(struct artpec6_crypto_req_common *common,
 			       void *dst, unsigned int len, bool eop,
 			       bool use_short)
 {
-	if (use_short && len < 7) {
+	dma_addr_t dma_addr;
+	int ret;
+
+	if (use_short && len < 7)
 		return artpec6_crypto_setup_out_descr_short(common, dst, len,
 							    eop);
-	} else {
-		int ret;
-		dma_addr_t dma_addr;
 
-		ret = artpec6_crypto_dma_map_single(common, dst, len,
-						   DMA_TO_DEVICE,
-						   &dma_addr);
-		if (ret)
-			return ret;
+	ret = artpec6_crypto_dma_map_single(common, dst, len, DMA_TO_DEVICE,
+					    &dma_addr);
+	if (ret)
+		return ret;
 
-		return artpec6_crypto_setup_out_descr_phys(common, dma_addr,
-							   len, eop);
-	}
+	return artpec6_crypto_setup_out_descr_phys(common, dma_addr, len, eop);
 }
 
 /** artpec6_crypto_setup_in_descr_phys - Setup an in channel with a

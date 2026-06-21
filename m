Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7862882D7
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2026 19:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782070005; cv=none; b=EVRmIho7sftISv+8ImwmcxxQqj3wHIamuuSrSOdNxtFrMKsYRw2Up2rCjtBvzMzEjO9/IhhaVyg+5EEc0C9tuNxaDUlaO81tKrh+te8KfuIYLHW9IoXT11MNjn9lhvL7imi9/ggvBnR5g5eCCarop4EGvYd4+LNcU4XnwJ54Wzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782070005; c=relaxed/simple;
	bh=QLkT6UpBtXFAmC/EbtJYRlAe8jiyZbpGniPqrtKoJ60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XaJLO6lQsTxcS9F4db3cogsXthC5eNiFb6HII6v2fyF565G6ePdXBDBsGVHCkrMKDubLVnVRCWIbGK0indfsru1QlaUQtbh+GZDcuLaHX9wOv0BOzOWExBbblRteTXMjqDFkB5gJMsVVa0VqoZemimWJ4e6G76yPz36bvXPAQaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A+/X6/gz; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A+/X6/gz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782069992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SyW5BDjbbmigNhBIEQlI5kPn/+PoFEIgeknateLdwe4=;
	b=A+/X6/gzL5DsFhYcVjNECqD+KhJW/fBatsdvl4pn75ovYj8zQv+UGoGeBcc6rC+dYKZt7q
	US1KlZRu0kr4Xh0w68gjTtp8o10XQ8RFA5lLOmZ+hrYzI9OPOfMlLvxbu4RwV2Rx/e++zV
	U5pyo4k3gooQ0UAzUc1PomZ+hBjomNM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Marek Vasut <marex@denx.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: mxs-dcp - fix source scatterlist length access
Date: Sun, 21 Jun 2026 21:26:16 +0200
Message-ID: <20260621192615.277957-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1044; i=thorsten.blum@linux.dev; h=from:subject; bh=QLkT6UpBtXFAmC/EbtJYRlAe8jiyZbpGniPqrtKoJ60=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkWVtf/Cu5UfHHr5psQA8WX6k/jS97s97SteKueYCvQw Vf6q/9JRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEyk0Zjhr9TxwPL6Od9fHNC/ JRK9ceuRs/JzOpTnTmC0NsladWLWQzVGhubVJxLtTZfx7L59V6Ah7OsRx4mp7Fu9TkjfKL07d+2 EEG4A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mxs_dcp_aes_block_crypt() uses sg_dma_len() without mapping the source
scatterlist with dma_map_sg() first. Therefore, sg_dma_len() is invalid
and could return zero or a stale DMA length, causing encryption and
decryption to process the wrong number of bytes when
CONFIG_NEED_SG_DMA_LENGTH=y.

Use the original scatterlist length instead.

Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/mxs-dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 133ebc998236..595b2fd84667 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -353,7 +353,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
-		len = sg_dma_len(src);
+		len = src->length;
 		tlen += len;
 		limit_hit = tlen > req->cryptlen;
 

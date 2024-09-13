Received: from mxc.seznam.cz (mxc.seznam.cz [77.75.79.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EDA1D58AF
	for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2024 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.75.79.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726218863; cv=none; b=rhvLoQJKhwz5CgE6bGKSqkc2l4ukF6SMtk2rBfGYGkfJrDMntQZC1lx5vVKESIQCbK/0rTMNSQnokrbGwh+G+iV5CJiaudMyvxvWsTwV7/PfpSpCI1AUZoUYC1RQhuR80orv8U4b74xLOWDwPbZO375yG5VMoEhzGPTAQ4EyiCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726218863; c=relaxed/simple;
	bh=MhYpjZsHGerh9uV9YInezLCAzgBvKjuo7JrUHX1GgMs=;
	h=From:To:Cc:Subject:Date:Message-Id:Mime-Version:Content-Type; b=nyy2v/s1CvdYJLEwAowFeVZKqxr1bE0n0yajxfdzR8f1n2O08K8QWIOzej3eJWYImTy/OyvF8rBAu9J3j1qUtRlwc41GjWTUjALuPRJE8wmKYVxxs360lMt644irgw6d5pnOGbp5xFAljGO3sb1dFEW3OfpR0EuL+vCiC3qrEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz; spf=pass smtp.mailfrom=email.cz; dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b=ABTide6v; arc=none smtp.client-ip=77.75.79.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=email.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=email.cz header.i=@email.cz header.b="ABTide6v"
Received: from email.seznam.cz
	by smtpc-mxc-58959dfbcf-mrxrj
	(smtpc-mxc-58959dfbcf-mrxrj [2a02:598:64:8a00::1000:460])
	id 34e24eddca16fc77346cc0c5;
	Fri, 13 Sep 2024 11:11:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz;
	s=szn20221014; t=1726218708;
	bh=g4vwlwy5O7TMlld+y4YtQP4hezQIvov6mjtXb2jroRk=;
	h=Received:From:To:Cc:Subject:Date:Message-Id:Mime-Version:X-Mailer:
	 Content-Type:Content-Transfer-Encoding;
	b=ABTide6vKVoFNrVunr8ULeqy0dJJzoZvvLdW4CQuHeUvgvMENkXT1pYKjf42Z4BdI
	 W78a7hW/o+XRTsiiIQDWt10YMdP4psdsFGD3q7BsLbCGCs6A1ch35AOB1UTjsQsLYf
	 5wV/XQlLIOyQxKV6YU9odYJ6uq+dkOxoTrXSRkuuqT5V1s7qzDQaSe7p8l3FKRSHSL
	 cXcW+XONp/uQKYmQAHDs/hzetw0iHohI2c4vf5+JlbeYobzOKLNt9d8adfTGdpI7a6
	 TwBnzh0gIfmM8qcG+sGjLqIlVMz6FhwPhybgYticGIlyrj0T2+vOSqcC4x7nBBfowc
	 XTh3FZ2WqHdFg==
Received: from 184-143.ktuo.cz (184-143.ktuo.cz [82.144.143.184])
	by email.seznam.cz (szn-ebox-5.0.189) with HTTP;
	Fri, 13 Sep 2024 11:11:43 +0200 (CEST)
From: "Tomas Paukrt" <tomaspaukrt@email.cz>
To: <linux-crypto@vger.kernel.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Shawn Guo" <shawnguo@kernel.org>,
	"Sascha Hauer" <s.hauer@pengutronix.de>,
	"Pengutronix Kernel Team" <kernel@pengutronix.de>,
	"Fabio Estevam" <festevam@gmail.com>,
	<imx@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] crypto: mxs-dcp: Fix AES-CBC with hardware-bound keys
Date: Fri, 13 Sep 2024 11:11:43 +0200 (CEST)
Message-Id: <1Wx.Zci3.5c7{vqn25ku.1cv07F@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (szn-mime-2.1.61)
X-Mailer: szn-ebox-5.0.189
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Fix passing an initialization vector in the payload field which
is necessary for AES in CBC mode even with hardware-bound keys.

Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys=
")
Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
---
 drivers/crypto/mxs-dcp.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index c82775d..77a6301 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -225,21 +225,22 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *a=
ctx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
-	dma_addr_t key_phys =3D 0;
-	dma_addr_t src_phys, dst_phys;
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp =3D global_sdcp;
 	struct dcp_dma_desc *desc =3D &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx =3D skcipher_request_ctx(req);
 	bool key_referenced =3D actx->key_referenced;
 	int ret;
 
-	if (!key_referenced) {
+	if (key_referenced)
+		key_phys =3D dma_map_single(sdcp->dev, sdcp->coh->aes_key + AES_KEYSIZE=
_128,
+					  AES_KEYSIZE_128, DMA_TO_DEVICE);
+	else
 		key_phys =3D dma_map_single(sdcp->dev, sdcp->coh->aes_key,
 					  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
-		ret =3D dma_mapping_error(sdcp->dev, key_phys);
-		if (ret)
-			return ret;
-	}
+	ret =3D dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
 
 	src_phys =3D dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
 				  DCP_BUF_SZ, DMA_TO_DEVICE);
@@ -300,7 +301,10 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx=
,
 err_dst:
 	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
 err_src:
-	if (!key_referenced)
+	if (key_referenced)
+		dma_unmap_single(sdcp->dev, key_phys, AES_KEYSIZE_128,
+				 DMA_TO_DEVICE);
+	else
 		dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 				 DMA_TO_DEVICE);
 	return ret;
-- 
2.7.4
 

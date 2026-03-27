Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58C3932DD
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774603488; cv=none; b=GN1eO7KvNcgNcKjImepVtukmVTQTbDoD7crxiK7YTmP6oL2Qorza+f3bDWJTkTmCpoz3d1TnaWp3ed0zau91AOwDhKvGAlEZlqyNvyWIW/yQaHFrRy14tF60zWzi1hfkAp+xXngx7UwEtmqQ+iFrowodrW5evxFAJZ7Eh499o+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774603488; c=relaxed/simple;
	bh=XQ4qcyKbXradsSabJGMbGq4/IFuov6bVlgxDE4ai67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GOrTvFme9nVODUKw3xUFgAFU9s/o3dd//YasXy2AfDp1b61b0aCdpl0ycyK0QsdMrB431/BvH0C39hhrXO55dYk3Yuo4/s/MOHt40V/g9FDkxdpNOgUbqNW8dVlH3l29GdSL+cGEq231HFL/O4KWPl2fIS0C9MAaun6bB14q0mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=xSWvcl8I; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="xSWvcl8I"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 3D3F44E4280A;
	Fri, 27 Mar 2026 09:24:45 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id EBE7960230;
	Fri, 27 Mar 2026 09:24:44 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C40C210450F33;
	Fri, 27 Mar 2026 10:24:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774603484; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=uX0ZkDshfrjUuQd8q4yz2ndynx0ogljmjvdsdmFxGS0=;
	b=xSWvcl8Isbuq0d92ng8BHqR2A3YD/pHQymygkKgvTGzvpJ/9TUPBQ5jualNb6iSeS3B/5i
	+57n2WSDTy/VWyaeVK08FOZkJNuKikPRGIapifgdHbDCJ9ZVFrsduV9/fUrJANVTpnRhrx
	2ld29wYDZxahiOPJwVtWp8hdCr5cDNzBt/sfpvNU57UZAp3f0cKeGC0wxuEhl6/8F/JBN5
	nxf5oYT+3UZw0LCt+nwOAmrVcAk20MBawzmq2bBImMdMoN4/plhIY/2oA6nx1SxCpCOKRi
	PDQ/77dJF6F5/n3wOy/p0eR4hlX9LJIZNRVgRSGfYVLDb+B37c4uG8wyb//msQ==
From: Paul Louvel <paul.louvel@bootlin.com>
To: Neal Liu <neal_liu@aspeedtech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Paul Louvel <paul.louvel@bootlin.com>,
	linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aspeed/hash: Use memcpy_from_sglist() in aspeed_ahash_dma_prepare()
Date: Fri, 27 Mar 2026 10:24:18 +0100
Message-ID: <20260327092418.10476-1-paul.louvel@bootlin.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Replace scatterwalk_map_and_copy() with memcpy_from_sglist() in
aspeed_ahash_dma_prepare(). The latter provides a simpler interface
without requiring a direction parameter, making the code easier to
read and less error-prone.

No functional change intended.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index f8f37c9d5f3c..6f0d03cfbefc 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -182,8 +182,7 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 			final = true;
 	} else
 		length -= remain;
-	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
-				 rctx->offset, length, 0);
+	memcpy_from_sglist(hash_engine->ahash_src_addr, rctx->src_sg, rctx->offset, length);
 	aspeed_ahash_update_counter(rctx, length);
 	if (final)
 		length += aspeed_ahash_fill_padding(
-- 
2.53.0


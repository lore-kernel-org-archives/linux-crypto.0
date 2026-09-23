Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D99956C628;
	Wed, 23 Sep 2026 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176801; cv=none; b=OG7zQCxiW+fb1V6PALnRPzCTIix0E+xcc0wX9khTeakPatATZ5fFykt5fmqJ2ce6xLScwF4LM1h4ElDTJI+mdJwc938iRylKMHk+SOomYlT/x4ABkK1BRnYFgmKQs21QVqC0gOrXdgOaTCcmegOCLtwwp3j4RH6Jx7wegWzNP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176801; c=relaxed/simple;
	bh=0fn9a5fI8mpJ9YsIbGo7WPqLxAqWQoB06cxqELNgtXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JpiqMW6o/1ICjrQAQXhwu9AYNtzxjxsODhgy7qoXM6BxCBhR2DiXrGQK0TFukD6MS27/zRTNmSmB1EWX1qHChysqtYbCRgYs1UV6Kjb8KWYe8ZKzmGBmokTLJhEQhdXMKFDAChjHKAUW07shWweofhPZFC+yK75snDwsRt3a6Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=wRJCJ4HI; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="wRJCJ4HI"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id B1CBA4E41046;
	Wed, 23 Sep 2026 15:19:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 872B860580;
	Wed, 23 Sep 2026 15:19:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7F91E103282D3;
	Wed, 23 Sep 2026 17:19:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1790176796; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=2jWPpOqCMznalTTgnQVZZXdihTNKO3bN3YwU1/tcePg=;
	b=wRJCJ4HI+zQxdUErBPAyj9zAvxMNikIfxfMkaiU7tXZxrRTFVDyJu878WtPyYzTzCMcBdd
	v9TXf+aTH4bZ60+NWBZqqb06VUbtA0x5ue1PbmMp5BxBnLHz5NMyQs7nOQd5mMMVLv7elu
	ubL8iiphPL/5GoEVRRhYNm28xvmwLsZzsNcg0I8YCt9G30q3Ai1skTbPpgakXv5Vo8+lVq
	/kk/L+nh4wgKHD2agE0zhRf1qGmBrjD4Yn3GJLVDfCb5tad3D9ZTREnGkRW2kvhR7x7sgV
	10cMHDSGU6r2TKD/ENjphOtAotn66dub0c+s7IwbuGRkCypOaw1YEv/gPdievA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 23 Sep 2026 17:18:55 +0200
Subject: [PATCH v7 19/20] crypto: talitos - Remove TALITOS_DESC_SIZE macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-7-3-rc2_talitos_cleanup-v7-19-9a45261fc097@bootlin.com>
References: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
In-Reply-To: <20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790176746; l=3441;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=0fn9a5fI8mpJ9YsIbGo7WPqLxAqWQoB06cxqELNgtXs=;
 b=BfbbWSMRXesaC3s8t+G6OI+9gBuYeEXUKaRjhbIVp9N+2BwRNzhRO3Fj+heEhStatwh81y7EI
 RJummt32PvKBh8nDAV6rCHvb2DSgVnitGO0Q4lU8vMDznQBrxGgsOlW
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that TALITOS_DESC_SIZE is simply sizeof(struct talitos_desc) with no
arithmetic, the macro is useless. Replace all occurrences with the
underlying sizeof expression and remove the macro.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-core.c | 16 ++++++++--------
 drivers/crypto/talitos/talitos.h      |  2 --
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-core.c b/drivers/crypto/talitos/talitos-core.c
index 2c274f1942d4..c31350679c99 100644
--- a/drivers/crypto/talitos/talitos-core.c
+++ b/drivers/crypto/talitos/talitos-core.c
@@ -168,7 +168,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 	if (is_sec1()) {
 		while (edesc) {
 			dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
-						  TALITOS_DESC_SIZE,
+						  sizeof(struct talitos_desc),
 						  DMA_BIDIRECTIONAL);
 
 			if (!prev_edesc) {
@@ -181,7 +181,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 			prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
 
 			dma_sync_single_for_device(dev, prev_dma_desc,
-						   TALITOS_DESC_SIZE,
+						   sizeof(struct talitos_desc),
 						   DMA_TO_DEVICE);
 
 next:
@@ -190,7 +190,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 			edesc = edesc->next_desc;
 		}
 	} else {
-		request->dma_desc = dma_map_single(dev, desc, TALITOS_DESC_SIZE,
+		request->dma_desc = dma_map_single(dev, desc, sizeof(struct talitos_desc),
 						   DMA_BIDIRECTIONAL);
 	}
 }
@@ -260,7 +260,7 @@ static __be32 get_request_hdr(struct device *dev,
 
 	if (!is_sec1()) {
 		dma_sync_single_for_cpu(dev, request->dma_desc,
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+					sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 
 		return request->desc->sec2.hdr;
 	}
@@ -272,7 +272,7 @@ static __be32 get_request_hdr(struct device *dev,
 		edesc = edesc->next_desc;
 	}
 
-	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+	dma_sync_single_for_cpu(dev, dma_desc, sizeof(struct talitos_desc),
 				DMA_BIDIRECTIONAL);
 
 	return edesc->desc.sec1.hdr;
@@ -284,17 +284,17 @@ static void dma_unmap_request(struct device *dev,
 	struct talitos_edesc *edesc;
 
 	if (is_sec1()) {
-		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+		dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
 				 DMA_BIDIRECTIONAL);
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
 		while (edesc->next_desc) {
 			dma_unmap_single(dev,
 					 be32_to_cpu(edesc->desc.sec1.next_desc),
-					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+					 sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 			edesc = edesc->next_desc;
 		}
 	} else {
-		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+		dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
 				 DMA_BIDIRECTIONAL);
 	}
 }
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index accc5bf1797c..28da0f507c91 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -78,8 +78,6 @@ struct talitos_desc {
 	};
 };
 
-#define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc))
-
 /*
  * talitos_edesc - s/w-extended descriptor
  * @bufsl: scatterlist buffer

-- 
2.55.0


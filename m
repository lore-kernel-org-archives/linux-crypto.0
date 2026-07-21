Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F5A39D6F2
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 14:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642410; cv=none; b=EnoksG3tAgGA5GqXby6OFIh7WxhmXsh0G4HpCsEUDeRLAWHvedSxw1t+kq86xnDEwthkiCYM6d4iQS9IwE7pmpts4+NqwXvY3+N3p3u3TYLdU3dZWDtGYLVoo8cJXko4knCTLDfpjQoQXOuRxP0NF7haJEjUMcWZH+TGFqeOSrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642410; c=relaxed/simple;
	bh=itOcTYks7XB8CxvDhYcLfUinXr3sQLi8u9lwaj5H4LU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AbdnPu9fHnlWpjlXTtWebr46lclitUv3MWR/bvqXkYh2LKO6lkTb0xQPp/dMIAYpDOONZp2UUTa5b8BwNm9mTebl4E6K1TfiO/if6Y49doHQmA1+TNjB3bvoiGDS9uUebdY+d1ZvWFkgfMCt4GFg6yxAf6do1nkhhQa3v0vcbMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=u80r4bTt; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="u80r4bTt"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 0596A4E40EA6;
	Tue, 21 Jul 2026 14:00:06 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CF4DC60368;
	Tue, 21 Jul 2026 14:00:05 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 66D6811BD3BDA;
	Tue, 21 Jul 2026 16:00:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642405; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ic58REeumOPvmupb0k8pt0OlD8zn12JRYiQhzehZkoY=;
	b=u80r4bTtfi4+FR27WAKyRwtfU3oHtNLBSEE+mVddghrGTCDF4F0rigt5BXR/Ado1Jl7V8g
	P2TdpuEXQZTUaNoVWcu2BeTAaZckwCJ5b527tCBf2ykM0jzy/DGbdE4OUaFbgpVMCCPxox
	pLQrJl3fXMV7PzuNCFtGkvNvEob7Zr9ogM3OfCyIS/CeU1v5NCLkKkX+TnSsdH5TZaX3HF
	HcHyGmCKNoHsyBq31eBSYgau01n48id8WIrBF+TYvrrbR+5vzjgEhlhSkkaAgvcXHwc+Sz
	TPYNMdA24y3INzDYQr2EmqF0AAegO2lfr1TXzj7Tgm+xIGdMBm6ghn0rzRL4iw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:46 +0200
Subject: [PATCH v3 19/19] crypto: talitos - Remove TALITOS_DESC_SIZE macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-19-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=3411;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=itOcTYks7XB8CxvDhYcLfUinXr3sQLi8u9lwaj5H4LU=;
 b=ajfB5tMP7+1U8a2ZGGNCiuEU/A85/RufmanfIf0wTKf1NW09fdanuSFm4WODJnCLSibfukIGM
 6kTr59zbbl7DcA6V3e/8hmpbS4MlqBFBbNrSFnsSIBXb3utqa/LQM0Q
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that TALITOS_DESC_SIZE is simply sizeof(struct talitos_desc) with no
arithmetic, the macro is useless. Replace all occurrences with the
underlying sizeof expression and remove the macro.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 16 ++++++++--------
 drivers/crypto/talitos/talitos.h |  2 --
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 1221eb9497fb..7faf3c2606a9 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -166,7 +166,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 	if (is_sec1()) {
 		while (edesc) {
 			dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
-						  TALITOS_DESC_SIZE,
+						  sizeof(struct talitos_desc),
 						  DMA_BIDIRECTIONAL);
 
 			if (!prev_edesc) {
@@ -179,7 +179,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 			prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
 
 			dma_sync_single_for_device(dev, prev_dma_desc,
-						   TALITOS_DESC_SIZE,
+						   sizeof(struct talitos_desc),
 						   DMA_TO_DEVICE);
 
 next:
@@ -188,7 +188,7 @@ static void dma_map_request(struct device *dev, struct talitos_request *request,
 			edesc = edesc->next_desc;
 		}
 	} else {
-		request->dma_desc = dma_map_single(dev, desc, TALITOS_DESC_SIZE,
+		request->dma_desc = dma_map_single(dev, desc, sizeof(struct talitos_desc),
 						   DMA_BIDIRECTIONAL);
 	}
 }
@@ -258,7 +258,7 @@ static __be32 get_request_hdr(struct device *dev,
 
 	if (!is_sec1()) {
 		dma_sync_single_for_cpu(dev, request->dma_desc,
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+					sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 
 		return request->desc->sec2.hdr;
 	}
@@ -270,7 +270,7 @@ static __be32 get_request_hdr(struct device *dev,
 		edesc = edesc->next_desc;
 	}
 
-	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+	dma_sync_single_for_cpu(dev, dma_desc, sizeof(struct talitos_desc),
 				DMA_BIDIRECTIONAL);
 
 	return edesc->desc.sec1.hdr;
@@ -282,17 +282,17 @@ static void dma_unmap_request(struct device *dev,
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
index 2e2414ad1e03..6b9ce69daed4 100644
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


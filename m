Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F0D48B36C;
	Wed, 22 Jul 2026 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710494; cv=none; b=XFQbd8NqBwj7VJQV8x05Ajpe/BvTz8rrmXQuBHDFdRarfgTLY4hWB0NSqi886xE63+Iu47fq/EUamjpqWttEFvYpATqH8SMiLpCLb9tw2spZpHFZaCtx28PxxdTglylh+hVkRV41c93l5L71haQjfnmmqO7q1WT2sQVA4fXI/Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710494; c=relaxed/simple;
	bh=itOcTYks7XB8CxvDhYcLfUinXr3sQLi8u9lwaj5H4LU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xhve2VMWAqDYiz+stLJkBhzUXUKQsE1u/gjUmSLjP3DBP/Q3CvB+WhzL7AVbjnRBb6/RyyWw2YlWGIjGyFA7qcNJSvjeVWKfgcyDkp13f0vjdm+uVY2aB/57cSAMJVH56d7q8Et7bsUY5bz1Lu4rcnAU2n81y81kBMwzD4gXkQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=HABBQ8um; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="HABBQ8um"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5ECB41A1151;
	Wed, 22 Jul 2026 08:54:50 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 322FC60388;
	Wed, 22 Jul 2026 08:54:50 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A789D11BD3B5F;
	Wed, 22 Jul 2026 10:54:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710489; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ic58REeumOPvmupb0k8pt0OlD8zn12JRYiQhzehZkoY=;
	b=HABBQ8umnGDyPIQutcg40lEqRvJ/0BpHDAXKIu/OT4lX8jXm07p/41HvZTtWfYwbEUaQQh
	QV+kXKjKM/zJGWXYszD5Cx/0RCe2eXdiVbsBlbj5BCJC6U2g6Q1Nv8uAmbd3qUtkQoI02f
	BCWqFkKqpZM8UQuPbHpxm/LR9sli7C0O6UvpWPeI4QIMF5YEgXwJp7ZHrD/wsgBsxyFW+7
	9UNygX0n+9UwdwEq0PUYwLyDzIFA8Cj7YuksGVOSI/1gqZUPLBtAssBpDm5JjqY8eZx3UZ
	7jwx03L2N52p+4ZO9RRWgsApA80nmWEMtnQp5eXLHc4O4BXTk4gr44zBSaIaEw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Wed, 22 Jul 2026 10:54:03 +0200
Subject: [PATCH v4 19/19] crypto: talitos - Remove TALITOS_DESC_SIZE macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-19-81d1ed2ad911@bootlin.com>
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
In-Reply-To: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=3411;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=itOcTYks7XB8CxvDhYcLfUinXr3sQLi8u9lwaj5H4LU=;
 b=gvdVcjicRbL1nar0QxgjaKlnnH2uZeyPt/35NtDlEMmyih8SmQ4iAcO0yXMinsGL9XhaUvhL8
 ZK6vIspCpXyANNhw83JAWlIfSS0ALqqZTBdGkQDbz7vKI1e3HTeHRiT
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


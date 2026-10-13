Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA82751474F
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897163; cv=none; b=Z98Bf3Sm6S7e7fcpSEcfI/PB3yLW/k65RbbXsmmXwBpXXeAbnHLI3o2PS5MYlC6ebn9vE1438XKDQwAhxWN0icH7dp4hdXbrL7l3QfcsnWfPK74TOS45AJ7+kSyITGMwEI9lnhjc1eeLkTyDoanV8XdoKTS6bqVvun7fi5mxFc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897163; c=relaxed/simple;
	bh=IFuDUbjWzURfdMvIXKRTPLG5XzSnwsJYtmo5mJlf/QE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y3OTgbkoj/HSBK8NUJlnxWbnZY6oB3WAAXgjNuibx8xp0v2f3OaygyNvr7GxLgm2LuNaz9kcks34GI8kGyTmPf9HFD+TQ4RWnCOzmQCMTOv9sUHlUrLYykafTCdK/Os/EbRYT1yNulh1YLzXGfWO6nZekad6sodS3Oo81uWFk78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=GjiDGw01; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="GjiDGw01"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 6BA644E41209
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3AF1860362;
	Tue, 13 Oct 2026 13:12:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 855B811D7139E;
	Tue, 13 Oct 2026 15:12:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897159; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=5zE5I2SlMjA2yhccXfLoJMBC5Wm5KcR6LR9RapzoPZo=;
	b=GjiDGw01zzOY1htRZxdXVJ/SBGTKzHSfoVgVvu6mMLKF2n/LM+ZhzXJ/76obaV5zit9/rJ
	zWwnH6awgKenrqLyCBC36IuXTjW51xIQo4ptDGKEtPAff8zs+kWXGnAIy4LXBMCItEFhWJ
	c+BgQeXwJ65ak9aA/+/6a5w0vkUXaTEcAxWtKr9rqa8TTIpXO8eibiCeKAeX09FtEiH7mo
	9lCDjrkrC6w+VY5oigzy+q9ybW7qM/ciQLrMIlWLA98sEDJnFTe6sHqStg4IMgAuRkoJsM
	EK1sEj4QMJOqVkAR4MQ/vSqa87BBbUTVtqAECNXWYMakO8C1tYFduaDBJtwqBQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:45 +0200
Subject: [PATCH v8 19/20] crypto: talitos - Remove TALITOS_DESC_SIZE macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-19-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=3441;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=IFuDUbjWzURfdMvIXKRTPLG5XzSnwsJYtmo5mJlf/QE=;
 b=CeG9cba7m7CF3N+g4Zs3jaWo0hVsXJ9c4r2PhJ2K3iCjBF7AQxOwppC66M5Ofrp7otuv/1aEM
 5OfIe4MfRwLAuaMFhLvkdLncDyBSoeWXPi1YkecQowOs6qVs3zVoNdL
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
index 78f63760000d..7acb1fc98999 100644
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
index f741804f5b4f..da353ee327af 100644
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
2.56.0


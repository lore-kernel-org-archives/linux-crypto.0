Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20463B47FD;
	Thu, 28 May 2026 09:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959401; cv=none; b=kk3kWSP0GbIAoDbU7OTGXIHmwDSQCVYVCOCdRcYxVREa3BE9Y7xeyUzFjlKNMZkFybPwTUubOnJJKKZkPjg/XVRE9IeaEoxupVu4tDCeZ6jKUEhx1aOKTaqxRHZyVRNstet0sImU0zxE9tbtanZkE3N5n9tc+ad//08JUOcSfHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959401; c=relaxed/simple;
	bh=HnzYZ5JzFHt+vA2kwbJgkI6CDjM3BNM9ZmBbgxAHFls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UeHA9h7Tth1HqPBQEU4k6QeDgf5IhS7YaDqRHcARqBwH9kHJ+sQOTiaRB5yM59ficz4de2dYtcopWwWM+flhwpPFaE5jiqocpPsa9Xp1zKudUwNsAiz6czfzN+hg2lBOOr6bvtp3eGnHLh7vfFQwPrf2IqG/8+FSgKedd0Sgmr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=pvjUywwb; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="pvjUywwb"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5C3791A3701;
	Thu, 28 May 2026 09:09:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 31F9D60495;
	Thu, 28 May 2026 09:09:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E495710888CAF;
	Thu, 28 May 2026 11:09:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959396; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=6sg0tvaanYkdhi2xR1TE4kvycHowtU8MfgTRjfSHJoQ=;
	b=pvjUywwb+qnLVpi9mqY2rsa0iAIlyjMRU37EiFdTNJQ002Msl60OqRgHyB2O+QVOepckn6
	PyUgNe1lA05NOtUyCICh0ryavU3ocVDIpYVG51KG5uRdsYsvqT7/hg7gVrFqLW9kiuXkmE
	vfwn2i48ftoPqw6OYByIr8VX7P6qYxFXMDDXYTxR/D1yDDKJh8IcTyluTUfOVYjZlt4m39
	2tx0JG1a9X156J5FNOaU8YYt0f53x0z2Dazagp/spOXbVuw+sWqVKJIKDIqxFKMIwz1/g5
	MYp6/MDs89NFh50Yzju9DwuEOXQ0PWIJ7YQoRy3+ARB5aT7vYXK6m7/J29rBMg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:42 +0200
Subject: [PATCH 29/29] crypto: talitos - Remove TALITOS_DESC_SIZE macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-29-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=3521;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=HnzYZ5JzFHt+vA2kwbJgkI6CDjM3BNM9ZmBbgxAHFls=;
 b=d9oBIpbemFkWufKqKa7gDQQJZnpQ7IZr2Cho9TMZc2E956rF4OpxrCmfAclJRQrOfLIA6oBsA
 AvhOfaTWWfRANckRcFaO3+Tmqe0NV3+tB7WIEpUCWZtxdpgVsj8jzWh
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that struct talitos_desc no longer has the SEC1-only next_desc field
(it was moved into sec1_talitos_desc), TALITOS_DESC_SIZE is identical to
sizeof(struct talitos_desc) and no longer serves any purpose. Remove it
and use sizeof directly at each macro invocation.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-sec1.c | 10 +++++-----
 drivers/crypto/talitos/talitos-sec2.c |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
index e4f482520372..504ce9e23e59 100644
--- a/drivers/crypto/talitos/talitos-sec1.c
+++ b/drivers/crypto/talitos/talitos-sec1.c
@@ -190,7 +190,7 @@ static void sec1_dma_map_request(struct device *dev,
 	while (edesc) {
 
 		dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
-					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+					  sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 
 		if (!prev_edesc) {
 			request->dma_desc = dma_desc;
@@ -202,7 +202,7 @@ static void sec1_dma_map_request(struct device *dev,
 		prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
 
 		dma_sync_single_for_device(dev, prev_dma_desc,
-					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
+					   sizeof(struct talitos_desc), DMA_TO_DEVICE);
 
 next:
 		prev_edesc = edesc;
@@ -216,12 +216,12 @@ static void sec1_dma_unmap_request(struct device *dev,
 {
 	struct talitos_edesc *edesc;
 
-	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
 			 DMA_BIDIRECTIONAL);
 	edesc = container_of(request->desc, struct talitos_edesc, desc);
 	while (edesc->next_desc) {
 		dma_unmap_single(dev, be32_to_cpu(edesc->desc.sec1.next_desc),
-				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+				 sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 		edesc = edesc->next_desc;
 	}
 }
@@ -239,7 +239,7 @@ static __be32 sec1_get_request_hdr(struct device *dev,
 		edesc = edesc->next_desc;
 	}
 
-	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+	dma_sync_single_for_cpu(dev, dma_desc, sizeof(struct talitos_desc),
 				DMA_BIDIRECTIONAL);
 
 	return edesc->desc.sec1.hdr;
diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
index 52f783ddc8b6..0df3b22510c7 100644
--- a/drivers/crypto/talitos/talitos-sec2.c
+++ b/drivers/crypto/talitos/talitos-sec2.c
@@ -205,7 +205,7 @@ static void sec2_dma_map_request(struct device *dev,
 				 struct talitos_desc *desc)
 {
 	request->dma_desc =
-		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+		dma_map_single(dev, desc, sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
 }
 
 static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
@@ -346,14 +346,14 @@ static void sec2_init_task(struct device *dev)
 static void sec2_dma_unmap_request(struct device *dev,
 				   struct talitos_request *request)
 {
-	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
 			 DMA_BIDIRECTIONAL);
 }
 
 static __be32 sec2_get_request_hdr(struct device *dev,
 				   struct talitos_request *request)
 {
-	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
+	dma_sync_single_for_cpu(dev, request->dma_desc, sizeof(struct talitos_desc),
 				DMA_BIDIRECTIONAL);
 
 	return request->desc->sec2.hdr;

-- 
2.54.0


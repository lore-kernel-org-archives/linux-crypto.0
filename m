Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804841C2E0;
	Thu,  7 May 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164937; cv=none; b=JMsUWtPYZuiUmd494MJjcymuqBWSDjrOTILQdHACGWOcWIWiTN1fqQRuBDvBgESgcfTwUP9v5WOdt3aih6yQRqgan6F8F1kL7za8g32SToEjvs8XaAwAj8F3PQGfvF13tf1dx+i6P4CEmBOW0jqopMHFcNi/4Ry85fKk3NsJS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164937; c=relaxed/simple;
	bh=4inkjgK57GRCXPdo6HgDUyXjwG29KDKGiIYu2SvycOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ijtNKNeZq4yPFrbhrv4wkuZbbcKPB20OIZ70RSxYD9WrW9lirt2gJuznOfpN0eisuWeENz0eBdVVR6nzdnSNqUFIv4VlQ7YvbXkfh51poi8A8sLiFb+OLw0jBg5W+cxR13PbxnXDlrR1dxz90P4kiEOKvk0u/wDHFo5vUhq0WkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=orF+Gwk7; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="orF+Gwk7"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id BBE35C5DC60;
	Thu,  7 May 2026 14:43:01 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 07FF360495;
	Thu,  7 May 2026 14:42:14 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 58C81108194E9;
	Thu,  7 May 2026 16:42:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164932; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=X/CWkPVSOvCEZvE/cf6kjT7+8Jx1BQbx/MToQJY3NP0=;
	b=orF+Gwk7e4Sl5kyfRnp7g+hv2214eeNJxbgg0ZPNwtVfy8seOzcFyqQxEytLYlfpCTl+NM
	8ic//DiDG5OI89QV2v2hLw7RzOmiY62t/RZgWLsBFfSN77F9WQvPahwk2Sa/9q2CpcUrcT
	ivWYGEgitEqlR2VUs4qB4ZWRhveilkvB563umjML9x1niN8vKJ8M75/VhehEEGj53uFsWd
	JAv7YNNS24eket+yZPsUdWXGR5WGpLHvmQiM+EqC+8QGXqSc0GUW3rG9ZXZvjhY1O5CJ7p
	OkOYimvupWLS20mCcp5HdbSv8Ms6xxXB2Muj8+cBMEe5AC/mZadx/yiEy1P2Kg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:50 +0200
Subject: [PATCH v3 04/11] crypto: talitos - move dma mapping code in
 talitos_submit() into a standalone dma_map_request() function
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-4-c98d7589b942@bootlin.com>
References: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
In-Reply-To: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=3310;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=4inkjgK57GRCXPdo6HgDUyXjwG29KDKGiIYu2SvycOo=;
 b=AZgruyy06M/fEoj/rmn1fE5AXdrHbfYol+hcbfg8z6w+kd1I0TfDoi4JyT1tWR4/IuMOfFqRI
 VIR0Ec/JlMeAP+6KcOX5VrvIPPDHw+/ReK6KhI6uru7Zz/Vc3IzuakS
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Previously added code to talitos_submit() in order to map an entire
descriptor chain.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 75 ++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a98b40f566dd..183d51fa9a4a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -255,6 +255,46 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
+static void dma_map_request(struct device *dev, struct talitos_request *request,
+			    struct talitos_desc *desc, bool is_sec1)
+{
+	struct talitos_edesc *edesc =
+		container_of(desc, struct talitos_edesc, desc);
+	dma_addr_t dma_desc, prev_dma_desc;
+	struct talitos_edesc *prev_edesc = NULL;
+
+	if (is_sec1) {
+		while (edesc) {
+			edesc->desc.hdr1 = edesc->desc.hdr;
+
+			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+						  TALITOS_DESC_SIZE,
+						  DMA_BIDIRECTIONAL);
+
+			if (!prev_edesc) {
+				request->dma_desc = dma_desc;
+				goto next;
+			}
+
+			/* Chain in any previous descriptors. */
+
+			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+			dma_sync_single_for_device(dev, prev_dma_desc,
+						   TALITOS_DESC_SIZE,
+						   DMA_TO_DEVICE);
+
+next:
+			prev_edesc = edesc;
+			prev_dma_desc = dma_desc;
+			edesc = edesc->next_desc;
+		}
+	} else {
+		request->dma_desc = dma_map_single(dev, desc, TALITOS_DESC_SIZE,
+						   DMA_BIDIRECTIONAL);
+	}
+}
+
 /**
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
@@ -273,10 +313,7 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 					   void *context, int error),
 			  void *context)
 {
-	struct talitos_edesc *edesc = container_of(desc, struct talitos_edesc, desc);
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	dma_addr_t dma_desc, prev_dma_desc;
-	struct talitos_edesc *prev_edesc = NULL;
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
@@ -294,37 +331,7 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	if (is_sec1) {
-		while (edesc) {
-			edesc->desc.hdr1 = edesc->desc.hdr;
-
-			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
-						  TALITOS_DESC_SIZE,
-						  DMA_BIDIRECTIONAL);
-
-			if (!prev_edesc) {
-				request->dma_desc = dma_desc;
-				goto next;
-			}
-
-			/* Chain in any previous descriptors. */
-
-			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
-
-			dma_sync_single_for_device(dev, prev_dma_desc,
-						   TALITOS_DESC_SIZE,
-						   DMA_TO_DEVICE);
-
-next:
-			prev_edesc = edesc;
-			prev_dma_desc = dma_desc;
-			edesc = edesc->next_desc;
-		}
-	} else {
-		request->dma_desc = dma_map_single(dev, desc,
-						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
-	}
+	dma_map_request(dev, request, desc, is_sec1);
 	request->callback = callback;
 	request->context = context;
 

-- 
2.54.0


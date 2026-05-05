Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073184A2E35;
	Tue,  5 May 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003637; cv=none; b=U6UQlHhqwNticpv+q9UQB539Krpjlj9jHXGPUWxpBwebScIQ06G56cULsKV61Z6mrHzi6m4mbTPv+yJCQS1roXhu7ZaWlBh347nsLUFC9d8ZQBO52kV/1aRH4+5wQU33ztJ0bgBj7spWs7x3wutiBSfu2/mOvtAWRKhBxalGygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003637; c=relaxed/simple;
	bh=NISdsgI9JatB76MR09v/Eb2pVygURjKaC3Ap2XbahlI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XzSBJXcEY5haO53uF8QLGLXLoeMjaQUYjXP5/br2acGNQScb486NmBBIORq8h5L4MRz4/G1XG7/+qfGOzC4Etr0XkC+6xe5qrlDaH/CkhDnIoMuWsWaGvBqc/nj/MLIXwZOw3u6Ahv1LIDgto/hugXT+fLa7Jl+EqFlpUqpSCc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=E/RnGFnB; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="E/RnGFnB"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 93726C5CD45;
	Tue,  5 May 2026 17:54:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A92736053C;
	Tue,  5 May 2026 17:53:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A8FEB11AD03AB;
	Tue,  5 May 2026 19:53:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003632; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=MEZqsuDQbbQ+QfwiLanmP4l2UhzdbO4iCh1W8/Tkplk=;
	b=E/RnGFnBZLpT+QccyXYtjr49gYXW3a+EeqNzNC5JQSgrbKCmmiGGXMQkB7J0Bajylo8vEw
	Zk9ZGpBPMBIwJ6dToOKwTpt1McxfsoBQfOwQzc07PAmfeoeWvDr/nqM3KMKF8iHVOJoW1e
	yS9ca2sJrlu2NX1fJhiZJfSm813Ht3VFieJfOXjrrDxt4WZH+xl01GL/hp6xX87n4yaenk
	2N7qGUE43hN0R1riDVX4xkdXxuMunn6LbKncBJ4jHHgcLfYCaYUrRcFjteNp/wnRmF1ps1
	r0KwwQv4A5vhk9zGKEOifjQsQCN+3m+Qi4gsP3ZD6pbaaA/2+vESDUZLqzH2Dg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:04 +0200
Subject: [PATCH v2 03/12] crypto: talitos - move dma unmapping code in
 flush_channel() into a standalone dma_unmap_request() function
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-3-5818064bd190@bootlin.com>
References: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
In-Reply-To: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=2441;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=NISdsgI9JatB76MR09v/Eb2pVygURjKaC3Ap2XbahlI=;
 b=gWTReQzsiTHShjmnIc/8JG4TZyFn0Ry0yzeg4yA0e9AAd30XDQJWGab9hPxaPUT83+ASCuRyJ
 JRx2+evlQb7CLVBVKj9PY38Jh3Hv7pfN9vQ+qhwtbRZGLKBXfiuVDr4
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Previously added code to flush_channel() in order to unmap an entire
descriptor.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d68d307c54f7..e26689bf7c9d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -380,6 +380,29 @@ static __be32 get_request_hdr(struct device *dev, struct talitos_request *reques
 	return desc->hdr1;
 }
 
+static void dma_unmap_request(struct device *dev,
+			      struct talitos_request *request, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
+
+	if (is_sec1) {
+		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+				 DMA_BIDIRECTIONAL);
+
+		list_for_each_entry(edesc, request->desc_chain, node) {
+			if (!edesc->desc.next_desc)
+				break;
+
+			dma_unmap_single(dev,
+					 be32_to_cpu(edesc->desc.next_desc),
+					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+		}
+	} else {
+		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+				 DMA_BIDIRECTIONAL);
+	}
+}
+
 /*
  * process what was done, notify callback of error if not
  */
@@ -387,7 +410,6 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
-	struct talitos_edesc *edesc;
 	unsigned long flags;
 	int tail, status;
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -412,23 +434,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;
 
-		if (is_sec1) {
-			dma_unmap_single(dev, request->dma_desc,
-					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-
-			list_for_each_entry(edesc, request->desc_chain, node) {
-				if (!edesc->desc.next_desc)
-					break;
-
-				dma_unmap_single(
-					dev, be32_to_cpu(edesc->desc.next_desc),
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-			}
-		} else {
-			dma_unmap_single(dev, request->dma_desc,
-					TALITOS_DESC_SIZE,
-					DMA_BIDIRECTIONAL);
-		}
+		dma_unmap_request(dev, request, is_sec1);
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;

-- 
2.53.0


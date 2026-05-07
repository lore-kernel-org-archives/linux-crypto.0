Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E9D41B362;
	Thu,  7 May 2026 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164939; cv=none; b=EjPcYhM+mIxLkl1RkFjSzvNJLKC10Ope3X9IN9LxGZxtPNgbgM+/bNBh2bipm8CCa0LT8vghuQiFepnPvRgiYh+Cga2H2on2uFia1H1sCWSkxFizoRqE3iaWFrRKLQ7sKlNOr0nRKUmWZ0LbaEQ/pZxRfPN0s7r5Fy3YDi5+HJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164939; c=relaxed/simple;
	bh=qO0tsxQ0b6EGI/EGaaoUlVQrUdwdEVZt2kdJRh6FnNk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZaFauxInzXk+wceEKADgOzYKA9h7H2U7AHdp77LW2uzcKpwAwa2zXoqG9mOe02a01I8T+TSFIIplUl8cxoG3qkOR2f5Gr1Q5DHory6E7OXNZJw72VmRsjch/X4zr6fINsY27NBLM0V/N1aqMZD7kpYDKa7DTblXnipvkNUJqhKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=nJvlDnE2; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="nJvlDnE2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8F5131A3562;
	Thu,  7 May 2026 14:42:15 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 64B4860495;
	Thu,  7 May 2026 14:42:15 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4D011108194E5;
	Thu,  7 May 2026 16:42:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164934; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Kit7VWOE4/kosaJUfI5BQRbHDaPqPffXvb+g/mMS7XI=;
	b=nJvlDnE2AcW7HOqmFZhvoDHJh4RjDXgD4kKLxRV/fRzfEkQjyZliJQD7vi5pKQVDBe5XgF
	Hs9PdB+RQkA2LvSTHGpOkgJn0uQOR13rgFvvC1oDfo1DiGOl4gvji9gNRxGq6fi/gxl4LZ
	VmrcUCNDnFn6Pcds6RPk3RWNoJ9GzucRt2PIeDiibDphY9cW+rIdNGZQBxcZUcRMtMJfBe
	NWflFYKu3ICgyMGqKo8T8yt6qYy0sG44sWEEE1Kgd8kiA7TYCzeIm1PSXlPZLw0z7nVL2i
	I99AsyGq5LyTa0YVAyhWmnCtiUY2nXgWiJxQ62KrGbcDFFxbO3cC3P5CD4gknA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:51 +0200
Subject: [PATCH v3 05/11] crypto: talitos - move code in current_desc_hdr()
 into a standalone function
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-5-c98d7589b942@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=2274;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=qO0tsxQ0b6EGI/EGaaoUlVQrUdwdEVZt2kdJRh6FnNk=;
 b=1Uq1OVb55Es/GZfCmuxeSe1FDKSQEEGybif04lCAI80QN7rLIoqEQ2mVGWwHRVJUK4Gw/K5SJ
 l6T788GMfrABn0GjAoqk9hNXf3tNBY5unjKAcQTWLPCapx4gCI5/QkP
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Previously added code in current_desc_hdr() in order to add support for
searching an offending descriptor inside a descriptor chain.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 183d51fa9a4a..b808833d18ef 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -520,6 +520,24 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
+static __be32 search_desc_hdr_in_request(struct talitos_request *request,
+					 dma_addr_t cur_desc, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
+
+	if (request->dma_desc == cur_desc) {
+		return request->desc->hdr;
+	} else if (is_sec1) {
+		edesc = container_of(request->desc, struct talitos_edesc, desc);
+		while (edesc->next_desc) {
+			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
+				return edesc->next_desc->desc.hdr1;
+			edesc = edesc->next_desc;
+		}
+	}
+	return 0;
+}
+
 /*
  * locate current (offending) descriptor
  */
@@ -528,7 +546,6 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
-	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
 	__be32 hdr = 0;
@@ -546,21 +563,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	do {
 		request = &priv->chan[ch].fifo[iter];
 
-		if (request->dma_desc == cur_desc) {
-			hdr = request->desc->hdr;
-		} else if (is_sec1) {
-			edesc = container_of(request->desc,
-					     struct talitos_edesc, desc);
-			while (edesc->next_desc) {
-				if (edesc->desc.next_desc ==
-				    cpu_to_be32(cur_desc)) {
-					hdr = edesc->next_desc->desc.hdr1;
-					break;
-				}
-				edesc = edesc->next_desc;
-			}
-		}
-
+		hdr = search_desc_hdr_in_request(request, cur_desc, is_sec1);
 		if (hdr)
 			break;
 

-- 
2.54.0


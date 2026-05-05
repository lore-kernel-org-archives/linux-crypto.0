Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EF54A33F7;
	Tue,  5 May 2026 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003639; cv=none; b=rAJfiXA2zc6D3e8EYQsn4tOCW4EwrHldRfyI+icMNqiiwbBMlatZcge7OJ+O3MmAic5aN93VhswXPv8k0S+ipz3qKJ2PAxaxp38E8+femm0Q8AB2935GXBEcyMMdvLu87JqpdklwLNQMz2+vRaMVlQwakE1wFC6QsSv0r2cMnM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003639; c=relaxed/simple;
	bh=OU8s8Mn9Mh8SMIUN160tl0JUdDlsU4lzL+J/GKX/XQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GuJrgt6WvKAdpbZIJ32F+VpOjlruwaH07wIY8j5mKfWn8Qr4f+o7sbYqxfb2xC25jyWEgRLER0lB8hO0RE4+qFecYyMg+oeZNRpqn1rvUvyOaraqX9WAvH0CoGAuboJkRp+CC1rQAtQ2BWwqFiwXybkInLpLCsYxYc/GL1DsIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=j9DZDVYY; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="j9DZDVYY"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 914F1C5CD54;
	Tue,  5 May 2026 17:54:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A73766053C;
	Tue,  5 May 2026 17:53:56 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AFDD711AD0410;
	Tue,  5 May 2026 19:53:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003635; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=VsN8MfEuE8p6zLNmSoD+xNBvkyYo5ArGJBL6xUhd3gc=;
	b=j9DZDVYYrYeDsIDszINU6Glk5Brmi3dFnx2YGJwfwCXmM1V0PjAs+307i4nnTcRSGcrvTk
	bO59AJNZKhYg9pLvuC/EncE5WzwsTF56BU7myRWCm788yPxMcCPkdiyLqWl9+EazE0mx71
	pApHw7azS/L34EHgVyOx8T/pDb2hiBgh9Ucux1sWlp6I588X27MslV5dpjqV2FnaVqup40
	gyzLY+Q44v1uEJyMKA4PQTfsYEprak6PTr/wgoawS5Ajg484p7Fuei2UKsiTUZpFvFEPJS
	JoMWwUR+2s+03FcNJiXXv5Ji8WEcVlSGolN5HV9AzPBMhMmX3rN4iA2fVVCz5w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:06 +0200
Subject: [PATCH v2 05/12] crypto: talitos - move code in current_desc_hdr()
 into a standalone function
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-5-5818064bd190@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=2129;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=OU8s8Mn9Mh8SMIUN160tl0JUdDlsU4lzL+J/GKX/XQo=;
 b=+yhdobtZECj4yuE/xllOGmPDGJvJQ5DZXqLISLOdWiDepm7vnxw0V9sGyptAI2eDQe/WJpxIp
 OeQxN81qCtTCKiuCpXTN9hNIrRcI7Lhxii1AbF9NIsFSj7pifIWJ2rE
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Previously added code in current_desc_hdr() in order to add support for
searching an offending descriptor inside a descriptor chain.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3b1d8e34e86e..376e21e06056 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -530,6 +530,23 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
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
+		list_for_each_entry(edesc, request->desc_chain, node) {
+			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
+				return list_next_entry(edesc, node)->desc.hdr;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * locate current (offending) descriptor
  */
@@ -538,7 +555,6 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
-	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
 	__be32 hdr = 0;
@@ -556,17 +572,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	do {
 		request = &priv->chan[ch].fifo[iter];
 
-		if (request->dma_desc == cur_desc) {
-			hdr = request->desc->hdr;
-		} else if (is_sec1) {
-			list_for_each_entry(edesc, request->desc_chain, node) {
-				if (edesc->desc.next_desc ==
-				    cpu_to_be32(cur_desc))
-					hdr = list_next_entry(edesc, node)
-						      ->desc.hdr;
-			}
-		}
-
+		hdr = search_desc_hdr_in_request(request, cur_desc, is_sec1);
 		if (hdr)
 			break;
 

-- 
2.53.0


Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A73948A2D1
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003647; cv=none; b=kFmIX4IAhbqvkWG4WmYs943LfNx7wSllDF/70yFr5YpLZxYpXDE/5tLdsAxRta/WT4ba0/lLVrA4i6M+PTFZTv2fcGVU5pHIJTxm9lS9Moza2dfgJjm8rsJBQi0V7kBDj7c8Us3SZs1cvzNc2LSJ3MbhfhvgzE14c29dHPQS/IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003647; c=relaxed/simple;
	bh=oL30Ms07i9TocHsSg6o/a5zVuK54dJ/ehi5tPzja7dg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NZa9hXtybZ1/aMVCdc2hD5Fw/mX0ebe46EJi4urzfYgig6ys6VFYEUmkcBPLyOpxps/1e1XHeSkZo6P4GAnstFXBP1FlmKHAb17BNqj+rmZ7ge+jIGzXhy+8z9L7ozYR8c7w2SogMK68QfpjyXXccEFiPnNzIHXZFD4nfoIfk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=o1caQRcZ; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="o1caQRcZ"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id BF48DC5CD5C;
	Tue,  5 May 2026 17:54:49 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D51016053C;
	Tue,  5 May 2026 17:54:02 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C5A6D11AD041B;
	Tue,  5 May 2026 19:54:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003642; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ynI54andb8JG6XMNDugqFX+BPJDMZ0WUSGpCceccGT4=;
	b=o1caQRcZVW9VBo972s+tc6N4FYf7zmg5vqMWOiIps+QOrjWGSWeqcUlyCsu0ydR33o0otW
	V3H5JrZX+27YAUEAGG6dR6PH8AvhOHUr1iLU5rH9KzWGUNeakvZg2Hl2WHWmnwxfr5cN4F
	dSe+dfyZb4g8mlHUMlqd+IL0EWOUvW6zpWsArJXBxPvVIYm9lRezVGSB0AMHDn0Q7LE0Qo
	xC3W/sg3K7fp6YVqCzZjjbBrxoQnx0PmDLep1SGpAqRyNwNYqht6fIaX+Kd2vqNQIlhBqO
	37yWOHsoOgjE3RtdYK1+8j6xinANaF540VL+KqGAQyUtov/1jVW1nFZg0OhUbA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:10 +0200
Subject: [PATCH v2 09/12] crypto: talitos/hash - rename
 first_desc/last_desc to first_request/last_request
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-9-5818064bd190@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=4876;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=oL30Ms07i9TocHsSg6o/a5zVuK54dJ/ehi5tPzja7dg=;
 b=m90Y7YSt0b/0mgbXkpOjrFxWOVmzCDcPiNGZPuJGI+7quEMliz0EFTLMBEpLfjR7be3wjryzb
 je97FrTGNlnAh8JYgVnGOijNiBz8Hte3Nlz+aPggbSIy3KvE7DKcPwh
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

In talitos_ahash_req_ctx and talitos_export_state, the fields
first_desc and last_desc describe request-level (not descriptor-level)
state.  Rename them to first_request and last_request for clarity.
last_desc is also removed from talitos_ahash_req_ctx as it is no
longer used.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 43c07d86f84c..4fad4e862405 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -954,8 +954,7 @@ struct talitos_ahash_req_ctx {
 	u8 buf[2][HASH_MAX_BLOCK_SIZE];
 	int buf_idx;
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first_request;
 	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
@@ -968,8 +967,8 @@ struct talitos_export_state {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	u8 buf[HASH_MAX_BLOCK_SIZE];
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first_request;
+	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 };
@@ -1835,7 +1834,7 @@ static void ahash_done(struct device *dev,
 	struct ahash_request *areq = context;
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
+	if (!req_ctx->last_request && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
@@ -1886,7 +1885,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1894,7 +1893,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
-	req_ctx->first_desc = 0;
+	req_ctx->first_request = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
@@ -1995,14 +1994,14 @@ static int ahash_process_req_prepare(struct ahash_request *areq,
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 
 		/* request SEC to INIT hash. */
-		if (req_ctx->first_desc && edesc->first && !req_ctx->swinit)
+		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 
 		/*
 		 * When the tfm context has a keylen, it's an HMAC.
 		 * A first or last (ie. not middle) descriptor must request HMAC.
 		 */
-		if (ctx->keylen && ((req_ctx->first_desc && edesc->first) ||
+		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
 				    (req_ctx->last_request && edesc->last)))
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
@@ -2122,14 +2121,13 @@ static int ahash_init(struct ahash_request *areq)
 	/* Initialize the context */
 	req_ctx->buf_idx = 0;
 	req_ctx->nbuf = 0;
-	req_ctx->first_desc = 1; /* first_desc indicates h/w must init its context */
+	req_ctx->first_request = 1;
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
-	req_ctx->last_desc = 0;
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
@@ -2221,8 +2219,8 @@ static int ahash_export(struct ahash_request *areq, void *out)
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
-	export->first_desc = req_ctx->first_desc;
-	export->last_desc = req_ctx->last_desc;
+	export->first_request = req_ctx->first_request;
+	export->last_request = req_ctx->last_request;
 	export->to_hash_later = req_ctx->to_hash_later;
 	export->nbuf = req_ctx->nbuf;
 
@@ -2247,8 +2245,8 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	memcpy(req_ctx->hw_context, export->hw_context, size);
 	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
-	req_ctx->first_desc = export->first_desc;
-	req_ctx->last_desc = export->last_desc;
+	req_ctx->first_request = export->first_request;
+	req_ctx->last_request = export->last_request;
 	req_ctx->to_hash_later = export->to_hash_later;
 	req_ctx->nbuf = export->nbuf;
 

-- 
2.53.0


Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C383E0220
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909183; cv=none; b=XGcs40avhNGBBv4aUXfaFsWqS8sGLc/gmDHA8EUxVgEsUZuX+rdma6MQNGZ6y3x0K4M+2ybmDX4AYa2e04S4KraZotUXNS6xY+CGVFv+gZ9fEuybEt2VAbY13LObXbFMiGRIRg6JGv0msyTM3gGQOGW0Q26lnqlsrdU1lzrkF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909183; c=relaxed/simple;
	bh=q4MZ+La159R2EqSHOQ0B8f2cDTsmyvN1X83sSLb5MKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gteL/3qwitsqvEU4Yx33WLfztFescCty6rw8Ek8ceZ8L3l87GRDG2q4F/ii0goRjdEsr0ad3NREzsx+uW0VzbKrV02QfgWUdbNIYNTtZqsqLgn1KkV8tz4yBBNStOSoYkLfFDUuWiliTDf7CeZ3JGpiMoyYftOeN/a8BwpJiDBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=rwoGylUq; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="rwoGylUq"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 2F4561A350E;
	Mon,  4 May 2026 15:39:40 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 051AD5FD5F;
	Mon,  4 May 2026 15:39:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0CD9211AD2BCC;
	Mon,  4 May 2026 17:39:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777909178; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=31DNmP7BbqxxwmafcensuC/+auDTPsXFUOPjvKgF2Uw=;
	b=rwoGylUqCany6IvNRjSEGXmxM2siBJjAsaQSFzzj2S5eLnP4v1yK0fHMn2uMJ3n5GN5U+b
	L61sXjKaEmgAJY4CDU5ay0v6e8gDW6wSuyQezYyqTabLZE4yorIX6SdQTShplajC8Y6ojT
	gmueOPK8Q7BOR1xtqUZctQmNslir6pYWO/5o0fvqowJM80XDLTOqvdcYH2hB3JdOK6kqRs
	PoAwRifAHsG6d5/dW4i8//iAEmNd76FmAgxAb8WwRPfPQmlsbvXuYCEWKe0VyYLxJHOqxS
	MMAY8AqIVG5Udyu9grN1vnllB35DY8AJdJSEAkfZQ0IUOZlTvzrLWw7egOipmA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 04 May 2026 17:38:28 +0200
Subject: [PATCH 2/4] crypto: talitos - rename first_desc/last_desc to
 first_request/last_request
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-2-c97c641976f5@bootlin.com>
References: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
In-Reply-To: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777909177; l=4824;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=q4MZ+La159R2EqSHOQ0B8f2cDTsmyvN1X83sSLb5MKU=;
 b=GqMLY7uq3gAFs1VMtxAF6a/t/QIJZKiol7P3taZWogGNtXSIIPMKdH0IjjR79W8Wl9ozRrFh+
 fwIKWKj+PEkAWAK//sS8Mc9wNp+/vSTJ11T/ZcQa+vp69DnEVRcfz1Z
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
index 458a6a56d65b..6ada42d8aa32 100644
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
@@ -1830,7 +1829,7 @@ static void sec1_ahash_done(struct device *dev, struct talitos_desc *desc,
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(context);
 	struct ahash_request *areq = context;
 
-	req_ctx->first_desc = 0;
+	req_ctx->first_request = 0;
 
 	ahash_free_desc_list_from(areq,
 				  list_first_entry(&req_ctx->desc_list,
@@ -1855,7 +1854,7 @@ static void sec2_ahash_done(struct device *dev, struct talitos_desc *desc,
 	struct talitos_edesc *edesc, *next;
 	bool is_last;
 
-	req_ctx->first_desc = 0;
+	req_ctx->first_request = 0;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 	is_last = edesc->last;
@@ -1930,7 +1929,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -2036,14 +2035,14 @@ static int ahash_process_req_prepare(struct ahash_request *areq,
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
 
@@ -2165,14 +2164,13 @@ static int ahash_init(struct ahash_request *areq)
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
@@ -2264,8 +2262,8 @@ static int ahash_export(struct ahash_request *areq, void *out)
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
-	export->first_desc = req_ctx->first_desc;
-	export->last_desc = req_ctx->last_desc;
+	export->first_request = req_ctx->first_request;
+	export->last_request = req_ctx->last_request;
 	export->to_hash_later = req_ctx->to_hash_later;
 	export->nbuf = req_ctx->nbuf;
 
@@ -2290,8 +2288,8 @@ static int ahash_import(struct ahash_request *areq, const void *in)
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


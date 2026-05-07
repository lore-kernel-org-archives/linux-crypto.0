Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813C943901A;
	Thu,  7 May 2026 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164948; cv=none; b=XcOCT1H5Z9qB/uB1xn7ih81OLTdlQxZrkrtRBSj6BkUa21o2YtI+GgYydP9sBvx7Yw9TCTtbRGg14khHjLUyYO197zizCEQWIwHEU9L3qkr1qoHgEbqCVkS2tSB4e81IBjg0Vb875QfN1AwwRPUVELKm5AlGeh09z23jwppGDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164948; c=relaxed/simple;
	bh=h69OuocOka0lEOTpvPZEVhUi/eh/0IH/isa5KRgbLeI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YUjb1E7egJqh9daWbSuh5s2O8KHwr2IV24NPzvtUE5ELUv0iPuhVivD7LV58G0RmVSXWvHLJl70O60oK9vG40ryhVM2aIIpouKmBKCWK3thwIdle2LwobPIhok4/l0dSXVH/DcdKOqmOz0q5W3RncP4k+uG9J27ksxKSHVeJtRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=APliv8x5; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="APliv8x5"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 2CAF54E42C32;
	Thu,  7 May 2026 14:42:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 021AB60495;
	Thu,  7 May 2026 14:42:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 82105108194F0;
	Thu,  7 May 2026 16:42:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164943; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=mQBLgnhCwiV4EhzA5f7CQH8UsRD9gPGq4MrWHe/TNzk=;
	b=APliv8x5fqkKbkLpr6WhDKfwELIg/L843L1Tt+LZ4WntWmPzy0RuHxkk7jU84pEy91npIH
	syJ6kE/5VJRIQZ2vKA0ouH7urB8EJ4iG2oXu1t0BM9193rUm0KP6rMV8RSzXaslAMn9kuK
	4+NlRVNdcf75Z0xUdPgJK/iQg+PzJN5Af2pjp2H493oyGuK0RvKMe0qWaPl1MGzAIl4Q40
	/dTtrMc/dpXj/JiWPDEjnr8my6ITGQ83ZIsKXI/hXlKUayww+03Ikfg0LmUAd1fa1xCsX/
	R6YFlk45YCg9QwXAb4DLk+rQownWZ8ts9jnjHxLK+nPeWQu1g0Jnhar1FgpQJA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:57 +0200
Subject: [PATCH v3 11/11] crypto: talitos/hash - fix SEC2 64k - 1 ahash
 request limitation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-11-c98d7589b942@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=3206;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=h69OuocOka0lEOTpvPZEVhUi/eh/0IH/isa5KRgbLeI=;
 b=734tPEih8sT/JGATidG+dSYYbcroS8aRJTkRuYEqAw4loRz9BVp1dhw9MENVdq9x5mqWWTHqe
 ew+DI03md/OCz765mpuuXY+LUk9fNcUeXSA0jFePBRB3PUSHYVQdE/9
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The problem described in commit 655ef638a2bc ("crypto: talitos - fix
SEC1 32k ahash request limitation") also apply for the SEC2 hardware,
but with a limitation of 64k - 1 bytes.

Split ahash_done() into SEC1 and SEC2 paths: SEC1 continues to free the
whole descriptor list at once, while SEC2 now iterates through
descriptors one by one, submitting the next only after the previous
completes, which is required since SEC2 cannot chain descriptors in
hardware.

Cc: stable@vger.kernel.org
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 47 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b4283b6c18ef..4b53b13f96d9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1820,16 +1820,46 @@ static void ahash_done(struct device *dev,
 	struct talitos_edesc *edesc =
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(dev));
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_edesc *next;
 
-	if (!req_ctx->last_request && req_ctx->to_hash_later) {
-		/* Position any partial block for next update/final/finup */
-		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
-		req_ctx->nbuf = req_ctx->to_hash_later;
-	}
+	if (is_sec1) {
+		if (!req_ctx->last_request && req_ctx->to_hash_later) {
+			/* Position any partial block for next update/final/finup */
+			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
+			req_ctx->nbuf = req_ctx->to_hash_later;
+		}
+
+		free_edesc_list_from(areq, edesc);
+		ahash_request_complete(areq, err);
+	} else {
+		next = edesc->next_desc;
 
-	free_edesc_list_from(areq, edesc);
+		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		kfree(edesc);
 
-	ahash_request_complete(areq, err);
+		if (err)
+			goto out;
+
+		if (next) {
+			err = talitos_submit(dev, ctx->ch, &next->desc,
+					     ahash_done, areq);
+			if (err != -EINPROGRESS)
+				goto out;
+			return;
+		}
+out:
+		if (!req_ctx->last_request && req_ctx->to_hash_later) {
+			/* Position any partial block for next update/final/finup */
+			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
+			req_ctx->nbuf = req_ctx->to_hash_later;
+		}
+		if (err && next)
+			free_edesc_list_from(areq, next);
+		ahash_request_complete(areq, err);
+	}
 }
 
 /*
@@ -1940,7 +1970,8 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
-	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN : SIZE_MAX;
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
+				    TALITOS2_MAX_DATA_LEN;
 	struct scatterlist tmp[2];
 	size_t to_hash_this_desc;
 	struct scatterlist *src;

-- 
2.54.0


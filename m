Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD93B2C028B
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 19:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773863302; cv=none; b=WtqQ1kI3lto6E/4tLbnIipDVbjVSS6Yu/V12SeJp62qUrkx8X4grGWari1g5/+Fa035U6IR+72nNhyFrOHiKaeA5EKFL54pubH3FeubzCPOy5sXU4QPA6BW4+CbeWuvxAFpRf1ouErVApfL6eHAlkvvSBAydN2L10uMqpbEvPAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773863302; c=relaxed/simple;
	bh=6lCQA5irQLf8r61E6iXlBTcgGWfBeo+sVIzGWD73WiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h43H7+RAaCm9ldBiKJZ8iKoKp0/9ggjIHYuNniW5oz+JCjXN5d5TgALXUctnSywiHX5507HlEd59HZVlXu1Q5HcBhS2cVaTpj/4USwxvtZPdFttevcNnkV1xqm+RVytKd7+yiG7aPM72Ph1JqWraahEuwGN7ImLU4VNyvQnsDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HJBwj2OT; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HJBwj2OT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773863288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nd7XU4yzoE7nXwDpfxkU3SS6EVX91OWvcehWjZ0TpgE=;
	b=HJBwj2OTjNpmPQU32j4b1zwGR3WwWD2nkhAUvufC2y+fP8+f6+/zQLPjPrqR+smMvPqgav
	rjJXjqsiJKuKotsQgHAjAKtOJMNLTpgOkGB2nahKAWB7/+mx8ffUOJMvCYX1ixmrQ8iHlq
	ab0x3+wGMd4HfJW7r5P+M0MpYAIMcFc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Yuan Kang <Yuan.Kang@freescale.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: caam - guard HMAC key hex dumps in hash_digest_key
Date: Wed, 18 Mar 2026 20:46:50 +0100
Message-ID: <20260318194649.137257-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3516; i=thorsten.blum@linux.dev; h=from:subject; bh=6lCQA5irQLf8r61E6iXlBTcgGWfBeo+sVIzGWD73WiQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJm7GTU/V7/7nf/p8nfvj3vnXddX6Nq1puXtsfkPPwTyv p8+aataTUcpC4MYF4OsmCLLg1k/ZviW1lRuMonYCTOHlQlkCAMXpwBMRPE5wx+Ok1PqH1yz4Du8 lGV3InfshIArt5MCXWI5mOoPOYV8/CTI8D+/xs7hEJeW5OLi2auXz268k1ZTUlDZybJGdxlDaKz MWx4A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Guard sensitive HMAC key hex dumps with DEBUG in hash_digest_key() to
avoid leaking secrets at runtime when CONFIG_DYNAMIC_DEBUG is enabled.

Fixes: 045e36780f11 ("crypto: caam - ahash hmac support")
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Debug-guard key hex dumps instead of removing them entirely (Herbert)
- Use print_hex_dump() instead of print_hex_dump_debug() since the dumps
  are already guarded by DEBUG
- Link to v1: https://lore.kernel.org/lkml/20260306111204.302544-1-thorsten.blum@linux.dev/
---
 drivers/crypto/caam/caamalg_qi2.c | 13 ++++++++-----
 drivers/crypto/caam/caamhash.c    | 13 ++++++++-----
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 167372936ca7..3392070942ab 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3269,8 +3269,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
-	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
+#ifdef DEBUG
+	print_hex_dump(KERN_DEBUG, "key_in@" __stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
+#endif
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -3289,9 +3291,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		/* in progress */
 		wait_for_completion(&result.completion);
 		ret = result.err;
-		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key,
-				     digestsize, 1);
+#ifdef DEBUG
+		print_hex_dump(KERN_DEBUG, "digested key@" __stringify(__LINE__)": ",
+			       DUMP_PREFIX_ADDRESS, 16, 4, key, digestsize, 1);
+#endif
 	}
 
 	dma_unmap_single(ctx->dev, flc_dma, sizeof(flc->flc) + desc_bytes(desc),
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 628c43a7efc4..0dad6fb6caeb 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -393,8 +393,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
-	print_hex_dump_debug("key_in@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
+#ifdef DEBUG
+	print_hex_dump(KERN_DEBUG, "key_in@"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
+#endif
 	print_hex_dump_debug("jobdesc@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -408,9 +410,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		wait_for_completion(&result.completion);
 		ret = result.err;
 
-		print_hex_dump_debug("digested key@"__stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key,
-				     digestsize, 1);
+#ifdef DEBUG
+		print_hex_dump(KERN_DEBUG, "digested key@"__stringify(__LINE__)": ",
+			       DUMP_PREFIX_ADDRESS, 16, 4, key, digestsize, 1);
+#endif
 	}
 	dma_unmap_single(jrdev, key_dma, *keylen, DMA_BIDIRECTIONAL);
 

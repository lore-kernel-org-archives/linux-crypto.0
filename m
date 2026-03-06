Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F8038229B
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 11:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795570; cv=none; b=pJekzN8bIR+1mFim1ex60lNSwYKxoaheM5B0pzulXL2Zim2ScspbSvzlAy5Y0c+KWiedxv/L5gUdH3O/hHIoeiuIfg1qek6qoljYnpXcRnaBAPne5tN8lrdvGTHgttk73N/SnQGRrDxJSgUgR+xbZToI0wlDE/l9Nn9Q8yNKwkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795570; c=relaxed/simple;
	bh=QYd7xFcjrF8awsSI06SrYCEauI5a1imh5mlX5CvHAd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rs3BXarmVQ1QGgz2SfSazI1ZWPpjsT6c11YRI55pDzFKORVgxYquvg7H4/c6ums3FufehR+EKP6Y+pdMcHz5PC0EpZrSS+XpLOaZF0fjUPl7MT7DwcMma4Scu6vnKnjb/3ev6gTzp0R3+QaUX7ogNRfE5CjWTBS8uU+une8Kfvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GLaoXKhh; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GLaoXKhh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772795557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t1fqidfFXzXSPjlsXOGznuUcZaf+Cb/XywjElhxqFYM=;
	b=GLaoXKhhSt1r5wLQadTCBMIOMa09dAfDXl/L/Yf7j11PsFXHQnPRp4dmEgeFaNiAaAKQNQ
	H1BpCRZ5640y4904gLrPRjkNITJewbCYmNT8mKVRE/447l8mAXCcbfYLAgArZW5mzDJfPY
	tiWyghzz3TqSXQrKVDnao5+JRPDrAbE=
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
Subject: [PATCH] crypto: caam - remove HMAC key hex dumps from hash_digest_key
Date: Fri,  6 Mar 2026 12:12:03 +0100
Message-ID: <20260306111204.302544-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Stop dumping sensitive HMAC key bytes (original and reduced keys) in
hash_digest_key() to avoid leaking secrets when debug logging is
enabled.

Fixes: 045e36780f11 ("crypto: caam - ahash hmac support")
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/caam/caamalg_qi2.c | 5 -----
 drivers/crypto/caam/caamhash.c    | 6 ------
 2 files changed, 11 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 167372936ca7..b4a6e4637b79 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3269,8 +3269,6 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
-	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -3289,9 +3287,6 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		/* in progress */
 		wait_for_completion(&result.completion);
 		ret = result.err;
-		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key,
-				     digestsize, 1);
 	}
 
 	dma_unmap_single(ctx->dev, flc_dma, sizeof(flc->flc) + desc_bytes(desc),
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 628c43a7efc4..70c252f167c5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -393,8 +393,6 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
-	print_hex_dump_debug("key_in@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("jobdesc@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -407,10 +405,6 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		/* in progress */
 		wait_for_completion(&result.completion);
 		ret = result.err;
-
-		print_hex_dump_debug("digested key@"__stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key,
-				     digestsize, 1);
 	}
 	dma_unmap_single(jrdev, key_dma, *keylen, DMA_BIDIRECTIONAL);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AE73B4E81
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773912608; cv=none; b=QUctmTkReUWbnLU09AGCr4Kdxg5cIOVN32pwpdEjQeYvSA9sg5q781TEj9nWKo0QazAitzUFt7qqInx2SoIAlbJa2SXYhtxp7K3WnYZafTBoZyAchenoM5LJt+cnasFQVvSK9+wQzyadXwebEc0wKvqT4YQaKOvCkIb7XT/OFUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773912608; c=relaxed/simple;
	bh=5Tn2GSJy9+z5AN9rUCr5S9E+wQKe4/XNxtQvB/al9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p32mfw8h3z7JgeBHDFUUqQAH1VbzDpHY2ERSdjX72RDLRgHV5pYreg9CKHjTH9eobAZaotT308KVzSoHiC6LsPfPWP7MB3+WDmE2h2xKcSyD7b8lLLlFQpYJ4s3FG5JJlXYcMjegoo6FGJt5hTfp7gcBKVD4m+7P135PYV0PnRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KNiqUR7f; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KNiqUR7f"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773912605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a4m5UwRuqyM/t4XvLlwc+wdoOn18dTnoMotq/73CZ3Q=;
	b=KNiqUR7fBuStfgzVa6UzT9qSiV/Zino8T5kUP8DTYuVqQN9baqfB8IZ+7GfnVwIPGOqmCl
	9kc6GxvydTSeJQn30WDzw7U1GHW0mHs04absHIRN2WgkScc8SVlfJDkbcVQyf7vUtSzJb9
	maP2Vmm+yaC9xPSFChP1KBdu2T/busU=
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
Subject: [PATCH v3 2/2] crypto: caam - guard HMAC key hex dumps in hash_digest_key
Date: Thu, 19 Mar 2026 10:29:33 +0100
Message-ID: <20260319092932.208939-4-thorsten.blum@linux.dev>
In-Reply-To: <20260319092932.208939-3-thorsten.blum@linux.dev>
References: <20260319092932.208939-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3285; i=thorsten.blum@linux.dev; h=from:subject; bh=5Tn2GSJy9+z5AN9rUCr5S9E+wQKe4/XNxtQvB/al9GE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJm7D/65tezRtGMbJBj+e+2fuGTnRHONyoj/LJPWPIi51 j3146Oc9x2lLAxiXAyyYoosD2b9mOFbWlO5ySRiJ8wcViaQIQxcnAIwkbwURob/G8LOhQp5dD8/ IfD2toSDz6/jjD/UHE6yycetkLlxon0qwz+1BfGrkw0D+t/GzJeYf0YhIfdaMNempvtTV5pk+74 7s4wHAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use print_hex_dump_devel() for dumping sensitive HMAC key bytes in
hash_digest_key() to avoid leaking secrets at runtime when
CONFIG_DYNAMIC_DEBUG is enabled.

Fixes: 045e36780f11 ("crypto: caam - ahash hmac support")
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
This patch now depends on patch 1 in the series.

Changes in v3:
- Convert single CAAM patch into a 2-patch series
- Use print_hex_dump_devel() helper from patch 1/2 to keep call sites
  compiled (Herbert)
- Link to v2: https://lore.kernel.org/lkml/20260318194649.137257-3-thorsten.blum@linux.dev/

Changes in v2:
- Debug-guard key hex dumps instead of removing them entirely (Herbert)
- Use print_hex_dump() instead of print_hex_dump_debug() since the dumps
  are already guarded by DEBUG
- Link to v1: https://lore.kernel.org/lkml/20260306111204.302544-1-thorsten.blum@linux.dev/
---
 drivers/crypto/caam/caamalg_qi2.c | 4 ++--
 drivers/crypto/caam/caamhash.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 167372936ca7..ec40d8ada4a9 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3269,7 +3269,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
-	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key_in@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
@@ -3289,7 +3289,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		/* in progress */
 		wait_for_completion(&result.completion);
 		ret = result.err;
-		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
+		print_hex_dump_devel("digested key@" __stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 628c43a7efc4..b8e6cc382d93 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -393,7 +393,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
-	print_hex_dump_debug("key_in@"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key_in@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("jobdesc@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
@@ -408,7 +408,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 		wait_for_completion(&result.completion);
 		ret = result.err;
 
-		print_hex_dump_debug("digested key@"__stringify(__LINE__)": ",
+		print_hex_dump_devel("digested key@"__stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}

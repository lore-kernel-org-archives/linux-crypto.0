Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67CE2F1FEF
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862294; cv=none; b=U62MBirfp9UazOgU0lX57QTfN826gWa57vwHiglxVJxKClajpyJTR+32PB5B71Mxdn4WeLg1EJfnvSY/zTJVDRQw7JJJwkYP2q1IA0pVjvhLbcm8vPU/qtR0Uh5aYVgcqAFMBk+EitnCXLPC8OcjLaDyULhyFW2b9I+6d+WgCHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862294; c=relaxed/simple;
	bh=mQnuDEKWShZxHCAe3ZafiMoJtQlBKAfcOErwkIASlsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jBArTqZAfwIHVv4jtRl6cNi5/+jWG3pYyrV4OnAzd8u4AOEx4+0Bv2relQm7jQbXbQnnc6/rR3FUfeCNR0lV5t/Ryae6SZlR9SJGt+tuPXAEBCKuWS0rS4DKrcZhzKWnUgy1W++I1aPPB4qNGdrG2zcaNurWQ9qtxSvOfa38qtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IUmEVtwM; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IUmEVtwM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771862288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HDCuQsJdgvN7tW2QCN8u4ujpqzhZbbHYre6HGExVag8=;
	b=IUmEVtwMzz2jn1gShMhiue1sI5aqaPZARoKVbocXcNWm9PGW2fbcBH2zG3U311p4gWNeXl
	VEYDt33spMT6wOMZPmgeFDLdm2ksBpnAS2ajY5hOPzMu2hWfK2dt95pOk0PGMTkRiqo3TK
	rfkv0Bgl8Oxchc+cAh0PrYXxJke4XxY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - Replace snprintf("%s") with strscpy
Date: Mon, 23 Feb 2026 16:57:55 +0100
Message-ID: <20260223155756.340931-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace snprintf("%s", ...) with the faster and more direct strscpy().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/aead.c     | 6 +++---
 drivers/crypto/qce/sha.c      | 6 +++---
 drivers/crypto/qce/skcipher.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 97b56e92ea33..1647d2329982 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -5,6 +5,7 @@
  */
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/string.h>
 #include <crypto/gcm.h>
 #include <crypto/authenc.h>
 #include <crypto/internal/aead.h>
@@ -768,9 +769,8 @@ static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_devi
 
 	alg = &tmpl->alg.aead;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->drv_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->drv_name);
 
 	alg->base.cra_blocksize		= def->blocksize;
 	alg->chunksize			= def->chunksize;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 71b748183cfa..87071f315088 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -6,6 +6,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/string.h>
 #include <crypto/internal/hash.h>
 
 #include "common.h"
@@ -489,9 +490,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base->cra_module = THIS_MODULE;
 	base->cra_init = qce_ahash_cra_init;
 
-	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->drv_name);
+	strscpy(base->cra_name, def->name);
+	strscpy(base->cra_driver_name, def->drv_name);
 
 	INIT_LIST_HEAD(&tmpl->entry);
 	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_AHASH;
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index ffb334eb5b34..b9a931037fdc 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -7,6 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <crypto/aes.h>
@@ -446,9 +447,8 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 
 	alg = &tmpl->alg.skcipher;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->drv_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->drv_name);
 
 	alg->base.cra_blocksize		= def->blocksize;
 	alg->chunksize			= def->chunksize;
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


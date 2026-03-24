Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDB736B061
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 11:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351858; cv=none; b=o0gsaeghg3Bz+UwDfFggrWzISfyL0ZDh6vKOgQY/panrzwcA8bf3O4QUjy7yU6NFfgwFn/t5x/UMsWbA2/52yudYoGCPeR1tbZsuCulk13KUb6bQOtUxCdJ+R4+XLsVSjbApOtTdkoi9otg24p7vllbosfp3Y343k6vYe7Gw/3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351858; c=relaxed/simple;
	bh=vPxq+kwNauRf7+FdEQZdHhioB7gTXlEFVlQI/Wsnh0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jCw/ok+C0kptsHoknpdiM0vEj4zrED8QeA30FsvHvdtS6kWuhCkgfmwknCVKn+gtotxOKy7UovWDQqkGT273sptkhe8U0C8PmiZY3PSJ8N79NgkqOCx9dA8x9UDQR47zke+L7DBMan92eiplZ8ijjQoOTYT8TZJvvqOS1FKLR90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NGuPAsZ8; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NGuPAsZ8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2u86yZ54gLY4J+6y84IxVHrLSMcs4f0aO1EZba6QgA=;
	b=NGuPAsZ8HwMWbYKqqBI4EauNFXT8wcTueodPAU9dgd/8o+RPUR1xadER5XbVtGS3lmf8bF
	RzKXDQV4axAD92BGokTCi7JIMTYidMrFhroAAPO92MEM0V9EMFFUBZQcHY1ez+JFPswMpW
	3RO4NZlB/aCTo0vsOiQLpcwYWPWpLuk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - Replace snprintf("%s") with strscpy
Date: Tue, 24 Mar 2026 12:30:07 +0100
Message-ID: <20260324113006.95171-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5620; i=thorsten.blum@linux.dev; h=from:subject; bh=vPxq+kwNauRf7+FdEQZdHhioB7gTXlEFVlQI/Wsnh0U=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmHSvctCb+WeVfpfcdzrYdBt2pulZ91Ddsi+VPnHZsXj 4OGu0xyRwkLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExE/AYjw91HSj3f9235kG36 QPuDzGWRMPaPM9qndx/p3iPJO2m50iSG74Gbtp6zcojedPz6B585EYZhlosq6tLeXd/B8eFkQ/8 9LgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace snprintf("%s") with the faster and more direct strscpy().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c | 6 +++---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c    | 6 +++---
 drivers/crypto/ccp/ccp-crypto-aes.c        | 5 ++---
 drivers/crypto/ccp/ccp-crypto-des3.c       | 5 ++---
 drivers/crypto/ccp/ccp-crypto-rsa.c        | 6 +++---
 drivers/crypto/ccp/ccp-crypto-sha.c        | 5 ++---
 6 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index b1dbb8cea559..f73be408c98c 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 #include <linux/crypto.h>
 #include <crypto/internal/aead.h>
 #include <crypto/algapi.h>
@@ -223,9 +224,8 @@ static int ccp_register_aes_aead(struct list_head *head,
 	/* Copy the defaults and override as necessary */
 	alg = &ccp_aead->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->driver_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->driver_name);
 	alg->base.cra_blocksize = def->blocksize;
 
 	ret = crypto_register_aead(alg);
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 93f735d6b02b..0e3f08fefed4 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 #include <crypto/aes.h>
 #include <crypto/xts.h>
 #include <crypto/internal/skcipher.h>
@@ -239,9 +240,8 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 
 	alg = &ccp_alg->alg;
 
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->drv_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->drv_name);
 	alg->base.cra_flags	= CRYPTO_ALG_ASYNC |
 				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 685d42ec7ade..a4827f273822 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -305,9 +305,8 @@ static int ccp_register_aes_alg(struct list_head *head,
 	/* Copy the defaults and override as necessary */
 	alg = &ccp_alg->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->driver_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->driver_name);
 	alg->base.cra_blocksize = def->blocksize;
 	alg->ivsize = def->ivsize;
 
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 91b1189c47de..8a2f82851c93 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -193,9 +193,8 @@ static int ccp_register_des3_alg(struct list_head *head,
 	/* Copy the defaults and override as necessary */
 	alg = &ccp_alg->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-			def->driver_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->driver_name);
 	alg->base.cra_blocksize = def->blocksize;
 	alg->ivsize = def->ivsize;
 
diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index a14f85512cf4..17179d9149b1 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/rsa.h>
@@ -257,9 +258,8 @@ static int ccp_register_rsa_alg(struct list_head *head,
 
 	alg = &ccp_alg->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->driver_name);
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->driver_name);
 	ret = crypto_register_akcipher(alg);
 	if (ret) {
 		pr_err("%s akcipher algorithm registration error (%d)\n",
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index fa3ae8e78f6f..704e9017f7f0 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -484,9 +484,8 @@ static int ccp_register_sha_alg(struct list_head *head,
 	halg->statesize = sizeof(struct ccp_sha_exp_ctx);
 
 	base = &halg->base;
-	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 def->drv_name);
+	strscpy(base->cra_name, def->name);
+	strscpy(base->cra_driver_name, def->drv_name);
 	base->cra_flags = CRYPTO_ALG_ASYNC |
 			  CRYPTO_ALG_ALLOCATES_MEMORY |
 			  CRYPTO_ALG_KERN_DRIVER_ONLY |

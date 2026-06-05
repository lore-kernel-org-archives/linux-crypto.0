Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8CE26F2AF;
	Fri,  5 Jun 2026 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701098; cv=none; b=gCty6T+OXgGfa6Zx8lRihrScn1h4Sw0r5EB3BkHclZeBQfImEt2O8NFMRmG1D7Qc0a5NatOlIkpyT9xgV55nRoKQO+R50piA4MJ/JbUnf0mcD6Qv0HASZjVofPLTB23Y9EvpuZBWvgh3SM0DTTbSVnF6iiflnwDM/FHSsWy/y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701098; c=relaxed/simple;
	bh=RxQqm3fvVTSrDNRGRcoiNlCo6Ycd+qfxYa8VMn7vKHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i00dBtkRPBY3GzGWidYbsJWvWgIMSlkKYyHQDQQmMJMzdIo843VTObaQ7dyEg0kUZ6hZtA1BGXse95T5LAv0JwTAOIrImwnwNR8AS7lklryehW8lgaLCohWviPKsS6uyhal39zy1VYP8KAJYsPWY73WCIGBrecJkBuvIoEGLyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=igjl6205; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="igjl6205"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiQUmWGPdAYUdrP8oS0gom5ekQF4xxxPwmzJ8KAc3qY=;
	b=igjl6205cLxkNx6Yhi41l0TkTwhZ5B7uTdaZPAGkJbsoT5FvQZKJpBuYBlUiROxIzaBuQm
	VVm5G15Fu6yMGuWm2scXJUFRqO6IWwmy/0ilWRe6JFXy8uHCmjEMi8uPZ9uc4Mze9VZzJg
	RD4Stkf+t/0LMkLa2rk2gVwRwTjp9bM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 1/6] crypto: use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:10:58 +0200
Message-ID: <20260605231056.1622060-9-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4015; i=thorsten.blum@linux.dev; h=from:subject; bh=RxQqm3fvVTSrDNRGRcoiNlCo6Ycd+qfxYa8VMn7vKHw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q371Ca4mah9yj9tqX9y4YdZKSftHRucD531v3Vqy 4mcVf57OkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAihz8zMjR+/tRV9S/4s2f1 Rh831fTm3a3itdvmxUzVtLwcNSs6q4aRYeqWiPtLeMrs+3aFui6Z03Hl06O/IZxW0W8XW08S5tW axAMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/api.c         | 2 +-
 crypto/crypto_user.c | 9 ++++-----
 crypto/hctr2.c       | 3 +--
 crypto/lrw.c         | 2 +-
 crypto/lskcipher.c   | 3 +--
 crypto/xts.c         | 3 ++-
 6 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 74e17d5049c9..040b7a965c2f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -116,7 +116,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
 
-	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
+	strscpy(larval->alg.cra_name, name);
 	init_completion(&larval->completion);
 
 	return larval;
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e8b6ae75f31f..d3ccb507153b 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -11,6 +11,7 @@
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -87,11 +88,9 @@ static int crypto_report_one(struct crypto_alg *alg,
 {
 	memset(ualg, 0, sizeof(*ualg));
 
-	strscpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
-	strscpy(ualg->cru_driver_name, alg->cra_driver_name,
-		sizeof(ualg->cru_driver_name));
-	strscpy(ualg->cru_module_name, module_name(alg->cra_module),
-		sizeof(ualg->cru_module_name));
+	strscpy(ualg->cru_name, alg->cra_name);
+	strscpy(ualg->cru_driver_name, alg->cra_driver_name);
+	strscpy(ualg->cru_module_name, module_name(alg->cra_module));
 
 	ualg->cru_type = 0;
 	ualg->cru_mask = 0;
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index ad5edf9366ac..cfc2343bcc1c 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -354,8 +354,7 @@ static int hctr2_create_common(struct crypto_template *tmpl, struct rtattr **tb,
 	err = -EINVAL;
 	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
 		goto err_free_inst;
-	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5,
-		      sizeof(blockcipher_name));
+	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5);
 	if (len < 1)
 		goto err_free_inst;
 	if (blockcipher_name[len - 1] != ')')
diff --git a/crypto/lrw.c b/crypto/lrw.c
index aa31ab03a597..e306e85d7ced 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -359,7 +359,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		len = strscpy(ecb_name, cipher_name + 4);
 		if (len < 2)
 			goto err_free_inst;
 
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index e4328df6e26c..d7ec215e2b3a 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -528,8 +528,7 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 		int len;
 
 		err = -EINVAL;
-		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4],
-			      sizeof(ecb_name));
+		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4]);
 		if (len < 2)
 			goto err_free_inst;
 
diff --git a/crypto/xts.c b/crypto/xts.c
index ad97c8091582..1dc948745444 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 #include <crypto/xts.h>
 #include <crypto/b128ops.h>
@@ -400,7 +401,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(name, cipher_name + 4, sizeof(name));
+		len = strscpy(name, cipher_name + 4);
 		if (len < 2)
 			goto err_free_inst;
 

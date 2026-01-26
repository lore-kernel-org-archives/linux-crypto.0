Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F943227BA4
	for <linux-crypto@vger.kernel.org>; Mon, 26 Jan 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769449635; cv=none; b=KhoYKMXNgr8YuEIPkgpyD2J9dYL7/FRACOZCBgjTvV59jzz2Z35mMtactLVQ1Ihg6IKJGexvfAvVBY3A3woms9EfFlU+I7VwYpyjG1idKEI+Afbyt9fXwQZQqG9xy4iY/ydsuQAwge9SVNjD4Km8zC+G+tBsHDCUCcMe6zT6v0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769449635; c=relaxed/simple;
	bh=apMBtf27Kh+LirTAtt3DXglnpiCWxwR6R+3KOTVn1ow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n9k8jWbTruscNMY/056rkFVBbcrrXO2c3/HAk0gKU8WVKXAPxr3EpolBtXZUCzYq3UpjxZUekZQCAj1IjvL23jeMB6zO1NlkWLgp30w7yc7PGgJhsZpXel0qKDd7nw828q6fqBiEovk4H+2oW2zrEzqoaoYtJ65T+UzQhxlWU+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jmD2e4vQ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jmD2e4vQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769449632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MV7oBX2Ps45Ldknxm+5EalQaAccqqOFLOMB9j7YB/XU=;
	b=jmD2e4vQejkA5I1i4sNN5tDqDDvmEhkLZFy0ZQCotRQRZ7OPjzKjVqDQ6KZyuYKlLDryeD
	6v3lC9aWpsMoOuazyCU0wmuZndRKZBeuPK5lenD+NoJjhzTnLXzfINqAV/IlbuhfAveryw
	DrfVKEH1qNJWwGhktnzoU4f+4jIXapI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel - Use unregister_{aeads,ahashes,skciphers}
Date: Mon, 26 Jan 2026 18:47:03 +0100
Message-ID: <20260126174704.237141-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace multiple for loops with calls to crypto_unregister_aeads(),
crypto_unregister_ahashes(), and crypto_unregister_skciphers().

Remove the definition of atmel_tdes_unregister_algs() because it is
equivalent to calling crypto_unregister_skciphers() directly, and the
function parameter 'struct atmel_tdes_dev *' is unused anyway.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-aes.c  | 17 ++++++-----------
 drivers/crypto/atmel-sha.c  | 27 ++++++++++-----------------
 drivers/crypto/atmel-tdes.c | 25 ++++++-------------------
 3 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 3a2684208dda..bc0c40f10944 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2201,12 +2201,10 @@ static irqreturn_t atmel_aes_irq(int irq, void *dev_id)
 
 static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
-	int i;
-
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
-		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
-			crypto_unregister_aead(&aes_authenc_algs[i]);
+		crypto_unregister_aeads(aes_authenc_algs,
+					ARRAY_SIZE(aes_authenc_algs));
 #endif
 
 	if (dd->caps.has_xts)
@@ -2215,8 +2213,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 	if (dd->caps.has_gcm)
 		crypto_unregister_aead(&aes_gcm_alg);
 
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
-		crypto_unregister_skcipher(&aes_algs[i]);
+	crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 }
 
 static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
@@ -2229,7 +2226,7 @@ static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
 
 static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
 		atmel_aes_crypto_alg_init(&aes_algs[i].base);
@@ -2272,8 +2269,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
-	for (j = 0; j < i; j++)
-		crypto_unregister_aead(&aes_authenc_algs[j]);
+	crypto_unregister_aeads(aes_authenc_algs, i);
 	crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
@@ -2281,8 +2277,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&aes_algs[j]);
+	crypto_unregister_skciphers(aes_algs, i);
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 3d7573c7bd1c..b02a71061708 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2418,27 +2418,23 @@ EXPORT_SYMBOL_GPL(atmel_sha_authenc_abort);
 
 static void atmel_sha_unregister_algs(struct atmel_sha_dev *dd)
 {
-	int i;
-
 	if (dd->caps.has_hmac)
-		for (i = 0; i < ARRAY_SIZE(sha_hmac_algs); i++)
-			crypto_unregister_ahash(&sha_hmac_algs[i]);
+		crypto_unregister_ahashes(sha_hmac_algs,
+					  ARRAY_SIZE(sha_hmac_algs));
 
-	for (i = 0; i < ARRAY_SIZE(sha_1_256_algs); i++)
-		crypto_unregister_ahash(&sha_1_256_algs[i]);
+	crypto_unregister_ahashes(sha_1_256_algs, ARRAY_SIZE(sha_1_256_algs));
 
 	if (dd->caps.has_sha224)
 		crypto_unregister_ahash(&sha_224_alg);
 
-	if (dd->caps.has_sha_384_512) {
-		for (i = 0; i < ARRAY_SIZE(sha_384_512_algs); i++)
-			crypto_unregister_ahash(&sha_384_512_algs[i]);
-	}
+	if (dd->caps.has_sha_384_512)
+		crypto_unregister_ahashes(sha_384_512_algs,
+					  ARRAY_SIZE(sha_384_512_algs));
 }
 
 static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(sha_1_256_algs); i++) {
 		atmel_sha_alg_init(&sha_1_256_algs[i]);
@@ -2480,18 +2476,15 @@ static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 
 	/*i = ARRAY_SIZE(sha_hmac_algs);*/
 err_sha_hmac_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_hmac_algs[j]);
+	crypto_unregister_ahashes(sha_hmac_algs, i);
 	i = ARRAY_SIZE(sha_384_512_algs);
 err_sha_384_512_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_384_512_algs[j]);
+	crypto_unregister_ahashes(sha_384_512_algs, i);
 	crypto_unregister_ahash(&sha_224_alg);
 err_sha_224_algs:
 	i = ARRAY_SIZE(sha_1_256_algs);
 err_sha_1_256_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_ahash(&sha_1_256_algs[j]);
+	crypto_unregister_ahashes(sha_1_256_algs, i);
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 3b2a92029b16..278c0df3c92f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -897,38 +897,25 @@ static irqreturn_t atmel_tdes_irq(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static void atmel_tdes_unregister_algs(struct atmel_tdes_dev *dd)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tdes_algs); i++)
-		crypto_unregister_skcipher(&tdes_algs[i]);
-}
-
 static int atmel_tdes_register_algs(struct atmel_tdes_dev *dd)
 {
-	int err, i, j;
+	int err, i;
 
 	for (i = 0; i < ARRAY_SIZE(tdes_algs); i++) {
 		atmel_tdes_skcipher_alg_init(&tdes_algs[i]);
 
 		err = crypto_register_skcipher(&tdes_algs[i]);
-		if (err)
-			goto err_tdes_algs;
+		if (err) {
+			crypto_unregister_skciphers(tdes_algs, i);
+			return err;
+		}
 	}
 
 	return 0;
-
-err_tdes_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&tdes_algs[j]);
-
-	return err;
 }
 
 static void atmel_tdes_get_cap(struct atmel_tdes_dev *dd)
 {
-
 	dd->caps.has_dma = 0;
 
 	/* keep only major version number */
@@ -1061,7 +1048,7 @@ static void atmel_tdes_remove(struct platform_device *pdev)
 	list_del(&tdes_dd->list);
 	spin_unlock(&atmel_tdes.lock);
 
-	atmel_tdes_unregister_algs(tdes_dd);
+	crypto_unregister_skciphers(tdes_algs, ARRAY_SIZE(tdes_algs));
 
 	tasklet_kill(&tdes_dd->done_task);
 	tasklet_kill(&tdes_dd->queue_task);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5931926F2BE
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310447; cv=none; b=Ee6pXhRXMwqLUNv7F10mipP4Iyt/uShb2Mf06tF7jZ+jW9plEd7vRcBK8w3KZrlwTLbrgkJ6QGNorI8ESnRgFAOTjdTS9mm8TKebJjjiPNEXSZswadY6sRdFpP1XHJZIQsh4VMjP5dm9mxvh7IZQMayoqrBIQFbMsRJxxm4LQqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310447; c=relaxed/simple;
	bh=kiYcnAb7eSltsnM8pt9yJnlYK6HhDuQkiSnoU4quvq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOBGU1qC2LRmaPvI/AKY38HP+rOtpixfjaGi5dmnf3ueA8Hyy5pcuTJ984W6+LlzxgHrP+ZlWy3el2xETVF36nvEhOyUfe2E54O0dHFm85UrwUhUSUZPhxiGPux9h/ZcBMEM4ligEjlj6fyFJcIJ85ECBOs7BGc1V/AsYnsi4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UQ1B1xAk; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UQ1B1xAk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777310441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+Kw/9Bw/B4rALoC498psLar42CORiFfu05i0v04MscA=;
	b=UQ1B1xAkYHS7TXQrOpXW/DS6hRjJvPhHYuNlTepooGk+YjVXNBiqWOpK5GCVGG57bcFE+C
	NuRmOgTFDQh6zpe2c5itqVXbk16kc7Pg3XZplGG+S3HOniJvUGsphQRodyjIyPNGg58Qny
	SiOJd0kvCZI6dUYOEujg6B88ThxisM8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: omap - add omap_aes_unregister_algs helper
Date: Mon, 27 Apr 2026 19:20:18 +0200
Message-ID: <20260427172018.416707-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3040; i=thorsten.blum@linux.dev; h=from:subject; bh=kiYcnAb7eSltsnM8pt9yJnlYK6HhDuQkiSnoU4quvq0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvZ12K2p7C8Ti1bqtni+3sqZqPbib/DWV/IZB1hu2KV tkat30GHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRQ0KMDIsWvGlek8umv+lR 17nKqyen+W4Wz5zEJV4t8cuqNDbqVBAjw/oS+bqkkJCjnjbZ5uuPNklWJc4uZJfdZPbzgtr0ZYd T2QA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper omap_aes_unregister_algs() and replace two for loops in
omap_aes_probe() and omap_aes_remove(), which also ensure ->registered
is reset to 0.

Replace two additional for loops with crypto_engine_unregister_aeads()
while at it and reset ->registered to 0 explicitly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-aes.c | 43 ++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 3eadaf7a64fa..f31555c0d715 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1089,6 +1089,20 @@ static struct attribute *omap_aes_attrs[] = {
 };
 ATTRIBUTE_GROUPS(omap_aes);
 
+static void omap_aes_unregister_algs(const struct omap_aes_pdata *pdata)
+{
+	struct omap_aes_algs_info *alg_info;
+	int i;
+
+	for (i = pdata->algs_info_size - 1; i >= 0; i--) {
+		alg_info = &pdata->algs_info[i];
+
+		crypto_engine_unregister_skciphers(alg_info->algs_list,
+						   alg_info->registered);
+		alg_info->registered = 0;
+	}
+}
+
 static int omap_aes_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1215,15 +1229,11 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 	return 0;
 err_aead_algs:
-	for (i = dd->pdata->aead_algs_info->registered - 1; i >= 0; i--) {
-		aalg = &dd->pdata->aead_algs_info->algs_list[i];
-		crypto_engine_unregister_aead(aalg);
-	}
+	crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
+				       dd->pdata->aead_algs_info->registered);
+	dd->pdata->aead_algs_info->registered = 0;
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_aes_unregister_algs(dd->pdata);
 
 err_engine:
 	if (dd->engine)
@@ -1244,25 +1254,16 @@ static int omap_aes_probe(struct platform_device *pdev)
 static void omap_aes_remove(struct platform_device *pdev)
 {
 	struct omap_aes_dev *dd = platform_get_drvdata(pdev);
-	struct aead_engine_alg *aalg;
-	int i, j;
 
 	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&list_lock);
 
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--) {
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
-			dd->pdata->algs_info[i].registered--;
-		}
+	omap_aes_unregister_algs(dd->pdata);
 
-	for (i = dd->pdata->aead_algs_info->registered - 1; i >= 0; i--) {
-		aalg = &dd->pdata->aead_algs_info->algs_list[i];
-		crypto_engine_unregister_aead(aalg);
-		dd->pdata->aead_algs_info->registered--;
-	}
+	crypto_engine_unregister_aeads(dd->pdata->aead_algs_info->algs_list,
+				       dd->pdata->aead_algs_info->registered);
+	dd->pdata->aead_algs_info->registered = 0;
 
 	crypto_engine_exit(dd->engine);
 

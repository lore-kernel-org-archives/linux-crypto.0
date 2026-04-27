Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E283DCD84
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310446; cv=none; b=k4YSmshaQYKUT4npOdBgnkTgwNMwnTidvSvzWoI8aFIsSGKP3G56+kagE7sC22HrWy9fGHQizFh6wVvYkEqD9qHdWVBVIe0Z86B7aIqLym+CWtZ751/CLWVWU2T0f3TXOcbq+ZiRD3YmF2AY5MJwWN38qw0I0wA9fWpSYh2t4wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310446; c=relaxed/simple;
	bh=3xDUnocLIAIGKNms7t7GLlfn+0JKHNX3bctn6rowp1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kk0cYwNhWnRBsfGAcKHjOt6h9xo/SbPrM/TyfFvVghf8j8ZjynxAHBL0MhUgQohb2S5PoeD00wGBj/jlbsLXdJgCC98WLykzmRJqDAWoIOjayvafLycH88je+BvokbPxVa6yhoc2CZ7JE692YT4c9wpukGKlMasfHYiKaVBe/lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=etEhaVYK; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="etEhaVYK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777310443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aq/7s2IHv/9b/Uw/YEvItYMFIy4ZXJ6dZqzgRz4Q/Xo=;
	b=etEhaVYK+QIwZ9PXzyBb1qtVCxGY6JzpKqIEYPE8KPvYykkR4tAGZxXzU/9DKjxGmC6Jjm
	qeH3s6FG2JApcBKiprLnftVMT1YJ3vxgTkwrvMcflIX2nvW2FntyligZe86KUe7vjXMC7Y
	JDCZrwQ5tBMfn018icn29du9DBMqy/g=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] crypto: omap - add omap_sham_unregister_algs helper
Date: Mon, 27 Apr 2026 19:20:20 +0200
Message-ID: <20260427172018.416707-6-thorsten.blum@linux.dev>
In-Reply-To: <20260427172018.416707-4-thorsten.blum@linux.dev>
References: <20260427172018.416707-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2244; i=thorsten.blum@linux.dev; h=from:subject; bh=3xDUnocLIAIGKNms7t7GLlfn+0JKHNX3bctn6rowp1g=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvZ90IOHYh4P/Hol9XtU8rnZkcqtQgEub5N+5h8U8li T+/HRYEdJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEfrky/A/d90Az6seWzjPv zGfLKZz+3PBcxv0j7wEX7XevT7A/fTeT4X9IOkfol9+m+ptydiQ3OLwPFb65/dDkAweLPyR6xQV u0eYBAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper omap_sham_unregister_algs() and replace two for loops
in omap_sham_probe() and omap_sham_remove(), which also ensure
->registered is reset to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-sham.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b8c416c5ee70..be1ac640ee59 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2042,6 +2042,20 @@ static struct attribute *omap_sham_attrs[] = {
 };
 ATTRIBUTE_GROUPS(omap_sham);
 
+static void omap_sham_unregister_algs(const struct omap_sham_pdata *pdata)
+{
+	struct omap_sham_algs_info *alg_info;
+	int i;
+
+	for (i = pdata->algs_info_size - 1; i >= 0; i--) {
+		alg_info = &pdata->algs_info[i];
+
+		crypto_engine_unregister_ahashes(alg_info->algs_list,
+						 alg_info->registered);
+		alg_info->registered = 0;
+	}
+}
+
 static int omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
@@ -2158,10 +2172,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_sham_unregister_algs(dd->pdata);
 err_engine_start:
 	crypto_engine_exit(dd->engine);
 err_engine:
@@ -2182,19 +2193,13 @@ static int omap_sham_probe(struct platform_device *pdev)
 static void omap_sham_remove(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
-	int i, j;
 
 	dd = platform_get_drvdata(pdev);
 
 	spin_lock_bh(&sham.lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--) {
-			crypto_engine_unregister_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
-			dd->pdata->algs_info[i].registered--;
-		}
+	omap_sham_unregister_algs(dd->pdata);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);

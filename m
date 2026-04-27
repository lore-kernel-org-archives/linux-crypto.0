Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3D83DA7E5
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310446; cv=none; b=KLWdVylG6PKt0FmlrgC5R+gmkzqnkH5G1jcp2trEGJEI6E0xprVJBbYa7dvFN8dRK/vY4CO/HebyLrpgcY3XoBxw6xOmAOZXpI+Ri8Qz+Ygk3HDkGfrP133Ho2NuZ8BlDdnRio4RwGB87PY84TxzCRCn2biSLDltoxos9tuNmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310446; c=relaxed/simple;
	bh=kscnIBItxFrhRJkr9ELi0HNdWFXJVmhILb8M4cpv89E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8PB4NLCAUAdBIaSiOyoYxuxESfcxZEXbD2WW7di+Y3PUwN4bZCIzkj6hy7Y7tdomTNqBMxx/rLsH9Vn5tH1I69k2p4YZtKiW8cJncf4zcxoLsqEViCa7eqPGTbHSlYATzG/6IEi5A1AF6dCYBEx7qscPgMJT2FP95BsEXS1CEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D58p6ACx; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D58p6ACx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777310442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ibugJZHLqlxbw8x51Hi5jczaNCpaoiSlQlbi40a6rWo=;
	b=D58p6ACxjjo5E+66wQcEuMxgeC5ZVLNaw9p+DU3TiqN4mBM4TQJds/vEeTDoHJIT5k1fSI
	6ElwVXEqX/E8hL5y6OMg0lzgK094lGAigjkiUrrJNt5zNLteF7fxr6728xCT28Xlkf44VX
	VM9jbf3favuNz/f7eyD88OdF/Fye+Ug=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: omap - add omap_des_unregister_algs helper
Date: Mon, 27 Apr 2026 19:20:19 +0200
Message-ID: <20260427172018.416707-5-thorsten.blum@linux.dev>
In-Reply-To: <20260427172018.416707-4-thorsten.blum@linux.dev>
References: <20260427172018.416707-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2122; i=thorsten.blum@linux.dev; h=from:subject; bh=kscnIBItxFrhRJkr9ELi0HNdWFXJVmhILb8M4cpv89E=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvZ93YbKF2x7d4qtTB7JZjJ47FiCpvPJN9z5X5tYRVk fncWyxNHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCR3keMDI+M3kkq370wofBg WteJjwF2kQrOTmsjXqvvLiwTFjtYOpXhf/ARC8to/jl5GubsPItvPpoQ33ig2/iLYUuPnpD2yW1 SXAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper omap_des_unregister_algs() and replace two for loops in
omap_des_probe() and omap_des_remove(), which also ensure ->registered
is reset to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-des.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 149ebd77710b..16d5c617d5ee 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -938,6 +938,20 @@ static int omap_des_get_pdev(struct omap_des_dev *dd,
 	return 0;
 }
 
+static void omap_des_unregister_algs(const struct omap_des_pdata *pdata)
+{
+	struct omap_des_algs_info *alg_info;
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
 static int omap_des_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1043,11 +1057,7 @@ static int omap_des_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
-
+	omap_des_unregister_algs(dd->pdata);
 err_engine:
 	if (dd->engine)
 		crypto_engine_exit(dd->engine);
@@ -1067,16 +1077,12 @@ static int omap_des_probe(struct platform_device *pdev)
 static void omap_des_remove(struct platform_device *pdev)
 {
 	struct omap_des_dev *dd = platform_get_drvdata(pdev);
-	int i, j;
 
 	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&list_lock);
 
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_des_unregister_algs(dd->pdata);
 
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);

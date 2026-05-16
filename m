Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8931F993
	for <linux-crypto@vger.kernel.org>; Sat, 16 May 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956007; cv=none; b=H7qWA5WhpR6bZzQEX6gnWxvnN/L5J8i/3ywsBMXuad0EJQ7PchZ0KOnxmQNUz4y2ldpbvYnrbDRKGyfmgX0sNPHazt4VMNBiX2wjWYwlxAeuGmRcuijy6MRvkh1w4kC9ODbQqISecyquFa6tZDcWo4yiVoCb1szFxMD/AxVHuKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956007; c=relaxed/simple;
	bh=5NRjr8zzHkUcqAAMbm7x3LPu9+T/wt4SCXaf51TXES0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lt05KNkRgPpRqq6HNFGpwy/5MDk6h0Sdcl9/LXFG7W9Ft5YEd5aibYohWmAt3AD2EsBWarLaEZ2gccP3/noQqIHQZzjakBolfwwfWrkEem9cF9nrzGHfyzg3SO4QVyTSdHQnFIJLDYfhc+6bEBgnLq+D1hUHIwOckOr0+CZWs3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u7zLm/Sv; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u7zLm/Sv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778956002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XPNmsPEY/N3T861BKhzCvLefPxnkkzhoF4rkecCN/kc=;
	b=u7zLm/SvcUJhO8FwJdzSEdx7tQP9dmfrqyvieZTwi1uHBHCdPJFVKAKP1qWAfYBFXmaRzW
	BhnXslUGf+1trAb5F7ERw/lx79jB8CR/m2yR1Q+82lfvrzlcUUIrJAS7fbNqNWLD4ju97V
	O8Wwqb039zoRcExDr/8YB2Tm9rl8BMw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] crypto: drivers - remove of_match_ptr from OF match tables
Date: Sat, 16 May 2026 20:23:36 +0200
Message-ID: <20260516182337.874311-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1579; i=thorsten.blum@linux.dev; h=from:subject; bh=5NRjr8zzHkUcqAAMbm7x3LPu9+T/wt4SCXaf51TXES0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkc27Q4jQ3T2drOJcjPvbFt2eVFqUnWlx6vXTHrr1mUZ Mz36fuudJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEljMz/BVdp3zkeWOVAFfM 7moe6TsbXFMvXazsKMtIvjG3xtNy0TdGhrsH+ToYeR4Zqh5Jc0l6voFBelfsKtcjdV7hB9rOTFb ZzAYA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop of_match_ptr() because OF matching is stubbed out when CONFIG_OF=n.

Indent bcm_spu_pdriver.driver and its members while at it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Drop omap-des.c because it doesn't compile with CONFIG=n and requires
  other fixes first
- v1: https://lore.kernel.org/lkml/20260516114941.741140-2-thorsten.blum@linux.dev/
---
 drivers/crypto/bcm/cipher.c | 6 +++---
 drivers/crypto/qcom-rng.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 2bce15dc0aa8..240b40ae9cd6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4698,9 +4698,9 @@ static void bcm_spu_remove(struct platform_device *pdev)
 
 static struct platform_driver bcm_spu_pdriver = {
 	.driver = {
-		   .name = "brcm-spu-crypto",
-		   .of_match_table = of_match_ptr(bcm_spu_dt_ids),
-		   },
+		.name = "brcm-spu-crypto",
+		.of_match_table = bcm_spu_dt_ids,
+	},
 	.probe = bcm_spu_probe,
 	.remove = bcm_spu_remove,
 };
diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 0685ba122e8a..150e5802e351 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -265,7 +265,7 @@ static struct platform_driver qcom_rng_driver = {
 	.remove =  qcom_rng_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
-		.of_match_table = of_match_ptr(qcom_rng_of_match),
+		.of_match_table = qcom_rng_of_match,
 		.acpi_match_table = ACPI_PTR(qcom_rng_acpi_match),
 	}
 };

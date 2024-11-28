Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05217BA5;
	Thu, 28 Nov 2024 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732786789; cv=none; b=K86mLQ3I5lXG4Oi7RYRwJ0BPh71ru+Ytk5Rf8GttKGbAIWJZBKAiVR13EWJVGCngF+2mp7GvDRjJGwxTxrsd0QUV4exFWi9VgufY9IseWYBB8jVWs4B1Z7lfiN0Z685zk6rGGvhgfSOgj9GbFVb40bOkZDEiUb8qmV6EW2Jnblo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732786789; c=relaxed/simple;
	bh=PgpjEeBjEeiM+/Ksgnzh7tkRkMF1vTzyGLuPO/r7fcE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VhPvUb4qgQQEiGGxZCjLViXj+4jyCYdpmOP5dOxgezSuGMute192xAFyd1CVsAUsWM6O0PZl6nc5bKz5wODSaEl7ZHOgU+HIWt3x6LSspEJyahxHO8qmK7ID3pOlJ2ausDhqI2+ad6QQLc4m8Xj3L1v85so5CD64cmbZ+4bJnGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ae6f2de0ad6c11efa216b1d71e6e1362-20241128
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:f0a86c82-ea5e-4d7e-b1f1-39f5737eaa53,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:15
X-CID-INFO: VERSION:1.1.38,REQID:f0a86c82-ea5e-4d7e-b1f1-39f5737eaa53,IP:0,URL
	:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-META: VersionHash:82c5f88,CLOUDID:bd0b7696ed857b7375f7d8adb9bfec43,BulkI
	D:241128173937ZXLZ92WA,BulkQuantity:0,Recheck:0,SF:17|19|38|66|102,TC:nil,
	Content:0,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: ae6f2de0ad6c11efa216b1d71e6e1362-20241128
X-User: xiaopei01@kylinos.cn
Received: from xiaopei-pc.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 125818; Thu, 28 Nov 2024 17:39:36 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: hadar.gat@arm.com,
	olivia@selenic.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] hwrng: cctrng: Add cancel_work_sync before module remove
Date: Thu, 28 Nov 2024 17:39:31 +0800
Message-Id: <d71e0bcee781ebe12697df94083f16d651fb30c0.1732786634.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Be ensured that the work is canceled before proceeding with
the cleanup in cc_trng_pm_fini.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 drivers/char/hw_random/cctrng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 4db198849695..fd1ee3687782 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -127,6 +127,8 @@ static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
 {
 	struct device *dev = &(drvdata->pdev->dev);
 
+	cancel_work_sync(&drvdata->compwork);
+	cancel_work_sync(&drvdata->startwork);
 	pm_runtime_disable(dev);
 }
 
-- 
2.34.1


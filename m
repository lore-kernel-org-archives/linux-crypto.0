Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769BE3537C8;
	Fri, 18 Sep 2026 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734455; cv=none; b=Y2BT+F/Qdf7C7d4S/91NqOj4GScwcCWOGZWzZlO9Bylk3CTMN4WDuMAzKqAJubRyekefasJWvYijbuzWiNCK/2otBFLuxiUBAwtKOlKCSMAA480V8TwvRMWMNcCcImC3AeZjrmUcJ6hrqHxgiw8E8rVQG52QDRA2J/njS3hns00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734455; c=relaxed/simple;
	bh=cjIGCpEQupSduZjIIDxu56kjnjPr13DJidN1ey56U4I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HW+6e+9ea6y4uuoGqCVPtYGh11LhDwTeqaIz63bzjQwppONWjJYiwT/9P/pGbh+ekuktMXMRHWPjZmEBKB4Bp7dHOzHt2tRqrKUlx7kTLHACX5qWAXOdaPF1mPWAC1D1ZRQ559l42ERByXi4dNocfJjR4NklnJmsHApHDDIjZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4C1h6OAV; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4C1h6OAV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ANp+T+1gS2OpRb7OkktyO+gN2A1T3woUSp4JeFk/BKg=;
	b=4C1h6OAVck1bHR4Jy/tRdj5VnU0lrN+Dp9qmtVKvLmcG5DoEHqA6t17oGGKpbRaWP4eLYYEQZ
	kUDdolGZwvwOhs6Wjh2SlMXbIiLEMWxmqlyzft5o/vIHosVoaFiDQJcbGl+nGBycEMkTzI3kwXH
	oKBHtzPqnyRpGagxsVxx7Iw=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hmWmX3XlPzpStW;
	Fri, 18 Sep 2026 20:15:40 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id CB4E620333;
	Fri, 18 Sep 2026 20:27:29 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:29 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 7/7] crypto: hisilicon/hpre - remove unused macros and struct fields
Date: Fri, 18 Sep 2026 20:27:26 +0800
Message-ID: <20260918122726.3014899-8-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

Several macros, the hpre_asym_request::err field and the hpre::status
field are defined but never referenced. Remove them.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        | 1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 ------
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 4 ----
 3 files changed, 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index 021dbd9a1d48..f73d01f6da87 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -70,7 +70,6 @@ struct hpre_debug {
 struct hpre {
 	struct hisi_qm qm;
 	struct hpre_debug debug;
-	unsigned long status;
 };
 
 enum hpre_alg_type {
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 6ca34f3bf9ff..66a276786a7d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -21,19 +21,15 @@ struct hpre_ctx;
 #define HPRE_CRYPTO_ALG_PRI	1000
 #define HPRE_ALIGN_SZ		64
 #define HPRE_BITS_2_BYTES_SHIFT	3
-#define HPRE_RSA_512BITS_KSZ	64
-#define HPRE_RSA_1536BITS_KSZ	192
 #define HPRE_CRT_PRMS		5
 #define HPRE_CRT_Q		2
 #define HPRE_CRT_P		3
 #define HPRE_CRT_INV		4
 #define HPRE_DH_G_FLAG		0x02
 #define HPRE_TRY_SEND_TIMES	100
-#define HPRE_INVLD_REQ_ID		(-1)
 
 #define HPRE_SQE_ALG_BITS	5
 #define HPRE_SQE_DONE_SHIFT	30
-#define HPRE_DH_MAX_P_SZ	512
 
 #define HPRE_DFX_SEC_TO_US	1000000
 #define HPRE_DFX_US_TO_NS	1000
@@ -56,7 +52,6 @@ struct hpre_ctx;
 #define HPRE_DRV_RSA_MASK_CAP		BIT(0)
 #define HPRE_DRV_DH_MASK_CAP		BIT(1)
 #define HPRE_DRV_ECDH_MASK_CAP		BIT(2)
-#define HPRE_DRV_X25519_MASK_CAP	BIT(5)
 
 static DEFINE_MUTEX(hpre_algs_lock);
 static unsigned int hpre_available_devs;
@@ -135,7 +130,6 @@ struct hpre_asym_request {
 		struct kpp_request *dh;
 		struct kpp_request *ecdh;
 	} areq;
-	int err;
 	hpre_cb cb;
 	struct timespec64 req_time;
 	u32 flags;
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index e1a567383de5..03aa11a7a3b4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -16,7 +16,6 @@
 #define CAP_FILE_PERMISSION		0444
 #define HPRE_CTRL_CNT_CLR_CE_BIT	BIT(0)
 #define HPRE_CTRL_CNT_CLR_CE		0x301000
-#define HPRE_FSM_MAX_CNT		0x301008
 #define HPRE_VFG_AXQOS			0x30100c
 #define HPRE_VFG_AXCACHE		0x301010
 #define HPRE_RDCHN_INI_CFG		0x301014
@@ -41,7 +40,6 @@
 #define HPRE_HAC_INT_SET		0x301500
 #define HPRE_AXI_ERROR_MASK		GENMASK(21, 10)
 #define HPRE_RNG_TIMEOUT_NUM		0x301A34
-#define HPRE_CORE_INT_ENABLE		0
 #define HPRE_RDCHN_INI_ST		0x301a00
 #define HPRE_CLSTR_BASE			0x302000
 #define HPRE_CORE_EN_OFFSET		0x04
@@ -61,8 +59,6 @@
 #define HPRE_CORE_ENB		(HPRE_CLSTR_BASE + HPRE_CORE_EN_OFFSET)
 #define HPRE_CORE_INI_CFG	(HPRE_CLSTR_BASE + HPRE_CORE_INI_CFG_OFFSET)
 #define HPRE_CORE_INI_STATUS (HPRE_CLSTR_BASE + HPRE_CORE_INI_STATUS_OFFSET)
-#define HPRE_HAC_ECC1_CNT		0x301a04
-#define HPRE_HAC_ECC2_CNT		0x301a08
 #define HPRE_HAC_SOURCE_INT		0x301600
 #define HPRE_CLSTR_ADDR_INTRVL		0x1000
 #define HPRE_CLUSTER_INQURY		0x100
-- 
2.43.0


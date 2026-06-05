Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974053FC5C7
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701109; cv=none; b=LFTI27hPxsOA92u6snBNpm6ybZUKqPMeUloAnXojcHZWF5EU0RkwSQ2AGVVzLuOZTjV6KDAOghlY6h8NMYJuTIL+k/y1cGhC2ZoPQuKs+bGrw3090uDNmywKMP9C5Vi0StWJHuS0HdfVuULGRXTUSAQk3cPf+iLjbfVjsNRHEXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701109; c=relaxed/simple;
	bh=B2wN6f7Mdj+lhRVjdZGQJIzHIcUS/37RRedHuIeK4Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trMTWAbSABvCOeqf0Jj14Hcv8HYjmXpfIir7Ddprmz4lISUji07BPj3NlkSHQQoSu808fnnvTWzzXZZPJR95kJbL7sTYRcgbQgjWfvZVCB/Fw3j4CUhjoIHcAq/gzhC3ckKWWn5F79SUs1ewhYRVCejbodZDJWWF3G/x+vWKG+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nu2hH2Yx; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nu2hH2Yx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I1IBGOwOXbjUw10pRCLW7+h/z71njNq/3tg95Tlz4KI=;
	b=Nu2hH2YxIdUUKkSo7gmtP70IMprOlJXFUAVKmwm4Hl4NJyjUT2955TrNY5jW7fHQ7uteDP
	gJea+10nRM/TICn2jeuUEPXKvmadp0Gjc1jewiQE6/hjPQNdUjvM2yuNP//224a22DYU2C
	4iptZ8yCWC5ztdB7iaPFzXpiqQJSVC8=
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
Subject: [PATCH v2 5/6] crypto: qat - use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:11:02 +0200
Message-ID: <20260605231056.1622060-13-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5226; i=thorsten.blum@linux.dev; h=from:subject; bh=B2wN6f7Mdj+lhRVjdZGQJIzHIcUS/37RRedHuIeK4Nc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q0Hmh7Jfk7b8fO70mSZW29Ov+Zov2mj5p7qW1mad uZr+8X4jlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZhI3xpGhhuPlA8/kW6637ee 22rZ+rrQ3Jyj1YHHZp3c9bjz3q6KJRqMDBdkJ77wentpufWqTP6ewHVHWxjWzFrxd/H1+Zbt69j 7r/IBAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c             | 7 ++++---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c    | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c      | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_transport_debug.c | 3 ++-
 drivers/crypto/intel/qat/qat_common/qat_compression.c     | 3 ++-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index ea5d72d5090c..d97ee1000045 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
@@ -284,13 +285,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&key_val->list);
-	strscpy(key_val->key, key, sizeof(key_val->key));
+	strscpy(key_val->key, key);
 
 	if (type == ADF_DEC) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
-		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
+		strscpy(key_val->val, (char *)val);
 	} else if (type == ADF_HEX) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "0x%lx", (unsigned long)val);
@@ -350,7 +351,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 	if (!sec)
 		return -ENOMEM;
 
-	strscpy(sec->name, name, sizeof(sec->name));
+	strscpy(sec->name, name);
 	INIT_LIST_HEAD(&sec->param_head);
 	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 7d00bcb41ce7..11cba347d12d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -60,7 +60,7 @@ static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const cha
 	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
 		return -EINVAL;
 
-	strscpy(services, buf, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
+	strscpy(services, buf);
 	substr = services;
 
 	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
index f9017e03ec0f..32aeb795cc03 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2024 Intel Corporation */
 
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include "adf_mstate_mgr.h"
 
@@ -158,7 +159,7 @@ static struct adf_mstate_sect_h *adf_mstate_sect_add_header(struct adf_mstate_mg
 		return NULL;
 	}
 
-	strscpy(sect->id, id, sizeof(sect->id));
+	strscpy(sect->id, id);
 	sect->size = 0;
 	sect->sub_sects = 0;
 	mgr->state += sizeof(*sect);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index a8f853516a3f..fc5d88a2bb17 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
 #include "adf_transport_internal.h"
@@ -103,7 +104,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 	if (!ring_debug)
 		return -ENOMEM;
 
-	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
+	strscpy(ring_debug->ring_name, name);
 	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
 		 ring->ring_number);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 1424d7a9bcd3..8129ad0c32d8 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2022 Intel Corporation */
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_transport.h"
@@ -144,7 +145,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
 	int i;
 
 	INIT_LIST_HEAD(&accel_dev->compression_list);
-	strscpy(key, ADF_NUM_DC, sizeof(key));
+	strscpy(key, ADF_NUM_DC);
 	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 	if (ret)
 		return ret;

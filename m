Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E533E8C4C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735253; cv=none; b=VT1TBfP+BsECh4WSeWz7aMoAw3tg6CExPjX8bltG1OKvHINuObXuy1M9TNoU0TouVMxbLo2DIR03ASLKNAN2RxidSh3/xEdB4EsGE98y2gnmo5FChuhWldicUORVZCr1+12ueqwNcUYmJJSqWQ6zMsALfsE7M6hAaQPjnmzIw18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735253; c=relaxed/simple;
	bh=T2/AocFoXAiNh+TqUWOLT0AJKHpscdsM9ExRjSXZ5kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx/optwHf/bi4nW5glNRCOS8zubJIfmgdkSITuZkf0NhVAeiq+fvonVrHIUgG0xzrzwdY8ZgSQIRyGmI0FSB5Qp8+wB43W2uGF8FkKO0NGkDX5Dbnu6++oZGKTGh4DIgY/DR6NcGKL9ArBGU5mN/7lcw2OHwpLSe+TXorOTBqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WFqRKW3j; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFqRKW3j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789735252; x=1821271252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T2/AocFoXAiNh+TqUWOLT0AJKHpscdsM9ExRjSXZ5kw=;
  b=WFqRKW3jKRqZJisYYiK71uJqXYAuQ9fRFoBP1f7LRlkm5T0UDTq2ZuRd
   waRiHur7mRsTQkHjB3SD4znY/4vL21RFye43OLnF3fbZOfDlHm4ZrQH3t
   xgm5d+rtX8/W1iZZ9/HcDoNNTe+uDH+5HWIHYi0LZQ/KZd18VWU94BCiX
   M88EncciS2lYlMTCOQ4MMnQWvXqQderGsvKpui/7IQOVheFcw3XzlBrEO
   wrBu9/ze9geoKBOEq2CYdeKsIlbGoGWqLVPFZaRTXkToa2ud7wDkJ0gaN
   OImsSZFeZ5eaTzKT3nqO8jqPL/i4ICJkGQkXSuCYzeiz5C4/yYFlpZHjK
   g==;
X-CSE-ConnectionGUID: EfjzglZdREKshlGmd45chg==
X-CSE-MsgGUID: 3jvXvuLbQpWoiBGBp2l2YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11908"; a="115769178"
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="115769178"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 05:40:51 -0700
X-CSE-ConnectionGUID: gOY/VQxZRs+jU0p7odQVDw==
X-CSE-MsgGUID: SL4yzEC7SSOB5OeJt8gkzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="2810446"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa013.fm.intel.com with ESMTP; 18 Sep 2026 05:40:50 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: qat - avoid redundant config list walks when adding a key
Date: Fri, 18 Sep 2026 13:41:12 +0100
Message-ID: <20260918124112.537571-3-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260918124112.537571-1-ahsan.atta@intel.com>
References: <20260918124112.537571-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

adf_cfg_add_key_value_param() now resolves the target section under
cfg->lock, but still calls adf_cfg_key_val_get(), which re-walks the
section list to find that same section and then walks param_head to
read the current value into a temporary buffer. If the value differs it
calls adf_cfg_keyval_remove(), which walks param_head a third time to
locate the entry that was already found.

Look up the existing entry once with adf_cfg_key_value_find() and act on
that pointer directly: free the new copy if the value is unchanged, or
unlink and free the old entry before adding the new one. This drops two
redundant list walks and the on-stack temp_val copy, and removes the now
unused adf_cfg_keyval_remove() helper. No functional change.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 47 ++++++-------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index e13db9ede0fa..e2ef5284abef 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -145,24 +145,6 @@ static void adf_cfg_keyval_add(struct adf_cfg_key_val *new,
 	list_add_tail(&new->list, &sec->param_head);
 }
 
-static void adf_cfg_keyval_remove(const char *key, struct adf_cfg_section *sec)
-{
-	struct list_head *head = &sec->param_head;
-	struct list_head *list_ptr, *tmp;
-
-	list_for_each_prev_safe(list_ptr, tmp, head) {
-		struct adf_cfg_key_val *ptr =
-			list_entry(list_ptr, struct adf_cfg_key_val, list);
-
-		if (strncmp(ptr->key, key, sizeof(ptr->key)))
-			continue;
-
-		list_del(list_ptr);
-		kfree(ptr);
-		break;
-	}
-}
-
 static void adf_cfg_keyval_del_all(struct list_head *head)
 {
 	struct list_head *list_ptr, *tmp;
@@ -271,9 +253,8 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 				enum adf_cfg_val_type type)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct adf_cfg_key_val *key_val, *existing;
 	struct adf_cfg_section *section;
-	struct adf_cfg_key_val *key_val;
-	char temp_val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
 	int ret = 0;
 
 	key_val = kzalloc_obj(*key_val);
@@ -295,14 +276,6 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	}
 	key_val->type = type;
 
-	/* Add the key-value pair as below policy:
-	 * 1. if the key doesn't exist, add it;
-	 * 2. if the key already exists with a different value then update it
-	 *    to the new value (the key is deleted and the newly created
-	 *    key_val containing the new value is added to the database);
-	 * 3. if the key exists with the same value, then return without doing
-	 *    anything (the newly created key_val is freed).
-	 */
 	down_write(&cfg->lock);
 
 	section = adf_cfg_sec_find(accel_dev, section_name);
@@ -312,13 +285,23 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		goto unlock;
 	}
 
-	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
-		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
-			adf_cfg_keyval_remove(key, section);
-		} else {
+	/*
+	 * Add the key-value pair as below policy:
+	 * 1. if the key doesn't exist, add it;
+	 * 2. if the key already exists with a different value then update it
+	 *    to the new value (the key is deleted and the newly created
+	 *    key_val containing the new value is added to the database);
+	 * 3. if the key exists with the same value, then return without doing
+	 *    anything (the newly created key_val is freed).
+	 */
+	existing = adf_cfg_key_value_find(section, key);
+	if (existing) {
+		if (!strncmp(existing->val, key_val->val, sizeof(existing->val))) {
 			kfree(key_val);
 			goto unlock;
 		}
+		list_del(&existing->list);
+		kfree(existing);
 	}
 
 	adf_cfg_keyval_add(key_val, section);
-- 
2.50.1


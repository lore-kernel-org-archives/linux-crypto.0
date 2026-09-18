Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8642E3DEFE2
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735251; cv=none; b=Dq/GSK4p2A/emLjn3/grT8dkSlWxcORIfaYQnBDv1wpf0TevO9PtGnYwQ8EMHwwVktR4XjXTjYyrYkbUOI3iMvC8pNeh4QjWl/dFI1UHaRlJ1JaoLodRUEly0BxwsLFVP3tNg8XcU8TCleQkxg5ePGjh40C/7I2LAZ2uKXw07c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735251; c=relaxed/simple;
	bh=zwbhZUIuUrvowsR3gBwvAZRe0ufAYxi51TTEBrl10Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttjTiuEAX8hQSziyPbqbft9eAeTtWpAYnOIE8js61f/Xu/gRyTZCG1tTob31pZBH0tg0MizmI6RYO5rp/Bl/2ZCIlU28ZjetiRrWgvn86SRhJJuvc36m3ThxRA1SMU+6fG4EwzqgR79Ib5ic+PSqg2ko+c6RhuKhCbEy5XIPO6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F6uaPNz1; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F6uaPNz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789735250; x=1821271250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zwbhZUIuUrvowsR3gBwvAZRe0ufAYxi51TTEBrl10Aw=;
  b=F6uaPNz1/C4QjYKaKkjxmHgNqtbJAwIzSlFIaomdzvDM7ifB2K8zgSt6
   Tx5TKuJBlLNbVKNSvl/mmaIKTC850IvUdNFKQwMQtoO4xUJQbTvXZ5cgM
   rVkCPhkA/OWn9MHFSf65+GlE/22qCPnbKhbQSwUy8T09TY1dy93U6jyKS
   hjESYAGMTiyprBunpsH3ysBDibqmj99ALscphuaWb8XEubip/91Gh4wBM
   a3Pw0pqayBpXsx2+5K6ZBu9MUWQUen58DJ1b0BL0jsf6lr9U4EX+HBOUN
   6PQc7yen9MJgqDabcwqN/lOBMS4gPhHPiwUbT1URN2W23u3FdsLGG7Ymq
   Q==;
X-CSE-ConnectionGUID: VmiHsDEdQzeLb5nVFRNJlQ==
X-CSE-MsgGUID: os/xUo0tT1OhFsF1bgblnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11908"; a="115769171"
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="115769171"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 05:40:50 -0700
X-CSE-ConnectionGUID: pa/iS4bLSPKp1x9GLxMlEw==
X-CSE-MsgGUID: JfIhMxwsTPOg9sPKXC5MLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="2810426"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa013.fm.intel.com with ESMTP; 18 Sep 2026 05:40:48 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - hold cfg->lock when accessing config sections
Date: Fri, 18 Sep 2026 13:41:11 +0100
Message-ID: <20260918124112.537571-2-ahsan.atta@intel.com>
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

adf_cfg_sec_find() walks the per-device section list without holding
cfg->lock, and the returned section pointer is used later under the
lock. A concurrent section deletion under cfg->lock
(adf_cfg_del_all_except() on device down, or adf_cfg_dev_remove() on
removal) can free the section first, leading to a use-after-free.

The debugfs dev_cfg reader has the same problem: qat_dev_cfg_show()
walks both the section list and each section's param_head under the
global qat_cfg_read_lock mutex, not the per-device cfg->lock used by the
add and delete paths, so the two do not serialise. Updating an existing
key frees the old key_val under cfg->lock, so even a config write
concurrent with an open dev_cfg read can free an entry mid-walk, a wider
window than section deletion alone.

Take cfg->lock around the section lookup in adf_cfg_add_key_value_param()
and around the lookup and insert in adf_cfg_section_add(), and use
down_read()/up_read(&cfg->lock) in the debugfs start/stop callbacks.
Remove the now-unused qat_cfg_read_lock.

While here, return -ENOENT rather than -EFAULT when the section is not
found; EFAULT (bad userspace address) is not meaningful for this case.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 49 +++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index b88febf53a19..e13db9ede0fa 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
-#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/list.h>
@@ -9,13 +8,11 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
-static DEFINE_MUTEX(qat_cfg_read_lock);
-
 static void *qat_dev_cfg_start(struct seq_file *sfile, loff_t *pos)
 {
 	struct adf_cfg_device_data *dev_cfg = sfile->private;
 
-	mutex_lock(&qat_cfg_read_lock);
+	down_read(&dev_cfg->lock);
 	return seq_list_start(&dev_cfg->sec_list, *pos);
 }
 
@@ -43,7 +40,9 @@ static void *qat_dev_cfg_next(struct seq_file *sfile, void *v, loff_t *pos)
 
 static void qat_dev_cfg_stop(struct seq_file *sfile, void *v)
 {
-	mutex_unlock(&qat_cfg_read_lock);
+	struct adf_cfg_device_data *dev_cfg = sfile->private;
+
+	up_read(&dev_cfg->lock);
 }
 
 static const struct seq_operations qat_dev_cfg_sops = {
@@ -272,13 +271,10 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 				enum adf_cfg_val_type type)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct adf_cfg_section *section;
 	struct adf_cfg_key_val *key_val;
-	struct adf_cfg_section *section = adf_cfg_sec_find(accel_dev,
-							   section_name);
 	char temp_val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
-
-	if (!section)
-		return -EFAULT;
+	int ret = 0;
 
 	key_val = kzalloc_obj(*key_val);
 	if (!key_val)
@@ -308,20 +304,28 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	 *    anything (the newly created key_val is freed).
 	 */
 	down_write(&cfg->lock);
+
+	section = adf_cfg_sec_find(accel_dev, section_name);
+	if (!section) {
+		kfree(key_val);
+		ret = -ENOENT;
+		goto unlock;
+	}
+
 	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
 		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
 			adf_cfg_keyval_remove(key, section);
 		} else {
 			kfree(key_val);
-			goto out;
+			goto unlock;
 		}
 	}
 
 	adf_cfg_keyval_add(key_val, section);
 
-out:
+unlock:
 	up_write(&cfg->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
 
@@ -339,21 +343,26 @@ EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
 int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
-	struct adf_cfg_section *sec = adf_cfg_sec_find(accel_dev, name);
+	struct adf_cfg_section *sec;
+	int ret = 0;
 
-	if (sec)
-		return 0;
+	down_write(&cfg->lock);
+
+	if (adf_cfg_sec_find(accel_dev, name))
+		goto unlock;
 
 	sec = kzalloc_obj(*sec);
-	if (!sec)
-		return -ENOMEM;
+	if (!sec) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
 
 	strscpy(sec->name, name);
 	INIT_LIST_HEAD(&sec->param_head);
-	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
+unlock:
 	up_write(&cfg->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_cfg_section_add);
 
-- 
2.50.1


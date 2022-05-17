Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8350DC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 May 2022 14:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiEQOKR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 May 2022 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348429AbiEQOKQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 May 2022 10:10:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41E4D276
        for <linux-crypto@vger.kernel.org>; Tue, 17 May 2022 07:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652796615; x=1684332615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dzNyhOzNRpfvDyedA2UK1wzHqffSicL7tC6Xjbob538=;
  b=O9cfoePIr6uZrbRUTJa51xuWDuGA7WuLzFkGZxhEBRZyYhpEcflFMEBW
   +lECHSk5KfL6gNkuN/BSBTjHOPo7PCpDeUroABnNv6BL9TtW/KCVhfIor
   a6vsmUrNBLDQKodgiewZpKj9mqOmzsIYGdBdb0kjD9qWDqy1mZ9MSt+ER
   WKjDXrzi514hoy2ein0AeChnXb5WIGJDpYaYh8yByWyVcICcJpE0Hzgdk
   lxZxHaW4QsWjyPxYk2DSKuAPfDpwJwcb6Qp7orJvIUVdw58uOA0FRYWl8
   NAOt7qYyi83bNMMw8vVmN62KlhFOLAjDNAPgFTnIDRCw+FTvqCQxPfenn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="268777801"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="268777801"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 07:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="816916460"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2022 07:10:10 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 2/4] crypto: qat - change behaviour of adf_cfg_add_key_value_param()
Date:   Tue, 17 May 2022 15:10:00 +0100
Message-Id: <20220517141002.32385-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
References: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_cfg_add_key_value_param() allows to insert duplicates
entries in the key value store of the driver.

Change the behaviour of that function to the following policy:
- if the key doesn't exist, add it;
- if the key already exists with a different value, then delete it and
  replace it with a new one containing the new value;
- if the key exists with the same value, then return without doing
  anything.

The behaviour of this function has been changed in order to easily
update key-values in the driver database. In particular this is required
to update the value of the ServiceEnables key used to change the service
loaded on a device.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg.c | 41 ++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index b5b208cbe5a1..e61b3e13db3b 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -128,6 +128,24 @@ static void adf_cfg_keyval_add(struct adf_cfg_key_val *new,
 	list_add_tail(&new->list, &sec->param_head);
 }
 
+static void adf_cfg_keyval_remove(const char *key, struct adf_cfg_section *sec)
+{
+	struct list_head *head = &sec->param_head;
+	struct list_head *list_ptr, *tmp;
+
+	list_for_each_prev_safe(list_ptr, tmp, head) {
+		struct adf_cfg_key_val *ptr =
+			list_entry(list_ptr, struct adf_cfg_key_val, list);
+
+		if (strncmp(ptr->key, key, sizeof(ptr->key)))
+			continue;
+
+		list_del(list_ptr);
+		kfree(ptr);
+		break;
+	}
+}
+
 static void adf_cfg_keyval_del_all(struct list_head *head)
 {
 	struct list_head *list_ptr, *tmp;
@@ -208,7 +226,8 @@ static int adf_cfg_key_val_get(struct adf_accel_dev *accel_dev,
  * @type: Type - string, int or address
  *
  * Function adds configuration key - value entry in the appropriate section
- * in the given acceleration device
+ * in the given acceleration device. If the key exists already, the value
+ * is updated.
  * To be used by QAT device specific drivers.
  *
  * Return: 0 on success, error code otherwise.
@@ -222,6 +241,8 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	struct adf_cfg_key_val *key_val;
 	struct adf_cfg_section *section = adf_cfg_sec_find(accel_dev,
 							   section_name);
+	char temp_val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+
 	if (!section)
 		return -EFAULT;
 
@@ -246,6 +267,24 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		return -EINVAL;
 	}
 	key_val->type = type;
+
+	/* Add the key-value pair as below policy:
+	 * 1. if the key doesn't exist, add it;
+	 * 2. if the key already exists with a different value then update it
+	 *    to the new value (the key is deleted and the newly created
+	 *    key_val containing the new value is added to the database);
+	 * 3. if the key exists with the same value, then return without doing
+	 *    anything (the newly created key_val is freed).
+	 */
+	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
+		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
+			adf_cfg_keyval_remove(key, section);
+		} else {
+			kfree(key_val);
+			return 0;
+		}
+	}
+
 	down_write(&cfg->lock);
 	adf_cfg_keyval_add(key_val, section);
 	up_write(&cfg->lock);
-- 
2.36.1


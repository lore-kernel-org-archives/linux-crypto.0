Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F73C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 08:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbiF0IhM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 04:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbiF0IhF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 04:37:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED762DE
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 01:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656319024; x=1687855024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oSs5S2/2GDyWLmSEpL3fA4tMMg0E0bdRTXKfoAaotjM=;
  b=PuKbkZ22oRZfcDC4jcfwe4v4k2y+Z12pOImXi2z/dIKHdold1CfTuwUY
   XsFjd1i+2rFyP0N76zGyKxV637KJIKCfKSduC8cdnEx80UlBqDAfTVCRY
   KSzbY9wKriYPgoRX6lZsEqvsCWvzn4E/qUdxjumFULJpsin7GUTWUVQsk
   0nXn4smZ5gm/7NijNxakO40gN/YcZ7DQwtMNtQJzLMlXvr1WOQ57idX79
   hPkSsxO+3Yg7s/9rYyNmEcPOZPBsIbCjIvFelcBH2p2laSiTDXaKOenBX
   HLGHClz4gGp+muxeE2tjnIhOA++5jQ9U8QBopqsjv/j8RM0Zxm2+Dl7Sj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282488932"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282488932"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 01:37:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="657595545"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2022 01:37:02 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 2/4] crypto: qat - change behaviour of adf_cfg_add_key_value_param()
Date:   Mon, 27 Jun 2022 09:36:50 +0100
Message-Id: <20220627083652.880303-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
References: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
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
Reviewed-by: Vladis Dronov <vdronov@redhat.com>
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


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DF7C7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjFIQsn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjFIQsm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:48:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF7430C1
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329321; x=1717865321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FmfoobnzPVJrrXNzDhj5G9EzK+45k156a+H8v/mNLrs=;
  b=YoqWP4o+pdn4/uGkTky7MhyiTj9QkHwFPiwQO6Sh5GjlFWjOGF1Nk332
   QfnRpz/BhtURvFjg11ZYXcmJSnWdtTtx3gcfxfsyfzNg1YNr7r7XEmNSE
   G6stUARNgl1GlOfTQpBI5GDf8/4MlDV3FQ061b3UCUX/WQpMwHi9ng4fw
   Pt9gcaRPN02yXDH2r3BZnPePgDc0s1Fa2jFN54jXtU7XXe4481P0RRnUn
   NLbv0t8HYTL0rRkviaC79BLhGLQHZ424z6jHUmirFhdACaDvkr2/dLhI5
   OT+h+VffM2xwKMx0DM94yZfMLyrmA/DJ9vCZVDYV7aCsgNJhd1CDLNrTR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337999076"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337999076"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:48:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957214170"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957214170"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:48:23 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/4] crypto: qat - move returns to default case
Date:   Fri,  9 Jun 2023 17:38:19 +0100
Message-Id: <20230609163821.6533-2-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609163821.6533-1-adam.guerin@intel.com>
References: <20230609163821.6533-1-adam.guerin@intel.com>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make use of the default statements by changing the pattern:
	switch(condition) {
	case COND_A:
	...
		break;
	case COND_b:
	...
		break;
	}
	return ret;

in

	switch(condition) {
	case COND_A:
	...
		break;
	case COND_b:
	...
		break;
	default:
		return ret;
	}

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 20 +++++++++----------
 .../crypto/intel/qat/qat_common/qat_algs.c    |  1 -
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index d7d5850af703..c961fa6ce5aa 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -215,9 +215,9 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		return capabilities_cy;
 	case SVC_DC:
 		return capabilities_dc;
+	default:
+		return 0;
 	}
-
-	return 0;
 }
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
@@ -232,9 +232,9 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 		return thrd_to_arb_map_cy;
 	case SVC_DC:
 		return thrd_to_arb_map_dc;
+	default:
+		return NULL;
 	}
-
-	return NULL;
 }
 
 static void get_arb_info(struct arb_info *arb_info)
@@ -319,9 +319,9 @@ static char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
 		return adf_4xxx_fw_cy_config[obj_num].obj_name;
 	case SVC_DC:
 		return adf_4xxx_fw_dc_config[obj_num].obj_name;
+	default:
+		return NULL;
 	}
-
-	return NULL;
 }
 
 static char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
@@ -331,9 +331,9 @@ static char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
 		return adf_402xx_fw_cy_config[obj_num].obj_name;
 	case SVC_DC:
 		return adf_402xx_fw_dc_config[obj_num].obj_name;
+	default:
+		return NULL;
 	}
-
-	return NULL;
 }
 
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
@@ -343,9 +343,9 @@ static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 		return adf_4xxx_fw_cy_config[obj_num].ae_mask;
 	case SVC_DC:
 		return adf_4xxx_fw_dc_config[obj_num].ae_mask;
+	default:
+		return 0;
 	}
-
-	return 0;
 }
 
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 538dcbfbcd26..3c4bba4a8779 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -106,7 +106,6 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 	default:
 		return -EFAULT;
 	}
-	return -EFAULT;
 }
 
 static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
-- 
2.40.1


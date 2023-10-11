Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8590CD6E5D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjJKMgQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjJKMgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5165293
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027771; x=1728563771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OtmZx/Dy67Kq3xnvRrbwiUHD/xLIFrE8NjDPw5tHoR8=;
  b=SWJwMbaon9I/CkaVPvrNNb1sZ0QRgQZ4NGHDa0NZpctDB5ThcNP9tGwo
   aqkl/vilwFbTcyszkSKvb6RGO7SIk00UqSJhREH9ufV8kcR89NpaYfjHT
   +3r8CSF5L0IbLtfFjefmjU3fKlStnZ4/yjAlGDGW49GFx6C+MSpT8bbD8
   ECcwIZvwVJ1kta5u9+Ct1j3up11i9SHZTcnTdMVtinEaTl25ct8MImfV9
   3ZbidXBiiFN/FqGan0XqMmLtKDEWnrhGyukz2gu09BGsVtO7urxjNneJ3
   KnvbBVCk5q3eeszkmYiFTtFywfF2YwINZ+eN/RtWsnJ3D25zb+YaTvs0J
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992843"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992843"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124637"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124637"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:10 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 02/11] crypto: qat - use masks for AE groups
Date:   Wed, 11 Oct 2023 14:15:00 +0200
Message-ID: <20231011121934.45255-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The adf_fw_config structures hardcode a bit mask that represents the
acceleration engines (AEs) where a certain firmware image will have to
be loaded to. Remove the hardcoded masks and replace them with defines.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 46 ++++++++++---------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 10839269c4d3..44b732fb80bc 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -14,6 +14,10 @@
 #include "adf_cfg_services.h"
 #include "icp_qat_hw.h"
 
+#define ADF_AE_GROUP_0		GENMASK(3, 0)
+#define ADF_AE_GROUP_1		GENMASK(7, 4)
+#define ADF_AE_GROUP_2		BIT(8)
+
 enum adf_fw_objs {
 	ADF_FW_SYM_OBJ,
 	ADF_FW_ASYM_OBJ,
@@ -41,45 +45,45 @@ struct adf_fw_config {
 };
 
 static const struct adf_fw_config adf_fw_cy_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_ASYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_asym_dc_config[] = {
-	{0xF0, ADF_FW_ASYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_sym_dc_config[] = {
-	{0xF0, ADF_FW_SYM_OBJ},
-	{0xF, ADF_FW_DC_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static const struct adf_fw_config adf_fw_dcc_config[] = {
-	{0xF0, ADF_FW_DC_OBJ},
-	{0xF, ADF_FW_SYM_OBJ},
-	{0x100, ADF_FW_ADMIN_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ},
 };
 
 static_assert(ARRAY_SIZE(adf_fw_cy_config) == ARRAY_SIZE(adf_fw_dc_config));
-- 
2.41.0


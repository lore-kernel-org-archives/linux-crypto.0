Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB92C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Mar 2022 18:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiCDSEy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbiCDSEx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Mar 2022 13:04:53 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD35A344D1
        for <linux-crypto@vger.kernel.org>; Fri,  4 Mar 2022 10:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646417042; x=1677953042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KDiOeqqzLqnUJ1asjs6bG87cJ8MRdG1jOuQFe3pblsE=;
  b=dOTMpNOeoWTGDSgrSKb9I7wDHcs9dge99k/3jPNbcGoT9a4HBjJpg4cM
   Goxuj61OUo0CCOrs6/f/P3xnhluNJTJb7/ZGtl24LJQsmq7sUIjY12YrG
   tfV5XEYKSG3HKyK05z8IQRr9222p3+jEzPCjBugdjaW2W53qvJq4qRn5i
   yF27IBc8JD2n7HQtKuAW8LdoDJugeMBIFdE14uTEH0tet8PVs6IMGBwHs
   9OlrfNdbaF1V/CIRtjvzInBduRppBgamzv/CQYVd5WU5nWxjNe7hnYHVF
   tyaJtG4k2kPteXlYgYhxrV01IlYcRzsa8zRwEWucH/NZlm+KPSNZ24psu
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="314744414"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="314744414"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552308548"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2022 10:04:01 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/3] crypto: qat - fix initialization of pfvf cap_msg structures
Date:   Fri,  4 Mar 2022 18:03:55 +0000
Message-Id: <20220304180356.22469-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
References: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Initialize fully the structures cap_msg containing the device
capabilities from the host.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:

    drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c:99:44: warning: missing field 'ext_dc_caps' initializer [-Wmissing-field-initializers]
            struct capabilities_v3 cap_msg = { { 0 }, };
                                                      ^

Fixes: 851ed498dba1 ("crypto: qat - exchange device capabilities over PFVF")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index 14b222691c9c..c5b326f63e95 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -96,7 +96,7 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct capabilities_v3 cap_msg = { { 0 }, };
+	struct capabilities_v3 cap_msg = { 0 };
 	unsigned int len = sizeof(cap_msg);
 
 	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_CAPABILITIES)
-- 
2.35.1


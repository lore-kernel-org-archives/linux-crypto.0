Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A8CC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376870AbjJTKfQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376860AbjJTKfJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3D2D5B
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798107; x=1729334107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j4awoPBrvveTeSoBjclbrMvJE4yZCepGGDiCM0J0wpk=;
  b=WwVMIE6PRFIXaOBUnySBFFaE2xDC3MGorxHNO1ihe/+5GVkNrMeV0jvr
   1lAA5t1A3kPEc4Xw0q/Kmxn27hz/ufDxh/jo297699c1EtJD7EafpWNOJ
   Lvq6rssfa8FXoWFioXrw+Jq5wzsmaPdbHzHPy8ToklbGm9EsW++FmASN7
   eeRO5WEtfa8ttttBnFbXncFezwF2SnnJ0JvSw+g6uF2PiKjZvjBPYqjmC
   xp+fqmi6z6RBzHQIrGTQfmb+JbrBIsURjkILouT/8/GGp7VblGOH+ZgHS
   vTT/yRp+G93OW+S+zG94M1rv1GcwfkCWAY4xVzs4h5tH50fOpi6A09yNX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686711"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686711"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369934"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369934"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 6/9] crypto: qat - add adf_get_aram_base() helper function
Date:   Fri, 20 Oct 2023 11:32:50 +0100
Message-ID: <20231020103431.230671-7-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the function adf_get_aram_base() which allows to return the
base address of the aram bar.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 18a382508542..d9342634f9c1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -248,4 +248,14 @@ static inline void __iomem *adf_get_pmisc_base(struct adf_accel_dev *accel_dev)
 	return pmisc->virt_addr;
 }
 
+static inline void __iomem *adf_get_aram_base(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *param;
+
+	param = &GET_BARS(accel_dev)[hw_data->get_sram_bar_id(hw_data)];
+
+	return param->virt_addr;
+}
+
 #endif
-- 
2.41.0


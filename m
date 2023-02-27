Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5339FC64ED8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjB0PoU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjB0PoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:44:19 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B94E397
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512658; x=1709048658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=CCsn5p7pPrgHEJmTHtmbFGukCXpKwAcKFyc5JvrmzSM=;
  b=EEmL0nWC8mmAbCq4e+sbBeCAIMQ08ZFp6tZRDz5eS74ErVAr09I1ay3m
   zIMNkraBCan/23HxuAoPPk/dg5ZtwHc+42dqknR1zV/bHPIknNcE7Yf/K
   TcU4jgmhNX/ojhmbug8yDFld9qICAEyFjN6X8FI0aSkYBuqq57TDHZ+C8
   96EMGy9cgrgm8isp8gubZt0g28pEn9SW9GEaagmkYlHkn/hbKKs2/Z3AU
   Htc/vgoXHL1MHm71YYftNjKZX6FJ6WEMfda0G2MYuL7BN2Vw+lEOwx1K8
   dxrc8lXxdtz0ClM6dYNJon25MfDtJVfA+UEv05SdA9e+2WeqCt8d3a41U
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166183"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166183"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392253"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392253"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:15 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 1/5] crypto: qat - delay sysfs initialization
Date:   Mon, 27 Feb 2023 15:55:41 -0500
Message-Id: <20230227205545.5796-2-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_sysfs_init() is used by qat_4xxx to create sysfs
attributes. This is called by the probe function before starting a
device. With this sequence, there might be a chance that the sysfs
entries for configuration might be changed by a user while the driver
is performing a device bring-up causing unexpected behaviors.

Delay the creation of sysfs entries after adf_dev_start().

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index b3a4c7b23864..f7fdb435a70e 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -411,10 +411,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = adf_sysfs_init(accel_dev);
-	if (ret)
-		goto out_err_disable_aer;
-
 	ret = hw_data->dev_config(accel_dev);
 	if (ret)
 		goto out_err_disable_aer;
@@ -427,6 +423,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_dev_stop;
 
+	ret = adf_sysfs_init(accel_dev);
+	if (ret)
+		goto out_err_dev_stop;
+
 	return ret;
 
 out_err_dev_stop:
-- 
2.16.4


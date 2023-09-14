Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBF3EDE99F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbjINJ5V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbjINJ5T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBB783
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685435; x=1726221435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xhQyJe06EhHEWN23L8SWixFjJMPnrqGCnxgj9CSJY10=;
  b=j6fFmOBCuMqQls3mLMGiVI7TfO82IxrNhIjpObJqDRQX5fE6WF7GlZJM
   nByYCIstwCeNVKtuEnY+JGMHRgJzsgQcBoG9OYIpBfsogGbDAryUAkNPQ
   M2stXzuh3yi7loGB0v8w4kzJtsQXNG+DqO8OMUQz+1ZiVtlsLJhzTfvzL
   MuersuX1GRLL4S3IhAC0OEpQNU9MSQGBqkQA1gvj0rwdL7jA7P8CfkIuU
   q6w7AZqqR0j6TizeOCj0j4lcu3Sr3ChkZL+he/OXvrIH0/WRSsz2bR3PI
   Oou6oYDnmYVgnAd69on2O8pdov3avu4RekPwSf0M5je23py51S6eNrSTN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279162"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279162"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619739"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619739"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:14 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 3/5] crypto: qat - ignore subsequent state up commands
Date:   Thu, 14 Sep 2023 10:55:47 +0100
Message-ID: <20230914095658.27166-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the device is already in the up state, a subsequent write of `up` to
the sysfs attribute /sys/bus/pci/devices/<BDF>/qat/state brings the
device down.
Fix this behaviour by ignoring subsequent `up` commands if the device is
already in the up state.

Fixes: 1bdc85550a2b ("crypto: qat - fix concurrency issue when device state changes")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 5e14c374ebd3..8672cfa2800f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -68,7 +68,9 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		dev_info(dev, "Starting device qat_dev%d\n", accel_id);
 
 		ret = adf_dev_up(accel_dev, true);
-		if (ret < 0) {
+		if (ret == -EALREADY) {
+			break;
+		} else if (ret) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
 			adf_dev_down(accel_dev, true);
-- 
2.41.0


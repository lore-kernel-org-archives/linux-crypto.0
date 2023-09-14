Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A5AEDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbjINJ5T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbjINJ5S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A27883
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685434; x=1726221434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QnvW2qoi1BAgggLRNSKzAi2DPKtQJsFHpwR3uV8n5wA=;
  b=Ur3Hf+VDCncDca+zRhY26pN8HMGD/2T40bNKlzHH/SNxWBfTdIIF91ZE
   zNA2U01RhBEL6nDNmx5Bns8K38jFHS8qkz59s2K3zMZJXfc3NQ1BQ+1NL
   ilNPk55vhxxWcMiETOsPP4hhY1alF+P+riwdEihJMPU/v8S42tgDGEc75
   ylZ1YvMj7sZ4dvDJI4QytccNDHvDyalaVTQuT2M78kuF25m4Ef1KQ9Pav
   3/et2ztOowEJUQVPi+DSqN1NRrGKJjSKxDdVKcgx0+HFvFk6yXVpMjBOA
   M9YpCJroQnd9xXc60MiqJfn2cIwXyE+DyAJJ9PrruFfuPzjGqjvR5M+km
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279159"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279159"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619727"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619727"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:12 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 2/5] crypto: qat - do not shadow error code
Date:   Thu, 14 Sep 2023 10:55:46 +0100
Message-ID: <20230914095658.27166-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Do not shadow the return code from adf_dev_down() in the error path of
the DEV_DOWN command.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index a8f33558d7cb..5e14c374ebd3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -60,8 +60,8 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		}
 
 		ret = adf_dev_down(accel_dev, true);
-		if (ret < 0)
-			return -EINVAL;
+		if (ret)
+			return ret;
 
 		break;
 	case DEV_UP:
-- 
2.41.0

